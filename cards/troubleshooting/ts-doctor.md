---
id: ts-doctor
title: Using chezmoi doctor to diagnose issues
category: troubleshooting
tags: [troubleshooting, command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/frequently-asked-questions/troubleshooting.md
related: [ts-diff-broken, ts-edit-blank, ts-template-errors, ts-permissions]
---

## Summary

`chezmoi doctor` runs a series of checks on your system and reports potential problems that could affect chezmoi operation. It is the first command to run when something is not working as expected.

## Syntax / Usage

```sh
chezmoi doctor
```

Flags:

```sh
chezmoi doctor --no-network
```

`--no-network` skips checks that require network access.

## Details

The output uses three severity levels:

| Status    | Meaning                                                       |
| --------- | ------------------------------------------------------------- |
| `ok`      | No problem detected                                           |
| `warning` | Only a problem if you use the related feature                 |
| `error`   | Definite problem that needs attention                         |

For more targeted debugging of a specific command, use the `--verbose` flag to print extra information about what chezmoi is doing, or the `--debug` flag for very detailed step-by-step output.

## Examples

Basic diagnostic check:

```sh
chezmoi doctor
```

Skip network checks (useful in air-gapped environments):

```sh
chezmoi doctor --no-network
```

Debugging a specific command that misbehaves:

```sh
chezmoi --verbose apply
chezmoi --debug apply
```

## Caveats / Common Mistakes

- A `warning` does not necessarily mean something is broken. It only matters if you rely on the feature being checked (e.g., a missing password manager binary is fine if you do not use that manager).
- The `--verbose` and `--debug` flags are global flags that go before the subcommand, not after.

## See Also

- ts-diff-broken
- ts-edit-blank
- ts-template-errors
- ts-permissions
