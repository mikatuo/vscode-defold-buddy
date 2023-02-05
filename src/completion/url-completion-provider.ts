import * as vscode from 'vscode';
import { load } from 'protobufjs';
import { readWorkspaceFileBytes } from '../utils/common';
import { DefoldIndex, IDefoldComponent, IDefoldInstance } from '../utils/defold-file-indexer';

export async function registerUrlCompletionItemProvider(context: vscode.ExtensionContext) {
    const urlCompletion = vscode.languages.registerCompletionItemProvider('lua', {
        provideCompletionItems(document: vscode.TextDocument, position: vscode.Position, token: vscode.CancellationToken, context: vscode.CompletionContext) {
			if (!showUrlCompletion(document, position)) { return undefined; }
			const script = vscode.workspace.asRelativePath(document.uri);

			return completionIfAttachedToGameObject(script)
				|| completionIfAttachedToCollection(script);
        },
    }, '"', ':');
    
	context.subscriptions.push(urlCompletion);
}

function showUrlCompletion(document: vscode.TextDocument, position: vscode.Position): boolean {
	if (!document.uri.path.endsWith('.script')) {
		return false;
	}
	
	const linePrefix = document.lineAt(position).text.substring(0, position.character);
	if (linePrefix.endsWith('"') || !linePrefix.endsWith('"#') || /"\w+:$/.test(linePrefix)) {
		return true;
	}

	return false;
}

function completionIfAttachedToGameObject(scriptPath: string): vscode.CompletionItem[] | undefined {
	const components = DefoldIndex.instance.findGameObjectComponents(`/${scriptPath}`);
	if (!components) { return undefined; }
	return components.map(componentCompletionItem);
}

function completionIfAttachedToCollection(script: string): vscode.CompletionItem[] | undefined {
	const instances = DefoldIndex.instance.findCollectionInstances(`/${script}`);
	if (!instances) { return undefined; }
	return instances.flatMap(instanceCompletionItem);
}

function instanceCompletionItem(instance: IDefoldInstance): vscode.CompletionItem[] {
	const item = new vscode.CompletionItem({
		label: instance.url,
		detail: ` ${instance.type}`,
		description: instance.filename,
	}, vscode.CompletionItemKind.Text);
	item.filterText = instance.url;

	return [
		item,
		...[...instance.instances].flatMap(instanceCompletionItem),
		...instance.components.map(componentCompletionItem),
	];
}

function componentCompletionItem(component: IDefoldComponent): vscode.CompletionItem {
	const item = new vscode.CompletionItem({
		label: component.url,
		detail: ` ${component.type}`,
		description: component.filename,
	}, vscode.CompletionItemKind.Text);
	item.filterText = component.id;
	return item;
}

////////////////

async function indexWorkspaceCollections2(context: vscode.ExtensionContext) {
	const path = vscode.Uri.joinPath(context.extensionUri, 'src', 'completion', 'gameobject.proto');
	load(path.fsPath, async function(err, root) {
		if (err) {
			throw err;
		}
		
		// example code
		const collectionDescription = root!.lookupType('dmGameObjectDDF.CollectionDesc');
		
		// let message = collectionDescription.create({ awesomeField: 'hello' });
		// console.log(`message = ${JSON.stringify(message)}`);
		
		// let buffer = collectionDescription.encode(message).finish();
		// console.log(`buffer = ${Array.prototype.toString.call(buffer)}`);
		
		let collectionData = await readWorkspaceFileBytes('main/test.collection');
		if (collectionData) {
			try {
				let decoded = collectionDescription.decode(collectionData);
				console.log(`decoded = ${JSON.stringify(decoded)}`);
			} catch (err) {
				console.error(err);
			}
		}
	});
}
