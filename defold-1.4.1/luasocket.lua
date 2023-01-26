---@meta

---LuaSocket API documentation
---@class socket
socket = {}

---Docs: https://defold.com/ref/stable/socket/?q=socket.select#socket.select
---
---The function returns a list with the sockets ready for reading, a list with the sockets ready for writing and an error message. The error message is "timeout" if a timeout condition was met and nil otherwise. The returned tables are doubly keyed both by integers and also by the sockets themselves, to simplify the test if a specific socket has changed status.
---<code>Recvt</code> and <code>sendt</code> parameters can be empty tables or <code>nil</code>. Non-socket values (or values with non-numeric indices) in these arrays will be silently ignored.
---The returned tables are doubly keyed both by integers and also by the sockets themselves, to simplify the test if a specific socket has changed status.
---This function can monitor a limited number of sockets, as defined by the constant socket._SETSIZE. This number may be as high as 1024 or as low as 64 by default, depending on the system. It is usually possible to change this at compile time. Invoking select with a larger number of sockets will raise an error.
---A known bug in WinSock causes select to fail on non-blocking TCP sockets. The function may return a socket as writable even though the socket is not ready for sending.
---Calling select with a server socket in the receive parameter before a call to accept does not guarantee accept will return immediately. Use the settimeout method or accept might block forever.
---If you close a socket and pass it to select, it will be ignored.
---(Using select with non-socket objects: Any object that implements <code>getfd</code> and <code>dirty</code> can be used with select, allowing objects from other libraries to be used within a socket.select driven loop.)
---@param recvt table array with the sockets to test for characters available for reading.
---@param sendt table array with sockets that are watched to see if it is OK to immediately write on them.
---@param timeout number|nil the maximum amount of time (in seconds) to wait for a change in status. Nil, negative or omitted timeout value allows the function to block indefinitely.
---@overload fun(recvt: table, sendt: table): table, table, string
---@return table sockets_r a list with the sockets ready for reading.
---@return table sockets_w a list with the sockets ready for writing.
---@return string error an error message. "timeout" if a timeout condition was met, otherwise <code>nil</code>.
function socket.select(recvt, sendt, timeout) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.tcp6#socket.tcp6
---
---Creates and returns an IPv6 TCP master object. A master object can be transformed into a server object with the method <code>listen</code> (after a call to <code>bind</code>) or into a client object with the method connect. The only other method supported by a master object is the close method.
---Note: The TCP object returned will have the option "ipv6-v6only" set to true.
---@return master tcp_master a new IPv6 TCP master object, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function socket.tcp6() end

---Docs: https://defold.com/ref/stable/socket/?q=socket.udp6#socket.udp6
---
---Creates and returns an unconnected IPv6 UDP object. Unconnected objects support the <code>sendto</code>, <code>receive</code>, <code>receivefrom</code>, <code>getoption</code>, <code>getsockname</code>, <code>setoption</code>, <code>settimeout</code>, <code>setpeername</code>, <code>setsockname</code>, and <code>close</code> methods. The <code>setpeername</code> method is used to connect the object.
---Note: The UDP object returned will have the option "ipv6-v6only" set to true.
---@return unconnected udp_unconnected a new unconnected IPv6 UDP object, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function socket.udp6() end

---Docs: https://defold.com/ref/stable/socket/?q=socket.dns.tohostname#socket.dns.tohostname
---
---This function converts from an IPv4 address to host name.
---The address can be an IPv4 address or a host name.
---@param address string an IPv4 address or host name.
---@return string hostname the canonic host name of the given address, or <code>nil</code> in case of an error.
---@return table|string resolved a table with all information returned by the resolver, or if an error occurs, the error message string.
function socket.dns.tohostname(address) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.dns.toip#socket.dns.toip
---
---This function converts a host name to IPv4 address.
---The address can be an IP address or a host name.
---@param address string a hostname or an IP address.
---@return string ip_address the first IP address found for the hostname, or <code>nil</code> in case of an error.
---@return table|string resolved a table with all information returned by the resolver, or if an error occurs, the error message string.
function socket.dns.toip(address) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.dns.gethostname#socket.dns.gethostname
---
---Returns the standard host name for the machine as a string.
---@return string hostname the host name for the machine.
function socket.dns.gethostname() end

