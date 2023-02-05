---@meta

---Timer API documentation
---@class timer
timer = {}

---Docs: https://defold.com/ref/stable/timer/?q=timer.delay#timer.delay
---
---Adds a timer and returns a unique handle
---You may create more timers from inside a timer callback.
---Using a delay of 0 will result in a timer that triggers at the next frame just before
---script update functions.
---If you want a timer that triggers on each frame, set delay to 0.0f and repeat to true.
---Timers created within a script will automatically die when the script is deleted.
---@param delay number time interval in seconds
---@param repeat boolean true = repeat timer until cancel, false = one-shot timer
---@param callback fun(self:object, handle:number, time_elapsed:number) timer callback function
---@return hash  handle identifier for the create timer, returns timer.INVALID_TIMER_HANDLE if the timer can not be created
function timer.delay(delay, repeat, callback) end

---Docs: https://defold.com/ref/stable/timer/?q=timer.cancel#timer.cancel
---
---You may cancel a timer from inside a timer callback.
---Cancelling a timer that is already executed or cancelled is safe.
---@param handle hash the timer handle returned by timer.delay()
---@return boolean true if the timer was active, false if the timer is already cancelled / complete
function timer.cancel(handle) end

---Docs: https://defold.com/ref/stable/timer/?q=timer.trigger#timer.trigger
---
---Manual triggering a callback for a timer.
---@param handle hash the timer handle returned by timer.delay()
---@return boolean true if the timer was active, false if the timer is already cancelled / complete
function timer.trigger(handle) end

---Indicates an invalid timer handle
timer.INVALID_TIMER_HANDLE = nil

