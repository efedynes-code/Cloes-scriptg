-- Cloes Multi-Game Menu | v10.0 | By Cloes
-- Mobile + PC | Wall Shots Fixed

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CLOES MENU",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By Cloes",
   ConfigurationSaving = {Enabled = true, FolderName = "Cloes", FileName = "CloesV10"},
   KeySystem = false
})

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local lighting = game:GetService("Lighting")
local rs = game:GetService("ReplicatedStorage")

-- ============================================
-- STEALTH SEKMESİ
-- ============================================
local StealthTab = Window:CreateTab("🛡️ Stealth", 4483362458)

StealthTab:CreateSection("Ban Koruması")

StealthTab:CreateToggle({
   Name = "Anti-Cheat Bypass",
   CurrentValue = false,
   Flag = "StealthBypass",
   Callback = function(Value)
       if Value then
           local mt = getrawmetatable(game)
           local oldNamecall = mt.__namecall
           setreadonly(mt, false)
           mt.__namecall = newcclosure(function(self, ...)
               local method = getnamecallmethod()
               if method == "Kick" or method == "Ban" or method == "KickPlayer" then
                   return nil
               end
               return oldNamecall(self, ...)
           end)
           setreadonly(mt, true)
       end
   end,
})

StealthTab:CreateToggle({
   Name = "Speed Randomizer",
   CurrentValue = false,
   Flag = "StealthSpeed",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(2)
                   if humanoid.WalkSpeed > 16 then
                       humanoid.WalkSpeed = humanoid.WalkSpeed + math.random(-3, 3)
                   end
               end
           end)
       end
   end,
})

StealthTab:CreateToggle({
   Name = "Fake Lag",
   CurrentValue = false,
   Flag = "StealthLag",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(1)
                   game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0)
                   task.wait(0.2)
                   game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
               end
           end)
       end
   end,
})

StealthTab:CreateButton({
   Name = "Remove Kick Events",
   Callback = function()
       for _, v in pairs(rs:GetDescendants()) do
           if v:IsA("RemoteEvent") and (v.Name:lower():find("kick") or v.Name:lower():find("ban") or v.Name:lower():find("cheat")) then
               v:Destroy()
           end
       end
   end,
})

StealthTab:CreateToggle({
   Name = "Anti-Void",
   CurrentValue = false,
   Flag = "AntiVoid",
   Callback = function(Value)
       if Value then
           RunService.Stepped:Connect(function()
               if root.Position.Y < -50 then
                   root.CFrame = CFrame.new(0, 50, 0)
               end
           end)
       end
   end,
})

-- ============================================
-- MM2 SEKMESİ
-- ============================================
local MM2Tab = Window:CreateTab("MM2", 4483362458)

MM2Tab:CreateSection("General")

MM2Tab:CreateButton({
   Name = "Coin Farm (Yavaş)",
   Callback = function()
       task.spawn(function()
           while true do
               task.wait(0.8)
               for _, v in pairs(workspace:GetDescendants()) do
                   if v:IsA("BasePart") or v:IsA("MeshPart") then
                       local n = v.Name:lower()
                       if n:find("coin") or n:find("cash") then
                           local dist = (v.Position - root.Position).Magnitude
                           if dist < 150 then
                               root.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                               task.wait(0.5)
                           end
                       end
                   end
               end
           end
       end)
   end,
})

MM2Tab:CreateButton({
   Name = "Kill All (Murder Only)",
   Callback = function()
       for _, v in pairs(game.Players:GetPlayers()) do
           if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
               if v.Backpack:FindFirstChild("Knife") or v.Character:FindFirstChild("Knife") then
                   v.Character.Humanoid.Health = 0
               end
           end
       end
   end,
})

-- Yardımcı Fonksiyonlar
local function isSheriff()
    if player.Character then
        if player.Character:FindFirstChild("Gun") or player.Character:FindFirstChild("Revolver") then
            return true
        end
    end
    if player.Backpack then
        if player.Backpack:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Revolver") then
            return true
        end
    end
    return false
end

local function getMurder()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character then
            local hasKnife = false
            if v.Character:FindFirstChild("Knife") then hasKnife = true end
            if v.Backpack and v.Backpack:FindFirstChild("Knife") then hasKnife = true end
            if hasKnife then return v end
        end
    end
    return nil
end

local function getMurderHead()
    local murder = getMurder()
    if murder and murder.Character then
        local head = murder.Character:FindFirstChild("Head")
        local hrp = murder.Character:FindFirstChild("HumanoidRootPart")
        if head then return head end
        if hrp then return hrp end
    end
    return nil
