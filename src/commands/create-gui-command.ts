import * as vscode from 'vscode';
import { saveWorkspaceFile } from '../utils/common';
import { CommandWithArgs } from './command';

export function registerCreateGuiCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.createGui', async (folder: vscode.Uri) => {
        if (!folder) {
            // TODO: it should be ok, just allow to select destination folder
            vscode.window.showErrorMessage('Select "Create Gui" from a folder\'s context menu (right mouse button click in Explorer panel).');
            return;
        }
        
		const cmd = new CreateGuiCommand(context);
		const result = await cmd.execute({ destination: folder });
        
        vscode.window.showInformationMessage(`Created files: ${result.createdFiles.join(', ')}`);
	}));
};

interface IInput { destination: vscode.Uri; }
interface IOutput { createdFiles: string[] }

class CreateGuiCommand extends CommandWithArgs<IInput, IOutput> {
    private absoluteFolder!: vscode.Uri;
    private id!: string;
    private options!: IOptions;
    private filenames!: { gui: string; guiScript: string; };
    private result = { createdFiles: new Array<string>() };

    async execute(input: IInput): Promise<IOutput> {
        this.absoluteFolder = input.destination;
        this.options = await this.promptUserOptions();

        this.filenames = {
            gui: `${this.id}.gui`,
            guiScript: `${this.id}.gui_script`,
        };
        await this.maybeCreateGuiScriptFile();
        await this.createGuiFile();

        return this.result;
    }
    
    private async promptUserOptions(): Promise<IOptions> {
        this.id = await promptId();

        const selectedChoises = await vscode.window.showQuickPick([
            { label: `${this.id}.gui_script`, picked: true, prop: 'withGuiScript' },
        ], {
            canPickMany: true,
		    ignoreFocusOut: true,
            placeHolder: 'Choose what to create',
        }) || [];

        const selectedOptions = selectedChoises.reduce((options, choise) => {
            options[choise.prop] = true;
            return options;
        }, <any>{}) as IOptions;

        return selectedOptions;
    }

    private async maybeCreateGuiScriptFile() {
        if (this.options.withGuiScript) {
            const lines = guiScriptFileLines();
            await this.saveFile(this.filenames.guiScript, lines);
        }
    }

    private async createGuiFile() {
        const lines = this.guiFileLines();
        await this.saveFile(this.filenames.gui, lines);
    }

    private guiFileLines(): string[] {
        if (!this.options.withGuiScript) {
            return [
                `script: ""`,
                `adjust_reference: ADJUST_REFERENCE_PARENT`,
                ``,
            ];
        }
        
        const lines = [];
        if (this.options.withGuiScript) {
            lines.push(`script: "${this.relativePath(this.filenames.guiScript)}"`);
            lines.push(`background_color {`);
            lines.push(`  x: 0.0`);
            lines.push(`  y: 0.0`);
            lines.push(`  z: 0.0`);
            lines.push(`  w: 0.0`);
            lines.push(`}`);
            lines.push(`material: "/builtins/materials/gui.material"`);
            lines.push(`adjust_reference: ADJUST_REFERENCE_PARENT`);
            lines.push(`max_nodes: 512`);
            lines.push(``);
        }
        lines.push(``);
        return lines;
    }

    relativePath(filename: string) {
        const relativeFolder = vscode.workspace.asRelativePath(this.absoluteFolder);
        return `/${relativeFolder}/${filename}`;
    }

    private async saveFile(filename: string, lines: string[]) {
        this.result.createdFiles.push(filename);
        const path = vscode.Uri.joinPath(this.absoluteFolder!, filename);
        await saveWorkspaceFile(path, lines.join('\n'));
    }
}

async function promptId(): Promise<string> {
    const placeholder = 'menu';
    const id = await vscode.window.showInputBox({
        title: 'Enter id of the new Gui',
        placeHolder: placeholder,
        ignoreFocusOut: true,
    });
    
    return id || placeholder;
}

function guiScriptFileLines(): string[] {
    return [
        `function init(self)`,
        `	-- Add initialization code here`,
        `	-- Learn more: https://defold.com/manuals/script/`,
        `	-- Remove this function if not needed`,
        `end`,
        ``,
        `function final(self)`,
        `	-- Add finalization code here`,
        `	-- Learn more: https://defold.com/manuals/script/`,
        `	-- Remove this function if not needed`,
        `end`,
        ``,
        `function update(self, dt)`,
        `	-- Add update code here`,
        `	-- Learn more: https://defold.com/manuals/script/`,
        `	-- Remove this function if not needed`,
        `end`,
        ``,
        `function on_message(self, message_id, message, sender)`,
        `	-- Add message-handling code here`,
        `	-- Learn more: https://defold.com/manuals/message-passing/`,
        `	-- Remove this function if not needed`,
        `end`,
        ``,
        `function on_input(self, action_id, action)`,
        `	-- Add input-handling code here. The game object this script is attached to`,
        `	-- must have acquired input focus:`,
        `	--`,
        `	--    msg.post(".", "acquire_input_focus")`,
        `	--`,
        `	-- All mapped input bindings will be received. Mouse and touch input will`,
        `	-- be received regardless of where on the screen it happened.`,
        `	-- Learn more: https://defold.com/manuals/input/`,
        `	-- Remove this function if not needed`,
        `end`,
        ``,
        `function on_reload(self)`,
        `	-- Add reload-handling code here`,
        `	-- Learn more: https://defold.com/manuals/hot-reload/`,
        `	-- Remove this function if not needed`,
        `end`,
        ``,
    ];
}

interface IOptions {
    withGuiScript: boolean;
}
