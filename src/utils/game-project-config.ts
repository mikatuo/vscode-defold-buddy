import { readWorkspaceFile, saveWorkspaceFile } from './common';

export class GameProjectConfig {
    private filename!: string;
    private sections!: ISection[];
    
    static async fromFile(filename: string): Promise<GameProjectConfig> {
        const project = new GameProjectConfig();

        const fileContent = await readWorkspaceFile(filename);
        if (!fileContent) {
            throw new Error(`Failed to read project settings from the ${filename} file`);
        }
        
        project.filename = filename;
        project.sections = parseIni(fileContent);

        return project;
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
