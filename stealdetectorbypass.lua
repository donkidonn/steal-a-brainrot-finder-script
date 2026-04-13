local net = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local lastStolenInfo = nil
local templateCache = {}

local function updateCache()
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return end
    for _, template in ipairs(debris:GetChildren()) do
        if template.Name == "FastOverheadTemplate" then
            local overhead = template:FindFirstChild("AnimalOverhead")
            if overhead then
                local displayName = overhead:FindFirstChild("DisplayName")
                local generation  = overhead:FindFirstChild("Generation")
                local mutation    = overhead:FindFirstChild("Mutation")
                local rarity      = overhead:FindFirstChild("Rarity")
                local price       = overhead:FindFirstChild("Price")
                local stolenLabel = overhead:FindFirstChild("Stolen")

                if displayName and displayName.ContentText ~= "" then
                    local existing = templateCache[template]
                    local mutationFinal = "None"
                    local isStolen = false

                    if mutation and mutation.Visible and mutation.ContentText ~= "" then
                        mutationFinal = mutation.ContentText
                    elseif existing and existing.mutation ~= "None" then
                        mutationFinal = existing.mutation
                    end

                    if stolenLabel and stolenLabel.Visible and stolenLabel.ContentText == "STOLEN" then
                        isStolen = true
                    elseif existing and existing.isStolen then
                        isStolen = existing.isStolen
                    end

                    templateCache[template] = {
                        name     = displayName.ContentText,
                        value    = generation and generation.ContentText or "?",
                        mutation = mutationFinal,
                        rarity   = rarity and rarity.ContentText or "?",
                        price    = price  and price.ContentText  or "?",
                        isStolen = isStolen,
                    }
                end
            end
        end
    end
    for template in pairs(templateCache) do
        if not template.Parent then templateCache[template] = nil end
    end
end

task.spawn(function()
    while true do
        updateCache()
        task.wait(0.1)
    end
end)

local function findBrainrot(targetName)
    local stolenMatch = nil
    local fallback = nil

    for template, info in pairs(templateCache) do
        if info.name:lower() == targetName:lower() then
            if info.isStolen then
                stolenMatch = info
                info.isStolen = false
                break
            end
            fallback = info
        end
    end

    return stolenMatch or fallback
end

for _, v in pairs(net:GetChildren()) do
    if v:IsA("RemoteEvent") then
        v.OnClientEvent:Connect(function(msg, duration, sound)
            if type(msg) == "string" and sound == "Sounds.Sfx.Success" and msg:find("stole") then
                local name = msg:match(">(.+)<") or msg
                lastStolenInfo = findBrainrot(name)
                    or { name = name, value = "?", mutation = "None", rarity = "?", price = "?" }
            end
        end)

        v.OnClientEvent:Connect(function(...)
            if #{...} == 0 and lastStolenInfo then
                task.delay(0.1, function()
                    if not lastStolenInfo then return end
                    local i = lastStolenInfo
                    print("=== STEAL CONFIRMED ===")
                    print("Name:     " .. i.name)
                    print("Value:    " .. i.value)
                    print("Mutation: " .. i.mutation)
                    print("Rarity:   " .. i.rarity)
                    print("Price:    " .. i.price)
                    print("Time:     " .. os.date("%X"))
                    print("=======================")
                    lastStolenInfo = nil
                end)
            end
        end)
    end
end

print("Steal detector running!")