---@meta

---Sprite API documentation
---@class sprite
sprite = {}

---Docs: https://defold.com/ref/stable/sprite/?q=sprite.set_hflip#sprite.set_hflip
---
---Sets horizontal flipping of the provided sprite's animations.
---The sprite is identified by its URL.
---If the currently playing animation is flipped by default, flipping it again will make it appear like the original texture.
---@param url string|hash|url the sprite that should flip its animations
---@param flip boolean <code>true</code> if the sprite should flip its animations, <code>false</code> if not
function sprite.set_hflip(url, flip) end

---Docs: https://defold.com/ref/stable/sprite/?q=sprite.set_vflip#sprite.set_vflip
---
---Sets vertical flipping of the provided sprite's animations.
---The sprite is identified by its URL.
---If the currently playing animation is flipped by default, flipping it again will make it appear like the original texture.
---@param url string|hash|url the sprite that should flip its animations
---@param flip boolean <code>true</code> if the sprite should flip its animations, <code>false</code> if not
function sprite.set_vflip(url, flip) end

---Docs: https://defold.com/ref/stable/sprite/?q=sprite.play_flipbook#sprite.play_flipbook
---
---Play an animation on a sprite component from its tile set
---An optional completion callback function can be provided that will be called when
---the animation has completed playing. If no function is provided,
---a animation_done message is sent to the script that started the animation.
---@param url string|hash|url the sprite that should play the animation
---@param id any hash name hash of the animation to play
---@param complete_function fun(self:object, message_id:hash, message:{current_tile:number, id:hash}, sender:url)|nil function to call when the animation has completed.
---@param play_properties {offset:number, playback_rate:number}|nil optional table with properties
---@overload fun(url: string|hash|url, id: any)
---@overload fun(url: string|hash|url, id: any, complete_function: fun(self:object, message_id:hash, message:{current_tile:number, id:hash}, sender:url)|nil)
function sprite.play_flipbook(url, id, complete_function, play_properties) end

---Post this message to a sprite component to make it play an animation from its tile set.
---@class play_animation_msg
---@field id hash the id of the animation to play

---This message is sent to the sender of a <code>play_animation</code> message when the
---animation has completed.
---Note that this message is sent only for animations that play with the following
---playback modes:
---
---Once Forward
---
---Once Backward
---
---Once Ping Pong
---
---See play_animation for more information and examples of how to use
---this message.
---@class animation_done_msg
---@field current_tile number the current tile of the sprite
---@field id hash id of the animation that was completed

