--! Platoboost configuration
local service = 362  -- Your service ID, this is used to identify your service.
local secret = "b613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad";  -- Obfuscate this for security.
local useNonce = true;  -- Use a nonce to prevent replay attacks and request tampering.

-- Callbacks
local onMessage = function(message) print(message) end; -- Print messages to console

-- Wait for game to load
repeat task.wait(1) until game:IsLoaded();

-- Functions
local requestSending = false;
local fSetClipboard = setclipboard or toclipboard;
local fRequest = request or http_request or syn_request;
local fOsTime = os.time;
local fMathRandom = math.random;
local fGetHwid = gethwid or function() return game.Players.LocalPlayer.UserId end

local cachedLink, cachedTime = "", 0;

-- Pick host
local host = "https://api.platoboost.com";
local hostResponse = fRequest({
    Url = host .. "/public/connectivity",
    Method = "GET"
});
if hostResponse.StatusCode ~= 200 then
    host = "https://api.platoboost.net";
end

-- Cache link
function cacheLink()
    if cachedTime + (10 * 60) < fOsTime() then
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
            onMessage("You are being rate limited, please wait 20 seconds and try again.");
            return false;
        end

        onMessage("Failed to cache link.");
        return false;
    else
        return true, cachedLink;
    end
end

-- Initialize cache link
cacheLink();

-- Generate nonce
local generateNonce = function()
    local str = ""
    for _ = 1, 16 do
        str = str .. string.char(math.floor(fMathRandom() * (122 - 97 + 1)) + 97)
    end
    return str
end

-- Redeem key function
local redeemKey = function(key)
    local nonce = generateNonce();
    local endpoint = host .. "/public/redeem/" .. tostring(service);

    local body = {
        identifier = lDigest(fGetHwid()),
        key = key
    }

    if useNonce then
        body.nonce = nonce;
    end

    local response = fRequest({
        Url = endpoint,
        Method = "POST",
        Body = lEncode(body),
        Headers = {
            ["Content-Type"] = "application/json"
        }
    });

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success == true and decoded.data.valid == true then
            return true;
        else
            onMessage("Key is invalid.");
            return false;
        end
    elseif response.StatusCode == 429 then
        onMessage("You are being rate limited, please wait 20 seconds and try again.");
        return false;
    else
        onMessage("Server returned an invalid status code, please try again later.");
        return false; 
    end
end

-- Verify key function
local verifyKey = function(key)
    if requestSending == true then
        onMessage("A request is already being sent, please slow down.");
        return false;
    else
        requestSending = true;
    end

    local nonce = generateNonce();
    local endpoint = host .. "/public/whitelist/" .. tostring(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;

    if useNonce then
        endpoint = endpoint .. "&nonce=" .. nonce;
    end

    local response = fRequest({
        Url = endpoint,
        Method = "GET",
    });

    requestSending = false;

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);

        if decoded.success == true and decoded.data.valid == true then
            return true;
        else
            return redeemKey(key);
        end
    else
        onMessage("Server returned an invalid status code, please try again later.");
        return false;
    end
end

-- Initialize Key System
local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/OopssSorry/LuaU-Free-Key-System-UI/main/source.lua"))()
local KeyValid = false

local response = KeySystem:Init({
    Debug = false,
    Title = "Luna Hub | Key System",
    Description = nil,
    Link = copyLink(),
    Discord = "test",
    SaveKey = false,
    Verify = function(key)
        return verifyKey(key)
    end,
    GuiParent = game.CoreGui,
})

if not response or not KeyValid then return end

-- Here you would write your additional script actions after key validation.
print("Key is valid! Proceeding with the script...");

-- Example platform boost effect (or any other functionality you want)
-- Add your custom functionality here after the key has been validated.
