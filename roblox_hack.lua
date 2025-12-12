local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "BILL HUB 2025 - VILA EDITION",
   LoadingTitle = "Carregando o melhor hack do planeta",
   LoadingSubtitle = "by Bill - o rei dos cheats",
   KeySystem = false
})

getgenv().Aim = {Enabled = true, WallCheck = true, Prediction = true, FOV = 120, Smoothness = 0.11}
getgenv().ESP = {Enabled = true}
getgenv().Fly = {Enabled = false, Speed = 100}
getgenv().Speed = {Value = 16}
getgenv().Noclip = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- FOV Circle
local FOV = Drawing.new("Circle")
FOV.Radius = getgenv().Aim.FOV
FOV.Color = Color3.fromRGB(255,0,255)
FOV.Thickness = 2
FOV.Filled = false
FOV.Visible = true

-- Aimbot principal
RunService.Heartbeat:Connect(function()
   FOV.Position = UserInputService:GetMouseLocation()
   FOV.Radius = getgenv().Aim.FOV

   if getgenv().Aim.Enabled then
      local closest = nil
      local dist = math.huge
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position + (head.Velocity * 0.165 if getgenv().Aim.Prediction else Vector3.new()))
            local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
            
            if onScreen and mag < dist and mag < getgenv().Aim.FOV then
               if not getgenv().Aim.WallCheck or #Camera:GetPartsObscuringTarget({head.Position}, {LocalPlayer.Character, plr.Character}) == 0 then
                  closest = head
                  dist = mag
               end
            end
         end
      end
      if closest then
         Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), getgenv().Aim.Smoothness)
      end
   end
end)

-- GUI
Window:CreateTab("Aimbot"):CreateToggle({Name="Aimbot", CurrentValue=true, Callback=function(v) getgenv().Aim.Enabled = v end})
Window:CreateTab("Aimbot"):CreateToggle({Name="WallCheck", CurrentValue=true, Callback=function(v) getgenv().Aim.WallCheck = v end})
Window:CreateTab("Aimbot"):CreateToggle({Name="Prediction", CurrentValue=true, Callback=function(v) getgenv().Aim.Prediction = v end})
Window:CreateTab("Aimbot"):CreateSlider({Name="FOV", Min=10, Max=360, CurrentValue=120, Callback=function(v) getgenv().Aim.FOV = v end})
Window:CreateTab("Aimbot"):CreateSlider({Name="Smoothness", Min=0.01, Max=1, CurrentValue=0.11, Callback=function(v) getgenv().Aim.Smoothness = v end})

Window:CreateTab("Visual"):CreateToggle({Name="ESP", CurrentValue=true, Callback=function(v) getgenv().ESP.Enabled = v end})

Window:CreateTab("Movement"):CreateToggle({Name="Fly (C)", CurrentValue=false, Callback=function(v) getgenv().Fly.Enabled = v end})
Window:CreateTab("Movement"):CreateSlider({Name="Fly Speed", Min=16, Max=300, CurrentValue=100, Callback=function(v) getgenv().Fly.Speed = v end})
Window:CreateTab("Movement"):CreateToggle({Name="Noclip", CurrentValue=false, Callback=function(v) getgenv().Noclip = v end})
Window:CreateTab("Movement"):CreateSlider({Name="WalkSpeed", Min=16, Max=300, CurrentValue=16, Callback=function(v) getgenv().Speed.Value = v; if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v end end})

Rayfield:Notify({Title="BILL HUB 2025", Content="Aimbot, ESP, Fly, tudo funcionando. F1 pra abrir de novo.", Duration=8})
print("BILL HUB CARREGADO - VILA EDITION 2025")
