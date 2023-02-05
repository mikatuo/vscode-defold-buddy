---@meta

---Factory API documentation
---@class factory
factory = {}

---Docs: https://defold.com/ref/stable/factory/?q=factory.get_status#factory.get_status
---
---This returns status of the factory.
---Calling this function when the factory is not marked as dynamic loading always returns
---factory.STATUS_LOADED.
---@param url string|hash|url|nil the factory component to get status from
---@overload fun(): constant
---@return constant status status of the factory component  <code>factory.STATUS_UNLOADED</code>  <code>factory.STATUS_LOADING</code>  <code>factory.STATUS_LOADED</code> 
function factory.get_status(url) end

---Docs: https://defold.com/ref/stable/factory/?q=factory.unload#factory.unload
---
---This decreases the reference count for each resource loaded with factory.load. If reference is zero, the resource is destroyed.
---Calling this function when the factory is not marked as dynamic loading does nothing.
---@param url string|hash|url|nil the factory component to unload
---@overload fun()
function factory.unload(url) end

---Docs: https://defold.com/ref/stable/factory/?q=factory.load#factory.load
---
---Resources are referenced by the factory component until the existing (parent) collection is destroyed or factory.unload is called.
---Calling this function when the factory is not marked as dynamic loading does nothing.
---@param url string|hash|url|nil the factory component to load
---@param complete_function fun(self:object, url:url, result:boolean)|nil function to call when resources are loaded.
---@overload fun()
---@overload fun(url: string|hash|url|nil)
function factory.load(url, complete_function) end

---Docs: https://defold.com/ref/stable/factory/?q=factory.create#factory.create
---
---The URL identifies which factory should create the game object.
---If the game object is created inside of the frame (e.g. from an update callback), the game object will be created instantly, but none of its component will be updated in the same frame.
---Properties defined in scripts in the created game object can be overridden through the properties-parameter below.
---See go.property for more information on script properties.
---Calling factory.create on a factory that is marked as dynamic without having loaded resources
---using factory.load will synchronously load and create resources which may affect application performance.
---@param url string|hash|url the factory that should create a game object.
---@param position vector3|nil the position of the new game object, the position of the game object calling <code>factory.create()</code> is used by default, or if the value is <code>nil</code>.
---@param rotation quaternion|nil the rotation of the new game object, the rotation of the game object calling <code>factory.create()</code> is used by default, or if the value is <code>nil</code>.
---@param properties table|nil the properties defined in a script attached to the new game object.
---@param scale number|vector3|nil the scale of the new game object (must be greater than 0), the scale of the game object containing the factory is used by default, or if the value is <code>nil</code>
---@overload fun(url: string|hash|url): hash
---@overload fun(url: string|hash|url, position: vector3|nil): hash
---@overload fun(url: string|hash|url, position: vector3|nil, rotation: quaternion|nil): hash
---@overload fun(url: string|hash|url, position: vector3|nil, rotation: quaternion|nil, properties: table|nil): hash
---@return hash id the global id of the spawned game object
function factory.create(url, position, rotation, properties, scale) end

---unloaded
factory.STATUS_UNLOADED = nil

---loading
factory.STATUS_LOADING = nil

---loaded
factory.STATUS_LOADED = nil

