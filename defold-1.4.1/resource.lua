---@meta

---Resource API documentation
---@class resource
resource = {}

---Docs: https://defold.com/ref/stable/resource/?q=resource.material#resource.material
---
---Constructor-like function with two purposes:
---
---Load the specified resource as part of loading the script
---
---Return a hash to the run-time version of the resource
---
---This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@overload fun(): hash
---@return hash path a path hash to the binary version of the resource
function resource.material(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.font#resource.font
---
---Constructor-like function with two purposes:
---
---Load the specified resource as part of loading the script
---
---Return a hash to the run-time version of the resource
---
---This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@overload fun(): hash
---@return hash path a path hash to the binary version of the resource
function resource.font(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.texture#resource.texture
---
---Constructor-like function with two purposes:
---
---Load the specified resource as part of loading the script
---
---Return a hash to the run-time version of the resource
---
---This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@overload fun(): hash
---@return hash path a path hash to the binary version of the resource
function resource.texture(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.atlas#resource.atlas
---
---Constructor-like function with two purposes:
---
---Load the specified resource as part of loading the script
---
---Return a hash to the run-time version of the resource
---
---This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@overload fun(): hash
---@return hash path a path hash to the binary version of the resource
function resource.atlas(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.buffer#resource.buffer
---
---Constructor-like function with two purposes:
---
---Load the specified resource as part of loading the script
---
---Return a hash to the run-time version of the resource
---
---This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@overload fun(): hash
---@return hash path a path hash to the binary version of the resource
function resource.buffer(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.tile_source#resource.tile_source
---
---Constructor-like function with two purposes:
---
---Load the specified resource as part of loading the script
---
---Return a hash to the run-time version of the resource
---
---This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@overload fun(): hash
---@return hash path a path hash to the binary version of the resource
function resource.tile_source(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.set#resource.set
---
---Sets the resource data for a specific resource
---@param path string|hash The path to the resource
---@param buffer buffer The buffer of precreated data, suitable for the intended resource type
function resource.set(path, buffer) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.load#resource.load
---
---Loads the resource data for a specific resource.
---@param path string The path to the resource
---@return buffer buffer Returns the buffer stored on disc
function resource.load(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.create_texture#resource.create_texture
---
---Creates a new texture resource.
---@param path string The path to the resource.
---@param table {type:number, width:number, height:number, format:number, max_mipmaps:number} A table containing info about how to create the texture. Supported entries
---@return hash path The path to the resource.
function resource.create_texture(path, table) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.release#resource.release
---
---Release a resource.
---@param path hash|string The path to the resource.
function resource.release(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.set_texture#resource.set_texture
---
---Sets the pixel data for a specific texture.
---@param path hash|string The path to the resource
---@param table {type:number, width:number, height:number, format:number, x:number, y:number, mipmap:number} A table containing info about the texture. Supported entries
---@param buffer buffer The buffer of precreated pixel data  To update a cube map texture you need to pass in six times the amount of data via the buffer, since a cube map has six sides!
function resource.set_texture(path, table, buffer) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.set_sound#resource.set_sound
---
---Update internal sound resource (wavc/oggc) with new data
---@param path hash|string The path to the resource
---@param buffer string A lua string containing the binary sound data
function resource.set_sound(path, buffer) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.get_buffer#resource.get_buffer
---
---gets the buffer from a resource
---@param path hash|string The path to the resource
---@return buffer buffer The resource buffer
function resource.get_buffer(path) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.set_buffer#resource.set_buffer
---
---sets the buffer of a resource
---@param path hash|string The path to the resource
---@param buffer buffer The resource buffer
function resource.set_buffer(path, buffer) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.get_text_metrics#resource.get_text_metrics
---
---Gets the text metrics from a font
---@param url hash the font to get the (unscaled) metrics from
---@param text string text to measure
---@param options {width:integer, leading:number, tracking:number, line_break:boolean}|nil A table containing parameters for the text. Supported entries
---@overload fun(url: hash, text: string): table
---@return table metrics a table with the following fields:  width  height  max_ascent  max_descent 
function resource.get_text_metrics(url, text, options) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.get_current_manifest#resource.get_current_manifest
---
---Return a reference to the Manifest that is currently loaded.
---@return number manifest_reference reference to the Manifest that is currently loaded
function resource.get_current_manifest() end

---Docs: https://defold.com/ref/stable/resource/?q=resource.store_resource#resource.store_resource
---
---add a resource to the data archive and runtime index. The resource will be verified
---internally before being added to the data archive.
---@param manifest_reference number The manifest to check against.
---@param data string The resource data that should be stored.
---@param hexdigest string The expected hash for the resource, retrieved through collectionproxy.missing_resources.
---@param callback fun(self:object, hexdigest:string, status:boolean) The callback
function resource.store_resource(manifest_reference, data, hexdigest, callback) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.store_manifest#resource.store_manifest
---
---Create a new manifest from a buffer. The created manifest is verified
---by ensuring that the manifest was signed using the bundled public/private
---key-pair during the bundle process and that the manifest supports the current
---running engine version. Once the manifest is verified it is stored on device.
---The next time the engine starts (or is rebooted) it will look for the stored
---manifest before loading resources. Storing a new manifest allows the
---developer to update the game, modify existing resources, or add new
---resources to the game through LiveUpdate.
---@param manifest_buffer string the binary data that represents the manifest
---@param callback fun(self:object, status:constant) the callback function
function resource.store_manifest(manifest_buffer, callback) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.store_archive#resource.store_archive
---
---Stores a zip file and uses it for live update content. The contents of the
---zip file will be verified against the manifest to ensure file integrity.
---It is possible to opt out of the resource verification using an option passed
---to this function.
---The path is stored in the (internal) live update location.
---@param path string the path to the original file on disc
---@param callback fun(self:object, status:constant) the callback function
---@param options {verify:boolean}|nil optional table with extra parameters. Supported entries
---@overload fun(path: string, callback: fun(self:object, status:constant))
function resource.store_archive(path, callback, options) end

---Docs: https://defold.com/ref/stable/resource/?q=resource.is_using_liveupdate_data#resource.is_using_liveupdate_data
---
---Is any liveupdate data mounted and currently in use?
---This can be used to determine if a new manifest or zip file should be downloaded.
---@return bool bool true if a liveupdate archive (any format) has been loaded
function resource.is_using_liveupdate_data() end

---2D texture type
resource.TEXTURE_TYPE_2D = nil

---Cube map texture type
resource.TEXTURE_TYPE_CUBE_MAP = nil

---luminance type texture format
resource.TEXTURE_FORMAT_LUMINANCE = nil

---RGB type texture format
resource.TEXTURE_FORMAT_RGB = nil

---RGBA type texture format
resource.TEXTURE_FORMAT_RGBA = nil

---LIVEUPDATE_OK
resource.LIVEUPDATE_OK = nil

---The handled resource is invalid.
resource.LIVEUPDATE_INVALID_RESOURCE = nil

---Mismatch between manifest expected version and actual version.
resource.LIVEUPDATE_VERSION_MISMATCH = nil

---Mismatch between running engine version and engine versions supported by manifest.
resource.LIVEUPDATE_ENGINE_VERSION_MISMATCH = nil

---Mismatch between manifest expected signature and actual signature.
resource.LIVEUPDATE_SIGNATURE_MISMATCH = nil

---Mismatch between scheme used to load resources. Resources are loaded with a different scheme than from manifest, for example over HTTP or directly from file. This is typically the case when running the game directly from the editor instead of from a bundle.
resource.LIVEUPDATE_SCHEME_MISMATCH = nil

---Mismatch between between expected bundled resources and actual bundled resources. The manifest expects a resource to be in the bundle, but it was not found in the bundle. This is typically the case when a non-excluded resource was modified between publishing the bundle and publishing the manifest.
resource.LIVEUPDATE_BUNDLED_RESOURCE_MISMATCH = nil

---Failed to parse manifest data buffer. The manifest was probably produced by a different engine version.
resource.LIVEUPDATE_FORMAT_ERROR = nil