end

MM2Tab:CreateSection("Sheriff")

MM2Tab:CreateToggle({
   Name = "Auto Shout Murder (Sheriff Only)",
   CurrentValue = false,
   Flag = "AutoShout",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(3)
                   if isSheriff() then
                       local murder = getMurder()
                       local murderName = murder and murder.Name or "None"
                       local chatEvent = rs:FindFirstChild("DefaultChatSystemChatEvents")
                       if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
                           chatEvent.SayMessageRequest:FireServer("Murder: " .. murderName, "All")
                       else
                           rs.SayMessageRequest:FireServer("Murder: " .. murderName, "All")
                       end
                   end
               end
           end)
       end
   end,
})

local wallShotsOn = false

MM2Tab:CreateToggle({
   Name = "Wall Shots (Sheriff Only)",
   CurrentValue = false,
   Flag = "WallShots",
   Callback = function(Value)
       wallShotsOn = Value
       if Value then
           task.spawn(function()
               while wallShotsOn do
                   task.wait(0.15)
                   if isSheriff() then
                       local target = getMurderHead()
                       if target then
                           camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
                           local shootEvent = nil
                           for _, v in pairs(rs:GetDescendants()) do
                               if v:IsA("RemoteEvent") and (v.Name == "ShootGun" or v.Name == "FireGun" or v.Name:lower():find("shoot")) then
                                   shootEvent = v
                                   break
                               end
                           end
                           if not shootEvent then
                               for _, tool in pairs(char:GetChildren()) do
                                   if tool:IsA("Tool") then
                                       for _, v in pairs(tool:GetDescendants()) do
                                           if v:IsA("RemoteEvent") then shootEvent = v break end
                                       end
                                   end
                               end
                           end
                           if shootEvent then
                               pcall(function() shootEvent:FireServer(target) end)
                           end
                           local tool = char:FindFirstChildOfClass("Tool")
                           if tool then pcall(function() tool:Activate() end) end
                       end
                   end
               end
           end)
       end
   end,
})

MM2Tab:CreateButton({
   Name = "Auto Throw (Murder Only)",
   Callback = function()
       task.spawn(function()
           while true do
               task.wait(0.7)
               local isMurder = false
               for _, v in pairs(player.Backpack:GetChildren()) do
                   if v.Name == "Knife" then isMurder = true end
               end
               if isMurder then
                   for _, v in pairs(game.Players:GetPlayers()) do
                       if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                           local args = {v.Character.HumanoidRootPart}
                           pcall(function() rs.ThrowKnife:FireServer(unpack(args)) end)
                       end
                   end
               end
           end
       end)
   end,
})

MM2Tab:CreateSection("ESP")

MM2Tab:CreateToggle({
   Name = "ESP (Renkli)",
   CurrentValue = false,
   Flag = "ESPMM2",
   Callback = function(Value)
       if Value then
           for _, v in pairs(game.Players:GetPlayers()) do
               if v ~= player and v.Character then
                   local h = Instance.new("Highlight")
                   h.Parent = v.Character
                   h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                   h.OutlineColor = Color3.fromRGB(255, 255, 255)
                   h.FillTransparency = 0.5
                   local hasKnife, hasGun = false, false
                   if v.Character:FindFirstChild("Knife") then hasKnife = true end
                   if v.Character:FindFirstChild("Gun") or v.Character:FindFirstChild("Revolver") then hasGun = true end
                   if v.Backpack then
                       if v.Backpack:FindFirstChild("Knife") then hasKnife = true end
                       if v.Backpack:FindFirstChild("Gun") or v.Backpack:FindFirstChild("Revolver") then hasGun = true end
                   end
                   if hasKnife then h.FillColor = Color3.fromRGB(255, 0, 0)
                   elseif hasGun then h.FillColor = Color3.fromRGB(0, 100, 255)
                   else h.FillColor = Color3.fromRGB(0, 255, 0) end
               end
           end
       else
           for _, v in pairs(game.Players:GetPlayers()) do
               if v.Character and v.Character:FindFirstChildOfClass("Highlight") then
                   v.Character:FindFirstChildOfClass("Highlight"):Destroy()
               end
           end
       end
   end,
})

MM2Tab:CreateSection("Teleport")

