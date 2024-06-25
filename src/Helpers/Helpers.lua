--[[
  Name: Helpers.lua
  Author: ByteXenon [Luna Gilbert]
  Date: 2024-06-21
--]]

--* Imports *--
local char   = string.char
local match  = string.match
local gmatch = string.gmatch
local insert = table.insert
local strlen = string.utf8len or string.len
local strsub = string.utf8sub or string.sub

--* Helpers *--
local Helpers = {}

--- Converts the given string to a table of its characters.
-- @param <String> string The string to convert.
-- @return <Table> table The table of characters.
function Helpers.stringToTable(string)
  local table = {}
  for i=1, strlen(string) do
    local char = strsub(string, i, i)
    insert(table, char)
  end
  return table
end

--- Converts a pattern to a character lookup table.
-- @param <String> pattern The pattern to convert.
-- @return <Table> table The table of characters.
function Helpers.createPatternLookupTable(pattern)
  local lookupTable = {}
  for i = 0, 255 do
    local character = char(i)
    if match(character, pattern) then
      lookupTable[character] = true
    end
  end
  return lookupTable
end

--- Creates a trie from the given operators, it's used to support 2+ character (potentional) operators.
-- @param <Table> table The operators to create the trie from.
-- @return <Table> trieTable The trie table.
function Helpers.makeTrie(table)
  local trieTable = {}
  for _, op in ipairs(table) do
    local node = trieTable
    for character in gmatch(op, ".") do
      node[character] = node[character] or {}
      node = node[character]
    end
    node.value = op
  end

  return trieTable
end

return Helpers