---Docs: https://defold.com/ref/stable/socket/?q=socket.dns.getaddrinfo#socket.dns.getaddrinfo
---
---This function converts a host name to IPv4 or IPv6 address.
---The supplied address can be an IPv4 or IPv6 address or host name.
---The function returns a table with all information returned by the resolver:
---<code>{
---[1] = {
---family = family-name-1,
---addr = address-1
---},
---...
---[n] = {
---family = family-name-n,
---addr = address-n
---}
---}
---</code>
---
---Here, family contains the string <code>"inet"</code> for IPv4 addresses, and <code>"inet6"</code> for IPv6 addresses.
---In case of error, the function returns nil followed by an error message.
---@param address string a hostname or an IPv4 or IPv6 address.
---@return table resolved a table with all information returned by the resolver, or if an error occurs, <code>nil</code>.
---@return string error the error message, or <code>nil</code> if no error occurred.
function socket.dns.getaddrinfo(address) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.dns.getnameinfo#socket.dns.getnameinfo
---
---This function converts an address to host name.
---The supplied address can be an IPv4 or IPv6 address or host name.
---The function returns a table with all information returned by the resolver:
---<code>{
---[1] = host-name-1,
---...
---[n] = host-name-n,
---}
---</code>
---@param address string a hostname or an IPv4 or IPv6 address.
---@return table resolved a table with all information returned by the resolver, or if an error occurs, <code>nil</code>.
---@return string error the error message, or <code>nil</code> if no error occurred.
function socket.dns.getnameinfo(address) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.connect#socket.connect
---
---This function is a shortcut that creates and returns a TCP client object connected to a remote
---address at a given port. Optionally, the user can also specify the local address and port to
---bind (<code>locaddr</code> and <code>locport</code>), or restrict the socket family to <code>"inet"</code> or <code>"inet6"</code>.
---Without specifying family to connect, whether a tcp or tcp6 connection is created depends on
---your system configuration.
---@param address string the address to connect to.
---@param port number the port to connect to.
---@param locaddr string|nil optional local address to bind to.
---@param locport number|nil optional local port to bind to.
---@param family string|nil optional socket family to use, <code>"inet"</code> or <code>"inet6"</code>.
---@overload fun(address: string, port: number): client, string
---@overload fun(address: string, port: number, locaddr: string|nil): client, string
---@overload fun(address: string, port: number, locaddr: string|nil, locport: number|nil): client, string
---@return client tcp_client a new IPv6 TCP client object, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function socket.connect(address, port, locaddr, locport, family) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.udp#socket.udp
---
---Creates and returns an unconnected IPv4 UDP object. Unconnected objects support the <code>sendto</code>, <code>receive</code>, <code>receivefrom</code>, <code>getoption</code>, <code>getsockname</code>, <code>setoption</code>, <code>settimeout</code>, <code>setpeername</code>, <code>setsockname</code>, and <code>close</code> methods. The <code>setpeername</code> method is used to connect the object.
---@return unconnected udp_unconnected a new unconnected IPv4 UDP object, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function socket.udp() end

---Docs: https://defold.com/ref/stable/socket/?q=socket.skip#socket.skip
---
---This function drops a number of arguments and returns the remaining.
---It is useful to avoid creation of dummy variables:
---<code>D</code> is the number of arguments to drop. <code>Ret1</code> to <code>retN</code> are the arguments.
---The function returns <code>retD+1</code> to <code>retN</code>.
---@param d number the number of arguments to drop.
---@param ret1 any|nil argument 1.
---@param ret2 any|nil argument 2.
---@param retN any|nil argument N.
---@overload fun(d: number): any, any, any
---@overload fun(d: number, ret1: any|nil): any, any, any
---@overload fun(d: number, ret1: any|nil, ret2: any|nil): any, any, any
---@return any [retD+1] argument D+1.
---@return any [retD+2] argument D+2.
---@return any [retN] argument N.
function socket.skip(d, ret1, ret2, retN) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.tcp#socket.tcp
---
---Creates and returns an IPv4 TCP master object. A master object can be transformed into a server object with the method <code>listen</code> (after a call to <code>bind</code>) or into a client object with the method <code>connect</code>. The only other method supported by a master object is the <code>close</code> method.
---@return master tcp_master a new IPv4 TCP master object, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function socket.tcp() end

---Docs: https://defold.com/ref/stable/socket/?q=socket.newtry#socket.newtry
---
---This function creates and returns a clean try function that allows for cleanup before the exception is raised.
---The <code>finalizer</code> function will be called in protected mode (see protect).
---@param finalizer fun() a function that will be called before the try throws the exception.
---@return function try the customized try function.
function socket.newtry(finalizer) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.protect#socket.protect
---
---Converts a function that throws exceptions into a safe function. This function only catches exceptions thrown by try functions. It does not catch normal Lua errors.
---Beware that if your function performs some illegal operation that raises an error, the protected function will catch the error and return it as a string. This is because try functions uses errors as the mechanism to throw exceptions.
---@param func function a function that calls a try function (or assert, or error) to throw exceptions.
---@return function(function()) safe_func an equivalent function that instead of throwing exceptions, returns <code>nil</code> followed by an error message.
function socket.protect(func) end

---Docs: https://defold.com/ref/stable/socket/?q=socket.gettime#socket.gettime
---
---Returns the time in seconds, relative to the system epoch (Unix epoch time since January 1, 1970 (UTC) or Windows file time since January 1, 1601 (UTC)).
---You should use the values returned by this function for relative measurements only.
---@return number seconds the number of seconds elapsed.
function socket.gettime() end

---Docs: https://defold.com/ref/stable/socket/?q=socket.sleep#socket.sleep
---
---Freezes the program execution during a given amount of time.
---@param time number the number of seconds to sleep for.
function socket.sleep(time) end

---Docs: https://defold.com/ref/stable/socket/?q=server:accept#server:accept
---
---Waits for a remote connection on the server object and returns a client object representing that connection.
---Calling <code>socket.select</code> with a server object in the <code>recvt</code> parameter before a call to accept does not guarantee accept will return immediately. Use the <code>settimeout</code> method or accept might block until another client shows up.
---@return client tcp_client if a connection is successfully initiated, a client object is returned, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred. The error is <code>"timeout"</code> if a timeout condition is met.
function server:accept() end

