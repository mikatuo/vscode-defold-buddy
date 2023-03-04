import * as vscode from 'vscode';
import * as path from 'path';
import { readWorkspaceFile } from './common';
import { DefoldIndex, IDefoldComponent, IDefoldFile, IDefoldInstance } from './defold-index';

const defaultInclude = '**/*.{go,collection}';
const defaultExclude = '.defold/**';

export { DefoldIndex, IDefoldComponent, IDefoldFile, IDefoldInstance };

export class DefoldFileIndexer {
    private index = new DefoldIndex();
    
    static async indexWorkspace(token?: vscode.CancellationToken): Promise<DefoldIndex> {
        console.log('Indexing: started');
        const indexer = new DefoldFileIndexer();
        const files = await vscode.workspace.findFiles(defaultInclude, defaultExclude, undefined, token);
        for (const file of files) {
            await indexer.add(file);
        }
        indexer.resolveReferencedInstances();
        console.log('Indexing: completed');
        return DefoldIndex.instance = indexer.index;
    }

    private async add(fullPath: vscode.Uri) {
        const relativePath = vscode.workspace.asRelativePath(fullPath.path);

        // TODO: [config] filter out components by type or name
        const lines = await readLines(fullPath);
        const result = extractDefoldInstances(lines);
        result.path = `/${relativePath}`;
        result.name = path.parse(relativePath).name;

        this.index.index[`/${relativePath}`] = result;
        if (fullPath.path.endsWith('.collection')) {
            this.index.collections.push(result);
            this.index.collectionsByPath[`/${relativePath}`] = result;
        }
        if (fullPath.path.endsWith('.go')) {
            this.index.gameObjects.push(result);
            this.index.gameObjectsByPath[`/${relativePath}`] = result;
        }
    }
    
    private resolveReferencedInstances() {
        for (const collection of this.index.collections) {
            for (const instance of collection.instances) {
                this.resolveReferences(instance);
            }
        }
    }

    private resolveReferences(instance: IDefoldInstance): IDefoldInstance {
        // resolve collection references
        if (instance.collection) {
            const referencedCollection = this.index.collectionsByPath[instance.collection];
            if (referencedCollection) {
                instance.instances = [
                    ...instance.instances,
                    ...referencedCollection.instances.map(x => {
                        return this.resolveReferences({
                            ...x,
                            url: `${instance.url}${x.url}`,
                        });
                    }),
                ];
            }
        }
        // resolve game object references
        if (instance.prototype) {
            const referencedGameObject = this.index.gameObjectsByPath[instance.prototype];
            if (referencedGameObject) {
                instance.components = [
                    ...instance.components,
                    ...referencedGameObject.components.map(x => {
                        return {
                            ...x,
                            url: `${instance.url}${x.url}`,
                        };
                    }),
                ];
            }
        }
        return instance;
    }
}

//////////////////////////////

async function readLines(path: vscode.Uri) {
    let fileContent = await readWorkspaceFile(path);
    const lines = fileContent!.split(/\r\n|\r|\n/);
    return lines;
}

function extractDefoldInstances(lines: string[]): IDefoldFile {
    const result = {
        name: '', // assigned later
        path: '', // assigned later
        instances: new Array<IDefoldInstance>(),
        components: new Array<IDefoldComponent>()
    };
    for (let i = 0; i < lines.length; i++) {
        let line = lines[i];

        const id = parseId(line);
        if (!id) { continue; }

        switch (identifyType(lines[i - 1])) {
            case DefoldObjectType.instance:
                const x = {
                    id: id,
                    url: `/${id}`,
                    collection: maybeParse(lines[i + 1], 'collection:'),
                    prototype: maybeParse(lines[i + 1], 'prototype:'),
                    instances: [],
                    components: [],
                    type: '',
                } as IDefoldInstance;
                x.filename = path.basename(x.collection || x.prototype || '');
                if (x.filename) {
                    x.type = x.filename.split('.')[1];
                } else if (lines[i + 1].includes('components {')) {
                    x.type = 'go';
                }
                result.instances.push(x);
                break;
            case DefoldObjectType.component:
                const parent = result.instances[result.instances.length - 1];
                if (parent) { // parsing a .component file
                    const c = {
                        id: id,
                        url: `/${parent.id}#${id}`,
                        component: maybeParse(lines[i + 1], 'component:'),
                    } as IDefoldComponent;
                    c.filename = path.basename(c.component || '');
                    c.type = c.filename ? c.filename.split('.')[1] : maybeParse(lines[i + 1], 'type:');
                    parent.components.push(c);
                } else { // parsing a .go file
                    const c = {
                        id: id,
                        url: `#${id}`,
                        component: maybeParse(lines[i + 1], 'component:'),
                    } as IDefoldComponent;
                    c.filename = path.basename(c.component || '');
                    c.type = c.filename ? c.filename.split('.')[1] : maybeParse(lines[i + 1], 'type:');
                    result.components.push(c);
                }
                break;
        }
    }
    return result;
}

const cleanUpRegex = new RegExp(/^[\s"]*|\\n"$/g);
const idRegex = new RegExp(/^id: "(?<id>.+)"$/);
function parseId(line: string): string | undefined {
	line = line.replace(cleanUpRegex, '');
	if (!line.startsWith('id:')) {
		return undefined;
	}
    // clean up embedded instances & components
    line = line.replace(/\\"/g, '"');
	const match = idRegex.exec(line);
	const id = match!.groups!['id'];
	return id;
}

function identifyType(line: string): DefoldObjectType {
    if (line.includes('components')) {
        return DefoldObjectType.component;
    }
    if (line.includes('instances')) {
        return DefoldObjectType.instance;
    }
    return DefoldObjectType.unknown;
}

function maybeParse(line: string, key: string): string | undefined {
    const idx = line.indexOf(key);
    if (idx !== -1) {
        const value = line.substring(idx + key.length).replace(/^\s*"|"$/g, '');
        if (line.endsWith('\\n"')) {
            // clean up embedded instances and components
            return value.replace(/^\s*\\"|\\"\\n$/g, '');
        }
        return value;
    }
    return undefined;
}

enum DefoldObjectType {
    unknown,
    instance,
    component,
}
