repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local PlaceId = game.PlaceId
local lastExecutionTime = 30
local executionCooldown = 30 -- 5 seconds cooldown between script executions

-- Anti-spam variables
local spamCount = 0
local spamLimit = 1 -- Number of messages allowed before kick
local timeFrame = 5 -- Time frame in seconds to count messages
local messageTimestamps = {}

local function onPlayerChatted(player, message)
    local currentTime = tick()

    -- Remove timestamps older than the time frame
    for i = #messageTimestamps, 1, -1 do
        if messageTimestamps[i] < currentTime - timeFrame then
            table.remove(messageTimestamps, i)
        end
    end

    -- Add the current message timestamp
    table.insert(messageTimestamps, currentTime)

    -- Check if the player has exceeded the spam limit
    if #messageTimestamps > spamLimit then
        player:Kick("You have been kicked for spamming.")
    end
end

-- Connect the chat event
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)

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
        game.Players.LocalPlayer:Kick("This game is not supported")
    end
else
    warn("Script execution is on cooldown. Please wait before trying again.")
end
