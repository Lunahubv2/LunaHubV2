local KeyValid,KeyPremium, KeysystemLibrary, PlatoboostLibrary = false,false,loadstring(game:HttpGet("https://raw.githubusercontent.com/jessajeal02/Lunahub/refs/heads/main/data/gui.lua"))(),loadstring(game:HttpGet("https://raw.githubusercontent.com/jessajeal02/LunaHubV2/refs/heads/main/API/booster.lua"))()

local service = 362;  -- your service id, this is used to identify your service.
local secret = "d4a12638-daa3-4728-ab9c-f1c5543ca55d";  -- make sure to obfuscate this if you want to ensure security.
local useNonce = true;  -- use a nonce to prevent replay attacks and request tampering.

-- https://github.com/OopssSorry/LuaU-Free-Key-System-UI
local KSresponse = KeysystemLibrary:Init({
	Title="Luna Hub",  -- TITLE HERE
	
	SaveKey=true, 
	Debug=false, 
	Link=PlatoboostLibrary.getLink(), 
	Verify=function(key) 
		if Platoboost.validateDefaultKey(key) then
			KeyValid=true
		elseif PlatoboostLibrary.validatePremiumKey(key) then
			KeyValid,KeyPremium=true,true
		end;
		return KeyValid
	end,
}) 

-- return nil on closing key system
if not KSresponse or not KeyValid then return end 
