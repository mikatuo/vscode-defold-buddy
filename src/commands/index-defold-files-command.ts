import * as vscode from 'vscode';
import { DefoldFileIndexer } from '../utils/defold-file-indexer';
import { Command } from './command';

export function registerIndexDefoldFilesCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.indexDefoldFiles', async () => {
		const cmd = new IndexDefoldFilesCommand(context);
		await cmd.execute();
	}));
}

export class IndexDefoldFilesCommand extends Command {
    async execute() {
        // TODO: read config from extension settings: 1) index automatically? 2) do not index some files? 3) ignore certain types?
        await DefoldFileIndexer.indexWorkspace();
    }
}