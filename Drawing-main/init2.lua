if (not Drawing) then
    print('Enviornment not supported! | Missing Function - Drawing')
    while wait() do end 
end 

--// Library Objects
local Draw = {}
local Calc = {}
--

--Primary Cache----------
local Cache = {}
-------------------------

--// Services 
local GetService = game.GetService
local RunService = GetService(game, 'RunService')
local UserInputService = GetService(game, 'UserInputService')
--

--// Public Constants 
local Vec2 = Vector2.new 
local CFn = CFrame.new 
local Camera = workspace.CurrentCamera
local ViewportPoint = Camera.WorldToViewportPoint
--

--// Public Functions
local Thread = function(func) return coroutine.resume(coroutine.create(func)) end 
--


--// Calc Class Functions 
function Calc:Get_Instance_Verticies(Instance,Data) 
    --
    local Verticies = {TR = 0, TL = 0, BL = 0, BR = 0}
    local C_Offset 
    local Data = Data or {_3D = false}
    local Offset = Data.Offset or {X = 0.1, Y = 0.5} 
    --

    --
    if (not Instance or not Instance.IsA(Instance, 'BasePart') or not Instance.IsDescendantOf(Instance, workspace)) then 
        return false 
    end 
    C_Offset = (Data._3D and Instance.CFrame or CFn(Instance.CFrame.p, Instance.CFrame.p - Camera.CFrame.lookVector))
    --

    --
    Verticies.TR = ViewportPoint(Camera, C_Offset * CFn(Instance.Size.X - Offset.X,   Instance.Size.Y + Offset.Y, 0).p)
    Verticies.TL = ViewportPoint(Camera, C_Offset * CFn(-Instance.Size.X + Offset.X,  Instance.Size.Y + Offset.Y, 0).p)
    Verticies.BL = ViewportPoint(Camera, C_Offset * CFn(Instance.Size.X - Offset.X,  -Instance.Size.Y - Offset.Y, 0).p)
    Verticies.BR = ViewportPoint(Camera, C_Offset * CFn(-Instance.Size.X + Offset.X, -Instance.Size.Y - Offset.Y, 0).p)
    --

    return Verticies
end 

function Calc:Instance_In_View(Instance)
    --
    if (not Instance or not Instance.IsA(Instance, 'BasePart')) then 
        return false 
    end 
    local _,Visible = ViewportPoint(Camera, Instance.Position)
    --
    return Visible
end 

--// Draw Class Functions 
function Draw:Draw_Box_On_Instance(Instance,Data)
    --
    if (not Instance or not Instance.IsA(Instance, 'BasePart') or not Instance.IsDescendantOf(Instance, workspace)) then 
        return false 
    end 
    --

    --
    local Box = Drawing.new('Quad')
    local Data = Data or {Enabled = true, BoxVerticies = {Offset = {X = 0.5, Y = 1}, _3D = false}}
    local c_Box = {Enabled = Data.Enabled, Box = Box, Instance = Instance}
    --

    --
    table.insert(Cache, c_Box)
    local CacheIndex = #Cache

    for c,k in next, (Data.BoxProperties or {Thickness = 1, Color = Color3.fromRGB(255,0,255)}) do 
        c_Box.Box[c] = k 
    end 
    --

    --
    function c_Box:Delete()
        table.remove(Cache, CacheIndex)
        c_Box.Box.Remove(c_Box.Box)
    end 
    --

    return c_Box
end 

--Render Loop-----------------
local Main = RunService.RenderStepped.Connect(RunService.RenderStepped, function()
    for c,Data in next, Cache do 
        --
        if (not Data.Instance or not Data.Instance.IsDescendantOf(Data.Instance, workspace)) then 
            Data.Delete(Data)
        end 
        --

        --
        local Verticies = Calc.Get_Instance_Verticies(Calc, Data.Instance, Data.BoxVerticies) 
        local Box = Data.Box 

        Box.PointA = Vec2(Verticies.TR.X, Verticies.TR.Y)
        Box.PointB = Vec2(Verticies.TL.X, Verticies.TL.Y)
        Box.PointC = Vec2(Verticies.BR.X, Verticies.BR.Y)
        Box.PointD = Vec2(Verticies.BL.X, Verticies.BL.Y)
        Box.Visible = (Data.Enabled and Calc.Instance_In_View(Calc, Data.Instance))
        --
    end 
end)
------------------------------


--// Return Object 
return Draw,Calc 



