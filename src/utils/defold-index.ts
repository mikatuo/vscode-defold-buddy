export class DefoldIndex {
    static instance = new DefoldIndex();
    
    index: { [key: string]: IDefoldFile } = {};
    collections: IDefoldFile[] = [];
    gameObjects: IDefoldFile[] = [];
    collectionsByPath: { [key: string]: IDefoldFile } = {};
    gameObjectsByPath: { [key: string]: IDefoldFile } = {};

    // find components of a game object by script name
    findGameObjectComponents(script: string): IDefoldComponent[] {
        for (const go of this.gameObjects) {
            if (isScriptAttached(go, script)) {
                return go.components;
            }
        }
        return [];
    }
    
    // find instances of a collection by script name
	findCollectionInstances(script: string): IDefoldInstance[] {
        for (const collection of this.collections) {
            if (isScriptAttached(collection, script)) {
                return collection.instances;
            }
        }
        return [];
	}
}

export interface IDefoldFile {
    name: string;
    path: string;
    instances: IDefoldInstance[];
    components: IDefoldComponent[];
}

export interface IDefoldInstance {
    id: string;
    url: string;
    collection?: string; // referenced .collection
    prototype?: string; // referenced .go
	filename?: string;
    type?: string;
    instances: IDefoldInstance[];
    components: IDefoldComponent[];
}

export interface IDefoldComponent {
    id: string;
    url: string;
    component?: string;
    filename?: string;
    type?: string;
}

function isScriptAttached(file: IDefoldFile, script: string) {
    return file.components.some(x => x.component === script)
        || file.instances.some(x => x.components.some(y => y.component === script));
}
