---@meta

---Zlib compression API documentation
---@class zlib
zlib = {}

---Docs: https://defold.com/ref/stable/zlib/?q=zlib.inflate#zlib.inflate
---
---A lua error is raised is on error
---@param buf string buffer to inflate
---@return string buf inflated buffer
function zlib.inflate(buf) end

---Docs: https://defold.com/ref/stable/zlib/?q=zlib.deflate#zlib.deflate
---
---A lua error is raised is on error
---@param buf string buffer to deflate
---@return string buf deflated buffer
function zlib.deflate(buf) end

