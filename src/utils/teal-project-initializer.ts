import * as vscode from 'vscode';
import path = require('path');
import { readWorkspaceFile, saveWorkspaceFile } from './common';
import { config } from '../config';

export class TealProjectInitializer {
	extension: { id: string; path: string; };
	workspaceAnnotationsFolder: string;

	constructor(context: vscode.ExtensionContext) {
		this.extension = {
			id: context.extension.id,
			path: context.extension.extensionPath,
		};
		this.workspaceAnnotationsFolder = config.defoldAnnotationsFolder;
	}

	async run() {
		await appendLinesIntoFileOrCreateFile({
			path: '.gitignore',
			lines: [`/${config.defoldTealTypesFolder}/${config.defoldTealTypesFile}`],
		});
		await appendLinesIntoFileOrCreateFile({
			path: 'tlconfig.lua',
			lines: [
				'return {',
				'    gen_target = "5.1",',
				'    gen_compat = "off",',
				'    include = {"**/*.tl"},',
				`    global_env_def = "${config.defoldTealTypesFolder}/${config.defoldTealTypesFile.replace('.d.tl', '')}",`,
				'}',
			],
		});
		await vscode.commands.executeCommand('vscode-defold-ide.addDependency', {
			name: 'extension-teal',
			project_url: 'https://github.com/defold/extension-teal',
			auto: true,
		});
		await showTealDocumentation(this.extension);
	}
}

async function appendLinesIntoFileOrCreateFile({ path, lines }: { path: string, lines: string[] }) {
	const defignoreContent = await readWorkspaceFile(path);
	const defignoreLines = defignoreContent && defignoreContent.split(/\r\n|\r|\n/) || [];
	lines.forEach(pattern => {
		if (!defignoreLines.includes(pattern)) {
			defignoreLines.push(pattern);
		}
	});
	await saveWorkspaceFile(path, defignoreLines.join('\n'));
}

async function showTealDocumentation(extension: { id: string; path: string; }) {
	try {
		const tealReadmePath = path.join(extension.path, 'docs/TEAL_DEFOLD.md');
		await vscode.commands.executeCommand('markdown.showPreview', vscode.Uri.parse(tealReadmePath));
	} catch (error: any) {
		console.error('Failed to show Teal documentation', error);
	}
}
