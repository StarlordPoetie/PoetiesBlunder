# Cursed Energy Secret - Current Tier Overview

## Tier 1
- Message: "You awaken to the flow of Cursed Energy."
- Grants `BlackFlash_Potential` (120% potential buff access).
- 10% chance to gain Domain Expansion.
- Sets `nextTierUp = 3`.

## Tier 2
- Message: "Your Cursed Energy control improves."
- 20% chance to gain Domain Expansion.
- Sets `nextTierUp = 3`.

## Tier 3
- Message: "Your Cursed Energy grows denser and more precise."
- Clears Black Flash T3+ style upgrades (`Sparks of Black` disabled and `BlackFlash_SureStrike` removed if present).
- 35% chance to gain Domain Expansion.
- Sets `nextTierUp = 4`.

## Tier 4
- Message: "Your Cursed Energy reaches a breakthrough: Domain Expansion is now yours by default."
- Clears `Sparks of Black`.
- Guarantees Domain Expansion grant.
- Sets `nextTierUp = 4`.

## Tier 5
- Message: "Your Domain mastery deepens."
- Clears `Sparks of Black`.
- Guarantees Domain Expansion grant.

## Domain Expansion defaults when granted by Cursed Energy
- Range: 20
- Shroud: OFF (`useShroud = FALSE`)
- Prompted to name the domain; fallback name is "Unnamed Domain".
- Floor icon: `WhiteTurfShift.dmi`

## Meditation-time Awakening Setup (first-time config)
- On meditation (tier 1+), player is prompted for Cursed Energy aura color.
- Player is auto-assigned one unique trait from: Serrated, Electricity, Slash.
- Trait assignment is globally unique via `cursed_energy_taken_traits`.

## Trait hit effects
- Serrated: applies Shearing + Shatter.
- Electricity: applies Shock + Burn.
- Slash: applies Crippling + Shearing.
