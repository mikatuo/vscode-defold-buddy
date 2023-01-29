---@meta

---Game object API documentation
---@class go
go = {}

---Docs: https://defold.com/ref/stable/go/?q=go.get#go.get
---
---gets a named property of the specified game object or component
---@param url string|hash|url url of the game object or component having the property
---@param property string|hash id of the property to retrieve
---@param options table|nil optional options table
---@overload fun(url: string|hash|url, property: string|hash): any
---@return any value the value of the specified property
function go.get(url, property, options) end

---Docs: https://defold.com/ref/stable/go/?q=go.set#go.set
---
---sets a named property of the specified game object or component, or a material constant
---@param url string|hash|url url of the game object or component having the property
---@param property string|hash id of the property to set
---@param value any the value to set
---@param options table|nil optional options table
---@overload fun(url: string|hash|url, property: string|hash, value: any)
function go.set(url, property, value, options) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_position#go.get_position
---
---The position is relative the parent (if any). Use go.get_world_position to retrieve the global world position.
---@param id string|hash|url|nil optional id of the game object instance to get the position for, by default the instance of the calling script
---@overload fun(): vector3
---@return vector3 position instance position
function go.get_position(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_rotation#go.get_rotation
---
---The rotation is relative to the parent (if any). Use go.get_world_rotation to retrieve the global world rotation.
---@param id string|hash|url|nil optional id of the game object instance to get the rotation for, by default the instance of the calling script
---@overload fun(): quaternion
---@return quaternion rotation instance rotation
function go.get_rotation(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_scale#go.get_scale
---
---The scale is relative the parent (if any). Use go.get_world_scale to retrieve the global world 3D scale factor.
---@param id string|hash|url|nil optional id of the game object instance to get the scale for, by default the instance of the calling script
---@overload fun(): vector3
---@return vector3 scale instance scale factor
function go.get_scale(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_scale_uniform#go.get_scale_uniform
---
---The uniform scale is relative the parent (if any). If the underlying scale vector is non-uniform the min element of the vector is returned as the uniform scale factor.
---@param id string|hash|url|nil optional id of the game object instance to get the uniform scale for, by default the instance of the calling script
---@overload fun(): number
---@return number scale uniform instance scale factor
function go.get_scale_uniform(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.set_position#go.set_position
---
---The position is relative to the parent (if any). The global world position cannot be manually set.
---@param position vector3 position to set
---@param id string|hash|url|nil optional id of the game object instance to set the position for, by default the instance of the calling script
---@overload fun(position: vector3)
function go.set_position(position, id) end

---Docs: https://defold.com/ref/stable/go/?q=go.set_rotation#go.set_rotation
---
---The rotation is relative to the parent (if any). The global world rotation cannot be manually set.
---@param rotation quaternion rotation to set
---@param id string|hash|url|nil optional id of the game object instance to get the rotation for, by default the instance of the calling script
---@overload fun(rotation: quaternion)
function go.set_rotation(rotation, id) end

---Docs: https://defold.com/ref/stable/go/?q=go.set_scale#go.set_scale
---
---The scale factor is relative to the parent (if any). The global world scale factor cannot be manually set.
---Physics are currently not affected when setting scale from this function.
---@param scale number|vector3 vector or uniform scale factor, must be greater than 0
---@param id string|hash|url|nil optional id of the game object instance to get the scale for, by default the instance of the calling script
---@overload fun(scale: number|vector3)
function go.set_scale(scale, id) end

---Docs: https://defold.com/ref/stable/go/?q=go.set_parent#go.set_parent
---
---Sets the parent for a game object instance. This means that the instance will exist in the geometrical space of its parent,
---like a basic transformation hierarchy or scene graph. If no parent is specified, the instance will be detached from any parent and exist in world
---space.
---This function will generate a <code>set_parent</code> message. It is not until the message has been processed that the change actually takes effect. This
---typically happens later in the same frame or the beginning of the next frame. Refer to the manual to learn how messages are processed by the
---engine.
---@param id string|hash|url|nil optional id of the game object instance to set parent for, defaults to the instance containing the calling script
---@param parent_id string|hash|url|nil optional id of the new parent game object, defaults to detaching game object from its parent
---@param keep_world_transform boolean|nil optional boolean, set to true to maintain the world transform when changing spaces. Defaults to false.
---@overload fun()
---@overload fun(id: string|hash|url|nil)
---@overload fun(id: string|hash|url|nil, parent_id: string|hash|url|nil)
function go.set_parent(id, parent_id, keep_world_transform) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_parent#go.get_parent
---
---Get the parent for a game object instance.
---@param id string|hash|url|nil optional id of the game object instance to get parent for, defaults to the instance containing the calling script
---@overload fun(): hash
---@return hash parent_id parent instance or nil
function go.get_parent(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_world_position#go.get_world_position
---
---The function will return the world position calculated at the end of the previous frame.
---Use go.get_position to retrieve the position relative to the parent.
---@param id string|hash|url|nil optional id of the game object instance to get the world position for, by default the instance of the calling script
---@overload fun(): vector3
---@return vector3 position instance world position
function go.get_world_position(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_world_rotation#go.get_world_rotation
---
---The function will return the world rotation calculated at the end of the previous frame.
---Use go.get_rotation to retrieve the rotation relative to the parent.
---@param id string|hash|url|nil optional id of the game object instance to get the world rotation for, by default the instance of the calling script
---@overload fun(): quaternion
---@return quaternion rotation instance world rotation
function go.get_world_rotation(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_world_scale#go.get_world_scale
---
---The function will return the world 3D scale factor calculated at the end of the previous frame.
---Use go.get_scale to retrieve the 3D scale factor relative to the parent.
---This vector is derived by decomposing the transformation matrix and should be used with care.
---For most cases it should be fine to use go.get_world_scale_uniform instead.
---@param id string|hash|url|nil optional id of the game object instance to get the world scale for, by default the instance of the calling script
---@overload fun(): vector3
---@return vector3 scale instance world 3D scale factor
function go.get_world_scale(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_world_scale_uniform#go.get_world_scale_uniform
---
---The function will return the world scale factor calculated at the end of the previous frame.
---Use go.get_scale_uniform to retrieve the scale factor relative to the parent.
---@param id string|hash|url|nil optional id of the game object instance to get the world scale for, by default the instance of the calling script
---@overload fun(): number
---@return number scale instance world scale factor
function go.get_world_scale_uniform(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_world_transform#go.get_world_transform
---
---The function will return the world transform matrix calculated at the end of the previous frame.
---@param id string|hash|url|nil optional id of the game object instance to get the world transform for, by default the instance of the calling script
---@overload fun(): matrix4
---@return matrix4 transform instance world transform
function go.get_world_transform(id) end

---Docs: https://defold.com/ref/stable/go/?q=go.get_id#go.get_id
---
---Returns or constructs an instance identifier. The instance id is a hash
---of the absolute path to the instance.
---
---If <code>path</code> is specified, it can either be absolute or relative to the instance of the calling script.
---
---If <code>path</code> is not specified, the id of the game object instance the script is attached to will be returned.
---
---@param path string|nil path of the instance for which to return the id
---@overload fun(): hash
---@return hash id instance id
function go.get_id(path) end

---Docs: https://defold.com/ref/stable/go/?q=go.animate#go.animate
---
---This is only supported for numerical properties. If the node property is already being
---animated, that animation will be canceled and replaced by the new one.
---If a <code>complete_function</code> (lua function) is specified, that function will be called when the animation has completed.
---By starting a new animation in that function, several animations can be sequenced together. See the examples for more information.
---If you call <code>go.animate()</code> from a game object's <code>final()</code> function,
---any passed <code>complete_function</code> will be ignored and never called upon animation completion.
---See the properties guide for which properties can be animated and the animation guide for how
---them.
---@param url string|hash|url url of the game object or component having the property
---@param property string|hash id of the property to animate
---@param playback constant playback mode of the animation  <code>go.PLAYBACK_ONCE_FORWARD</code>  <code>go.PLAYBACK_ONCE_BACKWARD</code>  <code>go.PLAYBACK_ONCE_PINGPONG</code>  <code>go.PLAYBACK_LOOP_FORWARD</code>  <code>go.PLAYBACK_LOOP_BACKWARD</code>  <code>go.PLAYBACK_LOOP_PINGPONG</code> 
---@param to number|vector3|vector4|quaternion target property value
---@param easing constant|vector easing to use during animation. Either specify a constant, see the animation guide for a complete list, or a vmath.vector with a curve
---@param duration number duration of the animation in seconds
---@param delay number|nil delay before the animation starts in seconds
---@param complete_function fun(self:object, url:url, property:hash)|nil optional function to call when the animation has completed
---@overload fun(url: string|hash|url, property: string|hash, playback: constant, to: number|vector3|vector4|quaternion, easing: constant|vector, duration: number)
---@overload fun(url: string|hash|url, property: string|hash, playback: constant, to: number|vector3|vector4|quaternion, easing: constant|vector, duration: number, delay: number|nil)
function go.animate(url, property, playback, to, easing, duration, delay, complete_function) end

---Docs: https://defold.com/ref/stable/go/?q=go.cancel_animations#go.cancel_animations
---
---By calling this function, all or specified stored property animations of the game object or component will be canceled.
---See the properties guide for which properties can be animated and the animation guide for how to animate them.
---@param url string|hash|url url of the game object or component
---@param property string|hash|nil optional id of the property to cancel
---@overload fun(url: string|hash|url)
function go.cancel_animations(url, property) end

---Docs: https://defold.com/ref/stable/go/?q=go.delete#go.delete
---
---Delete one or more game objects identified by id. Deletion is asynchronous meaning that
---the game object(s) are scheduled for deletion which will happen at the end of the current
---frame. Note that game objects scheduled for deletion will be counted against
---<code>max_instances</code> in "game.project" until they are actually removed.
---Deleting a game object containing a particle FX component emitting particles will not immediately stop the particle FX from emitting particles. You need to manually stop the particle FX using <code>particlefx.stop()</code>.
---Deleting a game object containing a sound component that is playing will not immediately stop the sound from playing. You need to manually stop the sound using <code>sound.stop()</code>.
---@param id string|hash|url|table|nil optional id or table of id's of the instance(s) to delete, the instance of the calling script is deleted by default
---@param recursive boolean|nil optional boolean, set to true to recursively delete child hiearchy in child to parent order
---@overload fun()
---@overload fun(id: string|hash|url|table|nil)
function go.delete(id, recursive) end

---Docs: https://defold.com/ref/stable/go/?q=go.property#go.property
---
---This function defines a property which can then be used in the script through the self-reference.
---The properties defined this way are automatically exposed in the editor in game objects and collections which use the script.
---Note that you can only use this function outside any callback-functions like init and update.
---@param name string the id of the property
---@param value boolean|number|hash|url|vector3|vector4|quaternion|resource default value of the property. In the case of a url, only the empty constructor msg.url() is allowed. In the case of a resource one of the resource constructors (eg resource.atlas(), resource.font() etc) is expected.
function go.property(name, value) end

---Docs: https://defold.com/ref/stable/go/?q=init#init
---
---This is a callback-function, which is called by the engine when a script component is initialized. It can be used
---to set the initial state of the script.
---@param self object reference to the script state to be used for storing data
function init(self) end

---Docs: https://defold.com/ref/stable/go/?q=final#final
---
---This is a callback-function, which is called by the engine when a script component is finalized (destroyed). It can
---be used to e.g. take some last action, report the finalization to other game object instances, delete spawned objects
---or release user input focus (see release_input_focus).
---@param self object reference to the script state to be used for storing data
function final(self) end

---Docs: https://defold.com/ref/stable/go/?q=update#update
---
---This is a callback-function, which is called by the engine every frame to update the state of a script component.
---It can be used to perform any kind of game related tasks, e.g. moving the game object instance.
---@param self object reference to the script state to be used for storing data
---@param dt number the time-step of the frame update
function update(self, dt) end

---Docs: https://defold.com/ref/stable/go/?q=on_message#on_message
---
---This is a callback-function, which is called by the engine whenever a message has been sent to the script component.
---It can be used to take action on the message, e.g. send a response back to the sender of the message.
---The <code>message</code> parameter is a table containing the message data. If the message is sent from the engine, the
---documentation of the message specifies which data is supplied.
---@param self object reference to the script state to be used for storing data
---@param message_id hash id of the received message
---@param message table a table containing the message data
---@param sender url address of the sender
function on_message(self, message_id, message, sender) end

---Docs: https://defold.com/ref/stable/go/?q=on_input#on_input
---
---This is a callback-function, which is called by the engine when user input is sent to the game object instance of the script.
---It can be used to take action on the input, e.g. move the instance according to the input.
---For an instance to obtain user input, it must first acquire input focus
---through the message <code>acquire_input_focus</code>.
---Any instance that has obtained input will be put on top of an
---input stack. Input is sent to all listeners on the stack until the
---end of stack is reached, or a listener returns <code>true</code>
---to signal that it wants input to be consumed.
---See the documentation of acquire_input_focus for more
---information.
---The <code>action</code> parameter is a table containing data about the input mapped to the
---<code>action_id</code>.
---For mapped actions it specifies the value of the input and if it was just pressed or released.
---Actions are mapped to input in an input_binding-file.
---Mouse movement is specifically handled and uses <code>nil</code> as its <code>action_id</code>.
---The <code>action</code> only contains positional parameters in this case, such as x and y of the pointer.
---Here is a brief description of the available table fields:
---
---
---
---Field
---Description
---
---
---
---
---<code>value</code>
---The amount of input given by the user. This is usually 1 for buttons and 0-1 for analogue inputs. This is not present for mouse movement.
---
---
---<code>pressed</code>
---If the input was pressed this frame. This is not present for mouse movement.
---
---
---<code>released</code>
---If the input was released this frame. This is not present for mouse movement.
---
---
---<code>repeated</code>
---If the input was repeated this frame. This is similar to how a key on a keyboard is repeated when you hold it down. This is not present for mouse movement.
---
---
---<code>x</code>
---The x value of a pointer device, if present.
---
---
---<code>y</code>
---The y value of a pointer device, if present.
---
---
---<code>screen_x</code>
---The screen space x value of a pointer device, if present.
---
---
---<code>screen_y</code>
---The screen space y value of a pointer device, if present.
---
---
---<code>dx</code>
---The change in x value of a pointer device, if present.
---
---
---<code>dy</code>
---The change in y value of a pointer device, if present.
---
---
---<code>screen_dx</code>
---The change in screen space x value of a pointer device, if present.
---
---
---<code>screen_dy</code>
---The change in screen space y value of a pointer device, if present.
---
---
---<code>gamepad</code>
---The index of the gamepad device that provided the input.
---
---
---<code>touch</code>
---List of touch input, one element per finger, if present. See table below about touch input
---
---
---
---Touch input table:
---
---
---
---Field
---Description
---
---
---
---
---<code>id</code>
---A number identifying the touch input during its duration.
---
---
---<code>pressed</code>
---True if the finger was pressed this frame.
---
---
---<code>released</code>
---True if the finger was released this frame.
---
---
---<code>tap_count</code>
---Number of taps, one for single, two for double-tap, etc
---
---
---<code>x</code>
---The x touch location.
---
---
---<code>y</code>
---The y touch location.
---
---
---<code>dx</code>
---The change in x value.
---
---
---<code>dy</code>
---The change in y value.
---
---
---<code>acc_x</code>
---Accelerometer x value (if present).
---
---
---<code>acc_y</code>
---Accelerometer y value (if present).
---
---
---<code>acc_z</code>
---Accelerometer z value (if present).
---
---
---
---@param self object reference to the script state to be used for storing data
---@param action_id hash id of the received input action, as mapped in the input_binding-file
---@param action table a table containing the input data, see above for a description
---@return boolean [consume] optional boolean to signal if the input should be consumed (not passed on to others) or not, default is false
function on_input(self, action_id, action) end

---Docs: https://defold.com/ref/stable/go/?q=on_reload#on_reload
---
---This is a callback-function, which is called by the engine when the script component is reloaded, e.g. from the editor.
---It can be used for live development, e.g. to tweak constants or set up the state properly for the instance.
---@param self object reference to the script state to be used for storing data
function on_reload(self) end

---Post this message to a game object instance to make that instance acquire the user input focus.
---User input is distributed by the engine to every instance that has
---requested it. The last instance to request focus will receive it first.
---This means that the scripts in the instance will have first-hand-chance
---at reacting on user input, possibly consuming it (by returning
---<code>true</code> from <code>on_input</code>) so that no other instances
---can react on it. The most common case is for a script to send this message
---to itself when it needs to respond to user input.
---A script belonging to an instance which has the user input focus will
---receive the input actions in its <code>on_input</code> callback function.
---See on_input for more information on how user input can be
---handled.
---@class acquire_input_focus_msg

---Post this message to an instance to make that instance release the user input focus.
---See acquire_input_focus for more information on how the user input handling
---works.
---@class release_input_focus_msg

---When this message is sent to an instance, it sets the parent of that instance. This means that the instance will exist
---in the geometrical space of its parent, like a basic transformation hierarchy or scene graph. If no parent is specified,
---the instance will be detached from any parent and exist in world space. A script can send this message to itself to set
---the parent of its instance.
---@class set_parent_msg
---@field parent_id hash the id of the new parent
---@field keep_world_transform number if the world transform of the instance should be preserved when changing spaces, 0 for false and 1 for true. The default value is 1.

---This message enables the receiving component. All components are enabled by default, which means they will receive input, updates
---and be a part of the simulation. A component is disabled when it receives the <code>disable</code> message.
--- Components that currently supports this message are:
---
---Collection Proxy
---
---Collision Object
---
---Gui
---
---Label
---
---Spine Model
---
---Sprite
---
---Tile Grid
---
---Model
---
---Mesh
---
---@class enable_msg

---This message disables the receiving component. All components are enabled by default, which means they will receive input, updates
---and be a part of the simulation. A component is disabled when it receives the <code>disable</code> message.
--- Components that currently supports this message are:
---
---Collection Proxy
---
---Collision Object
---
---Gui
---
---Label
---
---Spine Model
---
---Sprite
---
---Tile Grid
---
---Model
---
---Mesh
---
---@class disable_msg

---no playback
go.PLAYBACK_NONE = nil

---once forward
go.PLAYBACK_ONCE_FORWARD = nil

---once backward
go.PLAYBACK_ONCE_BACKWARD = nil

---once ping pong
go.PLAYBACK_ONCE_PINGPONG = nil

---loop forward
go.PLAYBACK_LOOP_FORWARD = nil

---loop backward
go.PLAYBACK_LOOP_BACKWARD = nil

---ping pong loop
go.PLAYBACK_LOOP_PINGPONG = nil

---linear interpolation
go.EASING_LINEAR = nil

---in-quadratic
go.EASING_INQUAD = nil

---out-quadratic
go.EASING_OUTQUAD = nil

---in-out-quadratic
go.EASING_INOUTQUAD = nil

---out-in-quadratic
go.EASING_OUTINQUAD = nil

---in-cubic
go.EASING_INCUBIC = nil

---out-cubic
go.EASING_OUTCUBIC = nil

---in-out-cubic
go.EASING_INOUTCUBIC = nil

---out-in-cubic
go.EASING_OUTINCUBIC = nil

---in-quartic
go.EASING_INQUART = nil

---out-quartic
go.EASING_OUTQUART = nil

---in-out-quartic
go.EASING_INOUTQUART = nil

---out-in-quartic
go.EASING_OUTINQUART = nil

---in-quintic
go.EASING_INQUINT = nil

---out-quintic
go.EASING_OUTQUINT = nil

---in-out-quintic
go.EASING_INOUTQUINT = nil

---out-in-quintic
go.EASING_OUTINQUINT = nil

---in-sine
go.EASING_INSINE = nil

---out-sine
go.EASING_OUTSINE = nil

---in-out-sine
go.EASING_INOUTSINE = nil

---out-in-sine
go.EASING_OUTINSINE = nil

---in-exponential
go.EASING_INEXPO = nil

---out-exponential
go.EASING_OUTEXPO = nil

---in-out-exponential
go.EASING_INOUTEXPO = nil

---out-in-exponential
go.EASING_OUTINEXPO = nil

---in-circlic
go.EASING_INCIRC = nil

---out-circlic
go.EASING_OUTCIRC = nil

---in-out-circlic
go.EASING_INOUTCIRC = nil

---out-in-circlic
go.EASING_OUTINCIRC = nil

---in-elastic
go.EASING_INELASTIC = nil

---out-elastic
go.EASING_OUTELASTIC = nil

---in-out-elastic
go.EASING_INOUTELASTIC = nil

---out-in-elastic
go.EASING_OUTINELASTIC = nil

---in-back
go.EASING_INBACK = nil

---out-back
go.EASING_OUTBACK = nil

---in-out-back
go.EASING_INOUTBACK = nil

---out-in-back
go.EASING_OUTINBACK = nil

---in-bounce
go.EASING_INBOUNCE = nil

---out-bounce
go.EASING_OUTBOUNCE = nil

---in-out-bounce
go.EASING_INOUTBOUNCE = nil

---out-in-bounce
go.EASING_OUTINBOUNCE = nil

