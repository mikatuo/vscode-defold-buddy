import * as vscode from 'vscode';
import { extendConfigArray, extendConfigObject, readWorkspaceFile, saveWorkspaceFile, setConfigValue } from './common';
import { config } from '../config';

export class LuaProjectInitializer {
	workspaceAnnotationsFolder: string;

	constructor() {
		this.workspaceAnnotationsFolder = config.defoldAnnotationsFolder;
	}

	async run() {
		// for build server to ignore those folders
		await appendLinesIntoFileOrCreateFile({
			path: '.defignore',
			lines: [`/${config.defoldAnnotationsFolder}`, '/.idea', '/.vscode'],
		});
		await appendLinesIntoFileOrCreateFile({
			path: '.gitignore',
			lines: [`/${config.defoldAnnotationsFolder}`],
		});
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

async function appendLinesIntoFileOrCreateFile({ path, lines }: { path: string, lines: string[] }) {
	const defignoreContent = await readWorkspaceFile(path);
	const defignoreLines = defignoreContent && defignoreContent.split(/\r\n|\r|\n/) || [];
	lines.forEach(pattern => {
		if (!defignoreLines.includes(pattern)) {
			defignoreLines.push(pattern);
		}
	});
	await saveWorkspaceFile(path, defignoreLines.join('\n'));
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
