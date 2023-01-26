const ini = require('ini');
import { readWorkspaceFile, saveWorkspaceFile } from './common';

export class GameProjectConfig {
    private filename!: string;
    private config: any;
    
    static async fromFile(filename: string): Promise<GameProjectConfig> {
        const project = new GameProjectConfig();

        const fileContent = await readWorkspaceFile(filename);
        if (!fileContent) {
            throw new Error(`Failed to read project settings from the ${filename} file`);
        }
        
        project.filename = filename;
        project.config = ini.parse(fileContent);

        return project;
    }

    set({ section, key, value }: { section: string, key: string, value: string }) {
        if (!this.config[section]) {
            this.config[section] = {};
        }
        this.config[section][key] = value;
    }

    async save(): Promise<boolean> {
        const fileContent = ini.stringify(this.config);
        return await saveWorkspaceFile(this.filename, fileContent);
    }
}