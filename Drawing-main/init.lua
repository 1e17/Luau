
--// Main Object 
local painter = {
    Drawings = {}
}

--// Constants 
local sketch = Drawing
local Mouse = game:GetService('Players').LocalPlayer:GetMouse()

--// Functions 
function painter:paint(name,properties)

    local painting = sketch.new(name)
    
    for index,value in next,properties do 
        painting[index] = value 
    end 
    
    table.insert(painter.Drawings,painting)

    return painting
end 

function painter:rePaint(painting,properties)
    
    for index,value in next,properties do 
        painting[index] = value 
    end 

end

function painter:togglePaintings(paintings,bool)

    for index,painting in next, paintings do 
        painting.Visible = bool 
    end 

end 

function painter:MouseOnDrawing(Drawing)

    if Drawing.Visible and (Mouse.X >= Drawing.Position.X and Mouse.X <= Drawing.Position.X + Drawing.Size.X) and (Mouse.Y + 36 >= Drawing.Position.Y and Mouse.Y + 36 <= Drawing.Position.Y + Drawing.Size.Y) then 
        return true 
    end 

    return false 

end 

function painter:DrawingOnDrawing(Drawing1, Drawing)

    if Drawing.Visible and (Drawing1.Position.X >= Drawing.Position.X and Drawing1.Position.X <= Drawing.Position.X + Drawing.Size.X) and (Drawing1.Position.Y >= Drawing.Position.Y and Drawing1.Position.Y + Drawing1.Size.Y <= Drawing.Position.Y + Drawing.Size.Y) then 
        return true 
    end 

    return false 
end 

function painter:erase(painting,recursive)

    if painting and recursive then 
        for _,value in next,painting do 
            value.Visible = false
            value:Remove()
        end 
    else 
        painting:Remove()
    end 

end

return painter
