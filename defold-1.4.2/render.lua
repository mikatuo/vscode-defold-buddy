---@meta

---Rendering API documentation
---@class render
render = {}

---Docs: https://defold.com/ref/stable/render/?q=render.constant_buffer#render.constant_buffer
---
---Constant buffers are used to set shader program variables and are optionally passed to the <code>render.draw()</code> function.
---The buffer's constant elements can be indexed like an ordinary Lua table, but you can't iterate over them with pairs() or ipairs().
---@return constant_buffer buffer new constant buffer
function render.constant_buffer() end

---Docs: https://defold.com/ref/stable/render/?q=render.enable_state#render.enable_state
---
---Enables a particular render state. The state will be enabled until disabled.
---@param state constant state to enable  <code>render.STATE_DEPTH_TEST</code>  <code>render.STATE_STENCIL_TEST</code>  <code>render.STATE_BLEND</code>  <code>render.STATE_ALPHA_TEST</code> ( not available on iOS and Android)  <code>render.STATE_CULL_FACE</code>  <code>render.STATE_POLYGON_OFFSET_FILL</code> 
function render.enable_state(state) end

---Docs: https://defold.com/ref/stable/render/?q=render.disable_state#render.disable_state
---
---Disables a render state.
---@param state constant state to disable  <code>render.STATE_DEPTH_TEST</code>  <code>render.STATE_STENCIL_TEST</code>  <code>render.STATE_BLEND</code>  <code>render.STATE_ALPHA_TEST</code> ( not available on iOS and Android)  <code>render.STATE_CULL_FACE</code>  <code>render.STATE_POLYGON_OFFSET_FILL</code> 
function render.disable_state(state) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_viewport#render.set_viewport
---
---Set the render viewport to the specified rectangle.
---@param x number left corner
---@param y number bottom corner
---@param width number viewport width
---@param height number viewport height
function render.set_viewport(x, y, width, height) end

---Docs: https://defold.com/ref/stable/render/?q=render.render_target#render.render_target
---
---Creates a new render target according to the supplied
---specification table.
---The table should contain keys specifying which buffers should be created
---with what parameters. Each buffer key should have a table value consisting
---of parameters. The following parameter keys are available:
---
---
---
---Key
---Values
---
---
---
---
---<code>format</code>
---<code>render.FORMAT_LUMINANCE</code><code>render.FORMAT_RGB</code><code>render.FORMAT_RGBA</code><code>render.FORMAT_DEPTH</code><code>render.FORMAT_STENCIL</code><code>render.FORMAT_RGBA32F</code><code>render.FORMAT_RGBA16F</code>
---
---
---<code>width</code>
---number
---
---
---<code>height</code>
---number
---
---
---<code>min_filter</code>
---<code>render.FILTER_LINEAR</code><code>render.FILTER_NEAREST</code>
---
---
---<code>mag_filter</code>
---<code>render.FILTER_LINEAR</code><code>render.FILTER_NEAREST</code>
---
---
---<code>u_wrap</code>
---<code>render.WRAP_CLAMP_TO_BORDER</code><code>render.WRAP_CLAMP_TO_EDGE</code><code>render.WRAP_MIRRORED_REPEAT</code><code>render.WRAP_REPEAT</code>
---
---
---<code>v_wrap</code>
---<code>render.WRAP_CLAMP_TO_BORDER</code><code>render.WRAP_CLAMP_TO_EDGE</code><code>render.WRAP_MIRRORED_REPEAT</code><code>render.WRAP_REPEAT</code>
---
---
---
---The render target can be created to support multiple color attachments. Each attachment can have different format settings and texture filters,
---but attachments must be added in sequence, meaning you cannot create a render target at slot 0 and 3.
---Instead it has to be created with all four buffer types ranging from [0..3] (as denoted by render.BUFFER_COLORX_BIT where 'X' is the attachment you want to create).
---@param name string render target name
---@param parameters table table of buffer parameters, see the description for available keys and values
---@return render_target render_target new render target
function render.render_target(name, parameters) end

