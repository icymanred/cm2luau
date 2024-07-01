local uuid = {}
local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
function uuid.gen():string
    math.randomseed(os.clock() * 1000)
    local res = template:gsub('[xy]',function(m) 
        local isx = m == 'x'
        local resu = (isx and math.random(0,16)) or (math.random(0,11))
        return string.format("%X",resu)
        
    
    end)
    return res

end
return uuid