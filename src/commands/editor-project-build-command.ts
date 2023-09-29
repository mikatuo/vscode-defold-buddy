import * as vscode from 'vscode';
import { DefoldEditor, EditorCommand } from '../editor/defold-editor';

export function registerEditorProjectBuildCommand(context: vscode.ExtensionContext) {
    context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.projectBuild', async () => {
        const editor = new DefoldEditor(context);
        await editor.executeCommand(EditorCommand.build);
    }));
};
