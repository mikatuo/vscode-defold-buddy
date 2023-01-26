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

export async function readWorkspaceFile(relativePath: string): Promise<string | undefined> {
    const filePath = getWorkspacePath(relativePath);
    if (!filePath) { return undefined; }

    try {
        const data = await vscode.workspace.fs.readFile(filePath);
        return Buffer.from(data).toString('utf8');
    } catch (ex: any) {
        if (ex.code === 'FileNotFound') {
            return undefined;
        }
        throw ex;
    }
}