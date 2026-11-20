local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = Library:CreateWindow({Title = "VAPE V4 手机版", KeySystem = false, Size = UDim2.fromOffset(580, 460)})
local Combat = Window:CreateTab("Combat", "crosshair")
Combat:CreateSection("Gun Modifications")

Combat:CreateToggle({Title = "无限子弹", Callback = function(on)
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
end})