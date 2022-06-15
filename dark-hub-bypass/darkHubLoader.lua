getgenv().DarkHubLoaded = true
local http = game:GetService('HttpService')

local mainDirectory = 'https://raw.githubusercontent.com/RandomAdamYT/DarkHub/master/'
local directory = 'https://raw.githubusercontent.com/1e17/Luau-Misc/main/DarkHubGames/'
local games_ = http:JSONDecode(game:HttpGet(mainDirectory .. 'SupportedGames'))

local games = {}
for c,k in next, games_ do 
    games[k] = c 
end 

local game_ = games[game.PlaceId]
if not game_ then game:GetService('Players').LocalPlayer:Kick('Game not supported') end

loadstring(game:HttpGet(directory .. game_ .. '.lua'))()
