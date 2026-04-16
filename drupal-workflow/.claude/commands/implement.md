---
description: "Phase 3: Implement code phase by phase following the blueprint"
---

# Implementation Phase

Input: $ARGUMENTS — parse as one of:
- `{issue-name}` — implement all phases
- `{issue-name} phase 2` — implement specific phase
- `{issue-name} phase 3-5` — implement a range of phases

## Step 1: Load Context

Read `.claude/planning/{issue-name}/02_BLUEPRINT.md`, `.claude/planning/{issue-name}/01_DISCOVERY.md`, and `.claude/planning/{issue-name}/00_STATUS.md`.

If `02_BLUEPRINT.md` does not exist, tell the developer: **"Blueprint not found for `{issue-name}`. Run `/blueprint {issue-name}` first."**

If implementation is partially complete (phases already done), resume from where it left off.

## Step 2: Determine Phases to Implement

Based on the arguments:
- No phase specified: implement all remaining phases
- Specific phase: implement only that phase
- Phase range: implement that range

Do NOT ask "Proceed? (y/n)" between phases. Implement continuously.

## Step 3: Implement Each Phase

For each phase in the blueprint, implement all files listed. Follow coding standards from CLAUDE.md. Additional implementation-phase checks:

- `services.yml` entries have correct class, arguments, and tags
- Entity annotations/attributes match the entity type (content vs config)
- Config schema defined for every custom config file
- Config install files use correct `{module}.{type}.{id}` naming
- Route access checks defined (`_permission`, `_role`, `_custom_access`)
- Admin routes use `_admin_route: TRUE`
- Twig templates follow naming conventions, libraries attached via `#attached`
- `baseFieldDefinitions()` properly defined for custom entities

**Validation after each phase:**
- `drush cr` (cache rebuild)
- `drush cex` (config export — verify only expected changes)
- `phpcs --standard=Drupal,DrupalPractice` on changed files

Update `00_STATUS.md` with phase completion progress after each phase.

## Step 4: Final Validation

After all phases are complete:
- `drush cr`
- `drush cex` — verify config changes match what was planned in the blueprint
- `phpcs --standard=Drupal,DrupalPractice` on all module files
- `phpunit` — run tests created in the final phase

## Step 5: Report

Report all implemented phases at once:

- List each phase completed with files created/modified
- List all config files created or changed in `config/sync/`
- Note any deviations from the blueprint
- Suggest: **"Run `/review {issue-name}` to check the implementation."**

## Step 6: Update 00_STATUS.md

Update the progress:

```markdown
- [x] Discover
- [x] Blueprint
- [x] Implement
- [ ] Review
- [ ] Retro
```

Update **Last Updated** date.

## Rules

1. Follow the blueprint exactly. Implement what is specified, nothing more.
2. Do NOT ask "Proceed? (y/n)" between phases. Implement continuously.
3. Always run `drush cex` after any phase that creates or modifies config.
4. Never skip the tests phase.
5. Never modify contrib modules directly — use hooks, events, patches, or custom plugins.
6. Do not create files or code outside what the blueprint specifies. If something is missing from the blueprint, note it in the report but do not add it.
