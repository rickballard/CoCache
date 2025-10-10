# Backups Folder Structure

This folder contains versioned backup archives of the Cognocarta Consenti (CC) repository.
Backups are grouped by type to assist future maintainers in tracing past versions, recovering data, or validating the history of this constitution's evolution.

## Folders

### `archive/`
Contains committed milestone versions of the main scroll or repo at significant publication stages.  
Filenames follow: `CC_v1.0_YYYYMMDD.zip` or similar.

### `snapshots/`
Holds zipped snapshots of the full repo folder as it existed at a certain moment in time, often used before major changes.  
Filenames follow: `Civium-Repo-State_YYYYMMDD.zip`

### `scratchpad/`
Used for miscellaneous, possibly non-canonical or deprecated archive files that may still contain useful work or exploratory material.

## Notes

- All `.zip` files are now tracked via Git LFS.
- The `.gitkeep` file ensures the folder structure persists even if empty.
- Do not delete backups unless you are absolutely certain they are obsolete and stored elsewhere.

---

Maintainer: Rick Ballard  
Last updated: 2025-07-16