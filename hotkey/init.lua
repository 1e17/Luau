
local userInputService = game:GetService('UserInputService')
local hotkey = {
  hotkeys = {}
}

local connection = userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
  if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Keyboard then
    local key = tostring(input.KeyCode):split('Enum.KeyCode.')[2]:upper()
    if hotkey.hotkeys[key] then
      hotkey.hotkeys[key]()
    end
  end
end)

function hotkey.add(key, callback)
  local class =  {key = key:upper()}
  hotkey.hotkeys[class.key] = callback 
  function class.close()
    hotkey.hotkeys[class.key] = nil
  end
  function class.switch(newKey)
    local oldFunc = hotkey.hotkeys[key:upper()] 
    hotkey.hotkeys[key:upper()] = nil
    hotkey.hotkeys[newKey:upper()] = oldFunc
    class.key = newKey:upper()
  end 
  function class.set(callback)
    hotkey.hotkeys[class.key] = callback
  end
  return class 
end 

function hotkey.exit()
  connection:Disconnect()
end

return hotkey
