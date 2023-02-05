# Change Log

## [Unreleased]

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