---Docs: https://defold.com/ref/stable/render/?q=render.delete_render_target#render.delete_render_target
---
---Deletes a previously created render target.
---@param render_target render_target render target to delete
function render.delete_render_target(render_target) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_render_target#render.set_render_target
---
---Sets a render target. Subsequent draw operations will be to the
---render target until it is replaced by a subsequent call to set_render_target.
---@param render_target render_target render target to set. render.RENDER_TARGET_DEFAULT to set the default render target
---@param options {transient:table}|nil optional table with behaviour parameters
---@overload fun(render_target: render_target)
function render.set_render_target(render_target, options) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_render_target_size#render.set_render_target_size
---
---sets the render target size
---@param render_target render_target render target to set size for
---@param width number new render target width
---@param height number new render target height
function render.set_render_target_size(render_target, width, height) end

---Docs: https://defold.com/ref/stable/render/?q=render.enable_texture#render.enable_texture
---
---Sets the specified render target's specified buffer to be
---used as texture with the specified unit.
---A material shader can then use the texture to sample from.
---@param unit number texture unit to enable texture for
---@param render_target render_target render target from which to enable the specified texture unit
---@param buffer_type constant buffer type from which to enable the texture  <code>render.BUFFER_COLOR_BIT</code>  <code>render.BUFFER_DEPTH_BIT</code>  <code>render.BUFFER_STENCIL_BIT</code>  If the render target has been created with multiple color attachments, these buffer types can be used to enable those textures as well. Currently only 4 color attachments are supported.  <code>render.BUFFER_COLOR0_BIT</code>  <code>render.BUFFER_COLOR1_BIT</code>  <code>render.BUFFER_COLOR2_BIT</code>  <code>render.BUFFER_COLOR3_BIT</code> 
function render.enable_texture(unit, render_target, buffer_type) end

---Docs: https://defold.com/ref/stable/render/?q=render.disable_texture#render.disable_texture
---
---Disables a texture unit for a render target that has previourly been enabled.
---@param unit number texture unit to disable
function render.disable_texture(unit) end

---Docs: https://defold.com/ref/stable/render/?q=render.get_render_target_width#render.get_render_target_width
---
---Returns the specified buffer width from a render target.
---@param render_target render_target render target from which to retrieve the buffer width
---@param buffer_type constant which type of buffer to retrieve the width from  <code>render.BUFFER_COLOR_BIT</code>  <code>render.BUFFER_DEPTH_BIT</code>  <code>render.BUFFER_STENCIL_BIT</code> 
---@return number width the width of the render target buffer texture
function render.get_render_target_width(render_target, buffer_type) end

---Docs: https://defold.com/ref/stable/render/?q=render.get_render_target_height#render.get_render_target_height
---
---Returns the specified buffer height from a render target.
---@param render_target render_target render target from which to retrieve the buffer height
---@param buffer_type constant which type of buffer to retrieve the height from  <code>render.BUFFER_COLOR_BIT</code>  <code>render.BUFFER_DEPTH_BIT</code>  <code>render.BUFFER_STENCIL_BIT</code> 
---@return number height the height of the render target buffer texture
function render.get_render_target_height(render_target, buffer_type) end

---Docs: https://defold.com/ref/stable/render/?q=render.clear#render.clear
---
---Clear buffers in the currently enabled render target with specified value. If the render target has been created with multiple
---color attachments, all buffers will be cleared with the same value.
---@param buffers table table with keys specifying which buffers to clear and values set to clear values. Available keys are
function render.clear(buffers) end

---Docs: https://defold.com/ref/stable/render/?q=render.draw#render.draw
---
---Draws all objects that match a specified predicate. An optional constant buffer can be
---provided to override the default constants. If no constants buffer is provided, a default
---system constants buffer is used containing constants as defined in materials and set through
---go.set (or particlefx.set_constant) on visual components.
---@param predicate predicate predicate to draw for
---@param options {frustum:vmath.matrix4, constants:constant_buffer}|nil optional table with properties
---@overload fun(predicate: predicate)
function render.draw(predicate, options) end

