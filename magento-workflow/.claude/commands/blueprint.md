---
description: "Phase 2: Create a phased implementation blueprint for a Magento task"
---

# Blueprint Phase

Input: $ARGUMENTS (issue name)

## Step 1: Load Context

Read `.claude/planning/{issue-name}/01_DISCOVERY.md` and `.claude/planning/{issue-name}/00_STATUS.md`.

If `01_DISCOVERY.md` does not exist, tell the developer: "Discovery has not been completed for this issue. Run `/discover` first."

## Step 2: Plan the Implementation

Design a phased implementation plan following Magento module structure conventions:

**Phase ordering rules:**
- Phase 1 is always the module skeleton: `registration.php`, `module.xml`, `db_schema.xml`, `system.xml`, `acl.xml` (include only what's needed)
- Models and Repositories before templates
- Backend logic before frontend presentation
- Admin functionality before customer-facing functionality
- Last phase is always: tests + static analysis (PHPUnit, PHPCS, PHPStan)

**Each phase must include:**
- Phase name and objective
- Files to create or modify with full paths
- Validation checkboxes (what to verify after implementing this phase)

## Step 3: Identify Magento-Specific Concerns

Evaluate and document concerns relevant to this task:
- Checkout totals collector ordering (sort_order values)
- Indexer impact (which indexers affected, reindex needed?)
- Cache invalidation (which cache types, full page cache impact)
- Plugin vs Preference decisions (always prefer plugin unless impossible)
- Hyva compatibility (if Hyva theme: Alpine.js, no Knockout/RequireJS)
- Event/Observer vs Plugin (events for loose coupling, plugins for method modification)
- Admin UI components (UI components vs layout XML)

## Step 4: Write 02_BLUEPRINT.md

Write `.claude/planning/{issue-name}/02_BLUEPRINT.md` with:

```markdown
# Blueprint: {Issue Name}

## Module
- **Name**: Vendor_ModuleName
- **Location**: app/code/Vendor/ModuleName

## Phase 1: Module Skeleton
**Objective**: Set up the module structure and registration

### Files
- `app/code/Vendor/ModuleName/registration.php`
- `app/code/Vendor/ModuleName/etc/module.xml`
- `app/code/Vendor/ModuleName/etc/db_schema.xml`

### Validation
- [ ] Module appears in `bin/magento module:status`
- [ ] `bin/magento setup:upgrade` runs without errors

## Phase 2: {Phase Name}
**Objective**: {What this phase accomplishes}

### Files
- `path/to/file1.php`
- `path/to/file2.xml`

### Validation
- [ ] Validation step 1
- [ ] Validation step 2

## Phase N: Tests & Static Analysis
**Objective**: Ensure code quality and correctness

### Files
- `app/code/Vendor/ModuleName/Test/Unit/...`
- `app/code/Vendor/ModuleName/Test/Integration/...`

### Validation
- [ ] Unit tests pass
- [ ] PHPCS passes with Magento2 standard
- [ ] PHPStan passes

## Magento-Specific Notes
- Note 1
- Note 2

## Dependencies Between Phases
- Phase 2 depends on Phase 1 (module must be registered)
- Phase 3 depends on Phase 2 (models must exist before templates)

## Conventions
- Follow Magento 2 coding standards
- Use strict types declaration in all PHP files
- Constructor dependency injection only
```

## Step 5: Update 00_STATUS.md

Update `.claude/planning/{issue-name}/00_STATUS.md`:
- Mark Blueprint as checked: `- [x] Blueprint`
- Update Last Updated date

## Step 6: Present to Developer

Summarize:
- Module name and location
- Number of phases with brief description of each
- Key Magento-specific concerns identified
- Estimated hours for implementation
- Suggest: "Run `/implement {issue-name}` to start building, or `/implement {issue-name} phase 2` for a specific phase."
