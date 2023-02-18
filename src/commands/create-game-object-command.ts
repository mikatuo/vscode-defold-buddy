import * as vscode from 'vscode';
import { saveWorkspaceFile } from '../utils/common';
import { CommandWithArgs } from './command';

export function registerCreateGameObjectCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.createGameObject', async (folder: vscode.Uri) => {
        if (!folder) {
            // TODO: it should be ok, just allow to select destination folder
            vscode.window.showErrorMessage('Select "Create Game Object" from a folder\'s context menu (right mouse button click in Explorer panel).');
            return;
        }
        
		const cmd = new CreateGameObjectCommand(context);
		const result = await cmd.execute({ destination: folder });
        
        vscode.window.showInformationMessage(`Created files: ${result.createdFiles.join(', ')}`);
	}));
};

interface IInput { destination: vscode.Uri; }
interface IOutput { createdFiles: string[] }

class CreateGameObjectCommand extends CommandWithArgs<IInput, IOutput> {
    private absoluteFolder!: vscode.Uri;
    private id!: string;
    private options!: IOptions;
    private filenames!: { gameObject: string; script: string; factory: string; };
    private result = { createdFiles: new Array<string>() };

    async execute(input: IInput): Promise<IOutput> {
        this.absoluteFolder = input.destination;
        this.options = await this.promptUserOptions();

        this.filenames = {
            gameObject: `${this.id}.go`,
            script: `${this.id}.script`,
            factory: `${this.id}.factory`,
        };
        await this.maybeCreateScriptFile();
        await this.createGameObjectFile();
        await this.maybeCreateFactoryFile();

        return this.result;
    }
    
