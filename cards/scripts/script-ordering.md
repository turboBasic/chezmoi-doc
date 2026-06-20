---
id: script-ordering
title: "Script ordering: before_ and after_ attributes"
category: scripts
tags: [script, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/application-order.md
related: [script-overview, script-templates, script-environment]
---

## Summary

chezmoi scripts execute in a deterministic order controlled by the `before_` and `after_` attributes combined with alphabetical sorting. This allows scripts to run before or after dotfile updates.

## Syntax / Usage

```text
run_before_<name>              # runs before dotfile updates
run_after_<name>               # runs after dotfile updates
run_once_before_<name>         # runs once, before updates
run_once_after_<name>          # runs once, after updates
run_onchange_before_<name>     # runs on change, before updates
run_onchange_after_<name>      # runs on change, after updates
```

Prefix order for scripts: `run_`, then `once_` or `onchange_`, then `before_` or `after_`.

## Details

chezmoi's application order is:

1. Read the source state.
2. Read the destination state.
3. Compute the target state.
4. Run `run_before_` scripts in alphabetical order.
5. Update entries in the target state (files, directories, externals, scripts, symlinks) in alphabetical order of their target name. Directories are updated before the files they contain.
6. Run `run_after_` scripts in alphabetical order.

Scripts without `before_` or `after_` are considered "inline" and run during step 5 in alphabetical order alongside file updates. For example, `run_b.sh` runs after updating `a.txt` and before updating `c.txt`.

Target names are determined after all attributes are stripped. For example, given `create_alpha` and `modify_dot_beta`, `.beta` is updated before `alpha` because `.beta` sorts before `alpha`.

## Examples

Install a password manager before any dotfiles are applied:

```sh title="~/.local/share/chezmoi/run_once_before_install-password-manager.sh"
#!/bin/sh
if ! command -v op >/dev/null; then
  # install 1Password CLI
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor -o /usr/share/keyrings/1password-archive-keyring.gpg
  sudo apt install 1password-cli
fi
```

Reload a shell configuration after dotfiles are updated:

```sh title="~/.local/share/chezmoi/run_after_reload-shell.sh"
#!/bin/sh
exec zsh
```

## Caveats / Common Mistakes

- `run_before_` scripts must not depend on externals applied during the update phase (step 5). Use `run_after_` scripts for that.
- `run_before_` scripts must not modify the source or destination states; doing so violates chezmoi's assumptions and produces undefined behavior.
- Alphabetical ordering uses the full filename including prefixes, so naming matters for controlling execution order among scripts of the same phase.

## See Also

- script-overview
- script-templates
- script-environment
