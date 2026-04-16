---
description: "Phase 5: Capture lessons learned and update project knowledge"
---

# Retro Phase

Input: $ARGUMENTS (issue name)

## Step 1: Load Context

Read the following files:
- `.claude/planning/{issue-name}/01_DISCOVERY.md`
- `.claude/planning/{issue-name}/02_BLUEPRINT.md`
- `.claude/planning/{issue-name}/03_REVIEW.md`
- `.claude/planning/{issue-name}/00_STATUS.md`

Also run `git diff` to see all changes made during this workflow.

## Step 2: Generate Retrospective

Focus on Magento-specific discoveries and surprises:
- Plugin ordering issues encountered (sort_order conflicts)
- Cache behavior surprises (full page cache, block cache, config cache)
- Indexer quirks (reindex requirements, indexer dependencies)
- Theme compatibility findings (Hyva vs Luma differences)
- What worked well in the approach
- What did not work or required rework
- Codebase discoveries (undocumented patterns, conventions found in existing code)
- Review findings that indicate knowledge gaps

**Rules for lessons:**
- Must be relevant to THIS specific project and codebase
- One sentence each
- Actionable and specific - not generic advice like "use plugins not preferences" but specific like "checkout totals collector sort order is 100 for catalog rules, 200 for cart rules - custom discounts should use 150"
- Maximum 5 lessons

## Step 3: Write 04_RETRO.md

Write `.claude/planning/{issue-name}/04_RETRO.md` with:

```markdown
# Retrospective: {Issue Name}

## Date
{date}

## Duration
{Estimated time from discover to completion}

## Lessons Learned
1. Lesson 1
2. Lesson 2
3. ...

## Review Issues Fixed
- Issue 1: How it was resolved
- Issue 2: How it was resolved

## Scope Accuracy

| Metric | Count |
|--------|-------|
| Planned Items | X |
| Delivered Items | Y |
| Delta | +/- Z |

### Notes on Scope Changes
- Any items added or removed during implementation and why
```

## Step 4: Update Project Knowledge

**Always** append lessons to `.claude/LEARNINGS.md`. Create the file if it does not exist.

Then show the developer what would be added to `CLAUDE.md` and ask for confirmation before writing. Wait for the developer to confirm.

**Rotation rule**: Keep the 3 most recent workflow lessons in `CLAUDE.md`. When adding new lessons, move the oldest entries to `LEARNINGS.md` to keep `CLAUDE.md` focused and current.

## Step 5: Mark Workflow Complete

Update `.claude/planning/{issue-name}/00_STATUS.md`:
- Change Status to: `WORKFLOW COMPLETE`
- Mark Retro as checked: `- [x] Retro`
- Update Last Updated date

## Step 6: Present to Developer

Show:
- Lessons learned from this workflow
- What will be added to `CLAUDE.md` (pending confirmation)
- Workflow complete confirmation
- Suggest: "Commit your changes, or run `/discover` to start a new task."
