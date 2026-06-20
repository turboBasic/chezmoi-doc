---
id: concept-application-order
title: "Application Order"
category: concepts
tags: [concept, script]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/application-order.md
related: [concept-source-state, concept-target-state, concept-destination-state, concept-source-attributes]
---

## Summary

chezmoi applies changes in a deterministic order: before-scripts first (alphabetically), then all entries in alphabetical order by target name (directories before their contents), then after-scripts (alphabetically). This predictable ordering ensures reproducible results across runs.

## Details

The full application sequence is:

1. Read the source state.
2. Read the destination state.
3. Compute the target state.
4. Run `run_before_` scripts in alphabetical order.
5. Update entries (files, directories, externals, scripts, symlinks, etc.) in alphabetical order of their **target name**. Directories (including those created by externals) are updated before the files they contain.
6. Run `run_after_` scripts in alphabetical order.

Target names are determined **after** all attribute prefixes and suffixes are stripped. This means the source filename `modify_dot_beta` has target name `.beta`, and `create_alpha` has target name `alpha`. Since `.beta` sorts before `alpha` in ASCII order, `.beta` is updated first.

Scripts without a `before_` or `after_` attribute are executed in ASCII order of their target names, interleaved with files, directories, and symlinks during step 5.

### Assumptions

chezmoi assumes that neither the source state nor the destination state is modified while chezmoi is running. This allows performance optimizations (lazy reads). Violating this assumption leads to undefined behavior.

Specifically:
- A `run_before_` script must NOT modify files in the source or destination state.
- External sources are updated during the update phase (step 5), so `run_before_` scripts should not depend on externals.
- `run_after_` scripts may freely depend on externals since they run after all updates complete.

## Examples

Given these source entries:

```
create_alpha
modify_dot_beta
run_once_before_setup.sh
run_after_cleanup.sh
exact_dot_c/
```

The execution order is:

1. `run_once_before_setup.sh` executes (before-script)
2. `.beta` is updated (`.beta` < `.c` < `alpha` in ASCII)
3. `.c/` directory is updated
4. `alpha` is created
5. `run_after_cleanup.sh` executes (after-script)

Another example -- controlling script order with naming:

```
run_once_before_01-install-homebrew.sh
run_once_before_02-install-packages.sh
run_once_before_03-configure-defaults.sh
```

These run in the order 01, 02, 03 because chezmoi sorts them alphabetically.

## Caveats / Common Mistakes

- Do not rely on `run_before_` scripts to set up externals or modify the source/destination state. The results are undefined.
- The sort is ASCII-based, not locale-aware. Dotfiles (`.` = 0x2E) sort before letters and digits, which can be surprising.
- Numbering scripts (e.g., `01-`, `02-`) is a common pattern to enforce explicit ordering within before/after groups.

## See Also

- concept-source-state
- concept-target-state
- concept-destination-state
- concept-source-attributes
