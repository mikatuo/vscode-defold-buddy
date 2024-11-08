
Teal
====

Check the [tutorial](https://github.com/teal-language/tl/blob/master/docs/tutorial.md) to get started with an overview of
the language.

## Installing

### Via LuaRocks

Install Lua and [LuaRocks](https://github.com/luarocks/luarocks), then run:

```
luarocks install tl
```

This should put a `tl` command in your `$PATH` (run `eval $(luarocks path)` if
the LuaRocks-installed binaries are not in your `$PATH`).

Teal works with Lua 5.1-5.4, including LuaJIT.

### Binaries

Alternatively, you can find pre-compiled binaries for Linux x86_64 and Windows
x86_64 at the [releases](https://github.com/teal-language/tl/releases) page.
The packages contain a stand-alone executable that can run Teal programs
(without the need of a separate Lua installation) and also compile them to Lua.

# Examples

## Hello world

Assuming you are using an empty project template to try it out, here is how you can start using it:

1. Create a file in the `main` folder and name it `greeter.tl`, then write the following code:
   ```lua
   -- this is Teal, note the type annotations:
   local template: string = "Hello, %s!"
   
   local M = {}
   
   function M.greet(s: string): string
      return template:format(s)
   end
   
   return M
   ```
2. Create `main.script` file in the `main` directory, set it's content to this:
   ```lua
   -- we are importing the Teal file as if it was Lua
   local greeter = require("main.greeter")
   
   function init(self)
       -- use the Teal module
       print(greeter.greet("Teal"))
   end
   ```
3. In `main.collection` file, add a `main.script` Script as a component to some game object.
4. Run the game. The build process will compile and type check all Teal code, and you will 
   see the following line in the output:
   ```
   DEBUG:SCRIPT: Hello, Teal!
   ```

## Type definitions

`tl` supports [declaration files](https://github.com/teal-language/tl/blob/master/docs/declaration_files.md), which can be used to annotate the types
of third-party Lua libraries.
