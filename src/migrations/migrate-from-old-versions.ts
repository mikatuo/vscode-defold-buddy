import * as vscode from 'vscode';
import { config } from '../config';
import { IState, StateMemento } from '../persistence/state-memento';
import { extendConfigArray, getWorkspacePath, removeFromConfigArray } from '../utils/common';

export async function migrateFromOldVersions(context: vscode.ExtensionContext) {
	const state = await StateMemento.load(context);
	if (!state) { return; }

	if (!state.lastMigration) { state.lastMigration = 0; }
    if (state.lastMigration >= config.lastMigration) { return; }

	if (state.lastMigration === 0) {
        // move .defold to .defold/api
		// move .defold/lib to .defold/assets
		await safelyRearrangeAnnotationFiles();
		await updateMigrationState(state, context);
	}
    if (state.lastMigration === 1) {
        // delete 'ext.manifest' files otherwise they cause errors when bundling
        await safelyDeleteExtmanifestFilesInAssetAnnotationFolder();
        await updateMigrationState(state, context);
    }
}

async function safelyRearrangeAnnotationFiles() {
    try {
        await vscode.workspace.fs.rename(
            await getWorkspacePath('.defold/lib')!,
            await getWorkspacePath('.defold/assets')!,
            { overwrite: false }
        );
    } catch { }

    // move .defold to .defold/api
    try {
        const filenames = await vscode.workspace.fs.readDirectory(await getWorkspacePath('.defold')!);
        for (const [filename] of filenames.filter(([filename, type]) => type === vscode.FileType.File)) {
            const source = getWorkspacePath(`.defold/${filename}`)!;
            await vscode.workspace.fs.copy(
                source,
                getWorkspacePath(`.defold/api/${filename}`)!,
                { overwrite: true }
            );
            await vscode.workspace.fs.delete(source);
        }
    } catch { }

    try {
        const workspaceConfig = vscode.workspace.getConfiguration();
        await removeFromConfigArray(workspaceConfig, 'Lua.workspace.library', x => x.startsWith('.defold'));
        await extendConfigArray(workspaceConfig, 'Lua.workspace.library', [
            '.defold/api',
            '.defold/assets',
        ]);
    } catch { }
}

async function safelyDeleteExtmanifestFilesInAssetAnnotationFolder() {
    try {
        const files = await vscode.workspace.findFiles('.defold/assets/**/ext.manifest');
        for (const file of files) {
            await vscode.workspace.fs.delete(file);
        }
    } catch { }
}

async function updateMigrationState(state: IState, context: vscode.ExtensionContext) {
    state.lastMigration!++;
    await StateMemento.save(context, state);
}
