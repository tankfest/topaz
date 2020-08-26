-----------------------------------
-- Ability: Eagle Eye Shot
-- Delivers a powerful and accurate ranged attack.
-- Obtained: Ranger Level 1
-- Recast Time: 1:00:00
-- Duration: Instant
-----------------------------------
require("scripts/globals/weaponskills")
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------

function onAbilityCheck(player, target, ability)
    local ranged = player:getStorageItem(0, 0, tpz.slot.RANGED)
    local ammo = player:getStorageItem(0, 0, tpz.slot.AMMO)

    if ranged and ranged:isType(tpz.itemType.WEAPON) then
        local skilltype = ranged:getSkillType()
        if skilltype == tpz.skill.ARCHERY or skilltype == tpz.skill.MARKSMANSHIP or skilltype == tpz.skill.THROWING then
            if ammo and (ammo:isType(tpz.itemType.WEAPON) or skilltype == tpz.skill.THROWING) then
                return 0, 0
            end
        end
    end

    return tpz.msg.basic.NO_RANGED_WEAPON, 0
end

function onUseAbility(player, target, ability, action)
    local accBonus = 100
    local damage = 0

    if (player:getWeaponSkillType(tpz.slot.RANGED) == tpz.skill.MARKSMANSHIP) then
        action:animation(target:getID(), action:animation(target:getID()) + 1)
    end
    if getRangedHitRate(player, target, false, accBonus) <= math.random() then -- EES misses
        action:messageID(target:getID(), tpz.msg.basic.JA_MISS_2)
        action:speceffect(target:getID(), 0)
    else
        damage = player:getRangedDmg() * 7.5 -- Weapon Damage * 5 (* 1.5 for ranged damage multiplier)
        target:takeDamage(damage, mob, tpz.attackType.RANGED, tpz.damageType.PIERCING)
        target:updateEnmityFromDamage(player, damage)
        action:messageID(target:getID(), tpz.msg.basic.JA_DAMAGE)
        action:speceffect(target:getID(), 32)
    end
    
    player:removeAmmo()
    return damage
end
