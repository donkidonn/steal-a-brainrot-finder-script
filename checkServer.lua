getgenv().config = {
    ping_when_coin = 0 -- ping when coin of the brainrot is greater than or equal to this value
    webhook = "WEBHOOK_URL" -- webhook url to send the notification to
    min_player_count = 1 -- minimum player count in the server for the bot to join
    fullhop_count = 1 -- number of times the bot wiil attenpt to enter the full server
}

repeat wait() until game:IsLoaded() -- wait until the game is loaded

-- get the local player and their username
local player_service = game:GetService("Players")
local player = game.Players.LocalPlayer
local username = player.Name
local character = player.Character or player.CharacterAdded:Wait() -- get the player's character

--steal a brainrot informations
local sabPlaceID = 109983668079237
local newPlayerPlaceID = 96342491571673
local bigServerID -- stores the server ID that has the big brainrot coin
local oldServerID = {}  -- stores the server IDs that have been checked 

--roblox functionalities
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local API = "https://games.roblox.com/v1/games/" .. sabPlaceID .. "/servers/Public?limit=100" -- API to get the list of public servers for the sab place

--get jobID
local function getJobID() 
    local success, result = pcall(function() return httpService:GetAsync(API) end)
    task.wait(1) -- wait for 1 second to avoid spamming the API
    if success then
        local data = httpService:JSONDecode(result) -- decode the JSON response from the API
        for _, server in pairs(data.data) do
            if server.playing >= getgenv().config.min_player_count then --checks if the server has the minimum player count
                return server.id -- return the server ID if it has the minimum player count
            end
        end
    else
        print("Error getting server list: " .. result)
    end
end

--[[
--server hop i guess
local function checkServer ()
    local jobID = getJobID()
    if jobID then 
        if not table.find(oldServerID, jobID) then -- checks if the jobID exist in oldServerID
            table.insert(oldServerID, jobID)
            teleportService:TeleportToPlaceInstance(sabPlaceID, jobID, player)
            task.wait(5)
            return #player_service:GetPlayers() -- return the player count in the server (debug purposes
        end
    end
end
]]

--check if the player got kicked then teleport to the same server
local function checkKicked()
    game:GetService('CoreGui').RobloxPromptGui.promptOverlay.ChildAdded
    :Connect(function(child)
        if child.Name == "ErrorPrompt" then
            local jobID = getJobID()
            task.wait(0.5)
            repeat
                local hopcount = 0
                pcall(function() teleportService:TeleportToPlaceInstance(sabPlaceID, jobID, player) end)
                hopcount = hopcount + 1
                task.wait(5)
            until character or getgenv().config.fullhop_count == hopcount
            end
        end
    end)

--check for brainrots in the server
local function checkBrainrots()
    --debug purposes
    local success, brainrot = pcall(function() return workspace:FindFirstChild("Brainrot") end)
    if success and brainrot then
        for _, value in pairs(brainrot) do 

-- main process
while true do 
    local jobID = getJobID() --stores job ID
    if jobID then 
        if not table.find(oldServerID, jobID) then -- checks if the jobID exist in oldServerID
            table.insert(oldServerID, jobID)
            teleportService:TeleportToPlaceInstance(sabPlaceID, jobID, player)
            task.wait(5)
            
        end
    end

    

