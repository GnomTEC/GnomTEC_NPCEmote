local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC_NPCEmote", "deDE")
if not L then return end

L["L_DESCRIPTION"] = "Addon zur Anzeige und Erstellung von NPC Emotes\n\n"
L["L_WELCOME"] = "Willkommen bei GnomTEC_NPCEmote"
L["L_ENABLED"] = "GnomTEC_NPCEmote aktiviert"

L["L_OPTIONS_GENERAL"] = "Allgemein"
L["L_OPTIONS_GENERAL_ENABLE"] = "NPC Emotes aktivieren"
L["L_OPTIONS_GENERAL_ENABLECOLORIZE"] = "Einfärben von 'Emotes' im /s welche mit '*...*' oder '<...> markiert sind" 
L["L_OPTIONS_GENERAL_SHOWMINIMAPICON"] = "Zeige Icon an der Minimap zum ein- und ausschalten des Emote-Fensters"

L["TRP2_LOC_DIT"] = "sagt: "
L["TRP2_LOC_CRIE"] = "schreit: "
L["TRP2_LOC_WHISPER"] = "flüstert: "
L["TRP2_LOC_EMOTE"] = "emote: "

L["L_TARGET"] = "Ziel:"

L["L_SEND"] = "Sende NPCEmote"