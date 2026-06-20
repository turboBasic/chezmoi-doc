---
id: script-overview
title: "Scripts in chezmoi: run_, run_once_, run_onchange_"
category: scripts
tags: [script, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/use-scripts-to-perform-actions.md
related: [script-ordering, script-templates, script-environment]
---

## Summary

chezmoi supports scripts prefixed with `run_` that execute during `chezmoi apply`. Scripts can run every time, only once per unique content, or only when their contents change, providing hooks for actions like package installation.

## Syntax / Usage

```text
run_<name>                  # runs every apply
run_once_<name>             # runs once per unique content (SHA256 tracked)
run_onchange_<name>         # runs only when content changes since last successful run
```

Scripts must include a `#!` shebang line or be an executable binary. There is no need to set the executable bit in the source directory.

## Details

- **`run_` scripts** execute every time `chezmoi apply` runs.
- **`run_once_` scripts** are tracked by SHA256 hash of their content. If the script is a template, the hash is computed after template execution. Even if renamed, the script will not re-run unless its rendered content changes.
- **`run_onchange_` scripts** re-run only when their content has changed since the last successful execution.
- All scripts should be idempotent, including `run_once_` and `run_onchange_` scripts.
- Scripts break chezmoi's declarative model and should be used sparingly.
- Scripts are generated in a temporary directory with the executable bit set and executed via `exec(3)`.
- The working directory is set to the equivalent location in the destination directory. If that does not exist, chezmoi walks up the hierarchy to the first existing directory.
- In verbose mode, script contents are printed before execution. In dry-run mode, scripts are not executed.
- Scripts must be created manually in the source directory (e.g., via `chezmoi cd`).

### The `.chezmoiscripts/` directory

If a `.chezmoiscripts/` directory exists at the root of the source directory, scripts inside it execute normally but do not create a corresponding directory in the target state. The `run_` prefix is still required.

## Examples

A package installation script that runs only when its contents change:

```sh title="~/.local/share/chezmoi/run_onchange_install-packages.sh"
#!/bin/sh
sudo apt install ripgrep
```

A `run_onchange_` script that re-runs when an external file changes (by embedding its hash):

```text title="~/.local/share/chezmoi/run_onchange_dconf-load.sh.tmpl"
#!/bin/bash

# dconf.ini hash: {{ include "dconf.ini" | sha256sum }}
dconf load / < {{ joinPath .chezmoi.sourceDir "dconf.ini" | quote }}
```

### Clearing script state

```sh
# Clear run_onchange_ state
chezmoi state delete-bucket --bucket=entryState

# Clear run_once_ state
chezmoi state delete-bucket --bucket=scriptState
```

## Caveats / Common Mistakes

- Forgetting the shebang line causes the script to fail since chezmoi uses `exec(3)`.
- `run_once_` tracks content hash, not filename. Renaming without changing content will not cause re-execution.
- Scripts that modify the source or destination state during execution violate chezmoi's assumptions and produce undefined behavior.

## See Also

- script-ordering
- script-templates
- script-environment
