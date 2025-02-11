-- Function to send notification
local function sendNotification()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Luna Hub V2", -- Required
        Text = "The Key is Invalid. Please Try Again!", -- Required
        Icon = "rbxassetid://1234567890" -- Optional
    })
    
    -- Wait for a few seconds before closing (this does not actually close the notification)
    wait(5) -- Adjust the number of seconds as needed
end

-- Call the function to send the notification
sendNotification()
