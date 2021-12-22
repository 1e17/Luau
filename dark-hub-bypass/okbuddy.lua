setreadonly(syn,false)
local req = syn.request
syn.request = function(args)
  if args.Url == 'https://darkhub.maxt.church/checkKey' then 
    return {
      Body = 'OK'
    }
  end 
  return req(args)
end 
local isFile = isfile
isFile = hookfunc(isfile,function(str)
  if str:find('DarkHubKey.DARKHUB') then 
    return true 
  end 
  return isFile(str)
end)
local readFile = readfile 
readFile = hookfunc(readfile,function(str)
  if str:find('DarkHubKey.DARKHUB') then 
    return 'cheese'
  end 
  return readFile(str)
end)
