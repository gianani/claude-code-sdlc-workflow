---
description: "Check for incomplete workflows and show current status"
---

# Status Check

## Step 1: Scan for Workflows

Scan `.claude/planning/` for subdirectories. For each subdirectory, read `00_STATUS.md`.

## Step 2: Group Workflows

Group workflows into two categories based on their Status field:

**In Progress** — Status is `IN PROGRESS`
**Completed** — Status is `COMPLETE`

## Step 3: Display Results

If workflows exist, display them grouped:

```
## In Progress
- **add-event-registration** (Standard) — Implement ✅ → Review pending
- **fix-search-facets** (Quick) — Discover ✅ → Blueprint pending

## Completed
- **migrate-paragraphs-layout** (Full) — Completed 2026-04-10
```

For each workflow show:
- Issue name
- Track (Quick/Standard/Full)
- Current phase progress based on checkboxes in 00_STATUS.md

Then say: **"Run `/discover` to start a new task, or `/blueprint {issue-name}` to continue."**

If no subdirectories exist in `.claude/planning/`:

**"No workflows found."**
