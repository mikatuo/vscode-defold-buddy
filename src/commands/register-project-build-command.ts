import * as vscode from 'vscode';
import axios from 'axios';

const editorBaseUrl = 'http://localhost';
const command = 'build';

export function registerProjectBuildCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.projectBuild', async () => {
		const editorPort = await getPortFromStateOrAskUser(context);
		
		// TODO: read port from logs
		// get the path to OS specific user data folder
		const osSpecificUserDataFolder = process.env.LOCALAPPDATA || (process.platform === 'darwin' ? process.env.HOME + '/Library/Preferences' : process.env.HOME + "/.local/share");
		console.log(osSpecificUserDataFolder);
        
		try {
			await axios.post(`${editorBaseUrl}:${editorPort}/command/${command}`, null, {
				timeout: 2000,
			});
		} catch (error) {
			vscode.window.showErrorMessage(`Is the Defold editor running? Failed to find it on port ${editorPort}.`);
			console.log(error);
		}
	}));
};

async function getPortFromStateOrAskUser(context: vscode.ExtensionContext) {
	const savedPort = await context.globalState.get<string>('defoldEditorPort', '');

	if (savedPort && await isDefoldEditorActive(savedPort)) {
		return savedPort;
	}
	
	const portFromUser = await vscode.window.showInputBox({
		title: 'Port of the running Defold editor',
		ignoreFocusOut: true,
	});
	await context.globalState.update('defoldEditorPort', portFromUser);

	if (!portFromUser) {
		return vscode.window.showInformationMessage(`No Defold Editor's port provided. Failed to execute ${command} command.`);
	}
	return portFromUser;
}

async function isDefoldEditorActive(port: string): Promise<boolean> {
	try {
		const response = await axios.get(`${editorBaseUrl}:${port}/command/`, {
			timeout: 1000,
		});
		return response.status >= 200 && response.status < 300;
	} catch {
		return false;
	}
}

