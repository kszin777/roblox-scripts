-- SCRIPT BILL ULTIMATE 2025 - GUI + AIMBOT FIXADO
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Bill Hack GUI 2025",
   LoadingTitle = "Carregando Hacks...",
   LoadingSubtitle = "por Bill - o Melhor",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "billhack",
      FileName = "billconfig"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false
})

local AimbotTab = Window:CreateTab("Aimbot & ESP", 4483362458)
local MovementTab = Window:CreateTab("Movimento", 4483362458)
local RenderTab = Window:CreateTab("Render/FPS", 4483362458)

-- VARS GLOBAIS
getgenv().AimbotEnabled = true
getgenv().ESPenabled = true
getgenv().FlyEnabled = false
getgenv().NoclipEnabled = false
getgenv().SpeedValue = 16
getgenv().LowRenderEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ESP Objects
local ESPObjects = {}

-- FUNÇÃO AIMBOT SUAVE SEMPRE ON
local function GetClosestPlayer()
   local closest, dist = nil, math.huge
   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
         local head = player.Character.Head
         local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
         if onScreen then
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if distance < dist then
               closest = head
               dist = distance
            end
         end
      end
   end
   return closest
end

-- LOOP PRINCIPAL
RunService.Heartbeat:Connect(function()
   -- AIMBOT FIXADO - SEMPRE ON SE ATIVO
   if getgenv().AimbotEnabled then
      local target = GetClosestPlayer()
      if target then
         local targetPos = target.Position
         Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), 0.15)
      end
   end

   -- ESP
   if getgenv().ESPenabled then
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen and not ESPObjects[player] then
               local box = Drawing.new("Square")
               box.Color = Color3.fromRGB(255, 0, 255)
               box.Thickness = 2
               box.Filled = false
               box.Transparency = 0.5
               local name = Drawing.new("Text")
               name.Text = player.Name
               name.Color = Color3.fromRGB(255, 0, 255)
               name.Size = 16
               ESPObjects[player] = {Box = box, Name = name}
            elseif ESPObjects[player] then
               local obj = ESPObjects[player]
               local size = (Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0)).Y - Camera:WorldToViewportPoint(root.Position + Vector3.new(0,5,0)).Y)
               obj.Box.Size = Vector2.new(size/2, size)
               obj.Box.Position = Vector2.new(pos.X - size/4, pos.Y - size/2)
               obj.Name.Position = Vector2.new(pos.X, pos.Y - 50)
               obj.Box.Visible = true
               obj.Name.Visible = true
            end
         elseif ESPObjects[player] then
            ESPObjects[player].Box.Visible = false
            ESPObjects[player].Name.Visible = false
         end
      end
   end

   -- FLY
   if getgenv().FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local root = LocalPlayer.Character.HumanoidRootPart
      local bv = root:FindFirstChild("FlyBV") or Instance.new("BodyVelocity")
      bv.MaxForce = Vector3.new(4000,4000,4000)
      bv.Velocity = Vector3.new(0,0,0)
      bv.Parent = root
      local move = UserInputService:IsKeyDown(Enum.KeyCode.W) and Camera.CFrame.LookVector or Vector3.new()
      if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
      if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
      bv.Velocity = move * 50
   end

   -- NOCLIP
   if getgenv().NoclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetChildren()) do
         if part:IsA("BasePart") then part.CanCollide = false end
      end
   end

   -- SPEED
   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().SpeedValue
   end

   -- LOW RENDER
   if getgenv().LowRenderEnabled then
      game:GetService("Lighting").GlobalShadows = false
      game:GetService("Lighting").FogEnd = 999999
      setfpscap(30)
   end
end)

-- GUI TOGGLES
AimbotTab:CreateToggle({
   Name = "Aimbot (Sempre On/Suave)",
   CurrentValue = true,
   Callback = function(Value)
      getgenv().AimbotEnabled = Value
   end
})

AimbotTab:CreateToggle({
   Name = "ESP Cyberpink",
   CurrentValue = true,
   Callback = function(Value)
      getgenv().ESPenabled = Value
   end
})

MovementTab:CreateToggle({
   Name = "Fly (WASD + Space/Ctrl)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().FlyEnabled = Value
   end
})

MovementTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().NoclipEnabled = Value
   end
})

MovementTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      getgenv().SpeedValue = Value
   end
})

RenderTab:CreateToggle({
   Name = "Low Render (FPS Boost)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().LowRenderEnabled = Value
   end
})

Rayfield:Notify({
   Title = "Bill Hack Carregado!",
   Content = "GUI F1 | Aimbot Fixado | Tudo Toggle!",
   Duration = 5,
   Image = 4483362458
})

print("BILL ULTIMATE GUI 2025 - F1 PRA ABRIR")
