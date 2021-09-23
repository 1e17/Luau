local lib = {}
--// Vars
local vec2 = Vector2.new
local uis = game:GetService('UserInputService')

--// Custom Functions 
local draw = function(type,props)
    local drawing = Drawing.new(type)
    for prop,value in pairs(props) do 
        drawing[prop] = (prop == 'Color' and Color3.fromRGB(unpack(value)) or value)
    end 
    return drawing
end 
local unpack_drawing = function(drawing,props)
    for prop,value in pairs(props) do 
        drawing[prop] = (prop == 'Color' and Color3.fromRGB(unpack(value)) or value)
    end 
end

--// Objects 
local offsetY = 810
local objects = {}
lib.new = function()
    objects['frame'] = draw('Square',{
        Visible = true,
        Position = vec2(20,800),
        Size = vec2(200,200),
        Transparency = 0.6,
        Color = {40,40,40},
        Filled = true
    })
end 

lib.toggle = function(name,key,callback)
    local enabled = false 
    objects['toggle_'..name] = draw('Text',{
        Visible = true,
        Outline = true,
        Color = {0,255,0},
        Font = 1,
        Size = 17,
        Center = false,
        Position = vec2(30,offsetY),
        Text = "["..key.."]  "..name..": "..tostring(enabled)
    })
    uis.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode[key] then 
            enabled = not enabled
            callback(enabled)
            objects['toggle_'..name].Text = "["..key.."]  "..name..": "..tostring(enabled)
        end 
    end)
    offsetY = offsetY + 26
end 

lib.hide = function(bool)
    for _,v in pairs(objects) do 
        v.Visible = bool
    end 
end 

return lib
