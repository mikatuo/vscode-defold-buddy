import * as vscode from 'vscode';
import { StateMemento } from '../persistence/state-memento';
import { extendConfigArray, getWorkspacePath, removeFromConfigArray } from '../utils/common';

export async function migrateFromOldVersions(context: vscode.ExtensionContext) {
	const state = await StateMemento.load(context);
	if (!state || state.lastMigration === 1) { return; }

	if (!state.lastMigration) { state.lastMigration = 0; }

	if (state.lastMigration === 0) {
        // move .defold to .defold/api
		// move .defold/lib to .defold/assets
		await rearrangeAnnotationFiles();

		state.lastMigration++;
		await StateMemento.save(context, state);
	}
}

async function rearrangeAnnotationFiles() {
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

