# Claude Code Dev Workflows

Slash commands and coding conventions for Magento and Drupal projects using Claude Code. Makes Claude write better code and gives you a repeatable process for building features.

---

## What is this?

Two things:

1. **CLAUDE.md conventions** — rules that Claude follows in every conversation. Things like "never use ObjectManager directly", "re-read files before editing", "don't add code I didn't ask for". These load automatically and make Claude's output better without you doing anything extra.

2. **Slash commands** — `/discover`, `/blueprint`, `/implement`, `/review`, `/retro`. A structured workflow for building features. For any task beyond a simple bug fix, use these.

---

## Setup

### First time on a project

Open your terminal. `cd` into your Magento or Drupal project root (where `composer.json` is).

**Magento:**
```bash
bash /path/to/claude-code-workflows/magento-workflow/setup.sh
```

**Drupal:**
```bash
bash /path/to/claude-code-workflows/drupal-workflow/setup.sh
```

**What the script does:**
- Copies `.claude/commands/` into your project (the slash commands)
- Creates `.claude/planning/` (where task docs go)
- Adds our coding conventions to your `CLAUDE.md`

**After running the script:**
```bash
git add CLAUDE.md .claude/commands/
git commit -m "Add Claude Code workflow"
git push
```

Now everyone on the team gets the same conventions and commands when they pull.

### Updating (when we release changes)

Pull the latest from this repo, then re-run the same setup script. It will:
- Overwrite `.claude/commands/` with the latest versions
- Update the conventions block in your `CLAUDE.md` without touching anything else in the file

---

## What you get without doing anything extra

Once setup is done, Claude automatically follows the conventions in every conversation. You don't need to run any commands for this to work.

**What changes:**
- Claude re-reads files before editing them (prevents stale edits)
- Claude doesn't add code you didn't ask for
- Claude matches your existing codebase style instead of its own preferences
- Claude uses the right patterns for your platform (Hyva vs Luma, plugins vs preferences, DI vs static calls)
- Claude pushes back if it thinks a simpler approach exists
- When you say "yes" or "do it", Claude executes instead of repeating the plan

**Set up the PHP lint hook (do this):**

Create `.claude/settings.local.json` in your project (don't commit this file):
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "php -l $CLAUDE_FILE_PATH 2>&1 | head -5"
      }
    ]
  }
}
```

This runs PHP lint every time Claude edits a file. Syntax errors get caught immediately, not 20 minutes later when you run `di:compile` or `drush cr`.

---

## The slash commands

You type these in Claude Code. For any task beyond a quick fix, use them.

### /discover

**When to use:** Starting a new task. Especially useful on a project you haven't worked on before, or for complex tasks where you're not sure what's affected.

**What you type:**
```
/discover Add a loyalty points system that lets customers earn and redeem points
```

**What Claude does:**
1. Reads your `composer.json`, config files, and custom modules to understand the project
2. Classifies your task as **Quick** (just fix it, no workflow needed), **Standard** (use the full workflow), or **Full** (complex, be extra careful)
3. If Standard or Full: creates a discovery doc with scope, affected areas, and risks
4. Gives you an issue name like `add-loyalty-points` that you use in the other commands

**What you get:** A file at `.claude/planning/add-loyalty-points/01_DISCOVERY.md` with:
- What the task includes and doesn't include
- Which existing modules are affected
- What theme you're on (Hyva or Luma) and what that means for frontend
- Risks (e.g., "this touches checkout — be careful with totals collectors")

### /blueprint

**When to use:** After `/discover`, before you start coding. This creates a plan so Claude builds things in the right order.

**What you type:**
```
/blueprint add-loyalty-points
```

**What Claude does:**
1. Reads the discovery doc
2. Creates a phased implementation plan with exact file paths
3. Phase 1 is always the module skeleton. Last phase is always tests
4. Flags platform-specific concerns (e.g., "this needs a totals collector with sortOrder 150")

**What you get:** A file at `.claude/planning/add-loyalty-points/02_BLUEPRINT.md` with phases like:
```
Phase 1: Module skeleton (registration.php, module.xml, db_schema.xml)
Phase 2: Models and repositories
Phase 3: Frontend (Alpine.js components for Hyva)
Phase 4: Checkout integration (totals collector)
Phase 5: Tests
```

Each phase has a list of files to create and validation steps (like "run di:compile after this phase").

### /implement

**When to use:** After `/blueprint`. This is where Claude actually writes code.

**What you type:**
```
/implement add-loyalty-points
```

Or to do a specific phase:
```
/implement add-loyalty-points phase 3
```

**What Claude does:**
1. Reads the blueprint
2. Implements each phase in order
3. After each phase that adds new classes or DI config: runs `di:compile` (Magento) or `drush cr` (Drupal)
4. Reports what was created/modified

**Important:** Claude builds everything continuously — it doesn't stop between phases to ask "continue?". If you need to pause, interrupt it. It tracks progress, so next time you run `/implement` it picks up where it left off.

### /review

**When to use:** After implementation is done, before you create a PR.

**What you type:**
```
/review add-loyalty-points
```

**What Claude does:**
1. Reads the discovery doc (what was supposed to be built)
2. Reads the blueprint (how it was supposed to be built)
3. Reads the actual code that was written
4. Checks **intent first** — does the code actually do what the task asked for? Are edge cases handled?
5. Then checks platform standards — correct DI, proper plugin signatures, template escaping, etc.

**What you get:** A file at `.claude/planning/add-loyalty-points/03_REVIEW.md` with:
- Verdict: APPROVED, APPROVED WITH MINOR ISSUES, or NEEDS FIXES
- A list of issues found with severity and suggested fixes
- Checklist results for each category (standards, security, performance, etc.)

**Tip:** Attach the review output to your PR. It shows your reviewer that the code was checked.

### /retro

**When to use:** After `/review` passes. This captures what you learned.

**What you type:**
```
/retro add-loyalty-points
```

**What Claude does:**
1. Reads all the planning docs and the code changes
2. Generates 3-5 specific lessons (not generic stuff like "use DI" — specific like "checkout totals sort order in this project is 100 for catalog rules, 200 for cart rules")
3. Asks you to confirm before adding lessons to CLAUDE.md
4. If you confirm, future sessions on this project benefit from what you learned

**This is the part that compounds.** After 10 tasks, your CLAUDE.md has project-specific knowledge that makes Claude better at working on this specific codebase.

### /status

**When to use:** Start of any session, to see if you have unfinished work.

**What you type:**
```
/status
```

**What Claude shows:**
```
In Progress:
  - add-loyalty-points — Blueprint done, Implement phase 2/4 (last updated: 2026-04-16)

