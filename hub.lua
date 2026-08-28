-- Celestial Hub - Multi-Game Script Loader
local hubData = {}

-- ============================================
-- DEFINE YOUR GAMES AND THEIR SCRIPTS HERE
-- ============================================

hubData["Murder Mystery 2"] = {
    icon = "🔪", -- optional, just for display
    scripts = {
        ["Aimbot"] = [[
            print("MM2 Aimbot loaded")
            -- your aimbot code here
        ]],
        ["ESP"] = [[
            print("MM2 ESP loaded")
            -- your ESP code here
        ]],
        ["Auto Farm"] = [[
            print("MM2 Auto Farm loaded")
            -- your auto farm code here
        ]],
        ["Kill All"] = [[
            print("MM2 Kill All loaded")
            -- your kill all code here
        ]]
    }
}

-- Example for next game (add later)
-- hubData["Arsenal"] = {
--     scripts = {
--         ["Aimbot"] = [[ print("Arsenal Aimbot") ]],
--         ["Triggerbot"] = [[ print("Arsenal Triggerbot") ]]
--     }
-- }

-- Example for another
-- hubData["Blox Fruits"] = {
--     scripts = {
--         ["Auto Farm"] = [[ print("Blox Fruits Farm") ]],
--         ["Teleport"] = [[ print("Blox Fruits Teleport") ]]
--     }
-- }

-- ============================================
-- GUI BUILDER - DO NOT EDIT BELOW
-- ============================================

local player = game:GetService("Players").LocalPlayer
local guiService = game:GetService("GuiService")
local userInput = game:GetService("UserInputService")

-- Main GUI
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
    screenGui:Destroy()
end)

-- Scroll frame for game buttons
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

-- Store sub-menus to destroy later
local subMenu = nil

-- Function to create a sub-menu for a game
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
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Celestial Hub",
                    Text = "Executed: " .. scriptName,
                    Duration = 1
                })
            end
        end)
        y = y + btnH + gap
    end
    
    scriptScroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
    
    -- Show sub-menu, hide game list
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
