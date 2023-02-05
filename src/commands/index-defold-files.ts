import * as vscode from 'vscode';
import { DefoldFileIndexer } from '../utils/defold-file-indexer';
import { Command } from './command';

export class IndexDefoldFiles extends Command {
    async execute() {
        // TODO: read config from extension settings: 1) index automatically? 2) do not index some files? 3) ignore certain types?
        
        vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Indexing',
            cancellable: true,
        }, async (progress, token) => {
            progress.report({ message: 'game files for autocompletion' });
            await DefoldFileIndexer.indexWorkspace(token);
        });
    }
}