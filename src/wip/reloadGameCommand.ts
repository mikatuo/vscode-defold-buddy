import * as vscode from 'vscode';
import axios from 'axios';
import { load, Root } from 'protobufjs';
import { readWorkspaceFile } from '../utils/common';
const descriptor = require('protobufjs/ext/descriptor');

export function registerListenGameLogsCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.reloadGame', async () => {
		vscode.window.showInformationMessage('Testing...');

		//await findRunningDefoldEngineService();
		await reloadGame(context);
	}));
}

//////////////////////

async function reloadGame(context: vscode.ExtensionContext) {
	let path = vscode.Uri.joinPath(context.extensionUri, 'src/proto/resource/resource_ddf.proto');
	let root = await loadProto(path);

	console.log('BINGO', root);

	// const message = 'dmResourceDDF.Reload';
	// const payload = { resources: [''] };

	const message = 'dmResourceDDF.Reload';
	const payload = { resources: ['/main/main.script'] };

	const buffer = createMessage(root, message, payload);
	
	// PING
	try {
		const response = await axios.get('http://192.168.56.1:8002/ping');
		console.log('response', response);
	} catch (err) {
		console.error('ERROR', err);
	}

	// POST
	try {
		const response = await axios.post('http://192.168.56.1:8002/post', buffer);
		console.log('response', response);
	} catch (err) {
		console.error('ERROR', err);
	}

	
	path = vscode.Uri.joinPath(context.extensionUri, 'src/proto/gameobject.proto');
	root = await loadProto(path);

	const collectionDesc = root!.lookupType('dmGameObjectDDF.CollectionDesc');
	let data = await readWorkspaceFile('main/main.collection');
	if (data) {
		try {
			
			//let decoded = collectionDesc.decode(data!);
			//console.log(`decoded = ${JSON.stringify(decoded)}`);
		} catch (err) {
			console.error(err);
		}
	}
}

async function loadProto(path: vscode.Uri): Promise<Root> {
	return new Promise((resolve, reject) => {
		load(path.fsPath, async function(err, root) {
			if (err) {
				return reject(err);
			}
			resolve(root!);
		});
	});
}

function createMessage(root: Root, type: string, payload: any) {
	const message = root!.lookupType(type);
	var errMsg = message.verify(payload);
	if (errMsg) { throw Error(errMsg); }
	const msg = message.create(payload);
	const buffer = message.encode(msg).finish();
	return buffer;
}
