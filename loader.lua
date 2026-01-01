-- loader.lua
-- VIOLETEX HUB - Main Loader
-- GitHub: LordCripes

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🟣 VIOLETEX HUB v1.0")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⏳ Carregando...")

-- Verificar se já está carregado
if _G.VioletexLoaded then
    warn("⚠️ VIOLETEX já está carregado!")
    return
end

_G.VioletexLoaded = true

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configurações
local GITHUB_BASE = "https://raw.githubusercontent.com/LordCripes/Violetex-Hub/main/"
local GAME_ID = game.PlaceId
local GAME_NAME = ""

-- Obter nome do jogo
pcall(function()
    GAME_NAME = game:GetService("MarketplaceService"):GetProductInfo(GAME_ID).Name
end)

-- Lista de jogos suportados
local SupportedGames = {
    -- Adicione jogos aqui no formato:
    -- [PlaceId] = "NomeDaPasta",
    
    -- Exemplos (descomente quando criar):
    -- [2788229376] = "DaHood",
    -- [4623386862] = "Rivals",
    -- [286090429] = "Arsenal",
    -- [292439477] = "PhantomForces",
}

-- Função para carregar script do GitHub
local function loadScript(url, scriptName)
    print("📥 Baixando: " .. scriptName)
    
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success and result then
        print("✅ Script baixado: " .. scriptName)
        
        local loadSuccess, loadError = pcall(function()
            loadstring(result)()
        end)
        
        if loadSuccess then
            print("✅ Script executado: " .. scriptName)
            return true
        else
            warn("❌ Erro ao executar " .. scriptName .. ": " .. tostring(loadError))
            return false
        end
    else
        warn("❌ Erro ao baixar " .. scriptName .. ": " .. tostring(result))
        return false
    end
end

-- Função para carregar jogo específico
local function loadGameScript(gameName)
    print("✨ Jogo detectado: " .. gameName)
    local url = GITHUB_BASE .. gameName .. "/init.lua"
    return loadScript(url, gameName)
end

-- Função para carregar Universal-Game
local function loadUniversal()
    print("🌐 Jogo não detectado. Carregando Universal-Game...")
    local url = GITHUB_BASE .. "Universal-Game/init.lua"
    return loadScript(url, "Universal-Game")
end

-- Função principal
local function main()
    print("👤 Usuário: " .. LocalPlayer.Name)
    print("🎮 Jogo: " .. (GAME_NAME ~= "" and GAME_NAME or "Desconhecido"))
    print("🆔 Place ID: " .. GAME_ID)
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    -- Verificar se o jogo é suportado
    if SupportedGames[GAME_ID] then
        local gameName = SupportedGames[GAME_ID]
        local success = loadGameScript(gameName)
        
        -- Se falhar, carregar Universal
        if not success then
            print("⚠️ Fallback para Universal-Game")
            task.wait(0.5)
            loadUniversal()
        end
    else
        -- Jogo não reconhecido, carregar Universal
        loadUniversal()
    end
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("✅ VIOLETEX HUB carregado!")
    print("📌 Pressione INSERT para abrir")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- Executar com proteção
local success, error = pcall(main)

if not success then
    warn("❌ Erro crítico ao carregar VIOLETEX HUB:")
    warn(error)
    _G.VioletexLoaded = false
end