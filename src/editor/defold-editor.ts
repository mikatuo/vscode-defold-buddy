import * as vscode from 'vscode';
import axios from 'axios';
import { promises as fs } from 'fs';
const readline = require('node:readline');
const { once } = require('node:events');
import { DefoldEditorLogsRepository } from "../utils/defold-editor-logs-repository";
import { openDefoldEditor } from '../utils/common';
import { Subject } from 'rxjs';
import { findRunningDefoldEngineService } from '../wip/findRunningDefoldGame';
import WebSocket = require('ws');
import { DataViewReader } from './dataViewReader';

const editorBaseUrl = 'http://localhost';

export enum EditorCommand {
    assetPortal = 'asset-portal', // Open the Asset Portal in a web browser
    build = 'build', // Build and run the project
    buildHtml5 = 'build-html5', // Build the project for HTML5 and open it in a web browser
    debuggerBreak = 'debugger-break', // Break into the debugger
    debuggerContinue = 'debugger-continue', // Resume execution in the debugger
    debuggerDetach = 'debugger-detach', // Detach the debugger from the running project
    debuggerStartOrAttach = 'debugger-start', // Start the project with the debugger, or attach the debugger to the running project
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
	showRunningDefoldEditorNotFoundWindow: boolean = true;
    $consoleLogs = new Subject<string>();
    
    constructor(context: vscode.ExtensionContext) {
        this.context = context;
    }
    
    async executeCommand(command: EditorCommand): Promise<{ running: boolean, port?: string }> {
        let portOfRunningEditor = await this.findRunningEditorOrAskToOpenOne(true /* detect port */);
		if (portOfRunningEditor) {
			await executeCommandInDefoldEditor(portOfRunningEditor, command);
			return { running: true, port: portOfRunningEditor };
		}
		return { running: false };
    }

	async findRunningEditor(detectPort = true): Promise<string | undefined> {
		let portOfRunningEditor = await getSavedPortOfRunningEditor(this.context);
		if (portOfRunningEditor) { return portOfRunningEditor; }
		if (detectPort) {
			portOfRunningEditor = await tryToFindRunningEditorPortFromLogFiles();
		}
        await savePort(this.context, portOfRunningEditor);
		return portOfRunningEditor;
	}

    async listenToConsoleLogs(port: string) {
		const engineService = await findRunningDefoldEngineService();
        if (!engineService) { return; }

        const editorConsole = await loadInitialDefoldEditorConsoleInfo(port);

		// output initial logs from the Defold editor
        for (const editorLogLine of editorConsole.logs!) {
            this.$consoleLogs.next(editorLogLine);
        }

		// before we start streaming logs from the editor
		// there is a chance that some of the logs will be missed
        const remotery = { address: editorConsole.remoteryAddress };
        streamDefoldEditorConsoleLogs(remotery, this.$consoleLogs);
    }

