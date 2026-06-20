---
id: recipe-file-types
title: Managing Different File Types
category: recipes
tags: [recipe, file-type, symlink, permissions, script]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/manage-different-types-of-file.md
related: [recipe-quick-start, recipe-ignore]
---

## Summary

chezmoi supports multiple file management strategies beyond simple copying: create-only files, modify scripts, symlinks, permission-only management, and file removal. Each strategy is indicated by source state filename prefixes.

## Syntax / Usage

| Source prefix | Behavior |
|---|---|
| (none) | Regular file -- overwrite target with source contents |
| `create_` | Create file only if target does not exist |
| `modify_` | Script that receives current contents on stdin, writes new contents to stdout |
| `symlink_` | Create a symlink (file contents = link target path) |
| `remove_` | Remove the target file |
| `private_` | Set permissions to 0600 (file) or 0700 (directory) |
| `executable_` | Add execute permission |
| `readonly_` | Set read-only permissions |

## Details

**Create-only files** (`create_` prefix): chezmoi creates the file if it does not exist but never overwrites existing content. Permission attributes (`executable_`, `private_`, `readonly_`) are still applied even if the file exists.

**Modify scripts** (`modify_` prefix): The script receives the current file contents on stdin and chezmoi reads the new contents from stdout. If the target file does not exist, stdin is empty and the script must write complete contents. Modify scripts containing the string `chezmoi:modify-template` are treated as templates with `.chezmoi.stdin` providing current file contents.

**Symlinks** (`symlink_` prefix): The file contents in the source state specify the symlink target. Can be combined with `.tmpl` for dynamic link targets.

**Removing files**: Use `.chezmoiremove` with patterns, or individual `remove_` prefixed entries. Run `chezmoi apply --dry-run --verbose` first to preview removals.

**Permission management without content**: An empty file with `private_` prefix (e.g., `dot_kube/private_config`) ensures target permissions are 0600 without changing contents. The file will be created if it does not exist.

## Examples

Manage part of a file using a modify template:

```text title="~/.local/share/chezmoi/modify_dot_config/some-app/config.json"
{{- /* chezmoi:modify-template */ -}}
{{ fromJson .chezmoi.stdin | setValueAtPath "key.nestedKey" "value" | toPrettyJson }}
```

Replace a string in an existing file:

```text title="~/.local/share/chezmoi/modify_dot_someconfig"
{{- /* chezmoi:modify-template */ -}}
{{- .chezmoi.stdin | replaceAllRegex "old" "new" }}
```

Create a dynamic symlink for externally-modified config files:

```text title="~/.local/share/chezmoi/private_dot_config/private_Code/User/symlink_settings.json.tmpl"
{{ .chezmoi.sourceDir }}/settings.json
```

Ensure `~/.kube/config` has 0600 permissions (create empty private source file):

```sh
mkdir -p $(chezmoi source-path)/dot_kube
touch $(chezmoi source-path)/dot_kube/private_config
```

Create a directory that chezmoi manages (but ignore contents):

```sh
mkdir -p $(chezmoi source-path)/src
touch $(chezmoi source-path)/src/.keep
```

Populate `~/.ssh/authorized_keys` from GitHub:

```text title="~/.local/share/chezmoi/dot_ssh/authorized_keys.tmpl"
{{ range gitHubKeys "$GITHUB_USERNAME" -}}
{{   .Key }}
{{ end -}}
```

## Caveats / Common Mistakes

- Modify templates must NOT have a `.tmpl` extension. The `chezmoi:modify-template` marker inside the file is sufficient.
- If a modify script's target does not exist, stdin will be empty. The script must handle this case and produce valid output.
- Using `create_` with an empty file means chezmoi will create an empty file if the target is missing. Combine with `private_` to manage permissions of files that may or may not exist.
- For permission-only management where you do NOT want to create the file if missing, use a `run_` script instead.

## See Also

- recipe-quick-start
- recipe-ignore
