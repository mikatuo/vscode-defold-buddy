import * as vscode from 'vscode';
import { registerInitializeProjectCommand } from './commands/initialize-project-command';
import { registerGenerateManifestCommand } from './commands/generate-manifest-command';
import { registerUrlCompletionItemProvider } from './completion/url-completion-provider';
import { registerGenerateHashesModuleCommand } from './commands/generate-hashes-module';
import { registerIndexDefoldFilesCommand } from './commands/index-defold-files-command';
import { registerCreateGameObjectCommand } from './commands/create-game-object-command';
import { registerCreateGuiCommand } from './commands/create-gui-command';
import { registerCreateLuaModuleCommand } from './commands/create-lua-module-command';
import { registerEditorProjectBuildCommand } from './commands/editor-project-build-command';
import { registerEditorProjectRebundleCommand } from './commands/editor-project-rebundle-command';
import { registerEditorHotReloadCommand } from './commands/editor-hot-reload-command';
import { registerUnzipProjectAssetsCommand } from './commands/extract-project-dependencies-command';
import { registerEditorProjectFetchLibrariesCommand } from './commands/editor-project-fetch-libraries-command';
import { registerEditorDebugStartOrAttachCommand } from './commands/editor-debug-start-or-attach-command';
import { registerAddProjectDependencyCommand } from './commands/add-project-dependency-command';
import { getWorkspacePath, openDefoldEditor } from './utils/common';
import { StateMemento } from './persistence/state-memento';
import { constants } from './constants';
import { migrateFromOldVersions } from './migrations/migrate-from-old-versions';
import { DefoldEditor } from './editor/defold-editor';
import { config } from './config';
import { OutputChannels } from './outputChannels';
import { AssetPortalPanel } from './panels/AssetPortalPanel';

// TODO: annotations for Defold to work without copying the files into the project
//	     ^ currently, there is no way to do that without specifying the absolute path, which I don't like
// TODO: decorate vector4 with color icon
// TODO: debugger
// TODO: show diagnostic errors for urls? (https://code.visualstudio.com/updates/v1_37#_diagnosticstagdeprecated)
// TODO: validate urls - show diagnostic errors if the url does not exist
// TODO: add Sentry or other error reporting tool

export async function activate(context: vscode.ExtensionContext) {
	console.log('Activation!');

	await migrateFromOldVersions(context);

	registerCommands(context);
	registerEditorCommands(context);
	registerUrlCompletionItemProvider(context);
	registerUrlReferenceProvider();
	intellisenseForProjectDependencies(context);

	maybeAskToInitializeCurrentProject(context);
	maybeAskToOpenDefoldEditor(context);

	registerOpenAssetStoreCommand(context);

	// index game files for autocompletion
	vscode.commands.executeCommand('vscode-defold-ide.indexDefoldFiles');
	
	// TODO: EXPERIMENTAL - register file watchers
	//reIndexDefoldFilesOnChanges();

	createDefoldBuddyOutputChannel(config.outputChannelName);
}

export function deactivate() {}

//////////////////

function registerCommands(context: vscode.ExtensionContext) {
	registerInitializeProjectCommand(context);
	registerGenerateManifestCommand(context);
	registerGenerateHashesModuleCommand(context);
	registerIndexDefoldFilesCommand(context);
	registerCreateGameObjectCommand(context);
	registerCreateGuiCommand(context);
	registerCreateLuaModuleCommand(context);
	registerAddProjectDependencyCommand(context);
}

function registerEditorCommands(context: vscode.ExtensionContext) {
	registerEditorProjectBuildCommand(context);
	registerEditorProjectRebundleCommand(context);
	registerEditorProjectFetchLibrariesCommand(context);
	registerEditorDebugStartOrAttachCommand(context);
	registerEditorHotReloadCommand(context);
}

function intellisenseForProjectDependencies(context: vscode.ExtensionContext) {
	// TODO: known issue is that assets are not reloaded when they are removed from Defold editor,
	// because they are removed from game.project but the actual .zip files are not deleted
	// TODO: when either '.internal' or '.internal/lib' folder is deleted the assets are not reloaded
	// possible fix could be to watch for the folder changes
	registerUnzipProjectAssetsCommand(context);
	updateAssetsWhenAssetArchivesChange();
	updateAssetsOnce();
}

