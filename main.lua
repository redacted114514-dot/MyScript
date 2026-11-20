-- 纯原生长条形 Vape UI (无需联网)
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- 清理旧界面
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

-- 悬浮球拖动逻辑
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
-- 2. 主界面框架 (加长版)
-- ==========================================
local MainUI = Instance.new("Frame")
MainUI.Size = UDim2.new(0, 500, 0, 300) -- 加宽加长
MainUI.Position = UDim2.new(0.5, -250, 0.5, -150)
MainUI.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainUI.BorderSizePixel = 0
MainUI.Visible = false -- 默认隐藏
MainUI.Active = true
MainUI.Draggable = true
MainUI.Parent = ScreenGui
Instance.new("UICorner", MainUI).CornerRadius = UDim.new(0, 6)

-- 顶栏 (绿色)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
Header.Parent = MainUI
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "  VAPE V4 仿制版"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- 关闭按钮 (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Header

-- 左侧边栏 (分栏)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainUI
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local SideTitle = Instance.new("TextLabel")
SideTitle.Size = UDim2.new(1, 0, 0, 30)
SideTitle.BackgroundTransparency = 1
SideTitle.Text = "Combat"
SideTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
SideTitle.Font = Enum.Font.GothamBold
SideTitle.TextSize = 14
SideTitle.Parent = Sidebar

-- ==========================================
-- 3. 交互逻辑
-- ==========================================
local isMenuOpen = false
FloatBtn.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    MainUI.Visible = isMenuOpen
end)
CloseBtn.MouseButton1Click:Connect(function()
    MainUI.Visible = false
    isMenuOpen = false
end)

-- ==========================================
-- 4. 长条形开关组件
-- ==========================================
local function CreateLongToggle(text, yPos, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = "  " .. text
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Sidebar.Parent -- 放在主框架而不是侧边栏里
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    -- 把位置偏移到右侧
    Btn.Position = UDim2.new(0, 135, 0, yPos)

    -- 开关圆点
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(1, -24, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Dot.Parent = Btn
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    local isOn = false
    Btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            Dot.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 40, 35)
        else
            Dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
        if callback then callback(isOn) end
    end)
end

-- ==========================================
-- 5. 添加功能
-- ==========================================
CreateLongToggle("无限子弹", 45, function(state)
    if state then
        task.spawn(function()
            while state do
                task.wait(0.1)
                local char = player.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Local_CurrentAmmo") then
                        tool.Local_CurrentAmmo.Value = 999
                    end
                end
            end
        end)
    end
end)

CreateLongToggle("秒换弹", 90, function(state) end)
CreateLongToggle("无跳跃冷却", 135, function(state) end)
CreateLongToggle("透视 (ESP)", 180, function(state) end)