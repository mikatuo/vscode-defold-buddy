# Defold Buddy

Tools for Defold to make your life a bit easier and coding experience in Lua nicer.

## Features

### IntelliSense for Defold API

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P`) or go to `View` > `Command Palette`.
2. Select `Defold: Initialize`

<details><summary>Demo</summary><p>

![a138ae9600cd0fa1d520bb4fbb8f33c897f3aa8f](https://user-images.githubusercontent.com/7230306/222926907-57a8eae2-8db7-43d1-9d6c-80e651d83d3c.gif)

![4cf75769ac699bbe2e1242fd9f6af705ccb29816](https://user-images.githubusercontent.com/7230306/222926911-23dd658c-359f-4739-8d04-e83add96aba0.png)

![213931566-78acccca-6335-4407-8e1a-3ab000899525](https://user-images.githubusercontent.com/7230306/222926916-b070093e-4468-4ced-b00f-6c603e56376a.gif)
</p></details>

### IntelliSense for project dependencies

<details><summary>Demo</summary><p>

![2647bce06606342c31c08006257d11e0173b23f5](https://user-images.githubusercontent.com/7230306/222926955-41f35bf5-bba3-4a96-8399-5edb8179e482.gif)
</p></details>

### Autocompletion for Defold URLs in .script files

Note: read about [the addressing](https://defold.com/manuals/addressing/) if you are not familiar with the concept.

Known issues: The suggestions do not refresh automatically when you make any changes to your .go and .collection files. For now you need to re-index them manually by runnin a command.

1. Open a `.script` file, you should see suggestions after typing a `"`, or pushing `Ctrl+Enter` with cursor next to a `"`.
2. Run "Defold: Index game files for autocompletion" when you need to refresh the autocompletion

<details><summary>Demo</summary><p>

![fb28a66cc769e7ccf8135deb9bfc110bbbf2eb6a](https://user-images.githubusercontent.com/7230306/222926962-645fb3aa-7eaf-408d-8c7b-8464d76df6c2.gif)
</p></details>

### Run "Project > Build" from VSCode (requires Defold editor opened in background)

Note: you can [set a hotkey](https://code.visualstudio.com/docs/getstarted/keybindings) for this command as well as for any other command

<details><summary>Demo</summary><p>

![81887c48d3bad6b29c9dbb49bea0c179d652cb05](https://user-images.githubusercontent.com/7230306/222926974-5c4d7e5b-a29d-427b-a33e-abb29b09701c.gif)
</p></details>

### Hot reloading when .script and .lua files are saved

<details><summary>Demo</summary><p>

https://user-images.githubusercontent.com/7230306/222926994-3aa97bc2-74c4-48f7-a183-176b024d2a41.mp4
</p></details>

### Create `.go` + `.script` + `.factory` files from Explorer context menu

<details><summary>Demo</summary><p>

![147121c5ed7f8954862f3a27fee4cf8cf1efaa16](https://user-images.githubusercontent.com/7230306/222927012-4947ddb0-7b93-4bed-8e5e-4f96cb757d6f.gif)
</p></details>

### Generate manifest (reduce game bundle size)

<details><summary>Demo</summary><p>

You can generate the app manifest from Defold editor:

![fc6f5813cdea82f6a8f264f7634f3b28855e6a3f_2_408x429](https://user-images.githubusercontent.com/7230306/222927049-96c8af0b-880d-4021-9a63-7e9e031aeb16.png)

Or from VSCode:

![8ea1248ec0f937778e9e3645a4158209fb53ada0](https://user-images.githubusercontent.com/7230306/222927056-03cd09eb-9fdb-4801-9286-a8d9c7d77aad.gif)
</p></details>

---

**Credit**

- Manifest generation code was copy pasted from [Defold App Manifest generator](https://github.com/britzl/manifestation) by [britzl](https://github.com/britzl).

**Resources**

- Annotations used in this extensions are generated with [Defold Lua Annotations](https://github.com/mikatuo/defold-lua-annotations).
