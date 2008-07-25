-- some code/ideas taken from tekkub .. thanks :)

local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("ShardBroker", {icon = "Interface\\Icons\\INV_Misc_Gem_Amethyst_02", text = "?"})

LibStub("tekKonfig-AboutPanel").new( nil , "ShardBroker") 

local MINDELAY, DELAY = 3, 300
local elapsed, dirty = 0, false

local f = CreateFrame("frame")
f:Hide()
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
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

if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
