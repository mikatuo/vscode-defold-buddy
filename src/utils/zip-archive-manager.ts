import * as vscode from 'vscode';
import * as crypto from 'crypto';
const AdmZip = require("adm-zip");

export class ZipArchiveManager {
    private zip: any;
    private zipEntries: any[];
    rootDirectory: string | undefined;
    
    constructor(archivePath: string) {
        this.zip = new AdmZip(archivePath);
        this.zipEntries = this.zip.getEntries();
        this.rootDirectory = getRootDirectory(this.zipEntries);
    }
    
    async readAsText(filename: string): Promise<string | undefined> {
        const entry = this.findZipEntry((entry: any) => entry.name === filename);
        if (!entry) { return Promise.resolve(undefined); }
        return await this.zip.readAsText(entry.entryName);
    }

    async extractAllEntries(destinationFolderUri: vscode.Uri, options: { overwrite?: boolean; }): Promise<void> {
        await this.zip.extractAllTo(destinationFolderUri.fsPath, /*overwrite*/ options.overwrite);
    }

    async extractEntry(entryName: string, destinationFolderUri: vscode.Uri, options: { overwrite?: boolean; }): Promise<void> {
        const entries = this.findZipEntries(entry => entry.entryName === entryName);
        const entry = entries.find(entry => entry.entryName === entryName);
        
        if (entry) {
            this.zip.extractEntryTo(entry.entryName, destinationFolderUri.fsPath, /*maintainEntryPath*/true, options.overwrite);
        }
    }

    async extractEntries(entryMatcher: (entry: IArchiveEntry) => boolean, destinationFolderUri: vscode.Uri, options: { overwrite?: boolean; }): Promise<void> {
        const entries = this.findZipEntries(entry => entryMatcher({ relativePath: entry.entryName }));
        for (const entry of entries) {
            let tempFolderUri = destinationFolderUri;
            if (!this.rootDirectory) {
                this.rootDirectory = crypto.randomUUID();
                tempFolderUri = vscode.Uri.joinPath(tempFolderUri, this.rootDirectory);
            }
            await this.zip.extractEntryTo(entry.entryName, tempFolderUri.fsPath, /*maintainEntryPath*/true, options.overwrite);

            const unzippedRootFolder = vscode.Uri.joinPath(destinationFolderUri, this.rootDirectory);
            const unzippedFilenames = await vscode.workspace.fs.readDirectory(unzippedRootFolder);
            for await (const filename of unzippedFilenames) {
                await moveFolder(
                    vscode.Uri.joinPath(unzippedRootFolder, filename[0]),
                    vscode.Uri.joinPath(destinationFolderUri, filename[0])
                );
            }
            await vscode.workspace.fs.delete(unzippedRootFolder, { recursive: true, useTrash: false });
        }
    }

    //////////////////////

    private findZipEntry(predicate: (entry: any) => boolean): any | undefined {
        for (const zipEntry of this.zipEntries) {
            if (predicate(zipEntry)) {
                return zipEntry;
            }
        }
    }
    
    private findZipEntries(predicate: (entry: any) => boolean): any[] {
        const result = [];
        for (const zipEntry of this.zipEntries) {
            if (predicate(zipEntry)) {
                result.push(zipEntry);
            }
        }
        return result;
    }
}

export interface IArchiveEntry {
    relativePath: string;
}

function getRootDirectory(zipEntries: any[]): string | undefined {
    const rootEntry = zipEntries[0];
    return rootEntry.isDirectory && rootEntry.entryName.replace(/\/$/, '') || undefined;
}

async function moveFolder(sourceUri: vscode.Uri, destinationUri: vscode.Uri) {
    try {
        await vscode.workspace.fs.copy(sourceUri, destinationUri);
        await vscode.workspace.fs.delete(sourceUri, { recursive: true, useTrash: false });
    } catch (ex) {
        console.error('Failed to move asset include folder into annotations folder.', ex);
    }
}
