import * as vscode from 'vscode';

export class OutputChannels {
    private static _defoldBuddy: vscode.OutputChannel;

    private constructor() {}

    public static get defoldBuddy(): vscode.OutputChannel {
        return OutputChannels._defoldBuddy;
    }

    public static set defoldBuddy(value: vscode.OutputChannel) {
        if (OutputChannels._defoldBuddy) {
            OutputChannels._defoldBuddy?.dispose();
        }
        OutputChannels._defoldBuddy = value;
    }
}
