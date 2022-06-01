-- **********************************************************************
-- GnomTEC NPCEmote
-- Version: 9.2.5.24
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright © 2013-2022 by Peter Jack
--
-- Licensed under the EUPL, Version 1.1 only (the "Licence");
-- You may not use this work except in compliance with the Licence.
-- You may obtain a copy of the Licence at:
--
-- http://ec.europa.eu/idabc/eupl5
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the Licence is distributed on an "AS IS" basis,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the Licence for the specific language governing permissions and
-- limitations under the Licence.
-- **********************************************************************
-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_NPCEmote")

-- ----------------------------------------------------------------------
-- Addon Info Constants (local)
-- ----------------------------------------------------------------------
-- addonInfo for addon registration to GnomTEC API
local addonInfo = {
	["Name"] = "GnomTEC NPCEmote",
	["Description"] = L["L_DESCRIPTION"],	
	["Version"] = "9.2.5.24",
	["Date"] = "2022-06-01",
	["Author"] = "Peter Jack",
	["Email"] = "info@gnomtec.de",
	["Website"] = "http://www.gnomtec.de/",
	["Copyright"] = "© 2013-2022 by Peter Jack",
	["License"] = "European Union Public Licence (EUPL v.1.1)",	
	["FrameworkRevision"] = 13
}

-- ----------------------------------------------------------------------
-- Addon Global Constants (local)
-- ----------------------------------------------------------------------
-- Class levels
local CLASS_BASE	= 0
local CLASS_CLASS	= 1
local CLASS_WIDGET	= 2
local CLASS_ADDON	= 3

-- Log levels
local LOG_FATAL = 0
local LOG_ERROR	= 1
local LOG_WARN	= 2
local LOG_INFO 	= 3
local LOG_DEBUG = 4

-- ----------------------------------------------------------------------
-- Addon Static Variables (local)
-- ----------------------------------------------------------------------
local addonDataObject =	{
	type = "launcher",
	tocname = "GnomTEC_NPCEmote",
	label = "GnomTEC NPCEmote",
	icon = [[Interface\ICONS\Ability_Rogue_Disguise]],
	OnClick = function(self, button)
		GnomTEC_NPCEmote.SwitchMainWindow()
	end,
	OnTooltipShow = function(tooltip)
		GnomTEC_NPCEmote.ShowAddonTooltip(tooltip)
	end,
}

-- default data for addon database
local defaultsDb = {
	char = {
		["Enabled"] = true,
		["EnableColorize"] = true,	
		["ShowMinimapIcon"] = true,		
	},
}

-- Main options menue with general addon information
local optionsArray = {
	{
		name = L["L_OPTIONS_GENERAL"],
		type = "group",
		args = {
			npcemoteOptionEnable = {
				type = "toggle",
				name = L["L_OPTIONS_GENERAL_ENABLE"],
				desc = "",
				set = function(info,val) GnomTEC_NPCEmote.SetOption("Enabled",val) end,
				get = function(info) return GnomTEC_NPCEmote.GetOption("Enabled") end,
				width = 'full',
				order = 2
			},
			npcemoteOptionEnableColorize = {
				type = "toggle",
				name = L["L_OPTIONS_GENERAL_ENABLECOLORIZE"],
				desc = "",
				set = function(info,val) GnomTEC_NPCEmote.SetOption("EnableColorize", val)  end,
				get = function(info) return GnomTEC_NPCEmote.GetOption("EnableColorize") end,
				width = 'full',
				order = 3
			},
			npcemoteOptionToolbar = {
				type = "toggle",
				name = L["L_OPTIONS_GENERAL_SHOWMINIMAPICON"],
				desc = "",
				set = function(info,val) GnomTEC_NPCEmote.SetOption("ShowMinimapIcon", val) end,
		   	get = function(info) return GnomTEC_NPCEmote.GetOption("ShowMinimapIcon") end,
				width = 'full',
				order = 4
			},
		}
	}
}
-- ----------------------------------------------------------------------
-- Addon Startup Initialization
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------
-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

-- ----------------------------------------------------------------------
-- Addon Class
-- ----------------------------------------------------------------------

