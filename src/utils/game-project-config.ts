import { readWorkspaceFile, saveWorkspaceFile } from './common';

export class GameProjectConfig {
    ini: GameProjectIniConfig;

    constructor(ini: GameProjectIniConfig) {
        this.ini = ini;
    }
    
    static fromString(content: string): GameProjectConfig {
        const ini = GameProjectIniConfig.fromString(content);
        return new GameProjectConfig(ini);
    }

    title(): string {
        const title = this.ini.get({ section: '[project]' }).find(x => x.key === 'title');
        return title ? title.value : '';
    }

    version(): string {
        const version = this.ini.get({ section: '[project]' }).find(x => x.key === 'version');
        return version ? version.value : '';
    }

    libraryIncludeDirs(): string[] {
        let includeDirs = this.ini.get({ section: '[library]' })
            .find(x => x.key === 'include_dirs')
            ?.value?.replace(/^\/|\/$/g, '') || '';
        return includeDirs.split(',').map(x => x.trim());
    }
}

export class GameProjectIniConfig {
    private filename!: string;
    private sections!: ISection[];

    static async fromFile(filename: string): Promise<GameProjectIniConfig> {
        const fileContent = await readWorkspaceFile(filename);
        if (!fileContent) {
            throw new Error(`Failed to read project settings from the ${filename} file`);
        }

        const project = this.fromString(fileContent);
        project.filename = filename;
        return project;
    }
    
    static fromString(content: string): GameProjectIniConfig {
        const project = new GameProjectIniConfig();
        project.sections = parseIni(content);
        return project;
    }

    get({ section: sectionName }: { section: string }): IValue[] | [] {
        const section = this.findSection(sectionName);
        if (!section) {
            return [];
        }

        return section.values;
    }

    isExtensionInstalled(extensionName: string): boolean {
        const projectSection = this.findSection('[project]');
        if (!projectSection) {
            return false;
        }

        return projectSection.values.some(x => x.key.startsWith('dependencies') && x.value.toLowerCase().includes(`/${extensionName.toLowerCase()}/`));
    }

    set({ section: sectionName, key, value }: { section: string, key: string, value: string }) {
        const existingSection = this.findSection(sectionName);
        
        if (existingSection) {
            // update ini section
            const existingValue = this.findValue(existingSection, key);
            if (existingValue) {
                existingValue.value = value;
            } else {
                existingSection.values.push({ key, value });
            }
        } else {
            // create ini section
            const newSection: ISection = {
                name: sectionName,
                values: [{ key, value }],
            };
            this.sections.push(newSection);
        }
    }

    async save(): Promise<boolean> {
        const fileContent = stringifyIni(this.sections);
        return await saveWorkspaceFile(this.filename, fileContent);
    }

    private findSection(section: string): ISection | undefined {
        const idx = this.sections.findIndex(x => x.name === section);
        return idx !== -1 ? this.sections[idx] : undefined;
    }

    private findValue(section: ISection, key: string): IValue | undefined {
        const idx = section.values.findIndex(x => x.key.toLowerCase() === key);
        return idx !== -1 ? section.values[idx] : undefined;
    }
}

/////////////////

function parseIni(content: string): ISection[] {
    const lines = content.split(/\r\n|\r|\n/);
    const sections = new Array<ISection>();

    let currentSection: ISection;
    for (const line of lines) {
        if (line.startsWith('[')) { // new section
            currentSection = { name: line.trim(), values: [] };
            sections.push(currentSection);
            continue;
        }
        if (!line.trim().length) { // skip empty lines
            continue;
        }

        // values
        const tokens = line.split(/ ?= ?/);
        const key = tokens[0].trim();
        const value = tokens.slice(1).join('');
        currentSection!.values.push({ key, value });
    }

    return sections;
}

function stringifyIni(sections: ISection[]) {
    const lines = [];

    for (const section of sections) {
        lines.push(section.name);

        for (const value of section.values) {
            lines.push(`${value.key} = ${value.value}`);
        }
        lines.push('');
    }
    lines.push('');
    return lines.join('\n');
}

interface ISection {
    name: string;
    values: IValue[];
}

interface IValue {
    key: string;
    value: string;
}
