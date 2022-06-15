local http = game:GetService('HttpService')

local directory = 'https://raw.githubusercontent.com/1e17/Luau-Misc/main/DarkHubGames/'
local games_ = http:JSONDecode(game:HttpGet(directory .. 'SupportedGames'))

local games = {}
for c,k in next, games_ do 
    games[k] = c 
end 

local game_ = games[game.PlaceId]
if not game_ then game:GetService('Players').LocalPlayer:Kick('Game not supported') end

loadstring(game:HttpGet(directory .. game_))()