local function GnomTECNPCEmote()
	local self = {}
	
	-- call base class
	local addon, protected = GnomTECAddon("GnomTEC_NPCEmote", addonInfo, defaultsDb, optionsArray)
	
	-- when we got nil from base class there is a major issue and we will stop here.
	-- GnomTEC framework will inform the user by itself about the issue.
	if (nil == addon) then
		return self
	end
	
	-- options get/set functions table
	local options = {
		["Enabled"] = {
			get = function() return addon.db.char["Enabled"] end,
			set = function(val) addon.db.char["Enabled"] = val end,
		},
		["EnableColorize"] = {
			get = function() return addon.db.char["EnableColorize"] end,
			set = function(val) addon.db.char["EnableColorize"] = val end,
		},
		["ShowMinimapIcon"]  = {
			get = function() return addon.db.char["ShowMinimapIcon"] end,
			set = function(val) addon.db.char["ShowMinimapIcon"] = val; if (val) then addon.ShowMinimapIcon(addonDataObject); else addon.HideMinimapIcon(); end; end,
		}		
	}

	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	local mainWindowWidgets = nil
	
	-- private methods
	-- local function f()
	local function SendEmoteMessage(npc, emoteType, msg)
		local maxlen
		if (L["TRP2_LOC_DIT"] == emoteType) then
			maxlen = 255 - string.len("|| "..npc.." "..L["TRP2_LOC_DIT"])
		elseif (L["TRP2_LOC_CRIE"] == emoteType) then
			maxlen = 255 - string.len("|| "..npc.." "..L["TRP2_LOC_CRIE"])
		elseif (L["TRP2_LOC_WHISPER"] == emoteType) then
			maxlen = 255 - string.len("|| "..npc.." "..L["TRP2_LOC_WHISPER"])
		else
			if ("" ~= npc) then
				maxlen = 255 - string.len("|| "..npc.." ")
			else
				maxlen = 255 - string.len("|| ")
			end
		end
	
		if (string.len(msg) <= maxlen) then
			if (L["TRP2_LOC_DIT"] == emoteType) then
				SendChatMessage("|| "..npc.." "..L["TRP2_LOC_DIT"]..msg,"EMOTE")
			elseif (L["TRP2_LOC_CRIE"] == emoteType) then
				SendChatMessage("|| "..npc.." "..L["TRP2_LOC_CRIE"]..msg,"EMOTE")
			elseif (L["TRP2_LOC_WHISPER"] == emoteType) then
				SendChatMessage("|| "..npc.." "..L["TRP2_LOC_WHISPER"]..msg,"EMOTE")
			else
				if ("" ~= npc) then
					SendChatMessage("|| "..npc.." "..msg,"EMOTE")
				else
					SendChatMessage("|| "..msg,"EMOTE")	
				end
			end
		else
			local m = ""
			local first = true
			local w	

			for w in string.gmatch(msg, "[^ ]+") do
				if ((string.len(m) + string.len(w)) + 1 <= maxlen) then
					if ("" ~= m) then
						m = m.." "..w
					else
						m = w
					end
				else
					if ("" == m) then
						-- nobody should type single words that are too long for a line, but if...
						m = string.sub(w,1,maxlen)
						w = ""
					end

					if (first) then
						SendEmoteMessage(npc, emoteType, m)
						if  (L["TRP2_LOC_EMOTE"] == emoteType) then
							first = false
						end
					else
						SendEmoteMessage("", nil, m)
					end				
					m = w
				end
			end
			if ("" ~= m) then
				if (first) then
					SendEmoteMessage(npc, emoteType, m)
				else
					SendEmoteMessage("", nil, m)
				end
			end
		end
	end

	local function OnClickMainWindowTarget(widget, button)
		mainWindowWidgets.mainWindowTargetChar.SetText(UnitName("target"))
	end

	local function OnClickMainWindowSend(widget, button)
		local npc = mainWindowWidgets.mainWindowTargetChar.GetText()
		local input = mainWindowWidgets.mainWindowText.GetText()
		local emoteType = mainWindowWidgets.mainWindowDropDownButton.GetSelectedValue()
		local line
	
		if (L["TRP2_LOC_EMOTE"] ~= emoteType) then
			for line in string.gmatch (input, "[^\n]+") do
				SendEmoteMessage(npc, emoteType, line)
			end
		else
			if ("" ~= npc) then
				local first = true;
				for line in string.gmatch (input, "[^\n]+") do
					if (first) then
						SendEmoteMessage(npc, emoteType, line)
						first = false
					else
						SendEmoteMessage("", emoteType, line)
					end
				end
			else
				for line in string.gmatch (input, "[^\n]+") do
					SendEmoteMessage("", emoteType, line)
				end
			end
		end
	end
	
	local function ShowEmoteEditor(npc,emoteType,input)
		self.SwitchMainWindow(true)	
		if (nil ~= emptynil(npc)) then
			mainWindowWidgets.mainWindowTargetChar.SetText(npc)
		else
			mainWindowWidgets.mainWindowTargetChar.SetFocus();
		end
		if (nil ~= emptynil(input)) then
			mainWindowWidgets.mainWindowText.SetText(input)
		else
			mainWindowWidgets.mainWindowText.SetFocus();
		end
		mainWindowWidgets.mainWindowDropDownButton.SetSelectedValue(emoteType)
	end

	-- ----------------------------------------------------------------------
	-- ChatFilter for TRP2 compatible NPC msgs
	-- ----------------------------------------------------------------------
	local function EmoteChatFilter(self, event, msg, author, ...)
		if ((options["Enabled"].get()) and (string.sub(msg,1,3) == "|| ")) then
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
 			local colorized = false
			if (options["EnableColorize"].get()) then
 				local count1, count2, count3
				local color = "|cFF"..string.format("%02X",ChatTypeInfo["SAY"].r*255)..string.format("%02X",ChatTypeInfo["SAY"].g*255)..string.format("%02X",ChatTypeInfo["SAY"].b*255)
 			
		 		msg, count1 = string.gsub(msg,"(%*.-%*)",color.."%1|r")
				msg, count2 = string.gsub(msg,"(<.->)",color.."%1|r")
				msg, count3 = string.gsub(msg,"(\".-\")",color.."%1|r")
				if (count1+count2+count3 > 0) then
					colorized = true
 				end
 			end
			if (colorized) then
 				return false, msg, author, ...
 			else
 				return false
 			end
		end
	end

	local function SayChatFilter(self, event, msg, author, ...)
		if (not options["EnableColorize"].get()) then
			return false
 		else
 			local count1, count2
 			local color = "|cFF"..string.format("%02X",ChatTypeInfo["EMOTE"].r*255)..string.format("%02X",ChatTypeInfo["EMOTE"].g*255)..string.format("%02X",ChatTypeInfo["EMOTE"].b*255)
 		
			msg, count1 = string.gsub(msg,"(%*.-%*)",color.."%1|r")
			msg, count2 = string.gsub(msg,"(<.->)",color.."%1|r")
			if (count1+count2 > 0) then
				return false, msg, author, ...
 			else
 				return false
 			end
 		end
 	end

	local function YellChatFilter(self, event, msg, author, ...)
		if (not options["EnableColorize"].get()) then
			return false
 		else
 			local count1, count2
 			local color = "|cFF"..string.format("%02X",ChatTypeInfo["EMOTE"].r*255)..string.format("%02X",ChatTypeInfo["EMOTE"].g*255)..string.format("%02X",ChatTypeInfo["EMOTE"].b*255)
 
 			msg, count1 = string.gsub(msg,"(%*.-%*)",color.."%1|r")
 			msg, count2 = string.gsub(msg,"(<.->)",color.."%1|r")
 			if (count1+count2 > 0) then
 				return false, msg, author, ...
 			else
 				return false
 			end
 		end
	end

	-- ----------------------------------------------------------------------
	-- chat commands
	-- ----------------------------------------------------------------------
	local function ChatCommand_npce(input)
		local npc = UnitName("target")

		if (npc) then
			if (nil ~= emptynil(input)) then
				SendEmoteMessage(npc,L["TRP2_LOC_EMOTE"], input)
			else
				ShowEmoteEditor(npc,L["TRP2_LOC_EMOTE"],input)
			end
		else
			if (nil ~= emptynil(input)) then
				SendEmoteMessage("", L["TRP2_LOC_EMOTE"], input)
			else
				ShowEmoteEditor(nil,L["TRP2_LOC_EMOTE"],"")
			end
		end
	end

	local function ChatCommand_npcs(input)
		local npc = UnitName("target")
	
		if (npc and (nil ~= emptynil(input))) then
			SendEmoteMessage(npc, L["TRP2_LOC_DIT"], input)
		else
			ShowEmoteEditor(npc,L["TRP2_LOC_DIT"],input)
		end
	end

	local function ChatCommand_npcy(input)
		local npc = UnitName("target")
	
		if (npc and (nil ~= emptynil(input))) then
			SendEmoteMessage(npc, L["TRP2_LOC_CRIE"], input)
		else
			ShowEmoteEditor(npc,L["TRP2_LOC_CRIE"],input)
		end
	end

	local function ChatCommand_npcw(input)
		local npc = UnitName("target")
	
		if (npc and (nil ~= emptynil(input))) then
				SendEmoteMessage(npc, L["TRP2_LOC_WHISPER"], input)
		else
			ShowEmoteEditor(npc,L["TRP2_LOC_WHISPER"],input)
		end
	end

	local function ChatCommand_pete(input)
		local npc = UnitName("pet")

		if (npc and (nil ~= emptynil(input))) then
			SendEmoteMessage(npc, L["TRP2_LOC_EMOTE"], input)
		else
			ShowEmoteEditor(npc,L["TRP2_LOC_EMOTE"],input)
		end
	end

	-- protected methods
	-- function protected.f()
	function protected.OnInitialize()
	 	-- Code that you want to run when the addon is first loaded goes here.
	 end

	function protected.OnEnable()
  	  -- Called when the addon is enabled

		addonDataObject = addon.NewDataObject("", addonDataObject)

		-- migrate legacy options
		if (GnomTEC_NPCEmote_Options) then
			options["Enabled"].set(GnomTEC_NPCEmote_Options["Enabled"])
			options["EnableColorize"].set(GnomTEC_NPCEmote_Options["EnableColorize"])
			options["ShowMinimapIcon"].set(GnomTEC_NPCEmote_Options["Toolbar"])
			GnomTEC_NPCEmote_Options = nil
		end

		if (options["ShowMinimapIcon"].get()) then
			addon.ShowMinimapIcon(addonDataObject)
		end
		
		ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", EmoteChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", SayChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", YellChatFilter)

		addon.RegisterChatCommand("npce", ChatCommand_npce)
		addon.RegisterChatCommand("npcs", ChatCommand_npcs)
		addon.RegisterChatCommand("npcy", ChatCommand_npcy)
		addon.RegisterChatCommand("npcw", ChatCommand_npcw)
		addon.RegisterChatCommand("pete", ChatCommand_pete)

		addon.LogMessage(LOG_INFO, L["L_ENABLED"])
	end

	function protected.OnDisable()
		-- Called when the addon is disabled
		addon.UnregisterAllEvents();
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_EMOTE", EmoteChatFilter)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", EmoteChatFilter)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", EmoteChatFilter)
	end
	
	-- public methods
	-- function self.f()
	function self.SwitchMainWindow(show)
		if (not mainWindowWidgets) then
			mainWindowWidgets = {}

			mainWindowWidgets.mainWindow = GnomTECWidgetContainerWindow({title="GnomTEC NPCEmote", portrait=[[Interface\ICONS\Ability_Rogue_Disguise]], name="EmoteEditor", db=addon.db})
			mainWindowWidgets.mainWindowLayoutV = GnomTECWidgetContainerLayoutVertical({parent=mainWindowWidgets.mainWindow})
			mainWindowWidgets.mainWindowLayoutH = GnomTECWidgetContainerLayoutHorizontal({parent=mainWindowWidgets.mainWindowLayoutV, height="0%"})
			mainWindowWidgets.mainWindowTopSpacer = GnomTECWidgetSpacer({parent=mainWindowWidgets.mainWindowLayoutH, minHeight=34, minWidth=50})
			mainWindowWidgets.mainWindowTargetButton = GnomTECWidgetPanelButton({parent=mainWindowWidgets.mainWindowLayoutH, width="0%", label=L["L_TARGET"]})
			mainWindowWidgets.mainWindowTargetButton.OnClick = OnClickMainWindowTarget
			mainWindowWidgets.mainWindowTargetChar = GnomTECWidgetEditBox({parent=mainWindowWidgets.mainWindowLayoutH, text="", multiLine=false})
			mainWindowWidgets.mainWindowDropDownButton = GnomTECWidgetDropDownButton({parent=mainWindowWidgets.mainWindowLayoutH, width="0%", values={L["TRP2_LOC_EMOTE"], L["TRP2_LOC_DIT"], L["TRP2_LOC_CRIE"], L["TRP2_LOC_WHISPER"]}})
			mainWindowWidgets.mainWindowText = GnomTECWidgetEditBox({parent=mainWindowWidgets.mainWindowLayoutV, text=""})
			mainWindowWidgets.mainWindowSendButton = GnomTECWidgetPanelButton({parent=mainWindowWidgets.mainWindowLayoutV, label=L["L_SEND"]})
			mainWindowWidgets.mainWindowSendButton.OnClick = OnClickMainWindowSend
		end
		
		if (nil == show) then
			if mainWindowWidgets.mainWindow.IsShown() then
				mainWindowWidgets.mainWindow.Hide()
			else
				mainWindowWidgets.mainWindow.Show()
			end
		else
			if show then
				mainWindowWidgets.mainWindow.Show()
			else
				mainWindowWidgets.mainWindow.Hide()
			end
		end
	end


	function	self.ShowAddonTooltip(tooltip)
		tooltip:AddLine("GnomTEC NPCEmote",1.0,1.0,1.0)
		tooltip:AddLine("Hinweis: Links-Klick zum öffnen/schließen",0.0,1.0,0.0)
	end	


	function	self.GetOption(option)
		if (options[option]) then
			return options[option].get()
		else
			addon.LogMessage(LOG_WARN, "Someone tried to get an unknown option (%s)", option or "")
			return nil
		end
	end	

	function	self.SetOption(option, value)
		if (options[option]) then
			options[option].set(value)
		else
			addon.LogMessage(LOG_WARN, "Someone tried to set an unknown option (%s)", option or "")
		end
	end	

	-- constructor
	do
		addon.LogMessage(LOG_INFO, L["L_WELCOME"])
	end
	
	-- return the instance table
	return self
end

-- ----------------------------------------------------------------------
-- Addon Instantiation
-- ----------------------------------------------------------------------

GnomTEC_NPCEmote = GnomTECNPCEmote()






