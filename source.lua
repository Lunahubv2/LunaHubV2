repeat wait(1) until game:IsLoaded()
local PlaceId = game.PlaceId
if PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 then
        -- Blox Fruit
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/settings.lua"))()
elseif PlaceId == 16732694052 then
        -- Fisch
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/Local/Fisch.lua"))()
elseif PlaceId == 17625359962 then
        -- Rivals
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/Local/BLRivals.lua"))()
elseif PlaceId == 0000000 then
        -- Arsenal
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Script-Blox/Script/main/Script-Blox"))()
        -- Grow a Garden
elseif PlaceId == 126884695634066 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/Local/Grow.lua"))()
        -- Dead Rials
elseif PlaceId == 116495829188952 or 70876832253163 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/Local/Deadrials.lua"))()
else
    game.Players.LocalPlayer:Kick("Sorry this games is not supported or ask administrator fix it.")
end
