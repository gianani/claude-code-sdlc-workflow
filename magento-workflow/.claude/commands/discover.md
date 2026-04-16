---
description: "Phase 1: Scope a task, detect Magento stack, map custom modules"
---

# Discover Phase

Input: $ARGUMENTS

If no arguments provided, ask the developer: "What task or issue are you working on? Describe it briefly."

## Step 1: Classify Complexity

Based on the task description, classify into one of three tracks:

| Track | Description | Examples | Workflow |
|-------|-------------|----------|----------|
| Quick | Single-file fix, config change, minor template edit | Fix typo, change config value, CSS tweak | Skip workflow - just do it |
| Standard | New feature, module, or multi-file change | New module, add API endpoint, new admin grid | Full workflow |
| Full | Migration, checkout/payment changes, major refactor | M1 to M2 migration, payment gateway, checkout rewrite | Full workflow with extra review |

Default to Quick if uncertain. If Quick, implement directly and skip remaining steps.

## Step 2: Generate Issue Name

Create a kebab-case issue name from the task description:
- 2-5 words
- Action-prefixed (add-, fix-, update-, create-, migrate-, refactor-)
- Examples: `add-loyalty-points`, `fix-checkout-tax`, `update-shipping-rates`

Create the directory: `.claude/planning/{issue-name}/`

## Step 3: Detect Magento Stack

Scan the project to detect the Magento stack:

- **composer.json**: Edition (Community/Enterprise/Cloud), PHP version, installed modules
- **composer.lock**: Exact versions of dependencies
- **app/etc/env.php**: Database type, cache backend, session storage, queue connection - NEVER include credentials, passwords, keys, or connection strings in the discovery document
- **app/etc/config.php**: List of enabled/disabled modules
- **Theme detection**: Check for `hyva-themes` in composer.json/composer.lock OR `Hyva/` directories in `app/design/`. Determine if Luma or Hyva frontend.
- **Custom code**: List all modules under `app/code/` with their purpose
- **Infrastructure**: Check for CI/CD configs, docker-compose, nginx configs

## Step 4: Map Affected Areas

Identify:
- Existing custom modules that may be affected
- Core Magento areas involved (catalog, checkout, customer, sales, etc.)
- Third-party module conflicts or interactions

## Step 5: Create 01_DISCOVERY.md

Write `.claude/planning/{issue-name}/01_DISCOVERY.md` with:

```markdown
# Discovery: {Issue Name}

## Task
{Task description from developer input}

## Magento Stack

| Component | Value |
|-----------|-------|
| Edition | Community / Enterprise / Cloud |
| Version | 2.4.x |
| PHP | 8.x |
| Theme | Luma / Hyva / Custom |
| Frontend Approach | Knockout.js / Alpine.js / React |
| Cache | Redis / Varnish / Built-in |
| Session | Redis / Files / DB |
| Queue | RabbitMQ / DB / None |
| Search | Elasticsearch / OpenSearch / MySQL |
| DB | MySQL / MariaDB |

## Custom Modules

| Module | Path | Purpose |
|--------|------|---------|
| Vendor_Module | app/code/Vendor/Module | Description |

## Scope

### In Scope
- Item 1
- Item 2

### Out of Scope
- Item 1
- Item 2

## Affected Areas
- Area 1: How it's affected
- Area 2: How it's affected

## Risks
- Risk 1
- Risk 2

## Dependencies
- Dependency 1
- Dependency 2
```

## Step 6: Create 00_STATUS.md

Write `.claude/planning/{issue-name}/00_STATUS.md` with:

```markdown
# Status: {issue-name}

- **Status**: IN PROGRESS
- **Track**: Standard / Full
- **Last Updated**: {date}

## Stack Summary
{One-line summary: e.g., "Magento 2.4.6 Community on PHP 8.2 with Hyva theme, Redis cache"}

## Progress
- [x] Discover
- [ ] Blueprint
- [ ] Implement
- [ ] Review
- [ ] Retro
```

## Step 7: Present to Developer

Summarize for the developer:
- Issue name created
- Stack summary (edition, version, theme, key infrastructure)
- Custom modules found
- Scope (in/out)
- Key risks identified
- Suggest: "Run `/blueprint {issue-name}` to create the implementation plan."
