import * as vscode from 'vscode';
import { DefoldEditor, EditorCommand } from '../editor/defold-editor';
import { Observer } from 'rxjs';
import { OutputChannels } from '../outputChannels';

export function registerEditorProjectRebundleCommand(context: vscode.ExtensionContext) {
    context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.projectRebundle', async () => {
        vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Rebundling...',
        }, async (progress, token) => {
            const editor = new DefoldEditor(context);
            const editorResult = await editor.executeCommand(EditorCommand.rebundle);

            if (!editorResult.running) { return; }

            editor.$consoleLogs.subscribe(outputToDefoldBuddyChannel());
            editor.listenToConsoleLogs(editorResult.port!);

            // an artificial delay to make sure the editor finishes building the game
            await new Promise(resolve => setTimeout(resolve, 2000));
        });
    }));
}

function outputToDefoldBuddyChannel(): Partial<Observer<string>> | ((value: string) => void) | undefined {
    // console.log(`\x1b[32mDEBUG:SCRIPT\x1b[0m test`);
    const channel = OutputChannels.defoldBuddy;
    channel.show();
    return function (line: string) {
        channel.appendLine(line);
    };
}
