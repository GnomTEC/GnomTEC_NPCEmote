-- **********************************************************************
-- GnomTEC NPCEmote
-- Version: 5.3.0.1
-- Author: GnomTEC
-- Copyright 2013 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************
-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_NPCEmote")

-- ----------------------------------------------------------------------
-- Legacy global variables and constants (will be deleted in future)
-- ----------------------------------------------------------------------

GnomTEC_NPCEmote_Options = {
	["Enabled"] = true,
}

-- ----------------------------------------------------------------------
-- Addon global variables (local)
-- ----------------------------------------------------------------------

-- Main options menue with general addon information
local optionsMain = {
	name = "GnomTEC NPCEmote",
	type = "group",
	args = {
		descriptionTitle = {
			order = 1,
			type = "description",
			name = L["L_OPTIONS_TITLE"],
		},
		babelOptionEnable = {
			type = "toggle",
			name = L["L_OPTIONS_ENABLE"],
			desc = "",
			set = function(info,val) GnomTEC_NPCEmote_Options["Enabled"] = val;  end,
			get = function(info) return GnomTEC_NPCEmote_Options["Enabled"] end,
			width = 'full',
			order = 2
		},
		descriptionAbout = {
			name = "About",
			type = "group",
			guiInline = true,
			order = 4,
			args = {
				descriptionVersion = {
				order = 1,
				type = "description",			
				name = "|cffffd700".."Version"..": ".._G["GREEN_FONT_COLOR_CODE"]..GetAddOnMetadata("GnomTEC_NPCEmote", "Version"),
				},
				descriptionAuthor = {
					order = 2,
					type = "description",
					name = "|cffffd700".."Autor"..": ".."|cffff8c00".."GnomTEC",
				},
				descriptionEmail = {
					order = 3,
					type = "description",
					name = "|cffffd700".."Email"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."info@gnomtec.de",
				},
				descriptionWebsite = {
					order = 4,
					type = "description",
					name = "|cffffd700".."Website"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."http://www.gnomtec.de/",
				},
				descriptionLicense = {
					order = 5,
					type = "description",
					name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."(c)2013 by GnomTEC",
				},
			}
		},
		descriptionLogo = {
			order = 5,
			type = "description",
			name = "",
			image = "Interface\\AddOns\\GnomTEC_NPCEmote\\Textures\\GnomTEC-Logo",
			imageCoords = {0.0,1.0,0.0,1.0},
			imageWidth = 512,
			imageHeight = 128,
		},
	}
}
	
-- ----------------------------------------------------------------------
-- Startup initialization
-- ----------------------------------------------------------------------

GnomTEC_NPCEmote = LibStub("AceAddon-3.0"):NewAddon("GnomTEC_NPCEmote", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC NPCEmote Main", optionsMain)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC NPCEmote Main", "GnomTEC NPCEmote");

