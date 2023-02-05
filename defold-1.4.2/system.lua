---@meta

---System API documentation
---@class sys
sys = {}

---Docs: https://defold.com/ref/stable/sys/?q=sys.save#sys.save
---
---The table can later be loaded by <code>sys.load</code>.
---Use <code>sys.get_save_file</code> to obtain a valid location for the file.
---Internally, this function uses a workspace buffer sized output file sized 512kb.
---This size reflects the output file size which must not exceed this limit.
---Additionally, the total number of rows that any one table may contain is limited to 65536
---(i.e. a 16 bit range). When tables are used to represent arrays, the values of
---keys are permitted to fall within a 32 bit range, supporting sparse arrays, however
---the limit on the total number of rows remains in effect.
---@param filename string file to write to
---@param table table lua table to save
---@return boolean success a boolean indicating if the table could be saved or not
function sys.save(filename, table) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.load#sys.load
---
---If the file exists, it must have been created by <code>sys.save</code> to be loaded.
---@param filename string file to read from
---@return table loaded lua table, which is empty if the file could not be found
function sys.load(filename) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_save_file#sys.get_save_file
---
---The save-file path is operating system specific and is typically located under the user's home directory.
---@param application_id string user defined id of the application, which helps define the location of the save-file
---@param file_name string file-name to get path for
---@return string path path to save-file
function sys.get_save_file(application_id, file_name) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_application_path#sys.get_application_path
---
---The path from which the application is run.
---@return string path path to application executable
function sys.get_application_path() end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_config_string#sys.get_config_string
---
---Get string config value from the game.project configuration file with optional default value
---@param key string key to get value for. The syntax is SECTION.KEY
---@param default_value string|nil (optional) default value to return if the value does not exist
---@overload fun(key: string): string
---@return string value config value as a string. default_value if the config key does not exist. nil if no default value was supplied.
function sys.get_config_string(key, default_value) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_config_int#sys.get_config_int
---
---Get integer config value from the game.project configuration file with optional default value
---@param key string key to get value for. The syntax is SECTION.KEY
---@param default_value integer|nil (optional) default value to return if the value does not exist
---@overload fun(key: string): integer
---@return integer value config value as an integer. default_value if the config key does not exist. 0 if no default value was supplied.
function sys.get_config_int(key, default_value) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_config_number#sys.get_config_number
---
---Get number config value from the game.project configuration file with optional default value
---@param key string key to get value for. The syntax is SECTION.KEY
---@param default_value number|nil (optional) default value to return if the value does not exist
---@overload fun(key: string): number
---@return number value config value as an number. default_value if the config key does not exist. 0 if no default value was supplied.
function sys.get_config_number(key, default_value) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.open_url#sys.open_url
---
---Open URL in default application, typically a browser
---@param url string url to open
---@param attributes table|nil table with attributes
---@overload fun(url: string): boolean
---@return boolean success a boolean indicating if the url could be opened or not
function sys.open_url(url, attributes) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.load_resource#sys.load_resource
---
---Loads a custom resource. Specify the full filename of the resource that you want
---to load. When loaded, the file data is returned as a string.
---If loading fails, the function returns nil plus the error message.
---In order for the engine to include custom resources in the build process, you need
---to specify them in the "custom_resources" key in your "game.project" settings file.
---You can specify single resource files or directories. If a directory is included
---in the resource list, all files and directories in that directory is recursively
---included:
---For example "main/data/,assets/level_data.json".
---@param filename string resource to load, full path
---@return string data loaded data, or <code>nil</code> if the resource could not be loaded
---@return string error the error message, or <code>nil</code> if no error occurred
function sys.load_resource(filename) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_sys_info#sys.get_sys_info
---
---Returns a table with system information.
---@param options table|nil optional options table
---@overload fun(): table
---@return table sys_info table with system information in the following fields:  <code>device_model</code> string  Only available on iOS and Android. <code>manufacturer</code> string  Only available on iOS and Android. <code>system_name</code> string The system name: "Darwin", "Linux", "Windows", "HTML5", "Android" or "iPhone OS" <code>system_version</code> string The system OS version. <code>api_version</code> string The API version on the system. <code>language</code> string Two character ISO-639 format, i.e. "en". <code>device_language</code> string Two character ISO-639 format (i.e. "sr") and, if applicable, followed by a dash (-) and an ISO 15924 script code (i.e. "sr-Cyrl" or "sr-Latn"). Reflects the device preferred language. <code>territory</code> string Two character ISO-3166 format, i.e. "US". <code>gmt_offset</code> number The current offset from GMT (Greenwich Mean Time), in minutes. <code>device_ident</code> string This value secured by OS.  "identifierForVendor" on iOS.  "android_id" on Android. On Android, you need to add <code>READ_PHONE_STATE</code> permission to be able to get this data. We don't use this permission in Defold. <code>user_agent</code> string  The HTTP user agent, i.e. "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/602.4.8 (KHTML, like Gecko) Version/10.0.3 Safari/602.4.8" 
function sys.get_sys_info(options) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_engine_info#sys.get_engine_info
---
---Returns a table with engine information.
---@return table engine_info table with engine information in the following fields:  <code>version</code> string The current Defold engine version, i.e. "1.2.96" <code>version_sha1</code> string The SHA1 for the current engine build, i.e. "0060183cce2e29dbd09c85ece83cbb72068ee050" <code>is_debug</code> boolean If the engine is a debug or release version 
function sys.get_engine_info() end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_application_info#sys.get_application_info
---
---Returns a table with application information for the requested app.
---On iOS, the <code>app_string</code> is an url scheme for the app that is queried. Your
---game needs to list the schemes that are queried in an <code>LSApplicationQueriesSchemes</code> array
---in a custom "Info.plist".
---On Android, the <code>app_string</code> is the package identifier for the app.
---@param app_string string platform specific string with application package or query, see above for details.
---@return table app_info table with application information in the following fields:  <code>installed</code> boolean <code>true</code> if the application is installed, <code>false</code> otherwise. 
function sys.get_application_info(app_string) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_ifaddrs#sys.get_ifaddrs
---
---Returns an array of tables with information on network interfaces.
---@return table ifaddrs an array of tables. Each table entry contain the following fields:  <code>name</code> string Interface name <code>address</code> string IP address.  might be <code>nil</code> if not available. <code>mac</code> string Hardware MAC address.  might be nil if not available. <code>up</code> boolean <code>true</code> if the interface is up (available to transmit and receive data), <code>false</code> otherwise. <code>running</code> boolean <code>true</code> if the interface is running, <code>false</code> otherwise. 
function sys.get_ifaddrs() end