Completed:
  - fix-checkout-tax (completed: 2026-04-10)
```

---

## When to use what

**Quick fixes only (no workflow):**
- Bug fixes, config changes, copy updates, 1-3 file tweaks where you know exactly what to do

**Everything else — use the workflow:**
- New module or feature
- Changes touching 5+ files
- Integrations with external services
- Checkout or payment changes
- Working on a codebase you're not familiar with

**Minimum required:** `/discover` -> `/implement` -> `/review`. Always.

**Full workflow:** `/discover` -> `/blueprint` -> `/implement` -> `/review` -> `/retro`. Use for new features and complex tasks.

---

## Team rules (mandatory)

- **Run `/review` before every PR.** Attach the review output. PRs without a review will be sent back
- **One developer per task.** No two people on the same module at the same time. AI merge conflicts are worse than human ones
- **Create a PR after every task.** The workflow ends at `/retro`. Then create a PR with the 03_REVIEW.md attached
- **Don't edit inside `## Magento Conventions` / `## Drupal Conventions`.** That section gets overwritten on update. Put your own rules above or below it
- **Re-run setup.sh when this repo is updated.** Pull, re-run, commit. Takes 10 seconds

---

## FAQ

**Q: Do I have to use all the commands?**
For quick fixes, no. For anything else: `/discover` -> `/implement` -> `/review` is the minimum. Use `/blueprint` and `/retro` for new features and complex tasks.

**Q: What if I'm already mid-project?**
Run setup.sh. It appends conventions to your existing CLAUDE.md without overwriting it. Commands are immediately available.

**Q: Does this work with Claude Code in VS Code / JetBrains?**
Yes. Slash commands and CLAUDE.md work in all Claude Code environments.

**Q: What if Claude ignores the rules?**
Remind it. Say "check CLAUDE.md" or "re-read the conventions". If it keeps ignoring a specific rule, paste that rule directly in your message. For coding standards specifically, set up the PHP lint hook — that enforces rules mechanically, not by asking nicely.

**Q: Can I add my own rules to CLAUDE.md?**
Yes. Add them above or below the conventions block. Don't edit inside the `## Magento Conventions` / `## Drupal Conventions` section — that gets overwritten when you re-run setup.sh.

**Q: Where do the planning files go?**
`.claude/planning/{issue-name}/`. Add this to `.gitignore` if you don't want them in the repo. They're internal working docs.

---

## Credits

Workflow structure inspired by [vakaobr/claude-code-ai-development-workflow](https://github.com/vakaobr/claude-code-ai-development-workflow) and [ryanthedev/code-foundations](https://github.com/ryanthedev/code-foundations).
