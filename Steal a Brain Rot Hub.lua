-- Steal a Brain Rot Hub by NovaRise Studios
-- OrionLib-Based UI

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPConnections = {}
local ESPBoxes = {}
local noClipConn
local noClipEnabled = false

-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "Steal a Brain Rot Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BrainRotHub",
    IntroEnabled = true,
    IntroText = "Welcome to the Brain Rot Hub!",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})

-- Main Tab
local mainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})
mainTab:AddLabel("Brain Rot Hub • Version 1.0")
mainTab:AddParagraph("Credits", "Developed by NovaRise Studios")

-- Player Tab
local playerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})

playerTab:AddSlider({
    Name = "Speed Boost",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Callback = function(v)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = v end
    end
})

playerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(v)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = v end
    end
})

playerTab:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(val)
        noClipEnabled = val
        if noClipConn then noClipConn:Disconnect() end
        if val then
            noClipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

playerTab:AddToggle({
    Name = "ESP (Wallhack)",
    Default = false,
    Callback = function(state)
        if state then
            ESPConnections.esp = RunService.RenderStepped:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        local head = player.Character.Head
                        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if not ESPBoxes[player] then
                            local box = Drawing.new("Square")
                            box.Color = Color3.fromRGB(255, 0, 0)
                            box.Thickness = 2
                            box.Size = Vector2.new(60, 60)
                            box.Filled = false
                            ESPBoxes[player] = box
                        end
                        if onScreen then
                            ESPBoxes[player].Visible = true
                            ESPBoxes[player].Position = Vector2.new(pos.X - 30, pos.Y - 30)
                        else
                            ESPBoxes[player].Visible = false
                        end
                    end
                end
            end)
        else
            if ESPConnections.esp then ESPConnections.esp:Disconnect() end
            for _, box in pairs(ESPBoxes) do
                box:Remove()
            end
            ESPBoxes = {}
        end
    end
})

playerTab:AddButton({
    Name = "Invisible Mode",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 1
                end
            end
        end
    end
})

-- STEAL Tab
local stealTab = Window:MakeTab({Name = "STEAL", Icon = "rbxassetid://4483345998", PremiumOnly = false})
stealTab:AddToggle({
    Name = "Big Brain Rot Hitboxes",
    Default = false,
    Callback = function(state)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part.Name:lower():find("brain") and part:IsA("BasePart") then
                        part.Size = state and Vector3.new(10, 10, 10) or Vector3.new(2, 2, 2)
                        part.Transparency = state and 0.5 or 0
                        part.Material = state and Enum.Material.Neon or Enum.Material.Plastic
                    end
                end
            end
        end
    end
})

OrionLib:Init()
