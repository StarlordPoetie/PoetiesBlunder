// Check Items.dm and sift through the spaghetti to find how this item is equipped and unequipped via the Equip proc and the ObjectUse proc
// (I fucking hate this shit dude)
#define BASE_MAX_CHARGES 2 // How many charges we start out with

/obj/Items/Flask
    Unwieldy = 1 // Should prevent people from using this outside of meditate
    icon = 'Icons/enchantment/Magic Potion.dmi'
    // 0 means they will not trigger if statements 
    // 1 means they will 
    // Basic Healing effects
    var/Heal=0
    var/Energy=0  
    var/Mana=0
    // Damaging effects
    var/Toxic=0
    // Passive Effects
    var/Hallucinogen=0
    var/Transform=0
    var/Searing=0
    var/Flowy=0
    var/Hard=0
    // Passive Finder
    var/FoundHallucinogen=0
    var/FoundSearing=0
    var/FoundFlowy=0
    var/FoundHard=0
    // Mutagenic Icon
    var/TransformIcon
    // Misc stuff
    var/Tier = 0 // This will be used to upgrade your flask
    var/DrinkMessage
    var/OffMessage
    var/Slots=2 // How many Herbs/Buffs a charge holds
    var/Charges = 0 // How many uses you have in your flask before you need to meditate again 
    // Charge refilling is handled in Gains.dm, line 237
    // Below is The Buff We Pass This Shit To and spends charges
    Techniques = list("/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Flask_Charge")
        
// This is the thing the players actually interact with, it also can be accessed in all the important ways
/mob/var/obj/Items/Flask/equippedFlask 

// What actually handles the Potion Buff and Hopefully works?
/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Flask_Charge
    var/CD = 300 // Base Cooldown of 5 mins
    MagicNeeded=1
    ActiveMessage="quaffs a mysterious potion!"
    TextColor=rgb(0, 153, 255)
    AlwaysOn=1
    Cooldown=1
    adjust(mob/P)
      /* var/obj/Items/Flask/BuffHolder = P.equippedFlask
        // I am so fucking sorry for what is about to happen
         if(BuffHolder.Heal == 1) // if you chose a  herb, your value for said herb should be 1 and ONLY 1
            InstantAffect=1
            StableHeal=1
            src.HealthHeal = glob.POTIONHEAL //check glob.dm for POTIONHEAL value, line 445. See above for BuffHolder.Heal
            src.ManaHeal -= glob.POTIONHEAL-BuffHolder.Tier // decreases mana penalty with tie
            src.EnergyHeal -= glob.POTIONHEAL*2-BuffHolder.Tier// Same as above but you lose 10 energy, since it's easy to recharge
        if(BuffHolder.Mana == 1) // same rule, ONLY THE VALUE OF 1 SHOULD BE HERE
            InstantAffect=1
            src.ManaHeal = glob.POTIONHEAL 
            src.EnergyHeal -= glob.POTIONHEAL*2-BuffHolder.Tier */

    verb/Imbibe_Flask(mob/P) // We cosnume a charge from the flask!
        set category = "Skills"
        P.reduceCharge() // mob proc that is detched
        if(P.equippedFlask.Charges == 0) return // If we have no charges, this will return 0, which means false, which means get out
        if(!usr.BuffOn(src)) // Activate the buff
            adjust(usr)
        src.Trigger(usr)



mob/proc/reduceCharge(mob/P) // this has given me a serious headache 
    if(equippedFlask.Charges == 0) // Empty 
        src << "You have no Flask Charges left!"
        return
    else if(equippedFlask.Charges > 3 || equippedFlask.Charges < 0) // Why do you have more than 3? Max flask tier is 2
        src << "ERROR: Your number of Flask Charges is [equippedFlask.Charges], this shouldn't be possible. Contact staff."
        liveDebugMsg("[P] has [equippedFlask.Charges] Flask Charges. This shouldn't be possible.") // I'll thank myself later when someone inevitably exploits flasks.
        return
    --equippedFlask.Charges
        

mob/proc/GetMaxCharges(mob/P)
    return BASE_MAX_CHARGES + equippedFlask.Tier
    