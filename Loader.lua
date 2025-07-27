local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Nexus - South Bronx Hub",
    LoadingTitle = "Nexus South Bronx",
    LoadingSubtitle = "Creation designs - fable",
    ShowText = "Nexus UI",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NexusSouthBronx",
        FileName = "NexusConfig"
    }
})

-- Main Tab (empty for now)
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Welcome")
MainTab:CreateLabel("Nexus South Bronx Hub - Features Below")

-- Player Tab: Utility Exploits
local PlayerTab = Window:CreateTab("Player")
PlayerTab:CreateSection("Player Mods")

-- Walkspeed
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 250},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- Infinite Jump
local infJump = false
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        infJump = state
        Rayfield:Notify({
            Title = "Infinite Jump",
            Content = infJump and "Enabled" or "Disabled",
            Duration = 2
        })
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Combat Tab: Aimbot & Silent Aim
local CombatTab = Window:CreateTab("Combat")
CombatTab:CreateSection("Combat Mods")

--[[ Example Aimbot/Silent Aim base structure — you MUST adapt this to South Bronx using a RemoteSpy
     and update the hit detection logic based on how the game registers hits.
     This example aimbot locks your aim to the nearest player's head within an aim radius.
]]
local aimKey = Enum.KeyCode.E
local aimRadius = 100
local aimbotEnabled = false
CombatTab:CreateToggle({
    Name = "Silent Aim / Aimbot",
    CurrentValue = false,
    Callback = function(state)
        aimbotEnabled = state
        Rayfield:Notify({
            Title = "Aimbot",
            Content = aimbotEnabled and "Enabled" or "Disabled",
            Duration = 2
        })
    end
})

local function getClosestPlayer()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char or not char:FindFirstChild("Head") then return end
    local closest, closestDist
    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Head") and plr.Team ~= lp.Team then
            local dist = (char.Head.Position - plr.Character.Head.Position).Magnitude
            if (not closestDist or dist < closestDist) and dist <= aimRadius then
                closest, closestDist = plr, dist
            end
        end
    end
    return closest
end

game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local lp = game.Players.LocalPlayer
            local mouse = lp:GetMouse()
            mouse.TargetFilter = target.Character
            -- For aimbot: snap camera to head
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
            -- For silent aim you'll want to intercept bullet/hit remote and change its target to target.Character.Head.Position
        end
    end
end)

-- Misc Tab: Free Tier, Hot Chips, Teleport, etc.
local MiscTab = Window:CreateTab("Misc")
MiscTab:CreateSection("Miscellaneous")

-- Click-to-Teleport
local teleportClick = false
local tpConn
MiscTab:CreateToggle({
    Name = "Teleport On Click",
    CurrentValue = false,
    Callback = function(state)
        teleportClick = state
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        if teleportClick then
            tpConn = mouse.Button1Down:Connect(function()
                if teleportClick and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0,3,0))
                end
            end)
        elseif tpConn then
            tpConn:Disconnect()
            tpConn = nil
        end
    end
})

-- Gun Dupe (template: must be customized per South Bronx's remotes/objects)
MiscTab:CreateButton({
    Name = "Gun Dupe (Example)",
    Description = "Attempt to dupe all guns in backpack",
    Callback = function()
        local player = game.Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        -- You MUST use correct gun RemoteEvent for true dupe; this is a template
        local gunEvent = ReplicatedStorage:FindFirstChild("GunEvent")
        local backpack = player:FindFirstChild("Backpack")
        if gunEvent and backpack then
            for _,tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local dupe = tool:Clone()
                    dupe.Parent = backpack
                    pcall(function() gunEvent:FireServer(dupe.Name) end)
                end
            end
            Rayfield:Notify({Title = "Gun Dupe", Content="Attempted dupe.", Duration=2})
        else
            Rayfield:Notify({Title = "Gun Dupe", Content="Remote/Backpack not found.", Duration=2})
        end
    end
})

-- Money Dupe (template: must be customized based on detected money RemoteEvent)
MiscTab:CreateButton({
    Name = "Money Dupe (Example)",
    Description = "Attempt to dupe money by firing money event.",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local player = game.Players.LocalPlayer
        -- Replace with actual remote event for adding money
        local moneyEvent = ReplicatedStorage:FindFirstChild("MoneyEvent")
        if moneyEvent then
            for i=1,10 do
                pcall(function() moneyEvent:FireServer(1000) end)
                wait(0.1)
            end
            Rayfield:Notify({Title="Money Dupe",Content="Attempted dupe.",Duration=2})
        else
            Rayfield:Notify({Title="Money Dupe",Content="Money event not found.",Duration=2})
        end
    end
})

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits")
CreditsTab:CreateSection("Developer Credits")
CreditsTab:CreateLabel("Developer: fable | Nexus Team")

-- Initial WalkSpeed setup (prevents running at zero speed)
local player = game.Players.LocalPlayer
if player and player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = 16
end

Rayfield:Notify({
    Title = "Nexus Loaded",
    Content = "South Bronx script loaded successfully!",
    Duration = 3,
})