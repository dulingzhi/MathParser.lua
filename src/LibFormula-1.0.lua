local MAJOR, MINOR = "LibFormula-1.0", 1
local LibFormula, oldminor = LibStub and LibStub:NewLibrary(MAJOR, MINOR) or {}

if not LibFormula then return end -- No Upgrade needed.

local Instance = {}

function LibFormula:CreateInstance()
    return Instance:new()
end

local Parser = require('MathParser')
function Instance:new()
    return setmetatable({ __vm = Parser:new() }, { __index = self })
end

function Instance:addFunc(name, func)
    assert(self.__vm, 'Invalid instance object')
    self.__vm:addFunction(name, func)
end

function Instance:exec(expression)
    assert(self.__vm, 'Invalid instance object')
    return self.__vm:solve(expression)
end

return LibFormula