MM2Tab:CreateButton({
   Name = "Current Map",
   Callback = function()
       for _, v in pairs(workspace:GetChildren()) do
           if v:FindFirstChild("TeleportPart") then
               root.CFrame = v.TeleportPart.CFrame
               break
           end
       end
   end,
})

MM2Tab:CreateButton({
   Name = "Lobby",
   Callback = function()
       for _, v in pairs(workspace:GetChildren()) do
           if v.Name:lower():find("lobby") then
               root.CFrame = v.CFrame + Vector3.new(0, 10, 0)
               break
           end
       end
   end,
})
-- ============================================
-- ARSENAL SEKMESİ
-- ============================================
local ArsenalTab = Window:CreateTab("Arsenal", 4483362458)

ArsenalTab:CreateSection("Aimbot")

local arsenalAimbot = false
ArsenalTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "ArsenalAimbot",
   Callback = function(Value) arsenalAimbot = Value end,
})

RunService.RenderStepped:Connect(function()
   if arsenalAimbot then
       local closest, dist = nil, math.huge
       for _, v in pairs(game.Players:GetPlayers()) do
           if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
               local d = (v.Character.Head.Position - camera.CFrame.Position).Magnitude
               if d < dist then dist = d; closest = v.Character.Head end
           end
       end
       if closest then camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Position) end
   end
end)

ArsenalTab:CreateSection("Visual")

ArsenalTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ArsenalESP",
   Callback = function(Value)
       if Value then
           for _, v in pairs(game.Players:GetPlayers()) do
               if v ~= player and v.Character then
                   local h = Instance.new("Highlight")
                   h.Parent = v.Character
                   h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                   h.FillColor = Color3.fromRGB(255, 0, 0)
                   h.OutlineColor = Color3.fromRGB(255, 255, 255)
               end
           end
       else
           for _, v in pairs(game.Players:GetPlayers()) do
               if v.Character and v.Character:FindFirstChildOfClass("Highlight") then
                   v.Character:FindFirstChildOfClass("Highlight"):Destroy()
               end
           end
       end
   end,
})

ArsenalTab:CreateSection("Combat")

ArsenalTab:CreateToggle({
   Name = "Infinite Ammo",
   CurrentValue = false,
   Flag = "ArsenalAmmo",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.5)
                   for _, v in pairs(char:GetChildren()) do
                       if v:IsA("Tool") and v:FindFirstChild("Ammo") then
                           v.Ammo.Value = 999
                       end
                   end
               end
           end)
       end
   end,
})

ArsenalTab:CreateToggle({
   Name = "Rapid Fire",
   CurrentValue = false,
   Flag = "ArsenalRapid",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.05)
                   local tool = char:FindFirstChildOfClass("Tool")
                   if tool then tool:Activate() end
               end
           end)
       end
   end,
})

ArsenalTab:CreateSection("Movement")

ArsenalTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 120},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "ArsenalSpeed",
   Callback = function(Value) humanoid.WalkSpeed = Value end,
})

-- ============================================
-- DA HOOD SEKMESİ
-- ============================================
local DaHoodTab = Window:CreateTab("Da Hood", 4483362458)

DaHoodTab:CreateSection("Movement")

DaHoodTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 150},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "DaHoodSpeed",
   Callback = function(Value) humanoid.WalkSpeed = Value end,
})

DaHoodTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "DaHoodJump",
   Callback = function(Value)
       if Value then
           UIS.JumpRequest:Connect(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
       end
   end,
})

DaHoodTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "DaHoodNoclip",
   Callback = function(Value)
       if Value then
           for _, v in pairs(char:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
           end
       end
   end,
})

DaHoodTab:CreateSection("Combat")

DaHoodTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Flag = "DaHoodAura",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.3)
                   for _, v in pairs(game.Players:GetPlayers()) do
                       if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                           local dist = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
                           if dist < 15 then
                               local tool = char:FindFirstChildOfClass("Tool")
                               if tool then tool:Activate() end
                           end
                       end
                   end
               end
           end)
       end
   end,
})

-- ============================================
-- BLOX FRUITS SEKMESİ
-- ============================================
local BloxTab = Window:CreateTab("Blox Fruits", 4483362458)

BloxTab:CreateSection("Auto Farm")

local bloxFarm = false
BloxTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "BloxFarm",
   Callback = function(Value)
       bloxFarm = Value
       if Value then
           task.spawn(function()
               while bloxFarm do
                   task.wait(0.5)
                   for _, v in pairs(workspace:GetChildren()) do
                       if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                           if v.Name ~= player.Name then
                               root.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                           end
                       end
                   end
               end
           end)
       end
   end,
})

