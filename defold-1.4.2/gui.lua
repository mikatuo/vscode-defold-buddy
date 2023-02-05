---@meta

---GUI API documentation
---@class gui
gui = {}

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_node#gui.get_node
---
---Retrieves the node with the specified id.
---@param id string|hash id of the node to retrieve
---@return node instance a new node instance
function gui.get_node(id) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_id#gui.get_id
---
---Retrieves the id of the specified node.
---@param node node the node to retrieve the id from
---@return hash id the id of the node
function gui.get_id(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_id#gui.set_id
---
---Set the id of the specicied node to a new value.
---Nodes created with the gui.new_*_node() functions get
---an empty id. This function allows you to give dynamically
---created nodes an id.
---No checking is done on the uniqueness of supplied ids.
---It is up to you to make sure you use unique ids.
---@param node node node to set the id for
---@param id string|hash id to set
function gui.set_id(node, id) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_index#gui.get_index
---
---Retrieve the index of the specified node among its siblings.
---The index defines the order in which a node appear in a GUI scene.
---Higher index means the node is drawn on top of lower indexed nodes.
---@param node node the node to retrieve the id from
---@return number index the index of the node
function gui.get_index(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.delete_node#gui.delete_node
---
---Deletes the specified node. Any child nodes of the specified node will be
---recursively deleted.
---@param node node node to delete
function gui.delete_node(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.animate#gui.animate
---
---This starts an animation of a node property according to the specified parameters.
---If the node property is already being animated, that animation will be canceled and
---replaced by the new one. Note however that several different node properties
---can be animated simultaneously. Use <code>gui.cancel_animation</code> to stop the animation
---before it has completed.
---Composite properties of type vector3, vector4 or quaternion
---also expose their sub-components (x, y, z and w).
---You can address the components individually by suffixing the name with a dot '.'
---and the name of the component.
---For instance, <code>"position.x"</code> (the position x coordinate) or <code>"color.w"</code>
---(the color alpha value).
---If a <code>complete_function</code> (Lua function) is specified, that function will be called
---when the animation has completed.
---By starting a new animation in that function, several animations can be sequenced
---together. See the examples below for more information.
---@param node node node to animate
---@param property string|constant property to animate  <code>"position"</code>  <code>"rotation"</code>  <code>"scale"</code>  <code>"color"</code>  <code>"outline"</code>  <code>"shadow"</code>  <code>"size"</code>  <code>"fill_angle"</code> (pie)  <code>"inner_radius"</code> (pie)  <code>"slice9"</code> (slice9)  The following property constants are defined equaling the corresponding property string names.  <code>gui.PROP_POSITION</code>  <code>gui.PROP_ROTATION</code>  <code>gui.PROP_SCALE</code>  <code>gui.PROP_COLOR</code>  <code>gui.PROP_OUTLINE</code>  <code>gui.PROP_SHADOW</code>  <code>gui.PROP_SIZE</code>  <code>gui.PROP_FILL_ANGLE</code>  <code>gui.PROP_INNER_RADIUS</code>  <code>gui.PROP_SLICE9</code> 
---@param to vector3|vector4 target property value
---@param easing constant|vector easing to use during animation.      Either specify one of the <code>gui.EASING_*</code> constants or provide a      vector with a custom curve. See the animation guide for more information.
---@param duration number duration of the animation in seconds.
---@param delay number|nil delay before the animation starts in seconds.
---@param complete_function fun(self, node)|nil function to call when the
---@param playback constant|nil playback mode  <code>gui.PLAYBACK_ONCE_FORWARD</code>  <code>gui.PLAYBACK_ONCE_BACKWARD</code>  <code>gui.PLAYBACK_ONCE_PINGPONG</code>  <code>gui.PLAYBACK_LOOP_FORWARD</code>  <code>gui.PLAYBACK_LOOP_BACKWARD</code>  <code>gui.PLAYBACK_LOOP_PINGPONG</code> 
---@overload fun(node: node, property: string|constant, to: vector3|vector4, easing: constant|vector, duration: number)
---@overload fun(node: node, property: string|constant, to: vector3|vector4, easing: constant|vector, duration: number, delay: number|nil)
---@overload fun(node: node, property: string|constant, to: vector3|vector4, easing: constant|vector, duration: number, delay: number|nil, complete_function: fun(self, node)|nil)
function gui.animate(node, property, to, easing, duration, delay, complete_function, playback) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.cancel_animation#gui.cancel_animation
---
---If an animation of the specified node is currently running (started by <code>gui.animate</code>), it will immediately be canceled.
---@param node node node that should have its animation canceled
---@param property string|constant property for which the animation should be canceled  <code>"position"</code>  <code>"rotation"</code>  <code>"scale"</code>  <code>"color"</code>  <code>"outline"</code>  <code>"shadow"</code>  <code>"size"</code>  <code>"fill_angle"</code> (pie)  <code>"inner_radius"</code> (pie)  <code>"slice9"</code> (slice9) 
function gui.cancel_animation(node, property) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.new_box_node#gui.new_box_node
---
---Dynamically create a new box node.
---@param pos vector3|vector4 node position
---@param size vector3 node size
---@return node node new box node
function gui.new_box_node(pos, size) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.new_text_node#gui.new_text_node
---
---Dynamically create a new text node.
---@param pos vector3|vector4 node position
---@param text string node text
---@return node node new text node
function gui.new_text_node(pos, text) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.new_pie_node#gui.new_pie_node
---
---Dynamically create a new pie node.
---@param pos vector3|vector4 node position
---@param size vector3 node size
---@return node node new pie node
function gui.new_pie_node(pos, size) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_text#gui.get_text
---
---Returns the text value of a text node. This is only useful for text nodes.
---@param node node node from which to get the text
---@return string text text value
function gui.get_text(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_text#gui.set_text
---
---Set the text value of a text node. This is only useful for text nodes.
---@param node node node to set text for
---@param text string text to set
function gui.set_text(node, text) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_line_break#gui.get_line_break
---
---Returns whether a text node is in line-break mode or not.
---This is only useful for text nodes.
---@param node node node from which to get the line-break for
---@return boolean line_break <code>true</code> or <code>false</code>
function gui.get_line_break(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_line_break#gui.set_line_break
---
---Sets the line-break mode on a text node.
---This is only useful for text nodes.
---@param node node node to set line-break for
---@param line_break boolean true or false
function gui.set_line_break(node, line_break) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_blend_mode#gui.get_blend_mode
---
---Returns the blend mode of a node.
---Blend mode defines how the node will be blended with the background.
---@param node node node from which to get the blend mode
---@return constant blend_mode blend mode  <code>gui.BLEND_ALPHA</code>  <code>gui.BLEND_ADD</code>  <code>gui.BLEND_ADD_ALPHA</code>  <code>gui.BLEND_MULT</code> 
function gui.get_blend_mode(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_blend_mode#gui.set_blend_mode
---
---Set the blend mode of a node.
---Blend mode defines how the node will be blended with the background.
---@param node node node to set blend mode for
---@param blend_mode constant blend mode to set  <code>gui.BLEND_ALPHA</code>  <code>gui.BLEND_ADD</code>  <code>gui.BLEND_ADD_ALPHA</code>  <code>gui.BLEND_MULT</code> 
function gui.set_blend_mode(node, blend_mode) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_texture#gui.get_texture
---
---Returns the texture of a node.
---This is currently only useful for box or pie nodes.
---The texture must be mapped to the gui scene in the gui editor.
---@param node node node to get texture from
---@return hash texture texture id
function gui.get_texture(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_texture#gui.set_texture
---
---Set the texture on a box or pie node. The texture must be mapped to
---the gui scene in the gui editor. The function points out which texture
---the node should render from. If the texture is an atlas, further
---information is needed to select which image/animation in the atlas
---to render. In such cases, use <code>gui.play_flipbook()</code> in
---addition to this function.
---@param node node node to set texture for
---@param texture string|hash texture id
function gui.set_texture(node, texture) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_flipbook#gui.get_flipbook
---
---Get node flipbook animation.
---@param node node node to get flipbook animation from
---@return hash animation animation id
function gui.get_flipbook(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.play_flipbook#gui.play_flipbook
---
---Play flipbook animation on a box or pie node.
---The current node texture must contain the animation.
---Use this function to set one-frame still images on the node.
---@param node node node to set animation for
---@param animation string|hash animation id
---@param complete_function fun(self:object, node:node)|nil optional function to call when the animation has completed
---@param play_properties {offset:number, playback_rate:number}|nil optional table with properties
---@overload fun(node: node, animation: string|hash)
---@overload fun(node: node, animation: string|hash, complete_function: fun(self:object, node:node)|nil)
function gui.play_flipbook(node, animation, complete_function, play_properties) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.cancel_flipbook#gui.cancel_flipbook
---
---Cancels any running flipbook animation on the specified node.
---@param node node node cancel flipbook animation for
function gui.cancel_flipbook(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.new_texture#gui.new_texture
---
---Dynamically create a new texture.
---@param texture string|hash texture id
---@param width number texture width
---@param height number texture height
---@param type string|constant texture type  <code>"rgb"</code> - RGB  <code>"rgba"</code> - RGBA  <code>"l"</code> - LUMINANCE 
---@param buffer string texture data
---@param flip boolean flip texture vertically
---@return boolean success texture creation was successful
---@return number code one of the gui.RESULT_* codes if unsuccessful
function gui.new_texture(texture, width, height, type, buffer, flip) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.delete_texture#gui.delete_texture
---
---Delete a dynamically created texture.
---@param texture string|hash texture id
function gui.delete_texture(texture) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_texture_data#gui.set_texture_data
---
---Set the texture buffer data for a dynamically created texture.
---@param texture string|hash texture id
---@param width number texture width
---@param height number texture height
---@param type string|constant texture type    <code>"rgb"</code> - RGB   <code>"rgba"</code> - RGBA   <code>"l"</code> - LUMINANCE 
---@param buffer string texture data
---@param flip boolean flip texture vertically
---@return boolean success setting the data was successful
function gui.set_texture_data(texture, width, height, type, buffer, flip) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_font#gui.get_font
---
---This is only useful for text nodes. The font must be mapped to the gui scene in the gui editor.
---@param node node node from which to get the font
---@return hash font font id
function gui.get_font(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_font_resource#gui.get_font_resource
---
---This is only useful for text nodes. The font must be mapped to the gui scene in the gui editor.
---@param font_name hash|string font of which to get the path hash
---@return hash hash path hash to resource
function gui.get_font_resource(font_name) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_font#gui.set_font
---
---This is only useful for text nodes.
---The font must be mapped to the gui scene in the gui editor.
---@param node node node for which to set the font
---@param font string|hash font id
function gui.set_font(node, font) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_layer#gui.get_layer
---
---The layer must be mapped to the gui scene in the gui editor.
---@param node node node from which to get the layer
---@return hash layer layer id
function gui.get_layer(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_layer#gui.set_layer
---
---The layer must be mapped to the gui scene in the gui editor.
---@param node node node for which to set the layer
---@param layer string|hash layer id
function gui.set_layer(node, layer) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_layout#gui.get_layout
---
---gets the scene current layout
---@return hash layout layout id
function gui.get_layout() end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_clipping_mode#gui.get_clipping_mode
---
---Clipping mode defines how the node will clip it's children nodes
---@param node node node from which to get the clipping mode
---@return constant clipping_mode clipping mode    <code>gui.CLIPPING_MODE_NONE</code>   <code>gui.CLIPPING_MODE_STENCIL</code> 
function gui.get_clipping_mode(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_clipping_mode#gui.set_clipping_mode
---
---Clipping mode defines how the node will clip it's children nodes
---@param node node node to set clipping mode for
---@param clipping_mode constant clipping mode to set    <code>gui.CLIPPING_MODE_NONE</code>   <code>gui.CLIPPING_MODE_STENCIL</code> 
function gui.set_clipping_mode(node, clipping_mode) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_clipping_visible#gui.get_clipping_visible
---
---If node is set as visible clipping node, it will be shown as well as clipping. Otherwise, it will only clip but not show visually.
---@param node node node from which to get the clipping visibility state
---@return boolean visible true or false
function gui.get_clipping_visible(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_clipping_visible#gui.set_clipping_visible
---
---If node is set as an visible clipping node, it will be shown as well as clipping. Otherwise, it will only clip but not show visually.
---@param node node node to set clipping visibility for
---@param visible boolean true or false
function gui.set_clipping_visible(node, visible) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_clipping_inverted#gui.get_clipping_inverted
---
---If node is set as an inverted clipping node, it will clip anything inside as opposed to outside.
---@param node node node from which to get the clipping inverted state
---@return boolean inverted true or false
function gui.get_clipping_inverted(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_clipping_inverted#gui.set_clipping_inverted
---
---If node is set as an inverted clipping node, it will clip anything inside as opposed to outside.
---@param node node node to set clipping inverted state for
---@param inverted boolean true or false
function gui.set_clipping_inverted(node, inverted) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_xanchor#gui.get_xanchor
---
---The x-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node node to get x-anchor from
---@return constant anchor anchor constant  <code>gui.ANCHOR_NONE</code>  <code>gui.ANCHOR_LEFT</code>  <code>gui.ANCHOR_RIGHT</code> 
function gui.get_xanchor(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_xanchor#gui.set_xanchor
---
---The x-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node node to set x-anchor for
---@param anchor constant anchor constant  <code>gui.ANCHOR_NONE</code>  <code>gui.ANCHOR_LEFT</code>  <code>gui.ANCHOR_RIGHT</code> 
function gui.set_xanchor(node, anchor) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_yanchor#gui.get_yanchor
---
---The y-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node node to get y-anchor from
---@return constant anchor anchor constant  <code>gui.ANCHOR_NONE</code>  <code>gui.ANCHOR_TOP</code>  <code>gui.ANCHOR_BOTTOM</code> 
function gui.get_yanchor(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_yanchor#gui.set_yanchor
---
---The y-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node node to set y-anchor for
---@param anchor constant anchor constant  <code>gui.ANCHOR_NONE</code>  <code>gui.ANCHOR_TOP</code>  <code>gui.ANCHOR_BOTTOM</code> 
function gui.set_yanchor(node, anchor) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_pivot#gui.get_pivot
---
---The pivot specifies how the node is drawn and rotated from its position.
---@param node node node to get pivot from
---@return constant pivot pivot constant    <code>gui.PIVOT_CENTER</code>   <code>gui.PIVOT_N</code>   <code>gui.PIVOT_NE</code>   <code>gui.PIVOT_E</code>   <code>gui.PIVOT_SE</code>   <code>gui.PIVOT_S</code>   <code>gui.PIVOT_SW</code>   <code>gui.PIVOT_W</code>   <code>gui.PIVOT_NW</code> 
function gui.get_pivot(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_pivot#gui.set_pivot
---
---The pivot specifies how the node is drawn and rotated from its position.
---@param node node node to set pivot for
---@param pivot constant pivot constant    <code>gui.PIVOT_CENTER</code>   <code>gui.PIVOT_N</code>   <code>gui.PIVOT_NE</code>   <code>gui.PIVOT_E</code>   <code>gui.PIVOT_SE</code>   <code>gui.PIVOT_S</code>   <code>gui.PIVOT_SW</code>   <code>gui.PIVOT_W</code>   <code>gui.PIVOT_NW</code> 
function gui.set_pivot(node, pivot) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_width#gui.get_width
---
---Returns the scene width.
---@return number width scene width
function gui.get_width() end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_height#gui.get_height
---
---Returns the scene height.
---@return number height scene height
function gui.get_height() end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_slice9#gui.set_slice9
---
---Set the slice9 configuration values for the node.
---@param node node node to manipulate
---@param values vector4 new values
function gui.set_slice9(node, values) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_slice9#gui.get_slice9
---
---Returns the slice9 configuration values for the node.
---@param node node node to manipulate
---@return vector4 values configuration values
function gui.get_slice9(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_perimeter_vertices#gui.set_perimeter_vertices
---
---Sets the number of generated vertices around the perimeter of a pie node.
---@param node node pie node
---@param vertices number vertex count
function gui.set_perimeter_vertices(node, vertices) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_perimeter_vertices#gui.get_perimeter_vertices
---
---Returns the number of generated vertices around the perimeter
---of a pie node.
---@param node node pie node
---@return number vertices vertex count
function gui.get_perimeter_vertices(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_fill_angle#gui.set_fill_angle
---
---Set the sector angle of a pie node.
---@param node node node to set the fill angle for
---@param angle number sector angle
function gui.set_fill_angle(node, angle) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_fill_angle#gui.get_fill_angle
---
---Returns the sector angle of a pie node.
---@param node node node from which to get the fill angle
---@return number angle sector angle
function gui.get_fill_angle(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_inner_radius#gui.set_inner_radius
---
---Sets the inner radius of a pie node.
---The radius is defined along the x-axis.
---@param node node node to set the inner radius for
---@param radius number inner radius
function gui.set_inner_radius(node, radius) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_inner_radius#gui.get_inner_radius
---
---Returns the inner radius of a pie node.
---The radius is defined along the x-axis.
---@param node node node from where to get the inner radius
---@return number radius inner radius
function gui.get_inner_radius(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_outer_bounds#gui.set_outer_bounds
---
---Sets the outer bounds mode for a pie node.
---@param node node node for which to set the outer bounds mode
---@param bounds_mode constant the outer bounds mode of the pie node:  <code>gui.PIEBOUNDS_RECTANGLE</code>  <code>gui.PIEBOUNDS_ELLIPSE</code> 
function gui.set_outer_bounds(node, bounds_mode) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_outer_bounds#gui.get_outer_bounds
---
---Returns the outer bounds mode for a pie node.
---@param node node node from where to get the outer bounds mode
---@return constant bounds_mode the outer bounds mode of the pie node:  <code>gui.PIEBOUNDS_RECTANGLE</code>  <code>gui.PIEBOUNDS_ELLIPSE</code> 
function gui.get_outer_bounds(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_leading#gui.set_leading
---
---Sets the leading value for a text node. This value is used to
---scale the line spacing of text.
---@param node node node for which to set the leading
---@param leading number a scaling value for the line spacing (default=1)
function gui.set_leading(node, leading) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_leading#gui.get_leading
---
---Returns the leading value for a text node.
---@param node node node from where to get the leading
---@return number leading leading scaling value (default=1)
function gui.get_leading(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_tracking#gui.set_tracking
---
---Sets the tracking value of a text node. This value is used to
---adjust the vertical spacing of characters in the text.
---@param node node node for which to set the tracking
---@param tracking number a scaling number for the letter spacing (default=0)
function gui.set_tracking(node, tracking) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_tracking#gui.get_tracking
---
---Returns the tracking value of a text node.
---@param node node node from where to get the tracking
---@return number tracking tracking scaling number (default=0)
function gui.get_tracking(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.pick_node#gui.pick_node
---
---Tests whether a coordinate is within the bounding box of a
---node.
---@param node node node to be tested for picking
---@param x number x-coordinate (see on_input )
---@param y number y-coordinate (see on_input )
---@return boolean pickable pick result
function gui.pick_node(node, x, y) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.is_enabled#gui.is_enabled
---
---Returns <code>true</code> if a node is enabled and <code>false</code> if it's not.
---Disabled nodes are not rendered and animations acting on them are not evaluated.
---@param node node node to query
---@param recursive boolean check hierarchy recursively
---@return boolean enabled whether the node is enabled or not
function gui.is_enabled(node, recursive) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_enabled#gui.set_enabled
---
---Sets a node to the disabled or enabled state.
---Disabled nodes are not rendered and animations acting on them are not evaluated.
---@param node node node to be enabled/disabled
---@param enabled boolean whether the node should be enabled or not
function gui.set_enabled(node, enabled) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_visible#gui.get_visible
---
---Returns <code>true</code> if a node is visible and <code>false</code> if it's not.
---Invisible nodes are not rendered.
---@param node node node to query
---@return boolean visible whether the node is visible or not
function gui.get_visible(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_visible#gui.set_visible
---
---Set if a node should be visible or not. Only visible nodes are rendered.
---@param node node node to be visible or not
---@param visible boolean whether the node should be visible or not
function gui.set_visible(node, visible) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_adjust_mode#gui.get_adjust_mode
---
---Returns the adjust mode of a node.
---The adjust mode defines how the node will adjust itself to screen
---resolutions that differs from the one in the project settings.
---@param node node node from which to get the adjust mode (node)
---@return constant adjust_mode the current adjust mode  <code>gui.ADJUST_FIT</code>  <code>gui.ADJUST_ZOOM</code>  <code>gui.ADJUST_STRETCH</code> 
function gui.get_adjust_mode(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_adjust_mode#gui.set_adjust_mode
---
---Sets the adjust mode on a node.
---The adjust mode defines how the node will adjust itself to screen
---resolutions that differs from the one in the project settings.
---@param node node node to set adjust mode for
---@param adjust_mode constant adjust mode to set  <code>gui.ADJUST_FIT</code>  <code>gui.ADJUST_ZOOM</code>  <code>gui.ADJUST_STRETCH</code> 
function gui.set_adjust_mode(node, adjust_mode) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_size_mode#gui.get_size_mode
---
---Returns the size of a node.
---The size mode defines how the node will adjust itself in size. Automatic
---size mode alters the node size based on the node's content. Automatic size
---mode works for Box nodes and Pie nodes which will both adjust their size
---to match the assigned image. Particle fx and Text nodes will ignore
---any size mode setting.
---@param node node node from which to get the size mode (node)
---@return constant size_mode the current size mode  <code>gui.SIZE_MODE_MANUAL</code>  <code>gui.SIZE_MODE_AUTO</code> 
function gui.get_size_mode(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_size_mode#gui.set_size_mode
---
---Sets the size mode of a node.
---The size mode defines how the node will adjust itself in size. Automatic
---size mode alters the node size based on the node's content. Automatic size
---mode works for Box nodes and Pie nodes which will both adjust their size
---to match the assigned image. Particle fx and Text nodes will ignore
---any size mode setting.
---@param node node node to set size mode for
---@param size_mode constant size mode to set  <code>gui.SIZE_MODE_MANUAL</code>  <code>gui.SIZE_MODE_AUTO</code> 
function gui.set_size_mode(node, size_mode) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.move_above#gui.move_above
---
---Alters the ordering of the two supplied nodes by moving the first node
---above the second.
---If the second argument is <code>nil</code> the first node is moved to the top.
---@param node node to move
---@param node node|nil reference node above which the first node should be moved
function gui.move_above(node, node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.move_below#gui.move_below
---
---Alters the ordering of the two supplied nodes by moving the first node
---below the second.
---If the second argument is <code>nil</code> the first node is moved to the bottom.
---@param node node to move
---@param node node|nil reference node below which the first node should be moved
function gui.move_below(node, node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_parent#gui.get_parent
---
---Returns the parent node of the specified node.
---If the supplied node does not have a parent, <code>nil</code> is returned.
---@param node node the node from which to retrieve its parent
---@return node parent parent instance or nil
function gui.get_parent(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_parent#gui.set_parent
---
---Sets the parent node of the specified node.
---@param node node node for which to set its parent
---@param parent node parent node to set
---@param keep_scene_transform boolean optional flag to make the scene position being perserved
function gui.set_parent(node, parent, keep_scene_transform) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.clone#gui.clone
---
---Make a clone instance of a node.
---This function does not clone the supplied node's children nodes.
---Use gui.clone_tree for that purpose.
---@param node node node to clone
---@return node clone the cloned node
function gui.clone(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.clone_tree#gui.clone_tree
---
---Make a clone instance of a node and all its children.
---Use gui.clone to clone a node excluding its children.
---@param node node root node to clone
---@return table clones a table mapping node ids to the corresponding cloned nodes
function gui.clone_tree(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.reset_nodes#gui.reset_nodes
---
---Resets all nodes in the current GUI scene to their initial state.
---The reset only applies to static node loaded from the scene.
---Nodes that are created dynamically from script are not affected.
function gui.reset_nodes() end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_render_order#gui.set_render_order
---
---Set the order number for the current GUI scene.
---The number dictates the sorting of the "gui" render predicate,
---in other words in which order the scene will be rendered in relation
---to other currently rendered GUI scenes.
---The number must be in the range 0 to 15.
---@param order number rendering order (0-15)
function gui.set_render_order(order) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.show_keyboard#gui.show_keyboard
---
---Shows the on-display touch keyboard.
---The specified type of keyboard is displayed if it is available on
---the device.
---This function is only available on iOS and Android.  .
---@param type constant keyboard type  <code>gui.KEYBOARD_TYPE_DEFAULT</code>  <code>gui.KEYBOARD_TYPE_EMAIL</code>  <code>gui.KEYBOARD_TYPE_NUMBER_PAD</code>  <code>gui.KEYBOARD_TYPE_PASSWORD</code> 
---@param autoclose boolean if the keyboard should automatically close when clicking outside
function gui.show_keyboard(type, autoclose) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.hide_keyboard#gui.hide_keyboard
---
---Hides the on-display touch keyboard on the device.
function gui.hide_keyboard() end

---Docs: https://defold.com/ref/stable/gui/?q=gui.reset_keyboard#gui.reset_keyboard
---
---Resets the input context of keyboard. This will clear marked text.
function gui.reset_keyboard() end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_position#gui.get_position
---
---Returns the position of the supplied node.
---@param node node node to get the position from
---@return vector3 position node position
function gui.get_position(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_position#gui.set_position
---
---Sets the position of the supplied node.
---@param node node node to set the position for
---@param position vector3|vector4 new position
function gui.set_position(node, position) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_rotation#gui.get_rotation
---
---Returns the rotation of the supplied node.
---The rotation is expressed in degree Euler angles.
---@param node node node to get the rotation from
---@return vector3 rotation node rotation
function gui.get_rotation(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_rotation#gui.set_rotation
---
---Sets the rotation of the supplied node.
---The rotation is expressed in degree Euler angles.
---@param node node node to set the rotation for
---@param rotation vector3|vector4 new rotation
function gui.set_rotation(node, rotation) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_scale#gui.get_scale
---
---Returns the scale of the supplied node.
---@param node node node to get the scale from
---@return vector3 scale node scale
function gui.get_scale(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_scale#gui.set_scale
---
---Sets the scaling of the supplied node.
---@param node node node to set the scale for
---@param scale vector3|vector4 new scale
function gui.set_scale(node, scale) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_color#gui.get_color
---
---Returns the color of the supplied node. The components
---of the returned vector4 contains the color channel values:
---
---
---
---Component
---Color value
---
---
---
---
---x
---Red value
---
---
---y
---Green value
---
---
---z
---Blue value
---
---
---w
---Alpha value
---
---
---
---@param node node node to get the color from
---@return vector4 color node color
function gui.get_color(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_color#gui.set_color
---
---Sets the color of the supplied node. The components
---of the supplied vector3 or vector4 should contain the color channel values:
---
---
---
---Component
---Color value
---
---
---
---
---x
---Red value
---
---
---y
---Green value
---
---
---z
---Blue value
---
---
---w vector4
---Alpha value
---
---
---
---@param node node node to set the color for
---@param color vector3|vector4 new color
function gui.set_color(node, color) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_outline#gui.get_outline
---
---Returns the outline color of the supplied node.
---See gui.get_color for info how vectors encode color values.
---@param node node node to get the outline color from
---@return vector4 color outline color
function gui.get_outline(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_outline#gui.set_outline
---
---Sets the outline color of the supplied node.
---See gui.set_color for info how vectors encode color values.
---@param node node node to set the outline color for
---@param color vector3|vector4 new outline color
function gui.set_outline(node, color) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_shadow#gui.get_shadow
---
---Returns the shadow color of the supplied node.
---See gui.get_color for info how vectors encode color values.
---@param node node node to get the shadow color from
---@return vector4 color node shadow color
function gui.get_shadow(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_shadow#gui.set_shadow
---
---Sets the shadow color of the supplied node.
---See gui.set_color for info how vectors encode color values.
---@param node node node to set the shadow color for
---@param color vector3|vector4 new shadow color
function gui.set_shadow(node, color) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_size#gui.set_size
---
---Sets the size of the supplied node.
---You can only set size on nodes with size mode set to SIZE_MODE_MANUAL
---@param node node node to set the size for
---@param size vector3|vector4 new size
function gui.set_size(node, size) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_size#gui.get_size
---
---Returns the size of the supplied node.
---@param node node node to get the size from
---@return vector3 size node size
function gui.get_size(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_screen_position#gui.get_screen_position
---
---Returns the screen position of the supplied node. This function returns the
---calculated transformed position of the node, taking into account any parent node
---transforms.
---@param node node node to get the screen position from
---@return vector3 position node screen position
function gui.get_screen_position(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_screen_position#gui.set_screen_position
---
---Set the screen position to the supplied node
---@param node node node to set the screen position to
---@param screen_position vector3 screen position
function gui.set_screen_position(node, screen_position) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.screen_to_local#gui.screen_to_local
---
---Convert the screen position to the local position of supplied node
---@param node node node used for getting local transformation matrix
---@param screen_position vector3 screen position
---@return vector3 local_position local position
function gui.screen_to_local(node, screen_position) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_flipbook_cursor#gui.get_flipbook_cursor
---
---This is only useful nodes with flipbook animations. Gets the normalized cursor of the flipbook animation on a node.
---@param node node node to get the cursor for (node)
---@return  cursor value number cursor value
function gui.get_flipbook_cursor(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_flipbook_cursor#gui.set_flipbook_cursor
---
---This is only useful nodes with flipbook animations. The cursor is normalized.
---@param node node node to set the cursor for
---@param cursor number cursor value
function gui.set_flipbook_cursor(node, cursor) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_flipbook_playback_rate#gui.get_flipbook_playback_rate
---
---This is only useful nodes with flipbook animations. Gets the playback rate of the flipbook animation on a node.
---@param node node node to set the cursor for
---@return number rate playback rate
function gui.get_flipbook_playback_rate(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_flipbook_playback_rate#gui.set_flipbook_playback_rate
---
---This is only useful nodes with flipbook animations. Sets the playback rate of the flipbook animation on a node. Must be positive.
---@param node node node to set the cursor for
---@param playback_rate number playback rate
function gui.set_flipbook_playback_rate(node, playback_rate) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.new_particlefx_node#gui.new_particlefx_node
---
---Dynamically create a particle fx node.
---@param pos vector3|vector4 node position
---@param particlefx hash|string particle fx resource name
---@return node node new particle fx node
function gui.new_particlefx_node(pos, particlefx) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.play_particlefx#gui.play_particlefx
---
---Plays the paricle fx for a gui node
---@param node node node to play particle fx for
---@param emitter_state_function fun(self:object, node:hash, emitter:hash, state:constant)|nil optional callback function that will be called when an emitter attached to this particlefx changes state.
---@overload fun(node: node)
function gui.play_particlefx(node, emitter_state_function) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.stop_particlefx#gui.stop_particlefx
---
---Stops the particle fx for a gui node
---@param node node node to stop particle fx for
---@param options {clear:boolean} options when stopping the particle fx. Supported options
function gui.stop_particlefx(node, options) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_particlefx#gui.set_particlefx
---
---Set the paricle fx for a gui node
---@param node node node to set particle fx for
---@param particlefx hash|string particle fx id
function gui.set_particlefx(node, particlefx) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_particlefx#gui.get_particlefx
---
---Get the paricle fx for a gui node
---@param node node node to get particle fx for
---@return hash  particle fx id
function gui.get_particlefx(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_inherit_alpha#gui.get_inherit_alpha
---
---gets the node inherit alpha state
---@param node node node from which to get the inherit alpha state
function gui.get_inherit_alpha(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_inherit_alpha#gui.set_inherit_alpha
---
---sets the node inherit alpha state
---@param node node node from which to set the inherit alpha state
---@param inherit_alpha boolean true or false
function gui.set_inherit_alpha(node, inherit_alpha) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.get_alpha#gui.get_alpha
---
---gets the node alpha
---@param node node node from which to get alpha
function gui.get_alpha(node) end

---Docs: https://defold.com/ref/stable/gui/?q=gui.set_alpha#gui.set_alpha
---
---sets the node alpha
---@param node node node for which to set alpha
---@param alpha number 0..1 alpha color
function gui.set_alpha(node, alpha) end

---Docs: https://defold.com/ref/stable/gui/?q=init#init
---
---This is a callback-function, which is called by the engine when a gui component is initialized. It can be used
---to set the initial state of the script and gui scene.
---@param self object reference to the script state to be used for storing data
function init(self) end

---Docs: https://defold.com/ref/stable/gui/?q=final#final
---
---This is a callback-function, which is called by the engine when a gui component is finalized (destroyed). It can
---be used to e.g. take some last action, report the finalization to other game object instances
---or release user input focus (see <code>release_input_focus</code>). There is no use in starting any animations or similar
---from this function since the gui component is about to be destroyed.
---@param self object reference to the script state to be used for storing data
function final(self) end

---Docs: https://defold.com/ref/stable/gui/?q=update#update
---
---This is a callback-function, which is called by the engine every frame to update the state of a gui component.
---It can be used to perform any kind of gui related tasks, e.g. animating nodes.
---@param self object reference to the script state to be used for storing data
---@param dt number the time-step of the frame update
function update(self, dt) end

---Docs: https://defold.com/ref/stable/gui/?q=on_message#on_message
---
---This is a callback-function, which is called by the engine whenever a message has been sent to the gui component.
---It can be used to take action on the message, e.g. update the gui or send a response back to the sender of the message.
---The <code>message</code> parameter is a table containing the message data. If the message is sent from the engine, the
---documentation of the message specifies which data is supplied.
---See the update function for examples on how to use this callback-function.
---@param self object reference to the script state to be used for storing data
---@param message_id hash id of the received message
---@param message table a table containing the message data
function on_message(self, message_id, message) end

---Docs: https://defold.com/ref/stable/gui/?q=on_input#on_input
---
---This is a callback-function, which is called by the engine when user input is sent to the instance of the gui component.
---It can be used to take action on the input, e.g. modify the gui according to the input.
---For an instance to obtain user input, it must first acquire input
---focus through the message <code>acquire_input_focus</code>.
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

---Docs: https://defold.com/ref/stable/gui/?q=on_reload#on_reload
---
---
---This is a callback-function, which is called by the engine when the gui script is reloaded, e.g. from the editor.
---It can be used for live development, e.g. to tweak constants or set up the state properly for the script.
---
---@param self object reference to the script state to be used for storing data
function on_reload(self) end

---This message is broadcast to every GUI component when a layout change has been initiated
---on device.
---@class layout_changed_msg
---@field id hash the id of the layout the engine is changing to
---@field previous_id hash the id of the layout the engine is changing from

---once forward
gui.PLAYBACK_ONCE_FORWARD = nil

---once backward
gui.PLAYBACK_ONCE_BACKWARD = nil

---once forward and then backward
gui.PLAYBACK_ONCE_PINGPONG = nil

---loop forward
gui.PLAYBACK_LOOP_FORWARD = nil

---loop backward
gui.PLAYBACK_LOOP_BACKWARD = nil

---ping pong loop
gui.PLAYBACK_LOOP_PINGPONG = nil

---linear interpolation
gui.EASING_LINEAR = nil

---in-quadratic
gui.EASING_INQUAD = nil

---out-quadratic
gui.EASING_OUTQUAD = nil

---in-out-quadratic
gui.EASING_INOUTQUAD = nil

---out-in-quadratic
gui.EASING_OUTINQUAD = nil

---in-cubic
gui.EASING_INCUBIC = nil

---out-cubic
gui.EASING_OUTCUBIC = nil

---in-out-cubic
gui.EASING_INOUTCUBIC = nil

---out-in-cubic
gui.EASING_OUTINCUBIC = nil

---in-quartic
gui.EASING_INQUART = nil

---out-quartic
gui.EASING_OUTQUART = nil

---in-out-quartic
gui.EASING_INOUTQUART = nil

---out-in-quartic
gui.EASING_OUTINQUART = nil

---in-quintic
gui.EASING_INQUINT = nil

---out-quintic
gui.EASING_OUTQUINT = nil

---in-out-quintic
gui.EASING_INOUTQUINT = nil

---out-in-quintic
gui.EASING_OUTINQUINT = nil

---in-sine
gui.EASING_INSINE = nil

---out-sine
gui.EASING_OUTSINE = nil

---in-out-sine
gui.EASING_INOUTSINE = nil

---out-in-sine
gui.EASING_OUTINSINE = nil

---in-exponential
gui.EASING_INEXPO = nil

---out-exponential
gui.EASING_OUTEXPO = nil

---in-out-exponential
gui.EASING_INOUTEXPO = nil

---out-in-exponential
gui.EASING_OUTINEXPO = nil

---in-circlic
gui.EASING_INCIRC = nil

---out-circlic
gui.EASING_OUTCIRC = nil

---in-out-circlic
gui.EASING_INOUTCIRC = nil

---out-in-circlic
gui.EASING_OUTINCIRC = nil

---in-elastic
gui.EASING_INELASTIC = nil

---out-elastic
gui.EASING_OUTELASTIC = nil

---in-out-elastic
gui.EASING_INOUTELASTIC = nil

---out-in-elastic
gui.EASING_OUTINELASTIC = nil

---in-back
gui.EASING_INBACK = nil

---out-back
gui.EASING_OUTBACK = nil

---in-out-back
gui.EASING_INOUTBACK = nil

---out-in-back
gui.EASING_OUTINBACK = nil

---in-bounce
gui.EASING_INBOUNCE = nil

---out-bounce
gui.EASING_OUTBOUNCE = nil

---in-out-bounce
gui.EASING_INOUTBOUNCE = nil

---out-in-bounce
gui.EASING_OUTINBOUNCE = nil

---default keyboard
gui.KEYBOARD_TYPE_DEFAULT = nil

---number input keyboard
gui.KEYBOARD_TYPE_NUMBER_PAD = nil

---email keyboard
gui.KEYBOARD_TYPE_EMAIL = nil

---password keyboard
gui.KEYBOARD_TYPE_PASSWORD = nil

---position property
gui.PROP_POSITION = nil

---rotation property
gui.PROP_ROTATION = nil

---scale property
gui.PROP_SCALE = nil

---color property
gui.PROP_COLOR = nil

---outline color property
gui.PROP_OUTLINE = nil

---shadow color property
gui.PROP_SHADOW = nil

---size property
gui.PROP_SIZE = nil

---fill_angle property
gui.PROP_FILL_ANGLE = nil

---inner_radius property
gui.PROP_INNER_RADIUS = nil

---slice9 property
gui.PROP_SLICE9 = nil

---alpha blending
gui.BLEND_ALPHA = nil

---additive blending
gui.BLEND_ADD = nil

---additive alpha blending
gui.BLEND_ADD_ALPHA = nil

---multiply blending
gui.BLEND_MULT = nil

---clipping mode none
gui.CLIPPING_MODE_NONE = nil

---clipping mode stencil
gui.CLIPPING_MODE_STENCIL = nil

---left x-anchor
gui.ANCHOR_LEFT = nil

---right x-anchor
gui.ANCHOR_RIGHT = nil

---top y-anchor
gui.ANCHOR_TOP = nil

---bottom y-anchor
gui.ANCHOR_BOTTOM = nil

---no anchor
gui.ANCHOR_NONE = nil

---center pivot
gui.PIVOT_CENTER = nil

---north pivot
gui.PIVOT_N = nil

---north-east pivot
gui.PIVOT_NE = nil

---east pivot
gui.PIVOT_E = nil

---south-east pivot
gui.PIVOT_SE = nil

---south pivot
gui.PIVOT_S = nil

---south-west pivot
gui.PIVOT_SW = nil

---west pivot
gui.PIVOT_W = nil

---north-west pivot
gui.PIVOT_NW = nil

---Adjust mode is used when the screen resolution differs from the project settings.
---The fit mode ensures that the entire node is visible in the adjusted gui scene.
gui.ADJUST_FIT = nil

---Adjust mode is used when the screen resolution differs from the project settings.
---The zoom mode ensures that the node fills its entire area and might make the node exceed it.
gui.ADJUST_ZOOM = nil

---Adjust mode is used when the screen resolution differs from the project settings.
---The stretch mode ensures that the node is displayed as is in the adjusted gui scene, which might scale it non-uniformally.
gui.ADJUST_STRETCH = nil

---elliptical pie node bounds
gui.PIEBOUNDS_ELLIPSE = nil

---rectangular pie node bounds
gui.PIEBOUNDS_RECTANGLE = nil

---The size of the node is determined by the size set in the editor, the constructor or by gui.set_size()
gui.SIZE_MODE_MANUAL = nil

---The size of the node is determined by the currently assigned texture.
gui.SIZE_MODE_AUTO = nil

---The texture id already exists when trying to use gui.new_texture().
gui.RESULT_TEXTURE_ALREADY_EXISTS = nil

---The system is out of resources, for instance when trying to create a new
---texture using gui.new_texture().
gui.RESULT_OUT_OF_RESOURCES = nil

---The provided data is not in the expected format or is in some other way
---incorrect, for instance the image data provided to gui.new_texture().
gui.RESULT_DATA_ERROR = nil

