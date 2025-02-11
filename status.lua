repeat wait(1) until game:IsLoaded()
local PlaceId = game.PlaceId
if PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 then

local function sendNotification()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Blox Fruit ", -- Required
        Text = "Script Working Properly", -- Required
        Icon = "rbxassetid://1234567890" -- Optional
    })
    
    wait(10) -- Adjust the number of seconds as needed
end

sendNotification()
elseif PlaceId == 16732694052 then
        -- Fisch
    local function sendNotification()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Fisch -- Online", -- Required
        Text = "Script Working Properly", -- Required
        Icon = "rbxassetid://1234567890" -- Optional
    })
    
    wait(10) -- Adjust the number of seconds as needed
end

sendNotification()
elseif PlaceId == 17625359962 then
        -- Rivals
    local function sendNotification()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Rivals -- Offline ", -- Required
        Text = "Script Working Properly", -- Required
        Icon = "rbxassetid://1234567890" -- Optional
    })
    
    wait(10) -- Adjust the number of seconds as needed
end

sendNotification()
elseif PlaceId == 0000000 then
        
    local function sendNotification()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Blox Fruit ", -- Required
        Text = "Script Working Properly", -- Required
        Icon = "rbxassetid://1234567890" -- Optional
    })
    
    wait(10) -- Adjust the number of seconds as needed
end

sendNotification()
else
    game.Players.LocalPlayer:Kick("Sorry this games is not supported. Supported Game")
end