	async findRunningEditorOrAskToOpenOne(detectPort = true): Promise<string | undefined> {
		const portOfRunningEditor = await this.findRunningEditor(detectPort);
		if (portOfRunningEditor) { return portOfRunningEditor; }

		if (this.showRunningDefoldEditorNotFoundWindow) {
			const result = await askToOpenDefoldEditorOrInputPortOrShowErrorMessage();
			if (result.port) { await savePort(this.context, result.port); }
			if (result.retry) { return await this.findRunningEditorOrAskToOpenOne(false /* do not detect port */); }
		}
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

async function tryToFindRunningEditorPortFromLogFiles(): Promise<string | undefined> {
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

function askToOpenDefoldEditorOrInputPortOrShowErrorMessage(): Promise<{ retry: boolean; port?: string; }> {
	try {
		return askToOpenDefoldEditorOrInputPort();
	} catch {
		vscode.window.showErrorMessage('Failed to start Defold editor. Please start it and try again.');
		return Promise.resolve(doNotRetryBuildingProject);
	}
}

const doNotRetryBuildingProject = { retry: false };
async function askToOpenDefoldEditorOrInputPort(): Promise<{ retry: boolean; port?: string; }> {
	const answer = await vscode.window.showInformationMessage(
		'Running Defold editor is not found',
		'Open Defold', 'Input Port', 'Cancel'
	);
	switch (answer) {
		case 'Open Defold':
			await openDefoldEditor('game.project', process.platform);
			return doNotRetryBuildingProject;
		case 'Input Port':
			const port = await askUserForPort();
			if (!port) { return doNotRetryBuildingProject; }
			return { retry: true, port: port };
		default:
			return doNotRetryBuildingProject;
	}
}

async function askUserForPort(): Promise<string | undefined> {
	const portFromUser = await vscode.window.showInputBox({
		title: 'Port of the running Defold editor',
		prompt: 'How to find a port of your running Defold editor:\n In the menu open "Debug" > "Open Web Profiler". The profiler will open in a browser. Copy the port from the URL. In example, for http://localhost:XXXXX/engine-profiler the port will be XXXXX. Input the port into the text input above.',
		placeHolder: 'xxxxx',
		ignoreFocusOut: true,
	});
	return portFromUser;
}

async function loadInitialDefoldEditorConsoleInfo(port: string) {
	return await loadDefoldEditorLogsWithRemoteryAddress({
		port: port,
		retries: 30,
		retryDelayMs: 500,
	});
}

async function loadDefoldEditorLogsWithRemoteryAddress({ port, retries, retryDelayMs }: { port: string, retries: number, retryDelayMs: number }): Promise<{ success: boolean, logs?: string[], remoteryAddress?: string }> {
    const res = await loadEditorConsoleLogs(port);
    if (res.success) {
		const remoteryAddress = extractRemoteryAddressFrom(res.logs!);
		if (remoteryAddress) {
			return { success: true, logs: res.logs, remoteryAddress };
		}
	}
    if (retries === 0) { return { success: false }; }
    await new Promise(resolve => setTimeout(resolve, retryDelayMs));
    return loadDefoldEditorLogsWithRemoteryAddress({ port, retries: retries - 1, retryDelayMs });
}

function extractRemoteryAddressFrom(logs: string[]): string | undefined {
    const logLineWithRemoteryAddress = logs.find((line: string) => line.startsWith('INFO:DLIB: Initialized Remotery'));
    if (!logLineWithRemoteryAddress) { return; }

    // parse address from 'INFO:DLIB: Initialized Remotery (ws://127.0.0.1:17815/rmt)'
    const remoteryAddress = logLineWithRemoteryAddress.match(/ws:\/\/(\d+\.\d+\.\d+\.\d+):(\d+)\/rmt/);
	return remoteryAddress && remoteryAddress[0] || undefined;
}

async function loadEditorConsoleLogs(port: string): Promise<{ success: boolean, logs?: string[] }> {
    const response = await axios.get(`http://localhost:${port}/console`);
    if (response.status < 200 || response.status >= 300) { return { success: false }; }
    if (!response.data.lines.length) { return { success: false }; }

    return {
        success: true,
        logs: response.data.lines,
    };
}

function streamDefoldEditorConsoleLogs(params: { ip?: string; port?: string; address?: string }, $output: Subject<string>) {
    const address = params.address || `ws://${params.ip}:${params.port}/`;

    const ws = new WebSocket(address);
	ws.binaryType = 'arraybuffer';

    ws.on('error', function (err: any) {
		console.error(`Failed to read logs from Defold's remotery`, err);
	});

	ws.on('message', function (data: ArrayBuffer) {
		let data_view = new DataView(data);
		let data_view_reader = new DataViewReader(data_view, 0);

		// decode standard message header
		const id = data_view_reader.GetStringOfLength(4);
		const length = data_view_reader.GetUInt32() - 8;

		if (id === 'LOGM') {
			var text = data_view_reader.GetString();
			$output.next(text);
		}
    });
}