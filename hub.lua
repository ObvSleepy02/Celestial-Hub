-- My Custom Roblox Hub - Hosted on GitHub
local scripts = {}

-- === ADD YOUR OWN SCRIPTS HERE ===
scripts["Fly"] = [[
    local plr = game:GetService("Players").LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    local uis = game:GetService("UserInputService")
    local con
    con = game:GetService("RunService").Heartbeat:Connect(function()
        local move = Vector3.new(0, 0, 0)
        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(1, 0, 0) end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - Vector3.new(1, 0, 0) end
        if uis:IsKeyDown(Enum.KeyCode.A) then move = move - Vector3.new(0, 0, 1) end
        if uis:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(0, 0, 1) end
        if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
        if move.Magnitude > 0 then bv.Velocity = move.Unit * 50 else bv.Velocity = Vector3.new(0, 0, 0) end
    end)
    pcall(function() con:Wait() end)
]]

scripts["Speed"] = [[
    local plr = game:GetService("Players").LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 50
    hum.JumpPower = 80
]]

scripts["ESP"] = [[
    local plr = game:GetService("Players").LocalPlayer
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= plr then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(4, 6, 2)
            box.Color3 = Color3.new(1, 0, 0)
            box.Transparency = 0.5
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Adornee = v.Character:WaitForChild("HumanoidRootPart")
            box.Parent = v.Character
        end
    end
]]

scripts["TP to Mouse"] = [[
    local plr = game:GetService("Players").LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local mouse = plr:GetMouse()
    local uis = game:GetService("UserInputService")
    local con
    con = uis.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    pcall(function() con:Wait() end)
]]

-- === GUI BUILDER ===
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MyHub"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 350)
frame.Position = UDim2.new(0.5, -140, 0.5, -175)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.new(0.3, 0.8, 1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
title.Text = "My Custom Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -60)
scroll.Position = UDim2.new(0, 5, 0, 30)
scroll.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
scroll.BackgroundTransparency = 0.5
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 6
scroll.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.new(0.8, 0.1, 0.1)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local y = 0
local btnH = 28
local gap = 4

for name, code in pairs(scripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, btnH)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = Color3.new(0.2, 0.4, 0.6)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(function()
        local success, err = pcall(loadstring(code))
        if not success then warn("Error: " .. tostring(err)) end
    end)
    y = y + btnH + gap
end

scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
