---
id: cmd-chattr
title: "chezmoi chattr -- Change source state attributes"
category: commands
tags: [command, permissions]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/chattr.md
related: [cmd-managed]
---

## Summary

Changes the attributes and/or type of targets in the source state by renaming source files to add or remove attribute prefixes. This is the primary way to toggle properties like `executable`, `private`, `template`, `encrypted`, etc.

## Syntax / Usage

```sh
chezmoi chattr modifier target...
chezmoi chattr -- -modifier target...
```

## Details

Add attributes by specifying them directly or with a `+` prefix. Remove attributes by prefixing with `no` or `-`.

Attribute modifiers and abbreviations:

| Attribute modifier | Abbreviation |
| ------------------ | ------------ |
| `after`            | `a`          |
| `before`           | `b`          |
| `empty`            | `e`          |
| `encrypted`        | (none)       |
| `exact`            | (none)       |
| `executable`       | `x`          |
| `external`         | (none)       |
| `once`             | `o`          |
| `onchange`         | (none)       |
| `private`          | `p`          |
| `readonly`         | `r`          |
| `remove`           | (none)       |
| `template`         | `t`          |

Type modifiers (change the entry type):

| Type modifier |
| ------------- |
| `create`      |
| `modify`      |
| `script`      |
| `symlink`     |

The negative form of type modifiers (e.g. `nocreate`) changes the target back to a regular file if it is of that type.

Multiple modifications can be separated by commas. When using `-modifier` form, place it after `--` to prevent chezmoi from interpreting it as a flag.

Flags:
- `-r`, `--recursive` -- apply recursively (default: false)

## Examples

```sh
# Make .bashrc a template
chezmoi chattr template ~/.bashrc

# Remove the empty attribute from .profile
chezmoi chattr noempty ~/.profile

# Add both private and template attributes
chezmoi chattr private,template ~/.netrc

# Remove executable using minus syntax (note the --)
chezmoi chattr -- -x ~/.zshrc

# Add create and private attributes
chezmoi chattr +create,+private ~/.kube/config
```

## Caveats / Common Mistakes

- The `-modifier` form requires `--` before it so chezmoi does not interpret it as a command-line flag.
- `chattr` renames files in the source directory; this shows up as a rename in git.

## See Also

- cmd-managed