---Docs: https://defold.com/ref/stable/sys/?q=sys.set_error_handler#sys.set_error_handler
---
---Set the Lua error handler function.
---The error handler is a function which is called whenever a lua runtime error occurs.
---@param error_handler fun(source:string, message:string, traceback:string) the function to be called on error
function sys.set_error_handler(error_handler) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.set_connectivity_host#sys.set_connectivity_host
---
---Sets the host that is used to check for network connectivity against.
---@param host string hostname to check against
function sys.set_connectivity_host(host) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.get_connectivity#sys.get_connectivity
---
---Returns the current network connectivity status
---on mobile platforms.
---On desktop, this function always return <code>sys.NETWORK_CONNECTED</code>.
---@return constant status network connectivity status:  <code>sys.NETWORK_DISCONNECTED</code> (no network connection is found)  <code>sys.NETWORK_CONNECTED_CELLULAR</code> (connected through mobile cellular)  <code>sys.NETWORK_CONNECTED</code> (otherwise, Wifi) 
function sys.get_connectivity() end

---Docs: https://defold.com/ref/stable/sys/?q=sys.exit#sys.exit
---
---Terminates the game application and reports the specified <code>code</code> to the OS.
---@param code number exit code to report to the OS, 0 means clean exit
function sys.exit(code) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.reboot#sys.reboot
---
---Reboots the game engine with a specified set of arguments.
---Arguments will be translated into command line arguments. Calling reboot
---function is equivalent to starting the engine with the same arguments.
---On startup the engine reads configuration from "game.project" in the
---project root.
---@param arg1 string argument 1
---@param arg2 string argument 2
---@param arg3 string argument 3
---@param arg4 string argument 4
---@param arg5 string argument 5
---@param arg6 string argument 6
function sys.reboot(arg1, arg2, arg3, arg4, arg5, arg6) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.set_vsync_swap_interval#sys.set_vsync_swap_interval
---
---Set the vsync swap interval. The interval with which to swap the front and back buffers
---in sync with vertical blanks (v-blank), the hardware event where the screen image is updated
---with data from the front buffer. A value of 1 swaps the buffers at every v-blank, a value of
---2 swaps the buffers every other v-blank and so on. A value of 0 disables waiting for v-blank
---before swapping the buffers. Default value is 1.
---When setting the swap interval to 0 and having <code>vsync</code> disabled in
---"game.project", the engine will try to respect the set frame cap value from
---"game.project" in software instead.
---This setting may be overridden by driver settings.
---@param swap_interval number target swap interval.
function sys.set_vsync_swap_interval(swap_interval) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.set_update_frequency#sys.set_update_frequency
---
---Set game update-frequency (frame cap). This option is equivalent to <code>display.update_frequency</code> in
---the "game.project" settings but set in run-time. If <code>Vsync</code> checked in "game.project", the rate will
---be clamped to a swap interval that matches any detected main monitor refresh rate. If <code>Vsync</code> is
---unchecked the engine will try to respect the rate in software using timers. There is no
---guarantee that the frame cap will be achieved depending on platform specifics and hardware settings.
---@param frequency number target frequency. 60 for 60 fps
function sys.set_update_frequency(frequency) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.serialize#sys.serialize
---
---The buffer can later deserialized by <code>sys.deserialize</code>.
---This method has all the same limitations as <code>sys.save</code>.
---@param table table lua table to serialize
---@return string buffer serialized data buffer
function sys.serialize(table) end

