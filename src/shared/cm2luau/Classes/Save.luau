local block = require(script.Parent.Block)
local connection = require(script.Parent.Connections)
export type Save = {
    blocks:{[string]:block.Block},
    connections: {[string]:{connection.Connection}},
    blockCount:number,
    ConnectionCount:number,
    addBlock:(self:Save,blockid:number,pos:Vector3,state:boolean,properties:{number}?,snapToGrid:boolean) -> block.Block,
    addConnection:(self:Save,source:block.Block,target:block.Block) -> connection.Connection,
    deleteBlock:(self:Save,blockRef:block.Block) -> never,
    DeleteConnection:(self:Save,connectionref:connection.Connection) -> never,
    ExportSave:(self:Save) -> string 




}

local save = {}
save.__index = save
function save:addBlock(blockid:number,pos:Vector3,state:boolean,properties:{number}?,snapToGrid:boolean):block.Block
    local newblock:block.Block
    newblock = block.New(blockid, snapToGrid and  pos:Floor() or pos, state, properties or {})
   self.blocks[newblock.uuid] = newblock
   self.blockCount +=1
   return newblock



end
function save:addConnection(source:block.Block,target:block.Block):connection.Connection
    local newconnection = connection.new(source, target)
    if self.connections[newconnection.Target.uuid] then
        table.insert(self.connections[newconnection.Target.uuid],newconnection)
    else 
        
        self.connections[newconnection.Target.uuid] = {newconnection}
    end
    self.ConnectionCount +=1
    return newconnection
end
function save:deleteBlock(blockRef:block.Block)
    assert(self.blocks[blockRef.uuid],"Block is not in save")
    for i,v:{connection.Connection} in pairs(self.connections) do
        for j,m in ipairs(v) do 
        if m.Source.uuid == blockRef.uuid or m.Target.uuid == blockRef.uuid then 
            self.connections[m.Target.uuid][   table.find(self.connections[m.Target.uuid], m)] = nil
            break
        end
        
        end
        
    end
    self.blocks[blockRef.uuid] = nil
    self.blockCount -= 1


end

function save:DeleteConnection(connectionref:connection.Connection)
    for i,v in pairs(self.connections) do 
        for j,m in pairs(v) do 
            if connectionref == m then
            self.connections[m.Target.uuid][table.find(self.connections[m.Target.uuid],m)::number] = nil
            end
        end

    end
    self.ConnectionCount -= 1


end

function save:ExportSave():string
local str = ""
local blockIndexes = {}
local index = 0
assert(self.blockCount > 0,"You need more then 0 blocks to export")
for i,v in pairs(self.blocks) do
    local propString = table.concat(v.properties,'+')
    str ..= `{v.blockId},{v.state and 1 or 0},{v.x},{v.y},{v.z},{propString};`
    blockIndexes[v.uuid] = index
    index +=1
end
str =  str:sub(1,#str-1) .. '?'
for i,v in pairs(self.connections) do 

    for j,m in pairs(v) do
        str ..= `{blockIndexes[m.Source.uuid]+1},{blockIndexes[m.Target.uuid]+1};`

    end


end
if self.ConnectionCount > 0 then 

    str = str:sub(1,#str-1) 
    

end
str ..= '??'
return str

end

function save.new():Save
    local ns = {
        blocks = {},
        connections = {},
        blockCount = 0,
        ConnectionCount = 0
    } :: Save
    setmetatable(ns, save)
    return ns

end

return save