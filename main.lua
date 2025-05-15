-- Platoboost configuration
local service = 362  -- Your service ID
local secret = "b613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad"  -- Your secret key for security
local useNonce = true  -- Use a nonce to prevent replay attacks

-- Callbacks
local onMessage = function(message) 
    print(message) -- Print messages to console for debugging
end

-- Wait for the game to load completely
repeat task.wait(1) until game:IsLoaded()

-- Functions
local requestSending = false
local fRequest = request or http_request or syn_request
local fOsTime = os.time
local fMathRandom = math.random
local fGetUserId = function() return game.Players.LocalPlayer.UserId end -- Changed from HWID to UserId
local cachedLink, cachedTime = "", 0 -- Variables for caching

-- Pick host
local host = "https://api.platoboost.com"
local hostResponse = fRequest({
    Url = host .. "/public/connectivity",
    Method = "GET"
})
if hostResponse.StatusCode ~= 200 then
    host = "https://api.platoboost.net"
end

-- Function to encode data to JSON
local function lEncode(data)
    return game:GetService("HttpService"):JSONEncode(data)
end

-- Function to decode JSON data
local function lDecode(data)
    return game:GetService("HttpService"):JSONDecode(data)
end

-- Cache Link Function
function cacheLink()
    if (not cachedLink or cachedTime + (10 * 60) < fOsTime()) then
        local response = fRequest({
            Url = host .. "/public/start",
            Method = "POST",
            Body = lEncode({
                service = service,
                identifier = fGetUserId() -- Now using UserId
            }),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })

        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body)

            if decoded.success then
                cachedLink = decoded.data.url
                cachedTime = fOsTime()
                return true, cachedLink
            else
                onMessage(decoded.message)
                return false, decoded.message
            end
        elseif response.StatusCode == 429 then
            local msg = "You are being rate limited, please wait 20 seconds and try again."
            onMessage(msg)
            return false, msg
        end

        local msg = "Failed to cache link."
        onMessage(msg)
        return false, msg
    else
        return true, cachedLink
    end
end

-- Nonce generation
local function generateNonce()
    local str = ""
    for _ = 1, 8 do
        str = str .. string.char(fMathRandom(97, 122)) -- Generate random lowercase letters
    end
    return str
end

-- Copy link function
local function copyLink()
    local success, link = cacheLink()
    
    if success then
        setclipboard(link)
        onMessage("Link copied to clipboard: " .. link)
    end
end

-- Redeem key function
local function redeemKey(key)
    local nonce = generateNonce()
    local endpoint = host .. "/public/redeem/" .. tostring(service)

    local body = {
        identifier = fGetUserId(), -- Now using UserId
        key = key,
        nonce = useNonce and nonce or nil
    }

    local response = fRequest({
        Url = endpoint,
        Method = "POST",
        Body = lEncode(body),
        Headers = { ["Content-Type"] = "application/json" }
    })

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body)
        if decoded.success and decoded.data.valid then
            onMessage("Key redeemed successfully!")

            -- Push update to GitHub repository
            local token = "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" -- Replace with your personal access token
            local owner = "Lunahubv2" -- Replace with your GitHub username
            local repo = "LunaHubV2" -- Replace with your repository name
            local path = "PlayerKey/Users" .. game.Players.LocalPlayer.UserId .. ".txt" -- Replace with the desired file path and name

            local updateBody = {
                message = "Add redeemed key",
                content = key,
            }

            local updateResponse = fRequest({
                Url = string.format("https://api.github.com/repos/%s/%s/contents/%s", owner, repo, path),
                Method = "PUT",
                Body = lEncode(updateBody),
                Headers = {
                    ["Authorization"] = "token " .. token,
                    ["Content-Type"] = "application/json",
                },
            })

            if updateResponse.StatusCode == 201 then
                onMessage("Key saved successfully to GitHub repository.")
            else
                onMessage("Error saving key to GitHub repository: " .. updateResponse.StatusCode)
            end

            return true
        else
            onMessage("Invalid key.")
            return false
        end
    else
        onMessage("Error redeeming key: " .. response.StatusCode)
        return false
    end
end

