import * as vscode from 'vscode';
import { Disposable, Webview, WebviewPanel, Uri, ViewColumn } from "vscode";
import { getUri } from "../utilities/getUri";
import { getNonce } from "../utilities/getNonce";
import { GameProjectIniConfig } from '../utils/game-project-config';
import { IAssetMetadata } from '../types/asset-metadata';
import axios from 'axios';
import { IGithubRelease, IGithubRepository } from '../types/github';

export class AssetPortalPanel {
    public static currentPanel: AssetPortalPanel | undefined;
    private readonly _panel: WebviewPanel;
    private _disposables: Disposable[] = [];

    private constructor(panel: WebviewPanel, extensionUri: Uri) {
        this._panel = panel;

        // Set an event listener to listen for when the panel is disposed (i.e. when the user closes
        // the panel or when the panel is closed programmatically)
        this._panel.onDidDispose(() => this.dispose(), null, this._disposables);

        // Set the HTML content for the webview panel
        this._panel.webview.html = this._getWebviewContent(this._panel.webview, extensionUri);

        // Set an event listener to listen for messages passed from the webview context
        this._setWebviewMessageListener(this._panel.webview);
    }

    /**
     * Renders the current webview panel if it exists otherwise a new webview panel
     * will be created and displayed.
     *
     * @param extensionUri The URI of the directory containing the extension.
     */
    public static render(extensionUri: Uri) {
        if (AssetPortalPanel.currentPanel) {
            // If the webview panel already exists reveal it
            AssetPortalPanel.currentPanel._panel.reveal(ViewColumn.One);
        } else {
            // If a webview panel does not already exist create and show a new one
            const panel = vscode.window.createWebviewPanel(
                // Panel view type
                "defoldAssetPortal",
                // Panel title
                "Defold Asset Portal",
                // The editor column the panel should be displayed in
                ViewColumn.One,
                // Extra panel configurations
                {
                    // Enable JavaScript in the webview
                    enableScripts: true,
                    // Restrict the webview access to resources
                    localResourceRoots: [
                        Uri.joinPath(extensionUri, "out"),
                        Uri.joinPath(extensionUri, "webview-ui/public/build"),
                        Uri.joinPath(extensionUri, "webview-ui/public/assets"),
                    ],
                }
            );

            AssetPortalPanel.currentPanel = new AssetPortalPanel(panel, extensionUri);
        }
    }

    postMessage(message: any) {
        this._panel.webview.postMessage(message);
    }

    /**
     * Cleans up and disposes of webview resources when the webview panel is closed.
     */
    public dispose() {
        AssetPortalPanel.currentPanel = undefined;

        // Dispose of the current webview panel
        this._panel.dispose();

        // Dispose of all disposables (i.e. commands) for the current webview panel
        while (this._disposables.length) {
            const disposable = this._disposables.pop();
            if (disposable) {
                disposable.dispose();
            }
        }
    }

    /**
     * Defines and returns the HTML that should be rendered within the webview panel.
     *
     * @remarks This is also the place where references to the Svelte webview build files
     * are created and inserted into the webview HTML.
     *
     * @param webview A reference to the extension webview
     * @param extensionUri The URI of the directory containing the extension
     * @returns A template string literal containing the HTML that should be
     * rendered within the webview panel
     */
    private _getWebviewContent(webview: Webview, extensionUri: Uri) {
        // The CSS file from the Svelte build output
        const stylesUri = getUri(webview, extensionUri, ["webview-ui", "public", "build", "bundle.css"]);
        // The JS file from the Svelte build output
        const scriptUri = getUri(webview, extensionUri, ["webview-ui", "public", "build", "bundle.js"]);

        const nonce = getNonce();
        
        const baseUrl = getUri(webview, extensionUri, ["webview-ui", "public"]);

        // Tip: Install the es6-string-html VS Code extension to enable code highlighting below
        return /*html*/ `
            <!DOCTYPE html>
            <html lang="en">
                <head>
                <title>Hello World</title>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta http-equiv="Content-Security-Policy" content="default-src 'none'; connect-src 'self' https://api.github.com https://raw.githubusercontent.com ${webview.cspSource}; style-src ${webview.cspSource}; script-src 'nonce-${nonce}'; img-src https: data:;">
                <link rel="stylesheet" type="text/css" href="${stylesUri}">
                <script defer nonce="${nonce}" src="${scriptUri}"></script>
                <script nonce="${nonce}">
                    window.baseUrl = '${baseUrl}';
                </script>
                </head>
                <body>
                </body>
            </html>
        `;
    }

    /**
     * Sets up an event listener to listen for messages passed from the webview context and
     * executes code based on the message that is recieved.
     *
     * @param webview A reference to the extension webview
     * @param context A reference to the extension context
     */
    private _setWebviewMessageListener(webview: Webview) {
        webview.onDidReceiveMessage(
            (message: any) => {
                const command = message.command;
                const text = message.text;

                switch (command) {
                    case 'hello':
                        vscode.window.showInformationMessage(text);
                        return;
                    case 'add_dependency':
                        const asset = JSON.parse(text) as IAssetMetadata;
                        addProjectDependency(asset);
                        return;
                    case 'copy_dependency':
                        vscode.window.showInformationMessage(text);
                        return;
                }
            },
            undefined,
            this._disposables
        );
    }
}

