
package.path = package.path .. ';src/?.lua'

require('tests.UTF8')

local M = require('src.MathParser')
local I = M:new()

-- print(ss)
I:addFunction('print', function(...)
    print('PRINT', ...)
    return ...
end)

I:addFunction('toggle', function(n)
    return n
end)

I:addFunction('player.buff.exists', function(a, b)
    return false
end)

print(1, I:solve('toggle(Hello) == World && !player.buff.exists(bbb, true)') == false)

print(2, I:solve('toggle(你好 世界)') == '你好 世界')

print(3,  I:solve('print(你好, 世界)') == '你好')