-- ----------------------------------------------------------------------
-- Local functions
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Frame event handler and functions
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Hook functions
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Event handler
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- ChatFilter for TRP2 compatible NPC msgs
-- ----------------------------------------------------------------------
local function EmoteChatFilter(self, event, msg, author, ...)
	if (not GnomTEC_NPCEmote_Options["Enabled"]) then
		return false
	elseif string.sub(msg,1,3) == "|| " then
		if string.find(msg,L["TRP2_LOC_DIT"]) then
			local npc = string.sub(msg,4,string.find(msg,L["TRP2_LOC_DIT"])-2);
			npc = "|Hplayer:"..author.."|h"..npc.." |h";
			msg = string.sub(msg,string.find(msg,L["TRP2_LOC_DIT"])+string.len(L["TRP2_LOC_DIT"]));
			self:AddMessage(npc..L["TRP2_LOC_DIT"]..msg,ChatTypeInfo["MONSTER_SAY"].r,ChatTypeInfo["MONSTER_SAY"].g,ChatTypeInfo["MONSTER_SAY"].b,ChatTypeInfo["MONSTER_SAY"].id);
		elseif string.find(msg,L["TRP2_LOC_CRIE"]) then
			local npc = string.sub(msg,4,string.find(msg,L["TRP2_LOC_CRIE"])-2);
			npc = "|Hplayer:"..author.."|h"..npc.." |h";
			msg = string.sub(msg,string.find(msg,L["TRP2_LOC_CRIE"])+string.len(L["TRP2_LOC_CRIE"]));
			self:AddMessage(npc..L["TRP2_LOC_CRIE"]..msg,ChatTypeInfo["MONSTER_YELL"].r,ChatTypeInfo["MONSTER_YELL"].g,ChatTypeInfo["MONSTER_YELL"].b,ChatTypeInfo["MONSTER_YELL"].id);
		elseif string.find(msg,L["TRP2_LOC_WHISPER"]) then
			local npc = string.sub(msg,4,string.find(msg,L["TRP2_LOC_WHISPER"])-2);
			npc = "|Hplayer:"..author.."|h"..npc.." |h";
			msg = string.sub(msg,string.find(msg,L["TRP2_LOC_WHISPER"])+string.len(L["TRP2_LOC_WHISPER"]));
			self:AddMessage(npc..L["TRP2_LOC_WHISPER"]..msg,ChatTypeInfo["MONSTER_WHISPER"].r,ChatTypeInfo["MONSTER_WHISPER"].g,ChatTypeInfo["MONSTER_WHISPER"].b,ChatTypeInfo["MONSTER_WHISPER"].id);
		else
			self:AddMessage("|Hplayer:"..author.."|h"..string.sub(msg,4).." |h",ChatTypeInfo["MONSTER_EMOTE"].r,ChatTypeInfo["MONSTER_EMOTE"].g,ChatTypeInfo["MONSTER_EMOTE"].b,ChatTypeInfo["MONSTER_EMOTE"].id);
		end
		return true
	else
		return false
	end
 end
 
-- ----------------------------------------------------------------------
-- chat commands
-- ----------------------------------------------------------------------
function GnomTEC_NPCEmote:ChatCommand_npce(input)
	local npc = UnitName("target") or "?"
	SendChatMessage("|| "..npc.." "..input,"EMOTE")
end

function GnomTEC_NPCEmote:ChatCommand_npcs(input)
	local npc = UnitName("target") or "?"
	SendChatMessage("|| "..npc.." "..L["TRP2_LOC_DIT"]..input,"EMOTE")
end

function GnomTEC_NPCEmote:ChatCommand_npcy(input)
	local npc = UnitName("target") or "?"
	SendChatMessage("|| "..npc.." "..L["TRP2_LOC_CRIE"]..input,"EMOTE")
end

function GnomTEC_NPCEmote:ChatCommand_npcw(input)
	local npc = UnitName("target") or "?"
	SendChatMessage("|| "..npc.." "..L["TRP2_LOC_WHISPER"]..input,"EMOTE")
end

-- ----------------------------------------------------------------------
-- Addon OnInitialize, OnEnable and OnDisable
-- ----------------------------------------------------------------------

function GnomTEC_NPCEmote:OnInitialize()
 	-- Code that you want to run when the addon is first loaded goes here.
  
  	GnomTEC_NPCEmote:Print(L["L_WELCOME"])
  	  	
end

function GnomTEC_NPCEmote:OnEnable()
    -- Called when the addon is enabled

	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", EmoteChatFilter)

	GnomTEC_NPCEmote:RegisterChatCommand("npce", "ChatCommand_npce")
	GnomTEC_NPCEmote:RegisterChatCommand("npcs", "ChatCommand_npcs")
	GnomTEC_NPCEmote:RegisterChatCommand("npcy", "ChatCommand_npcy")
	GnomTEC_NPCEmote:RegisterChatCommand("npcw", "ChatCommand_npcw")

	GnomTEC_NPCEmote:Print("GnomTEC_NPCEmote Enabled")

	-- Initialize options which are propably not valid because they are new added in new versions of addon
	
end

function GnomTEC_NPCEmote:OnDisable()
    -- Called when the addon is disabled
    
   GnomTEC_NPCEmote:UnregisterAllEvents();
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_EMOTE", EmoteChatFilter)

end

-- ----------------------------------------------------------------------
-- External API
-- ----------------------------------------------------------------------

