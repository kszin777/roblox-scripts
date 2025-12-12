local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield.lua'))()
local Window = Rayfield:CreateWindow({Name = "BILL REVENGE AIMBOT 2025", KeySystem = false})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configs
getgenv().Aimbot = {
    Enabled = true,
    Prediction = true,
    WallCheck = true,
    FOV = 180,
    Smoothness = 0.09,
    PriorityAttacker = true,   -- quem te deu dano vira alvo automático
    KeyToggle = Enum.KeyCode.E
}

-- Variáveis
local Target = nil
local LastAttacker = nil
local Highlight = Instance.new("Highlight")
Highlight.FillColor = Color3.fromRGB(255,0,0)
Highlight.OutlineColor = Color3.fromRGB(255,255,255)
Highlight.FillTransparency = 0.3
Highlight.OutlineTransparency = 0
Highlight.Parent = game.CoreGui

-- FOV Circle
local Circle = Drawing.new("Circle")
Circle.Radius = getgenv().Aimbot.FOV
Circle.Color = Color3.fromRGB(255,0,255)
Circle.Thickness = 2
Circle.Filled = false
Circle.Visible = true

-- Detecta quem te bateu
local function SetupDamageDetection()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.HealthChanged:Connect(function(health)
            if health < LocalPlayer.Character.Humanoid.MaxHealth then
                local creator = LocalPlayer.Character.Humanoid:FindFirstChild("creator")
                if creator and creator.Value and creator.Value:IsA("Player") then
                    LastAttacker = creator.Value
                    if getgenv().Aimbot.Enabled and getgenv().Aimbot.PriorityAttacker then
                        Target = LastAttacker.Character
                    end
                end
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(SetupDamageDetection)
if LocalPlayer.Character then SetupDamageDetection() end

-- Pega alvo mais próximo ou atacante
local function GetTarget()
    if LastAttacker and getgenv().Aimbot.PriorityAttacker and LastAttacker.Character and LastAttacker.Character:FindFirstChild("Head") then
        local head = LastAttacker.Character.Head
        local pos = Camera:WorldToViewportPoint(head.Position)
        if pos.Z > 0 and (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude <= getgenv().Aimbot.FOV then
            return head
        end
    end

    local closest = nil
    local best = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local vec, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(vec.X, vec.Y) - UserInputService:GetMouseLocation()).Magnitude
                if dist < best and dist <= getgenv().Aimbot.FOV then
                    if not getgenv().Aimbot.WallCheck or #Camera:GetPartsObscuringTarget({head.Position}, {LocalPlayer.Character, plr.Character}) == 0 then
                        best = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

-- Loop principal
RunService.Heartbeat:Connect(function()
    Circle.Position = UserInputService:GetMouseLocation()
    Circle.Radius = getgenv().Aimbot.FOV

    if getgenv().Aimbot.Enabled then
        local head = GetTarget()
        if head then
            Target = head.Parent
            Highlight.Adornee = Target
            Highlight.Enabled = true

            local predict = getgenv().Aimbot.Prediction and head.Velocity * 0.165 or Vector3.new()
            local targetPos = head.Position + predict
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), getgenv().Aimbot.Smoothness)
        else
            Highlight.Enabled = false
        end
    else
        Highlight.Enabled = false
    end
end)

-- GUI Rayfield
local Tab = Window:CreateTab("Revenge Aimbot")
Tab:CreateToggle({Name = "Aimbot Ativado", CurrentValue = true, Callback = function(v) getgenv().Aimbot.Enabled = v end})
Tab:CreateToggle({Name = "Priorizar quem me bateu", CurrentValue = true, Callback = function(v) getgenv().Aimbot.PriorityAttacker = v end})
Tab:CreateToggle({Name = "WallCheck", CurrentValue = true, Callback = function(v) getgenv().Aimbot.WallCheck = v end})
Tab:CreateToggle({Name = "Prediction", CurrentValue = true, Callback = function(v) getgenv().Aimbot.Prediction = v end})
Tab:CreateSlider({Name = "FOV", Min = 30, Max = 500, CurrentValue = 180, Callback = function(v) getgenv().Aimbot.FOV = v end})
Tab:CreateSlider({Name = "Suavidade", Min = 0.01, Max = 0.5, Increment = 0.01, CurrentValue = 0.09, Callback = function(v) getgenv().Aimbot.Smoothness = v end})

Rayfield:Notify({Title="BILL REVENGE AIMBOT", Content="Carregado! Tecla E ou F1", Duration=6})

-- Toggle com tecla E
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == getgenv().Aimbot.KeyToggle then
        getgenv().Aimbot.Enabled = not getgenv().Aimbot.Enabled
        Rayfield:Notify({Title="Aimbot", Content=getgenv().Aimbot.Enabled and "LIGADO" or "DESLIGADO"})
    end
end)

print("BILL REVENGE AIMBOT 2025 CARREGADO - REVENGE MODE ON")
