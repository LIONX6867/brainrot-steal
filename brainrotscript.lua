local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftColumn = Instance.new("ScrollingFrame")
local RightColumn = Instance.new("ScrollingFrame")
local Title = Instance.new("TextLabel")
local OpenButton = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

local lp = game.Players.LocalPlayer
local PPS = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")

ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

OpenButton.Name = "PVP_Open"
OpenButton.Parent = ScreenGui
OpenButton.Position = UDim2.new(0.48, 0, 0.02, 0)
OpenButton.Size = UDim2.new(0, 50, 0, 30)
OpenButton.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
OpenButton.Text = "PVP"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 14

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 400)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Text = "ZAYNPVP"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Position = UDim2.new(0.9, 0, 0.02, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.BackgroundTransparency = 1

LeftColumn.Parent = MainFrame
LeftColumn.Position = UDim2.new(0.05, 0, 0.12, 0)
LeftColumn.Size = UDim2.new(0.42, 0, 0.82, 0)
LeftColumn.BackgroundTransparency = 1
LeftColumn.ScrollBarThickness = 0

RightColumn.Parent = MainFrame
RightColumn.Position = UDim2.new(0.53, 0, 0.12, 0)
RightColumn.Size = UDim2.new(0.42, 0, 0.82, 0)
RightColumn.BackgroundTransparency = 1
RightColumn.ScrollBarThickness = 0

local leftLayout = Instance.new("UIListLayout", LeftColumn)
leftLayout.Padding = UDim.new(0, 12)
local rightLayout = Instance.new("UIListLayout", RightColumn)
rightLayout.Padding = UDim.new(0, 12)

local function addFeature(parent, name, hasSlider, defaultVal, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 55)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Size = UDim2.new(0.7, 0, 0, 18)
    Label.TextColor3 = Color3.fromRGB(220, 200, 255)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextSize = 12
    Label.Parent = Frame

    local Slider = nil
    if hasSlider then
        Slider = Instance.new("TextBox")
        Slider.Size = UDim2.new(0, 40, 0, 20)
        Slider.Position = UDim2.new(0.8, 0, 0, 25)
        Slider.BackgroundColor3 = Color3.fromRGB(20, 5, 35)
        Slider.TextColor3 = Color3.fromRGB(200, 100, 255)
        Slider.Text = tostring(defaultVal or 0)
        Slider.BorderSizePixel = 0
        Slider.Parent = Frame
    end

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 40, 0, 20)
    Toggle.Position = UDim2.new(0.8, 0, 0, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(45, 30, 60)
    Toggle.Text = ""
    Toggle.Parent = Frame
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = UDim2.new(0.1, 0, 0.1, 0)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.Parent = Toggle

    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.BackgroundColor3 = enabled and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(45, 30, 60)
        Indicator.Position = enabled and UDim2.new(0.5, 0, 0.1, 0) or UDim2.new(0.1, 0, 0.1, 0)
        local val = Slider and tonumber(Slider.Text) or defaultVal
        callback(enabled, val)
    end)
end

addFeature(LeftColumn, "Speed Boost", true, 50, function(state, val)
    local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = state and val or 16
    end
end)

local flyActive = false
addFeature(LeftColumn, "Fly Mod", true, 50, function(state, val)
    flyActive = state
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if flyActive and root then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "Z_Fly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "Z_Gyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flyActive and root and bv do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * val
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end)

local stealActive = false
addFeature(LeftColumn, "Auto Steal", false, nil, function(state)
    stealActive = state
end)

PPS.PromptButtonHoldBegan:Connect(function(prompt)
    if stealActive then
        prompt.HoldDuration = 0
        prompt:InputHoldBegin()
        prompt:InputHoldEnd()
    end
end)

addFeature(LeftColumn, "Spin Bot ☠️", true, 30, function(state, val)
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if state and root then
        local bgv = Instance.new("BodyAngularVelocity", root)
        bgv.Name = "ZAYN_Spin"
        bgv.MaxTorque = Vector3.new(0, math.huge, 0)
        bgv.AngularVelocity = Vector3.new(0, val, 0)
    else
        if root and root:FindFirstChild("ZAYN_Spin") then root.ZAYN_Spin:Destroy() end
    end
end)

addFeature(RightColumn, "Gravity %", true, 70, function(state, val)
    workspace.Gravity = state and val or 196.2
end)

addFeature(RightColumn, "Hop Power", true, 50, function(state, val)
    local hum = lp.Character:FindFirstChild("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = state and val or 50
    end
end)

addFeature(RightColumn, "Optimizer + XRay", false, nil, function(state)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
            obj.LocalTransparencyModifier = state and 0.5 or 0
        end
    end
end)

addFeature(LeftColumn, "Anti Ragdoll", false, nil, function(state)
    local hum = lp.Character:FindFirstChild("Humanoid")
    if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not state) end
end)

addFeature(LeftColumn, "Bat Aimbot", true, 19, function(state, val)
    local cam = workspace.CurrentCamera
    local runStepped = RunService.RenderStepped:Connect(function()
        if state then
            local target = nil
            local dist = val * 10
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        target = v.Character.HumanoidRootPart
                        dist = d
                    end
                end
            end
            if target then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position) end
        end
    end)
    if not state then runStepped:Disconnect() end
end)

addFeature(RightColumn, "Galaxy Mode", true, 1, function(state)
    local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", game.Lighting)
    if state then
        sky.SkyboxBk = "rbxassetid://159454299"
        sky.SkyboxDn = "rbxassetid://159454296"
        sky.SkyboxFt = "rbxassetid://159454293"
        sky.SkyboxLf = "rbxassetid://159454286"
        sky.SkyboxRt = "rbxassetid://159454300"
        sky.SkyboxUp = "rbxassetid://159454289"
    end
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)