---Docs: https://defold.com/ref/stable/socket/?q=master:bind#master:bind
---
---Binds a master object to address and port on the local host.
---@param address string an IP address or a host name. If address is <code>"*"</code>, the system binds to all local interfaces using the <code>INADDR_ANY</code> constant.
---@param port number the port to commect to, in the range [0..64K). If port is 0, the system automatically chooses an ephemeral port.
---@return number status the value <code>1</code>, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function master:bind(address, port) end

---Docs: https://defold.com/ref/stable/socket/?q=master:close#master:close
---
---Closes the TCP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
---It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function master:close() end

---Docs: https://defold.com/ref/stable/socket/?q=client:close#client:close
---
---Closes the TCP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
---It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function client:close() end

---Docs: https://defold.com/ref/stable/socket/?q=server:close#server:close
---
---Closes the TCP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
---It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function server:close() end

---Docs: https://defold.com/ref/stable/socket/?q=master:connect#master:connect
---
---Attempts to connect a master object to a remote host, transforming it into a client object. Client objects support methods send, receive, getsockname, getpeername, settimeout, and close.
---Note that the function <code>socket.connect</code> is available and is a shortcut for the creation of client sockets.
---@param address string an IP address or a host name. If address is <code>"*"</code>, the system binds to all local interfaces using the <code>INADDR_ANY</code> constant.
---@param port number the port to commect to, in the range [0..64K). If port is 0, the system automatically chooses an ephemeral port.
---@return number status the value <code>1</code>, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function master:connect(address, port) end

---Docs: https://defold.com/ref/stable/socket/?q=client:getpeername#client:getpeername
---
---Returns information about the remote side of a connected client object.
---It makes no sense to call this method on server objects.
---@return string info a string with the IP address of the peer, the port number that peer is using for the connection, and the family ("inet" or "inet6"). In case of error, the method returns <code>nil</code>.
function client:getpeername() end

---Docs: https://defold.com/ref/stable/socket/?q=master:getsockname#master:getsockname
---
---Returns the local address information associated to the object.
---@return string info a string with local IP address, the local port number, and the family ("inet" or "inet6"). In case of error, the method returns <code>nil</code>.
function master:getsockname() end

---Docs: https://defold.com/ref/stable/socket/?q=client:getsockname#client:getsockname
---
---Returns the local address information associated to the object.
---@return string info a string with local IP address, the local port number, and the family ("inet" or "inet6"). In case of error, the method returns <code>nil</code>.
function client:getsockname() end

---Docs: https://defold.com/ref/stable/socket/?q=server:getsockname#server:getsockname
---
---Returns the local address information associated to the object.
---@return string info a string with local IP address, the local port number, and the family ("inet" or "inet6"). In case of error, the method returns <code>nil</code>.
function server:getsockname() end

---Docs: https://defold.com/ref/stable/socket/?q=master:getstats#master:getstats
---
---Returns accounting information on the socket, useful for throttling of bandwidth.
---@return string stats a string with the number of bytes received, the number of bytes sent, and the age of the socket object in seconds.
function master:getstats() end

---Docs: https://defold.com/ref/stable/socket/?q=client:getstats#client:getstats
---
---Returns accounting information on the socket, useful for throttling of bandwidth.
---@return string stats a string with the number of bytes received, the number of bytes sent, and the age of the socket object in seconds.
function client:getstats() end

---Docs: https://defold.com/ref/stable/socket/?q=server:getstats#server:getstats
---
---Returns accounting information on the socket, useful for throttling of bandwidth.
---@return string stats a string with the number of bytes received, the number of bytes sent, and the age of the socket object in seconds.
function server:getstats() end

---Docs: https://defold.com/ref/stable/socket/?q=master:listen#master:listen
---
---Specifies the socket is willing to receive connections, transforming the object into a server object. Server objects support the <code>accept</code>, <code>getsockname</code>, <code>setoption</code>, <code>settimeout</code>, and <code>close</code> methods.
---@param backlog number the number of client connections that can be queued waiting for service. If the queue is full and another client attempts connection, the connection is refused.
---@return number status the value <code>1</code>, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function master:listen(backlog) end

---Docs: https://defold.com/ref/stable/socket/?q=client:receive#client:receive
---
---Reads data from a client object, according to the specified <code>read pattern</code>. Patterns follow the Lua file I/O format, and the difference in performance between patterns is negligible.
---@param pattern string|number|nil the read pattern that can be any of the following:  <code>"*a"</code> reads from the socket until the connection is closed. No end-of-line translation is performed; <code>"*l"</code> reads a line of text from the socket. The line is terminated by a LF character (ASCII 10), optionally preceded by a CR character (ASCII 13). The CR and LF characters are not included in the returned line. In fact, all CR characters are ignored by the pattern. This is the default pattern; <code>number</code> causes the method to read a specified number of bytes from the socket. 
---@param prefix string|nil an optional string to be concatenated to the beginning of any received data before return.
---@overload fun(): string, string, string
---@overload fun(pattern: string|number|nil): string, string, string
---@return string data the received pattern, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred. The error message can be the string <code>"closed"</code> in case the connection was closed before the transmission was completed or the string <code>"timeout"</code> in case there was a timeout during the operation.
---@return string partial a (possibly empty) string containing the partial that was received, or <code>nil</code> if no error occurred.
function client:receive(pattern, prefix) end

