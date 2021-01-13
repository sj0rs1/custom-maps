workspace:WaitForChild("Map")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local client = getsenv(LocalPlayer.PlayerGui.Client)
local mapid = getgenv().modelid
local stom = client.setcharacter

local map = game:GetObjects("rbxassetid://"..mapid)[1]
map.Name = "custommap"
map.Parent = workspace
map:MoveTo(Vector3.new(0,3,0))

function updateMap(o)
    local T,CT = o:WaitForChild("TSpawns"),o:WaitForChild("CTSpawns")
    for i,v in next, T:GetChildren() do
        v.Position = map.spawns.T:GetChildren()[math.random(1,#map.spawns.T:GetChildren())].Position
    end
    for i,v in next, CT:GetChildren() do
        v.Position = map.spawns.CT:GetChildren()[math.random(1,#map.spawns.CT:GetChildren())].Position
    end
end
updateMap(workspace.Map)
LocalPlayer.CharacterAdded:connect(function(char)
    if LocalPlayer.Status.Team.Value == "Spectator" then repeat wait() until LocalPlayer.Status.Team.Value ~= "Spectator" end
    char:WaitForChild("HumanoidRootPart")
    wait(0.8)
    local folder = workspace.Map[LocalPlayer.Status.Team.Value .. "Spawns"]
    LocalPlayer.Character:SetPrimaryPartCFrame(folder:GetChildren()[math.random(1, #folder:GetChildren())].CFrame * CFrame.new(0, 4, 0))
    wait(0.8)
    stom()
end)
workspace.ChildAdded:connect(function(th)
    if th.Name == "Map" then updateMap(th) end
end)
client.setcharacter = function()end
UserInputService.InputBegan:connect(function(k)
    if k.KeyCode == Enum.KeyCode.B and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and not client.Buymenuframe.Visible then
        client.Buymenuframe.Visible = true
        client.BuyMenuOpen = true
    end
end)
while wait() do
    if map:FindFirstChild("settings") then
        if map.settings:FindFirstChild("gravity") then
            workspace.Gravity = map.settings.gravity.Value
        else
            workspace.Gravity = 80
        end
    end
end
