---@meta

---Window API documentation
---@class window
window = {}

---Docs: https://defold.com/ref/stable/window/?q=window.set_listener#window.set_listener
---
---Sets a window event listener.
---@param callback fun(self:object, event:constant, data:{width:number, height:number}) A callback which receives info about window events. Pass an empty function or nil if you no longer wish to receive callbacks.
function window.set_listener(callback) end

---Docs: https://defold.com/ref/stable/window/?q=window.set_mouse_lock#window.set_mouse_lock
---
---Set the locking state for current mouse cursor on a PC platform.
---This function locks or unlocks the mouse cursor to the center point of the window. While the cursor is locked,
---mouse position updates will still be sent to the scripts as usual.
---@param flag boolean The lock state for the mouse cursor
function window.set_mouse_lock(flag) end

---Docs: https://defold.com/ref/stable/window/?q=window.set_dim_mode#window.set_dim_mode
---
---Sets the dimming mode on a mobile device.
---The dimming mode specifies whether or not a mobile device should dim the screen after a period without user interaction. The dimming mode will only affect the mobile device while the game is in focus on the device, but not when the game is running in the background.
---This function has no effect on platforms that does not support dimming.
---@param mode constant The mode for screen dimming  <code>window.DIMMING_ON</code>  <code>window.DIMMING_OFF</code> 
function window.set_dim_mode(mode) end

---Docs: https://defold.com/ref/stable/window/?q=window.get_dim_mode#window.get_dim_mode
---
---Returns the current dimming mode set on a mobile device.
---The dimming mode specifies whether or not a mobile device should dim the screen after a period without user interaction.
---On platforms that does not support dimming, <code>window.DIMMING_UNKNOWN</code> is always returned.
---@return constant mode The mode for screen dimming  <code>window.DIMMING_UNKNOWN</code>  <code>window.DIMMING_ON</code>  <code>window.DIMMING_OFF</code> 
function window.get_dim_mode() end

---Docs: https://defold.com/ref/stable/window/?q=window.get_size#window.get_size
---
---This returns the current window size (width and height).
---@return number width The window width
---@return number height The window height
function window.get_size() end

---Docs: https://defold.com/ref/stable/window/?q=window.get_mouse_lock#window.get_mouse_lock
---
---This returns the current lock state of the mouse cursor
---@return boolean state The lock state
function window.get_mouse_lock() end

---This event is sent to a window event listener when the game window or app screen has lost focus.
window.WINDOW_EVENT_FOCUS_LOST = nil

---This event is sent to a window event listener when the game window or app screen has
---gained focus.
---This event is also sent at game startup and the engine gives focus to the game.
window.WINDOW_EVENT_FOCUS_GAINED = nil

---This event is sent to a window event listener when the game window or app screen is resized.
---The new size is passed along in the data field to the event listener.
window.WINDOW_EVENT_RESIZED = nil

---<span class="icon-osx"></span> <span class="icon-windows"></span> <span class="icon-linux"></span> This event is sent to a window event listener when the game window or app screen is
---iconified (reduced to an application icon in a toolbar, application tray or similar).
window.WINDOW_EVENT_ICONFIED = nil

---<span class="icon-osx"></span> <span class="icon-windows"></span> <span class="icon-linux"></span> This event is sent to a window event listener when the game window or app screen is
---restored after being iconified.
window.WINDOW_EVENT_DEICONIFIED = nil

---Dimming mode is used to control whether or not a mobile device should dim the screen after a period without user interaction.
window.DIMMING_ON = nil

---Dimming mode is used to control whether or not a mobile device should dim the screen after a period without user interaction.
window.DIMMING_OFF = nil

---Dimming mode is used to control whether or not a mobile device should dim the screen after a period without user interaction.
---This mode indicates that the dim mode can't be determined, or that the platform doesn't support dimming.
window.DIMMING_UNKNOWN = nil

