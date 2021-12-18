
local userInputService = game:GetService('UserInputService')
local hotkey = {
  hotkeys = {}
}

local connection = userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
  if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Keyboard then
    local key = tostring(input.KeyCode):upper():split('Enum.KeyCode.')[2]
    hotkey.hotkeys[key]()
  end
end)

function hotkey.add(key, callback)
  hotkey.hotkeys[key:upper()] = callback 
  return ({}).close()
    hotkey.hotkeys[key] = nil 
  end 
end 

function hotkey.end()
  connection:Disconnect()
end

return hotkey
