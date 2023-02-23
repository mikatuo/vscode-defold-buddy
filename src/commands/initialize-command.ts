import * as vscode from 'vscode';
import { ConfigInitializer } from '../utils/config-initializer';
import { Command } from './command';

export function registerInitializeCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.initialize', async () => {
		const cmd = new InitializeCommand(context);
		await cmd.execute();
	}));
}

export class InitializeCommand extends Command {
    async execute() {
		const initializer = new ConfigInitializer(this.context);
		await initializer.run();
		vscode.window.showInformationMessage('Happy Defolding!');
    }
}