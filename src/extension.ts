import * as vscode from 'vscode';
import { InitializeCommand } from './commands/initialize-command';
import { GenerateManifestCommand } from './commands/generate-manifest-command';
import { registerUrlCompletionItemProvider } from './completion/url-completion-provider';
import { GenerateHashesModule } from './commands/generate-hashes-module';
import { IndexDefoldFiles } from './commands/index-defold-files';
import { registerReloadGameCommand } from './wip/reloadGameCommand';
import { registerCreateGameObjectCommand } from './commands/create-game-object-command';
import { registerCreateGuiCommand } from './commands/create-gui-command';

// TODO:
// 1. set path to the virtual environments directory for Defold annotations
//    in user settings
// 2. when "initialize" is called only specify version in the config, do not copy the files

// TODO: annotations for extensions
// TODO: create new Lua modules with #if .. for hot reloading
// TODO: decorate vector4 with color icon
// TODO: debugger -> while running show spawned instances?
// TODO: show diagnostic errors for urls? (https://code.visualstudio.com/updates/v1_37#_diagnosticstagdeprecated)
// TODO: validate requires - show diagnostic errors if the file does not exist
// TODO: validate urls - show diagnostic errors if the url does not exist

export function activate(context: vscode.ExtensionContext) {
	console.log('Activation!');

	registerCommands(context);
	registerUrlCompletionItemProvider(context);
	registerUrlReferenceProvider();

	// index game files for autocompletion
	vscode.commands.executeCommand('vscode-defold-ide.indexDefoldFiles');

	// TODO: EXPERIMENTAL - register file watchers
	//reIndexDefoldFilesOnChanges();
}

export function deactivate() {}

//////////////////

function registerCommands(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.initialize', async () => {
		const cmd = new InitializeCommand(context);
		await cmd.execute();
	}));

	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.generateManifest', async () => {
		const cmd = new GenerateManifestCommand(context);
		await cmd.execute();
	}));

	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.generateHashesModule', async () => {
		const cmd = new GenerateHashesModule(context);
		await cmd.execute();
	}));

	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.indexDefoldFiles', async () => {
		const cmd = new IndexDefoldFiles(context);
		await cmd.execute();
	}));

	registerCreateGameObjectCommand(context);
	registerCreateGuiCommand(context);

	//registerReloadGameCommand(context);
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
