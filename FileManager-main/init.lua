
--// Constants 
local FileManager = {Extension = '.config'}
local HttpService = game:GetService('HttpService')
local JSONEncode = HttpService.JSONEncode
local JSONDecode = HttpService.JSONDecode

--// Parser 
local function ParseData(File) 
    return JSONDecode(HttpService, readfile(File))
end 

local function ColorArray(Color)
    return {R = Color.R, G = Color.G, B = Color.B}
end

local function ArrayColor(Array) 
    return Color3.new(Array.R, Array.G, Array.B)
end 

--// Functions
function FileManager:Folder(FolderName)

    local FolderObject = {}
    local Folder = isfolder(FolderName) or makefolder(FolderName)

    function FolderObject:GetContent(FileName)
        local Content = ParseData(FolderName..'\\'..FileName..FileManager.Extension)
        local NewContent = {}

        for c,k in next, Content do 

            --// Parse
            if type(k) == 'string' and k:find('return') then 
                NewContent[c] = loadstring(k)()
            elseif k['R'] and k['G'] and k['B'] then 
                NewContent[c] = ArrayColor(k)  
            else 
                NewContent[c] = k
            end

        end 

        return NewContent
    end 

    function FolderObject:SaveContent(FileName, Content) 
        local NewContent = {}

        for c,k in next, Content do 
            local key = typeof(k)

            --// Parse 
            if key == 'EnumItem' then 
                NewContent[c] = 'return '..tostring(k)
            elseif key == 'Color3' then 
                NewContent[c] = ColorArray(k)
            else 
                NewContent[c] = k 
            end 

        end 
        
        writefile(FolderName..'\\'..FileName..FileManager.Extension, JSONEncode(HttpService, NewContent))

    end 

    return FolderObject
end 

return FileManager
