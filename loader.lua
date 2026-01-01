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
    
    if success and code then
        local runSuccess, result = pcall(function()
            return loadstring(code)()
        end)
        
        if runSuccess then
            print("✅ Carregado: " .. path)
            return result
        else
            warn("❌ Erro ao executar: " .. path)
            warn(result)
        end
    else
        warn("❌ Erro ao baixar: " .. path)
        warn(code)
    end
    
    return nil
end

print("📦 Carregando hub...")
local hub = loadScript("hub.lua")

if hub then
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("✅ VIOLETEX HUB CARREGADO!")
    print("📌 Pressione INSERT para abrir")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
else
    warn("❌ Falha ao carregar o hub!")
end
