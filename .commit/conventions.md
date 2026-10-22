# Commit conventions

## Changelog

- `CHANGELOG.md` is a plain version list with no link section and no `[Unreleased]`
  heading originally; new work goes under `## [Unreleased]` above the newest
  release, per Keep a Changelog.
- Entries are user-facing English bullets, one line each, with no commit or PR
  references. A patch that keeps the released version number (this repo ships
  prebuilt DLLs) still lands under `Unreleased`.

## Gotchas

- This working copy is a delivery folder: it contains the compiled
  `Landoria.StructureProtection.dll` plus docs, not the C# sources. There is no
  build or test step to run here.
- `manifest.json` holds the Thunderstore version; it stays at `1.0.6` for patches
  to that release.
- No `.gitignore` exists; everything in the folder is intentional content.
