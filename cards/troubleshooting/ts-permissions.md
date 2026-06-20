---
id: ts-permissions
title: File permission issues with chezmoi
category: troubleshooting
tags: [troubleshooting, config, permissions]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/frequently-asked-questions/troubleshooting.md
related: [ts-doctor]
---

## Summary

chezmoi uses the system umask when creating files, which can cause unexpected group-writable permissions (e.g., on `~/.ssh/config`) on systems with a `002` umask. The fix is to set the `umask` configuration variable or use source-state attributes like `private_` to control permissions.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
umask = 0o022
```

Source-state permission prefixes:

| Prefix        | Effect                    |
| ------------- | ------------------------- |
| `private_`    | Sets permissions to 0o600 (files) or 0o700 (directories) |
| `executable_` | Adds execute bit (+x)     |
| `readonly_`   | Sets read-only permissions |

## Details

### Group-writable files (umask 002)

On systems where the default umask is `002` (common on some Linux distributions), files and directories created by chezmoi are group-writable. This causes problems with SSH, which refuses to use a group-writable `~/.ssh/config`.

Setting `umask = 0o022` in the chezmoi configuration ensures no managed files are group-writable. This applies globally to all chezmoi-managed files; per-file group-write control is not currently supported.

### Script execution permission denied

The error `fork/exec /tmp/XXXXXXXXXX.XX: permission denied` occurs when the temporary directory (`$TMPDIR`) is mounted with the `noexec` option. Since chezmoi writes scripts to temp files before executing them (to handle templates and encryption), `noexec` on the temp directory blocks execution.

The fix is to configure an alternative temporary directory for script execution:

```toml title="~/.config/chezmoi/chezmoi.toml"
scriptTempDir = "~/tmp"
```

### Private files via source-state attributes

To mark files as private in chezmoi, use the `private_` prefix in the source state filename or run:

```sh
chezmoi chattr +private ~/.ssh/config
```

This sets the file permissions to 0o600 (or 0o700 for directories), overriding the umask for that specific entry.

## Examples

Fix group-writable permissions globally:

```toml title="~/.config/chezmoi/chezmoi.toml"
umask = 0o022
```

Fix script execution on noexec tmpdir:

```toml title="~/.config/chezmoi/chezmoi.toml"
scriptTempDir = "~/tmp"
```

Make `~/.ssh/config` private (0o600):

```sh
chezmoi chattr +private ~/.ssh/config
```

This renames the source file to include the `private_` prefix (e.g., `private_dot_ssh/private_config`).

Verify file permissions in target state:

```sh
chezmoi diff ~/.ssh/config
```

## Caveats / Common Mistakes

- The `umask` setting applies to ALL chezmoi-managed files and directories. There is no per-file umask override.
- The `private_` prefix sets exact permissions (0o600/0o700), not a mask. It does not interact with the `umask` setting.
- The `scriptTempDir` directory must exist before chezmoi tries to use it. Ensure it is created (e.g., via a `run_before_` script or manually).
- On systems installed via snap, permission errors on `/dev/stdin` or `/dev/stdout` during shell redirection are a snap bug, not a chezmoi bug. Use pipe alternatives or install chezmoi via a different method.

## See Also

- ts-doctor
