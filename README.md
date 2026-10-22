# Structure Protection (patched recompilation)

> **This is not the original mod.** Structure Protection was created by
> [Landoria Gaming](https://github.com/landoria-gaming/LandoriaMods). This
> repository is an unofficial recompiled build of their release containing fixes
> for problems in the original build. It is maintained by
> [srnoob2570](https://github.com/srnoob2570), with AI assistance, and is not
> affiliated with or endorsed by Landoria Gaming. Report problems with the patch
> here; report problems with the mod itself to the original project.

Prevents creatures from deliberately targeting structures whose creator is offline and blocks player damage to structures inside active wards.

## About this build

This is a recompilation of the original 1.0.6 release plus targeted fixes.

- Fixed the leaked `Landoria_CharacterActivity` ZDO retries that filled the server log with `ZDO ... not used when creating object` warnings and grew memory over time. Root cause and verification: [FIX_PERFORMANCE.md](FIX_PERFORMANCE.md).
- The full list of changes is in [CHANGELOG.md](CHANGELOG.md).

The patch keeps the original assembly name and version, so it drops in as a replacement for the upstream DLL. Install it on the server and on every client, as described below.

## Valheim compatibility

Original mod release: 1.0.x (this patch targets 1.0.6).

## Features

- Creatures cannot deliberately target player-built structures while their creator is offline.
- An active ward blocks damage to structures from players who are neither the ward creator nor on its permitted-player list.
- The ward creator and players on its permitted-player list can still damage protected structures.
- Protection against damage from unauthorized players remains active while the ward creator or a permitted player is online.
- Each character can have up to five wards in the world by default.
- Active wards are disabled after 30 real calendar days since their creator was last seen online.

Dedicated-server administrators can configure the protections with these command-line switches:

- `--structure-protection-offline-creature-targeting true|false`
- `--structure-protection-ward-player-damage true|false`
- `--structure-protection-max-wards-per-character <number>`: defaults to `5`; use `-1` to disable the ward limit.
- `--structure-protection-ward-inactivity-days <number>`: defaults to `30`; use `-1` to disable inactivity checks.
- `--structure-protection-ward-inactivity-check-hours <number>`: defaults to `6` and must be at least `1`.

## Installation

Most of Landoria mods need to be installed also on the dedicated server, we show you in this video how to do it on windows:

[Setup a Valheim Modded dedicated server on Windows](https://youtu.be/X5J1wSRr7Uo)

| Crossplay support | Steam network support |
|---|---
| Yes | No

| Client required | Server required (dedicated) | Player-hosted server |
|---|---|---|
| Yes | Yes | Not Supported |

Install matching versions of Structure Protection on the server and every participating client.


## Contact

- Patch issues and questions: [this repository's issues](https://github.com/srnoob2570/Landoria-StructureProtection-patched/issues).
- Original mod bugs and discussions: [LandoriaMods issues](https://github.com/landoria-gaming/LandoriaMods/issues) and [discussions](https://github.com/landoria-gaming/LandoriaMods/discussions).

All Landoria mods are used on the [Landoria Valheim public servers](https://valheim.landoria-gaming.com/).
