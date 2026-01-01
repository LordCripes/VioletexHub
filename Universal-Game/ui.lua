-- Universal-Game/ui.lua
-- VIOLETEX HUB - UI Module (Premium Style)
-- GitHub: LordCripes

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local UI = {}
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cores do tema (inspirado no LUX FARM)
UI.Colors = {
    Primary = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(100, 50, 200),
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 26),
    Frame = Color3.fromRGB(25, 25, 32),
    FrameLight = Color3.fromRGB(35, 35, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 150),
    Success = Color3.fromRGB(100, 200, 100),
    Danger = Color3.fromRGB(231, 76, 60),
    SliderBar = Color3.fromRGB(138, 43, 226)
}

local currentGui = nil
local isOpen = false
local currentTab = nil

-- Criar ScreenGui base
local function createScreenGui()
    local oldGui = playerGui:FindFirstChild("VioletexHub")
    if oldGui then
        oldGui:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VioletexHub"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui
    
    return screenGui
end

-- Criar botão de tab (lateral)
function UI.createTabButton(text, icon, parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = UI.Colors.Sidebar
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = UI.Colors.TextDim
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = button
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UI.Colors.TextDim
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    local selected = false
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback(button)
        end
    end)
    
    button.MouseEnter:Connect(function()
        if not selected then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = UI.Colors.Frame
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not selected then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = UI.Colors.Sidebar
            }):Play()
        end
    end)
    
    function button:SetSelected(value)
        selected = value
        button.BackgroundColor3 = selected and UI.Colors.Primary or UI.Colors.Sidebar
        iconLabel.TextColor3 = selected and UI.Colors.Text or UI.Colors.TextDim
        label.TextColor3 = selected and UI.Colors.Text or UI.Colors.TextDim
    end
    
    return button
end

-- Criar toggle moderno
function UI.createToggle(text, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 35)
    container.BackgroundColor3 = UI.Colors.Frame
    container.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UI.Colors.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -48, 0.5, -10)
    toggleButton.BackgroundColor3 = defaultValue and UI.Colors.Primary or UI.Colors.FrameLight
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = UI.Colors.Text
    indicator.BorderSizePixel = 0
    indicator.Parent = toggleButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    local value = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        value = not value
        
        local newColor = value and UI.Colors.Primary or UI.Colors.FrameLight
        local newPosition = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.2), {Position = newPosition}):Play()
        
        if callback then
            callback(value)
        end
    end)
    
    return container
end

-- Criar slider estilo LUX
function UI.createSlider(text, min, max, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 55)
    container.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UI.Colors.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, 0, 0, 6)
    sliderBack.Position = UDim2.new(0, 0, 0, 25)
    sliderBack.BackgroundColor3 = UI.Colors.Frame
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = UI.Colors.SliderBar
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 0, 15)
    valueLabel.Position = UDim2.new(0, 0, 0, 36)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = defaultValue .. "/" .. max
    valueLabel.TextColor3 = UI.Colors.TextDim
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = container
    
    local dragging = false
    
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderBack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            valueLabel.Text = value .. "/" .. max
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return container
end

-- Criar seção (categoria)
function UI.createSection(text)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -20, 0, 30)
    section.BackgroundTransparency = 1
    section.Text = text
    section.TextColor3 = UI.Colors.Primary
    section.TextSize = 13
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    
    return section
end

