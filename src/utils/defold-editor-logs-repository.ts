import { promises as fs } from 'fs';
import path = require('path');

export class DefoldEditorLogsRepository {
    async findRecentLogFile(): Promise<string | undefined> {
		// get the path to OS specific user data folder
		const osSpecificUserDataFolder = process.env.LOCALAPPDATA || (process.platform === 'darwin' ? process.env.HOME + '/Library/Preferences' : process.env.HOME + "/.local/share");
		console.log(osSpecificUserDataFolder);

        // if windows
        if (process.platform === 'win32') {
            const appDataDefoldFolder = `${osSpecificUserDataFolder}\\Defold\\`;
            const logFilenames = (await fs.readdir(appDataDefoldFolder))
                // TODO: pass today and yesterday as parameter
                .filter(createdAt(todayOrYesterday()))
                .sort().reverse();
            if (!logFilenames.length) { return undefined; }
            
            const recentLogFilename = logFilenames[0];
            return path.join(appDataDefoldFolder, recentLogFilename);
        }
        return undefined;
    }
}

function todayOrYesterday(): string[] {
    const today = new Date();
    // yesterday
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    // format as yyyy-mm-dd
    return [formatDate(today), formatDate(yesterday)];
}

function createdAt(dates: string[]): any {
    const filenames = dates.map(date => `editor2.${date}.log`);
    return (path: string) => {
        return filenames.some(filename => path.endsWith(filename));
    };
}

function formatDate(date: Date): string {
    return new Date(date.getTime() - (date.getTimezoneOffset() * 60000 ))
                .toISOString().slice(0, 10);
}