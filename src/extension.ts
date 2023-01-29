import * as vscode from 'vscode';
import { InitializeCommand } from './commands/initialize-command';
import { GenerateManifestCommand } from './commands/generate-manifest-command';
import { registerUrlCompletionItemProvider } from './completion/url-completion-provider';

// TODO: create new Lua modules with #if .. for hot reloading
// TODO: create new script + .go + factory
// TODO: debugger -> while running show spawned instances
// TODO: show list of URLs
// TODO: show diagnostic errors for urls? (https://code.visualstudio.com/updates/v1_37#_diagnosticstagdeprecated)

export function activate(context: vscode.ExtensionContext) {
	console.log('Activation!');

	registerCommands(context);
	//registerUrlCompletionItemProvider(context);
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

	// context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.addDependency', async () => {
	// 	vscode.window.showInformationMessage('This feature is in development');
	// }));

	// context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.removeDependency', async () => {
	// 	vscode.window.showInformationMessage('This feature is in development');
	// }));
}
