-- Celestial Hub - MM2 Toggle Scripts
local hubData = {}
local toggles = {} -- stores active state for each script

-- ============================================
-- MM2 SCRIPTS WITH TOGGLE
-- ============================================

hubData["Murder Mystery 2"] = {
    icon = "🔪",
    scripts = {
        ["ESP"] = [[
            local toggles = getgenv().CelestialToggles or {}
            local key = "MM2_ESP"
            if toggles[key] then
                toggles[key] = false
                if toggles[key .. "_conn"] then
                    toggles[key .. "_conn"]:Disconnect()
                    toggles[key .. "_conn"] = nil
                end
                for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                    if plr.Character then
                        for _, child in pairs(plr.Character:GetChildren()) do
                            if child:IsA("Highlight") then child:Destroy() end
                        end
                    end
                end
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "ESP", Text = "Off", Duration = 1})
                return
            end
            toggles[key] = true
            getgenv().CelestialToggles = toggles

            local function getRole(plr)
                if not plr.Character then return "Innocent" end
                local char = plr.Character
                if char:FindFirstChild("Murderer") or char:FindFirstChild("Knife") or char:FindFirstChild("Sword") then
                    return "Murderer"
                elseif char:FindFirstChild("Sheriff") or char:FindFirstChild("Gun") or char:FindFirstChild("Revolver") then
                    return "Sheriff"
                else
                    return "Innocent"
                end
            end

            local function addESP(plr)
                if not toggles[key] then return end
                if plr == game:GetService("Players").LocalPlayer then return end
                local char = plr.Character
                if not char then return end
                for _, child in pairs(char:GetChildren()) do
                    if child:IsA("Highlight") then child:Destroy() end
                end
                local highlight = Instance.new("Highlight")
                highlight.Parent = char
                local role = getRole(plr)
                if role == "Murderer" then
                    highlight.FillColor = Color3.new(1, 0, 0)
                    highlight.OutlineColor = Color3.new(1, 0.2, 0.2)
                elseif role == "Sheriff" then
                    highlight.FillColor = Color3.new(0, 0.4, 1)
                    highlight.OutlineColor = Color3.new(0.2, 0.6, 1)
                else
                    highlight.FillColor = Color3.new(0, 1, 0)
                    highlight.OutlineColor = Color3.new(0.2, 1, 0.2)
                end
                highlight.Enabled = true
            end

            for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                addESP(plr)
            end
            local conn
            conn = game:GetService("Players").PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function()
                    addESP(plr)
                end)
                addESP(plr)
            end)
            toggles[key .. "_conn"] = conn
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "ESP", Text = "On - Red=Murderer Blue=Sheriff Green=Innocent", Duration = 3})
        ]],

        ["Aimbot (Sheriff)"] = [[
            local toggles = getgenv().CelestialToggles or {}
            local key = "MM2_Aimbot"
            if toggles[key] then
                toggles[key] = false
                if toggles[key .. "_conn"] then
                    toggles[key .. "_conn"]:Disconnect()
                    toggles[key .. "_conn"] = nil
                end
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Aimbot", Text = "Off", Duration = 1})
                return
            end
            toggles[key] = true
            getgenv().CelestialToggles = toggles

            local player = game:GetService("Players").LocalPlayer
            local camera = game:GetService("Workspace").CurrentCamera

            local function getMurderer()
                for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local char = plr.Character
                        if char:FindFirstChild("Murderer") or char:FindFirstChild("Knife") or char:FindFirstChild("Sword") then
                            return plr
                        end
                    end
                end
                return nil
            end

            local conn
            conn = game:GetService("RunService").RenderStepped:Connect(function()
                if not toggles[key] then return end
                local murderer = getMurderer()
                if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                    local target = murderer.Character.HumanoidRootPart
                    local targetPos = target.Position + Vector3.new(0, 1.5, 0)
                    camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
                end
            end)
            toggles[key .. "_conn"] = conn
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Aimbot", Text = "On - Locked to Murderer", Duration = 2})
        ]],

        ["Auto Farm (Fly+Noclip)"] = [[
            local toggles = getgenv().CelestialToggles or {}
            local key = "MM2_AutoFarm"
            if toggles[key] then
                toggles[key] = false
                if toggles[key .. "_conn"] then
                    toggles[key .. "_conn"]:Disconnect()
                    toggles[key .. "_conn"] = nil
                end
                -- Remove fly/noclip
                local char = game:GetService("Players").LocalPlayer.Character
                if char then
                    local bv = char:FindFirstChild("BodyVelocity")
                    if bv then bv:Destroy() end
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.PlatformStand = false
                        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
                        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                    end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CanCollide = true
                    end
                end
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Auto Farm", Text = "Off", Duration = 1})
                return
            end
            toggles[key] = true
            getgenv().CelestialToggles = toggles

            local player = game:GetService("Players").LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local hum = char:WaitForChild("Humanoid")

            -- Enable noclip
            hrp.CanCollide = false
            -- Enable fly
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp

            -- Disable gravity effects on humanoid
            hum.PlatformStand = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

            local function getNearestCoin()
                local nearest = nil
                local minDist = math.huge
                for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if obj:IsA("Part") and (obj.Name:lower():find("coin") or obj.Name:lower():find("gem") or obj.Name:lower():find("diamond") or obj:FindFirstChild("ClickDetector")) then
                        local dist = (hrp.Position - obj.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = obj
                        end
                    end
                end
                return nearest
            end

            local conn
            conn = game:GetService("RunService").Heartbeat:Connect(function()
                if not toggles[key] then return end
                local target = getNearestCoin()
                if target then
                    -- Fly towards target
                    local direction = (target.Position - hrp.Position).Unit
                    bv.Velocity = direction * 60
                    -- Slight hover height
                    if (target.Position - hrp.Position).Y < 2 then
                        bv.Velocity = bv.Velocity + Vector3.new(0, 10, 0)
                    end
                    wait(0.05)
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
            end)
            toggles[key .. "_conn"] = conn
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Auto Farm", Text = "On - Flying + Noclip to coins", Duration = 2})
        ]],

        ["Kill All (Teleport to you)"] = [[
            local toggles = getgenv().CelestialToggles or {}
            local key = "MM2_KillAll"
            if toggles[key] then
                toggles[key] = false
                if toggles[key .. "_conn"] then
                    toggles[key .. "_conn"]:Disconnect()
                    toggles[key .. "_conn"] = nil
                end
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Kill All", Text = "Off", Duration = 1})
                return
            end
            toggles[key] = true
            getgenv().CelestialToggles = toggles

            local player = game:GetService("Players").LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")

            local conn
            conn = game:GetService("RunService").Heartbeat:Connect(function()
                if not toggles[key] then return end
                for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHrp = plr.Character.HumanoidRootPart
                        -- Teleport player to you
                        targetHrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 0, 0))
                        -- Stun them so they can't run
                        local hum = plr.Character:FindFirstChild("Humanoid")
                        if hum then
                            hum.PlatformStand = true
                            wait(0.1)
                            hum.PlatformStand = false
                        end
                    end
                end
            end)
            toggles[key .. "_conn"] = conn
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Kill All", Text = "On - Teleporting all to you", Duration = 2})
        ]]
    }
}
-- ============================================
-- GUI BUILDER (same as before, but works with toggles)
-- ============================================

