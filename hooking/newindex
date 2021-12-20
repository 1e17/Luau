
if newindex then return newindex end 

getgenv().newindex = {}
newindex.hooks = {}

local hook 
local function handler(t, i, k)
  local h = newindex.hooks[i]
  if h and t == h.object and tostring(i) == h.key then 
    return hook(t, i, h.value)
  end 
  return hook(t, i, k)
end 

hook = hookmetamethod(game, '__newindex', handler)

local hook_newindex = function(_, t, i, v)
  newindex.hooks[i] = {
    key = i, 
    object = t, 
    value = v,
    close = function()
      newindex.hooks[i] = nil
    end
  }
  return newindex.hooks[i]
end

setmetatable(newindex, {__call = hook_newindex})

return newindex
