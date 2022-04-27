---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by hibik.
--- DateTime: 4/26/2022 12:49 PM
---

require("TimedActions/ISBaseTimedAction")
local Utils = require("BetterFirstAid/Utils")


BFADissectTimedAction = ISBaseTimedAction:derive("BFADissectTimedAction")

function BFADissectTimedAction:isValid() -- Check if the action can be done
    return true;
end

function BFADissectTimedAction:update() -- Trigger every game update when the action is perform
end

function BFADissectTimedAction:waitToStart()
    return false;
end

function BFADissectTimedAction:start()
    self:setActionAnim("RipSheets")
end

function BFADissectTimedAction:stop() -- Trigger if the action is cancel
    ISBaseTimedAction.stop(self);
end

function BFADissectTimedAction:perform()
    BFA_OnGiveXP_Dissect(nil, nil, nil, self.character)
    Utils.DamageTool(self.character, self.dissectionTool)
    self.corpse:getSquare():removeCorpse(self.corpse, false)
    ISBaseTimedAction.perform(self)
end

function BFADissectTimedAction:new(character, dissectionTool, corpse)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.dissectionTool = dissectionTool
    o.corpse = corpse
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = true;
    o.maxTime = 200
    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end

BFABasicTimedAction = ISBaseTimedAction:derive("BFABasicTimedAction")

function BFABasicTimedAction:isValid() -- Check if the action can be done
    return true;
end

function BFABasicTimedAction:update() -- Trigger every game update when the action is perform
end

function BFABasicTimedAction:waitToStart()
    return false;
end

function BFABasicTimedAction:start()
    self:setActionAnim("RemoveGrass")
end

function BFABasicTimedAction:stop() -- Trigger if the action is cancel
    ISBaseTimedAction.stop(self);
end

function BFABasicTimedAction:perform()
    BFA_OnGiveXP_Basic(nil, nil, nil, self.character)
    self.character:getInventory():Remove(self.sterilizedBandage)
    self.character:removeFromHands(self.sterilizedBandage)
    self.character:setPrimaryHandItem(InventoryItemFactory.CreateItem("BandageDirty"))
    self.corpse:getSquare():removeCorpse(self.corpse, false)
    ISBaseTimedAction.perform(self)
end

function BFABasicTimedAction:new(character, sterilizedBandage, corpse)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.sterilizedBandage = sterilizedBandage
    o.corpse = corpse
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = true;
    o.maxTime = 200
    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end