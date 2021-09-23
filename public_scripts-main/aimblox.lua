
--// Config 
local config = {
    aimkey = Enum.UserInputType.MouseButton2,
    smoothness = 10,
}

--// Constants 
local Enabled = false
local Vec2 = Vector2.new 
local Camera = workspace.CurrentCamera 
local Mouse = game.Players.LocalPlayer:GetMouse()
local RunService = game:GetService('RunService')
local InputService = game:GetService('UserInputService')

--// Get Closest Entity 
local function GetNearestPart()
    local Part
    local Distance = math.huge 

    for c,k in next, workspace:GetChildren() do 
        if (k.Name == 'Part' and k:FindFirstChild('HealthBar')) then 
            local ScreenPosition, ScreenVisible = Camera:WorldToScreenPoint(k.Position)
            local Mag = (Vec2(Mouse.X,Mouse.Y) - Vec2(ScreenPosition.X,ScreenPosition.Y)).Magnitude

            if (ScreenVisible and Mag < Distance) then 
                Part = ScreenPosition
                Disance = mag 
            end  

        end 

    end 
    return Part
end 

--// KeyBind
local BindStart = InputService.InputBegan:Connect(function(Input)
    Input = ((Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode) or (Input.UserInputType))

    if Input == config.aimkey then 
        Enabled = true 
    end 

end)

local BindEnd = InputService.InputEnded:Connect(function(Input)
    Input = ((Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode) or (Input.UserInputType))

    if Input == config.aimkey then 
        Enabled = false 
    end 

end)

--// Main Loop 
local PrimaryLoop = RunService.Stepped:Connect(function()

    local Valid = GetNearestPart()

    if (Valid and Enabled) then 
        mousemoverel( (Valid.X - Mouse.X) / config.smoothness, (Valid.Y - Mouse.Y) / config.smoothness )
    end 

end)
