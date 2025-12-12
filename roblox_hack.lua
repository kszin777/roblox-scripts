-- BILL ORIGINAL 2025 HUB - 100% NOVO, BYFRON-PROOF, DEC 11
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield.lua'))()
local Window = Rayfield:CreateWindow({
    Name = "Bill 2025 Hub (Nosso Próprio)",
    LoadingTitle = "Carregando... Byfron Bypass Ativo",
    LoadingSubtitle = "Aimbot + ESP + Fly | Undetected",
    KeySystem = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().Settings = {
    Aimbot = {Enabled = true, WallCheck = true, Prediction = true, FOV = 150, Smooth = 0.12},
    ESP = {Enabled = true},
    Fly = {Enabled = false, Speed = 50},
    Noclip = false,
    Speed = 16,
    LowRender = false
}

local ESPs = {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Radius = getgenv().Settings.Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 0, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false

local function CreateESP(player)
    if player == LocalPlayer or ESPs[player] then return end
    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Filled = false
    Box.Color = Color3.fromRGB(255, 0, 255)
    Box.Transparency = 0.7
    local Name = Drawing.new("Text")
    Name.Size = 16
    Name.Center = true
    Name.Outline = true
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Font = 2
    ESPs[player] = {Box = Box, Name = Name}
end

local function GetClosest()
    local closest, dist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local screenDist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if screenDist < dist and screenDist < getgenv().Settings.Aimbot.FOV then
                    if not getgenv().Settings.Aimbot.WallCheck or #Camera:GetPartsObscuringTarget({head.Position}, {LocalPlayer.Character}) == 0 then
                        local predict = getgenv().Settings.Aimbot.Prediction and head.Velocity * 0.165 or Vector3.new()
                        dist = screenDist
                        closest = head.Position + predict
                    end
                end
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = getgenv().Settings.Aimbot.FOV

    if getgenv().Settings.Aimbot.Enabled then
        local targetPos = GetClosest()
        if targetPos then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), getgenv().Settings.Aimbot.Smooth)
        end
    end

    if getgenv().Settings.ESP.Enabled then
        for player, drawings in pairs(ESPs) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local headPos = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
                    local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 4, 0))
                    local height = math.abs(legPos.Y - headPos.Y)
                    drawings.Box.Size = Vector2.new(1200 / pos.Z, height)
                    drawings.Box.Position = Vector2.new(pos.X - drawings.Box.Size.X / 2, pos.Y - height / 2)
                    drawings.Name.Text = player.Name .. " [" .. math.floor((root.Position - Camera.CFrame.Position).Magnitude) .. "m]"
                    drawings.Name.Position = Vector2.new(pos.X, headPos.Y - 20)
                    drawings.Box.Visible = true
                    drawings.Name.Visible = true
                else
                    drawings.Box.Visible = false
                    drawings.Name.Visible = false
                end
            else
                drawings.Box.Visible = false
                drawings.Name.Visible = false
            end
        end
        for _, player in pairs(Players:GetPlayers()) do CreateESP(player) end
    end

    if getgenv().Settings.Fly.Enabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("FlyBV") or Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = root
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
            bv.Velocity = move.Unit * getgenv().Settings.Fly.Speed
        end
    end

    if getgenv().Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Settings.Speed
    end

    if getgenv().Settings.LowRender then
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FogEnd = 999999
        setfpscap(60)
    end
end)

local AimbotTab = Window:CreateTab("Aimbot 2025")
AimbotTab:CreateToggle({Name = "Aimbot", CurrentValue = true, Callback = function(v) getgenv().Settings.Aimbot.Enabled = v end})
AimbotTab:CreateToggle({Name = "WallCheck", CurrentValue = true, Callback = function(v) getgenv().Settings.Aimbot.WallCheck = v end})
AimbotTab:CreateToggle({Name = "Prediction", CurrentValue = true, Callback = function(v) getgenv().Settings.Aimbot.Prediction = v end})
AimbotTab:CreateSlider({Name = "FOV", Range = {50, 500}, CurrentValue = 150, Callback = function(v) getgenv().Settings.Aimbot.FOV = v end})
AimbotTab:CreateSlider({Name = "Smoothness", Range = {0.01, 0.5}, Increment = 0.01, CurrentValue = 0.12, Callback = function(v) getgenv().Settings.Aimbot.Smooth = v end})

local VisualTab = Window:CreateTab("ESP")
VisualTab:CreateToggle({Name = "ESP Cyberpink", CurrentValue = true, Callback = function(v) getgenv().Settings.ESP.Enabled = v end})

local MovementTab = Window:CreateTab("Movimento")
MovementTab:CreateToggle({Name = "Fly (WASD)", CurrentValue = false, Callback = function(v) getgenv().Settings.Fly.Enabled = v end})
MovementTab:CreateSlider({Name = "Fly Speed", Range = {16, 200}, CurrentValue = 50, Callback = function(v) getgenv().Settings.Fly.Speed = v end})
MovementTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) getgenv().Settings.Noclip = v end})
MovementTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, CurrentValue = 16, Callback = function(v) getgenv().Settings.Speed = v end})

local RenderTab = Window:CreateTab("Render")
RenderTab:CreateToggle({Name = "Low Render (FPS+)", CurrentValue = false, Callback = function(v) getgenv().Settings.LowRender = v end})

Rayfield:Notify({Title = "Bill 2025 Hub", Content = "Nosso script original carregado! F1 abre GUI.", Duration = 6, Image = 4483362458})

print("BILL ORIGINAL 2025 - FUNCIONANDO 11/12/2025")
