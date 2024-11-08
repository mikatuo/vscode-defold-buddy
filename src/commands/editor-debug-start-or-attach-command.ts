import * as vscode from 'vscode';
import { DefoldEditor, EditorCommand } from '../editor/defold-editor';
import { Observer } from 'rxjs';
import { OutputChannels } from '../outputChannels';

export function registerEditorDebugStartOrAttachCommand(context: vscode.ExtensionContext) {
    context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.debugStartOrAttach', async () => {
        vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Building...',
        }, async (progress, token) => {
            const editor = new DefoldEditor(context);
            const editorResult = await editor.executeCommand(EditorCommand.debuggerStartOrAttach);

            if (!editorResult.running) { return; }

            editor.$consoleLogs.subscribe(outputToChannel());
            editor.listenToConsoleLogs(editorResult.port!);

            // an artificial delay to make sure the editor finishes building the game
            await new Promise(resolve => setTimeout(resolve, 2000));
        });
    }));
}

function outputToChannel(): Partial<Observer<string>> | ((value: string) => void) | undefined {
    const channel = OutputChannels.defoldBuddy;
    channel.show();
    return function (line: string) {
        channel.appendLine(line);
    };
}