BloxTab:CreateSection("Movement")

BloxTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "BloxSpeed",
   Callback = function(Value) humanoid.WalkSpeed = Value end,
})

-- ============================================
-- PET SIM 99 SEKMESİ
-- ============================================
local PetTab = Window:CreateTab("Pet Sim 99", 4483362458)

PetTab:CreateSection("Auto")

PetTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "PetFarm",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.5)
                   for _, v in pairs(workspace:GetDescendants()) do
                       if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("breakable") or v.Name:lower():find("chest")) then
                           root.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                       end
                   end
               end
           end)
       end
   end,
})

PetTab:CreateButton({
   Name = "Auto Hatch Eggs",
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v.Name:lower():find("egg") and v:IsA("BasePart") then
               root.CFrame = v.CFrame + Vector3.new(0, 3, 0)
           end
       end
   end,
})

-- ============================================
-- MUSCLE LEGENDS SEKMESİ
-- ============================================
local MLTab = Window:CreateTab("Muscle Legends", 4483362458)

MLTab:CreateSection("Auto")

MLTab:CreateToggle({
   Name = "Auto Dumbbell",
   CurrentValue = false,
   Flag = "AutoDambil",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(1.5)
                   pcall(function() rs.Events.Dambil:FireServer(true) end)
               end
           end)
       end
   end,
})

MLTab:CreateToggle({
   Name = "Auto Pushup",
   CurrentValue = false,
   Flag = "AutoSinav",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(1.5)
                   pcall(function() rs.Events.Sinav:FireServer(true) end)
               end
           end)
       end
   end,
})

MLTab:CreateToggle({
   Name = "Auto Situp",
   CurrentValue = false,
   Flag = "AutoMekik",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(1.5)
                   pcall(function() rs.Events.Mekik:FireServer(true) end)
               end
           end)
       end
   end,
})

MLTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(3)
                   pcall(function() rs.Events.Rebirth:FireServer() end)
               end
           end)
       end
   end,
})

MLTab:CreateToggle({
   Name = "Auto Train All",
   CurrentValue = false,
   Flag = "AutoTrainAll",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(1)
                   pcall(function() rs.Events.Dambil:FireServer(true) end)
                   task.wait(0.3)
                   pcall(function() rs.Events.Sinav:FireServer(true) end)
                   task.wait(0.3)
                   pcall(function() rs.Events.Mekik:FireServer(true) end)
               end
           end)
       end
   end,
})

-- ============================================
-- UNIVERSAL SEKMESİ
-- ============================================
local UniTab = Window:CreateTab("Universal", 4483362458)

UniTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "UniESP",
   Callback = function(Value)
       if Value then
           for _, v in pairs(game.Players:GetPlayers()) do
               if v ~= player and v.Character then
                   local h = Instance.new("Highlight")
                   h.Parent = v.Character
                   h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                   h.FillColor = Color3.fromRGB(255, 0, 0)
                   h.OutlineColor = Color3.fromRGB(255, 255, 255)
               end
           end
       else
           for _, v in pairs(game.Players:GetPlayers()) do
               if v.Character and v.Character:FindFirstChildOfClass("Highlight") then
                   v.Character:FindFirstChildOfClass("Highlight"):Destroy()
               end
           end
       end
   end,
})

UniTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "UniBright",
   Callback = function(Value)
       if Value then
           lighting.Ambient = Color3.fromRGB(255, 255, 255)
           lighting.Brightness = 2
           lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
       else
           lighting.Ambient = Color3.fromRGB(0, 0, 0)
           lighting.Brightness = 1
           lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
       end
   end,
})

UniTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "UniAFK",
   Callback = function(Value)
       if Value then
           player.Idled:Connect(function()
               game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0))
               task.wait(1)
               game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0))
           end)
       end
   end,
})

UniTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 150},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "UniSpeed",
   Callback = function(Value) humanoid.WalkSpeed = Value end,
})

-- ============================================
-- ABOUT
-- ============================================
Window:CreateTab("About", 4483362458):CreateParagraph({
   Title = "CLOES MENU v10.0",
   Content = "Bu script Cloes tarafından yapılmıştır. By Cloes. Wall Shots artık Murder'ı otomatik hedefliyor."
})

Rayfield:Notify({
   Title = "CLOES MENU",
   Content = "Menu loaded! By Cloes",
   Duration = 5,
   Image = 4483362458,
})

print("Cloes Menu v10.0 loaded. By Cloes.")