// TODO: create a command
async function addProjectDependency(asset: IAssetMetadata): Promise<void> {
    const match = asset.project_url.match(/github.com\/(?<author>[^\/]+)\/(?<repo>[^\/]+)/);
    const githubAuthor = match?.groups?.author;
    const githubRepo = match?.groups?.repo;

    if (await isExtensionInstalled(`${githubAuthor}/${githubRepo}`)) {
        vscode.window.showWarningMessage(`'${asset.name}' is already in your game.project`);
        return;
    }

    const releases = (await fetchGithubReleases(githubAuthor!, githubRepo!))?.slice(0, 20);

    // ask user to choose which release to use
    if (releases.length) {
        const selectedRelease = await askWhichReleaseToUse(releases);
        if (!selectedRelease) { return; } // exit - user cancelled selection
        const dependencyZipUrl = getSourceCodeZipUrl(selectedRelease);
        return await addZipUrlIntoGameProject(asset, dependencyZipUrl); // exit - done
    }

    const repository = await fetchGithubRepoInfo(githubAuthor, githubRepo);

    // ask to use master/main branch
    if (repository?.default_branch) {
        const defaultBranch = repository.default_branch;
        const latest = { tag_name: 'latest', body: `${defaultBranch} branch`, published_at: '' } as IGithubRelease;
        const selectedRelease = await askWhichReleaseToUse([latest]);
        if (!selectedRelease) { return; } // exit - user cancelled selection
        const dependencyZipUrl = `https://github.com/${githubAuthor}/${githubRepo}/archive/${defaultBranch}.zip`;
        return await addZipUrlIntoGameProject(asset, dependencyZipUrl); // exit - done
    }

    // as last resort, try to use the library_url
    if (asset.library_url?.trim()) {
        return await addZipUrlIntoGameProject(asset, asset.library_url); // exit - done
    }

    vscode.window.showErrorMessage(`Failed to add '${asset.name}' into your game.project`);
}

async function fetchGithubRepoInfo(githubAuthor: string | undefined, githubRepo: string | undefined): Promise<IGithubRepository | undefined> {
    const response = await axios.get(`https://api.github.com/repos/${githubAuthor}/${githubRepo}`);
    if (response.status < 200 || response.status >= 300) {
        return undefined;
    }
    return response.data as IGithubRepository;
}

async function fetchGithubReleases(githubAuthor: string, githubRepo: string): Promise<IGithubRelease[]> {
    return new Promise((resolve, reject) => {
        vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Fetching releases...',
        }, async (progress, token) => {
            const response = await axios.get(`https://api.github.com/repos/${githubAuthor}/${githubRepo}/releases`);
            const releases = response.data as IGithubRelease[];
            resolve(releases);
        });
    });
}

async function isExtensionInstalled(name: string): Promise<boolean> {
    const config = await GameProjectIniConfig.fromFile('game.project');
    return config.isExtensionInstalled(name);
}

async function addZipUrlIntoGameProject(asset: IAssetMetadata, dependencyZipUrl: string) {
    const config = await GameProjectIniConfig.fromFile('game.project');
    const values = config.get({ section: '[project]' });
    const dependencyIndexes = values.filter((v) => v.key.startsWith('dependencies'))
        .map((v) => parseInt(v.key.split('#')[1]))
        .sort();
    const nextIndex = (dependencyIndexes[dependencyIndexes.length - 1] + 1) || 0;
    config.set({
        section: '[project]',
        key: `dependencies#${nextIndex}`,
        value: dependencyZipUrl,
    });
    const configSaved = await config.save();
    if (configSaved) {
        vscode.commands.executeCommand('vscode-defold-ide.projectFetchLibraries', { silently: true });
        vscode.window.showInformationMessage(`'${asset.name}' has been added into your game.project: ${dependencyZipUrl}`);
    } else {
        vscode.window.showErrorMessage('Failed to update the game project config');
    }
}

async function askWhichReleaseToUse(releases: IGithubRelease[]): Promise<IGithubRelease | undefined> {
	const choises = releases.map(release => {
        const name = release.tag_name;
        const description = (!!release.body && release.body || release.name)?.replace(release.tag_name, '')?.trim();
        const publishDate = release.published_at.split('T')[0];
        const label = publishDate ? `${name} (${publishDate})` : name;
        return { label, description, release };
    });
	const selection = await vscode.window.showQuickPick(choises, {
		placeHolder: 'Pick a release',
		ignoreFocusOut: true,
	});
	return selection?.release;
}

function getSourceCodeZipUrl(x: IGithubRelease) {
    return x.html_url.replace('/releases/tag/', '/archive/refs/tags/') + '.zip';
}
