---
description: "Phase 3: Implement code phase by phase following the blueprint"
---

# Implement Phase

Input: $ARGUMENTS

Parse the arguments:
- `{issue-name}` - implement all remaining phases
- `{issue-name} phase 2` - implement only phase 2
- `{issue-name} phase 3-5` - implement phases 3 through 5

## Step 1: Load Context

Read the following files:
- `.claude/planning/{issue-name}/02_BLUEPRINT.md`
- `.claude/planning/{issue-name}/01_DISCOVERY.md`
- `.claude/planning/{issue-name}/00_STATUS.md`

If `02_BLUEPRINT.md` does not exist, tell the developer: "No blueprint found. Run `/blueprint {issue-name}` first."

If implementation is partially complete (some phases done), resume from where it left off.

## Step 2: Determine Phases to Implement

Based on the arguments:
- If no phase specified: implement all remaining phases sequentially
- If specific phase: implement only that phase
- If range: implement that range of phases

Do NOT ask "Proceed? (y/n)" between phases. Implement them continuously.

## Step 3: Implement Each Phase

For each phase, follow the blueprint file paths exactly. Apply Magento coding standards throughout:

**Checks to apply during implementation:**
- Constructor dependency injection - no ObjectManager usage
- Plugin method signatures match the intercepted method exactly (subject as first param, type-hinted)
- `di.xml` entries are correct (type names, plugin names, sortOrder)
- Layout XML follows schema (correct handles, blocks, containers)
- `db_schema.xml` uses correct column types and attributes
- Template files use proper escaping (`escapeHtml`, `escapeUrl`, `escapeJs`)
- Hyva theme: use Alpine.js directives, no Knockout.js or RequireJS
- Luma theme: use Knockout.js bindings and RequireJS modules
- All strings wrapped in `__()` for translation

**After each phase that adds classes, plugins, or DI configuration:**
Run `bin/magento setup:di:compile` to verify DI correctness.

**After each phase:**
- Run the validation steps defined in the blueprint for that phase
- Update `.claude/planning/{issue-name}/00_STATUS.md` with progress

## Step 4: Final Validation

After all phases are implemented, run:
1. `bin/magento setup:di:compile` - DI compilation
2. `bin/magento setup:upgrade` - database schema upgrade
3. `vendor/bin/phpcs --standard=Magento2 app/code/Vendor/ModuleName` - coding standards
4. `vendor/bin/phpunit app/code/Vendor/ModuleName/Test/` - unit tests

## Step 5: Report Results

Report all phases at once (not one at a time):

For each phase completed:
- Files created
- Files modified
- Validation results (pass/fail)

Summary:
- Total files created/modified
- All validation results
- Any issues encountered
- Suggest: "Run `/review {issue-name}` to review the implementation."

## Step 6: Update 00_STATUS.md

Update `.claude/planning/{issue-name}/00_STATUS.md`:
- Mark Implement as checked: `- [x] Implement`
- Update Last Updated date

## Rules

1. **Follow the blueprint** - implement exactly what was planned, no more, no less
2. **Do not ask y/n** - implement phases continuously without confirmation prompts
3. **Run di:compile per phase** - after any phase that adds classes, plugins, or DI configuration
4. **Never skip tests** - the final phase with tests must always be implemented
5. **Ask before modifying core** - if a phase requires modifying vendor or core files, pause and confirm with the developer
6. **Stay within blueprint scope** - do not create files or make changes not specified in the blueprint
