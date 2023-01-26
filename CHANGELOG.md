# Change Log

## [Unreleased]

## [0.5.2] - 2023-01-26

### Added

- Demo animations to the Readme

## [0.5.1] - 2023-01-26

### Added

- Annotations for Defold 1.4.0, 1.4.2-beta

### Fixed

- Do not overwrite .defignore if it exists
- Fix a bug when no Defold version is selected during "Initialize"

## [0.5.0] - 2023-01-25

### Added

- "Defold: Initialize" command - adds Lua annotations for Defold API into the project, configures optimal VS Code settings for Defold
- "Defold: Generate App Manifest" command - creates and adds the manifest into opened project. The manifest file allows to reduce the game bundle size. The code is copy-pasted from [britzl/manifestation](https://github.com/britzl/manifestation)