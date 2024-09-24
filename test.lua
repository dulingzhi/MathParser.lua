package.path = package.path .. ';src/?.lua;./?/init.lua;'

require('tests/UTF8')

local json = require('tests.dkjson')

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

I:addFunction('player.buff.exists', function(a)
    return true
end)

I:addFunction('spell.cooldown', function(a)
    return 10
end)

I:addFunction('target.interrupt', function(x)
    print('target.interrupt')
    return false
end)

I:addFunction('spell.active', function(n)
    print(n)
    return true
end)

I:addFunction('player.rage.actual', function()
    return 50
end)

I:addFunction('swing.remains', function()
    print('swing.remains')
    return 1
end)

I:addFunction('spell.cooldown', function(n)
    print(n)
    return 0
end)

I:addFunction('target.isboss', function(n)
    return true
end)

I:addFunction('target.debuff.exists', function(n)
    print(n)
    return false
end)

I:addFunction('target.debuff.count', function(n, x)
    print('target.debuff.count')
    return 1
end)

I:addFunction('target.debuff.remains', function(n, k)
    print('target.debuff.remains')
    return 1
end)

local function dump(t, indent)
    print(json.encode(t, { indent = indent }))
end

local function comparetbl(left, right)
    for key, value in pairs(left) do
        if type(value) == "table" then
            return comparetbl(right[key], value)
        elseif right[key] ~= value then
            return false
        end
    end
    return true
end

local function call(i, exp, result)
    print(i, '=======================================')
    local node = I:parse(I:tokenize(exp), exp)
    dump(node, false)
    if result then
        local j = json.decode(result)
        if j then
            assert(comparetbl(node, json.decode(result)), 'Invalid parse')
        end
    end
    -- print(i, I:evaluate(node))
end

local rotation = { --
    -- 被控制
    { '狂暴之怒', 'player.lostcontrol(FEAR)', '{"Arguments":[{"Value":"FEAR","TYPE":"Variable","Position":23}],"TYPE":"FunctionCall","FunctionName":"player.lostcontrol"}' }, --
    --
    { '/startattack', '!spell.active(攻击)' }, --
    -- interrupt
    { '拳击', 'toggle(interrupts) && target.interrupt' }, --
    -- buff
    { '命令怒吼', 'toggle(战吼) == 命令怒吼 && !player.buff.exists(命令怒吼, true)' }, --
    { '战斗怒吼', 'toggle(战吼) == 战斗怒吼 && !player.buff.exists(战斗怒吼, true)' }, --
    -- CD
    { '鲁莽', 'toggle(cd) && player.buff.exists(死亡之愿)' }, --
    { '狂暴', 'toggle(cd) && player.buff.exists(鲁莽)' }, --
    { '速度药水', 'toggle(cd) && toggle(速度药水) && player.buff.exists(死亡之愿)' }, --
    { '手套', 'toggle(cd) && (player.buff.exists(死亡之愿) || spell.cooldown(死亡之愿) > 55)' }, --
    { '死亡之愿', 'toggle(cd)' }, --
    { '缴械' }, --
    { '血性狂暴', 'player.rage.actual <= 20' }, --
    { '破甲攻击',
        'toggle(破甲) && target.isboss && !target.debuff.exists(破甲) && (target.debuff.count(破甲攻击, true) < 5 || target.debuff.remains(破甲攻击, true) < 3)' }, --
    -- AOE
    { '顺劈斩', 'toggle(aoe) && toggle(顺劈斩) && !spell.active(顺劈斩) && player.rage.actual >= 12 && enemies.count(5) > 1' }, --
    { '英勇打击', '!spell.active(英勇打击) && !spell.active(顺劈斩) && player.rage.actual >= 12' }, --
    -- DPS
    { '乘胜追击' }, --
    { '旋风斩', 'toggle(aoe) && enemies.count(5) > 1' }, --
    { '嗜血' }, --
    { '旋风斩', 'toggle(aoe)' }, --
    { '碎裂投掷', 'toggle(cd) && battle.duration >= 6' }, --
    { '猛击', 'player.buff.exists(猛击！)' }, --
    { '斩杀' }, --
    { '英勇投掷', 'swing.remains >= 1 && spell.cooldown(嗜血) >= 1 && spell.cooldown(旋风斩) >= 1.5' }, --
    { '萨隆邪铁炸弹', 'toggle(炸弹) && target.isboss && enemies.count(5) > 0', 'player' } --
}

for index, value in ipairs(rotation) do
    if value[2] then
        call(value[1], value[2], value[3])
    end
end

local t = os.clock()
for i = 1, 10000, 1 do
    I:solve('1+2+3')
end
print('cost = ', os.clock() - t)
