setreadonly(syn,false)
local synreq = syn.request 
syn.request = function(args)
    local url = args.Url
    local response = {
        Body = 'okman69420xdlollmfao',
        Headers = {
            ['Content-Type'] = 'text/html; charset=UTF-8'
        }
    }
    if url == 'https://solarishub.dev/keysystem/HWID.php' then 
        return response
    end 
    if url == 'https://solarishub.dev/keysystem/Start_raw.php' then 
        return response
    end 
    if url:find('https://solarishub.dev/keysystem/Verify.php') then 
        return response
    end 
    return synreq(args)
end

