---@meta

---Messaging API documentation
---@class msg
msg = {}

---Docs: https://defold.com/ref/stable/msg/?q=msg.url#msg.url
---
---creates a new URL from separate arguments
---@param socket string|hash|nil socket of the URL
---@param path string|hash|nil path of the URL
---@param fragment string|hash|nil fragment of the URL
---@overload fun(): url
---@overload fun(socket: string|hash|nil): url
---@overload fun(urlstring: string): url
---@overload fun(socket: string|hash|nil, path: string|hash|nil): url
---@return url url a new URL
function msg.url(socket, path, fragment) end

---Docs: https://defold.com/ref/stable/msg/?q=msg.post#msg.post
---
---Post a message to a receiving URL. The most common case is to send messages
---to a component. If the component part of the receiver is omitted, the message
---is broadcast to all components in the game object.
---The following receiver shorthands are available:
---
---<code>"."</code> the current game object
---
---<code>"#"</code> the current component
---
---There is a 2 kilobyte limit to the message parameter table size.
---@param receiver string|url|hash The receiver must be a string in URL-format, a URL object or a hashed string.
---@param message_id string|hash The id must be a string or a hashed string.
---@param message table|nil a lua table with message parameters to send.
---@overload fun(receiver: string|url|hash, message_id: string|hash)
function msg.post(receiver, message_id, message) end

