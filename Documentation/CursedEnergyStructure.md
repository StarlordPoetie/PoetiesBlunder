# Cursed Energy Structure

This document records the current Cursed Energy architecture so future work can preserve the system instead of refactoring or renaming core hooks by accident.

## Files involved

- `Secrets/Cursed Secret/CursedEnergy.dm` is the main secret implementation. It defines `/SecretInformation/CursedEnergy`, player state variables, trait reservation helpers, awakening/setup, Heavy Strike/Toss/Reverse Dash overrides, Reverse Cursed Technique, Domain sure-hit support, Six Eyes/Infinite Void support, and cleanup.
- `Secrets/Cursed Secret/CursedTechniques.dm` defines the concrete Cursed Technique skill objects. These are mostly `/obj/Skills/Queue`, `/obj/Skills/AutoHit`, `/obj/Skills/Projectile`, and `/obj/Skills/Buffs/SlotlessBuffs` types with `CursedTechnique=1` and mana costs/drains.
- `Skills/_CursedEnergyBuffs.dm` defines the shared Domain Expansion object, Domain Expansion verbs, Simple Domain, Hollow Wicker Basket, and the Cursed Energy subtype of Domain Expansion.
- `Secrets/BlackFlash/skills.dm` and `Secrets/HeavyStrike/SecretHeavyStrike.dm` contain shared Black Flash/Divergent Fist skill behavior that Cursed Energy falls back to when no trait technique fires.
- `Secrets/HeavyStrike/_SecretHeavyStrikeUtility.dm` chooses the Black Flash or Divergent Fist replacement queue used by Cursed Energy fallback.
- `Skills/_QueueX.dm`, `Skills/_GrappleX.dm`, and `_1CodeFolder/Skills.dm` are the user-action hooks for Heavy Strike, Toss, and Reverse Dash. They call Cursed Energy override procs before normal behavior.
- `Skills/_BuffX.dm`, `_1CodeFolder/Gains.dm`, and `_1CodeFolder/_JinxUtility.dm` are central resource-consumption paths. They use `ManaAmount`, `LoseMana()`, `ManaCost`, and `ManaDrain`; Cursed Energy only renames/reduces this resource, it does not replace the underlying Mana storage.
- `_1CodeFolder/Chat&Verbs.dm` invokes Reverse Cursed Technique from the pose/training toggle.
- `_1CodeFolder/Creation.dm`, `_1CodeFolder/GainProcsOld.dm`, and `Secrets/_ManagementSecret.dm` revalidate or initialize the secret on creation/login/secret management paths.
- `_Reworks/Ags/AGDatabase.dm` exposes Cursed Energy users and trait slots in the admin Secret/Saga Database.
- `_1CodeFolder/AdminSecretSagaDatabase.dm` contains an older standalone Secret/Saga browser with similar Cursed Energy display/removal helper code, but the compiled `.dme` currently includes `_Reworks/Ags/AGDatabase.dm` for the live combined database.
- `_1CodeFolder/Customization.dm` applies the selected Cursed Energy aura color to the aura overlay.
- `_1CodeFolder/BattleSystem.dm` calls `cleanupCursedEnergy()` on death cleanup when the mob still has Cursed Energy state.

## Important types/classes

- `/SecretInformation/CursedEnergy` is the main secret datum. It sets `name = "Cursed Energy"`, `maxTier = 5`, grants `BlackFlash_Potential`, and owns tier progression behavior through `applySecret()`.
- `/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion` is the generic Domain Expansion skill with Wide/Target verbs and `releaseDomain()`.
- `/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy` is the Cursed Energy domain subtype. It applies Cursed Energy domain stats/drain and ticks Infinite Void for Spatial Manipulation users.
- `/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain` and `/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket` are anti-domain choices granted through Cursed Energy.
- Cursed Technique skill types are grouped in `CursedTechniques.dm` and include Gambler's Fist, Dismantle/Cleave, Voltage Strike, Limitless/Red/Blue/Hollow Purple, Disaster Flames/Volcanic Strike/Maximum Meteor, and domain sure-hit variants.
- Black Flash fallback uses `/obj/Skills/Queue/Secret_Heavy_Strike/Black_Flash/Black_Flash_Strike` and `/obj/Skills/Queue/Secret_Heavy_Strike/Black_Flash/Divergent_Fist`.

