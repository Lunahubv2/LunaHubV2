repeat wait() until game:IsLoaded()

local PlaceId = game.PlaceId
local lastExecutionTime = 0
local executionCooldown = 15 -- 5 seconds cooldown between script executions

local function canExecute()
    local currentTime = tick()
    if currentTime - lastExecutionTime >= executionCooldown then
        lastExecutionTime = currentTime
        return true
    end
    return false
end

if canExecute() then
    if PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 then
        -- Blox Fruit
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/settings.lua"))()
    elseif PlaceId == 16732694052 then
        -- Fisch
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/Local/Fisch.lua"))()
    elseif PlaceId == 0000000 then
        -- Rivals
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Script-Blox/Script/main/Script-Blox"))()
    elseif PlaceId == 0000000 then
        -- Arsenal
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Script-Blox/Script/main/Script-Blox"))()
    else
        warn("This game is not supported.")
    end
else
    warn("Script execution is on cooldown. Please wait before trying again.")
end