-- Verify key function
local function verifyKey(key)
    if requestSending then
        onMessage("A request is already being sent, please slow down.")
        return false
    else
        requestSending = true
    end

    local nonce = generateNonce()
    local endpoint = host .. "/public/whitelist/" .. tostring(service) .. "?identifier=" .. fGetUserId() .. "&key=" .. key

    if useNonce then
        endpoint = endpoint .. "&nonce=" .. nonce
    end

    local response = fRequest({
        Url = endpoint,
        Method = "GET"
    })

    requestSending = false

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body)
        if decoded.success and decoded.data.valid then
            onMessage("Key is valid!")
            return true
        else
            return redeemKey(key) -- Try redeeming the key if it is not valid
        end
    else
        onMessage("Error verifying key: " .. response.StatusCode)
        return false
    end
end

-- Load UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Key System UI
local Window = Fluent:CreateWindow({
    Title = "Luna Hub V2",
    SubTitle = "- Key System",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 340),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    KeySys = Window:AddTab({ Title = "Key System", Icon = "key" }),
}

local Entkey -- Declare the variable here for scope access later

-- Input for key
Entkey = Tabs.KeySys:AddInput("Input", {
    Title = "Enter Key",
    Description = "Enter Key Here",
    Default = "",
    Placeholder = "Enter key…",
    Numeric = false,
    Finished = false,
    Callback = function(inputKey)
        Entkey.Value = inputKey -- Capture the input correctly
    end
})

-- Check Key Button
local Checkkey = Tabs.KeySys:AddButton({
    Title = "Check Key",
    Description = "Enter Key before pressing this button",
    Callback = function()
        local key = Entkey.Value -- Get the value of the input field
        print("Entered Key: " .. key) -- Debug: Print the key
        local validKey = verifyKey(key) -- Use the function to verify the key
        
        if validKey then
            print("Key is valid")
            -- Remove the entire UI window
            Window:Destroy() -- This removes the UI
            
            -- Load another script
            local newScriptURL = "https://raw.githubusercontent.com/Lunahubv2/LunaHubV2/refs/heads/main/source.lua" -- Change this to your actual script URL
            local success, err = pcall(function()
                loadstring(game:HttpGet(newScriptURL))()
            end)

            if success then
               game:GetService("StarterGui"):SetCore("SendNotification", {
                   Title = "Luna Hub V2", -- Required
                   Text = "script loaded successfully!", -- Required
                   Icon = "rbxassetid://1234567890" -- Optional
                })
            else
                print("Error loading new script: " .. err)
            end
            
        else
            print("Key is invalid")
        end
    end
})


-- Get Key Button
local Getkey = Tabs.KeySys:AddButton({
    Title = "Get Key",
    Description = "Get Key here",
    Callback = function()
        copyLink() -- Assuming copyLink is defined somewhere in your script
    end
})

Window:SelectTab(1) -- Select the first tab by default

-- Status Configuration
local StatusTab = Window:AddTab({ Title = "Status", Icon = "" })

-- Button for Blox Fruit Status
StatusTab:AddButton({
    Title = "🟡  Blox Fruit",
    Description = "Script Working properly!",
})

-- Button for Grow a Garden Status
StatusTab:AddButton({
    Title = "🟢  Grow a Garden",
    Description = "Script Working properly!",
})

-- Button for Grow a Dead Rials Status
StatusTab:AddButton({
    Title = "🔴 Dead Rails",
    Description = "Script Working properly!",
})

-- Button for Fisch Status
StatusTab:AddButton({
    Title = "🔴  Fisch",
    Description = "Script Working properly!",
})

-- Button for Rivals Status
StatusTab:AddButton({
    Title = "⚫  Rivals",
    Description = "Sorry Script Not Working properly!",
})

-- Button for The Strongest Battlegrounds Status
StatusTab:AddButton({
    Title = "⚫  The Strongest Battlegrounds",
    Description = "Sorry Script Not Working properly!",
})

-- Button for The Mimic Status
StatusTab:AddButton({
    Title = "⚫  The Mimic",
    Description = "Sorry Script Not Working properly!",
})

-- Button for Arsenal Status
StatusTab:AddButton({
    Title = "⚫ Arsenal",
    Description = "Sorry Script Not Working properly!",
})
