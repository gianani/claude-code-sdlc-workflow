---
description: "Phase 2: Create a phased implementation blueprint for a Drupal task"
---

# Blueprint Phase

Input: $ARGUMENTS (issue name). If no arguments provided, check `.claude/planning/` for the most recent in-progress workflow.

## Step 1: Load Context

Read `.claude/planning/{issue-name}/01_DISCOVERY.md` and `.claude/planning/{issue-name}/00_STATUS.md`.

If `01_DISCOVERY.md` does not exist, tell the developer: **"Discovery not found for `{issue-name}`. Run `/discover` first."**

## Step 2: Plan the Implementation

Organize implementation into phases that follow Drupal module structure conventions:

- **Phase 1** is always the module skeleton: `.info.yml`, `.module`, `services.yml`, `config/install/`, `config/schema/`
- Then order remaining phases by dependency:
  1. Data model before business logic (entities, fields, schema before services)
  2. Services and plugins before controllers and forms
  3. Backend before theming (logic before templates)
  4. Admin-facing before public-facing
- **Last phase** is always: tests + config export + code standards cleanup

Each phase should be independently verifiable with `drush cr`, `drush cex`, and `phpcs`.

## Step 3: Identify Drupal-Specific Concerns

For each phase, document:

- **Config management**: list every config file that will be created or modified (exact filenames like `config/install/my_module.settings.yml`)
- **Update hooks**: any `hook_update_N()` needed for existing sites
- **Cache**: cache tags, cache contexts, and max-age for render arrays and custom data
- **Permissions**: new permissions to define and check
- **Entity type vs content type**: justify the decision if creating new data structures
- **Plugin types**: Block, Field (formatter/widget), QueueWorker, Constraint, Action, etc.
- **Services and interfaces**: service definitions, interface contracts, dependency injection
- **Events vs hooks**: prefer events/subscribers for new code, hooks only when required by core/contrib
- **Theme layer**: template files, preprocess functions, library definitions
- **Contrib interaction points**: hooks into contrib modules, event subscribers, plugin derivatives

## Step 4: Write 02_BLUEPRINT.md

Write `.claude/planning/{issue-name}/02_BLUEPRINT.md`:

```markdown
# Blueprint: {Issue Name}

## Module
- **Name:** {module_name}
- **Location:** modules/custom/{module_name}

## Phase 1: Module Skeleton
**Files:**
- `modules/custom/{module_name}/{module_name}.info.yml`
- `modules/custom/{module_name}/{module_name}.module`
- `modules/custom/{module_name}/{module_name}.services.yml`
- `modules/custom/{module_name}/config/install/{config files}`
- `modules/custom/{module_name}/config/schema/{module_name}.schema.yml`

**Validation:** `drush en {module_name}`, `drush cr`

## Phase 2: {Phase Title}
**Files:**
- {file list}

**Validation:** `drush cr`, `phpcs --standard=Drupal,DrupalPractice`

## Phase N: Tests & Config Export
**Files:**
- `modules/custom/{module_name}/tests/src/Unit/`
- `modules/custom/{module_name}/tests/src/Kernel/`

**Validation:** `drush cex`, `phpcs --standard=Drupal,DrupalPractice`, `phpunit`

## Drupal-Specific Notes
- {Config management notes}
- {Cache strategy}
- {Permission definitions}
- {Plugin types used}
- {Contrib interaction points}

## Dependencies Between Phases
- Phase 2 depends on Phase 1 (module must be enabled)
- {other dependencies}

## Config Changes
| Config File                          | Action   | Description              |
|--------------------------------------|----------|--------------------------|
| {config filename}                    | Create   | {what it configures}     |
| {config filename}                    | Modify   | {what changes}           |
```

## Step 5: Update 00_STATUS.md

Update the progress in `.claude/planning/{issue-name}/00_STATUS.md`:

```markdown
- [x] Discover
- [x] Blueprint
- [ ] Implement
- [ ] Review
- [ ] Retro
```

Update **Last Updated** date.

## Step 6: Present to Developer

Present a summary:

- Module name and location
- Number of phases with brief description of each
- Drupal-specific concerns identified
- Config files that will be created/modified
- Estimated hours for implementation
- Suggest: **"Run `/implement {issue-name}` to start building."**