---Docs: https://defold.com/ref/stable/render/?q=render.draw_debug3d#render.draw_debug3d
---
---Draws all 3d debug graphics such as lines drawn with "draw_line" messages and physics visualization.
---@param options {frustum:vmath.matrix4}|nil optional table with properties
---@overload fun()
function render.draw_debug3d(options) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_view#render.set_view
---
---Sets the view matrix to use when rendering.
---@param matrix matrix4 view matrix to set
function render.set_view(matrix) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_projection#render.set_projection
---
---Sets the projection matrix to use when rendering.
---@param matrix matrix4 projection matrix
function render.set_projection(matrix) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_blend_func#render.set_blend_func
---
---Specifies the arithmetic used when computing pixel values that are written to the frame
---buffer. In RGBA mode, pixels can be drawn using a function that blends the source RGBA
---pixel values with the destination pixel values already in the frame buffer.
---Blending is initially disabled.
---<code>source_factor</code> specifies which method is used to scale the source color components.
---<code>destination_factor</code> specifies which method is used to scale the destination color
---components.
---Source color components are referred to as (Rs,Gs,Bs,As).
---Destination color components are referred to as (Rd,Gd,Bd,Ad).
---The color specified by setting the blendcolor is referred to as (Rc,Gc,Bc,Ac).
---The source scale factor is referred to as (sR,sG,sB,sA).
---The destination scale factor is referred to as (dR,dG,dB,dA).
---The color values have integer values between 0 and (kR,kG,kB,kA), where kc = 2mc - 1 and mc is the number of bitplanes for that color. I.e for 8 bit color depth, color values are between <code>0</code> and <code>255</code>.
---Available factor constants and corresponding scale factors:
---
---
---
---Factor constant
---Scale factor (fR,fG,fB,fA)
---
---
---
---
---<code>render.BLEND_ZERO</code>
---(0,0,0,0)
---
---
---<code>render.BLEND_ONE</code>
---(1,1,1,1)
---
---
---<code>render.BLEND_SRC_COLOR</code>
---(Rs/kR,Gs/kG,Bs/kB,As/kA)
---
---
---<code>render.BLEND_ONE_MINUS_SRC_COLOR</code>
---(1,1,1,1) - (Rs/kR,Gs/kG,Bs/kB,As/kA)
---
---
---<code>render.BLEND_DST_COLOR</code>
---(Rd/kR,Gd/kG,Bd/kB,Ad/kA)
---
---
---<code>render.BLEND_ONE_MINUS_DST_COLOR</code>
---(1,1,1,1) - (Rd/kR,Gd/kG,Bd/kB,Ad/kA)
---
---
---<code>render.BLEND_SRC_ALPHA</code>
---(As/kA,As/kA,As/kA,As/kA)
---
---
---<code>render.BLEND_ONE_MINUS_SRC_ALPHA</code>
---(1,1,1,1) - (As/kA,As/kA,As/kA,As/kA)
---
---
---<code>render.BLEND_DST_ALPHA</code>
---(Ad/kA,Ad/kA,Ad/kA,Ad/kA)
---
---
---<code>render.BLEND_ONE_MINUS_DST_ALPHA</code>
---(1,1,1,1) - (Ad/kA,Ad/kA,Ad/kA,Ad/kA)
---
---
---<code>render.BLEND_CONSTANT_COLOR</code>
---(Rc,Gc,Bc,Ac)
---
---
---<code>render.BLEND_ONE_MINUS_CONSTANT_COLOR</code>
---(1,1,1,1) - (Rc,Gc,Bc,Ac)
---
---
---<code>render.BLEND_CONSTANT_ALPHA</code>
---(Ac,Ac,Ac,Ac)
---
---
---<code>render.BLEND_ONE_MINUS_CONSTANT_ALPHA</code>
---(1,1,1,1) - (Ac,Ac,Ac,Ac)
---
---
---<code>render.BLEND_SRC_ALPHA_SATURATE</code>
---(i,i,i,1) where i = min(As, kA - Ad) /kA
---
---
---
---The blended RGBA values of a pixel comes from the following equations:
---
---Rd = min(kR, Rs * sR + Rd * dR)
---
---Gd = min(kG, Gs * sG + Gd * dG)
---
---Bd = min(kB, Bs * sB + Bd * dB)
---
---Ad = min(kA, As * sA + Ad * dA)
---
---Blend function <code>(render.BLEND_SRC_ALPHA, render.BLEND_ONE_MINUS_SRC_ALPHA)</code> is useful for
---drawing with transparency when the drawn objects are sorted from farthest to nearest.
---It is also useful for drawing antialiased points and lines in arbitrary order.
---@param source_factor constant source factor
---@param destination_factor constant destination factor
function render.set_blend_func(source_factor, destination_factor) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_color_mask#render.set_color_mask
---
---Specifies whether the individual color components in the frame buffer is enabled for writing (<code>true</code>) or disabled (<code>false</code>). For example, if <code>blue</code> is <code>false</code>, nothing is written to the blue component of any pixel in any of the color buffers, regardless of the drawing operation attempted. Note that writing are either enabled or disabled for entire color components, not the individual bits of a component.
---The component masks are all initially <code>true</code>.
---@param red boolean red mask
---@param green boolean green mask
---@param blue boolean blue mask
---@param alpha boolean alpha mask
function render.set_color_mask(red, green, blue, alpha) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_depth_mask#render.set_depth_mask
---
---Specifies whether the depth buffer is enabled for writing. The supplied mask governs
---if depth buffer writing is enabled (<code>true</code>) or disabled (<code>false</code>).
---The mask is initially <code>true</code>.
---@param depth boolean depth mask
function render.set_depth_mask(depth) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_stencil_mask#render.set_stencil_mask
---
---The stencil mask controls the writing of individual bits in the stencil buffer.
---The least significant <code>n</code> bits of the parameter <code>mask</code>, where <code>n</code> is the number of
---bits in the stencil buffer, specify the mask.
---Where a <code>1</code> bit appears in the mask, the corresponding
---bit in the stencil buffer can be written. Where a <code>0</code> bit appears in the mask,
---the corresponding bit in the stencil buffer is never written.
---The mask is initially all <code>1</code>'s.
---@param mask number stencil mask
function render.set_stencil_mask(mask) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_depth_func#render.set_depth_func
---
---Specifies the function that should be used to compare each incoming pixel
---depth value with the value present in the depth buffer.
---The comparison is performed only if depth testing is enabled and specifies
---the conditions under which a pixel will be drawn.
---Function constants:
---
---<code>render.COMPARE_FUNC_NEVER</code> (never passes)
---
---<code>render.COMPARE_FUNC_LESS</code> (passes if the incoming depth value is less than the stored value)
---
---<code>render.COMPARE_FUNC_LEQUAL</code> (passes if the incoming depth value is less than or equal to the stored value)
---
---<code>render.COMPARE_FUNC_GREATER</code> (passes if the incoming depth value is greater than the stored value)
---
---<code>render.COMPARE_FUNC_GEQUAL</code> (passes if the incoming depth value is greater than or equal to the stored value)
---
---<code>render.COMPARE_FUNC_EQUAL</code> (passes if the incoming depth value is equal to the stored value)
---
---<code>render.COMPARE_FUNC_NOTEQUAL</code> (passes if the incoming depth value is not equal to the stored value)
---
---<code>render.COMPARE_FUNC_ALWAYS</code> (always passes)
---
---The depth function is initially set to <code>render.COMPARE_FUNC_LESS</code>.
---@param func constant depth test function, see the description for available values
function render.set_depth_func(func) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_stencil_func#render.set_stencil_func
---
---Stenciling is similar to depth-buffering as it enables and disables drawing on a
---per-pixel basis. First, GL drawing primitives are drawn into the stencil planes.
---Second, geometry and images are rendered but using the stencil planes to mask out
---where to draw.
---The stencil test discards a pixel based on the outcome of a comparison between the
---reference value <code>ref</code> and the corresponding value in the stencil buffer.
---<code>func</code> specifies the comparison function. See the table below for values.
---The initial value is <code>render.COMPARE_FUNC_ALWAYS</code>.
---<code>ref</code> specifies the reference value for the stencil test. The value is clamped to
---the range [0, 2n-1], where n is the number of bitplanes in the stencil buffer.
---The initial value is <code>0</code>.
---<code>mask</code> is ANDed with both the reference value and the stored stencil value when the test
---is done. The initial value is all <code>1</code>'s.
---Function constant:
---
---<code>render.COMPARE_FUNC_NEVER</code> (never passes)
---
---<code>render.COMPARE_FUNC_LESS</code> (passes if (ref &amp; mask) &lt; (stencil &amp; mask))
---
---<code>render.COMPARE_FUNC_LEQUAL</code> (passes if (ref &amp; mask) &lt;= (stencil &amp; mask))
---
---<code>render.COMPARE_FUNC_GREATER</code> (passes if (ref &amp; mask) &gt; (stencil &amp; mask))
---
---<code>render.COMPARE_FUNC_GEQUAL</code> (passes if (ref &amp; mask) &gt;= (stencil &amp; mask))
---
---<code>render.COMPARE_FUNC_EQUAL</code> (passes if (ref &amp; mask) = (stencil &amp; mask))
---
---<code>render.COMPARE_FUNC_NOTEQUAL</code> (passes if (ref &amp; mask) != (stencil &amp; mask))
---
---<code>render.COMPARE_FUNC_ALWAYS</code> (always passes)
---
---@param func constant stencil test function, see the description for available values
---@param ref number reference value for the stencil test
---@param mask number mask that is ANDed with both the reference value and the stored stencil value when the test is done
function render.set_stencil_func(func, ref, mask) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_stencil_op#render.set_stencil_op
---
---The stencil test discards a pixel based on the outcome of a comparison between the
---reference value <code>ref</code> and the corresponding value in the stencil buffer.
---To control the test, call render.set_stencil_func.
---This function takes three arguments that control what happens to the stored stencil
---value while stenciling is enabled. If the stencil test fails, no change is made to the
---pixel's color or depth buffers, and <code>sfail</code> specifies what happens to the stencil buffer
---contents.
---Operator constants:
---
---<code>render.STENCIL_OP_KEEP</code> (keeps the current value)
---
---<code>render.STENCIL_OP_ZERO</code> (sets the stencil buffer value to 0)
---
---<code>render.STENCIL_OP_REPLACE</code> (sets the stencil buffer value to <code>ref</code>, as specified by render.set_stencil_func)
---
---<code>render.STENCIL_OP_INCR</code> (increments the stencil buffer value and clamp to the maximum representable unsigned value)
---
---<code>render.STENCIL_OP_INCR_WRAP</code> (increments the stencil buffer value and wrap to zero when incrementing the maximum representable unsigned value)
---
---<code>render.STENCIL_OP_DECR</code> (decrements the current stencil buffer value and clamp to 0)
---
---<code>render.STENCIL_OP_DECR_WRAP</code> (decrements the current stencil buffer value and wrap to the maximum representable unsigned value when decrementing zero)
---
---<code>render.STENCIL_OP_INVERT</code> (bitwise inverts the current stencil buffer value)
---
---<code>dppass</code> and <code>dpfail</code> specify the stencil buffer actions depending on whether subsequent
---depth buffer tests succeed (dppass) or fail (dpfail).
---The initial value for all operators is <code>render.STENCIL_OP_KEEP</code>.
---@param sfail constant action to take when the stencil test fails
---@param dpfail constant the stencil action when the stencil test passes
---@param dppass constant the stencil action when both the stencil test and the depth test pass, or when the stencil test passes and either there is no depth buffer or depth testing is not enabled
function render.set_stencil_op(sfail, dpfail, dppass) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_cull_face#render.set_cull_face
---
---Specifies whether front- or back-facing polygons can be culled
---when polygon culling is enabled. Polygon culling is initially disabled.
---If mode is <code>render.FACE_FRONT_AND_BACK</code>, no polygons are drawn, but other
---primitives such as points and lines are drawn. The initial value for
---<code>face_type</code> is <code>render.FACE_BACK</code>.
---@param face_type constant face type  <code>render.FACE_FRONT</code>  <code>render.FACE_BACK</code>  <code>render.FACE_FRONT_AND_BACK</code> 
function render.set_cull_face(face_type) end