-- Criar Hub Universal Premium
function UI.createUniversalHub(ESP)
    local screenGui = createScreenGui()
    currentGui = screenGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    mainFrame.BackgroundColor3 = UI.Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Sidebar (menu lateral)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, 0)
    sidebar.BackgroundColor3 = UI.Colors.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 10)
    sidebarCorner.Parent = sidebar
    
    -- Fix canto da sidebar
    local sidebarFix = Instance.new("Frame")
    sidebarFix.Size = UDim2.new(0, 20, 1, 0)
    sidebarFix.Position = UDim2.new(1, -20, 0, 0)
    sidebarFix.BackgroundColor3 = UI.Colors.Sidebar
    sidebarFix.BorderSizePixel = 0
    sidebarFix.Parent = sidebar
    
    -- Header da sidebar
    local sidebarHeader = Instance.new("Frame")
    sidebarHeader.Size = UDim2.new(1, 0, 0, 60)
    sidebarHeader.BackgroundTransparency = 1
    sidebarHeader.Parent = sidebar
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, -20, 0, 25)
    logo.Position = UDim2.new(0, 10, 0, 15)
    logo.BackgroundTransparency = 1
    logo.Text = "VIOLETEX HUB"
    logo.TextColor3 = UI.Colors.Primary
    logo.TextSize = 16
    logo.Font = Enum.Font.GothamBold
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.Parent = sidebarHeader
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -20, 0, 15)
    subtitle.Position = UDim2.new(0, 10, 0, 38)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Universal Mode"
    subtitle.TextColor3 = UI.Colors.TextDim
    subtitle.TextSize = 10
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = sidebarHeader
    
    -- Container de tabs
    local tabsContainer = Instance.new("ScrollingFrame")
    tabsContainer.Size = UDim2.new(1, 0, 1, -70)
    tabsContainer.Position = UDim2.new(0, 0, 0, 65)
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.BorderSizePixel = 0
    tabsContainer.ScrollBarThickness = 0
    tabsContainer.Parent = sidebar
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.Padding = UDim.new(0, 5)
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsLayout.Parent = tabsContainer
    
    -- Header principal (arrastável)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, -180, 0, 50)
    header.Position = UDim2.new(0, 180, 0, 0)
    header.BackgroundColor3 = UI.Colors.Background
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    -- Sistema de arrastar
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
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
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(0, 200, 0, 30)
    searchBox.Position = UDim2.new(0, 15, 0.5, -15)
    searchBox.BackgroundColor3 = UI.Colors.Frame
    searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "Search"
    searchBox.PlaceholderColor3 = UI.Colors.TextDim
    searchBox.Text = ""
    searchBox.TextColor3 = UI.Colors.Text
    searchBox.TextSize = 12
    searchBox.Font = Enum.Font.Gotham
    searchBox.Parent = header
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 6)
    searchCorner.Parent = searchBox
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -45, 0.5, -15)
    closeBtn.BackgroundColor3 = UI.Colors.Danger
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = UI.Colors.Text
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        isOpen = false
        mainFrame.Visible = false
    end)
    
    -- Conteúdo principal
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -200, 1, -70)
    contentFrame.Position = UDim2.new(0, 190, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Criar tabs de conteúdo
    local tabs = {}
    
    local function createTab(name)
        local tab = Instance.new("ScrollingFrame")
        tab.Name = name.."Content"
        tab.Size = UDim2.new(1, 0, 1, 0)
        tab.BackgroundTransparency = 1
        tab.BorderSizePixel = 0
        tab.ScrollBarThickness = 4
        tab.ScrollBarImageColor3 = UI.Colors.Primary
        tab.Visible = false
        tab.Parent = contentFrame
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = tab
        
        tabs[name] = tab
        return tab
    end
    
    -- Criar tabs
    local visualTab = createTab("Visual")
    local miscTab = createTab("Misc")
    
    -- Conteúdo da tab Visual
    local espSection = UI.createSection("👁️ ESP SETTINGS")
    espSection.Parent = visualTab
    
    UI.createToggle("Enable ESP", false, function(value)
        ESP:Toggle(value)
        UI.notify("ESP " .. (value and "Ativado" or "Desativado"), value and "ESP ativado com sucesso" or "ESP desativado", 2)
    end).Parent = visualTab
    
    UI.createToggle("Team Check", true, function(value)
        ESP.TeamCheck = value
    end).Parent = visualTab
    
    UI.createToggle("Show Names", true, function(value)
        ESP.ShowName = value
    end).Parent = visualTab
    
    UI.createToggle("Show Distance", true, function(value)
        ESP.ShowDistance = value
    end).Parent = visualTab
    
    UI.createToggle("Show Health", true, function(value)
        ESP.ShowHealth = value
    end).Parent = visualTab
    
    -- Botões de tab
    local tabButtons = {}
    
    local function switchTab(tabName)
        for name, tab in pairs(tabs) do
            tab.Visible = (name == tabName)
        end
        
        for _, btn in pairs(tabButtons) do
            btn:SetSelected(false)
        end
        
        if tabButtons[tabName] then
            tabButtons[tabName]:SetSelected(true)
        end
    end
    
    tabButtons["Visual"] = UI.createTabButton("Visual", "👁️", tabsContainer, function()
        switchTab("Visual")
    end)
    
    tabButtons["Misc"] = UI.createTabButton("Misc", "⚙️", tabsContainer, function()
        switchTab("Misc")
    end)
    
    -- Selecionar primeira tab
    switchTab("Visual")
    
    -- Botão de abrir
    local openButton = Instance.new("TextButton")
    openButton.Name = "OpenButton"
    openButton.Size = UDim2.new(0, 50, 0, 50)
    openButton.Position = UDim2.new(0.5, -25, 0.5, -25)
    openButton.BackgroundColor3 = UI.Colors.Primary
    openButton.BorderSizePixel = 0
    openButton.Text = "🟣"
    openButton.TextSize = 24
    openButton.Font = Enum.Font.GothamBold
    openButton.TextColor3 = UI.Colors.Text
    openButton.AutoButtonColor = false
    openButton.Parent = screenGui
    
    local openCorner = Instance.new("UICorner")
    openCorner.CornerRadius = UDim.new(0, 12)
    openCorner.Parent = openButton
    
    openButton.MouseEnter:Connect(function()
        TweenService:Create(openButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 55, 0, 55),
            Position = UDim2.new(0.5, -27.5, 0.5, -27.5)
        }):Play()
    end)
    
    openButton.MouseLeave:Connect(function()
        TweenService:Create(openButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0.5, -25, 0.5, -25)
        }):Play()
    end)
    
    -- Arrastar botão
    local btnDragging, btnDragInput, btnDragStart, btnStartPos
    
    local function updateBtn(input)
        local delta = input.Position - btnDragStart
        openButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
    
    openButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDragging = true
            btnDragStart = input.Position
            btnStartPos = openButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    btnDragging = false
                end
            end)
        end
    end)
    
    openButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            btnDragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == btnDragInput and btnDragging then
            updateBtn(input)
        end
    end)
    
    openButton.MouseButton1Click:Connect(function()
        if not btnDragging then
            isOpen = not isOpen
            mainFrame.Visible = isOpen
            openButton.Visible = not isOpen
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            isOpen = not isOpen
            mainFrame.Visible = isOpen
            openButton.Visible = not isOpen
        end
    end)
    
    task.wait(1)
    UI.notify("VIOLETEX HUB", "Hub carregado! Pressione INSERT", 3)
end

-- Sistema de notificações
function UI.notify(title, message, duration)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "Notification"
    notifGui.IgnoreGuiInset = true
    notifGui.Parent = playerGui
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 70)
    notifFrame.Position = UDim2.new(1, 10, 0, 80)
    notifFrame.BackgroundColor3 = UI.Colors.Frame
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, 0)
    accent.BackgroundColor3 = UI.Colors.Primary
    accent.BorderSizePixel = 0
    accent.Parent = notifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Position = UDim2.new(0, 13, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = UI.Colors.Primary
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 30)
    messageLabel.Position = UDim2.new(0, 13, 0, 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = UI.Colors.Text
    messageLabel.TextSize = 11
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = notifFrame
    
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -310, 0, 80)
    }):Play()
    
    task.wait(duration or 3)
    
    TweenService:Create(notifFrame, TweenInfo.new(0.3), {
        Position = UDim2.new(1, 10, 0, 80)
    }):Play()
    
    task.wait(0.3)
    notifGui:Destroy()
end

print("✅ UI Module carregado!")
return UI