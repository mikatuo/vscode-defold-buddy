# Change Log

## [Unreleased]

## [1.5.2] - 2024-10-07
- `ADD` Project initializer for Teal

## [1.4.0] - 2024-05-20
- `CHG` Trigger hot reload for TS Defold when `.ts` files are saved
- `CHG` Initialize the extension for TS Defold (app/game.project is detected)

## [1.3.9] - 2023-11-18
- `ADD` Hero image into the Readme

## [1.3.8] - 2023-11-13
- `FIX` Trying to fix "No output socket available for ssdp search response" error

## [1.3.7] - 2023-11-01
- `CHG` Trigger hot reload when `.gui_script` files are saved
- `FIX` Bug when an icon on Asset Portal was taking whole view

## [1.3.1] - 2023-10-18
- `FIX` Game logs should be showing correctly without text artefacts at the end

## [1.2.9] - 2023-10-16
- `CHG` Readme, sponsor url, links to the Github repo

## [1.2.8] - 2023-10-16
- `CHG` UX improvements on Asset Portal
- `FIX` Bug with inconsistent grid on Asset Portal

## [1.2.0] - 2023-10-15
- `ADD` Asset Portal

## [1.1.7] - 2023-10-11
- `CHG` Update readme

## [1.1.6] - 2023-10-03
- `CHG` New logo

## [1.1.3] - 2023-10-01
- `ADD` Add "Project > Fetch Libraries", "Debug > Start / Attach" commands
- `ADD` Show game logs in "Defold Buddy" channel when running "Project > Build" or "Debug > Start / Attach" commands
- `CHG` Change command categories to "Defold Buddy"
- `CHG` Quality of life improvements such as progress indicators

## [1.0.0] - 2023-09-28
- `ADD` Ask to open Defold editor during activation

## [0.9.11] - 2023-09-28
- `ADD` Add sponsor url to https://github.com/sponsors/defold

## [0.9.10] - 2023-09-20
- `FIX` Fix annoying bugs when "Create Game Object", "Create Gui", "Create Lua Module" were generating files even when a user clicked Esc button

## [0.9.9] - 2023-08-29
- `FIX` Fix errors when bundling a project with assets that have ext.manifest files

## [0.9.8] - 2023-08-27
- `FIX` A bug introduced after previous release. Error message that Defold editor is not found when .lua or .script file is saved and the editor is not running
- `CHG` Annotate self and other types of .go hook functions (init, update, etc) when .go + .script files are created using the extension

## [0.9.7] - 2023-08-27
- `ADD` "Project > Build" will prompt to input a Defold's port manually if it can't detect it automatically

## [0.9.6] - 2023-08-25
- `ADD` "Project > Build" can now start Defold editor on MacOs

## [0.9.5] - 2023-05-28
- `FIX` Fix "Initialize" not setting vscode settings for the intellisense

## [0.9.3] - 2023-03-04
- `CHG` Updated readme

## [0.9.2] - 2023-03-04
- `ADD` Defold URL autocompletion in .lua files
- `FIX` Fix errors when bundling a project with assets that have ext.manifest files

## [0.9.1] - 2023-02-27
- `ADD` Hot reload the running game when a `.script` or `.lua` file is save

## [0.8.9] - 2023-02-26
- `CHG` Logo

## [0.8.8] - 2023-02-26
- `FIX` Do not show URL autocompletion after `require` keyword

## [0.8.7] - 2023-02-26
- `CHG` Download annotation files from [Github](https://github.com/mikatuo/defold-lsp-annotations/releases)
- `CHG` Various improvements with annotations for dependencies

## [0.8.6] - 2023-02-24
- `ADD` Unzip project dependencies into `/.defold/lib` folder so that they could be picked up by the Lua extension for intellisense

## [0.8.5] - 2023-02-20
- `CHG` When "Project > Build" can't find a Defold editor, it will ask to open one

## [0.8.3] - 2023-02-19
- `CHG` Better UX on Linux and Mac when running "Project > Build" command

## [0.8.1] - 2023-02-19
- `CHG` Better UX on Windows when running "Project > Build" command

## [0.8.0] - 2023-02-18
- `ADD` Ability to call running Defold editor from VS Code to build the project
- `ADD` Ask to run the "Initialize" command when opening a project without Lua annotations for Defold API

## [0.7.4] - 2023-02-12
- `ADD` Explorer's context menu item "Create Gui" for a folder to create .gui + .gui_script files with a few clicks

## [0.7.2] - 2023-02-12
- `ADD` Explorer's context menu item "Create Game Object" for a folder to create .go + .script + .factory files with a few clicks

## [0.6.7] - 2023-02-06
- `FIX` A bug when URL autocompletion was being triggered everywhere

## [0.6.6] - 2023-02-05
- `ADD` Better autocompletion for scripts that are attached to a game object that is placed into a collection

## [0.6.5] - 2023-02-05
- `CHG` Update the Readme

## [0.6.3] - 2023-02-05
- `ADD` Command to re-index game files for the autocompletion

## [0.6.2] - 2023-02-05
- `CHG` Better autocomplete for Defold url-s. It now shows referenced instances, component types, filenames

## [0.6.1] - 2023-02-04
- `FIX` Make autocomplete work better for component names (after '#')

## [0.6.0] - 2023-02-04
- `ADD` Autocompletion for Defold url-s for .script files that are attached to .go or .collection files

## [0.5.6] - 2023-02-03
- `ADD` "Generate module with hashes" command (alpha)

## [0.5.5] - 2023-01-30
- `ADD` Annotations for Defold v1.4.2

## [0.5.4] - 2023-01-30
- `FIX` Bug when generate manifest command was incorectly updating game.project

## [0.5.3] - 2023-01-29
- `FIX` Add, subtract, multiply, divide operator annotations for vector3, vector4
- `FIX` Missing types for "to" parameter in "gui.animate
- `FIX` Missing boolean type in go.property

## [0.5.2] - 2023-01-26
- `ADD` Demo animations to the Readme

## [0.5.1] - 2023-01-26
- `ADD` Annotations for Defold 1.4.0, 1.4.2-beta
- `FIX` Do not overwrite .defignore if it exists
- `FIX` A bug when no Defold version is selected during "Initialize"

## [0.5.0] - 2023-01-25
- `ADD` "Defold: Initialize" command - adds Lua annotations for Defold API into the project, configures optimal VS Code settings for Defold
- `ADD` "Defold: Generate App Manifest" command - creates and adds the manifest into opened project. The manifest file allows to reduce the game bundle size. The code is copy-pasted from [britzl/manifestation](https://github.com/britzl/manifestation)