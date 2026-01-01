-- VIOLETEX HUB - Main Hub v2.0

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ═══════════════════════════════════
-- ESP MODULE
-- ═══════════════════════════════════
local ESP = {
    Enabled = false,
    TeamCheck = true,
    ShowDistance = true,
    ShowName = true,
    ShowHealth = true,
    BoxColor = Color3.fromRGB(138, 43, 226)
}

local espObjects = {}
local espConnections = {}

local function createDrawing(drawType, properties)
    local drawing = Drawing.new(drawType)
    for prop, value in pairs(properties) do
        pcall(function()
            drawing[prop] = value
        end)
    end
    return drawing
end

local function createPlayerESP(targetPlayer)
    if targetPlayer == player or espObjects[targetPlayer] then return end
    
    espObjects[targetPlayer] = {
        box = createDrawing("Square", {
            Visible = false,
            Color = ESP.BoxColor,
            Thickness = 2,
            Transparency = 1,
            Filled = false
        }),
        nameTag = createDrawing("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            Font = 2,
            Size = 13,
            Color = Color3.new(1, 1, 1)
        }),
        distanceTag = createDrawing("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            Font = 2,
            Size = 12,
            Color = Color3.new(1, 1, 1)
        }),
        healthBarBg = createDrawing("Square", {
            Visible = false,
            Filled = true,
            Transparency = 0.5,
            Color = Color3.new(0.2, 0.2, 0.2)
        }),
        healthBar = createDrawing("Square", {
            Visible = false,
            Filled = true,
            Transparency = 1
        }),
        tracer = createDrawing("Line", {
            Visible = false,
            Color = ESP.BoxColor,
            Thickness = 1,
            Transparency = 1
        })
    }
end

local function updateESP()
    if not ESP.Enabled then return end
    
    for targetPlayer, drawings in pairs(espObjects) do
        pcall(function()
            local character = targetPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local head = character and character:FindFirstChild("Head")
            
            if not character or not hrp or not humanoid or humanoid.Health <= 0 then
                drawings.box.Visible = false
                drawings.nameTag.Visible = false
                drawings.distanceTag.Visible = false
                drawings.healthBarBg.Visible = false
                drawings.healthBar.Visible = false
                drawings.tracer.Visible = false
                return
            end
            
            if ESP.TeamCheck and targetPlayer.Team and player.Team and targetPlayer.Team == player.Team then
                drawings.box.Visible = false
                drawings.nameTag.Visible = false
                drawings.distanceTag.Visible = false
                drawings.healthBarBg.Visible = false
                drawings.healthBar.Visible = false
                drawings.tracer.Visible = false
                return
            end
            
            local position, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
            
            if not onScreen or distance > 2000 then
                drawings.box.Visible = false
                return
            end
            
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            local height = math.abs(headPos.Y - legPos.Y)
            local width = height / 2
            
            drawings.box.Size = Vector2.new(width, height)
            drawings.box.Position = Vector2.new(position.X - width/2, position.Y - height/2)
            drawings.box.Visible = true
            
            if ESP.ShowName then
                drawings.nameTag.Text = targetPlayer.Name
                drawings.nameTag.Position = Vector2.new(position.X, position.Y - height/2 - 16)
                drawings.nameTag.Visible = true
            end
            
            if ESP.ShowDistance then
                drawings.distanceTag.Text = math.floor(distance) .. "m"
                drawings.distanceTag.Position = Vector2.new(position.X, position.Y + height/2 + 4)
                drawings.distanceTag.Visible = true
            end
            
            if ESP.ShowHealth then
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                drawings.healthBarBg.Size = Vector2.new(3, height)
                drawings.healthBarBg.Position = Vector2.new(position.X - width/2 - 6, position.Y - height/2)
                drawings.healthBarBg.Visible = true
                
                drawings.healthBar.Size = Vector2.new(3, height * healthPercent)
                drawings.healthBar.Position = Vector2.new(position.X - width/2 - 6, position.Y - height/2 + (height * (1 - healthPercent)))
                drawings.healthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                drawings.healthBar.Visible = true
            end
            
            drawings.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.tracer.To = Vector2.new(position.X, position.Y)
            drawings.tracer.Visible = true
        end)
    end
end

function ESP:Toggle(state)
    ESP.Enabled = state
    
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            createPlayerESP(p)
        end
        
        if not espConnections.Update then
            espConnections.Update = RunService.RenderStepped:Connect(updateESP)
        end
        
        print("✅ ESP Ativado")
    else
        for _, drawings in pairs(espObjects) do
            pcall(function()
                drawings.box.Visible = false
                drawings.nameTag.Visible = false
                drawings.distanceTag.Visible = false
                drawings.healthBarBg.Visible = false
                drawings.healthBar.Visible = false
                drawings.tracer.Visible = false
            end)
        end
        
        print("❌ ESP Desativado")
    end
end

-- ═══════════════════════════════════
-- UI COLORS
-- ═══════════════════════════════════
local Colors = {
    Primary = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(75, 0, 130),
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 26),
    Frame = Color3.fromRGB(25, 25, 32),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 150),
    Success = Color3.fromRGB(100, 200, 100),
    Danger = Color3.fromRGB(231, 76, 60)
}

