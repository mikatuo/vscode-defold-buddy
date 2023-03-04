import * as vscode from 'vscode';
import { DefoldEditor, EditorCommand } from '../editor/defold-editor';

export function registerHotReloadCommand(context: vscode.ExtensionContext) {
	// TODO: move outside of the command
	vscode.workspace.onDidSaveTextDocument(async (document) => {
		if (document.fileName.endsWith('.script') || document.fileName.endsWith('.lua')) {
			const editor = new DefoldEditor(context);
			await editor.call(EditorCommand.hotReload);
		}
	});
	
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.hotReload', async () => {
		const editor = new DefoldEditor(context);
		await editor.call(EditorCommand.hotReload);
	}));
};
