# Chezmoi Documentation

Local mirror of [chezmoi](https://www.chezmoi.io) docs from `twpayne/chezmoi` (`assets/chezmoi.io/docs/`).

All Markdown content lives under `src/`. Synced via `./sync-docs.sh`. Use `/update-chezmoi-docs` to refresh.

## Lookup by topic

| Question about...       | Read first                                                     | Then                                                                       |
| ----------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------------- |
| How chezmoi works       | `src/what-does-chezmoi-do.md`                                  | `src/reference/concepts.md`                                                |
| Getting started         | `src/quick-start.md`                                           | `src/user-guide/setup.md`                                                  |
| A specific command      | `src/reference/commands/<cmd>.md`                              | `src/reference/commands/index.md` for list                                 |
| Config file options     | `src/reference/configuration-file/index.md`                    | `variables.md`, `editor.md`, `hooks.md`, `interpreters.md` in same dir     |
| Templates (syntax)      | `src/reference/templates/index.md`                             | `directives.md`, `variables.md` in same dir                                |
| Template functions      | `src/reference/templates/functions/<fn>.md`                    | `src/reference/templates/functions/index.md` for list                      |
| Source file naming      | `src/reference/source-state-attributes.md`                     | `src/reference/target-types.md`                                            |
| Scripts (run_*)         | `src/user-guide/use-scripts-to-perform-actions.md`             | `src/reference/special-directories/chezmoiscripts.md`                      |
| External files/archives | `src/user-guide/include-files-from-elsewhere.md`               | `src/reference/special-files/chezmoiexternal-format.md`                    |
| Encryption              | `src/user-guide/encryption/index.md`                           | `age.md`, `gpg.md`, `rage.md`, `transparent.md` in same dir               |
| Password managers       | `src/user-guide/password-managers/<name>.md`                   | `src/reference/templates/<name>-functions/`                                |
| Machine differences     | `src/user-guide/manage-machine-to-machine-differences.md`      | `src/user-guide/machines/` (linux, macos, windows, containers)             |
| Ignoring files          | `src/reference/special-files/chezmoiignore.md`                 |                                                                            |
| Application order       | `src/reference/application-order.md`                           |                                                                            |
| Data files              | `src/reference/special-files/chezmoidata-format.md`            | `src/reference/special-directories/chezmoidata.md`                         |
| Troubleshooting         | `src/user-guide/frequently-asked-questions/troubleshooting.md` | `general.md`, `usage.md`, `design.md`, `encryption.md` in same dir        |
| Migrating to chezmoi    | `src/migrating-from-another-dotfile-manager.md`                | `src/comparison-table.md`                                                  |
| Init workflow           | `src/reference/commands/init.md`                               | `src/reference/templates/init-functions/`                                  |
| Hooks (config)          | `src/reference/configuration-file/hooks.md`                    |                                                                            |
| Editor/merge/diff       | `src/user-guide/tools/editor.md`                               | `merge.md`, `diff.md` in same dir                                          |

## CLI commands

All at `src/reference/commands/<name>.md`:

add, age, age-keygen, apply, archive, cat, cat-config, cd, chattr, completion, data, decrypt, destroy, diff, docker, doctor, dump, dump-config, edit, edit-config, edit-config-template, edit-encrypted, encrypt, execute-template, forget, generate, git, help, ignored, import, init, license, list, manage, managed, merge, merge-all, podman, purge, re-add, remove, rm, secret, source-path, ssh, state, status, target-path, unmanage, unmanaged, update, upgrade, verify

## Template functions

All at `src/reference/templates/functions/<name>.md`:

comment, completion, decrypt, deleteValueAtPath, encrypt, ensureLinePrefix, eqFold, exec, findExecutable, findOneExecutable, fromIni, fromJson, fromJsonc, fromToml, fromYaml, getRedirectedURL, glob, globCaseInsensitive, hexDecode, hexEncode, include, includeTemplate, ioreg, isExecutable, joinPath, jq, lookPath, lstat, mozillaInstallHash, output, outputList, pruneEmptyDicts, quoteList, replaceAllRegex, setValueAtPath, stat, stdinIsATTY, toIni, toPrettyJson, toString, toStrings, toToml, toYaml, warnf

## Password manager template functions

Each at `src/reference/templates/<name>-functions/`:

| Manager             | Functions dir                    | User guide                                                                     |
| ------------------- | -------------------------------- | ------------------------------------------------------------------------------ |
| 1Password           | `1password-functions/`           | `src/user-guide/password-managers/1password.md`                                |
| Bitwarden           | `bitwarden-functions/`           | `src/user-guide/password-managers/bitwarden.md`                                |
| AWS Secrets Manager | `aws-secrets-manager-functions/` | `src/user-guide/password-managers/aws-secrets-manager.md`                      |
| Azure Key Vault     | `azure-key-vault-functions/`     | `src/user-guide/password-managers/azure-key-vault.md`                          |
| Dashlane            | `dashlane-functions/`            | `src/user-guide/password-managers/dashlane.md`                                 |
| Doppler             | `doppler-functions/`             | `src/user-guide/password-managers/doppler.md`                                  |
| ejson               | `ejson-functions/`               | `src/user-guide/password-managers/ejson.md`                                    |
| gopass              | `gopass-functions/`              | `src/user-guide/password-managers/gopass.md`                                   |
| KeePassXC           | `keepassxc-functions/`           | `src/user-guide/password-managers/keepassxc.md`                                |
| Keeper              | `keeper-functions/`              | `src/user-guide/password-managers/keeper.md`                                   |
| Keyring             | `keyring-functions/`             | `src/user-guide/password-managers/keychain-and-windows-credentials-manager.md` |
| LastPass            | `lastpass-functions/`            | `src/user-guide/password-managers/lastpass.md`                                 |
| pass                | `pass-functions/`                | `src/user-guide/password-managers/pass.md`                                     |
| Passhole            | `passhole-functions/`            | `src/user-guide/password-managers/passhole.md`                                 |
| Proton Pass         | `protonpass-functions/`          | `src/user-guide/password-managers/proton-pass.md`                              |
| Vault (HashiCorp)   | `vault-functions/`               | `src/user-guide/password-managers/vault.md`                                    |
| Generic secret cmd  | `secret-functions/`              | `src/user-guide/password-managers/custom.md`                                   |
| GitHub              | `github-functions/`              | —                                                                              |

## Source state prefixes/suffixes

Defined in `src/reference/source-state-attributes.md`. Quick reference:

| Prefix/suffix        | Meaning                                            |
| -------------------- | -------------------------------------------------- |
| `dot_`               | Target starts with `.`                             |
| `private_`           | Permissions 0o600/0o700                            |
| `executable_`        | Permissions +x                                     |
| `readonly_`          | Read-only permissions                              |
| `encrypted_`         | Decrypt before applying                            |
| `modify_`            | Modify script (receives current contents on stdin) |
| `create_`            | Only create if target doesn't exist                |
| `remove_`            | Remove target                                      |
| `run_`               | Script to execute                                  |
| `once_`              | Run script only once                               |
| `onchange_`          | Run script only when contents change               |
| `before_` / `after_` | Script ordering                                    |
| `symlink_`           | Create symlink                                     |
| `literal_`           | Disable `.tmpl` interpretation                     |
| `.tmpl` suffix       | Template — evaluate before applying                |

## Special files

All at `src/reference/special-files/<name>.md`:

| File                     | Purpose                               |
| ------------------------ | ------------------------------------- |
| `.chezmoiignore`         | Patterns to exclude from target       |
| `.chezmoiremove`         | Files to remove from target           |
| `.chezmoiroot`           | Override source directory root         |
| `.chezmoiversion`        | Minimum chezmoi version               |
| `.chezmoiexternal.<fmt>` | Pull files from URLs/archives         |
| `.chezmoi.<fmt>.tmpl`    | Config file template (used by `init`) |
| `.chezmoidata.<fmt>`     | Data files (TOML/YAML/JSON)           |

## Special directories

All at `src/reference/special-directories/<name>.md`:

| Directory            | Purpose                              |
| -------------------- | ------------------------------------ |
| `.chezmoiscripts/`   | Scripts to run on `apply`            |
| `.chezmoitemplates/` | Reusable template partials           |
| `.chezmoiexternals/` | External file definitions            |
| `.chezmoidata/`      | Data directory (multiple data files) |

## Searching tips

- Grep for function names, config keys, or attribute prefixes to find the right file fast
- `src/reference/commands/index.md` has a categorized table of all commands
- Template variables available in `.tmpl` files: `src/reference/templates/variables.md`
- Init-time only functions (prompts, etc.): `src/reference/templates/init-functions/`
- Config file format is TOML/YAML/JSON; keys documented in `src/reference/configuration-file/`
