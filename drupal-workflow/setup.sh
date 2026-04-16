#!/bin/bash
# Setup/Update Drupal Claude Code workflow
# Run from your Drupal project root: bash path/to/setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Drupal Claude Code Workflow Setup ==="
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
    if grep -q "## Drupal Conventions" CLAUDE.md 2>/dev/null; then
        # Replace existing conventions block
        python3 -c "
import re, sys
with open('CLAUDE.md', 'r') as f:
    content = f.read()
pattern = r'## Drupal Conventions.*?(?=\n## [^#]|\Z)'
with open('$SCRIPT_DIR/CLAUDE.md.sample', 'r') as f:
    new_block = f.read().strip()
content = re.sub(pattern, new_block, content, flags=re.DOTALL)
with open('CLAUDE.md', 'w') as f:
    f.write(content)
" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Updated Drupal conventions in existing CLAUDE.md"
        else
            echo "Warning: Could not auto-update CLAUDE.md. Please manually replace the '## Drupal Conventions' section with the latest from CLAUDE.md.sample"
        fi
    else
        echo "" >> CLAUDE.md
        cat "$SCRIPT_DIR/CLAUDE.md.sample" >> CLAUDE.md
        echo "Appended Drupal conventions to existing CLAUDE.md"
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
