import * as vscode from 'vscode';
import * as crypto from 'crypto';
import { saveWorkspaceFile } from '../utils/common';
import { CommandWithArgs } from './command';
import { GameProjectIniConfig } from '../utils/game-project-config';

export function registerCreateLuaModuleCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.createLuaModule', async (folder: vscode.Uri) => {
        const templateType = vscode.workspace.getConfiguration('Defold').get<string>('template.luaModule') || 'compact';

        if (!folder) {
            const doc = await vscode.workspace.openTextDocument({
                language: 'lua',
                content: luaModuleLines(templateType).join('\r'),
            });
            // show preview with name "New Lua Module", place cursor at line 9
            const position = new vscode.Position(doc.lineCount - 3, 0);
            await showTextDocument(doc, position);
            return;
        }
        
		const cmd = new CreateLuaModuleCommand(context);
		await cmd.execute({ destination: folder });

        if (templateType === 'preprocessor') {
            // https://forum.defold.com/t/extension-lua-preprocessor-small-and-simple-lua-preprocessor/72449
            await ensureLuaPreprocessorExtensionIsInstalled();
        }
	}));
};

interface IInput { destination: vscode.Uri; }
interface IOutput { createdFiles: string[] }

class CreateLuaModuleCommand extends CommandWithArgs<IInput, IOutput> {
    private absoluteFolder!: vscode.Uri;
    private name!: string;
    private filenames!: { lua: string; };
    private result = { createdFiles: new Array<string>() };

    async execute(input: IInput): Promise<IOutput> {
        this.absoluteFolder = input.destination;
        this.name = await promptName();

        this.filenames = {
            lua: `${this.name}.lua`,
        };
        await this.createLuaModuleFile();
        await this.showLuaModuleFile();

        return this.result;
    }

    private async createLuaModuleFile() {
        const templateType = vscode.workspace.getConfiguration('Defold').get<string>('template.lua') || 'compact';
        const lines = luaModuleLines(templateType);
        await this.saveFile(this.filenames.lua, lines);
    }

    private async showLuaModuleFile() {
        const path = vscode.Uri.joinPath(this.absoluteFolder!, this.filenames.lua);
        const doc: vscode.TextDocument = await vscode.workspace.openTextDocument(path);
        // show preview with name "New Lua Module", place cursor at line 9
        const position = new vscode.Position(doc.lineCount - 3, 0);
        await showTextDocument(doc, position);
    }

    private async saveFile(filename: string, lines: string[]) {
        this.result.createdFiles.push(filename);
        const path = vscode.Uri.joinPath(this.absoluteFolder!, filename);
        await saveWorkspaceFile(path, lines.join('\n'));
    }
}

async function showTextDocument(doc: vscode.TextDocument, position: vscode.Position) {
    const selection = new vscode.Selection(position, position);
    await vscode.window.showTextDocument(doc, { preview: true, selection: selection });
}

function luaModuleLines(templateType: string): string[] {
    const uniqueVariableName = `GlobalModule_${crypto.randomUUID().replace(/-/g, '')}`;

    if (templateType === 'preprocessor') {
        return [
            `--#IF DEBUG`,
            `${uniqueVariableName} = ${uniqueVariableName} or {}`,
            `local M = ${uniqueVariableName} -- this module can be hot-reloaded during development`,
            `--#ELSE`,
            `local M = {} ---@diagnostic disable-line: redefined-local`,
            `--#ENDIF`,
            ``,
            ``,
            ``,
            `return M`,
        ];
    } else {
        return [
            `local M = {}`,
            ``,
            ``,
            ``,
            `return M`,
        ];
    }
}

async function promptName(): Promise<string> {
    const placeholder = 'module';
    const id = await vscode.window.showInputBox({
        title: 'Enter name of the module',
        placeHolder: placeholder,
        ignoreFocusOut: true,
    });
    
    return id || placeholder;
}
async function ensureLuaPreprocessorExtensionIsInstalled() {
    const config = await GameProjectIniConfig.fromFile('game.project');

    if (config.isExtensionInstalled('extension-lua-preprocessor')) {
        return;
    }
    // add the extension
    const extensionSourceUrl = 'https://github.com/defold/extension-lua-preprocessor/archive/refs/tags/1.0.0.zip';
    const values = config.get({ section: '[project]' });
    const dependencyIndexes = values.filter((v) => v.key.startsWith('dependencies'))
        .map((v) => parseInt(v.key.split('#')[1]))
        .sort();
    const nextIndex = (dependencyIndexes[dependencyIndexes.length - 1] + 1) || 0;
    config.set({
        section: '[project]',
        key: `dependencies#${nextIndex}`,
        value: extensionSourceUrl,
    });
    const configSaved = await config.save();
    if (!configSaved) { vscode.window.showErrorMessage('Failed to update the game project config'); }
    vscode.window.showInformationMessage(`Added 'extension-lua-preprocessor' extension into your game.project. Please run 'Fetch Libraries' from the menu in the Defold Editor to install it.`);
}

