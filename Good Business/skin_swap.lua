
--[[
  If you use this give credit to Require please
]]

local skin_swap = {} 
local skins 
local rep = game:GetService('ReplicatedStorage')
local funcs = require(rep.TS)
local menu = funcs.Menu
local lp = game.Players.LocalPlayer 
local weapons = rep.PlayerData[lp.Name].Weapons

do 
  for c,k in next, rep:GetChildren() do 
    if k.Name == ' ' then 
      local modules = k:FindFirstChild('Skins',true)
      if modules then 
        skins = modules 
        break 
      end 
    end 
  end 
end 

function skin_swap.getModel()
  for c,k in next, workspace:GetChildren() do 
    if k.Name == menu.CurrentWeapon and k:FindFirstChild('AnimationController') then 
      return k 
    end 
  end 
end 

function skin_swap:paint(skin,model)
  local skinData = require(skins:FindFirstChild(skin,true))
  for c,k in next, model:GetDescendants() do 
    if k:IsA('Texture') then 
      k:Destroy()
    end 
  end 
  skinData:Apply(model)
  for c,k in next, model:GetDescendants() do 
    if k:IsA('Texture') and k.Parent.Transparency == 1 then 
      k:Destroy() 
    end 
  end 
end 

function skin_swap.set(gun,skin,current)
  weapons[not current and gun or menu.CurrentWeapon].Customization.Skin.Value = skin 
end 

local gunSwap = workspace.ChildAdded:Connect(pcall(function(child)
  if child:FindFirstChild('AnimationController') then 
    local skin = weapons[child.Name].Customization.Skin.Value
    skin_swap.paint,skin_swap,skin,child
  end
end))

function skin_swap.exit()
  gunSwap:Disconnect()
end

return skin_swap

--[[
  If you use this give credit to Require pleaseZ
]]
