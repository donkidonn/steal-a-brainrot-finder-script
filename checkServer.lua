getgenv().config = {
    ping_when_coin = 0 -- ping when coin of the brainrot is greater than or equal to this value
    webhook = "WEBHOOK_URL" -- webhook url to send the notification to
    min_player_count = 1, -- minimum player count in the server for the bot to join
    fullhop_count = 1, -- number of times the bot wiil attenpt to enter the full server
    bot_stay = 2 -- time in minutes the bot will stay in the server before hopping to another one (if the coin is not found)
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
local API = "https://steal-a-brainrot-server-retrieval.onrender.com/test" -- API to get the list of public servers for the sab place

-- get the right http function for any executor
local function getHttp()
    return http_request or request or http and http.request
end

local function getJobID()
    local http = getHttp() --stores the http request found that the executor supports
    
    --check if the executor supports any http request
    if not http then
        print("No http function found!")
        return nil
    end
    
    -- retrieve raw server list from the api of roblox
    local success, result = pcall(function()
        return http({
            Url = API,
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })
    end)
    
    task.wait(1)
    
    if success then
        -- result.Body contains the response
        local data = httpService:JSONDecode(result.Body)
        
        --checks if the data table exist in the api
        if not data or not data.data then
            print("No server data found! / game is down")
            return nil
        end
        
        local jobIDStorage = {} --stores jobIDs

        --main jobid retrieving process
        for _, server in pairs(data.data) do
            if server.playing >= getgenv().config.min_player_count -- greater or equal to the min player count
            and server.playing < server.maxPlayers  -- not full
            and server.id ~= game.JobId then        -- not current server
                table.insert(jobIDStorage, server.id)
            end
        end

        --return valid random job ID
        if #jobIDStorage > 0 then
            local randomJobID = jobIDStorage[math.random(1, #jobIDStorage)] -- get a random job ID from the storage
            return randomJobID
        end
        
        print("No servers found with minimum player count!")
        return nil
    else
        print("Error getting server list: " .. result)
        return nil
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
--status: to be fixed (near)
local function checkKicked()
    game:GetService('CoreGui').RobloxPromptGui.promptOverlay.ChildAdded
    :Connect(function(child)
        if child.Name == "ErrorPrompt" then
            local jobID = getJobID()
            task.wait(0.5)
            local hopcount = 0
            repeat
                pcall(function() teleportService:TeleportToPlaceInstance(sabPlaceID, jobID, player) end)
                hopcount = hopcount + 1
                task.wait(5)
            until character or hopcount >= getgenv().config.fullhop_count
        end
    end)
end

--check for brainrots in the server
--not pa finish
local function checkBrainrots()
    --debug purposes
    local success, brainrot = pcall(function() return workspace:FindFirstChild("Brainrot") end)
    if success and brainrot then
        for _, value in pairs(brainrot) do 

-- main process
checkKicked() -- check if the player got kicked and teleport back to the same server if true

while true do 
    local jobID = getJobID() --stores job ID
    print(jobID)
    if jobID then 
        task.wait(getgenv().config.bot_stay) --check if the player got kicked and teleport back to the same server if true
        local success, result = pcall(function() teleportService:TeleportToPlaceInstance(sabPlaceID, jobID, player) end) --teleport to the server with the job ID
        if not success then
            print("Teleport failed:", result)  -- see error
        end
    else 
        task.wait(5)
    end
end

    

