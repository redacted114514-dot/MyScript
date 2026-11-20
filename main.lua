local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = Library:CreateWindow({
    Title = "VAPE V4 手机版",
    KeySystem = false,
    Size = UDim2.fromOffset(580, 460)
})

local Combat = Window:CreateTab("Combat", "crosshair")
Combat:CreateSection("Gun Modifications")

Combat:CreateToggle({
    Title = "无限子弹",
    Callback = function(on)
        if on then 
            task.spawn(function() 
                while on do 
                    task.wait(0.1) 
                    local char = game.Players.LocalPlayer.Character 
                    if char and char:FindFirstChildOfClass("Tool") then 
                        local tool = char:FindFirstChildOfClass("Tool")
                        local ammo = tool:FindFirstChild("Local_CurrentAmmo")
                        if ammo then ammo.Value = 999 end
                    end 
                end 
            end) 
        end
    end
})

Combat:CreateToggle({
    Title = "秒换弹",
    Callback = function(on)
        if on then
            game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
                    local RS = game:GetService("ReplicatedStorage")
                    if RS:FindFirstChild("GunRemotes") and RS.GunRemotes:FindFirstChild("FuncReload") then
                        pcall(function() RS.GunRemotes.FuncReload:InvokeServer() end)
                    end
                end
            end)
        end
    end
})

-- 🔥 这一句是关键！告诉 UI 库渲染出来
Library:Init()