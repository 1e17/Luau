
local player = game.Players.LocalPlayer 
local cursor = function()
    return player.PlayerGui.PlayScreen.PlayFrame.Cursor
end
local runservice = game:GetService('RunService')
local vim = game:GetService('VirtualInputManager')
local tweenservice = game:GetService('TweenService')

local function MoveCursor(Circle)
    local tween = tweenservice:Create(cursor(),TweenInfo.new(0.001,Enum.EasingStyle.Linear),{Position = Circle.Position})
    tween:Play()
end 

while true do runservice.RenderStepped:wait()
    for c,k in next, player.PlayerGui.PlayScreen.PlayFrame:GetChildren() do 
        if k.Name == 'Circle' and k:FindFirstChild('HitCircle') and k:FindFirstChild('ApproachCircle') then 
            if k.ApproachCircle.AbsoluteSize.X <= 190 then 
                MoveCursor(k)
                vim:SendKeyEvent(true,Enum.KeyCode.X,false,game)
            end 
        end 
    end 
end 

