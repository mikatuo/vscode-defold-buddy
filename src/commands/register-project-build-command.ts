import * as vscode from 'vscode';
import { openDefoldEditor } from '../utils/common';
import { DefoldEditor, EditorCommand } from '../editor/defold-editor';

export function registerProjectBuildCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.projectBuild', async () => {
		let success = false;
		await vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Building...',
            cancellable: false,
        }, async (progress, token) => {
            const editor = new DefoldEditor(context);
			success = await editor.call(EditorCommand.build);
        });

		if (!success) { maybeAskToOpenDefoldEditorOrShowErrorMessage(); }
	}));
};

function maybeAskToOpenDefoldEditorOrShowErrorMessage() {
	if (process.platform === 'win32') {
		try {
			maybeOpenDefoldEditor();
		} catch {
			vscode.window.showErrorMessage('Failed to start Defold editor. Please start it and try again.');
		}
	} else {
		vscode.window.showErrorMessage('Failed to find a running Defold editor. Please start it and try again.');
	}
}

async function askUserForPort(context: vscode.ExtensionContext): Promise<string | undefined> {
	const portFromUser = await vscode.window.showInputBox({
		title: 'Port of the running Defold editor',
		ignoreFocusOut: true,
	});
	return portFromUser;
}

function maybeOpenDefoldEditor() {
	vscode.window.showInformationMessage(
		`Defold editor is not found`,
		'Open Defold', 'Cancel'
	).then(async answer => {
		if (answer === 'Open Defold') {
			await openDefoldEditor('game.project');
		}
	});
}
