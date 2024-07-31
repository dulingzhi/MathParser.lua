local MAJOR, MINOR = "LibFormula-1.0", 1
local LibFormula, oldminor = LibStub and LibStub:NewLibrary(MAJOR, MINOR) or {}

if not LibFormula then return end -- No Upgrade needed.

local Instance = {}

function LibFormula:CreateInstance()
    return Instance:new()
end

local Parser = require('MathParser')
function Instance:new()
    local o = setmetatable({ __vm = Parser:new() }, { __index = self })
    assert(o.__vm, 'Invalid instance object')
    return o
end

function Instance:addFunc(name, func)
    self.__vm:addFunction(name, func)
end

function Instance:removeFunc(name)
    self.__vm:removeFunction(name)
end

function Instance:exec(ast)
    return self.__vm:evaluate(ast)
end

function Instance:parse(expression)
    return self.__vm:parse(self.__vm:tokenize(expression), expression)
end

function Instance:perform(expression)
    return self.__vm:solve(expression)
end

return LibFormula
