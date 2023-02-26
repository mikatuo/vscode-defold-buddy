import * as vscode from 'vscode';
import { config } from '../config';
import { constants } from '../constants';
import { IAsset, IState, StateMemento } from '../persistence/state-memento';
import { extendConfigArray, getWorkspacePath, readWorkspaceFile, removeFromConfigArray, safelyDeleteFolder, saveWorkspaceFile } from '../utils/common';
import { GameProjectConfig } from '../utils/game-project-config';
import { ZipArchiveManager } from '../utils/zip-archive-manager';

export async function registerUnzipProjectAssetsCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.unzipDependencies', async (folder: vscode.Uri) => {
        const state = await StateMemento.load(context);
        if (!state) { return; } // initialization was not performed

        const filenames = await readArchivedAssetFilenames();
        if (assetAnnotationsAreUpToDate(state, filenames)) { return; }

        console.log('Extracting dependencies...');
        state.assets = [];
        await safelyDeleteFolder(config.assetsAnnotationsFolder, { recursive: true, useTrash: false });
        // remove .defold/lib/ from the library paths in the Lua plugin settings
        // a workaround to make the Lua plugin reload lib files after they change
        await removeLuaWorkspaceLibrariesFromSettings();
        for await (const filename of filenames) {
            const unzippedAsset = await unzipAssetFromArchive(filename);
            await maybeEnhanceUnzippedAsset(unzippedAsset);
            // add .defold/lib/ into the library paths in the Lua plugin settings
            //await moveAssetIncludeFolderIntoAnnotationsFolder(unzippedAsset);
            state.assets.push(toAssetInfo(unzippedAsset, filename));
        }
        await addLuaWorkspaceLibrariesIntoSettings();
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

async function removeLuaWorkspaceLibrariesFromSettings() {
    const workspaceConfig = vscode.workspace.getConfiguration();
    await removeFromConfigArray(workspaceConfig, 'Lua.workspace.library', x => x.startsWith(config.assetsAnnotationsFolder));
}

async function addLuaWorkspaceLibrariesIntoSettings() {
    const workspaceConfig = vscode.workspace.getConfiguration();
    await extendConfigArray(workspaceConfig, 'Lua.workspace.library', [config.assetsAnnotationsFolder]);
}

async function addLuaWorkspaceLibrary(assetInfo: IArchivedAsset) {
    const workspaceConfig = vscode.workspace.getConfiguration();
    const rootAssetUri = vscode.Uri.joinPath(getWorkspacePath(config.assetsAnnotationsFolder)!, assetInfo.rootDirectory);
    const rootAssetFolder = vscode.workspace.asRelativePath(rootAssetUri);
    await extendConfigArray(workspaceConfig, 'Lua.workspace.library', [rootAssetFolder]);
}

async function maybeEnhanceUnzippedAsset(unzippedAsset: IArchivedAsset) {
    if (!unzippedAsset || !unzippedAsset.name) {
        return;
    }
    const assetsAnnotationsUri = getWorkspacePath(config.assetsAnnotationsFolder)!;
    switch (unzippedAsset.name.toLowerCase()) {
        case 'druid':
            const path = vscode.Uri.joinPath(assetsAnnotationsUri, unzippedAsset.includeDirectories[0], 'druid.lua');
            await safelyEditAssetFile(path, (content: string) => {
                return content.replace('local M = {}', 'local M = {} ---@type druid');
            });
            break;
        default:
            break;
    }
}

async function moveAssetIncludeFolderIntoAnnotationsFolder(unzippedAsset: IArchivedAsset) {
    const assetsAnnotationsPath = getWorkspacePath(config.assetsAnnotationsFolder)!;

    try {
        // move the /.defold/lib/{asset-name}/{include-dir} into /.defold/lib/{include-dir}
        const assetRootUri = vscode.Uri.joinPath(assetsAnnotationsPath, unzippedAsset.rootDirectory);
        for await (const includeDir of unzippedAsset.includeDirectories) {
            const assetIncludeUri = vscode.Uri.joinPath(assetRootUri, includeDir);
            const destinationUri = vscode.Uri.joinPath(assetsAnnotationsPath, includeDir);
            await vscode.workspace.fs.copy(assetIncludeUri, destinationUri);
        }
        await vscode.workspace.fs.delete(assetRootUri, { recursive: true, useTrash: false });
    } catch (ex) {
        console.error('Failed to move asset include folder into annotations folder.', ex);
    }
}

async function safelyEditAssetFile(path: vscode.Uri, mutator: (content: string) => string) {
    try {
        let fileContent = await readWorkspaceFile(path);
        fileContent = mutator(fileContent!);
        await saveWorkspaceFile(path, fileContent);
    } catch (ex) {
        console.error(`Failed to edit an unzipped asset file ${path.fsPath}.`, ex);
    }
}

async function unzipAssetFromArchive(filename: [string, vscode.FileType]): Promise<IArchivedAsset> {
    const zipUri = getWorkspacePath(`${constants.assetsInternalFolder}/${filename[0]}`)!;
    const destinationUri = getWorkspacePath(config.assetsAnnotationsFolder)!;
    
    const archiveManager = new ZipArchiveManager(zipUri.fsPath);
    const archivedAsset = await readAssetInfoFromArchive(archiveManager);

    // unzip the asset into /.defold/lib/asset-name/include-dir
    try {
        const includeDirs = getIncludeDirsInsideArchive(archivedAsset);
        await archiveManager.extractEntries(
            entry => includeDirs.includes(entry.relativePath),
            destinationUri,
            { overwrite: true },
        );
        return archivedAsset;
    } catch (ex) {
        console.error(`Failed to unzip asset '${archivedAsset.name}' from archive '${zipUri.fsPath}'.`, ex);
        return archivedAsset;
    }
}

function getIncludeDirsInsideArchive(archivedAsset: IArchivedAsset): string[] {
    return archivedAsset.includeDirectories.map(includeDir => {
        if (archivedAsset.rootDirectory !== '') {
            return `${archivedAsset.rootDirectory}/${includeDir}/`;
        } else {
            return `${includeDir.trim()}/`;
        }
    });
}

function toAssetInfo(unzippedAsset: IArchivedAsset, filename: [string, vscode.FileType]): IAsset {
    return {
        name: unzippedAsset.name,
        version: unzippedAsset.version,
        sourceArchiveFilename: filename[0],
    };
}

async function readAssetInfoFromArchive(archiveManager: ZipArchiveManager): Promise<IArchivedAsset> {
    try {
        const data = await archiveManager.readAsText('game.project');
        const config = GameProjectConfig.fromString(data!);
        return {
            name: config.title(),
            version: config.version(),
            rootDirectory: archiveManager.rootDirectory || '',
            includeDirectories: config.libraryIncludeDirs(),
        };
    } catch (e) {
        console.log(`Failed to read asset info from the archive. ${e}`);
        return {} as IArchivedAsset;
    }
}

interface IArchivedAsset {
    name: string;
    version: string;
    rootDirectory: string;
    includeDirectories: string[];
}
