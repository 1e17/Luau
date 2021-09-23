
local user = {
    registry_bypass = true,
    request_protection = true,
    file_protection = true,
}

--// Old Returns 
local old = {registry = getreg()}

--// Enviornment Variables 
local junk = newcclosure(function()end)
local request = (syn and syn.request or junk)
local getreg = (syn and getreg or junk)
local write = (syn and writefile or junk)

--// Registry Check Bypass
do 
    local reg_hook;reg_hook = hookfunc(getreg,function(...)
        if user.registry_bypass then
            warn('Registry Check')
            return old.registry 
        end 
        return reg_hook(...)
    end)
end 

--// Request Hook
do 
    local req_hook;req_hook = hookfunc(request,function(...)
        if user.request_protection then 
            warn('Attempted Http Request')
            return junk
        end 
        return req_hook(...)
    end)
end 

--// WriteFile Hook 
do 
    local write_hook;write_hook = hookfunc(write,function(...)
        if user.file_protection then 
            warn('Attempted WriteFile')
            return junk
        end 
        return write_hook(...)
    end)
end 

