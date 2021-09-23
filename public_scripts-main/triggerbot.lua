
--// Enviornment Check 
if not (mouse1release and mouse1press and mousemoverel) then 
    while true do end -- XD, xd, Xd, xD, lmfao, lol, LOL, jaja
end 

getgenv().cfg = {} -- Global Table

--// Variables 
if #cfg == 0 then 
    cfg.TriggerBot = true 
    cfg.LockOnHover = true
    cfg.LockSmoothness = 5
end 

--// Services
local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')

--// Constants 
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera  
local Mouse = Player:GetMouse();Mouse.TargetFilter = Camera
local MouseLocation = UserInputService.GetMouseLocation
local MouseTarget = nil 
local Parts = {'Head','Arm','Leg','Torso','Root','Foot'}


---// Functions 
local function LocalPlayerExists()
    return (Player.Character and #Player.Character:GetChildren() > 0)
end 

local function LeftClick()
    mouse1press();wait(nil);mouse1release()
end 

local function CheckPart(Part)

    if not Part or Part:FindFirstAncestor('Map') or not LocalPlayerExists() or Part:IsDescendantOf(Player.Character) then 
        return false
    end 

    local Model = (Part):FindFirstAncestorWhichIsA('Model', true)

    if Model then
        for _,Name in next, Parts do 
            if (Part.Name):find(Name) then 
                return true
            end 
        end 
    end 

    if Model then 
        for _,Part_ in next, Model:GetChildren() do 
            for _,Name in next, Parts do 
                if (Part_.Name):find(Name) then 
                    return true 
                end 
            end 
        end 
    end 

end

--// Main 
local Main = coroutine.wrap(function()

    while true do RunService.Heartbeat:Wait()
        MouseTarget = Mouse.Target

        if MouseTarget and CheckPart(MouseTarget) then 
            if cfg.TriggerBot then 
                LeftClick()
            end 
            if cfg.LockOnHover then 
                local Position = Camera:WorldToScreenPoint(MouseTarget.Position)
                mousemoverel((Position.X - UserInputService:GetMouseLocation().X) / cfg.LockSmoothness, (Position.Y - UserInputService:GetMouseLocation().Y) / cfg.LockSmoothness)
            end 
        end 

    end 

end)()
