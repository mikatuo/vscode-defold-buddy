import * as vscode from 'vscode';

export function getWorkspacePath(folder: string): vscode.Uri | undefined {
    if (!vscode.workspace.workspaceFolders?.length) {
        return undefined;
    }
    const workspaceFolder = vscode.workspace.workspaceFolders[0];
    return vscode.Uri.joinPath(workspaceFolder.uri, folder);
}

export async function saveWorkspaceFile(relativePath: vscode.Uri | string, content: string): Promise<boolean> {
    const path = typeof(relativePath) === 'string'
        ? getWorkspacePath(relativePath)
        : <vscode.Uri>relativePath;
    if (!path) { return false; }

    const data = Buffer.from(content, 'utf8');
    try {
        await vscode.workspace.fs.writeFile(path, data);
        return true;
    } catch (ex: any) {
        console.error(`Failed to save the file ${relativePath}. Error: ${ex}`);
        return false;
    }
}

export async function readWorkspaceFileBytes(relativePath: string | vscode.Uri): Promise<Uint8Array | undefined> {
    const filePath = typeof(relativePath) === 'string'
        ? getWorkspacePath(relativePath)
        : relativePath;
    if (!filePath) { return undefined; }

    try {
        const data = await vscode.workspace.fs.readFile(filePath);
        return data;
    } catch (ex: any) {
        if (ex.code === 'FileNotFound') {
            return undefined;
        }
        throw ex;
    }
}

export async function readWorkspaceFile(relativePath: vscode.Uri | string): Promise<string | undefined> {
    const data = await readWorkspaceFileBytes(relativePath);
    if (!data) { return undefined; }

    return Buffer.from(data).toString('utf8');
}

export async function showTextDocument(relativePath: vscode.Uri | string, selection?: vscode.Range): Promise<void> {
    const path = typeof(relativePath) === 'string'
        ? getWorkspacePath(relativePath)
        : <vscode.Uri>relativePath;
    if (!path) { return; }
    
    try {
        const doc: vscode.TextDocument = await vscode.workspace.openTextDocument(path);
        await vscode.window.showTextDocument(doc, { preview: true, selection: selection });
    } catch (error: any) {
        console.error('Failed to show text document', error);
    }
}

import { exec, spawn, fork, execFile } from 'child_process';
export async function openDefoldEditor(relativePath: string) {
    const absolutePath = await getWorkspacePath(relativePath);
    // TODO: it would be better to use 'spawn' or 'fork' but
    // for that we need to know path to the executable
    exec(`"${absolutePath?.fsPath!}"`, (error: any, stdout: any, stderr: any) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    });
}