import type { IAssetMetadata } from "../types/assetMetadata";
import { vscode } from "./vscode";

export default class StateManager {
    public static load(): IAssetPortalWebViewState {
        const state = vscode.getState();
        if (state) {
            return state as IAssetPortalWebViewState;
        }
        return {
            assets: [],
        };
    }

    static save(state: IAssetPortalWebViewState) {
        vscode.setState(state);
    }
}

interface IAssetPortalWebViewState {
    assets: IAssetMetadata[];
}