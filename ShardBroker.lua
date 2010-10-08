-- some code/ideas taken from tekkub .. thanks :)

if(select(2, UnitClass('player')) ~= 'WARLOCK') then return end

local _, _, _, uiVersion = GetBuildInfo()

local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("ShardBroker", {type = "data source", icon = "Interface\\Icons\\INV_Misc_Gem_Amethyst_02", text = "?"})

LibStub("tekKonfig-AboutPanel").new( nil , "ShardBroker") 

local f = CreateFrame("frame")
f:Hide()
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

if (uiVersion < 40000) then

    local MINDELAY, DELAY = 3, 300
    local elapsed, dirty = 0, false

    f:SetScript("OnUpdate", function(self, elap)
    elapsed = elapsed + elap
    if (dirty and elapsed >= MINDELAY) or elapsed >= DELAY then
        elapsed, dirty = 0, false
        dataobj.text = GetItemCount(6265)
    end
    end)

    function f:BAG_UPDATE(event,bag) dirty = true end

    function f:PLAYER_LOGIN()
        self:RegisterEvent("BAG_UPDATE")
        self:Show()
        self:UnregisterEvent("PLAYER_LOGIN")
        self.PLAYER_LOGIN = nil
    end

else
    local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
    
    function f:UNIT_POWER(_,unit,power)
        if (not power or power ~= 'SOUL_SHARDS' or unit ~= "player") then return end
        dataobj.text = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)        
    end

    function f:PLAYER_LOGIN()
        self:RegisterEvent("UNIT_POWER")
        dataobj.text = UnitPower('player', SPELL_POWER_SOUL_SHARDS)  
        self:Show()
        self:UnregisterEvent("PLAYER_LOGIN")
        self.PLAYER_LOGIN = nil
    end


end


if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
