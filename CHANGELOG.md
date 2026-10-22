# Changelog

## [Unreleased]

### Changed

- Publish this patched recompilation under its own Thunderstore package, `StructureProtection-patched`, with numbering restarted at 1.0.0.

### Fixed

- Stop the repeated `ZDO ... not used when creating object Landoria_CharacterActivity` log spam and the leaked inactive objects behind it.

## 1.0.6

- Migration to Valheim 1.0.x.

## 1.0.4

- Updated documentation

## 1.0.2

- Keep warded structures protected from unauthorized player attacks while permitted players are online.
- Limit each character to five wards by default, with a dedicated-server command-line override.
- Disable active wards when their character has no recent recorded connection.

## 1.0.1

- Clarify boolean command-switch syntax in the documentation.

## 1.0.0

- Protect unattended structures from deliberate creature targeting and warded player weapon damage.
