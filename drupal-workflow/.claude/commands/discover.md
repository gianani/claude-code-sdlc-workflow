---
description: "Phase 1: Scope a task, detect Drupal stack, map custom modules"
---

# Discovery Phase

Input: $ARGUMENTS (task description). If no arguments provided, ask the developer to describe the task.

## Step 1: Classify Complexity

Determine the complexity track:

| Track    | Description                                      | Example                          |
|----------|--------------------------------------------------|----------------------------------|
| Quick    | Single-file fix, config change, minor tweak      | Fix a View filter, update a field |
| Standard | New feature, new module, multi-file change        | Add event registration feature    |
| Full     | Migration, entity restructuring, major config     | Migrate Paragraphs to Layout Builder |

Default to **Quick** unless evidence suggests otherwise. If Quick, note that the full workflow can be skipped — implement directly.

## Step 2: Generate Issue Name

Create a kebab-case issue name, 2-5 words, action-prefixed (e.g., `add-event-registration`, `fix-search-facets`, `migrate-paragraphs-layout`).

Create directory: `.claude/planning/{issue-name}/`

## Step 3: Detect Drupal Stack

Scan the codebase for Drupal stack details:

- **composer.json**: `drupal/core` or `drupal/core-recommended` version, PHP version constraint, contrib modules listed as dependencies
- **core/lib/Drupal.php**: Drupal core version constant
- **sites/default/settings.php**: Database driver, cache backend, file paths. **NEVER include credentials, passwords, or connection strings in the discovery document.**
- **Modules**:
  - `modules/custom/` — list each module with its `.info.yml` metadata
  - `modules/contrib/` — key modules especially: Commerce, Paragraphs, Webform, Search API, Pathauto, Layout Builder, Media, Token, Metatag
- **Theme**:
  - `themes/custom/` — list with `.info.yml` metadata
  - Base theme (Olivero, Claro, Bootstrap, Starter)
  - CSS framework from `.libraries.yml`
- **Config**: scan `config/sync/` for content types (`node.type.*.yml`), vocabularies (`taxonomy.vocabulary.*.yml`), views (`views.view.*.yml`)
- **Infrastructure**: CI/CD files, `.ddev/`, `.lando.yml`, `docker-compose.yml`

## Step 4: Map Affected Areas

Based on the task description and stack detection, identify:

- Custom modules that will be modified or created
- Content types and entities involved
- Contrib module interactions (hooks, events, plugins that depend on contrib)
- Config changes that will be needed

## Step 5: Create 01_DISCOVERY.md

Write `.claude/planning/{issue-name}/01_DISCOVERY.md` with:

```markdown
# Discovery: {Issue Name}

## Task
{Task description from developer input}

## Drupal Stack

| Component       | Detail                    |
|-----------------|---------------------------|
| Drupal Version  | {version}                 |
| PHP Version     | {version}                 |
| Theme           | {custom theme name}       |
| Base Theme      | {base theme}              |
| CSS Framework   | {framework or None}       |
| Cache Backend   | {database/redis/memcache} |
| Search          | {core/search_api+solr}    |
| Database        | {mysql/mariadb/postgres}  |
| Local Dev       | {ddev/lando/docker/none}  |
| CI/CD           | {tool or None detected}   |

## Key Contrib Modules

| Module          | Version   | Relevance to Task          |
|-----------------|-----------|----------------------------|
| {module}        | {version} | {why it matters}           |

## Custom Modules

| Module          | Path                        | Purpose                    |
|-----------------|-----------------------------|----------------------------|
| {module}        | modules/custom/{module}     | {from info.yml description}|

## Content Architecture
{Content types, vocabularies, and key views discovered from config/sync}

## Scope

**In Scope:**
- {item}

**Out of Scope:**
- {item}

## Affected Areas
- {Custom module, content type, config, or integration point}

## Risks
- {Identified risk}

## Dependencies
- {Module or system dependency}
```

## Step 6: Create 00_STATUS.md

Write `.claude/planning/{issue-name}/00_STATUS.md`:

```markdown
# Workflow: {issue-name}

- **Status:** IN PROGRESS
- **Track:** {Quick|Standard|Full}
- **Last Updated:** {date}
- **Stack:** Drupal {version} | {theme} | {local dev}

## Progress
- [x] Discover
- [ ] Blueprint
- [ ] Implement
- [ ] Review
- [ ] Retro
```

## Step 7: Present to Developer

Present a summary:

- Issue name and track
- Stack summary (Drupal version, theme, key contrib)
- Custom modules found
- Content architecture relevant to task
- Scope (in/out)
- Risks identified
- Suggest: **"Run `/blueprint {issue-name}` to create the implementation plan."**
