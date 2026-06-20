---
id: cmd-doctor
title: "chezmoi doctor -- Check for potential problems"
category: commands
tags: [command, troubleshooting]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/doctor.md
related: [cmd-verify, cmd-status]
---

## Summary

Runs a series of checks to detect potential problems with the chezmoi installation, configuration, and environment. First command to run when troubleshooting.

## Syntax / Usage

```sh
chezmoi doctor [--no-network]
```

## Details

`chezmoi doctor` checks for issues such as missing executables, misconfigured encryption, permission problems, and version incompatibilities. It prints a table of checks with ok/warning/error status for each.

The `--no-network` flag disables any checks that require network connectivity.

## Examples

```sh
# Run all checks
chezmoi doctor

# Run checks without network access
chezmoi doctor --no-network
```

## See Also

- cmd-verify
- cmd-status