---Docs: https://defold.com/ref/stable/sys/?q=sys.deserialize#sys.deserialize
---
---deserializes buffer into a lua table
---@param buffer string buffer to deserialize from
---@return table table lua table with deserialized data
function sys.deserialize(buffer) end

---Terminates the game application and reports the specified <code>code</code> to the OS.
---This message can only be sent to the designated <code>@system</code> socket.
---@class exit_msg
---@field code number exit code to report to the OS, 0 means clean exit

---Toggles the on-screen profiler.
---The profiler is a real-time tool that shows the numbers of milliseconds spent
---in each scope per frame as well as counters. The profiler is very useful for
---tracking down performance and resource problems.
---In addition to the on-screen profiler, Defold includes a web-based profiler that
---allows you to sample a series of data points and then analyze them in detail.
---The web profiler is available at <code>http://&lt;device IP&gt;:8002</code> where  is
---the IP address of the device you are running your game on.
---This message can only be sent to the designated <code>@system</code> socket.
---@class toggle_profile_msg

---Toggles the on-screen physics visual debugging mode which is very useful for
---tracking down issues related to physics. This mode visualizes
---all collision object shapes and normals at detected contact points. Toggling
---this mode on is equal to setting <code>physics.debug</code> in the "game.project" settings,
---but set in run-time.
---This message can only be sent to the designated <code>@system</code> socket.
---@class toggle_physics_debug_msg

---Starts video recording of the game frame-buffer to file. Current video format is the
---open vp8 codec in the ivf container. It's possible to upload this format directly
---to YouTube. The VLC video player has native support but with the known issue that
---not the entire file is played back. It's probably an issue with VLC.
---The Miro Video Converter has support for vp8/ivf.
---   Video recording is only supported on desktop platforms.
--- Audio is currently not supported
--- Window width and height must be a multiple of 8 to be able to record video.
---This message can only be sent to the designated <code>@system</code> socket.
---@class start_record_msg
---@field file_name string file name to write the video to
---@field frame_period number frame period to record, ie write every nth frame. Default value is <code>2</code>
---@field fps number frames per second. Playback speed for the video. Default value is <code>30</code>. The fps value doens't affect the recording. It's only meta-data in the written video file.

---Stops the currently active video recording.
---   Video recording is only supported on desktop platforms.
---This message can only be sent to the designated <code>@system</code> socket.
---@class stop_record_msg

---Reboots the game engine with a specified set of arguments.
---Arguments will be translated into command line arguments. Sending the reboot
---command is equivalent to starting the engine with the same arguments.
---On startup the engine reads configuration from "game.project" in the
---project root.
---This message can only be sent to the designated <code>@system</code> socket.
---@class reboot_msg
---@field arg1 string argument 1
---@field arg2 string argument 2
---@field arg3 string argument 3
---@field arg4 string argument 4
---@field arg5 string argument 5
---@field arg6 string argument 6

---Set the vsync swap interval. The interval with which to swap the front and back buffers
---in sync with vertical blanks (v-blank), the hardware event where the screen image is updated
---with data from the front buffer. A value of 1 swaps the buffers at every v-blank, a value of
---2 swaps the buffers every other v-blank and so on. A value of 0 disables waiting for v-blank
---before swapping the buffers. Default value is 1.
---When setting the swap interval to 0 and having <code>vsync</code> disabled in
---"game.project", the engine will try to respect the set frame cap value from
---"game.project" in software instead.
---This setting may be overridden by driver settings.
---This message can only be sent to the designated <code>@system</code> socket.
---@class set_vsync_msg
---@field swap_interval any target swap interval.

---Set game update-frequency (frame cap). This option is equivalent to <code>display.update_frequency</code> in
---the "game.project" settings but set in run-time. If <code>Vsync</code> checked in "game.project", the rate will
---be clamped to a swap interval that matches any detected main monitor refresh rate. If <code>Vsync</code> is
---unchecked the engine will try to respect the rate in software using timers. There is no
---guarantee that the frame cap will be achieved depending on platform specifics and hardware settings.
---This message can only be sent to the designated <code>@system</code> socket.
---@class set_update_frequency_msg
---@field frequency any target frequency. 60 for 60 fps

---no network connection found
sys.NETWORK_DISCONNECTED = nil

---network connected through mobile cellular
sys.NETWORK_CONNECTED_CELLULAR = nil

---network connected through other, non cellular, connection
sys.NETWORK_CONNECTED = nil

