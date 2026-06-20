---
id: cmd-edit
title: "chezmoi edit"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/edit.md
related: [cmd-apply, cmd-add, cmd-diff]
---

## Summary

Opens the source state of target files in your editor. Handles encrypted file decryption/re-encryption transparently and can optionally apply changes immediately after editing.

## Syntax / Usage

```sh
chezmoi edit [flags] [target...]
```

If no targets are given, the working tree of the source directory is opened in the editor.

## Details

Targets must be files or symlinks. Encrypted files are decrypted to a private temporary directory; the editor opens the decrypted version. When the editor exits, the edited file is re-encrypted and replaces the original in the source state.

If the operating system supports hard links, chezmoi invokes the editor with filenames matching the target filename (not the source filename), so the editor can detect the file type correctly. Templates retain their `.tmpl` extension. This behavior can be disabled with `--hardlink=false` or `edit.hardlink = false` in config.

Key flags:

- `-a`, `--apply` -- Apply the target immediately after editing. Ignored when no targets are specified. Does not apply scripts. Configuration: `edit.apply`.
- `--hardlink` *bool* -- Use hard links so the editor sees the target filename. Default: true. Configuration: `edit.hardlink`.
- `--watch` -- Automatically apply changes when files are saved (using filesystem notifications). Configuration: `edit.watch`.
- `-x`, `--exclude` *types* -- Exclude target types.
- `-i`, `--include` *types* -- Only include specified target types.
- `--init` -- Regenerate the config file from the config template before applying.

Limitations of `--watch`:

- Only available when targets are specified (not argument-free `chezmoi edit`).
- All edited files are applied when any file is saved.
- Only the edited files are watched, not dependent files (e.g., `.chezmoitemplates` or `include`d template files).
- Only works on operating systems supported by fsnotify.
- Only works if `edit.hardlink` is enabled and functional.

## Examples

```sh
# Edit the source for ~/.bashrc
chezmoi edit ~/.bashrc

# Edit and immediately apply
chezmoi edit ~/.bashrc --apply

# Open the entire source directory in your editor
chezmoi edit
```

## Caveats / Common Mistakes

- Hard links cannot be created across different filesystems. If your `tempDir` is on a different filesystem (e.g., a tmpfs at `/tmp`), the hardlink feature will not work and you should set `edit.hardlink = false`.
- The `--watch` flag only watches the edited files themselves, not any templates they include. Changes to `.chezmoitemplates` will not trigger a re-apply.
- You can use editor modelines (e.g., Vim modelines) to set syntax highlighting for template files that have a `.tmpl` extension.

## See Also

- cmd-apply
- cmd-add
- cmd-diff
