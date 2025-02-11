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
    else
        game.Players.LocalPlayer:Kick("Sorry this games is not supported. Supported Game")
    end
else
    warn("Script not working this game. Please wait before trying again.")
end
