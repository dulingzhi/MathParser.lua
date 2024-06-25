require('tests.UTF8')

local M = require('LibFormula')

local I = M:CreateInstance()

local ss = '测试'

-- print(string.utf8sub(ss, 1, 1))
-- print(string.utf8sub(ss, 2, 2))

-- print(ss)
I:addFunc('print', function(...)
    print('PRINT', ...)
    return ...
end)

print(ss == I:perform('print(测试)'))