## Important variables

Do not casually rename these because they are read across admin tools, login/setup paths, skill hooks, cleanup, and persisted player state:

- `Secret` and `secretDatum` identify the active secret and point at `/SecretInformation/CursedEnergy`.
- `cursedEnergyAuraColor` stores the player-selected aura color.
- `cursedEnergyTrait` stores the chosen unique trait name.
- `cursedEnergyTraitSlot` stores the reserved trait slot key for cleanup and validation.
- `cursedEnergyTraitPassivesApplied` records passive bonuses currently applied from the trait so they can be removed safely.
- `cursedEnergySpecialization` stores the tier-2 specialization.
- `cursedEnergySpecializationPassiveMigrated` prevents old permanent specialization passives from being removed repeatedly after the Ki Control migration.
- `cursedEnergyDomainChoice` stores whether the player chose Simple Domain or Hollow Wicker Basket.
- `cursedEnergyPoseHealReady` and `cursedEnergyPoseHealCooldown` control Reverse Cursed Technique availability.
- `cursedEnergySixEyes`, `cursedEnergySixEyesOverlay`, and `cursedEnergyInfiniteVoidEscapes` support Spatial Manipulation/Six Eyes/Infinite Void behavior.
- Global `cursed_energy_taken_traits` maps trait names to owner ckeys and enforces unique trait slots.
- `/obj/Skills` var `CursedTechnique` marks skills for Cursed Energy mana-drain reduction.
- Active Ki Control buffs use `cursedEnergySpecializationPassivesApplied` to track specialization passives injected into the buff.

## Important procs

- `/SecretInformation/CursedEnergy/applySecret(mob/p)` is the tier application entry point. It renames Mana, sets up awakening, grants/tunes skills, handles specialization/domain chances, and refreshes trait passives.
- `mob/proc/setupCursedEnergyAwakening()` handles first-time aura/trait selection and re-setup on later logins or reapplications.
- `mob/proc/getCursedEnergySecret()` is the central safe accessor for the secret datum.
- `mob/proc/getCursedEnergyDrain(drain, obj/Skills/S)` reduces `ManaCost`/`ManaDrain` only when `S.CursedTechnique` is set.
- `mob/proc/reserveCursedEnergyTrait()`, `freeCursedEnergyTrait()`, `getAvailableCursedEnergyTraits()`, and `cursedEnergySlotOwnerId()` own trait-slot reservation semantics.
- `mob/proc/refreshCursedEnergyTraitPassives()`, `removeCursedEnergyTraitPassives()`, and `safeRemoveCursedEnergyPassives()` keep trait passives reversible.
- `mob/proc/attemptCursedHeavyStrike()`, `attemptCursedToss()`, and `attemptCursedReverseDash()` are action-replacement hooks called by base skills.
- `mob/proc/activateReversedCursedTechnique()` is the Reverse Cursed Technique heal.
- `/SecretInformation/CursedEnergy/grantDomainExpansion()`, `applyCursedDomainExpansionBuff()`, `ensureDomainExpansionVerbs()`, `grantDomainDefense()`, `grantDomainSureHit()`, and `getDomainSureHitSkill()` own Domain Expansion/anti-domain/sure-hit grants.
- `mob/proc/canUseCursedEnergyDomainSureHit()`, `collapseCursedEnergyDomainSureHit()`, and `finishCursedEnergyDomainSureHit()` validate and collapse domain sure-hit actions.
- `mob/proc/updateCursedEnergySpatialTechniques()` and `updateCursedEnergyImmolationTechniques()` scale trait techniques by secret tier.
- `mob/proc/triggerSixEyesCooldownReduction()`, `updateCursedEnergySixEyesOverlay()`, and `tickInfiniteVoidDomain()` support Six Eyes and Infinite Void.
- `mob/proc/cleanupCursedEnergy()` removes Cursed Energy skills, passives, renamed Mana, domain state, trait reservations, overlays, and persisted state.

