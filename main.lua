getgenv().looped = false
workspace:WaitForChild("Map")
local Enabled = true
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local mapid = getgenv().modelid
local map

function updateMap(o)
    if not Enabled then return end
    if map then map:Destroy(); map = nil end
    map = game:GetObjects("rbxassetid://"..mapid)[1]
    map.Name = "custommap"
    map.Parent = workspace
    map:MoveTo(Vector3.new(0,1500,0))
    for i,v in next, map:GetDescendants() do
        pcall(function()
            v.Anchored = true
        end)
    end
end
workspace.ChildAdded:connect(function(th)
    if th.Name == "Map" then updateMap(th) end
end)

getgenv().looped = true
updateMap(workspace.Map)
while getgenv().looped do wait()
    if map:FindFirstChild("settings") then
        if map.settings:FindFirstChild("gravity") then
            workspace.Gravity = map.settings.gravity.Value
        else
            workspace.Gravity = 80
        end
        if map.settings:FindFirstChild("time") then
            game.Lighting.TimeOfDay = map.settings.time.Value
        end
        if map.settings:FindFirstChild("skybox") then
            if not game.Lighting:FindFirstChild("customsky") then
                if game.Lighting:FindFirstChild("skybox") then
                    game.Lighting.skybox:Destroy()
                end
                if game.Lighting:FindFirstChild("SunRays") then
                    game.Lighting.SunRays.Enabled = false
                end
                local skybox = map.settings.skybox:Clone()
                skybox.Parent = game.Lighting
            end
        end
    end
    if map and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        local folder = map.spawns[LocalPlayer.Status.Team.Value]
        if folder then
            local ypos = LocalPlayer.Character.PrimaryPart.Position.Y
            local spawnpos = folder:GetChildren()[1].Position.Y
            if spawnpos - 50 > ypos then
                LocalPlayer.Character:SetPrimaryPartCFrame(folder:GetChildren()[math.random(1, #folder:GetChildren())].CFrame * CFrame.new(0,3,0))
            end
        end
    end
end

Enabled = false
workspace.Gravity = 80
if map then map:Destroy(); map = nil end
