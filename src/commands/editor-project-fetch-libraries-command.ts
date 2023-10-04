import * as vscode from 'vscode';
import { DefoldEditor, EditorCommand } from '../editor/defold-editor';

export function registerEditorProjectFetchLibrariesCommand(context: vscode.ExtensionContext) {
    context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.projectFetchLibraries', async () => {
        vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Updating libraries...',
        }, async (progress, token) => {
            const editor = new DefoldEditor(context);
            const editorResult = await editor.executeCommand(EditorCommand.fetchLibraries);
            if (editorResult.running) {
                // an artificial delay to make sure the editor finishes fetching libraries
                await new Promise(resolve => setTimeout(resolve, 3000));
            }
        });
    }));
}