---Docs: https://defold.com/ref/stable/socket/?q=client:send#client:send
---
---Sends data through client object.
---The optional arguments i and j work exactly like the standard string.sub Lua function to allow the selection of a substring to be sent.
---Output is not buffered. For small strings, it is always better to concatenate them in Lua (with the <code>..</code> operator) and send the result in one call instead of calling the method several times.
---@param data string the string to be sent.
---@param i number|nil optional starting index of the string.
---@param j number|nil optional end index of string.
---@overload fun(data: string): number, string, number
---@overload fun(data: string, i: number|nil): number, string, number
---@return number index the index of the last byte within [i, j] that has been sent, or <code>nil</code> in case of error. Notice that, if <code>i</code> is 1 or absent, this is effectively the total number of bytes sent.
---@return string error the error message, or <code>nil</code> if no error occurred. The error message can be <code>"closed"</code> in case the connection was closed before the transmission was completed or the string <code>"timeout"</code> in case there was a timeout during the operation.
---@return number lastindex in case of error, the index of the last byte within [i, j] that has been sent. You might want to try again from the byte following that. <code>nil</code> if no error occurred.
function client:send(data, i, j) end

---Docs: https://defold.com/ref/stable/socket/?q=client:setoption#client:setoption
---
---Sets options for the TCP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---@param option string the name of the option to set. The value is provided in the <code>value</code> parameter:  <code>"keepalive"</code> Setting this option to <code>true</code> enables the periodic transmission of messages on a connected socket. Should the connected party fail to respond to these messages, the connection is considered broken and processes using the socket are notified; <code>"linger"</code> Controls the action taken when unsent data are queued on a socket and a close is performed. The value is a table with the following keys:   boolean <code>on</code>  number <code>timeout</code> (seconds)  If the 'on' field is set to true, the system will block the process on the close attempt until it is able to transmit the data or until <code>timeout</code> has passed. If 'on' is false and a close is issued, the system will process the close in a manner that allows the process to continue as quickly as possible. It is not advised to set this to anything other than zero;  <code>"reuseaddr"</code> Setting this option indicates that the rules used in validating addresses supplied in a call to <code>bind</code> should allow reuse of local addresses; <code>"tcp-nodelay"</code> Setting this option to <code>true</code> disables the Nagle's algorithm for the connection; <code>"ipv6-v6only"</code> Setting this option to <code>true</code> restricts an inet6 socket to sending and receiving only IPv6 packets. 
---@param value any|nil the value to set for the specified option.
---@overload fun(option: string): number, string
---@return number status the value <code>1</code>, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function client:setoption(option, value) end

---Docs: https://defold.com/ref/stable/socket/?q=server:setoption#server:setoption
---
---Sets options for the TCP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---@param option string the name of the option to set. The value is provided in the <code>value</code> parameter:  <code>"keepalive"</code> Setting this option to <code>true</code> enables the periodic transmission of messages on a connected socket. Should the connected party fail to respond to these messages, the connection is considered broken and processes using the socket are notified; <code>"linger"</code> Controls the action taken when unsent data are queued on a socket and a close is performed. The value is a table with the following keys:   boolean <code>on</code>  number <code>timeout</code> (seconds)  If the 'on' field is set to true, the system will block the process on the close attempt until it is able to transmit the data or until <code>timeout</code> has passed. If 'on' is false and a close is issued, the system will process the close in a manner that allows the process to continue as quickly as possible. It is not advised to set this to anything other than zero;  <code>"reuseaddr"</code> Setting this option indicates that the rules used in validating addresses supplied in a call to <code>bind</code> should allow reuse of local addresses; <code>"tcp-nodelay"</code> Setting this option to <code>true</code> disables the Nagle's algorithm for the connection; <code>"ipv6-v6only"</code> Setting this option to <code>true</code> restricts an inet6 socket to sending and receiving only IPv6 packets. 
---@param value any|nil the value to set for the specified option.
---@overload fun(option: string): number, string
---@return number status the value <code>1</code>, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function server:setoption(option, value) end

---Docs: https://defold.com/ref/stable/socket/?q=client:getoption#client:getoption
---
---Gets options for the TCP object. See client:setoption for description of the option names and values.
---@param option string the name of the option to get:  <code>"keepalive"</code>  <code>"linger"</code>  <code>"reuseaddr"</code>  <code>"tcp-nodelay"</code> 
---@return any value the option value, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function client:getoption(option) end

---Docs: https://defold.com/ref/stable/socket/?q=server:getoption#server:getoption
---
---Gets options for the TCP object. See server:setoption for description of the option names and values.
---@param option string the name of the option to get:  <code>"keepalive"</code>  <code>"linger"</code>  <code>"reuseaddr"</code>  <code>"tcp-nodelay"</code> 
---@return any value the option value, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function server:getoption(option) end

