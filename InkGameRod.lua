-- Load external Ink Game script
loadstring(game:HttpGet("https://raw.githubusercontent.com/NysaDanielle/games/refs/heads/main/inkgame.lua"))()

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create main window
local Window = Rayfield:CreateWindow({
   Name = "🦑 Ink Game Script 🦑",
   Icon = 0,
   LoadingTitle = "🦑 Ink Game Script 🦑",
   LoadingSubtitle = "by Rodrigo 😊",
   ShowText = "Ink Game Script",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Phantom Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local Maintab = Window:CreateTab("Main", nil)
local Section = Maintab:CreateSection("Main")

-- WalkSpeed Slider
Maintab:CreateSlider({
   Name = "Player WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player and player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Auto Kill Toggle
local AutoKillRunning = false
local CurrentTarget = nil

Maintab:CreateToggle({
   Name = "Auto Kill",
   CurrentValue = false,
   Flag = "Auto Kill",
   Callback = function(Value)
      AutoKillRunning = Value

      local function GetClosestPlayer()
         local closest = nil
         local shortestDistance = math.huge
         local player = game.Players.LocalPlayer
         local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
         if not myHRP then return nil end

         for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
               local distance = (v.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
               if distance < shortestDistance then
                  shortestDistance = distance
                  closest = v
               end
            end
         end
         return closest
      end

      task.spawn(function()
         while AutoKillRunning do
            if not CurrentTarget or not CurrentTarget.Character or not CurrentTarget.Character:FindFirstChild("Humanoid") or CurrentTarget.Character.Humanoid.Health <= 0 then
               CurrentTarget = GetClosestPlayer()
            end

            if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
               local myChar = game.Players.LocalPlayer.Character
               if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                  local targetPos = CurrentTarget.Character.HumanoidRootPart.Position
                  local behindTarget = targetPos - (CurrentTarget.Character.HumanoidRootPart.CFrame.LookVector * 2)
                  myChar:MoveTo(behindTarget)
               end
            end

            task.wait(0.2)
         end
      end)
   end,
})

-- Infinite Jump Toggle
local UserInputService = game:GetService("UserInputService")
local InfiniteJumpEnabled = false

Maintab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(value)
        InfiniteJumpEnabled = value
    end,
})

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip Toggle
local RunService = game:GetService("RunService")
local NoclipEnabled = false

Maintab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        NoclipEnabled = Value
    end,
})

RunService.Stepped:Connect(function()
    if NoclipEnabled then
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- FOV Slider
Maintab:CreateSlider({
   Name = "Camera FOV",
   Range = {30, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Flag = "FOVSlider",
   Callback = function(Value)
      local camera = workspace.CurrentCamera
      if camera then
         camera.FieldOfView = Value
      end
   end,
})

-- Reset FOV Button
Maintab:CreateButton({
   Name = "Reset FOV to Default (70°)",
   Callback = function()
      local camera = workspace.CurrentCamera
      if camera then
         camera.FieldOfView = 70
      end
      Rayfield:Notify({
         Title = "FOV Reset",
         Content = "Camera FOV has been reset to 70°.",
         Duration = 3
      })
   end,
})
