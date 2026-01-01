-- Universal-Game/init.lua
-- VIOLETEX HUB - Universal Game Loader
-- GitHub: LordCripes

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🌐 Inicializando Universal-Game...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

local GITHUB_BASE = "https://raw.githubusercontent.com/LordCripes/Violetex-Hub/main/Universal-Game/"

-- Função para carregar módulos da pasta Universal-Game
local function loadModule(moduleName)
    local url = GITHUB_BASE .. moduleName .. ".lua"
    
    print("📦 Carregando módulo: " .. moduleName)
    
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success and result then
        local loadSuccess, module = pcall(function()
            return loadstring(result)()
        end)
        
        if loadSuccess then
            print("✅ Módulo carregado: " .. moduleName)
            return module
        else
            warn("❌ Erro ao executar módulo " .. moduleName)
            return nil
        end
    else
        warn("❌ Erro ao baixar módulo " .. moduleName)
        return nil
    end
end

-- Carregar módulos na ordem correta
print("📦 Carregando módulos...")

-- 1. Carregar UI primeiro
local UI = loadModule("ui")
if not UI then
    warn("❌ ERRO CRÍTICO: UI não carregado!")
    return
end

-- Aguardar UI inicializar
task.wait(0.2)

-- 2. Carregar ESP
local ESP = loadModule("esp")
if not ESP then
    warn("❌ ERRO CRÍTICO: ESP não carregado!")
    return
end

-- Aguardar ESP inicializar
task.wait(0.2)

-- 3. Criar interface universal
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎨 Criando interface...")

local createSuccess, createError = pcall(function()
    UI.createUniversalHub(ESP)
end)

if createSuccess then
    print("✅ Interface criada com sucesso!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("✅ Universal-Game carregado!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
else
    warn("❌ Erro ao criar interface:")
    warn(createError)
end