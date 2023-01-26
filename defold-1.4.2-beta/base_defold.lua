---@class vector3
---@field x number
---@field y number
---@field z number

---@class vector4
---@field x number
---@field y number
---@field z number
---@field w number

---@class quaternion
---@field x number
---@field y number
---@field z number
---@field w number

---@alias quat quaternion

---@class url
---@field socket number|string
---@field path string|hash
---@field fragment string|hash

---@class hash : userdata
---@class constant : userdata
---@alias bool boolean
---@alias float number
---@alias object userdata
---@alias matrix4 userdata
---@class node : userdata

---@alias vector vector4

-- luasocket
---@alias master userdata
---@alias unconnected userdata
---@alias client userdata

-- render
---@alias constant_buffer userdata
---@alias render_target userdata
---@alias predicate userdata
