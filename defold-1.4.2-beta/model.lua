---@meta

---Model API documentation
---@class model
model = {}

---Docs: https://defold.com/ref/stable/model/?q=model.play_anim#model.play_anim
---
---Plays an animation on a model component with specified playback
---mode and parameters.
---An optional completion callback function can be provided that will be called when
---the animation has completed playing. If no function is provided,
---a model_animation_done message is sent to the script that started the animation.
---The callback is not called (or message sent) if the animation is
---cancelled with model.cancel. The callback is called (or message sent) only for
---animations that play with the following playback modes:
---
---<code>go.PLAYBACK_ONCE_FORWARD</code>
---
---<code>go.PLAYBACK_ONCE_BACKWARD</code>
---
---<code>go.PLAYBACK_ONCE_PINGPONG</code>
---
---@param url string|hash|url the model for which to play the animation
---@param anim_id string|hash id of the animation to play
---@param playback constant playback mode of the animation  <code>go.PLAYBACK_ONCE_FORWARD</code>  <code>go.PLAYBACK_ONCE_BACKWARD</code>  <code>go.PLAYBACK_ONCE_PINGPONG</code>  <code>go.PLAYBACK_LOOP_FORWARD</code>  <code>go.PLAYBACK_LOOP_BACKWARD</code>  <code>go.PLAYBACK_LOOP_PINGPONG</code> 
---@param play_properties {blend_duration:number, offset:number, playback_rate:number}|nil optional table with properties
---@param complete_function fun(self:object, message_id:hash, message:{animation_id:hash, playback:constant}, sender:url)|nil function to call when the animation has completed.
---@overload fun(url: string|hash|url, anim_id: string|hash, playback: constant)
---@overload fun(url: string|hash|url, anim_id: string|hash, playback: constant, play_properties: {blend_duration:number, offset:number, playback_rate:number}|nil)
function model.play_anim(url, anim_id, playback, play_properties, complete_function) end

---Docs: https://defold.com/ref/stable/model/?q=model.cancel#model.cancel
---
---Cancels all animation on a model component.
---@param url string|hash|url the model for which to cancel the animation
function model.cancel(url) end

---Docs: https://defold.com/ref/stable/model/?q=model.get_go#model.get_go
---
---Gets the id of the game object that corresponds to a model skeleton bone.
---The returned game object can be used for parenting and transform queries.
---This function has complexity <code>O(n)</code>, where <code>n</code> is the number of bones in the model skeleton.
---Game objects corresponding to a model skeleton bone can not be individually deleted.
---@param url string|hash|url the model to query
---@param bone_id string|hash id of the corresponding bone
---@return hash id id of the game object
function model.get_go(url, bone_id) end

---This message is sent when a Model animation has finished playing back to the script
---that started the animation.
--- No message is sent if a completion callback function was supplied
---when the animation was started. No message is sent if the animation is cancelled with
---model.cancel(). This message is sent only for animations that play with
---the following playback modes:
---
---<code>go.PLAYBACK_ONCE_FORWARD</code>
---
---<code>go.PLAYBACK_ONCE_BACKWARD</code>
---
---<code>go.PLAYBACK_ONCE_PINGPONG</code>
---
---@class model_animation_done_msg
---@field animation_id hash the id of the completed animation
---@field playback constant the playback mode of the completed animation

