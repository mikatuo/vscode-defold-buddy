---@meta

---HTTP API documentation
---@class http
http = {}

---Docs: https://defold.com/ref/stable/http/?q=http.request#http.request
---
---Perform a HTTP/HTTPS request.
---If no timeout value is passed, the configuration value "network.http_timeout" is used. If that is not set, the timeout value is <code>0</code> (which blocks indefinitely).
---@param url string target url
---@param method string HTTP/HTTPS method, e.g. "GET", "PUT", "POST" etc.
---@param callback fun(self:object, id:hash, response:{status:number, response:string, headers:table, path:string, error:string}) response callback function
---@param headers table|nil optional table with custom headers
---@param post_data string|nil optional data to send
---@param options {timeout:number, path:string, ignore_cache:boolean, chunked_transfer:boolean}|nil optional table with request parameters. Supported entries
---@overload fun(url: string, method: string, callback: fun(self:object, id:hash, response:{status:number, response:string, headers:table, path:string, error:string}))
---@overload fun(url: string, method: string, callback: fun(self:object, id:hash, response:{status:number, response:string, headers:table, path:string, error:string}), headers: table|nil)
---@overload fun(url: string, method: string, callback: fun(self:object, id:hash, response:{status:number, response:string, headers:table, path:string, error:string}), headers: table|nil, post_data: string|nil)
function http.request(url, method, callback, headers, post_data, options) end

