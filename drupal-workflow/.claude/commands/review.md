---
description: "Phase 4: Review code against Drupal standards and best practices"
---

# Review Phase

Input: $ARGUMENTS (issue name).

## Step 1: Load Context

Read `.claude/planning/{issue-name}/02_BLUEPRINT.md`, `.claude/planning/{issue-name}/01_DISCOVERY.md`, and `.claude/planning/{issue-name}/00_STATUS.md`.

If the Implement checkbox is not checked in `00_STATUS.md`, tell the developer: **"Implementation not complete for `{issue-name}`. Run `/implement {issue-name}` first."**

## Step 2: Identify Changed Files

Collect the list of changed files from:
- Files listed in the blueprint phases
- `git diff` to catch any additional changes
- Config files in `config/sync/` that were added or modified

## Step 3: Review Checklists

### Intent and Spec Match (Review This FIRST)

- [ ] Every item in the discovery scope is implemented
- [ ] Nothing out of scope was added
- [ ] Implementation matches the blueprint phases and files
- [ ] Edge cases are handled
- [ ] Error scenarios are handled gracefully
- [ ] User-facing behavior matches what the discovery describes

### Drupal Coding Standards

- [ ] `phpcs --standard=Drupal,DrupalPractice` passes with no errors
- [ ] `services.yml` entries are correct (class, arguments, tags)
- [ ] Hook implementations are in `.module` file with correct `hook_` naming
- [ ] All user-facing strings wrapped in `t()` or `$this->t()`
- [ ] No hardcoded entity IDs, bundle names, or field names

### Config Management

- [ ] All config is exported to `config/sync/` via `drush cex`
- [ ] Config schema is defined for every custom config object
- [ ] Config install files are present in `config/install/` for initial setup
- [ ] No config changes outside the scope of this task
- [ ] Update hooks (`hook_update_N()`) exist for any data migrations on existing sites

### Entity and Data Access

- [ ] Entity type annotations/attributes are correct and complete
- [ ] Base field definitions are correct (type, label, settings, display)
- [ ] Access handlers are defined for custom entity types
- [ ] Entity queries used instead of raw SQL
- [ ] No `::load()` calls inside loops (use `::loadMultiple()`)

### Caching

- [ ] All render arrays include `#cache` with appropriate metadata
- [ ] Custom cache tags are defined where data changes should invalidate cache
- [ ] Cache contexts are set for role-based, URL-based, or user-based variation
- [ ] `max-age` is appropriate (not 0 unless truly uncacheable)

### Templates and Theming

- [ ] Twig template naming follows conventions (`module-name--variant.html.twig`)
- [ ] No business logic in Twig templates
- [ ] Preprocess functions are documented with `@param` and purpose
- [ ] Libraries are defined in `.libraries.yml` and attached properly
- [ ] Templates use `content.field_name` pattern, not direct entity access

### Routing and Access

- [ ] All routes have proper access checks (`_permission`, `_role`, `_custom_access`)
- [ ] Admin routes include `_admin_route: TRUE` option
- [ ] Form routes use correct `_form` or `_entity_form` definition

### Security

- [ ] No raw user input in database queries (parameterized queries or Entity API)
- [ ] Form API is used for all form handling (not raw `$_POST`)
- [ ] File upload fields validate MIME types and extensions
- [ ] No `|raw` filter on user-generated content in Twig
- [ ] Admin-only operations are protected by permissions

### Performance

- [ ] No entity loading in preprocess functions for list/collection pages
- [ ] No full entity loads (`::load()`) when only a single field value is needed
- [ ] Database tables have proper indexes for custom queries
- [ ] Event subscribers are lightweight (defer heavy work to queues)

### Completeness

- [ ] Unit tests and/or kernel tests exist for custom logic
- [ ] Config export is clean (no unrelated config changes)
- [ ] Module dependencies are declared in `.info.yml`

## Step 4: Write 03_REVIEW.md

Write `.claude/planning/{issue-name}/03_REVIEW.md`:

```markdown
# Review: {Issue Name}

## Verdict
{APPROVED | APPROVED WITH MINOR ISSUES | NEEDS FIXES}

## Files Reviewed
- {file path}

## Config Changes

| Config File                          | Action   | Verified |
|--------------------------------------|----------|----------|
| {config filename}                    | {action} | Yes/No   |

## Issues Found

| # | Severity | File             | Issue                        | Fix                          |
|---|----------|------------------|------------------------------|------------------------------|
| 1 | {sev}    | {file}           | {description}                | {recommended fix}            |

## Checklist Results
- **Intent and Spec Match:** {PASS/FAIL} — {notes}
- **Drupal Coding Standards:** {PASS/FAIL} — {notes}
- **Config Management:** {PASS/FAIL} — {notes}
- **Entity and Data Access:** {PASS/FAIL} — {notes}
- **Caching:** {PASS/FAIL} — {notes}
- **Templates and Theming:** {PASS/FAIL} — {notes}
- **Routing and Access:** {PASS/FAIL} — {notes}
- **Security:** {PASS/FAIL} — {notes}
- **Performance:** {PASS/FAIL} — {notes}
- **Completeness:** {PASS/FAIL} — {notes}

## Notes
- {Additional observations}
```

## Step 5: Act on Verdict

- **APPROVED**: Proceed to retro. Suggest: **"Run `/retro {issue-name}` to complete the workflow."**
- **APPROVED WITH MINOR ISSUES**: List non-blocking items. Suggest retro but note items to fix before commit.
- **NEEDS FIXES**: List blocking issues with specific fix instructions. After fixes, re-run `/review {issue-name}`.

## Step 6: Update 00_STATUS.md

Update the progress:

```markdown
- [x] Discover
- [x] Blueprint
- [x] Implement
- [x] Review
- [ ] Retro
```

Update **Last Updated** date.