---Docs: https://defold.com/ref/stable/render/?q=render.set_polygon_offset#render.set_polygon_offset
---
---Sets the scale and units used to calculate depth values.
---If <code>render.STATE_POLYGON_OFFSET_FILL</code> is enabled, each fragment's depth value
---is offset from its interpolated value (depending on the depth value of the
---appropriate vertices). Polygon offset can be used when drawing decals, rendering
---hidden-line images etc.
---<code>factor</code> specifies a scale factor that is used to create a variable depth
---offset for each polygon. The initial value is <code>0</code>.
---<code>units</code> is multiplied by an implementation-specific value to create a
---constant depth offset. The initial value is <code>0</code>.
---The value of the offset is computed as <code>factor</code> &times; <code>DZ</code> + <code>r</code> &times; <code>units</code>
---<code>DZ</code> is a measurement of the depth slope of the polygon which is the change in z (depth)
---values divided by the change in either x or y coordinates, as you traverse a polygon.
---The depth values are in window coordinates, clamped to the range [0, 1].
---<code>r</code> is the smallest value that is guaranteed to produce a resolvable difference.
---It's value is an implementation-specific constant.
---The offset is added before the depth test is performed and before the
---value is written into the depth buffer.
---@param factor number polygon offset factor
---@param units number polygon offset units
function render.set_polygon_offset(factor, units) end

