# Defold Buddy

Tools for Defold to make your life a bit easier and coding experience in Lua nicer.

## Features

- [x] IntelliSense
- [x] Autocompletion for Defold urls
- [x] Generate manifest (reduce game bundle size)
- [x] Create .go + .script + .factory files from Explorer context menu
- [x] Create .gui + .gui_script files from Explorer context menu

### IntelliSense

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P`) or go to `View` > `Command Palette`.
2. Select `Defold: Initialize`

<img src="https://user-images.githubusercontent.com/7230306/214968246-3454f551-212b-43f5-88b3-23aa8c9811c1.gif" width=50% height=50%>

### Autocompletion

Known issues: The suggestions do not refresh automatically when you make any changes to your .go and .collection files. For now you need to re-index them manually by runnin a command.

1. Open a `.script` file, you should see suggestions after typing a `"`, or pushing `Ctrl+Enter` with cursor next to a `"`.
2. Run "Defold: Index game files for autocompletion" when you need to refresh the autocompletion

<img src="https://user-images.githubusercontent.com/7230306/216835760-1f9812c4-f793-4094-a6c4-7c816f0c0e4f.gif" width=50% height=50%>

### Generate Manifest

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P`) or go to `View` > `Command Palette`.
2. Select `Defold: Generate manifest (reduce game bundle size)`

<img src="https://user-images.githubusercontent.com/7230306/214969382-6df5462a-82dd-4ffb-9567-89b67c72eeb9.gif" width=50% height=50%>

---

**Credit**

- Manifest generation code was copy pasted from [Defold App Manifest generator](https://github.com/britzl/manifestation) by [britzl](https://github.com/britzl).

**Resources**

- Annotations used in this extensions are generated with [Defold Lua Annotations](https://github.com/mikatuo/defold-lua-annotations).
