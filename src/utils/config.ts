import * as vscode from 'vscode';
import { promises as fs } from 'fs';
import path = require('path'); // TODO: use vscode.Uri.joinPath instead?
import { getWorkspacePath, readWorkspaceFile, saveWorkspaceFile } from './common';

export class ConfigInitializer {
	context: vscode.ExtensionContext;
	extension: { id: string; path: string; };
	defoldVersion: string;
	workspaceAnnotationsFolder: string;

	constructor(context: vscode.ExtensionContext) {
		this.context = context;
		this.extension = {
			id: context.extension.id,
			path: context.extension.extensionPath,
		};
		this.defoldVersion = '';
		this.workspaceAnnotationsFolder = '';
	}

	async run() {
		const selectedVersion = await vscode.window.showQuickPick([
			{ label: '1.4.2' },
			{ label: '1.4.1' },
			{ label: '1.4.0' },
		], {
			placeHolder: 'Select Defold version of the current project.',
			ignoreFocusOut: true,
		});
		if (!selectedVersion) {
			vscode.window.showErrorMessage('Please select version of Defold used for this project.');
			return;
		}
		// copy annotations
		this.defoldVersion = selectedVersion.label;
		this.workspaceAnnotationsFolder = '.defold';
		// TODO: move it outside of the config initializer
		// TODO: download annotations from Github in a .zip file
		this.copyDefoldAnnotationsIntoWorkspace();
		await appendLinesIntoFileOrCreateFile(['/.defold', '/.idea', '/.vscode'], '.defignore'); // build server to ignore
		await appendLinesIntoFileOrCreateFile(['/.defold'], '.gitignore'); // git to ignore
		// add recommended workspace settings
		this.initWorkspaceSettingsForDefold();
		// save extension's state
		await this.context.workspaceState.update('defoldApiAnnotations', <IState>{
			version: selectedVersion.label,
		});
	}

	copyDefoldAnnotationsIntoWorkspace() {
		// annotations for intellisense
		const sourceFolder = this.getExtensionPath(`defold-${this.defoldVersion}`);
		const destinationFolder = getWorkspacePath(this.workspaceAnnotationsFolder)?.fsPath;

		if (!destinationFolder) {
			vscode.window.showErrorMessage('Failed to setup IntelliSense for Defold. Please open a folder first.');
			return;
		}
		copyFolder(sourceFolder, destinationFolder);
	}

	getExtensionPath(folder: string): string {
		// TODO: check if such folder exists
		return path.join(this.extension.path, folder);
	}

	private initWorkspaceSettingsForDefold() {
		const config = vscode.workspace.getConfiguration();

		configureEditor(config);
		if (this.workspaceAnnotationsFolder) {
			configureIntelliSenseForDefold(config, this.workspaceAnnotationsFolder);
		}
		configureGlobalFunctions(config);
		configureFileAssociations(config);
		configureSearchExclude(config);
	}
}

// TODO: move to a separate file
export interface IState {
	version: string;
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

function configureEditor(config: vscode.WorkspaceConfiguration) {
	setConfigValue(config, 'editor.snippetSuggestions', 'bottom');
	setConfigValue(config, 'editor.suggest.showKeywords', false);
}

function configureIntelliSenseForDefold(config: vscode.WorkspaceConfiguration, annotationsFolder: string) {
	setConfigValue(config, 'Lua.completion.callSnippet', 'Replace');
	setConfigValue(config, 'Lua.runtime.version', 'Lua 5.1');
	extendConfigArray(config, 'Lua.workspace.library', [annotationsFolder]);
	// don't show warnings/errors for library files
	setConfigValue(config, 'Lua.diagnostics.libraryFiles', 'Disable');
	extendConfigArray(config, 'Lua.workspace.ignoreDir', [annotationsFolder]);
	setConfigValue(config, 'Lua.diagnostics.ignoredFiles', 'Disable');
}

function configureGlobalFunctions(config: vscode.WorkspaceConfiguration) {
	extendConfigArray(config, 'Lua.diagnostics.globals', [
		'init',
		'final',
		'update',
		'fixed_update',
		'on_message',
		'on_input',
		'on_reload',
	]);
}

function configureFileAssociations(config: vscode.WorkspaceConfiguration) {
	/* eslint-disable @typescript-eslint/naming-convention */
	extendConfigObject(config, 'files.associations', {
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

function configureSearchExclude(config: vscode.WorkspaceConfiguration) {
	/* eslint-disable @typescript-eslint/naming-convention */
	extendConfigObject(config, 'search.exclude', {
		".defold/**": true,
		"**/build/**": true,
		"patches/": true,
		"**/*.collection": true,
		"**/*.atlas": true,
		"**/icon_*.png": true
	});
	/* eslint-enable @typescript-eslint/naming-convention */
}

function extendConfigArray(config: vscode.WorkspaceConfiguration, section: string, additions: string[], configTarget?: vscode.ConfigurationTarget) {
	const values = config.get<string[]>(section, []);

	const newValues = [...values];
	for (const newValue of additions) {
		if (newValues.indexOf(newValue) !== -1) { continue; }
		newValues.push(newValue);
	}
	const target = configTarget || vscode.ConfigurationTarget.Workspace;
	config.update(section, newValues, target);
}

function setConfigValue<TValue>(config: vscode.WorkspaceConfiguration, section: string, newValue: TValue, configTarget?: vscode.ConfigurationTarget) {
	const target = configTarget || vscode.ConfigurationTarget.Workspace;
	config.update(section, newValue, target);
}

function extendConfigObject(config: vscode.WorkspaceConfiguration, section: string, addition: object, configTarget?: vscode.ConfigurationTarget) {
	const value = config.get(section, {});
	
	const newValue = { ...value, ...addition };
	const target = configTarget || vscode.ConfigurationTarget.Workspace;
	config.update(section, newValue, target);
}