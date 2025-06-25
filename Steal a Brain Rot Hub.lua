-- Steal a Brain Rot Hub | Created by NovaRise Studios
-- OrionLib UI Hub Script

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Init
local Window = OrionLib:MakeWindow({
    Name = "BrainRot Hub | NovaRise Studios",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BrainRotHub",
    IntroEnabled = true,
    IntroText = "Steal a Brain Rot | NovaRise Studios",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998",
})

-- Tabs
local mainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local playerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})
local stealTab = Window:MakeTab({Name = "STEAL", Icon = "rbxassetid://4483345998"})

-- Main Content
mainTab:AddLabel("Version: v1.0.0")
mainTab:AddParagraph("Credits", "Developed by NovaRise Studios")

-- Player Tab Logic
local speedConn, jumpConn, noclipConn, espConn
local DesiredSpeed, DesiredJump = 16, 50
local invisEnabled = false

playerTab:AddSlider({
    Name = "Speed Boost",
    Min = 16, Max = 100, Default = 16, Increment = 1,
    Callback = function(value)
        DesiredSpeed = value
        if speedConn then speedConn:Disconnect() end
        speedConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = DesiredSpeed
            end
        end)
    end
})

playerTab:AddSlider({
    Name = "Jump Power",
    Min = 50, Max = 100, Default = 50, Increment = 1,
    Callback = function(value)
        DesiredJump = value
        if jumpConn then jumpConn:Disconnect() end
        jumpConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = DesiredJump
            end
        end)
    end
})

playerTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        if noclipConn then noclipConn:Disconnect() end
        if state then
            noclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

playerTab:AddToggle({
    Name = "Invisible Mode",
    Default = false,
    Callback = function(state)
        invisEnabled = state
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = state and 1 or 0
                end
            end
        end
    end
})

playerTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(enabled)
        if espConn then espConn:Disconnect() end
        if enabled then
            espConn = RunService.RenderStepped:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        local head = player.Character.Head
                        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            -- Draw tracer lines or box here
                            -- Example: Drawing.new("Line") etc.
                        end
                    end
                end
            end)
        end
    end
})

-- STEAL Tab Logic
stealTab:AddToggle({
    Name = "Expand Brain Rot Hitboxes",
    Default = false,
    Callback = function(enabled)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part.Name:lower():find("brain") and part:IsA("BasePart") then
                        part.Size = enabled and Vector3.new(10,10,10) or Vector3.new(1,1,1)
                        part.Transparency = enabled and 0.5 or 1
                    end
                end
            end
        end
    end
})

stealTab:AddLabel("Walk up to enlarged hitbox and click the icon to steal.")

OrionLib:Init()
