-- **********************************************************************
-- GnomTEC NPCEmote
-- Version: 5.3.0.3
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
	["EnableColorize"] = true,	
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
		npcemoteOptionEnable = {
			type = "toggle",
			name = L["L_OPTIONS_ENABLE"],
			desc = "",
			set = function(info,val) GnomTEC_NPCEmote_Options["Enabled"] = val;  end,
			get = function(info) return GnomTEC_NPCEmote_Options["Enabled"] end,
			width = 'full',
			order = 2
		},
		npcemoteOptionEnableColorize = {
			type = "toggle",
			name = L["L_OPTIONS_ENABLECOLORIZE"],
			desc = "",
			set = function(info,val) GnomTEC_NPCEmote_Options["EnableColorize"] = val;  end,
			get = function(info) return GnomTEC_NPCEmote_Options["EnableColorize"] end,
			width = 'full',
			order = 3
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
-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

function GnomTEC_NPCEmote:ShowEmoteEditor(npc,emoteType,input)
	if (nil ~= emptynil(npc)) then
		GNOMTEC_NPCEMOTE_FRAME_NPC:SetText(npc)
	end
	if (nil ~= emptynil(input)) then
		GNOMTEC_NPCEMOTE_FRAME_SCROLL_TEXT:SetText(input)
	end
	GNOMTEC_NPCEMOTE_FRAME:Show()	
	if (nil ~= emoteType) then
		GNOMTEC_NPCEMOTE_FRAME_SELECTEMOTE_BUTTON:SetText(emoteType)
	else
		GNOMTEC_NPCEMOTE_FRAME_SELECTEMOTE_BUTTON:SetText("emote:")
	end
end

-- ----------------------------------------------------------------------
-- Frame event handler and functions
-- ----------------------------------------------------------------------
function GnomTEC_NPCEmote:GetTargetNPC()
	GNOMTEC_NPCEMOTE_FRAME_NPC:SetText(UnitName("target") or "")
end

function GnomTEC_NPCEmote:SendEmote()
	local npc = GNOMTEC_NPCEMOTE_FRAME_NPC:GetText()
	local input = GNOMTEC_NPCEMOTE_FRAME_SCROLL_TEXT:GetText()
	local emoteType = GNOMTEC_NPCEMOTE_FRAME_SELECTEMOTE_BUTTON:GetText()
	local line
	
	if (L["TRP2_LOC_DIT"] == emoteType) then
		for line in string.gmatch (input, "[^\n]+") do
			SendChatMessage("|| "..npc.." "..L["TRP2_LOC_DIT"]..line,"EMOTE")
		end
	elseif (L["TRP2_LOC_CRIE"] == emoteType) then
		for line in string.gmatch (input, "[^\n]+") do
			SendChatMessage("|| "..npc.." "..L["TRP2_LOC_CRIE"]..line,"EMOTE")
		end
	elseif (L["TRP2_LOC_WHISPER"] == emoteType) then
		for line in string.gmatch (input, "[^\n]+") do
			SendChatMessage("|| "..npc.." "..L["TRP2_LOC_WHISPER"]..line,"EMOTE")
		end
	else
		if (npc) then
			local first = true;
			for line in string.gmatch (input, "[^\n]+") do
				if (first) then
					SendChatMessage("|| "..npc.." "..input,"EMOTE")
					first = false
				else
					SendChatMessage("|| "..line,"EMOTE")	
				end
			end
		else
			for line in string.gmatch (input, "[^\n]+") do
				SendChatMessage("|| "..line,"EMOTE")	
			end
		end
	end
	
end

-- initialize drop down menu emote type
local function GnomTEC_NPCEmote_SelectEmote_InitializeDropDown(level)
	local emote = {
		notCheckable = 1,
		func = function (self, arg1, arg2, checked) GNOMTEC_NPCEMOTE_FRAME_SELECTEMOTE_BUTTON:SetText(arg1) end
	}

	emote.arg1 = "emote:"
	emote.text = emote.arg1
	UIDropDownMenu_AddButton(emote)
	emote.arg1 = L["TRP2_LOC_DIT"]
	emote.text = emote.arg1
	UIDropDownMenu_AddButton(emote)
	emote.arg1 = L["TRP2_LOC_CRIE"]
	emote.text = emote.arg1
	UIDropDownMenu_AddButton(emote)
	emote.arg1 = L["TRP2_LOC_WHISPER"]
	emote.text = emote.arg1
	UIDropDownMenu_AddButton(emote)

end

-- select emote type drop down menu OnLoad
function GnomTEC_NPCEmote:SelectEmote_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GnomTEC_NPCEmote_SelectEmote_InitializeDropDown, "MENU")
end

