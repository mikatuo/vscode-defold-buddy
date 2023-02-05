---@meta

---Particle effects API documentation
---@class particlefx
particlefx = {}

---Docs: https://defold.com/ref/stable/particlefx/?q=particlefx.play#particlefx.play
---
---Starts playing a particle FX component.
---Particle FX started this way need to be manually stopped through <code>particlefx.stop()</code>.
---Which particle FX to play is identified by the URL.
---A particle FX will continue to emit particles even if the game object the particle FX component belonged to is deleted. You can call <code>particlefx.stop()</code> to stop it from emitting more particles.
---@param url string|hash|url the particle fx that should start playing.
---@param emitter_state_function fun(self:object, id:hash, emitter:hash, state:constant)|nil optional callback function that will be called when an emitter attached to this particlefx changes state.
---@overload fun(url: string|hash|url)
function particlefx.play(url, emitter_state_function) end

---Docs: https://defold.com/ref/stable/particlefx/?q=particlefx.stop#particlefx.stop
---
---Stops a particle FX component from playing.
---Stopping a particle FX does not remove already spawned particles.
---Which particle FX to stop is identified by the URL.
---@param url string|hash|url the particle fx that should stop playing
---@param options {clear:boolean} Options when stopping the particle fx. Supported options
function particlefx.stop(url, options) end

---Docs: https://defold.com/ref/stable/particlefx/?q=particlefx.set_constant#particlefx.set_constant
---
---Sets a shader constant for a particle FX component emitter.
---The constant must be defined in the material assigned to the emitter.
---Setting a constant through this function will override the value set for that constant in the material.
---The value will be overridden until particlefx.reset_constant is called.
---Which particle FX to set a constant for is identified by the URL.
---@param url string|hash|url the particle FX that should have a constant set
---@param emitter string|hash the id of the emitter
---@param constant string|hash the name of the constant
---@param value vector4 the value of the constant
function particlefx.set_constant(url, emitter, constant, value) end

---Docs: https://defold.com/ref/stable/particlefx/?q=particlefx.reset_constant#particlefx.reset_constant
---
---Resets a shader constant for a particle FX component emitter.
---The constant must be defined in the material assigned to the emitter.
---Resetting a constant through this function implies that the value defined in the material will be used.
---Which particle FX to reset a constant for is identified by the URL.
---@param url string|hash|url the particle FX that should have a constant reset
---@param emitter string|hash the id of the emitter
---@param constant string|hash the name of the constant
function particlefx.reset_constant(url, emitter, constant) end

---The emitter does not have any living particles and will not spawn any particles in this state.
particlefx.EMITTER_STATE_SLEEPING = nil

---The emitter will be in this state when it has been started but before spawning any particles. Normally the emitter is in this state for a short time, depending on if a start delay has been set for this emitter or not.
particlefx.EMITTER_STATE_PRESPAWN = nil

---The emitter is spawning particles.
particlefx.EMITTER_STATE_SPAWNING = nil

---The emitter is not spawning any particles, but has particles that are still alive.
particlefx.EMITTER_STATE_POSTSPAWN = nil