## Trait system structure

Cursed Energy has five unique trait slots: `Serrated`, `Electricity`, `Slash`, `Spatial Manipulation`, and `Immolation`. `setupCursedEnergyAwakening()` asks the player for an aura color, collects available trait slots from `getAvailableCursedEnergyTraits()`, randomly picks one, reserves it through `reserveCursedEnergyTrait()`, stores it in `cursedEnergyTrait`, and grants the trait's starter skills.

Trait passives are returned by `/SecretInformation/CursedEnergy/getTraitPassives()` and applied via `refreshCursedEnergyTraitPassives()`. The applied list is copied into `cursedEnergyTraitPassivesApplied` so cleanup can remove only what Cursed Energy added.

Trait-slot ownership is global and ckey-based through `cursed_energy_taken_traits`. Admins can free stale/incorrect slots with `Manage_Cursed_Energy_Slots`, and the Secret/Saga Database displays the occupied trait-slot map.

## Technique replacement structure

Base actions are intentionally not rewritten. Cursed Energy overrides are small early-return hooks:

- Heavy Strike calls `attemptCursedHeavyStrike()` before normal Heavy Strike. Trait-specific replacements take priority: Electricity uses Cursed Voltage Strike, Slash uses Cleave, Serrated queues Gambler's Fist, Spatial Manipulation chooses Red/Blue by target distance, and Immolation uses Volcanic Strike. If no trait technique can fire, it falls back to Black Flash/Divergent Fist through `canBlackFlashStrike()` and `getBlackFlashStrike()`.
- Toss calls `attemptCursedToss()` before normal Toss. Serrated uses Shutter Doors, Slash uses Dismantle, Spatial Manipulation uses Hollow Purple, and Immolation uses Maximum Meteor.
- Reverse Dash calls `attemptCursedReverseDash()` before normal Reverse Dash. It activates the player's chosen Simple Domain or Hollow Wicker Basket if available.

## Resource / Mana / Cursed Energy handling

Cursed Energy does not create a separate resource pool. It sets the `RenameMana` passive to `"Cursed Energy"`, so UI/labels treat the existing Mana resource as Cursed Energy. Actual values remain `ManaAmount`, `ManaCost`, `ManaDrain`, and `LoseMana()`.

Cursed Technique skills set `CursedTechnique=1`. `getCursedEnergyDrain()` reduces their mana drain by tier: 10% per tier after tier 1, capped at 40%, plus an additional Six Eyes bonus capped at 75%. Buff activation and upkeep paths call this helper before checking or spending mana.

## Domain Expansion hooks

Cursed Energy can grant Domain Expansion randomly at lower tiers and guarantees it at tier 4+. `grantDomainExpansion()` either retunes an existing Domain Expansion or creates `/Domain_Expansion/Cursed_Energy`, prompts for the domain name/floor/shroud assets, applies the Cursed Energy stat package, grants verbs, and then asks the anti-domain choice.

Domain Expansion uses `releaseDomain()` in `Skills/_CursedEnergyBuffs.dm` for Wide/Target verbs. Cursed Energy adds a 30 Cursed Energy opening requirement and uses the shared `DomainExpansion()`/`stopDomainExapansion()` world-domain mechanics. Sure-hit skills require the correct trait and an active Domain Expansion; after firing, they collapse the domain and apply domain cooldown behavior.

