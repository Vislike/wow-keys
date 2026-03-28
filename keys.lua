-- local vars

local string, canaccessvalue = string, canaccessvalue;
local mpKeyStone = 180653;
local linkKeys, partyChat;

-- frame

local f = CreateFrame("Frame");
f:Hide();

local function onEvent(self, event, ...)
	if(event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER") then
		local msg = ...;
		if(canaccessvalue(msg) and string.lower(msg) == "!keys") then
			linkKeys();
		end
	elseif(event == "ADDON_LOADED") then
		local name = ...;
		if(name == "!keys") then
			--Events
			f:UnregisterEvent("ADDON_LOADED");
			f:RegisterEvent("CHAT_MSG_PARTY");
			f:RegisterEvent("CHAT_MSG_PARTY_LEADER");
		end
	end
end

f:RegisterEvent("ADDON_LOADED");
f:SetScript("OnEvent", onEvent);

-- functionality

linkKeys = function()
	local bag, slot;
	local found = {};
	for bag = 0, NUM_BAG_SLOTS do
		local bagSlots = C_Container.GetContainerNumSlots(bag);
		for slot = 1, bagSlots do
			local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
			if(itemInfo and itemInfo.itemID) then
				-- use id
				if(itemInfo.itemID == mpKeyStone) then
					found[#found+1] = itemInfo.hyperlink;
				else
					-- fallback
					local itemName = GetItemInfo(itemInfo.itemID);
					if(itemName and string.find(itemName, "Keystone")) then
						found[#found+1] = itemInfo.hyperlink;
					end
				end
			end
		end
	end
	if(#found > 0) then
		partyChat(table.concat(found, " "));
	end
end

partyChat = function(msg)
	if(IsInGroup(LE_PARTY_CATEGORY_HOME)) then
		SendChatMessage(msg, "PARTY");
	else
		print("!keys: " .. msg);
	end
end

function ExclamationKeysDebugTrigger()
	linkKeys();
end