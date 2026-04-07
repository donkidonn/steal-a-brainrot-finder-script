getgenv().config = {
    ping_when_coin = 0 -- ping when coin of the brainrot is greater than or equal to this value
    webhook = "WEBHOOK_URL" -- webhook url to send the notification to
}

repeat wait() until game:IsLoaded() -- wait until the game is loaded

-- get the local player and their username
local player = game.Players.LocalPlayer
local username = player.Name

--steal a brainrot informations
local sabPlaceID = 109983668079237
local newPlayerPlaceID = 96342491571673
local serverID -- stores the server ID of the current server
local bigServerID -- stores the server ID that has the big brainrot coin

--roblox functionalities
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local API = "https://games.roblox.com/v1/games/" .. sabPlaceID .. "/servers/Public?limit=100" -- API to get the list of public servers for the sab place

--get jobID
local function getJobID() {
    local success, result = pcall(function() httpService:GetAsync(API) end)
}



