import * as vscode from 'vscode';
import { ConfigInitializer } from '../utils/config';
import { Command } from './command';

export class InitializeCommand extends Command {
    async execute() {
		const initializer = new ConfigInitializer(this.context.extension);
		await initializer.run();
		vscode.window.showInformationMessage('Happy Defolding!');
    }
}