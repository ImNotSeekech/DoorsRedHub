-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local guiParent = pcall(function() return CoreGui end) and CoreGui or player:FindFirstChild("PlayerGui")

-- Очистка старого гуи
if guiParent:FindFirstChild("RedHubDoors") then
    guiParent.RedHubDoors:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RedHubDoors"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- Плавающая кнопка (аккуратная, без лишнего мусора)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 50, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.Text = "RH"
toggleButton.TextColor3 = Color3.fromRGB(200, 50, 50)
toggleButton.TextSize = 13
toggleButton.Font = Enum.Font.Code
toggleButton.Parent = screenGui

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0, 8)
corner1.Parent = toggleButton

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 310, 0, 255)
mainFrame.Position = UDim2.new(0.5, -155, 0.5, -127)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 8)
corner2.Parent = mainFrame

-- Шапка меню
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.Text = "  RedHub | Doors v0.69"
titleBar.TextColor3 = Color3.fromRGB(180, 180, 180)
titleBar.TextSize = 12
titleBar.Font = Enum.Font.Code
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = mainFrame

local corner3 = Instance.new("UICorner")
corner3.CornerRadius = UDim.new(0, 8)
corner3.Parent = titleBar

-- Кнопка закрытия (крестик)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -32, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
closeBtn.TextSize = 12
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Перетаскивание кнопки по экрану
local dragging, dragInput, dragStart, startPos
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Функция создания переключателей (Toggle)
local function createToggle(posY, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = "  " .. name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextSize = 11
    btn.Font = Enum.Font.Code
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = mainFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.Text = "  " .. name .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(50, 220, 50)
            btn.BackgroundColor3 = Color3.fromRGB(25, 40, 25)
        else
            btn.Text = "  " .. name .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        end
        pcall(function()
            callback(enabled)
        end)
    end)
end

-- Добавляем чит-функции
createToggle(42, "Fullbright", function(state)
    Lighting.Brightness = state and 2 or 1
    Lighting.GlobalShadows = not state
end)

createToggle(78, "ESP (Entities / Monsters)", function(state)
    -- Имитация работы ESP
end)

createToggle(114, "ESP (Items / Keys / Books)", function(state)
    -- Имитация работы ESP
end)

createToggle(150, "Speed Boost (+16)", function(state)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = state and 22 or 16
    end
end)

createToggle(186, "NoClip (Bypass)", function(state)
    -- Имитация работы NoClip
end)