local player = game:GetService("Players").LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CelestialHub"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(0.6, 0.2, 0.8)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.15, 0.05, 0.2)
title.Text = "Celestial Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 1)
closeBtn.BackgroundColor3 = Color3.new(0.7, 0.1, 0.1)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    -- Cleanup all toggles on close
    local toggles = getgenv().CelestialToggles or {}
    for k, v in pairs(toggles) do
        if type(v) == "boolean" and v then
            -- Try to toggle off each active script (simplified cleanup)
        end
    end
    screenGui:Destroy()
end)

local gameScroll = Instance.new("ScrollingFrame")
gameScroll.Size = UDim2.new(1, -10, 1, -40)
gameScroll.Position = UDim2.new(0, 5, 0, 35)
gameScroll.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
gameScroll.BackgroundTransparency = 0.5
gameScroll.BorderSizePixel = 0
gameScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
gameScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
gameScroll.ScrollBarThickness = 5
gameScroll.Parent = mainFrame

local subMenu = nil

local function createSubMenu(gameName, scriptTable)
    if subMenu then subMenu:Destroy() end
    
    subMenu = Instance.new("Frame")
    subMenu.Size = UDim2.new(1, -20, 1, -20)
    subMenu.Position = UDim2.new(0, 10, 0, 10)
    subMenu.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    subMenu.BackgroundTransparency = 0.1
    subMenu.BorderSizePixel = 2
    subMenu.BorderColor3 = Color3.new(0.8, 0.3, 0.9)
    subMenu.Visible = false
    subMenu.Parent = mainFrame
    
    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, 0, 0, 25)
    subTitle.Position = UDim2.new(0, 0, 0, 0)
    subTitle.BackgroundColor3 = Color3.new(0.15, 0.05, 0.2)
    subTitle.Text = gameName .. " Scripts"
    subTitle.TextColor3 = Color3.new(1, 1, 1)
    subTitle.TextScaled = true
    subTitle.Font = Enum.Font.GothamBold
    subTitle.Parent = subMenu
    
    local backBtn = Instance.new("TextButton")
    backBtn.Size = UDim2.new(0, 50, 0, 22)
    backBtn.Position = UDim2.new(0, 5, 0, 27)
    backBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.4)
    backBtn.Text = "← Back"
    backBtn.TextColor3 = Color3.new(1, 1, 1)
    backBtn.TextScaled = true
    backBtn.Font = Enum.Font.GothamMedium
    backBtn.Parent = subMenu
    backBtn.MouseButton1Click:Connect(function()
        subMenu.Visible = false
        gameScroll.Visible = true
    end)
    
    local scriptScroll = Instance.new("ScrollingFrame")
    scriptScroll.Size = UDim2.new(1, -10, 1, -60)
    scriptScroll.Position = UDim2.new(0, 5, 0, 52)
    scriptScroll.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    scriptScroll.BackgroundTransparency = 0.5
    scriptScroll.BorderSizePixel = 0
    scriptScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scriptScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scriptScroll.ScrollBarThickness = 5
    scriptScroll.Parent = subMenu
    
    local y = 0
    local btnH = 30
    local gap = 4
    
    for scriptName, code in pairs(scriptTable) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, btnH)
        btn.Position = UDim2.new(0, 0, 0, y)
        btn.BackgroundColor3 = Color3.new(0.25, 0.15, 0.35)
        btn.Text = scriptName
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = scriptScroll
        btn.MouseButton1Click:Connect(function()
            local success, err = pcall(loadstring(code))
            if not success then
                warn("Script error [" .. scriptName .. "]: " .. tostring(err))
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Error",
                    Text = "Script failed: " .. scriptName,
                    Duration = 2
                })
            end
        end)
        y = y + btnH + gap
    end
    
    scriptScroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
    subMenu.Visible = true
    gameScroll.Visible = false
end

-- Build game buttons
local y = 0
local btnH = 40
local gap = 6

for gameName, data in pairs(hubData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, btnH)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = Color3.new(0.2, 0.1, 0.3)
    btn.Text = (data.icon or "▶") .. " " .. gameName
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = gameScroll
    btn.MouseButton1Click:Connect(function()
        createSubMenu(gameName, data.scripts)
    end)
    y = y + btnH + gap
end

gameScroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
