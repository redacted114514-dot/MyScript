-- 纯原生长条形 Vape UI (带飞行、自瞄、速度)
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if player.PlayerGui:FindFirstChild("NativeVapeMenu") then
    player.PlayerGui.NativeVapeMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NativeVapeMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

-- ==========================================
-- 1. 悬浮球开关
-- ==========================================
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 20, 0, 150)
FloatBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
FloatBtn.Text = "菜单"
FloatBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 14
FloatBtn.Parent = ScreenGui
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

-- 悬浮球拖动
local dragging, dragInput, dragStart, startPos
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
FloatBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FloatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- 2. 主界面框架
-- ==========================================
local MainUI = Instance.new("Frame")
MainUI.Size = UDim2.new(0, 500, 0, 300)
MainUI.Position = UDim2.new(0.5, -250, 0.5, -150)
MainUI.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainUI.BorderSizePixel = 0
MainUI.Visible = false
MainUI.Active = true
MainUI.Draggable = true
MainUI.Parent = ScreenGui
Instance.new("UICorner", MainUI).CornerRadius = UDim.new(0, 6)

-- 顶栏
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
Header.Parent = MainUI
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "  VAPE V4 增强版"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Header

-- 左侧边栏 (切换页面)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainUI
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

-- 内容容器 (切换页面用)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -30)
ContentFrame.Position = UDim2.new(0, 120, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainUI

-- 分类按钮
local TabCombat = Instance.new("TextButton")
TabCombat.Size = UDim2.new(1, 0, 0, 40)
TabCombat.Position = UDim2.new(0, 0, 0, 10)
TabCombat.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabCombat.Text = "Combat"
TabCombat.TextColor3 = Color3.fromRGB(0, 255, 128)
TabCombat.Font = Enum.Font.GothamBold
TabCombat.Parent = Sidebar
Instance.new("UICorner", TabCombat).CornerRadius = UDim.new(0, 4)

local TabMove = Instance.new("TextButton")
TabMove.Size = UDim2.new(1, 0, 0, 40)
TabMove.Position = UDim2.new(0, 0, 0, 60)
TabMove.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabMove.Text = "Movement"
TabMove.TextColor3 = Color3.fromRGB(200, 200, 200)
TabMove.Font = Enum.Font.GothamBold
TabMove.Parent = Sidebar
Instance.new("UICorner", TabMove).CornerRadius = UDim.new(0, 4)

-- 交互
local isMenuOpen = false
FloatBtn.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    MainUI.Visible = isMenuOpen
end)
CloseBtn.MouseButton1Click:Connect(function()
    MainUI.Visible = false
    isMenuOpen = false
end)

-- 切换页面逻辑
local CombatGroup = Instance.new("Folder", ContentFrame)
local MoveGroup = Instance.new("Folder", ContentFrame)
MoveGroup.Parent.Visible = false -- 默认隐藏移动页面

TabCombat.MouseButton1Click:Connect(function()
    CombatGroup.Parent = ContentFrame
    MoveGroup.Parent = nil
    TabCombat.TextColor3 = Color3.fromRGB(0, 255, 128)
    TabMove.TextColor3 = Color3.fromRGB(200, 200, 200)
end)
TabMove.MouseButton1Click:Connect(function()
    CombatGroup.Parent = nil
    MoveGroup.Parent = ContentFrame
    TabMove.TextColor3 = Color3.fromRGB(0, 255, 128)
    TabCombat.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- ==========================================
-- 3. 组件生成函数
-- ==========================================
-- 长条开关
local function CreateToggle(parentFolder, text, yPos, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = "  " .. text
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = parentFolder
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(1, -24, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Dot.Parent = Btn
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    local isOn = false
    Btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        Dot.BackgroundColor3 = isOn and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(100, 100, 100)
        Btn.BackgroundColor3 = isOn and Color3.fromRGB(30, 40, 35) or Color3.fromRGB(35, 35, 35)
        if callback then callback(isOn) end
    end)
end

-- 滑块 (用于速度调节)
local function CreateSlider(parentFolder, text, yPos, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 45)
    Frame.Position = UDim2.new(0, 10, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Frame.Parent = parentFolder
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 5, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0.9, 0, 0, 5)
    Bar.Position = UDim2.new(0.05, 0, 0, 30)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Bar.Parent = Frame
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    Fill.Parent = Bar
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function updateSlider(input)
        local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * percent)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Label.Text = text .. ": " .. value
        if callback then callback(value) end
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

-- ==========================================
-- 4. 填充功能 (Combat 页面)
-- ==========================================
CreateToggle(CombatGroup, "无限子弹", 10, function(state)
    if state then
        task.spawn(function()
            while state do
                task.wait(0.1)
                local char = player.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Local_CurrentAmmo") then tool.Local_CurrentAmmo.Value = 999 end
                end
            end
        end)
    end
end)

-- 自瞄逻辑
local isAimbot = false
local aimbotFOV = 150
CreateToggle(CombatGroup, "自瞄 (Aimbot)", 55, function(state)
    isAimbot = state
end)
CreateSlider(CombatGroup, "自瞄范围 (FOV)", 100, 50, 500, 150, function(val)
    aimbotFOV = val
end)

-- 自瞄核心循环
RunService.RenderStepped:Connect(function()
    if not isAimbot then return end
    
    local camera = workspace.CurrentCamera
    local closestTarge