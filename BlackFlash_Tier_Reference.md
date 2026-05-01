# Black Flash (Secret) Tier Reference

Extracted from `Secrets/_ManagementSecret.dm` and `Secrets/BlackFlash/skills.dm`.

## Tiers 1–5

- **Tier 1**
  - Grants the core Black Flash potential buff skill (`BlackFlash_Potential`).
  - Sets base Black Flash chance to **5%**.

- **Tier 2**
  - Sets base Black Flash chance to **15%**.

- **Tier 3**
  - Sets base Black Flash chance to **25%**.
  - Enables **Sparks of Black** (50% chance for Black Flash chance not to reset on proc).

- **Tier 4**
  - Sets base Black Flash chance to **35%**.

- **Tier 5**
  - Sets base Black Flash chance to **50%**.
  - Grants **Black Flash SureStrike** (5-second slotless buff that forces Black Flash chance to 100%).

## Core Black Flash Potential Buff

When active, `BlackFlash_Potential` grants **120% multipliers** to key combat stats (Str/For/End/Spd/Def/Off), and lasts **90 ticks/seconds-equivalent by timer config** in source.
