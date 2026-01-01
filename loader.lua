-- VIOLETEX HUB - Loader v2.0
-- GitHub: LordCripes/VioletexHub

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🟣 VIOLETEX HUB")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if _G.VioletexHub then
    warn("⚠️ Hub já carregado!")
    return
end

_G.VioletexHub = true

local BASE_URL = "https://raw.githubusercontent.com/LordCripes/VioletexHub/main/"

local function loadScript(path)
    print("📥 Carregando: " .. path)
    
    local success, code = pcall(function()
        return game:HttpGet(BASE_URL .. path, true)
    end)
    
    -- Verifica se o download falhou ou se o GitHub retornou "404"
    if not success or code:find("404: Not Found") then
        warn("❌ Erro ao baixar (Arquivo não encontrado ou erro de rede): " .. path)
        return nil
    end

    local runSuccess, resultFunc = pcall(loadstring, code)
    
    if runSuccess and type(resultFunc) == "function" then
        local executeSuccess, err = pcall(resultFunc)
        if executeSuccess then
            print("✅ Carregado: " .. path)
            return true
        else
            warn("❌ Erro ao executar o script: " .. tostring(err))
        end
    else
        warn("❌ Erro de sintaxe no script baixado ou loadstring negado.")
    end
    
    return nil
end

print("📦 Carregando hub...")
local hub = loadScript("hub.lua")

if hub then
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("✅ VIOLETEX HUB CARREGADO!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
else
    _G.VioletexHub = nil -- Permite tentar carregar de novo se falhar
    warn("❌ Falha crítica ao carregar o hub!")
end
