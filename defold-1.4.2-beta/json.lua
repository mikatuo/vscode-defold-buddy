---@meta

---JSON API documentation
---@class json
json = {}

---Docs: https://defold.com/ref/stable/json/?q=json.decode#json.decode
---
---Decode a string of JSON data into a Lua table.
---A Lua error is raised for syntax errors.
---@param json string json data
---@return table data decoded json
function json.decode(json) end

---Docs: https://defold.com/ref/stable/json/?q=json.encode#json.encode
---
---Encode a lua table to a JSON string.
---A Lua error is raised for syntax errors.
---@param tbl table lua table to encode
---@return string json encoded json
function json.encode(tbl) end

---Represents the null primitive from a json file
json.null = nil

