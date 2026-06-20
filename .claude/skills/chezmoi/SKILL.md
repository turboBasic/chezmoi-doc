---
name: chezmoi
description: Look up chezmoi documentation — commands, config, templates, scripts, encryption, password managers
allowed-tools: Read, Bash(grep *)
---

You are a knowledge base lookup skill for **chezmoi**. The documentation lives under `src/`.

## Steps

1. Derive the repo root: this file lives at `<repo-root>/.claude/skills/chezmoi/SKILL.md`.
   Strip `/.claude/skills/chezmoi/SKILL.md` from the path this file was loaded from to get `<repo-root>`.

2. Read the navigation table:
   `<repo-root>/CLAUDE.md`

3. Based on the user's question, identify which file(s) in `src/` are relevant using the lookup table.

4. Read those file(s) from `<repo-root>/src/`.

5. If the lookup table doesn't clearly point to the right file, grep across `src/` for the relevant keyword:
   `grep -rn "<keyword>" <repo-root>/src/`

6. Answer the user's question concisely, citing the specific file and section where the information was found.

## Topic routing

| Topic                              | Primary file(s)                                                              |
| ---------------------------------- | ---------------------------------------------------------------------------- |
| How chezmoi works                  | `src/what-does-chezmoi-do.md`, `src/reference/concepts.md`                  |
| Getting started / setup            | `src/quick-start.md`, `src/user-guide/setup.md`                             |
| A specific command                 | `src/reference/commands/<cmd>.md`                                            |
| All commands overview              | `src/reference/commands/index.md`                                            |
| Config file options                | `src/reference/configuration-file/index.md`                                 |
| Config variables                   | `src/reference/configuration-file/variables.md`                             |
| Hooks (config)                     | `src/reference/configuration-file/hooks.md`                                 |
| Templates (syntax/directives)      | `src/reference/templates/index.md`, `src/reference/templates/directives.md` |
| Template variables                 | `src/reference/templates/variables.md`                                      |
| Template functions                 | `src/reference/templates/functions/<fn>.md`                                 |
| Init-time template functions       | `src/reference/templates/init-functions/`                                   |
| Source file naming / prefixes      | `src/reference/source-state-attributes.md`                                  |
| Target types                       | `src/reference/target-types.md`                                              |
| Application order                  | `src/reference/application-order.md`                                        |
| Scripts (run_*)                    | `src/user-guide/use-scripts-to-perform-actions.md`                          |
| External files/archives            | `src/user-guide/include-files-from-elsewhere.md`                            |
| Encryption (age/gpg/rage)          | `src/user-guide/encryption/index.md`                                        |
| Password managers                  | `src/user-guide/password-managers/<name>.md`                                |
| Machine differences                | `src/user-guide/manage-machine-to-machine-differences.md`                   |
| macOS-specific                     | `src/user-guide/machines/macos.md`                                          |
| Linux-specific                     | `src/user-guide/machines/linux.md`                                          |
| Windows-specific                   | `src/user-guide/machines/windows.md`                                        |
| Ignoring files                     | `src/reference/special-files/chezmoiignore.md`                              |
| Data files                         | `src/reference/special-files/chezmoidata-format.md`                        |
| Templating guide                   | `src/user-guide/templating.md`                                              |
| Daily operations                   | `src/user-guide/daily-operations.md`                                        |
| Editor / merge / diff tools        | `src/user-guide/tools/editor.md`                                            |
| Troubleshooting / FAQ              | `src/user-guide/frequently-asked-questions/troubleshooting.md`              |
| General FAQ                        | `src/user-guide/frequently-asked-questions/general.md`                      |
| Migrating to chezmoi               | `src/migrating-from-another-dotfile-manager.md`                             |
| Init workflow                      | `src/reference/commands/init.md`                                            |
