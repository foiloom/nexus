local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Nexus - Fling Things And People",
    LoadingTitle = "Nexus Development",
    LoadingSubtitle = "Creation designs - fable",
    ShowText = "Nexus UI",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NexusDevelopment",
        FileName = "NexusConfig"
    }
})

-- ========== Tabs ==========
local MainTab = Window:CreateTab("Main", nil)
local PlayerTab = Window:CreateTab("Player", nil)
local CombatTab = Window:CreateTab("Combat", nil)
local MiscTab = Window:CreateTab("Misc", nil)
local CreditsTab = Window:CreateTab("Credits", nil)

-- ========== Main Tab ==========
MainTab:CreateSection("Welcome")
MainTab:CreateLabel("Main tab is empty for now.")

-- ========== Player Tab ==========
local PlayerSection = PlayerTab:CreateSection("Player Settings")

-- Default Walkspeed value
local walkspeed = 16
local player = game.Players.LocalPlayer

-- Walkspeed slider
PlayerTab:CreateSlider({
    Name = "Walkspeed",
    Range = {0, 250},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = walkspeed,
    Flag = "WalkspeedSlider",
    Callback = function(value)
        walkspeed = value
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkspeed
        end
    end
})

-- Infinite Jump toggle
local infiniteJumpEnabled = false
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(state)
        infiniteJumpEnabled = state
        if infiniteJumpEnabled then
            Rayfield:Notify({
                Title = "Infinite Jump",
                Content = "Enabled",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Infinite Jump",
                Content = "Disabled",
                Duration = 3
            })
        end
    end
})

-- Infinite jump event connection (only once)
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ========== Combat Tab ==========
local CombatSection = CombatTab:CreateSection("Combat Features")
CombatTab:CreateLabel("No combat features added yet.")

-- ========== Misc Tab ==========
local MiscSection = MiscTab:CreateSection("Miscellaneous")

local teleportOnClickEnabled = false
local mouse = player:GetMouse()
local teleportConnection = nil

MiscTab:CreateToggle({
    Name = "Teleport On Click",
    CurrentValue = false,
    Flag = "TeleportOnClickToggle",
    Callback = function(state)
        teleportOnClickEnabled = state
        if teleportOnClickEnabled then
            -- Connect mouse click event safely
            if teleportConnection and teleportConnection.Connected then
                teleportConnection:Disconnect()
            end
            teleportConnection = mouse.Button1Down:Connect(function()
                if not teleportOnClickEnabled then return end
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local mousePos = mouse.Hit and mouse.Hit.p
                    if mousePos then
                        local targetPosition = mousePos + Vector3.new(0, 3, 0) -- Offset Y to avoid ground clipping
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                    end
                end
            end)
            Rayfield:Notify({
                Title = "Teleport On Click",
                Content = "Enabled",
                Duration = 3
            })
        else
            -- Disconnect when toggle off
            if teleportConnection and teleportConnection.Connected then
                teleportConnection:Disconnect()
                teleportConnection = nil
            end
            Rayfield:Notify({
                Title = "Teleport On Click",
                Content = "Disabled",
                Duration = 3
            })
        end
    end
})

-- ========== Credits Tab ==========
local CreditsSection = CreditsTab:CreateSection("Developer Credits")
CreditsTab:CreateLabel("Developer Credits: fable")

-- ========== Initialization ==========

-- Set initial walkspeed to default on script load
if player and player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = walkspeed
end

-- Notification upon script injection
Rayfield:Notify({
    Title = "Nexus Loaded",
    Content = "Script injected successfully!",
    Duration = 4
})
