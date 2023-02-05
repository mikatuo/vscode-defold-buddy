import * as vscode from 'vscode';

export function getWorkspacePath(folder: string): vscode.Uri | undefined {
    if (!vscode.workspace.workspaceFolders?.length) {
        return undefined;
    }
    const workspaceFolder = vscode.workspace.workspaceFolders[0];
    return vscode.Uri.joinPath(workspaceFolder.uri, folder);
}

export async function saveWorkspaceFile(relativePath: string, content: string): Promise<boolean> {
    const workspacePath = getWorkspacePath(relativePath);
    if (!workspacePath) { return false; }

    const data = Buffer.from(content, 'utf8');
    try {
        await vscode.workspace.fs.writeFile(workspacePath, data);
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

export async function readWorkspaceFile(relativePath: string | vscode.Uri): Promise<string | undefined> {
    const data = await readWorkspaceFileBytes(relativePath);
    if (!data) { return undefined; }

    return Buffer.from(data).toString('utf8');
}

export async function showTextDocument(relativePath: string): Promise<void> {
    var path = getWorkspacePath(relativePath);
    if (!path) { return; }
    try {
        const doc: vscode.TextDocument = await vscode.workspace.openTextDocument(path);
        await vscode.window.showTextDocument(doc, { preview: true });
    } catch (error: any) {
        console.error('Failed to show text document', error);
    }
}