---
id: config-interpreters
title: Script Interpreter Configuration
category: configuration
tags: [config, script]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/configuration-file/interpreters.md
related: [config-file, config-hooks]
---

## Summary

chezmoi uses file extensions to determine which interpreter runs scripts and hook scripts. Default interpreters are provided for common languages, and you can add or override them in the configuration file.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
[interpreters.<extension>]
    command = "<interpreter-binary>"
    args = ["arg1", "arg2"]
```

The `<extension>` is the file extension without the leading dot.

## Details

### Default Interpreters

| Extension | Command   | Arguments       |
| --------- | --------- | --------------- |
| `.nu`     | `nu`      | (none)          |
| `.pl`     | `perl`    | (none)          |
| `.py`     | `python3` | (none)          |
| `.ps1`    | `pwsh`    | `-NoLogo -File` |
| `.rb`     | `ruby`    | (none)          |

### Windows Behavior

On Windows, scripts with `.bat`, `.cmd`, `.com`, and `.exe` extensions are executed natively. All other extensions require an interpreter in `%PATH%`.

### PowerShell

chezmoi defaults to PowerShell Core (`pwsh`) for `.ps1` scripts. On Windows, if `pwsh` is not available, it falls back to Windows PowerShell (`powershell`).

### Template Scripts

If a script has a `.tmpl` extension, chezmoi strips `.tmpl` and uses the next remaining extension to determine the interpreter. For example, `run_once_install.py.tmpl` uses the `.py` interpreter.

## Examples

Override Python interpreter and add Tcl:

```toml title="~/.config/chezmoi/chezmoi.toml"
[interpreters.py]
    command = "C:\\Python39\\python3.exe"
[interpreters.tcl]
    command = "tclsh"
```

Alternative inline TOML syntax:

```toml title="~/.config/chezmoi/chezmoi.toml"
[interpreters]
py = { command = "C:\\Python39\\python3.exe" }
tcl = { command = "tclsh" }
```

Explicitly use Windows PowerShell:

```toml title="~/.config/chezmoi/chezmoi.toml"
[interpreters.ps1]
    command = "powershell"
    args = ["-NoLogo"]
```

Add a bash interpreter for `.sh` scripts:

```toml title="~/.config/chezmoi/chezmoi.toml"
[interpreters.sh]
    command = "bash"
```

## Caveats / Common Mistakes

- The extension key must NOT include the leading dot: use `interpreters.py`, not `interpreters..py`.
- PowerShell Core (`pwsh`) must be installed separately on most systems. If missing and no override is configured, `.ps1` scripts will fail on non-Windows systems.
- The `args` array replaces the default arguments entirely -- if you override `.ps1` args, you lose the default `-NoLogo -File`.

## See Also

- config-file
- config-hooks
