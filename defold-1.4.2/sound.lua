---@meta

---Sound API documentation
---@class sound
sound = {}

---Docs: https://defold.com/ref/stable/sound/?q=sound.is_music_playing#sound.is_music_playing
---
---Checks if background music is playing, e.g. from iTunes.
---On non mobile platforms,
---this function always return <code>false</code>.
---On Android you can only get a correct reading
---of this state if your game is not playing any sounds itself. This is a limitation
---in the Android SDK. If your game is playing any sounds, even with a gain of zero, this
---function will return <code>false</code>.
---The best time to call this function is:
---
---In the <code>init</code> function of your main collection script before any sounds are triggered
---
---In a window listener callback when the window.WINDOW_EVENT_FOCUS_GAINED event is received
---
---Both those times will give you a correct reading of the state even when your application is
---swapped out and in while playing sounds and it works equally well on Android and iOS.
---@return boolean playing <code>true</code> if music is playing, otherwise <code>false</code>.
function sound.is_music_playing() end

---Docs: https://defold.com/ref/stable/sound/?q=sound.get_rms#sound.get_rms
---
---Get RMS (Root Mean Square) value from mixer group. This value is the
---square root of the mean (average) value of the squared function of
---the instantaneous values.
---For instance: for a sinewave signal with a peak gain of -1.94 dB (0.8 linear),
---the RMS is <code>0.8 &times; 1/sqrt(2)</code> which is about 0.566.
---Note the returned value might be an approximation and in particular
---the effective window might be larger than specified.
---@param group string|hash group name
---@param window number window length in seconds
---@return number rms_l RMS value for left channel
---@return number rms_r RMS value for right channel
function sound.get_rms(group, window) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.get_peak#sound.get_peak
---
---Get peak value from mixer group.
---Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula <code>20 * log(gain)</code>.
---Inversely, to find the linear value from a dB value, use the formula
---<code>10db/20</code>.
---Also note that the returned value might be an approximation and in particular
---the effective window might be larger than specified.
---@param group string|hash group name
---@param window number window length in seconds
---@return number peak_l peak value for left channel
---@return number peak_r peak value for right channel
function sound.get_peak(group, window) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.set_group_gain#sound.set_group_gain
---
---Set mixer group gain
---Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula <code>20 * log(gain)</code>.
---Inversely, to find the linear value from a dB value, use the formula
---<code>10db/20</code>.
---@param group string|hash group name
---@param gain number gain in linear scale
function sound.set_group_gain(group, gain) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.get_group_gain#sound.get_group_gain
---
---Get mixer group gain
---Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula <code>20 * log(gain)</code>.
---Inversely, to find the linear value from a dB value, use the formula
---<code>10db/20</code>.
---@param group string|hash group name
---@return number gain gain in linear scale
function sound.get_group_gain(group) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.get_groups#sound.get_groups
---
---Get a table of all mixer group names (hashes).
---@return table groups table of mixer group names
function sound.get_groups() end

---Docs: https://defold.com/ref/stable/sound/?q=sound.get_group_name#sound.get_group_name
---
---Get a mixer group name as a string.
---This function is to be used for debugging and
---development tooling only. The function does a reverse hash lookup, which does not
---return a proper string value when the game is built in release mode.
---@param group string|hash group name
---@return string name group name
function sound.get_group_name(group) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.is_phone_call_active#sound.is_phone_call_active
---
---Checks if a phone call is active. If there is an active phone call all
---other sounds will be muted until the phone call is finished.
---On non mobile platforms,
---this function always return <code>false</code>.
---@return boolean call_active <code>true</code> if there is an active phone call, <code>false</code> otherwise.
function sound.is_phone_call_active() end

---Docs: https://defold.com/ref/stable/sound/?q=sound.play#sound.play
---
---Make the sound component play its sound. Multiple voices are supported. The limit is set to 32 voices per sound component.
---Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula <code>20 * log(gain)</code>.
---Inversely, to find the linear value from a dB value, use the formula
---<code>10db/20</code>.
---A sound will continue to play even if the game object the sound component belonged to is deleted. You can call <code>sound.stop()</code> to stop the sound.
---@param url string|hash|url the sound that should play
---@param play_properties {delay:number, gain:number, pan:number, speed:number}|nil optional table with properties
---@param complete_function fun(self:object, message_id:hash, message:{play_id:number}, sender:url)|nil function to call when the sound has finished playing.
---@overload fun(url: string|hash|url): number
---@overload fun(url: string|hash|url, play_properties: {delay:number, gain:number, pan:number, speed:number}|nil): number
---@return number id The identifier for the sound voice
function sound.play(url, play_properties, complete_function) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.stop#sound.stop
---
---Stop playing all active voices
---@param url string|hash|url the sound that should stop
function sound.stop(url) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.pause#sound.pause
---
---Pause all active voices
---@param url string|hash|url the sound that should pause
---@param pause bool true if the sound should pause
function sound.pause(url, pause) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.set_gain#sound.set_gain
---
---Set gain on all active playing voices of a sound.
---Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula <code>20 * log(gain)</code>.
---Inversely, to find the linear value from a dB value, use the formula
---<code>10db/20</code>.
---@param url string|hash|url the sound to set the gain of
---@param gain number|nil sound gain between 0 and 1. The final gain of the sound will be a combination of this gain, the group gain and the master gain.
---@overload fun(url: string|hash|url)
function sound.set_gain(url, gain) end

---Docs: https://defold.com/ref/stable/sound/?q=sound.set_pan#sound.set_pan
---
---Set panning on all active playing voices of a sound.
---The valid range is from -1.0 to 1.0, representing -45 degrees left, to +45 degrees right.
---@param url string|hash|url the sound to set the panning value to
---@param pan number|nil sound panning between -1.0 and 1.0
---@overload fun(url: string|hash|url)
function sound.set_pan(url, pan) end

---Post this message to a sound-component to make it play its sound. Multiple voices is supported. The limit is set to 32 voices per sound component.
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula <code>20 * log(gain)</code>.
---Inversely, to find the linear value from a dB value, use the formula
---<code>10db/20</code>.
--- A sound will continue to play even if the game object the sound component belonged to is deleted. You can send a <code>stop_sound</code> to stop the sound.
---@class play_sound_msg
---@field delay number|nil delay in seconds before the sound starts playing, default is 0.
---@field gain number|nil sound gain between 0 and 1, default is 1.
---@field play_id number|nil the identifier of the sound, can be used to distinguish between consecutive plays from the same component.

---Post this message to a sound-component to make it stop playing all active voices
---@class stop_sound_msg

---Post this message to a sound-component to set gain on all active playing voices.
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula <code>20 * log(gain)</code>.
---Inversely, to find the linear value from a dB value, use the formula
---<code>10db/20</code>.
---@class set_gain_msg
---@field gain number|nil sound gain between 0 and 1, default is 1.

---This message is sent back to the sender of a <code>play_sound</code> message, if the sound
---could be played to completion.
---@class sound_done_msg
---@field play_id number|nil id number supplied when the message was posted.

