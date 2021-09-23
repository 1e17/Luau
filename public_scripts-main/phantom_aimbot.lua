
--// Config 
if not shared.config then 
    shared.config = {
        aim_keybind = Enum.UserInputType.MouseButton2,
        aim_part = 'Head', 
        smoothness = 5,
        visualize_fov = true,
        fov_color = Color3.fromRGB(255,0,255),
        fov_size = 20,
        aesthetic = true,
        legit_chams = true
    }; 
end 

--// Check Enviornment 
if not mousemoverel then 
    while true do end;  -- lol buy synpase
end; 

--// Constants 
local config = shared.config;
local players = game:GetService('Players');
local player = players.LocalPlayer;
local mouse = player:GetMouse();
local aiming = false; 
local cham_cache = {};
local sky = Instance.new('Sky',game.Lighting);
local painter = loadstring(game:HttpGet('https://raw.githubusercontent.com/1e17/Drawing/main/init.lua'))('Drawing');
local fps = loadstring(game:HttpGet('https://raw.githubusercontent.com/1e17/public_scripts/main/fps_counter'))('Counter');
local run = game:GetService('RunService');
local input = game:GetService('UserInputService');
local fov = painter:paint('Circle',{Visible = config.visualize_fov, Radius = config.fov_size*10, Color = config.fov_color, Thickness = 1})
local vec2 = Vector2.new
local camera = workspace.CurrentCamera; 

--// Check Wall 
local function checkwall(object)

    if (object) then 
        local ray = (Ray.new(camera.CFrame.p, object.Position - camera.CFrame.p));
        local cast = (workspace:FindPartOnRayWithWhitelist(ray,{workspace.Map},false,true));

        if not cast then 
            return false
        end;

    end; 

    return true
end; 

--// Nearest Entity 
local function getentity()
    local part; 
    local distance = math.huge;

    for c,k in next, workspace.Players[(tostring(player.Team) == 'Phantoms' and 'Ghosts' or tostring(player.Team) == 'Ghosts' and 'Phantoms')]:GetChildren() do 
        local root = k:FindFirstChild(config.aim_part);

        if (root) then 
            local pos, vis = camera:WorldToViewportPoint(root.Position);
            local mag = (vec2(pos.x, pos.y) - vec2(mouse.x, mouse.y)).magnitude;
            local fmag = (vec2(fov.Position.x, fov.Position.y) - vec2(pos.x, pos.y)).magnitude;

            if (vis and not checkwall(root) and mag < distance and fmag < fov.Radius) then 
                part = root;
                distance = mag; 
            end;  

        end; 

    end; 

    return part
end; 

--// Apply Glow 
local function addglow(plr)
    
    for c,k in next, plr:GetChildren() do 

        if (k:IsA('BasePart') and not k:FindFirstChild('BoxHandleAdornment') and k.Name ~= 'HumanoidRootPart') then 
            local glow = Instance.new('BoxHandleAdornment',k);
            glow.Transparency = 0.05;
            glow.Visible = false; 
            glow.Size = k.Size + Vector3.new(0.2,0.2,0.2);
            glow.Color = BrickColor.new(Color3.fromRGB(255, 255, 13));
            glow.Adornee = k;
            table.insert(cham_cache,glow)
        end; 

    end; 
    
end; 

--// Main Loop 
local Loop = run.Stepped:Connect(function()

    --// Aimbot 
    local valid = (getentity() and camera:WorldToScreenPoint(getentity().Position));

    if (valid and aiming) then 
        mousemoverel((valid.x - mouse.x)/config.smoothness, (valid.y - mouse.y)/config.smoothness);
    end; 

    --// FOV 
    painter:rePaint(fov,{
        Visible = config.visualize_fov,
        Radius = config.fov_size*10,
        Color = config.fov_color,
        Position = vec2(mouse.x,mouse.y+36)
    });

end);

--// Adding Chams 
for c,k in next, workspace.Players[(tostring(player.Team) == 'Phantoms' and 'Ghosts' or tostring(player.Team) == 'Ghosts' and 'Phantoms')]:GetChildren() do 
    coroutine.wrap(addglow)(k);
end;

workspace.Players.DescendantAdded:Connect(function(child)
    if child.Name == 'Player' and child.Parent.Name == (tostring(player.Team) == 'Phantoms' and 'Ghosts' or tostring(player.Team) == 'Ghosts' and 'Phantoms') then 
        if (child:FindFirstChild('Head')) then 
            coroutine.wrap(addglow)(child);
        else 
            local temp;temp = child.ChildAdded:Connect(function(newchild)
                if (newchild.Name == 'Head') then 
                    coroutine.wrap(addglow)(child);
                    temp:Disconnect();
                end;
            end);
        end; 
    end;
end);

--// Binds 
local began = input.InputBegan:Connect(function(inp)
    inp = (inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode or inp.UserInputType);

    if (inp == config.aim_keybind) then 
        aiming = true; 
    end; 

end);

local ended = input.InputEnded:Connect(function(inp)
    inp = (inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode or inp.UserInputType);

    if (inp == config.aim_keybind) then 
        aiming = false; 
    end; 
    
end);

--// Misc 
local misc_loop = run.RenderStepped:Connect(function()

    --// Chams 
    for c,k in next, cham_cache do 
        if k.Parent ~= nil and k:IsDescendantOf(workspace.Players) then 
            k.Visible = config.legit_chams
            if not checkwall(k.Parent) then 
                k.Color = BrickColor.new(Color3.fromRGB(255, 255, 13))
            else 
                k.Color = BrickColor.new(Color3.fromRGB(203, 0, 245))
            end 
        else 
            k:Destroy()
            cham_cache[c] = nil
        end 
    end 

    --// Aesthetic 
    sky.SkyboxBk = (config.aesthetic and 'http://www.roblox.com/asset/?id=159454299' or 'rbxasset://textures/sky/sky512_bk.tex');
    sky.SkyboxDn = (config.aesthetic and 'http://www.roblox.com/asset/?id=159454296' or 'rbxasset://textures/sky/sky512_dn.tex');
    sky.SkyboxFt = (config.aesthetic and 'http://www.roblox.com/asset/?id=159454293' or 'rbxasset://textures/sky/sky512_ft.tex');
    sky.SkyboxLf = (config.aesthetic and 'http://www.roblox.com/asset/?id=159454286' or 'rbxasset://textures/sky/sky512_lf.tex');
    sky.SkyboxRt = (config.aesthetic and 'http://www.roblox.com/asset/?id=159454300' or 'rbxasset://textures/sky/sky512_rt.tex');
    sky.SkyboxUp = (config.aesthetic and 'http://www.roblox.com/asset/?id=159454288' or 'rbxasset://textures/sky/sky512_up.tex');
    sky.SunTextureId = (config.aesthetic and nil or 'rbxasset://sky/sun.jpg')

    game.Lighting.Ambient = (config.aesthetic and Color3.fromRGB(200,0,200) or Color3.fromRGB(100,100,100));
    game.Lighting.OutdoorAmbient = (config.aesthetic and Color3.fromRGB(200,0,200) or Color3.fromRGB(100,100,100));
    game.Lighting.ColorShift_Bottom = (config.aesthetic and Color3.fromRGB(200,0,200) or Color3.fromRGB(100,100,100));
    game.Lighting.ColorShift_Top = (config.aesthetic and Color3.fromRGB(200,0,200) or Color3.fromRGB(100,100,100));

end);
