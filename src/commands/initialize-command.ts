import axios from 'axios';
import * as vscode from 'vscode';
import { config } from '../config';
import { StateMemento } from '../persistence/state-memento';
import { getWorkspacePath } from '../utils/common';
import { ConfigInitializer } from '../utils/config-initializer';
import { ZipArchiveManager } from '../utils/zip-archive-manager';

export function registerInitializeCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.initialize', async () => {
		const selectedRelease = await setupDefoldApiAnnotations(context);
		await setupRecommendedVscodeSettings(context);

		if (selectedRelease) {
			await saveInitializedState(context, selectedRelease);
		} else {
			vscode.window.showErrorMessage('Please select version of Defold used for this project.');
		}
		vscode.window.showInformationMessage('Happy Defolding!');
	}));
}

async function setupDefoldApiAnnotations(context: vscode.ExtensionContext): Promise<IDefoldLuaAnnotationRelease | undefined> {
	const releases = await getDefoldLuaAnnotationReleasesFromGithub();
	const selectedRelease = await askWhichReleaseToUse(releases);
	if (!selectedRelease) { return undefined; }

	let archiveUri = await getAlreadyDownloadedAnnotations(context, selectedRelease);
	if (!archiveUri) {
		archiveUri = await downloadApiAnnotations(context, selectedRelease);
	}
	await extractAnnotations(archiveUri);
	return selectedRelease;
}

async function setupRecommendedVscodeSettings(context: vscode.ExtensionContext) {
	const initializer = new ConfigInitializer(context);
	await initializer.run();
}

async function saveInitializedState(context: vscode.ExtensionContext, selectedRelease: IDefoldLuaAnnotationRelease) {
	await StateMemento.save(context, {
		version: selectedRelease.version,
		assets: [],
	});
}

async function getDefoldLuaAnnotationReleasesFromGithub(): Promise<IDefoldLuaAnnotationRelease[]> {
	const response = await axios.get('https://api.github.com/repos/mikatuo/defold-lua-annotations/releases');
	if (response.status < 200 || response.status >= 300 || !response.data) {
		throw new Error(`Failed to fetch Lua annotations for Defold API. Status code: ${response.status}`);
	}

	const releases = parseReleases(response.data);
	return releases.filter(x => !x.draft && x.assets.apiAnnotationsUrl)
		.sort((a, b) => b.version.localeCompare(a.version));
}

async function askWhichReleaseToUse(releases: IDefoldLuaAnnotationRelease[]): Promise<IDefoldLuaAnnotationRelease | undefined> {
	const choises = releases.map(x => ({ label: x.name, release: x }));
	const selection = await vscode.window.showQuickPick(choises, {
		placeHolder: 'Select Defold version of the current project.',
		ignoreFocusOut: true,
	});
	return selection?.release;
}

async function getAlreadyDownloadedAnnotations(context: vscode.ExtensionContext, release: IDefoldLuaAnnotationRelease): Promise<vscode.Uri | undefined> {
	const archiveUri = getArchiveCachePath(context, release);
	try {
		const stats = await vscode.workspace.fs.stat(archiveUri);
		return stats.type === vscode.FileType.File
			? archiveUri
			: undefined;
	} catch {
		return undefined;
	}
}

async function downloadApiAnnotations(context: vscode.ExtensionContext, release: IDefoldLuaAnnotationRelease): Promise<vscode.Uri> {
	const response = await axios.get(release.assets.apiAnnotationsUrl!, { responseType: 'arraybuffer' });
	if (response.status === 200 && response.data) {
		const archiveUri = getArchiveCachePath(context, release);
		try { await vscode.workspace.fs.delete(archiveUri, { useTrash: false }); } catch {}
		await vscode.workspace.fs.writeFile(archiveUri, response.data);
		return archiveUri;
	} else {
		throw new Error(`Failed to download Lua annotations for Defold. Status code: ${response.status}`);
	}
}

async function extractAnnotations(archiveUri: vscode.Uri) {
	const archiveManager = new ZipArchiveManager(archiveUri.fsPath);
	await archiveManager.extractAllEntries(
		getWorkspacePath(config.defoldAnnotationsFolder)!,
		{ overwrite: true },
	);
}

function parseReleases(data: IGithubRelease[]): IDefoldLuaAnnotationRelease[] {
	return data.map(x => {
		const defoldApiAnnotations = x.assets.find((a: IGithubReleaseAsset) => a.name.startsWith('defold-lua-') && a.name.endsWith('.zip'));
		const helperModule = x.assets.find((a: IGithubReleaseAsset) => a.name.startsWith('defoldy-') && a.name.endsWith('.zip'));
		return {
			version: x.tag_name,
			name: x.name,
			draft: x.draft,
			prerelease: x.prerelease,
			assets: {
				apiAnnotationsUrl: defoldApiAnnotations?.browser_download_url,
				helperModuleUrl: helperModule?.browser_download_url,
			},
		};
	});
}

function getArchiveCachePath(context: vscode.ExtensionContext, release: IDefoldLuaAnnotationRelease) {
	return vscode.Uri.joinPath(context.extensionUri, 'cache', 'api', `${release.version}.zip`);
}

interface IDefoldLuaAnnotationRelease {
	name: string;
	version: string;
	draft: boolean;
	prerelease: boolean;
	assets: {
		apiAnnotationsUrl: string | undefined;
		helperModuleUrl: string | undefined;
	};
}

/* eslint-disable @typescript-eslint/naming-convention */
interface IGithubRelease {
	tag_name: string;
	name: string;
	draft: boolean;
	prerelease: boolean;
	assets: IGithubReleaseAsset[];
}

interface IGithubReleaseAsset {
	name: string;
	browser_download_url: string;
}
