---@meta

---Image API documentation
---@class image
image = {}

---Docs: https://defold.com/ref/stable/image/?q=image.load#image.load
---
---Load image (PNG or JPEG) from buffer.
---@param buffer string image data buffer
---@param premult boolean|nil optional flag if alpha should be premultiplied. Defaults to <code>false</code>
---@overload fun(buffer: string): table
---@return table image object or <code>nil</code> if loading fails. The object is a table with the following fields:  number <code>width</code>: image width  number <code>height</code>: image height  constant <code>type</code>: image type <code>image.TYPE_RGB</code>  <code>image.TYPE_RGBA</code>  <code>image.TYPE_LUMINANCE</code>    string <code>buffer</code>: the raw image data 
function image.load(buffer, premult) end

---RGB image type
image.TYPE_RGB = nil

---RGBA image type
image.TYPE_RGBA = nil

---luminance image type
image.TYPE_LUMINANCE = nil