---Docs: https://defold.com/ref/stable/socket/?q=master:setstats#master:setstats
---
---Resets accounting information on the socket, useful for throttling of bandwidth.
---@param received number the new number of bytes received.
---@param sent number the new number of bytes sent.
---@param age number the new age in seconds.
---@return number success the value <code>1</code> in case of success, or <code>nil</code> in case of error.
function master:setstats(received, sent, age) end

---Docs: https://defold.com/ref/stable/socket/?q=client:setstats#client:setstats
---
---Resets accounting information on the socket, useful for throttling of bandwidth.
---@param received number the new number of bytes received.
---@param sent number the new number of bytes sent.
---@param age number the new age in seconds.
---@return number success the value <code>1</code> in case of success, or <code>nil</code> in case of error.
function client:setstats(received, sent, age) end

---Docs: https://defold.com/ref/stable/socket/?q=server:setstats#server:setstats
---
---Resets accounting information on the socket, useful for throttling of bandwidth.
---@param received number the new number of bytes received.
---@param sent number the new number of bytes sent.
---@param age number the new age in seconds.
---@return number success the value <code>1</code> in case of success, or <code>nil</code> in case of error.
function server:setstats(received, sent, age) end

---Docs: https://defold.com/ref/stable/socket/?q=master:settimeout#master:settimeout
---
---Changes the timeout values for the object. By default, all I/O operations are blocking. That is, any call to the methods <code>send</code>, <code>receive</code>, and <code>accept</code> will block indefinitely, until the operation completes. The <code>settimeout</code> method defines a limit on the amount of time the I/O methods can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---There are two timeout modes and both can be used together for fine tuning.
---Although timeout values have millisecond precision in LuaSocket, large blocks can cause I/O functions not to respect timeout values due to the time the library takes to transfer blocks to and from the OS and to and from the Lua interpreter. Also, function that accept host names and perform automatic name resolution might be blocked by the resolver for longer than the specified timeout value.
---@param value number the amount of time to wait, in seconds. The <code>nil</code> timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
---@param mode string|nil optional timeout mode to set:  <code>"b"</code> block timeout. Specifies the upper limit on the amount of time LuaSocket can be blocked by the operating system while waiting for completion of any single I/O operation. This is the default mode; <code>"t"</code> total timeout. Specifies the upper limit on the amount of time LuaSocket can block a Lua script before returning from a call. 
---@overload fun(value: number)
function master:settimeout(value, mode) end

---Docs: https://defold.com/ref/stable/socket/?q=client:settimeout#client:settimeout
---
---Changes the timeout values for the object. By default, all I/O operations are blocking. That is, any call to the methods <code>send</code>, <code>receive</code>, and <code>accept</code> will block indefinitely, until the operation completes. The <code>settimeout</code> method defines a limit on the amount of time the I/O methods can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---There are two timeout modes and both can be used together for fine tuning.
---Although timeout values have millisecond precision in LuaSocket, large blocks can cause I/O functions not to respect timeout values due to the time the library takes to transfer blocks to and from the OS and to and from the Lua interpreter. Also, function that accept host names and perform automatic name resolution might be blocked by the resolver for longer than the specified timeout value.
---@param value number the amount of time to wait, in seconds. The <code>nil</code> timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
---@param mode string|nil optional timeout mode to set:  <code>"b"</code> block timeout. Specifies the upper limit on the amount of time LuaSocket can be blocked by the operating system while waiting for completion of any single I/O operation. This is the default mode; <code>"t"</code> total timeout. Specifies the upper limit on the amount of time LuaSocket can block a Lua script before returning from a call. 
---@overload fun(value: number)
function client:settimeout(value, mode) end

---Docs: https://defold.com/ref/stable/socket/?q=server:settimeout#server:settimeout
---
---Changes the timeout values for the object. By default, all I/O operations are blocking. That is, any call to the methods <code>send</code>, <code>receive</code>, and <code>accept</code> will block indefinitely, until the operation completes. The <code>settimeout</code> method defines a limit on the amount of time the I/O methods can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---There are two timeout modes and both can be used together for fine tuning.
---Although timeout values have millisecond precision in LuaSocket, large blocks can cause I/O functions not to respect timeout values due to the time the library takes to transfer blocks to and from the OS and to and from the Lua interpreter. Also, function that accept host names and perform automatic name resolution might be blocked by the resolver for longer than the specified timeout value.
---@param value number the amount of time to wait, in seconds. The <code>nil</code> timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
---@param mode string|nil optional timeout mode to set:  <code>"b"</code> block timeout. Specifies the upper limit on the amount of time LuaSocket can be blocked by the operating system while waiting for completion of any single I/O operation. This is the default mode; <code>"t"</code> total timeout. Specifies the upper limit on the amount of time LuaSocket can block a Lua script before returning from a call. 
---@overload fun(value: number)
function server:settimeout(value, mode) end

---Docs: https://defold.com/ref/stable/socket/?q=client:shutdown#client:shutdown
---
---Shuts down part of a full-duplex connection.
---@param mode string which way of the connection should be shut down:  <code>"both"</code> disallow further sends and receives on the object. This is the default mode; <code>"send"</code> disallow further sends on the object; <code>"receive"</code> disallow further receives on the object. 
---@return number status the value <code>1</code>.
function client:shutdown(mode) end

