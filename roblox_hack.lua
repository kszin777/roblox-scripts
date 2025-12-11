--[[
  SCRIPT UNIVERSAL PARA ROBLOX (Termux + Executor)
  Funções: Aimbot, ESP Cyberpunk, Low Render, Botão de Minimizar
  Requer: Termux + Executor (Arceus X, Delta, etc.)
]]

-- ===== CONFIGURAÇÕES =====
local ESP_COR = Color3.fromRGB(255, 0, 255) -- Cor cyberpunk (rosa neon)
local AIMBOT_ATIVO = true
local LOW_RENDER = true
local MINIMIZADO = false

-- ===== FUNÇÃO: LOW RENDER (DESEMPENHO) =====
local function setLowRender()
    if LOW_RENDER then
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FogEnd = 999999
        game:GetService("RunService"):Set3dRendering(false) -- Desativa efeitos 3D
        setfpscap(30) -- Limita FPS para melhor desempenho
    end
end

-- ===== FUNÇÃO: ESP CYBERPUNK (TIME/INIMIGOS) =====
local function enableESP()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local box = Drawing.new("Quad")
                box.Color = ESP_COR
                box.Thickness = 2
                box.Transparency = 0.5
                box.Visible = true

                game:GetService("RunService").Heartbeat:Connect(function()
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                        if onScreen then
                            box.PointA = Vector2.new(pos.X - 20, pos.Y - 40)
                            box.PointB = Vector2.new(pos.X + 20, pos.Y + 40)
                            -- Adiciona nome do jogador
                            local nameTag = Drawing.new("Text")
                            nameTag.Text = player.Name
                            nameTag.Color = ESP_COR
                            nameTag.Position = Vector2.new(pos.X, pos.Y - 40)
                            nameTag.Size = 16
                            nameTag.Visible = true
                            -- Remove ao sair
                            character.AncestryChanged:Connect(function()
                                box:Remove()
                                nameTag:Remove()
                            end)
                        else
                            box.Visible = false
                        end
                    else
                        box:Remove()
                    end
                end)
            end
        end
    end
end

-- ===== FUNÇÃO: AIMBOT UNIVERSAL =====
local function enableAimbot()
    if not AIMBOT_ATIVO then return end

    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local camera = workspace.CurrentCamera

    game:GetService("RunService").Heartbeat:Connect(function()
        if localPlayer.Character then
            local closestPlayer = nil
            local closestDistance = math.huge

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                            if distance < closestDistance then
                                closestPlayer = humanoidRootPart
                                closestDistance = distance
                            end
                        end
                    end
                end
            end

            if closestPlayer then
                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closestPlayer.Position)
            end
        end
    end)
end

-- ===== FUNÇÃO: BOTÃO DE MINIMIZAR =====
local function toggleMinimize()
    MINIMIZADO = not MINIMIZADO
    if MINIMIZADO then
        for _, obj in ipairs(Drawing.getObjects()) do
            obj.Visible = false
        end
        AIMBOT_ATIVO = false
        setfpscap(60) -- Volta ao FPS normal
    else
        enableESP()
        enableAimbot()
        setLowRender()
        AIMBOT_ATIVO = true
    end
end

-- ===== ATALHO PARA MINIMIZAR (TECLA "P") =====
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        toggleMinimize()
    end
end)

-- ===== INICIALIZAÇÃO =====
setLowRender()
enableESP()
enableAimbot()

-- ===== COMANDO PARA GITHUB (SALVAR SEU SCRIPT) =====
-- 1. Crie um repositório no GitHub pelo seu navegador.
-- 2. Faça upload deste script manualmente ou use:
--    git add roblox_hack.lua
--    git commit -m "Script Roblox Universal"
--    git push origin main
