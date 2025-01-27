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
local fGetHwid = gethwid or function() return game.Players.LocalPlayer.UserId end

--! pick host
local host = "https://api.platoboost.com";
local hostResponse = fRequest({
    Url = host .. "/public/connectivity",
    Method = "GET"
});
if hostResponse.StatusCode ~= 200 or hostResponse.StatusCode ~= 429 then
    host = "https://api.platoboost.net";
end

--!optimize 2
function cacheLink()
    if cachedTime + (10*60) < fOsTime() then
        local response = fRequest({
            Url = host .. "/public/start",
            Method = "POST",
            Body = lEncode({
                service = service,
                identifier = lDigest(fGetHwid())
            }),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        });

        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body);

            if decoded.success == true then
                cachedLink = decoded.data.url;
                cachedTime = fOsTime();
                return true, cachedLink;
            else
                onMessage(decoded.message);
                return false, decoded.message;
            end
        elseif response.StatusCode == 429 then
            local msg = "you are being rate limited, please wait 20 seconds and try again.";
            onMessage(msg);
            return false, msg;
        end

        local msg = "Failed to cache link.";
        onMessage(msg);
        return false, msg;
    else
        return true, cachedLink;
    end
end

--!optimize 1
for _ = 1, 5 do
    local oNonce = generateNonce();
    task.wait(0.2)
    if generateNonce() == oNonce then
        local msg = "platoboost nonce error.";
        onMessage(msg);
        error(msg);
    end
end

--!optimize 2
local copyLink = function()
    local success, link = cacheLink();
    
    if success then
        fSetClipboard(link);
    end
end

-- Nonce generation
local function generateNonce()
    local str = ""
    for _ = 1, 16 do
        str = str .. string.char(fMathRandom(97, 122)) -- Generate random lowercase letters
    end
    return str
end

-- Redeem key function
local function redeemKey(key)
    local nonce = generateNonce()
    local endpoint = "https://api.platoboost.com/public/redeem/" .. tostring(service)

    local body = {
        identifier = lDigest(fGetHwid()), -- Generate HWID identifier
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
    local endpoint = "https://api.platoboost.com/public/whitelist/" .. tostring(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key

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

-- Copy link function (to be called when link is validated)
local function copyLink()
    local linkToCopy = "https://example.com/some-link"  -- Specify the link you want to copy
    setclipboard(linkToCopy) -- Copy link to clipboard
    onMessage("Link copied to clipboard: " .. linkToCopy)
end

-- Initialize Key System (if needed)
local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/OopssSorry/LuaU-Free-Key-System-UI/main/source.lua"))()
local KeyValid = false

local response = KeySystem:Init({
    Debug = false,
    Title = "Luna Hub | Key System",
    Description = nil,
    Link = function()
        copyLink() -- Call copyLink function when key is validated
    end,
    Discord = "test",
    SaveKey = false,
    Verify = function(key)
        KeyValid = verifyKey(key) -- Store key validity
        return KeyValid
    end,
    GuiParent = game.CoreGui
})

if not response or not KeyValid then return end

-- If the key is valid, proceed with additional script actions
print("Key is valid! Proceeding with the script...")

-- Your additional functionalities can be added here.