-- ═══════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════
local function notify(title, message)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "Notification"
    notifGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 70)
    frame.Position = UDim2.new(1, 10, 0, 80)
    frame.BackgroundColor3 = Colors.Frame
    frame.BorderSizePixel = 0
    frame.Parent = notifGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, 0)
    accent.BackgroundColor3 = Colors.Primary
    accent.BorderSizePixel = 0
    accent.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Position = UDim2.new(0, 13, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Primary
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 30)
    messageLabel.Position = UDim2.new(0, 13, 0, 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Colors.Text
    messageLabel.TextSize = 11
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = frame
    
    TS:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -310, 0, 80)
    }):Play()
    
    task.wait(3)
    
    TS:Create(frame, TweenInfo.new(0.3), {
        Position = UDim2.new(1, 10, 0, 80)
    }):Play()
    
    task.wait(0.3)
    notifGui:Destroy()
end

-- ═══════════════════════════════════
-- CREATE TOGGLE
-- ═══════════════════════════════════
local function createToggle(text, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 35)
    container.BackgroundColor3 = Colors.Frame
    container.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -48, 0.5, -10)
    toggle.BackgroundColor3 = defaultValue and Colors.Success or Colors.Frame
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = Colors.Text
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    local value = defaultValue
    
    toggle.MouseButton1Click:Connect(function()
        value = not value
        
        TS:Create(toggle, TweenInfo.new(0.2), {
            BackgroundColor3 = value and Colors.Success or Colors.Frame
        }):Play()
        
        TS:Create(indicator, TweenInfo.new(0.2), {
            Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        if callback then
            callback(value)
        end
    end)
    
    return container
end

-- ═══════════════════════════════════
-- CREATE HUB UI
-- ═══════════════════════════════════
local isOpen = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VioletexHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 700, 0, 450)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
mainFrame.BackgroundColor3 = Colors.Background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.BackgroundColor3 = Colors.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 10)
sidebarCorner.Parent = sidebar

local sidebarFix = Instance.new("Frame")
sidebarFix.Size = UDim2.new(0, 20, 1, 0)
sidebarFix.Position = UDim2.new(1, -20, 0, 0)
sidebarFix.BackgroundColor3 = Colors.Sidebar
sidebarFix.BorderSizePixel = 0
sidebarFix.Parent = sidebar

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, -20, 0, 25)
logo.Position = UDim2.new(0, 10, 0, 15)
logo.BackgroundTransparency = 1
logo.Text = "VIOLETEX HUB"
logo.TextColor3 = Colors.Primary
logo.TextSize = 16
logo.Font = Enum.Font.GothamBold
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.Parent = sidebar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 15)
subtitle.Position = UDim2.new(0, 10, 0, 38)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Universal Mode"
subtitle.TextColor3 = Colors.TextDim
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = sidebar

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -180, 0, 50)
header.Position = UDim2.new(0, 180, 0, 0)
header.BackgroundColor3 = Colors.Background
header.BorderSizePixel = 0
header.Parent = mainFrame

-- Drag System
local dragging, dragInput, dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragInput == input and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -45, 0.5, -15)
closeBtn.BackgroundColor3 = Colors.Danger
closeBtn.Text = "✕"
closeBtn.TextColor3 = Colors.Text
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    isOpen = false
    mainFrame.Visible = false
end)

-- Content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -200, 1, -70)
content.Position = UDim2.new(0, 190, 0, 60)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Colors.Primary
content.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = content

-- ESP Section
local section = Instance.new("TextLabel")
section.Size = UDim2.new(1, -20, 0, 30)
section.BackgroundTransparency = 1
section.Text = "👁️ ESP SETTINGS"
section.TextColor3 = Colors.Primary
section.TextSize = 13
section.Font = Enum.Font.GothamBold
section.TextXAlignment = Enum.TextXAlignment.Left
section.Parent = content

createToggle("Enable ESP", false, function(value)
    ESP:Toggle(value)
    notify("ESP", value and "Ativado!" or "Desativado!")
end).Parent = content

createToggle("Team Check", true, function(value)
    ESP.TeamCheck = value
end).Parent = content

createToggle("Show Names", true, function(value)
    ESP.ShowName = value
end).Parent = content

createToggle("Show Distance", true, function(value)
    ESP.ShowDistance = value
end).Parent = content

createToggle("Show Health", true, function(value)
    ESP.ShowHealth = value
end).Parent = content

-- Open Button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
openBtn.BackgroundColor3 = Colors.Primary
openBtn.Text = "🟣"
openBtn.TextSize = 24
openBtn.Font = Enum.Font.GothamBold
openBtn.TextColor3 = Colors.Text
openBtn.BorderSizePixel = 0
openBtn.Parent = screenGui

local openBtnCorner = Instance.new("UICorner")
openBtnCorner.CornerRadius = UDim.new(0, 12)
openBtnCorner.Parent = openBtn

-- Drag Open Button
local btnDragging, btnDragInput, btnDragStart, btnStartPos

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = openBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                btnDragging = false
            end
        end)
    end
end)

openBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        btnDragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if btnDragInput == input and btnDragging then
        local delta = input.Position - btnDragStart
        openBtn.Position = UDim2.new(
            btnStartPos.X.Scale,
            btnStartPos.X.Offset + delta.X,
            btnStartPos.Y.Scale,
            btnStartPos.Y.Offset + delta.Y
        )
    end
end)

openBtn.MouseButton1Click:Connect(function()
    if not btnDragging then
        isOpen = not isOpen
        mainFrame.Visible = isOpen
        openBtn.Visible = not isOpen
    end
end)

-- INSERT Key Toggle
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        isOpen = not isOpen
        mainFrame.Visible = isOpen
        openBtn.Visible = not isOpen
    end
end)

-- Player Added
Players.PlayerAdded:Connect(function(p)
    if ESP.Enabled then
        createPlayerESP(p)
    end
end)

-- Welcome Notification
task.wait(1)
notify("VIOLETEX HUB", "Carregado! Pressione INSERT")

print("✅ Hub criado com sucesso!")

return true