---Docs: https://defold.com/ref/stable/socket/?q=master:dirty#master:dirty
---
---Check the read buffer status.
---This is an internal method, any use is unlikely to be portable.
---@return boolean status <code>true</code> if there is any data in the read buffer, <code>false</code> otherwise.
function master:dirty() end

---Docs: https://defold.com/ref/stable/socket/?q=client:dirty#client:dirty
---
---Check the read buffer status.
---This is an internal method, any use is unlikely to be portable.
---@return boolean status <code>true</code> if there is any data in the read buffer, <code>false</code> otherwise.
function client:dirty() end

---Docs: https://defold.com/ref/stable/socket/?q=server:dirty#server:dirty
---
---Check the read buffer status.
---This is an internal method, any use is unlikely to be portable.
---@return boolean status <code>true</code> if there is any data in the read buffer, <code>false</code> otherwise.
function server:dirty() end

---Docs: https://defold.com/ref/stable/socket/?q=master:getfd#master:getfd
---
---Returns the underlying socket descriptor or handle associated to the object.
---This is an internal method, any use is unlikely to be portable.
---@return number handle the descriptor or handle. In case the object has been closed, the return will be -1.
function master:getfd() end

---Docs: https://defold.com/ref/stable/socket/?q=client:getfd#client:getfd
---
---Returns the underlying socket descriptor or handle associated to the object.
---This is an internal method, any use is unlikely to be portable.
---@return number handle the descriptor or handle. In case the object has been closed, the return will be -1.
function client:getfd() end

---Docs: https://defold.com/ref/stable/socket/?q=server:getfd#server:getfd
---
---Returns the underlying socket descriptor or handle associated to the object.
---This is an internal method, any use is unlikely to be portable.
---@return number handle the descriptor or handle. In case the object has been closed, the return will be -1.
function server:getfd() end

---Docs: https://defold.com/ref/stable/socket/?q=master:setfd#master:setfd
---
---Sets the underling socket descriptor or handle associated to the object. The current one is simply replaced, not closed, and no other change to the object state is made
---@param handle number the descriptor or handle to set.
function master:setfd(handle) end

---Docs: https://defold.com/ref/stable/socket/?q=client:setfd#client:setfd
---
---Sets the underling socket descriptor or handle associated to the object. The current one is simply replaced, not closed, and no other change to the object state is made
---@param handle number the descriptor or handle to set.
function client:setfd(handle) end

---Docs: https://defold.com/ref/stable/socket/?q=server:setfd#server:setfd
---
---Sets the underling socket descriptor or handle associated to the object. The current one is simply replaced, not closed, and no other change to the object state is made
---@param handle number the descriptor or handle to set.
function server:setfd(handle) end

---Docs: https://defold.com/ref/stable/socket/?q=connected:close#connected:close
---
---Closes a UDP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
---It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function connected:close() end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:close#unconnected:close
---
---Closes a UDP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
---It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function unconnected:close() end

---Docs: https://defold.com/ref/stable/socket/?q=connected:getpeername#connected:getpeername
---
---Retrieves information about the peer associated with a connected UDP object.
---It makes no sense to call this method on unconnected objects.
---@return string info a string with the IP address of the peer, the port number that peer is using for the connection, and the family ("inet" or "inet6"). In case of error, the method returns <code>nil</code>.
function connected:getpeername() end

---Docs: https://defold.com/ref/stable/socket/?q=connected:getsockname#connected:getsockname
---
---Returns the local address information associated to the object.
---UDP sockets are not bound to any address until the <code>setsockname</code> or the <code>sendto</code> method is called for the first time (in which case it is bound to an ephemeral port and the wild-card address).
---@return string info a string with local IP address, a number with the local port, and the family ("inet" or "inet6"). In case of error, the method returns <code>nil</code>.
function connected:getsockname() end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:getsockname#unconnected:getsockname
---
---Returns the local address information associated to the object.
---UDP sockets are not bound to any address until the <code>setsockname</code> or the <code>sendto</code> method is called for the first time (in which case it is bound to an ephemeral port and the wild-card address).
---@return string info a string with local IP address, a number with the local port, and the family ("inet" or "inet6"). In case of error, the method returns <code>nil</code>.
function unconnected:getsockname() end

---Docs: https://defold.com/ref/stable/socket/?q=connected:receive#connected:receive
---
---Receives a datagram from the UDP object. If the UDP object is connected, only datagrams coming from the peer are accepted. Otherwise, the returned datagram can come from any host.
---@param size number|nil optional maximum size of the datagram to be retrieved. If there are more than size bytes available in the datagram, the excess bytes are discarded. If there are less then size bytes available in the current datagram, the available bytes are returned. If size is omitted, the maximum datagram size is used (which is currently limited by the implementation to 8192 bytes).
---@overload fun(): string, string
---@return string datagram the received datagram, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function connected:receive(size) end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:receive#unconnected:receive
---
---Receives a datagram from the UDP object. If the UDP object is connected, only datagrams coming from the peer are accepted. Otherwise, the returned datagram can come from any host.
---@param size number|nil optional maximum size of the datagram to be retrieved. If there are more than size bytes available in the datagram, the excess bytes are discarded. If there are less then size bytes available in the current datagram, the available bytes are returned. If size is omitted, the maximum datagram size is used (which is currently limited by the implementation to 8192 bytes).
---@overload fun(): string, string
---@return string datagram the received datagram, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function unconnected:receive(size) end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:receivefrom#unconnected:receivefrom
---
---Works exactly as the receive method, except it returns the IP address and port as extra return values (and is therefore slightly less efficient).
---@param size number|nil optional maximum size of the datagram to be retrieved.
---@overload fun(): string, string, number
---@return string datagram the received datagram, or <code>nil</code> in case of error.
---@return string ip_or_error the IP address, or the error message in case of error.
---@return number port the port number, or <code>nil</code> in case of error.
function unconnected:receivefrom(size) end

