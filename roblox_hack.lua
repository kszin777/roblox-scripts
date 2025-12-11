--[[  SCRIPT UNIVERSAL ROBLOX 2025 - BY BILL (O MELHOR)  ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configs
getgenv().Aimbot = true
getgenv().ESP = true
getgenv().Fly = false
getgenv().Speed = 100
getgenv().Noclip = false

-- ESP Limpo (sem lag)
local ESPObjects = {}
local function CreateESP(player)
    if player == LocalPlayer or ESPObjects[player] then return end
    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Filled = false
    Box.Color = Color3.fromRGB(255,0,255)
    Box.Transparency = 1
    
    local Name = Drawing.new("Text")
    Name.Size = 16
    Name.Center = true
    Name.Outline = true
    Name.Color = Color3.fromRGB(255,0,255)
    Name.Font = 2
    
    ESPObjects[player] = {Box = Box, Name = Name}
end

-- Fly + Noclip
local BodyGyro = nil
local BodyVelocity = nil
local function StartFly()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9000
    BodyGyro.maxTorque = Vector3.new(9000,9000,9000)
    BodyGyro.CFrame = root.CFrame
    BodyGyro.Parent = root
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(90000,90000,90000)
    BodyVelocity.Velocity = Vector3.new(0,0,0)
    BodyVelocity.Parent = root
end

-- Loop principal
RunService.Heartbeat:Connect(function()
    -- ESP Update
    if getgenv().ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                CreateESP(player)
                local root = player.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                local obj = ESPObjects[player]
                if obj and onScreen then
                    local headPos = Camera:WorldToViewportPoint(root.Position + Vector3.new(0,3,0))
                    local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,4,0))
                    local size = math.abs(headPos.Y - legPos.Y)
                    
                    obj.Box.Size = Vector2.new(size/2, size)
                    obj.Box.Position = Vector2.new(pos.X - obj.Box.Size.X/2, pos.Y - obj.Box.Size.Y/2)
                    obj.Box.Visible = true
                    
                    obj.Name.Text = player.Name .. " ["..math.floor((root.Position - Camera.CFrame.Position).Magnitude).."m]"
                    obj.Name.Position = Vector2.new(pos.X, headPos.Y - 20)
                    obj.Name.Visible = true
                elseif obj then
                    obj.Box.Visible = false
                    obj.Name.Visible = false
                end
            end
        end
    end
    
    -- Aimbot suave (segura botão direito)
    if getgenv().Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest = nil
        local closestDist = 300
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < closestDist then
                        closest = head
                        closestDist = dist
                    end
                end
            end
        end
        if closest then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, closest.Position), 0.2)
        end
    end
    
    -- Fly
    if getgenv().Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        
        BodyVelocity.Velocity = moveDir.Unit * getgenv().Speed
        BodyGyro.CFrame = Camera.CFrame
    end
end)

UserInputService.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.F then
        getgenv().ESP = not getgenv().ESP
        getgenv().Aimbot = not getgenv().Aimbot
        getgenv().Fly = not getgenv().Fly
        print("Hacks toggled → ESP:", getgenv().ESP, "Aimbot:", getgenv().Aimbot, "Fly:", getgenv().Fly)
    end
end)

print("SCRIPT 2025 CARREGADO – APERTE F PRA TOGGLAR")
