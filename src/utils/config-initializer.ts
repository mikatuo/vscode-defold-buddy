import * as vscode from 'vscode';
import { promises as fs } from 'fs';
import path = require('path'); // TODO: use vscode.Uri.joinPath instead?
import { extendConfigArray, extendConfigObject, getWorkspacePath, readWorkspaceFile, saveWorkspaceFile, setConfigValue } from './common';
import { StateMemento } from '../persistence/state-memento';
import { config } from '../config';

export class ConfigInitializer {
	context: vscode.ExtensionContext;
	extension: { id: string; path: string; };
	workspaceAnnotationsFolder: string;

	constructor(context: vscode.ExtensionContext) {
		this.context = context;
		this.extension = {
			id: context.extension.id,
			path: context.extension.extensionPath,
		};
		this.workspaceAnnotationsFolder = config.defoldAnnotationsFolder;
	}

	async run() {
		await appendLinesIntoFileOrCreateFile([`/${config.defoldAnnotationsFolder}`, '/.idea', '/.vscode'], '.defignore'/* filename */); // build server to ignore
		await appendLinesIntoFileOrCreateFile([`/${config.defoldAnnotationsFolder}`], '.gitignore'/* filename */);
		// add recommended workspace settings
		await this.initWorkspaceSettingsForDefold();
	}

	private async initWorkspaceSettingsForDefold() {
		const config = vscode.workspace.getConfiguration();

		await configureEditor(config);
		await configureIntelliSenseForDefold(config, this.workspaceAnnotationsFolder);
		await configureGlobalFunctions(config);
		await configureFileAssociations(config);
		await configureSearchExclude(config);
	}
}

async function appendLinesIntoFileOrCreateFile(lines: string[], filename: string) {
	const defignoreContent = await readWorkspaceFile(filename);
	const defignoreLines = defignoreContent && defignoreContent.split(/\r\n|\r|\n/) || [];
	lines.forEach(pattern => {
		if (!defignoreLines.includes(pattern)) {
			defignoreLines.push(pattern);
		}
	});
	await saveWorkspaceFile(filename, defignoreLines.join('\n'));
}

async function copyFolder(sourceFolder: string, destFolder: string) {
    await fs.mkdir(destFolder, { recursive: true });
    let entries = await fs.readdir(sourceFolder, { withFileTypes: true });

    for (let entry of entries) {
        let srcPath = path.join(sourceFolder, entry.name);
        let destPath = path.join(destFolder, entry.name);

        entry.isDirectory() ?
            await copyFolder(srcPath, destPath) :
            await fs.copyFile(srcPath, destPath);
    }
}

async function configureEditor(config: vscode.WorkspaceConfiguration) {
	await setConfigValue(config, 'editor.snippetSuggestions', 'bottom');
	await setConfigValue(config, 'editor.suggest.showKeywords', false);
}

async function configureIntelliSenseForDefold(config: vscode.WorkspaceConfiguration, annotationsFolder: string) {
	await setConfigValue(config, 'Lua.completion.callSnippet', 'Replace');
	await setConfigValue(config, 'Lua.runtime.version', 'Lua 5.1');
	await extendConfigArray(config, 'Lua.workspace.library', [annotationsFolder]);
	// don't show warnings/errors for library files
	await setConfigValue(config, 'Lua.diagnostics.libraryFiles', 'Disable');
	await extendConfigArray(config, 'Lua.workspace.ignoreDir', [annotationsFolder, 'build']);
	await setConfigValue(config, 'Lua.diagnostics.ignoredFiles', 'Disable');
}

async function configureGlobalFunctions(config: vscode.WorkspaceConfiguration) {
	await extendConfigArray(config, 'Lua.diagnostics.globals', [
		'init',
		'final',
		'update',
		'fixed_update',
		'on_message',
		'on_input',
		'on_reload',
	]);
}

async function configureFileAssociations(config: vscode.WorkspaceConfiguration) {
	/* eslint-disable @typescript-eslint/naming-convention */
	await extendConfigObject(config, 'files.associations', {
		'*.script': 'lua',
		'*.gui_script': 'lua',
		'*.render_script': 'lua',
		'*.editor_script': 'lua',
		'*.lua_': 'lua',
		'*.fp': 'glsl',
		'*.vp': 'glsl',
		'*.go': 'textproto',
		'*.animationset': 'textproto',
		'*.atlas': 'textproto',
		'*.buffer': 'json',
		'*.camera': 'textproto',
		'*.collection': 'textproto',
		'*.collectionfactory': 'textproto',
		'*.collectionproxy': 'textproto',
		'*.collisionobject': 'textproto',
		'*.display_profiles': 'textproto',
		'*.factory': 'textproto',
		'*.gamepads': 'textproto',
		'*.gui': 'textproto',
		'*.input_binding': 'textproto',
		'*.label': 'textproto',
		'*.material': 'textproto',
		'*.mesh': 'textproto',
		'*.model': 'textproto',
		'*.particlefx': 'textproto',
		'*.project': 'ini',
		'*.render': 'textproto',
		'*.sound': 'textproto',
		'*.spinemodel': 'textproto',
		'*.spinescene': 'textproto',
		'*.sprite': 'textproto',
		'*.texture_profiles': 'textproto',
		'*.tilemap': 'textproto',
		'*.tilesource': 'textproto',
		'*.appmanifest': 'yaml',
	});
	/* eslint-enable @typescript-eslint/naming-convention */
}

async function configureSearchExclude(config: vscode.WorkspaceConfiguration) {
	/* eslint-disable @typescript-eslint/naming-convention */
	await extendConfigObject(config, 'search.exclude', {
		[`${config.defoldAnnotationsFolder}/**`]: true,
		'**/build/**': true,
		'patches/': true,
		'**/*.collection': true,
		'**/*.atlas': true,
		'**/icon_*.png': true
	});
	/* eslint-enable @typescript-eslint/naming-convention */
}
