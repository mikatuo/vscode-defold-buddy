---@meta

---Collection proxy API documentation
---@class collectionproxy
collectionproxy = {}

---Docs: https://defold.com/ref/stable/collectionproxy/?q=collectionproxy.get_resources#collectionproxy.get_resources
---
---return an indexed table of resources for a collection proxy. Each
---entry is a hexadecimal string that represents the data of the specific
---resource. This representation corresponds with the filename for each
---individual resource that is exported when you bundle an application with
---LiveUpdate functionality.
---@param collectionproxy url the collectionproxy to check for resources.
---@return table resources the resources
function collectionproxy.get_resources(collectionproxy) end

---Docs: https://defold.com/ref/stable/collectionproxy/?q=collectionproxy.missing_resources#collectionproxy.missing_resources
---
---return an array of missing resources for a collection proxy. Each
---entry is a hexadecimal string that represents the data of the specific
---resource. This representation corresponds with the filename for each
---individual resource that is exported when you bundle an application with
---LiveUpdate functionality. It should be considered good practise to always
---check whether or not there are any missing resources in a collection proxy
---before attempting to load the collection proxy.
---@param collectionproxy url the collectionproxy to check for missing resources.
---@return table resources the missing resources
function collectionproxy.missing_resources(collectionproxy) end

---Post this message to a collection-proxy-component to modify the time-step used when updating the collection controlled by the proxy.
---The time-step is modified by a scaling <code>factor</code> and can be incremented either continuously or in discrete steps.
---The continuous mode can be used for slow-motion or fast-forward effects.
---The discrete mode is only useful when scaling the time-step to pass slower than real time (<code>factor</code> is below 1).
---The time-step will then be set to 0 for as many frames as the scaling demands and then take on the full real-time-step for one frame,
---to simulate pulses. E.g. if <code>factor</code> is set to <code>0.1</code> the time-step would be 0 for 9 frames, then be 1/60 for one
---frame, 0 for 9 frames, and so on. The result in practice is that the game looks like it's updated at a much lower frequency than 60 Hz,
---which can be useful for debugging when each frame needs to be inspected.
---@class set_time_step_msg
---@field factor number time-step scaling factor
---@field mode number time-step mode: 0 for continuous and 1 for discrete

---Post this message to a collection-proxy-component to start the loading of the referenced collection.
---When the loading has completed, the message proxy_loaded will be sent back to the script.
---A loaded collection must be initialized (message init) and enabled (message enable) in order to be simulated and drawn.
---@class load_msg

---Post this message to a collection-proxy-component to start background loading of the referenced collection.
---When the loading has completed, the message proxy_loaded will be sent back to the script.
---A loaded collection must be initialized (message init) and enabled (message enable) in order to be simulated and drawn.
---@class async_load_msg

---This message is sent back to the script that initiated a collection proxy load when the referenced
---collection is loaded. See documentation for load for examples how to use.
---@class proxy_loaded_msg

---Post this message to a collection-proxy-component to initialize the game objects and components in the referenced collection.
---Sending enable to an uninitialized collection proxy automatically initializes it.
---The init message simply provides a higher level of control.
---@class init_msg

---Post this message to a collection-proxy-component to enable the referenced collection, which in turn enables the contained game objects and components.
---If the referenced collection was not initialized prior to this call, it will automatically be initialized.
---@class enable_msg

---Post this message to a collection-proxy-component to disable the referenced collection, which in turn disables the contained game objects and components.
---@class disable_msg

---Post this message to a collection-proxy-component to finalize the referenced collection, which in turn finalizes the contained game objects and components.
---@class final_msg

---Post this message to a collection-proxy-component to start the unloading of the referenced collection.
---When the unloading has completed, the message proxy_unloaded will be sent back to the script.
---@class unload_msg

---This message is sent back to the script that initiated an unload with a collection proxy when
---the referenced collection is unloaded. See documentation for unload for examples how to use.
---@class proxy_unloaded_msg

