---
id: script-templates
title: "Script templates: conditional execution with .tmpl"
category: scripts
tags: [script, template]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/use-scripts-to-perform-actions.md
related: [script-overview, script-ordering, script-environment]
---

## Summary

Scripts with the `.tmpl` suffix are treated as templates, enabling conditional execution and dynamic content. If a template resolves to only whitespace or an empty string, the script is not executed, providing a mechanism to disable scripts based on OS, hostname, or other conditions.

## Syntax / Usage

```text
run_once_<name>.sh.tmpl
run_onchange_before_<name>.sh.tmpl
run_<name>.py.tmpl
```

The `.tmpl` suffix is stripped to determine the interpreter (via the remaining extension). All standard chezmoi template variables and functions are available.

## Details

- Template variables (`.chezmoi.os`, `.chezmoi.arch`, `.chezmoi.hostname`, etc.) are available inside script templates.
- If the rendered output is empty or whitespace-only, the script is skipped entirely. This is the canonical way to conditionally disable a script.
- For `run_once_` scripts, the SHA256 hash used for deduplication is computed after template execution, meaning changes in template data (e.g., a new OS) will cause re-execution.
- For `run_onchange_` scripts, content change detection also happens after template rendering.
- The `include` function can be used to embed file contents (useful for triggering `run_onchange_` on external file changes via hash embedding).

## Examples

Install packages conditionally by OS:

```text title="~/.local/share/chezmoi/run_onchange_install-packages.sh.tmpl"
{{ if eq .chezmoi.os "linux" -}}
#!/bin/sh
sudo apt install ripgrep
{{ else if eq .chezmoi.os "darwin" -}}
#!/bin/sh
brew install ripgrep
{{ end -}}
```

A script that only runs on a specific machine:

```text title="~/.local/share/chezmoi/run_once_setup-work.sh.tmpl"
{{ if eq .chezmoi.hostname "work-laptop" -}}
#!/bin/sh
# Configure work-specific settings
git config --global user.email "me@company.com"
{{ end -}}
```

Re-run a script when a dependent file changes:

```text title="~/.local/share/chezmoi/run_onchange_dconf-load.sh.tmpl"
#!/bin/bash

# dconf.ini hash: {{ include "dconf.ini" | sha256sum }}
dconf load / < {{ joinPath .chezmoi.sourceDir "dconf.ini" | quote }}
```

## Caveats / Common Mistakes

- The shebang must be inside the template conditional, not before it. If the template renders to just a shebang with no actual commands, it will still execute (it is not whitespace-only).
- When using `{{ end -}}` (with dash), trailing newlines are trimmed. Without it, the script may contain trailing whitespace and still execute.
- Remember to add helper files (like `dconf.ini` in the hash example) to `.chezmoiignore` so they are not deployed to the target directory.

## See Also

- script-overview
- script-ordering
- script-environment