async function maybeAskToInitializeCurrentProject(context: vscode.ExtensionContext) {
	const neverAsk = await context.globalState.get<boolean>('neverAskToInitializeCurrentProject', false);
	if (neverAsk) { return; }
	if (await alreadyInitialized(context)) { return; }
	if (await folderExists('.defold')) {
		await StateMemento.save(context, {
			version: 'unknown',
			language: 'lua',
			assets: [],
		});
		return;
	}
	
	vscode.window.showInformationMessage(
		'Add Lua annotations for Defold and recommended settings for VS Code?',
		'Apply', 'Remind me later', 'Never ask again'
	).then(async answer => {
		if (answer === 'Apply') {
			vscode.commands.executeCommand('vscode-defold-ide.initialize');
		}
		if (answer === 'Never ask again') {
			await context.globalState.update('neverAskToInitializeCurrentProject', true);
		}
	});
}

async function maybeAskToOpenDefoldEditor(context: vscode.ExtensionContext) {
	const neverAsk = await context.globalState.get<boolean>('neverAskToOpenDefoldDuringActivation', false);
	if (neverAsk) { return; }
	const editor = new DefoldEditor(context);
	if (!await editor.findRunningEditor()) {
		askToOpenDefoldEditorOrInputPort(context);
	}
}

function registerUrlReferenceProvider() {
	vscode.languages.registerReferenceProvider('lua', {
		provideReferences(document: vscode.TextDocument, position: vscode.Position, context: vscode.ReferenceContext, token: vscode.CancellationToken): vscode.ProviderResult<vscode.Location[]> {
			// TODO: when a script URL is clicked navigate to the script file
			return undefined;
		},
	});
}

function reIndexDefoldFilesOnChanges() {
	const folder = vscode.workspace.workspaceFolders?.[0];
	if (folder) {
		const pattern = new vscode.RelativePattern(folder, '**/*.collection');
		const watcher = vscode.workspace.createFileSystemWatcher(pattern);
		watcher.onDidChange(() => {
			vscode.commands.executeCommand('vscode-defold-ide.indexDefoldFiles');
		});
		watcher.onDidCreate(() => {
			vscode.commands.executeCommand('vscode-defold-ide.indexDefoldFiles');
		});
		watcher.onDidDelete(() => {
			vscode.commands.executeCommand('vscode-defold-ide.indexDefoldFiles');
		});
	}
}

async function alreadyInitialized(context: vscode.ExtensionContext): Promise<boolean> {
	const state = await StateMemento.load(context);
	return !!state;
}

async function folderExists(relativePath: string): Promise<boolean> {
	const path = await getWorkspacePath(relativePath);
	try {
		const stats = await vscode.workspace.fs.stat(path!);
		return stats.type === vscode.FileType.Directory;
	} catch (ex: any) {
		return false;
	}
}

// TODO: move into a separate file
let updatingAssets = false;
function updateAssetsWhenAssetArchivesChange() {
	const folder = getWorkspacePath(constants.assetsInternalFolder);
	if (folder) {
		const pattern = new vscode.RelativePattern(folder, '**/*.zip');
		const watcher = vscode.workspace.createFileSystemWatcher(pattern);
		watcher.onDidChange(updateAssetsOnce);
		watcher.onDidCreate(updateAssetsOnce);
		watcher.onDidDelete(updateAssetsOnce);
	}
}

async function updateAssetsOnce() {
	if (updatingAssets) {
		return;
	}
	updatingAssets = true;
	await vscode.commands.executeCommand('vscode-defold-ide.unzipDependencies');
	updatingAssets = false;
}

async function askToOpenDefoldEditorOrInputPort(context: vscode.ExtensionContext): Promise<{ port?: string }> {
	const answer = await vscode.window.showInformationMessage(
		'Open Defold editor for current project?',
		'Open Defold', 'No', 'Never ask again'
	);
	switch (answer) {
		case 'Open Defold':
			await openDefoldEditor('game.project', process.platform);
			return {};
		case 'No':
			return {};
		case 'Never ask again':
			if (answer === 'Never ask again') {
				await context.globalState.update('neverAskToOpenDefoldDuringActivation', true);
			}
		default:
			return {};
	}
}

function createDefoldBuddyOutputChannel(name: string) {
	OutputChannels.defoldBuddy = vscode.window.createOutputChannel(name, 'defold-buddy-console-output');
}

// the web view shows content of https://defold.com/assets/
async function registerOpenAssetStoreCommand(context: vscode.ExtensionContext) {
    context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.openAssetStore', async () => {
		AssetPortalPanel.render(context.extensionUri);
	}));
}