---
id: config-merge
title: Merge Tool Configuration
category: configuration
tags: [config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/tools/merge.md
related: [config-file, config-diff, cmd-merge]
---

## Summary

chezmoi uses an external merge tool (defaulting to `vimdiff`) to resolve conflicts between destination, source, and target states. The merge command and arguments are fully configurable with template variables.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
[merge]
    command = "<merge-program>"
    args = ["{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]
```

## Details

### Configuration Keys

| Key       | Type     | Default    | Description                              |
| --------- | -------- | ---------- | ---------------------------------------- |
| `command` | string   | `vimdiff`  | Merge tool command                       |
| `args`    | []string | (varies)   | Arguments passed to the merge tool       |

### Template Variables in `args`

- `.Destination` -- path to the file in the destination state (current file on disk)
- `.Source` -- path to the file in the source state (in the chezmoi source directory)
- `.Target` -- path to the file in the target state (what chezmoi wants to apply)

The elements of `merge.args` are interpreted as Go templates with these variables available.

## Examples

Use neovim diff mode:

```toml title="~/.config/chezmoi/chezmoi.toml"
[merge]
    command = "nvim"
    args = ["-d", "{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]
```

Use Beyond Compare:

```toml title="~/.config/chezmoi/chezmoi.toml"
[merge]
    command = "bcomp"
    args = [
        "{{ .Destination }}",
        "{{ .Source }}",
        "{{ .Target }}",
        "{{ .Source }}"
    ]
```

Use VS Code merge:

```toml title="~/.config/chezmoi/chezmoi.toml"
[merge]
    command = "bash"
    args = [
        "-c",
        "cp {{ .Target | quote }} {{ printf \"%s.base\" .Target | quote }} && code --new-window --wait --merge {{ .Destination | quote }} {{ .Target | quote }} {{ printf \"%s.base\" .Target | quote }} {{ .Source | quote }}"
    ]
```

## Caveats / Common Mistakes

- If you generate the config from a template (`.chezmoi.toml.tmpl`), escape `{{` and `}}` using `{{ printf "%q" "{{ .Destination }}" }}` or similar constructs.
- The default merge tool is `vimdiff`. If it is not installed, `chezmoi merge` will fail unless you configure an alternative.
- The merge tool receives temporary file paths for `.Source` and `.Target`; edits to `.Source` will update the source state.

## See Also

- config-file
- config-diff
