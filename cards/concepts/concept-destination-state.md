---
id: concept-destination-state
title: "Destination State"
category: concepts
tags: [concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/concepts.md
related: [concept-source-state, concept-target-state, concept-application-order]
---

## Summary

The destination state is the current actual state of all managed targets in the destination directory (usually your home directory `~`). It is what exists on disk right now, before chezmoi makes any changes.

## Details

The **destination directory** is the directory that chezmoi manages -- by default, your home directory (`~`). The destination state is the current contents, permissions, and types (file, directory, symlink) of all targets within that directory.

When you run `chezmoi apply`, chezmoi compares the destination state against the computed target state and makes the minimum changes required to bring the destination into alignment with the target.

The destination state also participates in computing the target state in certain cases:

- `create_` files: chezmoi checks whether the target already exists in the destination. If it does, its contents are left unchanged.
- `modify_` scripts: the current contents of the destination file are passed to the modify script on standard input.

chezmoi assumes that the destination state is not modified while chezmoi is running. Violating this assumption (e.g., by using a `run_before_` script to change files in the destination) leads to undefined behavior.

chezmoi only reads files from the destination state if they are needed to compute the target state, which is a performance optimization.

## Examples

See what the current destination state looks like compared to the target state:

```sh
chezmoi diff
```

Check the status of managed files (shows differences between source, target, and destination):

```sh
chezmoi status
```

Verify that the destination matches the target state without making changes:

```sh
chezmoi verify
```

## Caveats / Common Mistakes

- Do not modify destination files while chezmoi is running (e.g., from `run_before_` scripts). chezmoi's behavior is undefined if the destination state changes mid-execution.
- If you edit a destination file directly (outside of chezmoi), those changes will be overwritten on the next `chezmoi apply`. Use `chezmoi re-add` to pull changes back into the source state.

## See Also

- concept-source-state
- concept-target-state
- concept-application-order
