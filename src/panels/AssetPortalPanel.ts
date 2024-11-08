import * as vscode from 'vscode';
import { Disposable, Webview, WebviewPanel, Uri, ViewColumn } from "vscode";
import { getUri } from "../utilities/getUri";
import { getNonce } from "../utilities/getNonce";
import { IAssetMetadata } from '../types/asset-metadata';

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

async function addProjectDependency(asset: { name: string, project_url: string, library_url?: string }): Promise<void> {
    await vscode.commands.executeCommand('vscode-defold-ide.addDependency', asset);
}
