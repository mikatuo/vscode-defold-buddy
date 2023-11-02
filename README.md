# Defold Buddy

Productivity tools for Defold to make your life easier and coding experience nicer.<br/>
You will have less reasons to alt-tab between VS Code and Defold Editor because you can run your game, hot reload changed files, fetch libraries from VS Code.

## Features

- [x] Code completion for Defold API and dependencies
- [x] Code completion for Defold URLs
- [x] Asset Portal
- [x] Build (run) your game
- [x] Fetch libraries
- [x] Hot reloading
- [x] Open Defold Editor
- [x] Create a complex Game Object file from Explorer context menu
- [x] Generate manifest (reduce game bundle size) - also available in Defold Editor

## Code completion for Defold API and dependencies

![GitHub release](https://img.shields.io/github/v/release/mikatuo/defold-lua-annotations.svg?include_prereleases=&sort=semver&color=)

<details><summary>Demo (Defold API)...</summary><p>

1. Open a Defold project
2. You should see a prompt to initialize the extension

or

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P`) or go to `View` > `Command Palette`.
2. Select `Defold Buddy: Initialize`

![a138ae9600cd0fa1d520bb4fbb8f33c897f3aa8f](https://user-images.githubusercontent.com/7230306/222926907-57a8eae2-8db7-43d1-9d6c-80e651d83d3c.gif)

![4cf75769ac699bbe2e1242fd9f6af705ccb29816](https://user-images.githubusercontent.com/7230306/222926911-23dd658c-359f-4739-8d04-e83add96aba0.png)
</p></details>

<details><summary>Demo (project dependencies)...</summary><p>

![2647bce06606342c31c08006257d11e0173b23f5](https://user-images.githubusercontent.com/7230306/222926955-41f35bf5-bba3-4a96-8399-5edb8179e482.gif)
</p></details>

## Code completion for Defold URLs

<details><summary>Demo...</summary><p>

Note: read about the [addressing](https://defold.com/manuals/addressing/) if you are not familiar with the concept

![fb28a66cc769e7ccf8135deb9bfc110bbbf2eb6a](https://user-images.githubusercontent.com/7230306/222926962-645fb3aa-7eaf-408d-8c7b-8464d76df6c2.gif)
</p></details>

<details><summary>Known issues</summary>

For now the suggestions are not refreshed automatically when you make any changes to your .go and .collection files. For now you need to re-index them manually by running a command.

1. Open a `.script` file, you should see suggestions after typing a `"`, or pushing `Ctrl+Enter` with cursor next to a `"`.
2. Run "Defold Buddy: Index game files for autocompletion" when you need to refresh the autocompletion
</details>

## Asset Portal

<details><summary>Demo...</summary><p>

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P`) or go to `View` > `Command Palette`.
2. Select `Defold Buddy: Asset Portal`

![ezgif-4-b091012f33](https://github.com/mikatuo/vscode-defold-buddy/assets/7230306/7ff1547f-d43c-4195-8066-5542c0509df8)
</p></details>

## Build (run) your game

<details><summary>Demo...</summary><p>

Note: requires Defold editor running in the background

Note: you can [set a hotkey](https://code.visualstudio.com/docs/getstarted/keybindings) for this command as well as for any other command

![81887c48d3bad6b29c9dbb49bea0c179d652cb05](https://user-images.githubusercontent.com/7230306/222926974-5c4d7e5b-a29d-427b-a33e-abb29b09701c.gif)
</p></details>

## Hot reloading

After `.script`, `.gui_script` or `.lua` files are saved they are automatically hot-reloaded if the game is running.

<details><summary>Demo...</summary><p>

Note: read about [hot reloading](https://defold.com/manuals/hot-reload/) in Defold

1. Open Defold editor
2. Run your game via the editor
3. Modify a .script file and save it, the modified file should be hot-reloaded

https://user-images.githubusercontent.com/7230306/222926994-3aa97bc2-74c4-48f7-a183-176b024d2a41.mp4
</p></details>

## Create a complex Game Object file from Explorer context menu

Create a Game Object file (.go) with components (sprite, script) and a factory file (`.factory`) for that Game Object with less clicks

<details><summary>Demo...</summary><p>

![147121c5ed7f8954862f3a27fee4cf8cf1efaa16](https://user-images.githubusercontent.com/7230306/222927012-4947ddb0-7b93-4bed-8e5e-4f96cb757d6f.gif)
</p></details>

## Generate manifest (reduce game bundle size)

<details><summary>Demo...</summary><p>

You can generate the app manifest from Defold editor:

![fc6f5813cdea82f6a8f264f7634f3b28855e6a3f_2_408x429](https://user-images.githubusercontent.com/7230306/222927049-96c8af0b-880d-4021-9a63-7e9e031aeb16.png)

Or from VSCode:

![8ea1248ec0f937778e9e3645a4158209fb53ada0](https://user-images.githubusercontent.com/7230306/222927056-03cd09eb-9fdb-4801-9286-a8d9c7d77aad.gif)
</p></details>

<br/>

### Feedback

If you would like to collaborate, contribute or request a feature feel free to do it at [Github](https://github.com/mikatuo/vscode-defold-buddy)

#### Credit

Manifest generation code was copy pasted from [Defold App Manifest generator](https://github.com/britzl/manifestation) by [britzl](https://github.com/britzl).

#### Resources

Annotations used in this extensions are generated with [Defold Lua Annotations](https://github.com/mikatuo/defold-lua-annotations).
