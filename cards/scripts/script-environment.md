---
id: script-environment
title: "Script environment variables"
category: scripts
tags: [script, config, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/use-scripts-to-perform-actions.md
related: [script-overview, script-ordering, script-templates]
---

## Summary

chezmoi automatically sets `CHEZMOI*` environment variables when running scripts, corresponding to commonly-used template data variables. Additional variables can be injected via the `scriptEnv` configuration section.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
[scriptEnv]
    MY_VAR = "my_value"
    ANOTHER_VAR = "another_value"
```

## Details

### Automatic environment variables

chezmoi sets the following environment variables for every script execution:

- `CHEZMOI=1` — always set, indicates the script is running under chezmoi.
- `CHEZMOI_OS` — the operating system (corresponds to `.chezmoi.os` template variable).
- `CHEZMOI_ARCH` — the architecture (corresponds to `.chezmoi.arch` template variable).
- Other `CHEZMOI_*` variables corresponding to commonly-used template data variables.

### Custom environment variables via `scriptEnv`

The `scriptEnv` section in the configuration file allows setting arbitrary environment variables that are available to all scripts and hooks. This is useful for injecting configuration that scripts need without hardcoding values.

Extra environment variables can also be set via the `env` configuration variable.

### Working directory

Scripts run with their working directory set to the equivalent location in the destination tree. If that directory does not exist, chezmoi walks up the hierarchy to find the first existing parent directory.

### Interpreters

Scripts are executed using configured interpreters based on file extension. Default interpreters include:

| Extension | Command   | Arguments       |
| --------- | --------- | --------------- |
| `.nu`     | `nu`      | *none*          |
| `.pl`     | `perl`    | *none*          |
| `.py`     | `python3` | *none*          |
| `.ps1`    | `pwsh`    | `-NoLogo -File` |
| `.rb`     | `ruby`    | *none*          |

Interpreters can be added or overridden in the `interpreters` configuration section.

## Examples

Set environment variables for scripts:

```toml title="~/.config/chezmoi/chezmoi.toml"
[scriptEnv]
    GITHUB_TOKEN = "ghp_xxxxxxxxxxxx"
    DOTFILES_FLAVOR = "personal"
```

Use the environment variable in a script:

```sh title="~/.local/share/chezmoi/run_once_before_setup.sh"
#!/bin/sh
echo "Running on OS: $CHEZMOI_OS, Arch: $CHEZMOI_ARCH"
if [ "$DOTFILES_FLAVOR" = "personal" ]; then
    echo "Installing personal tools..."
fi
```

Configure a custom interpreter for Tcl scripts:

```toml title="~/.config/chezmoi/chezmoi.toml"
[interpreters.tcl]
    command = "tclsh"
```

## Caveats / Common Mistakes

- Do not store secrets directly in `scriptEnv` in plain text config files. Use a password manager template or encrypted config instead.
- The `CHEZMOI=1` variable can be used in shell profiles to detect when they are being sourced during a chezmoi apply, allowing you to skip interactive-only setup.
- Hiding scripts from `chezmoi diff` output requires setting `diff.exclude = ["scripts"]` in the config file; similarly `status.exclude = ["scripts"]` hides them from `chezmoi status`.

## See Also

- script-overview
- script-ordering
- script-templates
