#!/bin/bash
# Setup/Update Drupal Claude Code workflow
# Run from your Drupal project root: bash claude-code-sdlc-workflow/drupal-workflow/setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_NAME="$(basename "$REPO_DIR")"

echo "=== Drupal Claude Code Workflow Setup ==="
echo ""

# 1. Copy/overwrite commands
mkdir -p .claude
cp -r "$SCRIPT_DIR/.claude/commands" .claude/
echo "Updated .claude/commands/"

# 2. Create planning directory
mkdir -p .claude/planning
echo "Ensured .claude/planning/ exists"

# 3. Handle CLAUDE.md conventions
if [ -f "CLAUDE.md" ]; then
    if grep -q "## Drupal Conventions" CLAUDE.md 2>/dev/null; then
        python3 -c "
import re
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
            echo "Warning: Could not auto-update CLAUDE.md. Manually replace '## Drupal Conventions' section."
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

# 4. Add gitignore entries
touch .gitignore
CHANGED=false
if ! grep -q "$REPO_NAME/" .gitignore 2>/dev/null; then
    echo "$REPO_NAME/" >> .gitignore
    CHANGED=true
fi
if ! grep -q ".claude/planning/" .gitignore 2>/dev/null; then
    echo ".claude/planning/" >> .gitignore
    CHANGED=true
fi
if [ "$CHANGED" = true ]; then
    echo "Added $REPO_NAME/ and .claude/planning/ to .gitignore"
else
    echo ".gitignore already up to date"
fi

echo ""
echo "=== Done ==="
echo ""
echo "Now run:"
echo "  git add CLAUDE.md .claude/commands/ .gitignore"
echo "  git commit -m 'Add Claude Code workflow'"
echo "  git push"
echo ""
echo "Then open Claude Code and run: /discover [task description]"
