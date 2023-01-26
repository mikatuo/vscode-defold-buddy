import * as vscode from 'vscode';

export abstract class Command {
    context: vscode.ExtensionContext;

    constructor(context: vscode.ExtensionContext) {
        this.context = context;
    }

    abstract execute(): void;
}