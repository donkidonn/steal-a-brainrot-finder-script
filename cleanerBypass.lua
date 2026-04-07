local TeleportService = game:GetService("TeleportService")
pcall(function() TeleportService:SetTeleportGui(workspace) end) -- set GUI before load

---wait until the game is loaded and the local player is available
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game:GetService("Players").LocalPlayer

--local player and username
local player = game:GetService("Players").LocalPlayer
local username = player.Name

--sab information
local sabPlaceID = 109983668079237
local newPlayerPlaceID = 96342491571673

--cancel teleport in new player server
if game.PlaceId == newPlayerPlaceID then
    pcall(function() TeleportService:TeleportCancel() end)
    task.wait(0.5)
    pcall(function() TeleportService:SetTeleportGui(nil) end)
    task.wait(0.5)
    pcall(function() TeleportService:Teleport(sabPlaceID, player) end)
end

-- fallback cleanup in case the teleport cancelation doesn't work
task.wait(2)
pcall(function() TeleportService:TeleportCancel() end)
pcall(function() TeleportService:SetTeleportGui(nil) end)