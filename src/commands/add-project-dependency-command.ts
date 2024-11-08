import * as vscode from 'vscode';
import { IGithubRelease, IGithubRepository } from '../types/github';
import { GameProjectIniConfig } from '../utils/game-project-config';
import axios from 'axios';

export function registerAddProjectDependencyCommand(context: vscode.ExtensionContext) {
    context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.addDependency', async (params: { name: string, project_url: string, library_url?: string, auto: boolean }) => {
        const match = params.project_url.match(/github.com\/(?<author>[^\/]+)\/(?<repo>[^\/]+)/);
        const githubAuthor = match?.groups?.author;
        const githubRepo = match?.groups?.repo;

        if (await isExtensionInstalled(`${githubAuthor}/${githubRepo}`)) {
            if (!params.auto) {
                vscode.window.showWarningMessage(`'${params.name}' is already in your game.project`);
            }
            return;
        }

        const releases = (await fetchGithubReleases(githubAuthor!, githubRepo!))?.slice(0, 20);

        // ask user to choose which release to use
        if (releases.length) {
            const selectedRelease = params.auto
                ? releases[0]
                : await askWhichReleaseToUse(releases);
            if (!selectedRelease) { return; } // exit - user cancelled selection
            const dependencyZipUrl = getSourceCodeZipUrl(selectedRelease);
            return await addZipUrlIntoGameProject(params.name, dependencyZipUrl); // exit - done
        }

        const repository = await fetchGithubRepoInfo(githubAuthor, githubRepo);

        // ask to use master/main branch
        if (repository?.default_branch) {
            const defaultBranch = repository.default_branch;
            const latest = { tag_name: 'latest', body: `${defaultBranch} branch`, published_at: '' } as IGithubRelease;
            const selectedRelease = params.auto
                ? latest
                : await askWhichReleaseToUse([latest]);
            if (!selectedRelease) { return; } // exit - user cancelled selection
            const dependencyZipUrl = `https://github.com/${githubAuthor}/${githubRepo}/archive/${defaultBranch}.zip`;
            return await addZipUrlIntoGameProject(params.name, dependencyZipUrl); // exit - done
        }

        // as last resort, try to use the library_url
        if (params.library_url?.trim()) {
            return await addZipUrlIntoGameProject(params.name, params.library_url); // exit - done
        }

        vscode.window.showErrorMessage(`Failed to add '${params.name}' into your game.project`);
    }));
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

async function addZipUrlIntoGameProject(assetName: string, dependencyZipUrl: string) {
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
        vscode.window.showInformationMessage(`'${assetName}' has been added into your game.project: ${dependencyZipUrl}`);
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