---Docs: https://defold.com/ref/stable/render/?q=render.get_width#render.get_width
---
---Returns the logical window width that is set in the "game.project" settings.
---Note that the actual window pixel size can change, either by device constraints
---or user input.
---@return number width specified window width (number)
function render.get_width() end

---Docs: https://defold.com/ref/stable/render/?q=render.get_height#render.get_height
---
---Returns the logical window height that is set in the "game.project" settings.
---Note that the actual window pixel size can change, either by device constraints
---or user input.
---@return number height specified window height
function render.get_height() end

---Docs: https://defold.com/ref/stable/render/?q=render.get_window_width#render.get_window_width
---
---Returns the actual physical window width.
---Note that this value might differ from the logical width that is set in the
---"game.project" settings.
---@return number width actual window width
function render.get_window_width() end

---Docs: https://defold.com/ref/stable/render/?q=render.get_window_height#render.get_window_height
---
---Returns the actual physical window height.
---Note that this value might differ from the logical height that is set in the
---"game.project" settings.
---@return number height actual window height
function render.get_window_height() end

---Docs: https://defold.com/ref/stable/render/?q=render.predicate#render.predicate
---
---This function returns a new render predicate for objects with materials matching
---the provided material tags. The provided tags are combined into a bit mask
---for the predicate. If multiple tags are provided, the predicate matches materials
---with all tags ANDed together.
---The current limit to the number of tags that can be defined is <code>64</code>.
---@param tags table table of tags that the predicate should match. The tags can be of either hash or string type
---@return predicate predicate new predicate
function render.predicate(tags) end