    private async promptUserOptions(): Promise<IOptions> {
        this.id = await promptId();

        const selectedChoises = await vscode.window.showQuickPick([
            { label: `#co`, description: 'collision object', picked: true, prop: 'withCollisionObject' },
            { label: `#sprite`, description: 'sprite', picked: true, prop: 'withSprite' },
            { label: `${this.id}.script`, picked: true, prop: 'withScript' },
            { label: `${this.id}.factory`, prop: 'withFactory' },
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

    private async maybeCreateScriptFile() {
        if (this.options.withScript) {
            const lines = scriptFileLines();
            await this.saveFile(this.filenames.script, lines);
        }
    }

    private async createGameObjectFile() {
        const lines = this.gameObjectFileLines();
        await this.saveFile(this.filenames.gameObject, lines);
    }

    private async maybeCreateFactoryFile() {
        if (this.options.withFactory) {
            const lines = this.factoryFileLines();
            await this.saveFile(this.filenames.factory, lines);
        }
    }

    private gameObjectFileLines(): string[] {
        if (!this.options.withCollisionObject && !this.options.withScript && !this.options.withSprite) {
            // create empty file when there are no components
            // otherwise Defold Editor will not open it
            return [''];
        }
        
        const lines = [];
        if (this.options.withScript) {
            lines.push(`components {`);
            lines.push(`  id: "${this.id}"`);
            lines.push(`  component: "${this.relativePath(this.filenames.script)}"`);
            lines.push(`  position {`);
            lines.push(`    x: 0.0`);
            lines.push(`    y: 0.0`);
            lines.push(`    z: 0.0`);
            lines.push(`  }`);
            lines.push(`  rotation {`);
            lines.push(`    x: 0.0`);
            lines.push(`    y: 0.0`);
            lines.push(`    z: 0.0`);
            lines.push(`    w: 1.0`);
            lines.push(`  }`);
            lines.push(`}`);
        }
        if (this.options.withCollisionObject) {
            lines.push(`embedded_components {`);
            lines.push(`  id: "co"`);
            lines.push(`  type: "collisionobject"`);
            lines.push(`  data: "collision_shape: \\"\\"\\n"`);
            lines.push(`  "type: COLLISION_OBJECT_TYPE_KINEMATIC\\n"`);
            lines.push(`  "mass: 0.0\\n"`);
            lines.push(`  "friction: 0.1\\n"`);
            lines.push(`  "restitution: 0.5\\n"`);
            lines.push(`  "group: \\"default\\"\\n"`);
            lines.push(`  "mask: \\"default\\"\\n"`);
            lines.push(`  "linear_damping: 0.0\\n"`);
            lines.push(`  "angular_damping: 0.0\\n"`);
            lines.push(`  "locked_rotation: false\\n"`);
            lines.push(`  "bullet: false\\n"`);
            lines.push(`  ""`);
            lines.push(`  position {`);
            lines.push(`    x: 0.0`);
            lines.push(`    y: 0.0`);
            lines.push(`    z: 0.0`);
            lines.push(`  }`);
            lines.push(`  rotation {`);
            lines.push(`    x: 0.0`);
            lines.push(`    y: 0.0`);
            lines.push(`    z: 0.0`);
            lines.push(`    w: 1.0`);
            lines.push(`  }`);
            lines.push(`}`);
        }
        if (this.options.withSprite) {
            lines.push(`embedded_components {`);
            lines.push(`  id: "sprite"`);
            lines.push(`  type: "sprite"`);
            lines.push(`  data: "tile_set: \\"\\"\\n"`);
            lines.push(`  "default_animation: \\"\\"\\n"`);
            lines.push(`  "material: \\"/builtins/materials/sprite.material\\"\\n"`);
            lines.push(`  "blend_mode: BLEND_MODE_ALPHA\\n"`);
            lines.push(`  ""`);
            lines.push(`  position {`);
            lines.push(`    x: 0.0`);
            lines.push(`    y: 0.0`);
            lines.push(`    z: 0.0`);
            lines.push(`  }`);
            lines.push(`  rotation {`);
            lines.push(`    x: 0.0`);
            lines.push(`    y: 0.0`);
            lines.push(`    z: 0.0`);
            lines.push(`    w: 1.0`);
            lines.push(`  }`);
            lines.push(`}`);
        }
        lines.push(``);
        return lines;
    }
    
    private relativePath(filename: string) {
        const relativeFolder = vscode.workspace.asRelativePath(this.absoluteFolder);
        return `/${relativeFolder}/${filename}`;
    }

    private factoryFileLines(): string[] {
        const lines = [];
        lines.push(`prototype: "${this.relativePath(this.filenames.gameObject)}"`);
        lines.push(`load_dynamically: false`);
        lines.push(``);
        return lines;
    }

    private async saveFile(filename: string, lines: string[]) {
        this.result.createdFiles.push(filename);
        const path = vscode.Uri.joinPath(this.absoluteFolder!, filename);
        await saveWorkspaceFile(path, lines.join('\n'));
    }
}

async function promptId(): Promise<string> {
    const placeholder = 'player';
    const id = await vscode.window.showInputBox({
        title: 'Enter id of the new Game Object',
        placeHolder: placeholder,
        ignoreFocusOut: true,
    });
    
    return id || placeholder;
}

function scriptFileLines(): string[] {
    return [
        `function init(self)`,
        `    -- Add initialization code here`,
        `    -- Learn more: https://defold.com/manuals/script/`,
        `    -- Remove this function if not needed`,
        `end`,
        ``,
        `function final(self)`,
        `    -- Add finalization code here`,
        `    -- Learn more: https://defold.com/manuals/script/`,
        `    -- Remove this function if not needed`,
        `end`,
        ``,
        `function update(self, dt)`,
        `    -- Add update code here`,
        `    -- Learn more: https://defold.com/manuals/script/`,
        `    -- Remove this function if not needed`,
        `end`,
        ``,
        `function fixed_update(self, dt)`,
        `    -- This function is only called if 'Use Fixed Timestep' is enabled in the Physics section of game.project`,
        `    -- Add update code here`,
        `    -- Learn more: https://defold.com/manuals/script/`,
        `    -- Remove this function if not needed`,
        `end`,
        ``,
        `function on_message(self, message_id, message, sender)`,
        `    -- Add message-handling code here`,
        `    -- Learn more: https://defold.com/manuals/message-passing/`,
        `    -- Remove this function if not needed`,
        `end`,
        ``,
        `function on_input(self, action_id, action)`,
        `    -- Add input-handling code here. The game object this script is attached to`,
        `    -- must have acquired input focus:`,
        `    --`,
        `    --    msg.post(".", "acquire_input_focus")`,
        `    --`,
        `    -- All mapped input bindings will be received. Mouse and touch input will`,
        `    -- be received regardless of where on the screen it happened.`,
        `    -- Learn more: https://defold.com/manuals/input/`,
        `    -- Remove this function if not needed`,
        `end`,
        ``,
        `function on_reload(self)`,
        `    -- Add reload-handling code here`,
        `    -- Learn more: https://defold.com/manuals/hot-reload/`,
        `    -- Remove this function if not needed`,
        `end`,
        ``,
    ];
}

interface IOptions {
    withCollisionObject: boolean;
    withScript: boolean;
    withSprite: boolean;
    withFactory: boolean;
}
