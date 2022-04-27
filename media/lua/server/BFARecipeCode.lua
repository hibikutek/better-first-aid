---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by hibik.
--- DateTime: 3/31/2022 1:41 PM
---

require "XpSystem/XpUpdate"
local Utils = require("BetterFirstAid/Utils")

-- XP functions
function BFA_OnGiveXP_Dissect(recipe, ingredients, result, player)
    if not Utils.CanDissect(player) then
        player:Say(getText("UI_BFA_Learning_No_More_Dissect"))
    else
        player:getXp():AddXP(Perks.Doctor, (10 + ZombRand(10)))
    end
end

function BFA_OnGiveXP_Basic(recipe, ingredients, result, player)
    local perkLevel = player:getPerkLevel(Perks.Doctor)
    if perkLevel and perkLevel < 2 then
        player:Say(getText("UI_BFA_Learning_Not_Yet_Basic"))
    end
    if perkLevel and perkLevel > 5 then
        player:Say(getText("UI_BFA_Learning_No_More_Basic"))
    else
        player:getXp():AddXP(Perks.Doctor, (20 + ZombRand(20)))
    end
end


-- OnCreate functions
function BFA_OnCreate_Damage_Tools(items, result, player)
    for i=0,items:size() - 1 do
        local item = items:get(i)
        -- If it's a knife, lower the condition
        if item:getType() == "KitchenKnife" or item:getType() == "HuntingKnife" then
            player:Say(getText("UI_BFA_Scalpel_Better"))
            item:setCondition(item:getCondition() - 1);
        end
    end
end
