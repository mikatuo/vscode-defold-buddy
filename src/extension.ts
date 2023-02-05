import * as vscode from 'vscode';
import { InitializeCommand } from './commands/initialize-command';
import { GenerateManifestCommand } from './commands/generate-manifest-command';
import { registerUrlCompletionItemProvider } from './completion/url-completion-provider';
import { GenerateHashesModule } from './commands/generate-hashes-module';
import { IndexDefoldFiles } from './commands/index-defold-files';

// TODO:
// 1. set path to the virtual environments directory for Defold annotations
//    in user settings
// 2. when "initialize" is called only specify version in the config, do not copy the files

// TODO: create new script + .go + factory
// TODO: create new Lua modules with #if .. for hot reloading
// TODO: decorate vector4 with color icon
// TODO: debugger -> while running show spawned instances
// TODO: show diagnostic errors for urls? (https://code.visualstudio.com/updates/v1_37#_diagnosticstagdeprecated)

export function activate(context: vscode.ExtensionContext) {
	console.log('Activation!');

	registerCommands(context);
	registerUrlCompletionItemProvider(context);

	// index game files for autocompletion
	vscode.commands.executeCommand('vscode-defold-ide.indexDefoldFiles');
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

	// context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.addDependency', async () => {
	// 	vscode.window.showInformationMessage('This feature is in development');
	// }));

	// context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.removeDependency', async () => {
	// 	vscode.window.showInformationMessage('This feature is in development');
	// }));
}
