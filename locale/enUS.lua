-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC_NPCEmote", "enUS", true)
if not L then return end

L["L_DESCRIPTION"] = "Addon to make emotes for NPCs\n\n"
L["L_WELCOME"] = "Welcome to GnomTEC_NPCEmote"
L["L_ENABLED"] = "GnomTEC_NPCEmote enabled"

L["L_OPTIONS_GENERAL"] = "General"
L["L_OPTIONS_GENERAL_ENABLE"] = "Activate NPC emotes"
L["L_OPTIONS_GENERAL_ENABLECOLORIZE"] = "Colorize 'emotes' embedded with '*...*' or '<...> in /s" 
L["L_OPTIONS_GENERAL_SHOWMINIMAPICON"] = "Show icon at minimap for show/hide emote window."

L["TRP2_LOC_DIT"] = "says: "
L["TRP2_LOC_CRIE"] = "yells: "
L["TRP2_LOC_WHISPER"] = "whispers: "
L["TRP2_LOC_EMOTE"] = "emote: "

L["L_TARGET"] = "Target:"
L["L_SEND"] = "Send NPCEmote"
