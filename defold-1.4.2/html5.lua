---@meta

---HTML5 API documentation
---@class html5
html5 = {}

---Docs: https://defold.com/ref/stable/html5/?q=html5.run#html5.run
---
---Executes the supplied string as JavaScript inside the browser.
---A call to this function is blocking, the result is returned as-is, as a string.
---(Internally this will execute the string using the <code>eval()</code> JavaScript function.)
---@param code string Javascript code to run
---@return string result result as string
function html5.run(code) end

---Docs: https://defold.com/ref/stable/html5/?q=html5.set_interaction_listener#html5.set_interaction_listener
---
---Set a JavaScript interaction listener callaback from lua that will be
---invoked when a user interacts with the web page by clicking, touching or typing.
---The callback can then call DOM restricted actions like requesting a pointer lock,
---or start playing sounds the first time the callback is invoked.
---@param callback fun(self:object) The interaction callback. Pass an empty function or nil if you no longer wish to receive callbacks.
function html5.set_interaction_listener(callback) end

