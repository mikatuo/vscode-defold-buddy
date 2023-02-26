import * as vscode from 'vscode';

export class StateMemento {
    static async load(context: vscode.ExtensionContext) {
        const state = await context.workspaceState.get<IState>('defoldApiAnnotations');
        if (state && !state.assets) {
            state.assets = [];
        }
        return state;
    }

    static async save(context: vscode.ExtensionContext, newState: IState) {
        await context.workspaceState.update('defoldApiAnnotations', newState);
    }
}

export interface IState {
	version: string;
    assets: IAsset[];
    lastMigration?: number;
}

export interface IAsset {
    name: string;
    version: string;
    sourceArchiveFilename: string;
}
