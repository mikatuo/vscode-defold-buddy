// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import { InitializeCommand } from './commands/initialize-command';
import { GenerateManifestCommand } from './commands/generate-manifest-command';

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {
	console.log('Activation!');

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

// This method is called when your extension is deactivated
export function deactivate() {}
