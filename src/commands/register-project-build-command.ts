import * as vscode from 'vscode';
import axios from 'axios';
import { promises as fs } from 'fs';
const readline = require('node:readline');
const { once } = require('node:events');
import { DefoldEditorLogsRepository } from '../utils/defold-editor-logs-repository';

const editorBaseUrl = 'http://localhost';
const command = 'build';

export function registerProjectBuildCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.projectBuild', async () => {
		let editorPort = await getSavedPortOfRunningEditor(context)
			|| await tryToFindEditorPortFromLogFiles()
			|| await askUserForPort(context);
		await savePort(context, editorPort);

		if (!editorPort) { return vscode.window.showInformationMessage(`No Defold Editor's port provided. Failed to execute ${command} command.`); }
		if (!isDefoldEditorRunning(editorPort)) { vscode.window.showErrorMessage(`Failed to find running Defold editor with port ${editorPort}. Please try again.`); }
		
		await executeCommandInDefoldEditor(editorPort, command);
	}));
};

async function executeCommandInDefoldEditor(editorPort: string, command: string) {
	try {
		await axios.post(`${editorBaseUrl}:${editorPort}/command/${command}`, null, {
			timeout: 2000,
		});
	} catch (error) {
		console.log(error);
	}
}

async function getSavedPortOfRunningEditor(context: vscode.ExtensionContext): Promise<string | undefined> {
	const savedPort = await context.globalState.get<string>('defoldEditorPort', '');

	if (savedPort && await isDefoldEditorRunning(savedPort)) {
		return savedPort;
	} else {
		return undefined;
	}
}

async function tryToFindEditorPortFromLogFiles(): Promise<string | undefined> {
	const repo = new DefoldEditorLogsRepository();
	const recentLogFile = await repo.findRecentLogFile();
	if (!recentLogFile) { return undefined; }

	const foundPorts = await extractEditorPortsFrom(recentLogFile);
	
	// extract port from recent log files and see if any of the editors
	// are still running
	for await (const port of foundPorts) {
		if (await isDefoldEditorRunning(port)) {
			return port;
		}
	}
	return undefined; // no running editors found
}

async function askUserForPort(context: vscode.ExtensionContext): Promise<string | undefined> {
	const portFromUser = await vscode.window.showInputBox({
		title: 'Port of the running Defold editor',
		ignoreFocusOut: true,
	});
	return portFromUser;
}

async function savePort(context: vscode.ExtensionContext, editorPort: string | undefined) {
	await context.globalState.update('defoldEditorPort', editorPort);
}

async function isDefoldEditorRunning(port: string): Promise<boolean> {
	try {
		const response = await axios.get(`${editorBaseUrl}:${port}/command/`, {
			timeout: 1500,
		});
		return response.status >= 200 && response.status < 300;
	} catch {
		return false;
	}
}

async function extractEditorPortsFrom(logFile: string): Promise<string[]> {
	const result = new Array<string>();
	const file = await fs.open(logFile, 'r');
	
	const rl = readline.createInterface({
		input: file.createReadStream(),
		crlfDelay: Infinity
	});
	// read file line by line
	const localUrlRegex = new RegExp(/:local-url "(?<address>http:\/\/[^:]+):(?<port>\d+)"/);
	rl.on('line', (line: string) => {
		if (!line.includes('[JavaFX Application Thread]')) { return; }
		if (line.includes('util.http-server') && line.includes(':msg "Http server running"')) {
			const match = line.match(localUrlRegex);
			if (match) {
				result.push(match.groups!.port);
			}
		}
	});

	await once(rl, 'close');

	// return the most recent ports at the beginning of the array
	return result.reverse();
}
