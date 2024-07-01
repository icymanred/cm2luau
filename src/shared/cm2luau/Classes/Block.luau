local uuid = require(script.Parent.Parent.Parent.utils.uuid4)
local block = {}
export type Block = {
    blockId:number,
    pos:Vector3,
    x:number,
    y:number,
    z:number,
    state:boolean,
    properties:{number},
    uuid:string


}

function block.New(blockId:number,pos:Vector3,state:boolean,properties:{number}):Block
    assert(typeof(blockId) == "number","Expected type of number, got " .. typeof(blockId))
    assert(typeof(pos) == "Vector3", "Expected type of Vector3, got ".. typeof(pos))
    assert(typeof(state) == "boolean", "Expected type of boolean, got " .. typeof(state))
    assert(typeof(properties) == "table", "Expected type of table, got " .. typeof(properties))
    local fakeSel = newproxy(true) :: Block
    local sel:Block = {
        ["blockId"]= blockId,
        ["pos"] = pos,
        ["x"] = pos.X,
        ["y"] = pos.Y,
        ["z"] = pos.Z,
        ["state"] = state,
        ["properties"] = properties,
        ["uuid"] = uuid.gen()
    }
    local mt = getmetatable(fakeSel)

    mt["__index"] = sel 
    mt["__newindex"] = function(tab,ind,val)
        if ind == "pos" then
            assert(typeof(val) == "Vector3","Expected type of Vector 3, got ".. typeof(val) )
            rawset( mt.__index, ind, val)
            rawset(mt.__index, "x", val.X)
            rawset(mt.__index, "y", val.Y)
            rawset(mt.__index, "z", val.Z)
        elseif ind == "x" or ind == "y" or ind == "z" or ind== "uuid" then -- readonlys
           error("You cannot modify a readonly value") 
            

        else 
            assert(typeof(val) == typeof(mt.__index[ind]), "Expected type of " .. typeof(mt.__index[ind]) .. " got " .. typeof(val))
            rawset(mt.__index, ind, val)


        end

            


    end
    mt["__tostring"] = function(tab)
        local form = [[
        
        BlockId = %i
        Position = %s
        State = %s
        Properties =  %s
        UUID = %s
        ]]
        local pt = "{"
        for i,v in ipairs(sel.properties) do
            if i ~= #sel.properties then
                pt = pt.. tostring(v) .. ","
            else 

                pt = pt.. tostring(v) .. "}"
            end
        end 
        return string.format(form,sel.blockId,tostring(sel.pos),tostring(sel.state),pt,sel.uuid)


    end
        
    return fakeSel


    end



    
    
    
    
    
    
return block

    