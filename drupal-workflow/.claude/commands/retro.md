---
description: "Phase 5: Capture lessons learned and update project knowledge"
---

# Retrospective Phase

Input: $ARGUMENTS (issue name).

## Step 1: Load Context

Read all planning artifacts:
- `.claude/planning/{issue-name}/00_STATUS.md`
- `.claude/planning/{issue-name}/01_DISCOVERY.md`
- `.claude/planning/{issue-name}/02_BLUEPRINT.md`
- `.claude/planning/{issue-name}/03_REVIEW.md`

Also review `git diff` to understand the full scope of changes made.

## Step 2: Generate Retrospective

Focus on Drupal-specific lessons and surprises:

- Hook ordering issues (weights, execution order)
- Cache tag behavior (invalidation timing, tag naming)
- Config sync quirks (unexpected config changes, merge issues)
- Update hook sequencing (dependency on other updates)
- Theme compatibility (base theme overrides, library conflicts)
- Contrib module interaction surprises
- What worked well in the implementation
- What did not work well or required rework
- Codebase discoveries made during the task
- Issues found during review and how they were fixed

**Rules for lessons:**
- Must be relevant to THIS project and codebase, not generic Drupal advice
- One sentence each
- Actionable and specific

**Good example:** "The `hook_entity_presave` weight for `custom_events` module is 10 — custom field updates should use weight 15 to run after it."

**Bad example:** "Use services not static calls."

**Maximum 5 lessons.**

## Step 3: Write 04_RETRO.md

Write `.claude/planning/{issue-name}/04_RETRO.md`:

```markdown
# Retrospective: {Issue Name}

## Date
{date}

## Duration
{estimated time from discover to retro}

## Lessons Learned
1. {lesson}
2. {lesson}

## Review Issues Fixed
- {issue and how it was resolved}

## Scope Accuracy
- **Planned:** {number of phases/files planned}
- **Actual:** {number of phases/files implemented}
- **Deviation:** {description of any scope changes}
```

## Step 4: Update Project Knowledge

**Always** append new lessons to `.claude/LEARNINGS.md` (create if it does not exist).

**For CLAUDE.md**, show the developer what would be added and ask for confirmation before writing:

> "I'd like to add the following to CLAUDE.md:
> - {lesson 1}
> - {lesson 2}
>
> Proceed? (y/n)"

**Rotation policy:** Keep the 3 most recent workflow lessons in `CLAUDE.md`. When adding new lessons would exceed 3, move the oldest to `LEARNINGS.md` before adding the new ones.

## Step 5: Mark Workflow Complete

Update `.claude/planning/{issue-name}/00_STATUS.md`:

```markdown
- **Status:** COMPLETE
```

```markdown
- [x] Discover
- [x] Blueprint
- [x] Implement
- [x] Review
- [x] Retro
```

Update **Last Updated** date.

## Step 6: Present to Developer

Present:

- Lessons learned (numbered list)
- CLAUDE.md confirmation prompt (wait for developer response before writing)
- **"Workflow complete for `{issue-name}`."**
- Suggest: **"Commit your changes, or run `/discover` to start a new task."**
