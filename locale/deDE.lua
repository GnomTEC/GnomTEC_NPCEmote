local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC_NPCEmote", "deDE")
if not L then return end

L["L_OPTIONS_TITLE"] = "Addon zur Anzeige und Erstellung von NPC Emotes\n\n"
L["L_OPTIONS_ENABLE"] = "NPC Emotes aktivieren"
L["L_OPTIONS_ENABLECOLORIZE"] = "Einfärben von 'Emotes' im /s welche mit '*...*' oder '<...> markiert sind" 
L["L_OPTIONS_TOOLBAR"] = "Zeige Toolbar zum ein- und ausschalten des Emote-Fensters"
L["L_WELCOME"] = "Willkommen bei GnomTEC_NPCEmote"
L["TRP2_LOC_DIT"] = "sagt: "
L["TRP2_LOC_CRIE"] = "schreit: "
L["TRP2_LOC_WHISPER"] = "flüstert: "
L["TRP2_LOC_EMOTE"] = "emote: "