local uuid = {}
local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
function uuid.gen():string
    local res = template:gsub('[xy]',function(m) 
        local mf = Random.new()

        local isx = m == 'x'
        local resu = (isx and mf:NextInteger(0, 16)) or (mf:NextInteger(0,11))
        return string.format("%X",resu)
        
    
    end)
    return res

end
return uuid