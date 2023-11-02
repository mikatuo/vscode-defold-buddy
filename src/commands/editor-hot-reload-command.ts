import * as vscode from 'vscode';
import { DefoldEditor, EditorCommand } from '../editor/defold-editor';

const fileExtensionsThatTriggerHotReload = ['.script', '.lua', '.gui_script'];

export function registerEditorHotReloadCommand(context: vscode.ExtensionContext) {
    // TODO: move outside of the command
    vscode.workspace.onDidSaveTextDocument(async (document) => {
        if (fileExtensionsThatTriggerHotReload.some((ext) => document.fileName.endsWith(ext))) {
            const editor = new DefoldEditor(context);
            editor.showRunningDefoldEditorNotFoundWindow = false;
            await editor.executeCommand(EditorCommand.hotReload);
        }
    });

    context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.hotReload', async () => {
        const editor = new DefoldEditor(context);
        await editor.executeCommand(EditorCommand.hotReload);
    }));
};
