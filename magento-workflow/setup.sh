#!/bin/bash
# Setup/Update Magento Claude Code workflow
# Run from your Magento project root: bash path/to/setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Magento Claude Code Workflow Setup ==="
echo ""

# 1. Always copy/overwrite commands (these are ours, not project-specific)
mkdir -p .claude
cp -r "$SCRIPT_DIR/.claude/commands" .claude/
echo "Updated .claude/commands/"

# 2. Create planning directory if missing
mkdir -p .claude/planning
echo "Ensured .claude/planning/ exists"

# 3. Handle CLAUDE.md conventions
if [ -f "CLAUDE.md" ]; then
    if grep -q "## Magento Conventions" CLAUDE.md 2>/dev/null; then
        # Replace existing conventions block
        # Remove everything from "## Magento Conventions" to the next ## heading or EOF
        python3 -c "
import re, sys
with open('CLAUDE.md', 'r') as f:
    content = f.read()
# Match from '## Magento Conventions' to next '## ' heading (not ###) or EOF
pattern = r'## Magento Conventions.*?(?=\n## [^#]|\Z)'
with open('$SCRIPT_DIR/CLAUDE.md.sample', 'r') as f:
    new_block = f.read().strip()
content = re.sub(pattern, new_block, content, flags=re.DOTALL)
with open('CLAUDE.md', 'w') as f:
    f.write(content)
" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Updated Magento conventions in existing CLAUDE.md"
        else
            echo "Warning: Could not auto-update CLAUDE.md. Please manually replace the '## Magento Conventions' section with the latest from CLAUDE.md.sample"
        fi
    else
        echo "" >> CLAUDE.md
        cat "$SCRIPT_DIR/CLAUDE.md.sample" >> CLAUDE.md
        echo "Appended Magento conventions to existing CLAUDE.md"
    fi
else
    cp "$SCRIPT_DIR/CLAUDE.md.sample" CLAUDE.md
    echo "Created CLAUDE.md from sample"
fi

echo ""
echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  1. Commit CLAUDE.md and .claude/commands/ to your repo"
echo "  2. Open Claude Code and run: /discover [task description]"
