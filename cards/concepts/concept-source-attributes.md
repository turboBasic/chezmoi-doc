---
id: concept-source-attributes
title: "Source State Attributes (File Naming Conventions)"
category: concepts
tags: [concept, file-type, permissions, symlink, script]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/source-state-attributes.md
related: [concept-source-state, concept-target-state, concept-application-order]
---

## Summary

chezmoi encodes file attributes (permissions, type, behavior) in source file names using special prefixes and suffixes. These attributes control how each source entry is interpreted and applied to the destination.

## Details

All target types except directories are represented as regular files in the source state. The filename prefixes and suffixes determine what type of target is created and what properties it has.

### Prefixes

| Prefix | Effect |
|---|---|
| `dot_` | Target name starts with `.` (e.g., `dot_bashrc` becomes `.bashrc`) |
| `private_` | Remove all group and world permissions (0600 for files, 0700 for dirs) |
| `readonly_` | Remove all write permission bits |
| `executable_` | Add executable permission bits |
| `encrypted_` | File is encrypted in the source state |
| `empty_` | Ensure the file exists even if empty (by default, empty files are removed) |
| `exact_` | Remove entries in destination not managed by chezmoi (directories only) |
| `create_` | Only create the file if it does not already exist |
| `modify_` | Treat contents as a script that modifies the existing file |
| `remove_` | Remove the entry from the destination |
| `run_` | Treat contents as a script to execute |
| `once_` | Only run script if same contents have not succeeded before |
| `onchange_` | Only run script if contents changed (even if same contents ran before) |
| `before_` | Run script before updating the destination |
| `after_` | Run script after updating the destination |
| `symlink_` | Create a symbolic link instead of a regular file |
| `external_` | Ignore attributes in child entries (directories only) |
| `literal_` | Stop parsing prefix attributes (escape hatch for conflicting names) |

### Suffixes

| Suffix | Effect |
|---|---|
| `.tmpl` | Interpret file contents as a Go template |
| `.literal` | Stop parsing suffix attributes |
| `.age` / `.asc` | Stripped from encrypted files (age/gpg respectively) |

### Prefix order by target type

| Target type | Allowed prefixes (in order) |
|---|---|
| Directory | `remove_`, `external_`, `exact_`, `private_`, `readonly_`, `dot_` |
| Regular file | `encrypted_`, `private_`, `readonly_`, `empty_`, `executable_`, `dot_` |
| Create file | `create_`, `encrypted_`, `private_`, `readonly_`, `empty_`, `executable_`, `dot_` |
| Modify file | `modify_`, `encrypted_`, `private_`, `readonly_`, `executable_`, `dot_` |
| Remove file | `remove_`, `dot_` |
| Script | `run_`, `once_` or `onchange_`, `before_` or `after_` |
| Symbolic link | `symlink_`, `dot_` |

Attributes can be changed by renaming the source file directly or using the `chezmoi chattr` command.

## Examples

A private executable dotfile template:

```
~/.local/share/chezmoi/private_executable_dot_my-script.tmpl
# Becomes ~/.my-script with mode 0700 (private + executable)
```

A create-only file (will not overwrite existing):

```
~/.local/share/chezmoi/create_dot_config/myapp/config.toml
# Creates ~/.config/myapp/config.toml only if it doesn't exist
```

A script that runs once before other changes:

```
~/.local/share/chezmoi/run_once_before_install-packages.sh.tmpl
```

A symlink defined by its target path:

```
~/.local/share/chezmoi/symlink_dot_vimrc
# Contents: ".config/nvim/init.vim" (the symlink target)
```

Change attributes using chattr:

```sh
chezmoi chattr +private,+executable ~/.bashrc
```

A file with a name that conflicts with chezmoi attributes (using literal_ escape):

```
~/.local/share/chezmoi/literal_dot_private_notes.txt
# Becomes .private_notes.txt (literal_ stops further prefix parsing)
```

## Caveats / Common Mistakes

- Prefix order matters. Prefixes must appear in the documented order for each target type or they will not be recognized correctly.
- Empty files are removed by default. Use the `empty_` prefix if you want to keep a zero-byte file in the destination.
- The `exact_` prefix on directories causes chezmoi to **delete** unmanaged entries within that directory. Use with caution.
- `run_once_` checks script contents, not filename. Changing the script body will cause it to re-run; renaming it will not.
- `run_onchange_` also checks contents but will re-run even if the same contents previously succeeded (unlike `run_once_` which tracks by content hash across all filenames).

## See Also

- concept-source-state
- concept-target-state
- concept-application-order
