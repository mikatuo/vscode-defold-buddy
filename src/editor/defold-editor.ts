import * as vscode from 'vscode';
import axios from 'axios';
import { promises as fs } from 'fs';
const readline = require('node:readline');
const { once } = require('node:events');
import { DefoldEditorLogsRepository } from "../utils/defold-editor-logs-repository";

const editorBaseUrl = 'http://localhost';

export enum EditorCommand {
    assetPortal = 'asset-portal', // Open the Asset Portal in a web browser
    build = 'build', // Build and run the project
    buildHtml5 = 'build-html5', // Build the project for HTML5 and open it in a web browser
    debuggerBreak = 'debugger-break', // Break into the debugger
    debuggerContinue = 'debugger-continue', // Resume execution in the debugger
    debuggerDetach = 'debugger-detach', // Detach the debugger from the running project
    debuggerStart = 'debugger-start', // Start the project with the debugger, or attach the debugger to the running project
    debuggerStepInto = 'debugger-step-into', // Step into the current expression in the debugger
    debuggerStepOut = 'debugger-step-out', // Step out of the current expression in the debugger
    debuggerStepOver = 'debugger-step-over', // Step over the current expression in the debugger
    debuggerStop = 'debugger-stop', // Stop the debugger and the running project
    documentation = 'documentation', // Open the Defold documentation in a web browser
    donatePage = 'donate-page', // Open the Donate to Defold page in a web browser
    editorLogs = 'editor-logs', // Show the directory containing the editor logs
    engineProfiler = 'engine-profiler', // Open the Engine Profiler in a web browser
    fetchLibraries = 'fetch-libraries', // Download the latest version of the project library dependencies
    hotReload = 'hot-reload', // Hot-reload all modified files into the running project
    issues = 'issues', // Open the Defold Issue Tracker in a web browser
    rebuild = 'rebuild', // Rebuild and run the project
    rebundle = 'rebundle', // Re-bundle the project using the previous Bundle dialog settings
    reloadExtensions = 'reload-extensions', // Reload editor extensions
    reloadStylesheets = 'reload-stylesheets', // Reload editor stylesheets
    reportIssue = 'report-issue', // Open the Report Issue page in a web browser
    reportSuggestion = 'report-suggestion', // Open the Report Suggestion page in a web browser
    showBuildErrors = 'show-build-errors', // Show the Build Errors tab
    showConsole = 'show-console', // Show the Console tab
    showCurveEditor = 'show-curve-editor', // Show the Curve Editor tab
    supportForum = 'support-forum', // Open the Defold Support Forum in a web browser
    togglePaneBottom = 'toggle-pane-bottom', // Toggle visibility of the bottom editor pane
    togglePaneLeft = 'toggle-pane-left', // Toggle visibility of the left editor pane
    togglePaneRight = 'toggle-pane-right', // Toggle visibility of the right editor pane
}

export class DefoldEditor {
    private context: vscode.ExtensionContext;
    
    constructor(context: vscode.ExtensionContext) {
        this.context = context;
    }
    
    async call(command: EditorCommand): Promise<boolean> {
        return await this.tryToFindRunningEditorAndExecuteCommand(command);
    }

    private async tryToFindRunningEditorAndExecuteCommand(command: EditorCommand): Promise<boolean> {
        let editorPort = await getSavedPortOfRunningEditor(this.context)
            || await tryToFindEditorPortFromLogFiles();
        await savePort(this.context, editorPort);

        if (editorPort && await isDefoldEditorRunning(editorPort)) {
            return await executeCommandInDefoldEditor(editorPort!, command);
        }
        return false;
    }
}


async function executeCommandInDefoldEditor(editorPort: string, command: EditorCommand): Promise<boolean> {
	try {
		const response = await axios.post(`${editorBaseUrl}:${editorPort}/command/${command}`, null, {
			timeout: 2000,
		});
        return response.status >= 200 && response.status < 300;
	} catch (error) {
		console.log(error);
        return false;
	}
}

async function getSavedPortOfRunningEditor(context: vscode.ExtensionContext): Promise<string | undefined> {
	const savedPort = await context.globalState.get<string>('defoldEditorPort', '');

	if (savedPort && await isDefoldEditorRunning(savedPort)) {
		return savedPort;
	} else {
		return undefined;
	}
}

async function tryToFindEditorPortFromLogFiles(): Promise<string | undefined> {
	const repo = new DefoldEditorLogsRepository();
	const recentLogFile = await repo.findRecentLogFile();
	if (!recentLogFile) { return undefined; } // failed to find the recent log file

	const foundPorts = await extractEditorPortsFrom(recentLogFile);
	
	// find the running editor that was started the most recently
	for await (const port of foundPorts) {
		if (await isDefoldEditorRunning(port)) {
			return port;
		}
	}
	return undefined; // no running editors found
}

async function savePort(context: vscode.ExtensionContext, editorPort: string | undefined) {
	await context.globalState.update('defoldEditorPort', editorPort);
}

async function isDefoldEditorRunning(port: string): Promise<boolean> {
	try {
		const response = await axios.get(`${editorBaseUrl}:${port}/command/`, {
			timeout: 1500,
		});
		return response.status >= 200 && response.status < 300;
	} catch {
		return false;
	}
}

async function extractEditorPortsFrom(logFile: string): Promise<string[]> {
	const result = new Array<string>();
	const file = await fs.open(logFile, 'r');
	
	const rl = readline.createInterface({
		input: file.createReadStream(),
		crlfDelay: Infinity
	});
	// read file line by line
	const localUrlRegex = new RegExp(/:local-url "(?<address>http:\/\/[^:]+):(?<port>\d+)"/);
	rl.on('line', (line: string) => {
		if (!line.includes('[JavaFX Application Thread]')) { return; }
		if (line.includes('util.http-server') && line.includes(':msg "Http server running"')) {
			const match = line.match(localUrlRegex);
			if (match) {
				result.push(match.groups!.port);
			}
		}
	});

	await once(rl, 'close');

	// return the most recent ports at the beginning of the array
	return result.reverse();
}
