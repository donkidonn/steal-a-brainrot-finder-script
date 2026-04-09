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

--check if the player got kicked then teleport to the same server
--status: working 
local function checkKicked()
    game:GetService('CoreGui').RobloxPromptGui.promptOverlay.ChildAdded
    :Connect(function(child)
        if child.Name == "ErrorPrompt" then
            local jobID = getJobID()
            task.wait(0.5)
            if jobID then
                pcall(function() 
                    teleportService:TeleportToPlaceInstance(sabPlaceID, jobID, player)
                end)
            else
                print("No valid server found after kick!")
            end
        end
    end)
end

--parse value from brainrot generation (value)
local function parseValue(text)
    -- remove $ and /s
    local clean = tostring(text or "")
        :gsub("%$", "")   -- remove $
        :gsub("/s", "")   -- remove /s
        :gsub("%s", "")   -- remove spaces
    
    -- parse number with suffix
    local num, suffix = clean:match("([%d%.]+)([KkMmBbTt]?)")
    if not num then return 0 end
    
    num = tonumber(num) or 0
    local mults = {
        K = 1e3,  k = 1e3,
        M = 1e6,  m = 1e6,
        B = 1e9,  b = 1e9,
        T = 1e12, t = 1e12
    }
    return num * (mults[suffix] or 1) -- return the parsed number (convert text to its number value)
end

--webhook function to send brainrot information to the webhook
local function sendWebhook(brainrotList, webhookUrl)
    local http = getHttp()
    
    -- build the message
    local description = ""
    for _, brainrot in ipairs(brainrotList) do
        description = description .. brainrot.name .. ": " .. brainrot.rawValue .. "\n"
    end
    
    local maxRetries = 3  -- max retry attempts
    local retryCount = 0
    local success = false
    
    repeat
        local err
        success, err = pcall(function()
            http({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = httpService:JSONEncode({
                    embeds = {{
                        title = "Brainrots Found!",
                        description = description,
                        color = 16711680,  -- red color (decimal RGB)
                        
                        -- author section (top of embed)
                        author = {
                            name = username,  -- your player name!
                            icon_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
                        },
                        
                        -- fields (inline key-value pairs)
                        fields = {
                            {
                                name = "Server",
                                value = game.JobId,
                                inline = true
                            },
                            {
                                name = "Players",
                                value = #player_service:GetPlayers() .. "/8",
                                inline = true
                            },
                            {
                                name = "Player",
                                value = username,
                                inline = true
                            }
                        },
                        
                        -- footer (bottom of embed)
                        footer = {
                            text = "Steal A Brainrot • " .. os.date("%X")  -- current time
                        },
                        
                        -- thumbnail (small image top right)
                        thumbnail = {
                            url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
                        }
                    }}
                })
            })
        end)
        
        if not success then
            retryCount = retryCount + 1
            print("Webhook failed, retrying... attempt " .. retryCount .. "/" .. maxRetries)
            task.wait(2)  -- wait 2 seconds before retrying
        end
        
    until success or retryCount >= maxRetries
    
    if not success then
        print("Webhook failed after " .. maxRetries .. " attempts!")
    else
        print("Webhook sent successfully!")
    end
end

--check for brainrots in the server
--working
local function checkBrainrots()
    local lowerbrainrots = {} -- stores 5m to 50m brainrots value
    local higherbrainrots = {} -- stores 50m to 150m brainrots value
    local bigafbrainrots = {} -- stores 150m and above brainrots value
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return end
    
    for _, template in ipairs(debris:GetChildren()) do
        if template.Name == "FastOverheadTemplate" then
            local animalOverhead = template:FindFirstChild("AnimalOverhead")
            if animalOverhead then
                local generation = animalOverhead:FindFirstChild("Generation") -- stores the price of the brainrot ($/s value)
                local displayName = animalOverhead:FindFirstChild("DisplayName") -- stores the display name of the brainrot
                local rarity = animalOverhead:FindFirstChild("Rarity") -- stores brainrot rarity
                local mutations = animalOverhead:FindFirstChild("Mutation") -- stores brainrot mutation
                
                --checks
                if generation and displayName and rarity and generation.ContentText:find("/s") then

                    local value = parseValue(generation.ContentText)
                    local mutationtext = mutations and mutations.ContentText or ""
                    local name = mutationtext .. " " .. displayName.ContentText
                    local unParsedValue = generation.ContentText

                    if value >= 15000000 and value < 50000000 then
                            table.insert(lowerbrainrots, { name = name, value = value, rawValue = unParsedValue })
                            print("Brainrot name: " .. name .. " Value: " .. generation.ContentText .. "Class: lowervalue")  -- "print brainrots"
                        
                    elseif value >= 50000000 and value < 150000000 then
                            table.insert(higherbrainrots, { name = name, value = value, rawValue = unParsedValue })
                            print("Brainrot name: " .. name .. " Value: " .. generation.ContentText .. "Class: highervalue")  -- "print brainrots"
                        
                    elseif value >= 150000000 then
                            table.insert(bigafbrainrots, { name = name, value = value, rawValue = unParsedValue })
                            print("Brainrot name: " .. name .. " Value: " .. generation.ContentText .. "Class: bigafvalue")  -- "print brainrots"
                        
                    end
                end
            end
        end
    end
    if #lowerbrainrots > 0 then
        sendWebhook(lowerbrainrots, getgenv().config.lowtier_webhook)
    end
    if #higherbrainrots > 0 then
        sendWebhook(higherbrainrots, getgenv().config.hightier_webhook)
    end
    if #bigafbrainrots > 0 then
        sendWebhook(bigafbrainrots, getgenv().config.bigtier_webhook)
    end
end

-- main process
checkKicked() -- check if the player got kicked and teleport back to the same server if true

while true do 
    local jobID = getJobID() --stores job ID
    print(jobID) -- print the job ID to see if it's retrieving correctly (can be removed later)

    if jobID then 
        checkBrainrots() -- check for brainrots in the server
        task.wait(getgenv().config.bot_stay) -- wait for the specified time before checking for brainrots
        local success, result = pcall(function() teleportService:TeleportToPlaceInstance(sabPlaceID, jobID, player) end) --teleport to the server with the job ID
        if not success then
            print("Teleport failed:", result)  -- see error
        end
    else 
        task.wait(2) -- waits 5 seconds before trying to get a new job ID if no valid job ID was found
    end
end