import * as vscode from 'vscode';
import { DefoldEditor, EditorCommand } from '../editor/defold-editor';

const gameFilesThatTriggerHotReload = ['.script', '.lua', '.gui_script'];

// TS Defold transpiles .ts files to .lua (https://ts-defold.dev)
const tsDefoldFilesThatTriggerHotReload = ['.ts'];
// could ts -> lua conversion take more than 2 seconds?
const tsDefoldTranspilationMaxWaitTime = 2000;

export function registerEditorHotReloadCommand(context: vscode.ExtensionContext) {
    hotReloadGameWhenGameFilesAreSaved(context);
    hotReloadGameWhenTsDefoldFilesAreSaved(context);

    context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.hotReload', async () => {
        await hotReloadRunningGameOrAskToOpenDefoldEditor(context);
    }));
};

function hotReloadGameWhenGameFilesAreSaved(context: vscode.ExtensionContext) {
    vscode.workspace.onDidSaveTextDocument(async (document) => {
        if (gameFilesThatTriggerHotReload.some((ext) => document.fileName.endsWith(ext))) {
            await silentlyHotReloadRunningGameViaDefoldEditor(context);
        }
    });
}

function hotReloadGameWhenTsDefoldFilesAreSaved(context: vscode.ExtensionContext) {
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (workspaceFolder) {
        vscode.workspace.onWillSaveTextDocument(async (event) => {
            if (tsDefoldFilesThatTriggerHotReload.some((ext) => event.document.fileName.endsWith(ext))) {
                await waitForTypescriptFilesToBeTranspiledToLuaFiles(workspaceFolder);
                // now that we are sure that the .lua files are updated
                // we can trigger the hot reload
                await silentlyHotReloadRunningGameViaDefoldEditor(context);
            }
        });
    }
}

async function hotReloadRunningGameOrAskToOpenDefoldEditor(context: vscode.ExtensionContext) {
    const editor = new DefoldEditor(context);
    await editor.executeCommand(EditorCommand.hotReload);
}

async function silentlyHotReloadRunningGameViaDefoldEditor(context: vscode.ExtensionContext) {
    const editor = new DefoldEditor(context);
    editor.showRunningDefoldEditorNotFoundWindow = false;
    await editor.executeCommand(EditorCommand.hotReload);
}

async function waitForTypescriptFilesToBeTranspiledToLuaFiles(folder: vscode.WorkspaceFolder) {
    return new Promise<void>(async (resolve) => {
        const pattern = new vscode.RelativePattern(folder, '**/*.lua');
        const watcher = vscode.workspace.createFileSystemWatcher(pattern);
        watcher.onDidChange(() => { triggerHotReloadOnce(); });
        watcher.onDidCreate(() => { triggerHotReloadOnce(); });
        watcher.onDidDelete(() => { triggerHotReloadOnce(); });
        // watch for file changes for a while, then trigger hot reload
        // even if we can't detect the file changes
        // just to make sure that we do not wait forever
        setTimeout(() => { triggerHotReloadOnce(); }, tsDefoldTranspilationMaxWaitTime);

        let alreadyFired = false;
        function triggerHotReloadOnce() {
            if (!alreadyFired) {
                alreadyFired = true;
                resolve();
                watcher.dispose();
            }
        }
    });
}
