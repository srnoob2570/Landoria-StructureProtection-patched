# StructureProtection 1.0.6 performance fix

## What was wrong

The server log is dominated by this line:

```
ZDO 1:83 not used when creating object Landoria_CharacterActivity
```

10,497,122 of the 10,501,760 lines in the supplied log (99.96%) are that warning,
repeated for eight ZDO IDs (six from the current session and two left over from
an older session). The log is ~700 MB.

### Root cause

`CharacterActivityPrefab` registers an **inactive** prefab:

```csharp
GameObject prefab = new GameObject(Name);
prefab.SetActive(false);              // <-- the cause
ZNetView view = prefab.AddComponent<ZNetView>();
```

Valheim's `ZNetScene.CreateObject` does this:

1. sets `ZNetView.m_initZDO = zdo`;
2. calls `Instantiate(prefab)`;
3. if `m_initZDO` is still set, logs `ZDO ... not used when creating object ...`;
4. returns the instance without calling `ZNetScene.AddInstance`.

Because the prefab is inactive, the instantiated object is also inactive, so
`ZNetView.Awake` never runs. `Awake` is the method that consumes `m_initZDO`,
calls `AddInstance`, and sets `ZDO.Created = true`. As a result:

- `ZDO.Created` stays `false`;
- `ZNetScene.CreateDestroyObjects` (runs 30 times per second) sees the same ZDO
  as "not created" and calls `CreateObject` again;
- every attempt creates another inactive `GameObject` that is never tracked by
  `ZNetScene.m_instances` or destroyed, so it is leaked;
- every attempt writes the warning line to the log.

The activity records also use `StoragePosition = (100000, -10000, 100000)`.
Valheim clamps out-of-world sector coordinates to sector 0, so these records are
always in the sector around the server's reference position and are retried on
every `ZNetScene` cycle.

## Fix

Added a Harmony postfix to `ZNetScene.CreateObject` in
`CharacterActivityPrefab.cs`. It only acts for the
`Landoria_CharacterActivity` prefab and an inactive instance. It restores
`ZNetView.m_initZDO`, activates the instance so `ZNetView.Awake` consumes the
ZDO, and then clears the static state.

After that, `ZNetScene.AddInstance` is called, `ZDO.Created` becomes `true`, and
`ZNetScene` stops retrying and leaking the object.

On each server restart, the fix can still print one warning per existing
activity record (the supplied log shows eight), because the warning is emitted
before the postfix runs. Those lines are harmless and should not grow.

## Verification

- The patched assembly loads with its BepInEx and Valheim references resolved.
- The repository's Harmony target validator reports:
  `Harmony targets: 16 checked, 0 errors, 0 unverified.`
- The only added type is
  `CharacterActivityPrefab.ZNetSceneCreateObjectPatch`; the rest of the public
  and internal API is unchanged.
- The assembly name and version match the original
  (`Landoria.StructureProtection.shared`, `1.0.6.13986`).

## Install

1. Stop the Valheim server.
2. Replace `BepInEx/plugins/Landoria.StructureProtection.dll` on the server and
   on every client with the patched DLL.
3. Delete or rotate the old `AMPLOG_*.log`; it is almost entirely this warning.
4. Start the server and confirm the `ZDO ... not used when creating object
   Landoria_CharacterActivity` lines stop appearing.

The original DLL is kept next to the patched one as
`Landoria.StructureProtection.dll.original-1.0.6.bak`.
