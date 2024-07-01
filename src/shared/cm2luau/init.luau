local classDir = script.Parent.cm2luau.Classes
local save = require(classDir.Save)
local block = require(classDir.Block)
local connection = require(classDir.Connections)
local blockdef = require(classDir.Parent.blockdefs)
local cm2luau = {
    ["save"] = save,
    ["block"] = block,
    ["connection"] = connection,
    ["blockdef"] = blockdef

}


return cm2luau
