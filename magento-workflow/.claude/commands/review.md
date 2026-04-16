---
description: "Phase 4: Review code against Magento standards and best practices"
---

# Review Phase

Input: $ARGUMENTS (issue name)

## Step 1: Load Context

Read the following files:
- `.claude/planning/{issue-name}/02_BLUEPRINT.md`
- `.claude/planning/{issue-name}/01_DISCOVERY.md`
- `.claude/planning/{issue-name}/00_STATUS.md`

If the Implement checkbox is not checked in `00_STATUS.md`, tell the developer: "Implementation is not complete. Run `/implement {issue-name}` first."

## Step 2: Identify Changed Files

Gather the list of files to review from:
- Files listed in `02_BLUEPRINT.md` across all phases
- `git diff` to catch any additional changes

## Step 3: Review Checklists

### Intent & Spec Match (REVIEW THIS FIRST)
- [ ] Every item in the Discovery scope has been implemented
- [ ] Nothing out of scope has been added
- [ ] Implementation matches the blueprint approach
- [ ] Edge cases are handled
- [ ] Error scenarios are handled
- [ ] User-facing behavior matches what was described in discovery

### Magento Coding Standards
- [ ] No direct use of ObjectManager
- [ ] All dependencies injected via constructor
- [ ] Plugin method signatures are correct (first param is `$subject` with correct type)
- [ ] No `around` plugin where `before`/`after` would work
- [ ] No `preference` where a `plugin` would work
- [ ] `db_schema.xml` uses proper column types and constraints
- [ ] `db_schema_whitelist.json` is generated/updated
- [ ] ACL resources are defined for all admin controllers and API endpoints
- [ ] CSRF protection is not bypassed
- [ ] All user-facing strings wrapped in `__()`

### Template & Frontend
- [ ] `escapeHtml()` used for all dynamic string output
- [ ] `escapeUrl()` used for all dynamic URLs
- [ ] No inline CSS or inline JavaScript in templates
- [ ] Hyva theme: Alpine.js used (no Knockout.js, no RequireJS)
- [ ] Luma theme: Knockout.js and RequireJS used correctly
- [ ] Layout XML validates against schema
- [ ] View models used instead of block methods where appropriate

### Data Access
- [ ] Repository pattern used for data access
- [ ] `addFieldToFilter` used instead of raw SQL
- [ ] No `load()` calls inside loops
- [ ] `getById()` used for single entity retrieval

### Performance
- [ ] No `around` plugin on checkout totals or critical path
- [ ] No full collection load when only count is needed
- [ ] Cache tags set correctly on cacheable blocks
- [ ] Indexer impact considered (custom indexers or reindex triggers)

### Security
- [ ] No raw user input in SQL queries
- [ ] Form keys validated on all POST requests
- [ ] Admin controllers extend `\Magento\Backend\App\Action`
- [ ] File uploads validate MIME type
- [ ] Sensitive data not written to logs

### Completeness
- [ ] Unit tests exist for business logic
- [ ] Integration tests exist for critical paths
- [ ] `module.xml` sequence is correct for dependencies

## Step 4: Write 03_REVIEW.md

Write `.claude/planning/{issue-name}/03_REVIEW.md` with:

```markdown
# Review: {Issue Name}

## Verdict: APPROVED / APPROVED WITH MINOR ISSUES / NEEDS FIXES

## Files Reviewed

| File | Status |
|------|--------|
| path/to/file.php | OK / Issues Found |

## Issues

| Severity | File | Issue | Suggestion |
|----------|------|-------|------------|
| Critical / Major / Minor | path/to/file.php | Description of issue | How to fix |

## Checklist Results

### Intent & Spec Match
- [x] / [ ] Each item...

### Magento Coding Standards
- [x] / [ ] Each item...

### Template & Frontend
- [x] / [ ] Each item...

### Data Access
- [x] / [ ] Each item...

### Performance
- [x] / [ ] Each item...

### Security
- [x] / [ ] Each item...

### Completeness
- [x] / [ ] Each item...

## Notes
- Any additional observations or recommendations
```

## Step 5: Act on Verdict

Based on the review verdict:

- **APPROVED**: No issues found. Suggest: "Run `/retro {issue-name}` to complete the workflow."
- **APPROVED WITH MINOR ISSUES**: Fix the minor issues immediately before committing. No re-review needed. Then suggest `/retro`.
- **NEEDS FIXES**: Fix all critical and major issues, then tell the developer to run `/review {issue-name}` again.

## Step 6: Update 00_STATUS.md

Update `.claude/planning/{issue-name}/00_STATUS.md`:
- Mark Review as checked: `- [x] Review`
- Update Last Updated date