---Docs: https://defold.com/ref/stable/render/?q=render.enable_material#render.enable_material
---
---If another material was already enabled, it will be automatically disabled
---and the specified material is used instead.
---The name of the material must be specified in the ".render" resource set
---in the "game.project" setting.
---@param material_id string|hash material id to enable
function render.enable_material(material_id) end

---Docs: https://defold.com/ref/stable/render/?q=render.disable_material#render.disable_material
---
---If a material is currently enabled, disable it.
---The name of the material must be specified in the ".render" resource set
---in the "game.project" setting.
function render.disable_material() end

---Draw a text on the screen. This should be used for debugging purposes only.
---@class draw_debug_text_msg
---@field position vector3 position of the text
---@field text string the text to draw
---@field color vector4 color of the text

---Draw a line on the screen. This should mostly be used for debugging purposes.
---@class draw_line_msg
---@field start_point vector3 start point of the line
---@field end_point vector3 end point of the line
---@field color vector4 color of the line

---Reports a change in window size. This is initiated on window resize on desktop or by orientation changes
---on mobile devices.
---@class window_resized_msg
---@field height number the new window height
---@field width number the new window width

---Set the size of the game window. Only works on desktop platforms.
---@class resize_msg
---@field height number the new window height
---@field width number the new window width

---Set render clear color. This is the color that appears on the screen where nothing is rendered, i.e. background.
---@class clear_color_msg
---@field color vector4 color to use as clear color

