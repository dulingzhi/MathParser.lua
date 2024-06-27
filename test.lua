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

I:addFunction('player.buff.exists', function (a)
    return true
end)

I:addFunction('spell.cooldown', function (a)
    return 10
end)

print(1, I:solve('toggle(Hello) == World && !player.buff.exists(bbb, true)') == false)

print(2, I:solve('toggle(你好 世界)') == '你好 世界')

print(3, I:solve('print(你好, 世界)') == '你好')

print(4, I:solve('toggle(cd) && (player.buff.exists(死亡之愿) || spell.cooldown(死亡之愿) > 55)'))

local rotation = { --
    -- 被控制
    { '狂暴之怒', 'player.lostcontrol(FEAR)' }, --
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
        print(value[1], I:parse(I:tokenize(value[2]), value[2]))
    end
end
