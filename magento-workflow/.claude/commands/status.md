---
description: "Check for incomplete workflows and show current status"
---

# Status Check

Scan `.claude/planning/` for subdirectories. In each subdirectory, read `00_STATUS.md`.

## Step 1: Scan for Workflows

Look for all directories under `.claude/planning/`. For each directory found, read `00_STATUS.md` and extract the status, track, and progress checkboxes.

If no directories exist under `.claude/planning/`, report:

> No workflows found. Run `/discover` to start a new task.

Then stop.

## Step 2: Group Workflows

Group workflows into two categories:

### In Progress
Workflows where status is `IN PROGRESS`. Show:
- Issue name
- Track (Standard/Full)
- Last updated
- Current phase (based on checkboxes)

### Completed
Workflows where status is `COMPLETE`. Show:
- Issue name
- Track
- Completion date

Example output:

```
## In Progress
- **add-loyalty-points** (Standard) - Implementing Phase 2 - Updated 2024-01-15
- **fix-checkout-tax** (Full) - Blueprint complete, ready for implementation - Updated 2024-01-14

## Completed
- **update-shipping-rates** (Standard) - Completed 2024-01-10
```

## Step 3: Suggest Next Action

At the end, always show:

> Run `/discover` to start a new task, or `/blueprint {issue-name}` to continue.