---Docs: https://defold.com/ref/stable/socket/?q=connected:getoption#connected:getoption
---
---Gets an option value from the UDP object. See connected:setoption for description of the option names and values.
---@param option string the name of the option to get:  <code>"dontroute"</code>  <code>"broadcast"</code>  <code>"reuseaddr"</code>  <code>"reuseport"</code>  <code>"ip-multicast-loop"</code>  <code>"ipv6-v6only"</code>  <code>"ip-multicast-if"</code>  <code>"ip-multicast-ttl"</code>  <code>"ip-add-membership"</code>  <code>"ip-drop-membership"</code> 
---@return any value the option value, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function connected:getoption(option) end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:getoption#unconnected:getoption
---
---Gets an option value from the UDP object. See unconnected:setoption for description of the option names and values.
---@param option string the name of the option to get:  <code>"dontroute"</code>  <code>"broadcast"</code>  <code>"reuseaddr"</code>  <code>"reuseport"</code>  <code>"ip-multicast-loop"</code>  <code>"ipv6-v6only"</code>  <code>"ip-multicast-if"</code>  <code>"ip-multicast-ttl"</code>  <code>"ip-add-membership"</code>  <code>"ip-drop-membership"</code> 
---@return any value the option value, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function unconnected:getoption(option) end

---Docs: https://defold.com/ref/stable/socket/?q=connected:send#connected:send
---
---Sends a datagram to the UDP peer of a connected object.
---In UDP, the send method never blocks and the only way it can fail is if the underlying transport layer refuses to send a message to the specified address (i.e. no interface accepts the address).
---@param datagram string a string with the datagram contents. The maximum datagram size for UDP is 64K minus IP layer overhead. However datagrams larger than the link layer packet size will be fragmented, which may deteriorate performance and/or reliability.
---@return number success the value <code>1</code> on success, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function connected:send(datagram) end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:sendto#unconnected:sendto
---
---Sends a datagram to the specified IP address and port number.
---In UDP, the send method never blocks and the only way it can fail is if the underlying transport layer refuses to send a message to the specified address (i.e. no interface accepts the address).
---@param datagram string a string with the datagram contents. The maximum datagram size for UDP is 64K minus IP layer overhead. However datagrams larger than the link layer packet size will be fragmented, which may deteriorate performance and/or reliability.
---@param ip string the IP address of the recipient. Host names are not allowed for performance reasons.
---@param port number the port number at the recipient.
---@return number success the value <code>1</code> on success, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function unconnected:sendto(datagram, ip, port) end

---Docs: https://defold.com/ref/stable/socket/?q=connected:setpeername#connected:setpeername
---
---Changes the peer of a UDP object. This method turns an unconnected UDP object into a connected UDP object or vice versa.
---For connected objects, outgoing datagrams will be sent to the specified peer, and datagrams received from other peers will be discarded by the OS. Connected UDP objects must use the <code>send</code> and <code>receive</code> methods instead of <code>sendto</code> and <code>receivefrom</code>.
---Since the address of the peer does not have to be passed to and from the OS, the use of connected UDP objects is recommended when the same peer is used for several transmissions and can result in up to 30% performance gains.
---@param name string if address is "*" and the object is connected, the peer association is removed and the object becomes an unconnected object again.
---@return number success the value <code>1</code> on success, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function connected:setpeername(name) end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:setpeername#unconnected:setpeername
---
---Changes the peer of a UDP object. This method turns an unconnected UDP object into a connected UDP object or vice versa.
---For connected objects, outgoing datagrams will be sent to the specified peer, and datagrams received from other peers will be discarded by the OS. Connected UDP objects must use the <code>send</code> and <code>receive</code> methods instead of <code>sendto</code> and <code>receivefrom</code>.
---Since the address of the peer does not have to be passed to and from the OS, the use of connected UDP objects is recommended when the same peer is used for several transmissions and can result in up to 30% performance gains.
---@param address string an IP address or a host name.
---@param port number the port number.
---@return number success the value <code>1</code> on success, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function unconnected:setpeername(address, port) end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:setsockname#unconnected:setsockname
---
---Binds the UDP object to a local address.
---This method can only be called before any datagram is sent through the UDP object, and only once. Otherwise, the system automatically binds the object to all local interfaces and chooses an ephemeral port as soon as the first datagram is sent. After the local address is set, either automatically by the system or explicitly by <code>setsockname</code>, it cannot be changed.
---@param address string an IP address or a host name. If address is "*" the system binds to all local interfaces using the constant <code>INADDR_ANY</code>.
---@param port number the port number. If port is 0, the system chooses an ephemeral port.
---@return number success the value <code>1</code> on success, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function unconnected:setsockname(address, port) end

