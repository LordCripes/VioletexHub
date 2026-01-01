-- Universal-Game/esp.lua
-- VIOLETEX HUB - ESP Module
-- GitHub: LordCripes

local ESP = {}

-- Configurações padrão
ESP.Enabled = false
ESP.TeamCheck = true
ESP.ShowDistance = true
ESP.ShowName = true
ESP.ShowHealth = true
ESP.BoxColor = Color3.fromRGB(138, 43, 226)
ESP.TeamColor = false

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Armazenamento
local espObjects = {}
local connections = {}

-- Função auxiliar para criar Drawing
local function createDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, value in pairs(properties) do
        pcall(function()
            drawing[prop] = value
        end)
    end
    return drawing
end

-- Criar ESP para um jogador
local function createESP(player)
    if player == LocalPlayer then return end
    if espObjects[player] then return end
    
    local success, objects = pcall(function()
        -- Box (contorno)
        local box = createDrawing("Square", {
            Visible = false,
            Color = ESP.BoxColor,
            Thickness = 2,
            Transparency = 1,
            Filled = false
        })
        
        -- Nome
        local nameTag = createDrawing("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            Font = 2,
            Size = 13,
            Color = Color3.new(1, 1, 1),
            Text = player.Name
        })
        
        -- Distância
        local distanceTag = createDrawing("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            Font = 2,
            Size = 12,
            Color = Color3.new(1, 1, 1)
        })
        
        -- Barra de vida (fundo)
        local healthBarBg = createDrawing("Square", {
            Visible = false,
            Thickness = 1,
            Filled = true,
            Transparency = 0.5,
            Color = Color3.new(0.2, 0.2, 0.2)
        })
        
        -- Barra de vida (preenchimento)
        local healthBar = createDrawing("Square", {
            Visible = false,
            Thickness = 1,
            Filled = true,
            Transparency = 1
        })
        
        -- Tracer (linha)
        local tracer = createDrawing("Line", {
            Visible = false,
            Color = ESP.BoxColor,
            Thickness = 1,
            Transparency = 1
        })
        
        return {
            box = box,
            nameTag = nameTag,
            distanceTag = distanceTag,
            healthBarBg = healthBarBg,
            healthBar = healthBar,
            tracer = tracer
        }
    end)
    
    if success and objects then
        espObjects[player] = objects
    end
end

-- Remover ESP de um jogador
local function removeESP(player)
    if not espObjects[player] then return end
    
    local objects = espObjects[player]
    
    for _, obj in pairs(objects) do
        pcall(function()
            if obj and obj.Remove then
                obj:Remove()
            end
        end)
    end
    
    espObjects[player] = nil
end