---
render.STATE_DEPTH_TEST = nil

---
render.STATE_STENCIL_TEST = nil

---
render.STATE_BLEND = nil

---
render.STATE_CULL_FACE = nil

---
render.STATE_POLYGON_OFFSET_FILL = nil

---
render.FORMAT_LUMINANCE = nil

---
render.FORMAT_RGB = nil

---
render.FORMAT_RGBA = nil

---May be nil if the format isn't supported
render.FORMAT_RGB16F = nil

---May be nil if the format isn't supported
render.FORMAT_RGB32F = nil

---May be nil if the format isn't supported
render.FORMAT_RGBA16F = nil

---May be nil if the format isn't supported
render.FORMAT_RGBA32F = nil

---May be nil if the format isn't supported
render.FORMAT_R16F = nil

---May be nil if the format isn't supported
render.FORMAT_RG16F = nil

---May be nil if the format isn't supported
render.FORMAT_R32F = nil

---May be nil if the format isn't supported
render.FORMAT_RG32F = nil

---
render.FORMAT_DEPTH = nil

---
render.FORMAT_STENCIL = nil

---
render.FILTER_LINEAR = nil

---
render.FILTER_NEAREST = nil

---
render.WRAP_CLAMP_TO_BORDER = nil

---
render.WRAP_CLAMP_TO_EDGE = nil

---
render.WRAP_MIRRORED_REPEAT = nil

---
render.WRAP_REPEAT = nil

---
render.RENDER_TARGET_DEFAULT = nil

---
render.BUFFER_COLOR_BIT = nil

---
render.BUFFER_COLOR0_BIT = nil

---
render.BUFFER_COLOR1_BIT = nil

---
render.BUFFER_COLOR2_BIT = nil

---
render.BUFFER_COLOR3_BIT = nil

---
render.BUFFER_DEPTH_BIT = nil

---
render.BUFFER_STENCIL_BIT = nil

---
render.BLEND_ZERO = nil

---
render.BLEND_ONE = nil

---
render.BLEND_SRC_COLOR = nil

---
render.BLEND_ONE_MINUS_SRC_COLOR = nil

---
render.BLEND_DST_COLOR = nil

---
render.BLEND_ONE_MINUS_DST_COLOR = nil

---
render.BLEND_SRC_ALPHA = nil

---
render.BLEND_ONE_MINUS_SRC_ALPHA = nil

---
render.BLEND_DST_ALPHA = nil

---
render.BLEND_ONE_MINUS_DST_ALPHA = nil

---
render.BLEND_SRC_ALPHA_SATURATE = nil

---
render.BLEND_CONSTANT_COLOR = nil

---
render.BLEND_ONE_MINUS_CONSTANT_COLOR = nil

---
render.BLEND_CONSTANT_ALPHA = nil

---
render.BLEND_ONE_MINUS_CONSTANT_ALPHA = nil

---
render.COMPARE_FUNC_NEVER = nil

---
render.COMPARE_FUNC_LESS = nil

---
render.COMPARE_FUNC_LEQUAL = nil

---
render.COMPARE_FUNC_GREATER = nil

---
render.COMPARE_FUNC_GEQUAL = nil

---
render.COMPARE_FUNC_EQUAL = nil

---
render.COMPARE_FUNC_NOTEQUAL = nil

---
render.COMPARE_FUNC_ALWAYS = nil

---
render.STENCIL_OP_KEEP = nil

---
render.STENCIL_OP_ZERO = nil

---
render.STENCIL_OP_REPLACE = nil

---
render.STENCIL_OP_INCR = nil

---
render.STENCIL_OP_INCR_WRAP = nil

---
render.STENCIL_OP_DECR = nil

---
render.STENCIL_OP_DECR_WRAP = nil

---
render.STENCIL_OP_INVERT = nil

---
render.FACE_FRONT = nil

---
render.FACE_BACK = nil

---
render.FACE_FRONT_AND_BACK = nil

