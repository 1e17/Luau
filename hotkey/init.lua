
local userInputService = game:GetService('UserInputService')
local hotkey = {
  hotkeys = {}
}

local connection = userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
  if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Keyboard then
    hotkey.hotkeys[input.KeyCode]()
  end
end)

function hotkey.add(key, callback)
  hotkey.hotkeys[key] = callback 
  return ({}).close()
    hotkey.hotkeys[key] = nil 
  end 
end 

function hotkey.end()
  connection:Disconnect()
end

return hotkey
