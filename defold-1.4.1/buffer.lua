---@meta

---Buffer API documentation
---@class buffer
buffer = {}

---Docs: https://defold.com/ref/stable/buffer/?q=buffer.create#buffer.create
---
---Create a new data buffer containing a specified set of streams. A data buffer
---can contain one or more streams with typed data. This is useful for managing
---compound data, for instance a vertex buffer could contain separate streams for
---vertex position, color, normal etc.
---@param element_count number The number of elements the buffer should hold
---@param declaration {name:hash | string, type:constant, count:number} A table where each entry (table) describes a stream
---@return buffer buffer the new buffer
function buffer.create(element_count, declaration) end

---Docs: https://defold.com/ref/stable/buffer/?q=buffer.get_stream#buffer.get_stream
---
---Get a specified stream from a buffer.
---@param buffer buffer the buffer to get the stream from
---@param stream_name hash|string the stream name
---@return bufferstream stream the data stream
function buffer.get_stream(buffer, stream_name) end

---Docs: https://defold.com/ref/stable/buffer/?q=buffer.copy_stream#buffer.copy_stream
---
---Copy a specified amount of data from one stream to another.
---The value type and size must match between source and destination streams.
---The source and destination streams can be the same.
---@param dst bufferstream the destination stream
---@param dstoffset number the offset to start copying data to (measured in value type)
---@param src bufferstream the source data stream
---@param srcoffset number the offset to start copying data from (measured in value type)
---@param count number the number of values to copy (measured in value type)
function buffer.copy_stream(dst, dstoffset, src, srcoffset, count) end

---Docs: https://defold.com/ref/stable/buffer/?q=buffer.copy_buffer#buffer.copy_buffer
---
---Copy all data streams from one buffer to another, element wise.
---Each of the source streams must have a matching stream in the
---destination buffer. The streams must match in both type and size.
---The source and destination buffer can be the same.
---@param dst buffer the destination buffer
---@param dstoffset number the offset to start copying data to
---@param src buffer the source data buffer
---@param srcoffset number the offset to start copying data from
---@param count number the number of elements to copy
function buffer.copy_buffer(dst, dstoffset, src, srcoffset, count) end

---Docs: https://defold.com/ref/stable/buffer/?q=buffer.get_bytes#buffer.get_bytes
---
---Get a copy of all the bytes from a specified stream as a Lua string.
---@param buffer buffer the source buffer
---@param stream_name hash the name of the stream
---@return string data the buffer data as a Lua string
function buffer.get_bytes(buffer, stream_name) end

---Unsigned integer, 1 byte
buffer.VALUE_TYPE_UINT8 = nil

---Unsigned integer, 2 bytes
buffer.VALUE_TYPE_UINT16 = nil

---Unsigned integer, 4 bytes
buffer.VALUE_TYPE_UINT32 = nil

---Unsigned integer, 8 bytes
buffer.VALUE_TYPE_UINT64 = nil

---Signed integer, 1 byte
buffer.VALUE_TYPE_INT8 = nil

---Signed integer, 2 bytes
buffer.VALUE_TYPE_INT16 = nil

---Signed integer, 4 bytes
buffer.VALUE_TYPE_INT32 = nil

---Signed integer, 8 bytes
buffer.VALUE_TYPE_INT64 = nil

---Float, single precision, 4 bytes
buffer.VALUE_TYPE_FLOAT32 = nil

