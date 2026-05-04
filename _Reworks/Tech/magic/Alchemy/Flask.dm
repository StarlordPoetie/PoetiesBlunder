// Check Items.dm and sift through the spaghetti to find how this item is equipped and unequipped via the Equip proc and the ObjectUse proc
//
// (I fucking hate this shit dude)

/obj/Items/Flask
    Unwieldy = 1 // Should prevent people from using this outside of meditate
    icon = 'Icons/enchantment/Magic Potion.dmi'
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
    var/DrinkMessage
    var/OffMessage
    var/Slots=2 // How many Herbs/Buffs a charge holds
    var/Charges = 0 // How many uses you have in your flask before you need to meditate agai
    var/MaxCharges = 2 //How many charges your flask stores total, this will be increased with certain magic knowledge
    // Charge refilling is handled in Gains.dm, line 237
    // The Buff We Pass This Shit To
    Techniques = list("/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Flask_Charge") // how we spend charges
        
// This is the thing the players actually interact with, it also can be accessed in all the important ways
/mob/var/obj/Items/Flask/equippedFlask 

// What actually handles the Potion Buff and Hopefully works?
/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Flask_Charge
    var/CD = 300 // Base Cooldown of 5 mins

mob/proc/reduceCharge()
    if(Charges != 0)
        --equippedFlask.Charges
    else if(Charges = 0)
        src << "You have no Flask Charges left!" 
        