---Docs: https://defold.com/ref/stable/socket/?q=connected:setoption#connected:setoption
---
---Sets options for the UDP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---@param option string the name of the option to set. The value is provided in the <code>value</code> parameter:  <code>"dontroute"</code> Indicates that outgoing messages should bypass the standard routing facilities. Receives a boolean value; <code>"broadcast"</code> Requests permission to send broadcast datagrams on the socket. Receives a boolean value; <code>"reuseaddr"</code> Indicates that the rules used in validating addresses supplied in a <code>bind</code> call should allow reuse of local addresses. Receives a boolean value; <code>"reuseport"</code> Allows completely duplicate bindings by multiple processes if they all set <code>"reuseport"</code> before binding the port. Receives a boolean value; <code>"ip-multicast-loop"</code> Specifies whether or not a copy of an outgoing multicast datagram is delivered to the sending host as long as it is a member of the multicast group. Receives a boolean value; <code>"ipv6-v6only"</code> Specifies whether to restrict inet6 sockets to sending and receiving only IPv6 packets. Receive a boolean value; <code>"ip-multicast-if"</code> Sets the interface over which outgoing multicast datagrams are sent. Receives an IP address; <code>"ip-multicast-ttl"</code> Sets the Time To Live in the IP header for outgoing multicast datagrams. Receives a number;  <code>"ip-add-membership"</code>: Joins the multicast group specified. Receives a table with fields:  string <code>multiaddr</code> (IP address)  string <code>interface</code> (IP address)   "'ip-drop-membership"` Leaves the multicast group specified. Receives a table with fields:   string <code>multiaddr</code> (IP address)  string <code>interface</code> (IP address) 
---@param value any|nil the value to set for the specified option.
---@overload fun(option: string): number, string
---@return number status the value <code>1</code>, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function connected:setoption(option, value) end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:setoption#unconnected:setoption
---
---Sets options for the UDP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---@param option string the name of the option to set. The value is provided in the <code>value</code> parameter:  <code>"dontroute"</code> Indicates that outgoing messages should bypass the standard routing facilities. Receives a boolean value; <code>"broadcast"</code> Requests permission to send broadcast datagrams on the socket. Receives a boolean value; <code>"reuseaddr"</code> Indicates that the rules used in validating addresses supplied in a <code>bind</code> call should allow reuse of local addresses. Receives a boolean value; <code>"reuseport"</code> Allows completely duplicate bindings by multiple processes if they all set <code>"reuseport"</code> before binding the port. Receives a boolean value; <code>"ip-multicast-loop"</code> Specifies whether or not a copy of an outgoing multicast datagram is delivered to the sending host as long as it is a member of the multicast group. Receives a boolean value; <code>"ipv6-v6only"</code> Specifies whether to restrict inet6 sockets to sending and receiving only IPv6 packets. Receive a boolean value; <code>"ip-multicast-if"</code> Sets the interface over which outgoing multicast datagrams are sent. Receives an IP address; <code>"ip-multicast-ttl"</code> Sets the Time To Live in the IP header for outgoing multicast datagrams. Receives a number;  <code>"ip-add-membership"</code>: Joins the multicast group specified. Receives a table with fields:  string <code>multiaddr</code> (IP address)  string <code>interface</code> (IP address)   "'ip-drop-membership"` Leaves the multicast group specified. Receives a table with fields:   string <code>multiaddr</code> (IP address)  string <code>interface</code> (IP address) 
---@param value any|nil the value to set for the specified option.
---@overload fun(option: string): number, string
---@return number status the value <code>1</code>, or <code>nil</code> in case of error.
---@return string error the error message, or <code>nil</code> if no error occurred.
function unconnected:setoption(option, value) end

---Docs: https://defold.com/ref/stable/socket/?q=connected:settimeout#connected:settimeout
---
---Changes the timeout values for the object. By default, the <code>receive</code> and <code>receivefrom</code>  operations are blocking. That is, any call to the methods will block indefinitely, until data arrives. The <code>settimeout</code> function defines a limit on the amount of time the functions can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---In UDP, the <code>send</code> and <code>sendto</code> methods never block (the datagram is just passed to the OS and the call returns immediately). Therefore, the <code>settimeout</code> method has no effect on them.
---@param value number the amount of time to wait, in seconds. The <code>nil</code> timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
function connected:settimeout(value) end

---Docs: https://defold.com/ref/stable/socket/?q=unconnected:settimeout#unconnected:settimeout
---
---Changes the timeout values for the object. By default, the <code>receive</code> and <code>receivefrom</code>  operations are blocking. That is, any call to the methods will block indefinitely, until data arrives. The <code>settimeout</code> function defines a limit on the amount of time the functions can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---In UDP, the <code>send</code> and <code>sendto</code> methods never block (the datagram is just passed to the OS and the call returns immediately). Therefore, the <code>settimeout</code> method has no effect on them.
---@param value number the amount of time to wait, in seconds. The <code>nil</code> timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
function unconnected:settimeout(value) end

---This constant has a string describing the current LuaSocket version.
socket._VERSION = nil

---This constant contains the maximum number of sockets that the select function can handle.
socket._SETSIZE = nil

