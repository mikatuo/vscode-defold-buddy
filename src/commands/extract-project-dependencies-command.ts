import * as vscode from 'vscode';
import { config } from '../config';
import { constants } from '../constants';
import { IAsset, IState, StateMemento } from '../persistence/state-memento';
import { extendConfigArray, getWorkspacePath, readWorkspaceFile, removeFromConfigArray, safelyDeleteFolder, saveWorkspaceFile } from '../utils/common';
import { GameProjectConfig } from '../utils/game-project-config';
const AdmZip = require("adm-zip");

export async function registerUnzipProjectAssetsCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.unzipDependencies', async (folder: vscode.Uri) => {
        const state = await StateMemento.load(context);
        if (!state) { return; } // initialization was not performed

        const filenames = await readArchivedAssetFilenames();
        if (assetAnnotationsAreUpToDate(state, filenames)) { return; }

        console.log('Extracting dependencies...');
        state.assets = [];
        await safelyDeleteFolder(config.assetsAnnotationsFolder, { recursive: true, useTrash: false });
        // a workaround to make the Lua plugin to reload lib files after they change
        await removeValueFromVsCodeWorkspaceSettings('Lua.workspace.library', config.assetsAnnotationsFolder);
        for (const filename of filenames) {
            const unzippedAsset = await unzipOnlyIncludedAssetFolder(filename);
            await maybeEnhanceUnzippedAsset(unzippedAsset);
            state.assets.push(toAssetInfo(unzippedAsset, filename));
            // add the /.defold/lib into the workspace library
            // so that they are available for intellisense
            await addValueToVsCodeWorkspaceSettings('Lua.workspace.library', config.assetsAnnotationsFolder);
        }
        await StateMemento.save(context, state);
	}));
};

async function readArchivedAssetFilenames() {
    try {
        const dependenciesInternalPath = getWorkspacePath(constants.assetsInternalFolder);
        const archiveFilenames = await vscode.workspace.fs.readDirectory(dependenciesInternalPath!);
        return archiveFilenames;
    } catch (ex) {
        console.error('Failed to read archived assets.', ex);
        return [];
    }
}

function assetAnnotationsAreUpToDate(state: IState, filenames: [string, vscode.FileType][]) {
    if (state.assets.length !== filenames.length) {
        return false;
    }
    const existingAssetFilenames = state.assets.map(asset => asset.sourceArchiveFilename);
    const someAreDifferent = filenames.some(filename => !existingAssetFilenames.includes(filename[0]));
    const allAreUpToDate = !someAreDifferent;
    return allAreUpToDate;
}

async function removeValueFromVsCodeWorkspaceSettings(section: string, valueToRemove: string) {
    const workspaceConfig = vscode.workspace.getConfiguration();
    await removeFromConfigArray(workspaceConfig, section, valueToRemove);
}

async function addValueToVsCodeWorkspaceSettings(section: string, addition: string) {
    const workspaceConfig = vscode.workspace.getConfiguration();
    await extendConfigArray(workspaceConfig, section, [addition]);
}

async function unzipOnlyIncludedAssetFolder(filename: [string, vscode.FileType]) {
    const zipUri = getWorkspacePath(`${constants.assetsInternalFolder}/${filename[0]}`);
    const destinationUri = getWorkspacePath(config.assetsAnnotationsFolder);
    const unzippedAsset = await unzipAssetFromArchive(zipUri!, destinationUri!);
    return unzippedAsset;
}

async function maybeEnhanceUnzippedAsset(unzippedAsset: IArchivedAsset) {
    if (!unzippedAsset || !unzippedAsset.name) {
        return;
    }
    switch (unzippedAsset.name.toLowerCase()) {
        case 'druid':
            await safelyEditAssetFile(unzippedAsset, 'druid.lua', (content: string) => {
                return content.replace('local M = {}', 'local M = {} ---@type druid');
            });
            break;
        default:
            break;
    }
}

async function safelyEditAssetFile(unzippedAsset: IArchivedAsset, filename: string, mutator: (content: string) => string) {
    try {
        const druidLuaFileUri = vscode.Uri.joinPath(unzippedAsset.unzippedUri!, 'druid.lua');
        let fileContent = await readWorkspaceFile(druidLuaFileUri);
        fileContent = mutator(fileContent!);
        await saveWorkspaceFile(druidLuaFileUri, fileContent);
    } catch (ex) {
        console.error(`Failed to edit an unzipped asset file ${filename} in '${unzippedAsset.name}' asset.`, ex);
    }
}

async function unzipAssetFromArchive(zipUri: vscode.Uri, destinationFolderUri: vscode.Uri): Promise<IArchivedAsset> {
    const zip = new AdmZip(zipUri.fsPath);
    const zipEntries = zip.getEntries();
    const assetInfo = await readAssetInfoFromArchive(zip, zipEntries);

    // unzip the asset into /.defold/lib/asset-name/include-dir
    const includeDirRelativePathInsideArchive = `${assetInfo.rootDirInArchive}/${assetInfo.includeDirectory}/`;
    const includeDirZipEntry = findZipEntry(zipEntries, (entry: any) => entry.entryName === includeDirRelativePathInsideArchive);
    zip.extractEntryTo(includeDirZipEntry.entryName, destinationFolderUri.fsPath, /*maintainEntryPath*/true, /*overwrite*/true);
    assetInfo.unzippedUri = vscode.Uri.joinPath(destinationFolderUri, includeDirRelativePathInsideArchive);
    return assetInfo;
}

function toAssetInfo(unzippedAsset: IArchivedAsset, filename: [string, vscode.FileType]): IAsset {
    return {
        name: unzippedAsset.name,
        version: unzippedAsset.version,
        sourceArchiveFilename: filename[0],
    };
}

function findZipEntry(zipEntries: any[], predicate: (entry: any) => boolean): any {
    for (const zipEntry of zipEntries) {
        if (predicate(zipEntry)) {
            return zipEntry;
        }
    }
}

function readAssetInfoFromArchive(zip: any, zipEntries: any[]): IArchivedAsset {
    try {
        const gameProjectZipEntry = findZipEntry(zipEntries, (entry: any) => entry.name === 'game.project');
        
        const rootDirName = zipEntries[0].entryName.replace(/\/$/, '');
        const rootDirNameParts = rootDirName.split('-');
    
        const data = zip.readAsText(gameProjectZipEntry.entryName);
        const config = GameProjectConfig.fromString(data);
        const includeDir = config.get({ section: '[library]' }).find(x => x.key === 'include_dirs')!.value;
        return {
            name: includeDir,
            version: rootDirNameParts[rootDirNameParts.length - 1],
            rootDirInArchive: rootDirName,
            includeDirectory: includeDir,
        };
    } catch (e) {
        console.log(`Something went wrong. ${e}`);
    }
    return {} as IArchivedAsset;
}

interface IArchivedAsset {
    name: string;
    version: string;
    rootDirInArchive: string;
    includeDirectory: string;
    unzippedUri?: vscode.Uri;
}