Domain sure-hit grants currently map Serrated to Gambler's Luck, Slash to Domain Dismantle, Electricity to Domain Electric Discharge, and Spatial Manipulation to Infinite Void. Immolation has no explicit domain sure-hit mapping in the current `getDomainSureHitSkill()` switch.

## Reverse Cursed Technique behavior

Reverse Cursed Technique is triggered when a Cursed Energy user stops the Train/Pose state. `activateReversedCursedTechnique()` checks `cursedEnergyPoseHealReady` and cooldown, clears injuries/maims/mortal wounds/health cuts, heals a tier-scaled percent of health, doubles that heal for Six Eyes, restores 50 Mana/Cursed Energy, then starts a 300-tick cooldown and announces when available again.

## Simple Domain / Hollow Wicker Basket

`grantDomainDefense()` prompts once for `Simple Domain` or `Hollow Wicker Basket`, grants the selected skill, and stores the choice in `cursedEnergyDomainChoice`. `attemptCursedReverseDash()` uses this stored choice as a Reverse Dash override.

Simple Domain is a short slotless buff with Siphon/FluidForm/PureReduction/SpaceWalk/StaticWalk/Void passives and a forced 1500-tick cooldown method. Hollow Wicker Basket is a short high-reduction slotless buff with a 100 cooldown and a wicker barrier icon.

## Admin tools

- `_Reworks/Ags/AGDatabase.dm` contains the live combined Secret/Saga Database. It lists Cursed Energy trait, trait slot, specialization, domain choice, Six Eyes, and trait-passive counts for live players; it also displays the global `cursed_energy_taken_traits` table.
- `Manage_Cursed_Energy_Slots` lets level-3 admins free a trait slot without removing Cursed Energy from any character.
- `cleanupCursedEnergy()` sends an admin message after cleaning a character's Cursed Energy state. Secret/Saga removal tools rely on it rather than duplicating cleanup logic.

## Known extension points

- Add new unique traits by updating `getAvailableCursedEnergyTraits()`, `getTraitPassives()`, `setupCursedEnergyAwakening()`, `attemptCursedHeavyStrike()`, `attemptCursedToss()`, cleanup skill lists, admin display expectations, and any domain sure-hit mapping.
- Add new Cursed Techniques by defining skill objects in `CursedTechniques.dm`, setting `CursedTechnique=1`, giving them appropriate `ManaCost`/`ManaDrain`, and adding cleanup paths.
- Add new domain sure-hits by extending `getDomainSureHitSkill()` and preserving the `canUseCursedEnergyDomainSureHit()` and collapse/cooldown flow.
- Add specialization behavior by extending `getSpecializationPassives()` and the Ki Control specialization refresh path.

## Warnings: do not casually rename/remove

- Do not rename `/SecretInformation/CursedEnergy`, `Secret == "Cursed Energy"`, `getCursedEnergySecret()`, or `cleanupCursedEnergy()`; many validation and admin paths depend on those exact checks.
- Do not rename the `cursedEnergy*` player vars or global `cursed_energy_taken_traits` without migration code because they are persisted and displayed by admin tools.
- Do not remove `CursedTechnique=1` from Cursed Technique skills; that is what makes tier/Six Eyes drain reduction work.
- Do not replace Mana storage with a separate Cursed Energy pool unless all `ManaAmount`, `ManaCost`, `ManaDrain`, `LoseMana()`, UI rename, buff activation, and upkeep paths are migrated together.
- Do not delete Black Flash/Divergent Fist fallback helpers; Cursed Energy Heavy Strike still uses them when trait techniques cannot fire.
- Do not delete Simple Domain/Hollow Wicker Basket or Domain Expansion helpers unless `grantDomainDefense()`, `attemptCursedReverseDash()`, and Domain sure-hit flow are updated together.
- When removing Cursed Energy from a player, use `cleanupCursedEnergy()` so passives, overlays, skills, trait slots, domain state, and RenameMana are all cleaned consistently.
