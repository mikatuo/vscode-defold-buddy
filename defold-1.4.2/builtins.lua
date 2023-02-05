---@meta

---Built-ins API documentation
---@class builtins
builtins = {}

---Docs: https://defold.com/ref/stable/builtins/?q=pprint#pprint
---
---Pretty printing of Lua values. This function prints Lua values
---in a manner similar to +print()+, but will also recurse into tables
---and pretty print them. There is a limit to how deep the function
---will recurse.
---@param v any value to print
function pprint(v) end

---Docs: https://defold.com/ref/stable/builtins/?q=hash#hash
---
---All ids in the engine are represented as hashes, so a string needs to be hashed
---before it can be compared with an id.
---@param s string string to hash
---@return hash hash a hashed string
function hash(s) end

---Docs: https://defold.com/ref/stable/builtins/?q=hash_to_hex#hash_to_hex
---
---Returns a hexadecimal representation of a hash value.
---The returned string is always padded with leading zeros.
---@param h hash hash value to get hex string for
---@return string hex hex representation of the hash
function hash_to_hex(h) end

