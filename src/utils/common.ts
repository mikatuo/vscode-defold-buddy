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

export async function safelyDeleteFolder(relativePath: string, options?: { recursive?: boolean; useTrash?: boolean }) {
    const path = getWorkspacePath(relativePath);
    if (!path) { return; }

    try {
        await vscode.workspace.fs.delete(path, options);
    } catch (ex: any) {
        // ignore
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
export async function openDefoldEditor(relativePath: string, platform: NodeJS.Platform) {
    const absolutePath = await getWorkspacePath(relativePath);
    // TODO: it would be better to use 'spawn' or 'fork' but
    // for that we need to know path to the executable
    switch (platform) {
        case 'win32':
            openDefoldEditorOnWindows(absolutePath);
            break;
        case 'darwin':
            openDefoldEditorOnMac(absolutePath);
            break;
        default:
            vscode.window.showErrorMessage(`Failed to open Defold as this feature is not implemented for '${platform}' platform. Please start it yourself and try again.`);
    }
}

function openDefoldEditorOnWindows(absolutePath: vscode.Uri | undefined) {
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

function openDefoldEditorOnMac(absolutePath: vscode.Uri | undefined) {
    // TODO: if Defold is named differently on Mac, this will not work. Make it configurable.
    const defoldAppName = 'Defold.app';
    exec(`open -a "${defoldAppName}" "${absolutePath?.fsPath!}"`, (error: any, stdout: any, stderr: any) => {
        if (error) {
            console.log(`error: ${error.message}`);
            if (error.message.includes(`Unable to find application named '${defoldAppName}'`)) {
                vscode.window.showErrorMessage(`Unable to find application named '${defoldAppName.replace('.app', '')}'. Please make sure that you have it in your installed Applications to use this feature.`);
            }
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    });
}

export async function extendConfigArray(config: vscode.WorkspaceConfiguration, section: string, additions: string[], configTarget?: vscode.ConfigurationTarget) {
	const values = config.get<string[]>(section, []);

	const newValues = [...values];
	for (const newValue of additions) {
		if (newValues.indexOf(newValue) !== -1) { continue; }
		newValues.push(newValue);
	}
	const target = configTarget || vscode.ConfigurationTarget.Workspace;
	await config.update(section, newValues, target);
}

export async function removeFromConfigArray(config: vscode.WorkspaceConfiguration, section: string, matcher: (value: string) => boolean, configTarget?: vscode.ConfigurationTarget) {
    const values = config.get<string[]>(section, []);

    for (let i = 0; i < values.length; i++) {
        const value = values[i];
        if (matcher(value)) {
            values.splice(i, 1);
            i--;
        }
    }
    const target = configTarget || vscode.ConfigurationTarget.Workspace;
	await config.update(section, values, target);
}

export async function setConfigValue<TValue>(config: vscode.WorkspaceConfiguration, section: string, newValue: TValue, configTarget?: vscode.ConfigurationTarget) {
	const target = configTarget || vscode.ConfigurationTarget.Workspace;
	await config.update(section, newValue, target);
}

export async function extendConfigObject(config: vscode.WorkspaceConfiguration, section: string, addition: object, configTarget?: vscode.ConfigurationTarget) {
	const value = config.get(section, {});
	
	const newValue = { ...value, ...addition };
	const target = configTarget || vscode.ConfigurationTarget.Workspace;
	await config.update(section, newValue, target);
}