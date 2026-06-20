---
id: ts-edit-blank
title: Blank buffer or empty file when running chezmoi edit
category: troubleshooting
tags: [troubleshooting, command, config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/frequently-asked-questions/troubleshooting.md
related: [ts-doctor, ts-template-errors]
---

## Summary

`chezmoi edit` opens a blank or empty file because the editor command exits immediately (forks to background), causing chezmoi to remove the temporary directory before the actual editor process opens the file.

## Syntax / Usage

```sh
chezmoi edit ~/.zshrc
```

Typical warning message:

```text
chezmoi: warning: $EDITOR $TMPDIR/$FILENAME: returned in less than 1s
```

## Details

`chezmoi edit` creates a temporary directory with hardlinks that have human-friendly filenames (matching target names rather than source-state names like `dot_zshrc`). When the editor command returns, chezmoi assumes editing is complete and cleans up the temporary directory.

If the editor command forks a background process and exits immediately, the background process tries to open a file that no longer exists, resulting in a blank buffer.

The fix is to configure the editor to stay in the foreground (block) until the file is closed.

Additional magic performed by `chezmoi edit`:

- File names in the temp directory match target names (e.g., `.zshrc` instead of `dot_zshrc`), helping editors choose correct syntax highlighting.
- Encrypted files are transparently decrypted before editing and re-encrypted on save.
- Template files preserve the `.tmpl` extension.

## Examples

Fix for Vim (pass `-f` to stay in foreground):

```toml title="~/.config/chezmoi/chezmoi.toml"
[edit]
    args = ["-f"]
```

Or via environment variable:

```sh
export EDITOR="vim -f"
```

Fix for VSCode (pass `--wait` to block until file is closed):

```toml title="~/.config/chezmoi/chezmoi.toml"
[edit]
    command = "code"
    args = ["--wait"]
```

Or via environment variable:

```sh
export EDITOR="code --wait"
```

## Caveats / Common Mistakes

- GUI editors (VSCode, Sublime Text, IntelliJ) almost always need a "wait" or "foreground" flag.
- Vim typically only needs `-f` when launched from certain terminal multiplexers or when `gvim` is used.
- If you use `chezmoi edit --apply`, the changes are applied immediately when the editor exits, so the foreground requirement is even more important to avoid applying empty content.

## See Also

- ts-doctor
- ts-template-errors
