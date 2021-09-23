

local players     = game:GetService('Players')
local player      = players.LocalPlayer 

local camera      = workspace.CurrentCamera
local world_view  = camera.WorldToViewportPoint
local bottom      = Vector2.new(camera.ViewportSize.x / 2, camera.ViewportSize.y / 1)

local run_service = game:GetService('RunService')

local esp = {
    ['cache']  = {},
    ['color']  = Color3.fromRGB(255,0,0),
    ['tracer'] = true,
    ['quad']   = true,
}

local cli;cli = {
    ['draw_object'] = function(drawing,properties)
        local new_drawing = Drawing.new(drawing)
        for property,value in pairs(properties) do 
            new_drawing[property] = value 
        end 
        return new_drawing
    end,
    ['unpack_drawing'] = function(drawing,properties)
        for property,value in pairs(properties) do 
            drawing[property] = value 
        end 
    end,
    ['register_player'] = function(plr)
        local box    = cli.draw_object('Quad',{Thickness = 2,Color = esp.color})
        local tracer = cli.draw_object('Line',{Thickness = 1,Color = esp.color})
        esp.cache[plr.Name] = {box = box,tracer = tracer}
    end,
    ['quad_points'] = function(part)
        return {
            ['top_right']    = world_view(camera,part.CFrame * CFrame.new(part.Size.x + 0.1,   part.Size.Y + 1, 0).Position),
            ['top_left']     = world_view(camera,part.CFrame * CFrame.new(-part.Size.x - 0.1,  part.Size.Y + 1, 0).Position),
            ['bottom_right'] = world_view(camera,part.CFrame * CFrame.new(-part.Size.x - 0.1, -part.Size.Y - 1, 0).Position),
            ['bottom_left']  = world_view(camera,part.CFrame * CFrame.new(part.Size.x + 0.1,  -part.Size.Y - 1, 0).Position)
        }
    end,
    ['update_drawing_table'] = function(plr_name,drawing_table)
        local plr  = players:FindFirstChild(plr_name)
        local char = (plr and plr.Character) and plr.Character:FindFirstChild('HumanoidRootPart')

        if (not plr or not char) then 
            drawing_table.box.Visible    = false 
            drawing_table.tracer.Visible = false
            return 
        end 

        local root_pos,root_vis = world_view(camera,char.Position)
        local quad_points = cli.quad_points(char)

        if esp.tracer and root_vis then 
            cli.unpack_drawing(drawing_table.tracer,{
                ['Visible'] = true,
                ['To']      = Vector2.new(root_pos.x,root_pos.y),
                ['From']    = bottom
            })
        else 
            drawing_table.tracer.Visible = false 
        end 

        if esp.quad and root_vis then 
            cli.unpack_drawing(drawing_table.box,{
                ['Visible'] = true,
                ['PointA']  = Vector2.new(quad_points.top_right.x,quad_points.top_right.y),
                ['PointB']  = Vector2.new(quad_points.top_left.x,quad_points.top_left.y),
                ['PointC']  = Vector2.new(quad_points.bottom_right.x,quad_points.bottom_right.y),
                ['PointD']  = Vector2.new(quad_points.bottom_left.x,quad_points.bottom_left.y),
            })
        else 
            drawing_table.box.Visible = false 
        end 

    end,
    ['drawing_update'] = function()
        for plr_name,drawing_table in pairs(esp.cache) do 
            cli.update_drawing_table(plr_name,drawing_table)
        end 
    end 
}


for _,plr in pairs(players:GetPlayers()) do 
    cli.register_player(plr)
end 
players.PlayerAdded:Connect(function(plr)
    cli.register_player(plr)
end)

local esp_connection = run_service.RenderStepped:Connect(cli.drawing_update)