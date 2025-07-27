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

-- Tabs
local MainTab = Window:CreateTab("Main", nil)
local PlayerTab = Window:CreateTab("Player", nil)
local CombatTab = Window:CreateTab("Combat", nil)
local MiscTab = Window:CreateTab("Misc", nil)
local CreditsTab = Window:CreateTab("Credits", nil)

-- Sections (Optional, for cleaner grouping)
-- Main tab - For future use (empty now)

-- Player tab Section
local PlayerSection = PlayerTab:CreateSection("Player Settings")

-- Walkspeed Slider
local walkspeed = 16
PlayerTab:CreateSlider({
    Name = "Walkspeed",
    Range = {0, 250},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = walkspeed,
    Flag = "WalkspeedSlider",
    Callback = function(value)
        walkspeed = value
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkspeed
        end
    end
})

-- Infinite Jump Checkbox
local infiniteJumpEnabled = false
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(state)
        infiniteJumpEnabled = state
    end
})

-- Connect Infinite Jump event ONCE outside UI callbacks
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Combat tab - empty for now, placeholder
CombatTab:CreateSection("Combat Features")

-- Misc tab Section
local MiscSection = MiscTab:CreateSection("Miscellaneous")

-- Teleport On Click Checkbox logic
local teleportOnClickEnabled = false
local mouse = game.Players.LocalPlayer:GetMouse()
local teleportConnection

MiscTab:CreateToggle({
    Name = "Teleport On Click",
    CurrentValue = false,
    Flag = "TeleportOnClickToggle",
    Callback = function(state)
        teleportOnClickEnabled = state
        if teleportOnClickEnabled then
            -- Connect Mouse Button1Down event
            if teleportConnection and teleportConnection.Connected then
                teleportConnection:Disconnect()
            end
            teleportConnection = mouse.Button1Down:Connect(function()
                if not teleportOnClickEnabled then return end
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = mouse.Hit and mouse.Hit.p
                    if targetPos then
                        -- Slightly offset Y to avoid going underground
                        local newPos = targetPos + Vector3.new(0, 3, 0)
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(newPos)
                    end
                end
            end)
        else
            -- Disconnect event to stop teleporting when disabled
            if teleportConnection and teleportConnection.Connected then
                teleportConnection:Disconnect()
            end
        end
    end
})

-- Credits tab Section
local CreditsSection = CreditsTab:CreateSection("Credits")
CreditsTab:CreateLabel("Developer Credits: fable")

-- Set initial Walkspeed on script load (to avoid zero speed)
local player = game.Players.LocalPlayer
if player and player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = walkspeed
end

-- Notify on script injection complete
Rayfield:Notify({
    Title = "Nexus Loaded",
    Content = "Script injected successfully!",
    Duration = 4,
    Image = nil,
})
