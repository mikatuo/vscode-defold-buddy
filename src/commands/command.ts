import * as vscode from 'vscode';

export abstract class Command {
    context: vscode.ExtensionContext;

    constructor(context: vscode.ExtensionContext) {
        this.context = context;
    }

    abstract execute(): void;
}

export abstract class CommandWithArgs<TInput, TOutput> {
    context: vscode.ExtensionContext;

    constructor(context: vscode.ExtensionContext) {
        this.context = context;
    }

    abstract execute(args: TInput): Promise<TOutput>;
}