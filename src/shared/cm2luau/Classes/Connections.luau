local block = require(script.Parent.Block)
local connection = {}
export type Connection = {
    Source:block.Block,
    Target:block.Block

}


function connection.new(source,target)
    assert(typeof(source) == "userdata" and typeof(target) == "userdata", "Only two blocks can be connected")
    local sel:Connection = {
        ["Source"] = source,
        ["Target"] = target
    }
    return sel

end
return connection