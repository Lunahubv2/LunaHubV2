local player = game.Players.LocalPlayer
local teams = game:GetService("Teams")

-- Change "Pirates" to "Marines" if you want to join Marines instead
local desiredTeam = "Marines"

-- Function to join a team
local function joinTeam()
    if teams:FindFirstChild(desiredTeam) then
        player.Team = teams[desiredTeam]
        print("Joined team: " .. desiredTeam)
    else
        print("Team does not exist!")
    end
end

-- Wait for the game to load
game.Players.PlayerAdded:Wait()
joinTeam()
 
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/Local/Bloxfruit.lua"))
