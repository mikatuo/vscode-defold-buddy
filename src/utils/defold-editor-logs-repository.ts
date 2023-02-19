import { promises as fs } from 'fs';
import path = require('path');

export class DefoldEditorLogsRepository {
    async findRecentLogFile(): Promise<string | undefined> {
        try {
            const logFolder = getLogFolder('Defold');

            const recentLogFilenames = (await fs.readdir(logFolder))
                .filter(createdAt(todayOrYesterday()))
                .sort().reverse();
            if (!recentLogFilenames.length) { return undefined; }
            
            const recentLogFilename = recentLogFilenames[0];
            return path.join(logFolder, recentLogFilename);
        } catch (error) {
            return undefined;
        }
    }
}

function getLogFolder(applicationName: string) {
    // windows
    if (process.platform === 'win32') {
        return path.join(process.env.LOCALAPPDATA!, applicationName);
    }
    // mac
    if (process.platform === 'darwin') {
        return path.join(process.env.HOME!, 'Library', 'Application Support', applicationName);
    }
    // linux
    return path.join(process.env.HOME!, `.${applicationName}`);
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