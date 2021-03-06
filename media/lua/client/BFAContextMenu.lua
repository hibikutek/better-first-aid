---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by hibik.
--- DateTime: 4/22/2022 10:40 PM
---

local Utils = require("BetterFirstAid/Utils")

local BFADissectCorpse = {}
local BFABasicFirstAid = {}

BFADissectCorpse.doMenu = function(player, context, worldobjects, test)
    if test == true then return true end

    -- Can the player benefit from Dissection? If not, return
    if not Utils.CanDissect(getSpecificPlayer(player)) then return end

    -- Is there a corpse at the location clicked?  If not, return
    local corpse = IsoObjectPicker.Instance:PickCorpse(getMouseX(), getMouseY());
    if not corpse then return end
    BFADissectCorpse.corpse = corpse

    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    local dissectionTool = playerInv:getFirstEvalRecurse(Utils.IsDissectionTool)

    if dissectionTool then
        context:addOption(getText("UI_BFA_Dissect_Corpse"), worldobjects, BFADissectCorpse.dissectCorpse, player);
    end
    return
end

BFADissectCorpse.dissectCorpse = function (item, player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    local equipped = playerObj:getPrimaryHandItem()
    local dissectionTool

    -- Check to see if a dissectionTool is equipped
    if equipped and Utils.IsDissectionTool(equipped) then
        dissectionTool = equipped
    end
    -- If no dissectionTool is equipped check inventory for one
    if not dissectionTool then
        -- first check for a proper tool, such as a scalpel
        dissectionTool = playerInv:getFirstEvalRecurse(Utils.IsProperDissectionTool)
        if not dissectionTool then
            -- next check for any dissection tool
            dissectionTool = playerInv:getFirstEvalRecurse(Utils.IsDissectionTool)
        end
    end

    if BFADissectCorpse.corpse:getSquare() and dissectionTool and luautils.walkAdj(playerObj, BFADissectCorpse.corpse:getSquare()) then
        ISInventoryPaneContextMenu.equipWeapon(dissectionTool, true, false, playerObj:getPlayerNum());
        ISTimedActionQueue.add(BFADissectTimedAction:new(playerObj, dissectionTool, BFADissectCorpse.corpse));
    end
end

BFABasicFirstAid.doMenu = function(player, context, worldobjects, test)
    if test == true then return true end
    if not Utils.CanBasicFirstAid(getSpecificPlayer(player)) then return end

    local corpse = IsoObjectPicker.Instance:PickCorpse(getMouseX(), getMouseY());
    if not corpse then return end
    BFABasicFirstAid.corpse = corpse

    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    local sterilizedBandage = playerInv:getFirstEvalRecurse(Utils.IsSterilizedBandage)

    if sterilizedBandage then
        context:addOption(getText("UI_BFA_Basic_First_Aid"), worldobjects, BFABasicFirstAid.basicFirstAid, player);
    end
    return
end

BFABasicFirstAid.basicFirstAid = function(item, player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    local equipped = playerObj:getPrimaryHandItem()
    local sterilizedBandage

    -- Check to see if the bandage is equipped
    if equipped and Utils.IsSterilizedBandage(equipped) then
        sterilizedBandage = equipped
    end
    -- Check if the bandage is in the inventory
    if not sterilizedBandage then
        sterilizedBandage = playerInv:getFirstEvalRecurse(Utils.IsSterilizedBandage)
    end

    if BFABasicFirstAid.corpse:getSquare() and sterilizedBandage and luautils.walkAdj(playerObj, BFABasicFirstAid.corpse:getSquare()) then
        ISInventoryPaneContextMenu.equipWeapon(sterilizedBandage, true, false, playerObj:getPlayerNum());
        ISTimedActionQueue.add(BFABasicTimedAction:new(playerObj, sterilizedBandage, BFABasicFirstAid.corpse));
    end

end

Events.OnFillWorldObjectContextMenu.Add(BFADissectCorpse.doMenu)
Events.OnFillWorldObjectContextMenu.Add(BFABasicFirstAid.doMenu)