-- select emote type drop down menu OnClick
function GnomTEC_NPCEmote:SelectEmote_Button_OnClick(self, button, down)
	ToggleDropDownMenu(1, nil, GNOMTEC_NPCEMOTE_FRAME_SELECTEMOTE_DROPDOWN, self:GetName(), 0, 0)
end

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
 
 
local function SayChatFilter(self, event, msg, author, ...)
	if (not GnomTEC_NPCEmote_Options["EnableColorize"]) then
		return false
 	else
 		local count
 		local color = "|cFF"..string.format("%02X",ChatTypeInfo["EMOTE"].r*255)..string.format("%02X",ChatTypeInfo["EMOTE"].g*255)..string.format("%02X",ChatTypeInfo["EMOTE"].b*255)
 		
 		msg, count = string.gsub(msg,"(%*.-%*)",color.."%1|r")
 		if (count > 0) then
 			return false, msg, author, ...
 		else
 			return false
 		end
 	end
 end
 
-- ----------------------------------------------------------------------
-- chat commands
-- ----------------------------------------------------------------------
function GnomTEC_NPCEmote:ChatCommand_npce(input)
	local npc = UnitName("target")

	if (npc) then
		if (nil ~= emptynil(input)) then
			SendChatMessage("|| "..npc.." "..input,"EMOTE")
		else
			GnomTEC_NPCEmote:ShowEmoteEditor(npc,nil,input)
		end
	else
		if (nil ~= emptynil(input)) then
			SendChatMessage("|| "..input,"EMOTE")	
		else
			GnomTEC_NPCEmote:ShowEmoteEditor(nil,nil,"")
		end
	end
end

function GnomTEC_NPCEmote:ChatCommand_npcs(input)
	local npc = UnitName("target")
	
	if (npc and (nil ~= emptynil(input))) then
		SendChatMessage("|| "..npc.." "..L["TRP2_LOC_DIT"]..input,"EMOTE")
	else
		GnomTEC_NPCEmote:ShowEmoteEditor(npc,L["TRP2_LOC_DIT"],input)
	end
end

function GnomTEC_NPCEmote:ChatCommand_npcy(input)
	local npc = UnitName("target")
	
	if (npc and (nil ~= emptynil(input))) then
		SendChatMessage("|| "..npc.." "..L["TRP2_LOC_CRIE"]..input,"EMOTE")
	else
		GnomTEC_NPCEmote:ShowEmoteEditor(npc,L["TRP2_LOC_CRIE"],input)
	end
end

function GnomTEC_NPCEmote:ChatCommand_npcw(input)
	local npc = UnitName("target")
	
	if (npc and (nil ~= emptynil(input))) then
		SendChatMessage("|| "..npc.." "..L["TRP2_LOC_WHISPER"]..input,"EMOTE")
	else
		GnomTEC_NPCEmote:ShowEmoteEditor(npc,L["TRP2_LOC_WHISPER"],input)
	end

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
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", SayChatFilter)

	GnomTEC_NPCEmote:RegisterChatCommand("npce", "ChatCommand_npce")
	GnomTEC_NPCEmote:RegisterChatCommand("npcs", "ChatCommand_npcs")
	GnomTEC_NPCEmote:RegisterChatCommand("npcy", "ChatCommand_npcy")
	GnomTEC_NPCEmote:RegisterChatCommand("npcw", "ChatCommand_npcw")

	GnomTEC_NPCEmote:Print("GnomTEC_NPCEmote Enabled")

	-- Initialize options which are propably not valid because they are new added in new versions of addon
	if (nil == GnomTEC_NPCEmote_Options["EnableColorize"]) then
		GnomTEC_NPCEmote_Options["EnableColorize"] = false
	end
	
end

function GnomTEC_NPCEmote:OnDisable()
    -- Called when the addon is disabled
    
   GnomTEC_NPCEmote:UnregisterAllEvents();
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_EMOTE", EmoteChatFilter)

end

-- ----------------------------------------------------------------------
-- External API
-- ----------------------------------------------------------------------