-- Atualizar ESP de todos os jogadores
local function updateESP()
    if not ESP.Enabled then return end
    
    for player, objects in pairs(espObjects) do
        local success = pcall(function()
            -- Verificações básicas
            if not player or not player.Parent then
                removeESP(player)
                return
            end
            
            local character = player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local head = character and character:FindFirstChild("Head")
            
            -- Se não tem componentes necessários, oculta
            if not character or not humanoidRootPart or not humanoid or not head or humanoid.Health <= 0 then
                objects.box.Visible = false
                objects.nameTag.Visible = false
                objects.distanceTag.Visible = false
                objects.healthBarBg.Visible = false
                objects.healthBar.Visible = false
                objects.tracer.Visible = false
                return
            end
            
            -- Team check
            if ESP.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                objects.box.Visible = false
                objects.nameTag.Visible = false
                objects.distanceTag.Visible = false
                objects.healthBarBg.Visible = false
                objects.healthBar.Visible = false
                objects.tracer.Visible = false
                return
            end
            
            -- Calcular posição e distância
            local hrpPosition = humanoidRootPart.Position
            local distance = (hrpPosition - Camera.CFrame.Position).Magnitude
            
            -- Verificar se está na tela
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrpPosition)
            
            if not onScreen or distance > 2000 then
                objects.box.Visible = false
                objects.nameTag.Visible = false
                objects.distanceTag.Visible = false
                objects.healthBarBg.Visible = false
                objects.healthBar.Visible = false
                objects.tracer.Visible = false
                return
            end
            
            -- Calcular dimensões do box
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(hrpPosition - Vector3.new(0, 3, 0))
            
            local height = math.abs(headPos.Y - legPos.Y)
            local width = height / 2
            
            -- Atualizar cor (time ou padrão)
            local espColor = ESP.BoxColor
            if ESP.TeamColor and player.Team then
                espColor = player.Team.TeamColor.Color
            end
            
            -- Box
            objects.box.Size = Vector2.new(width, height)
            objects.box.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2)
            objects.box.Color = espColor
            objects.box.Visible = true
            
            -- Nome
            if ESP.ShowName then
                objects.nameTag.Text = player.Name
                objects.nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 16)
                objects.nameTag.Color = espColor
                objects.nameTag.Visible = true
            else
                objects.nameTag.Visible = false
            end
            
            -- Distância
            if ESP.ShowDistance then
                objects.distanceTag.Text = math.floor(distance) .. "m"
                objects.distanceTag.Position = Vector2.new(screenPos.X, screenPos.Y + height/2 + 4)
                objects.distanceTag.Color = espColor
                objects.distanceTag.Visible = true
            else
                objects.distanceTag.Visible = false
            end
            
            -- Barra de vida
            if ESP.ShowHealth then
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                local barHeight = height * healthPercent
                local barWidth = 3
                
                -- Fundo da barra
                objects.healthBarBg.Size = Vector2.new(barWidth, height)
                objects.healthBarBg.Position = Vector2.new(screenPos.X - width/2 - barWidth - 3, screenPos.Y - height/2)
                objects.healthBarBg.Visible = true
                
                -- Preenchimento
                objects.healthBar.Size = Vector2.new(barWidth, barHeight)
                objects.healthBar.Position = Vector2.new(screenPos.X - width/2 - barWidth - 3, screenPos.Y - height/2 + (height - barHeight))
                objects.healthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                objects.healthBar.Visible = true
            else
                objects.healthBarBg.Visible = false
                objects.healthBar.Visible = false
            end
            
            -- Tracer (linha do centro inferior até o jogador)
            objects.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            objects.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            objects.tracer.Color = espColor
            objects.tracer.Visible = true
        end)
        
        if not success then
            -- Se der erro, ocultar
            pcall(function()
                objects.box.Visible = false
                objects.nameTag.Visible = false
                objects.distanceTag.Visible = false
                objects.healthBarBg.Visible = false
                objects.healthBar.Visible = false
                objects.tracer.Visible = false
            end)
        end
    end
end

-- Ativar/Desativar ESP
function ESP:Toggle(state)
    ESP.Enabled = state
    
    if state then
        print("🟣 [ESP] Ativando...")
        
        -- Criar ESP para jogadores existentes
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                task.spawn(function()
                    createESP(player)
                end)
            end
        end
        
        -- Conectar atualização
        if not connections.Update then
            connections.Update = RunService.RenderStepped:Connect(updateESP)
        end
        
        -- Conectar eventos de jogadores
        if not connections.PlayerAdded then
            connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
                if ESP.Enabled then
                    task.wait(1)
                    createESP(player)
                end
            end)
        end
        
        if not connections.PlayerRemoving then
            connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
                removeESP(player)
            end)
        end
        
        print("✅ [ESP] Ativado com sucesso!")
    else
        print("🟣 [ESP] Desativando...")
        
        -- Ocultar todos os ESP
        for player, objects in pairs(espObjects) do
            pcall(function()
                objects.box.Visible = false
                objects.nameTag.Visible = false
                objects.distanceTag.Visible = false
                objects.healthBarBg.Visible = false
                objects.healthBar.Visible = false
                objects.tracer.Visible = false
            end)
        end
        
        -- Desconectar atualização
        if connections.Update then
            connections.Update:Disconnect()
            connections.Update = nil
        end
        
        print("❌ [ESP] Desativado!")
    end
end

-- Limpar tudo
function ESP:Destroy()
    ESP.Enabled = false
    
    -- Remover todos os ESP
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
    
    -- Desconectar eventos
    for _, connection in pairs(connections) do
        if connection then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    
    connections = {}
    espObjects = {}
    
    print("🗑️ [ESP] Destruído completamente!")
end

print("✅ ESP Module carregado!")
return ESP