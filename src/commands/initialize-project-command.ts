import axios from 'axios';
import * as vscode from 'vscode';
import { config } from '../config';
import { StateMemento } from '../persistence/state-memento';
import { getWorkspacePath } from '../utils/common';
import { LuaProjectInitializer } from '../utils/lua-project-initializer';
import { TealProjectInitializer } from '../utils/teal-project-initializer';
import { ZipArchiveManager } from '../utils/zip-archive-manager';
import { IGithubRelease, IGithubReleaseAsset } from '../types/github';

export function registerInitializeProjectCommand(context: vscode.ExtensionContext) {
	context.subscriptions.push(vscode.commands.registerCommand('vscode-defold-ide.initialize', async () => {
		const userSettings = await askUserWhichAvailableAnnotationAndLanguageToUse();
		if (!userSettings) {
			vscode.window.showErrorMessage('Please select a Defold version and your preferred language for this project.');
		}

		await initializeCurrentProject(userSettings!, context);
		await saveInitializedState(context, userSettings!);
		vscode.window.showInformationMessage('Happy Defolding!');
	}));
}

async function askUserWhichAvailableAnnotationAndLanguageToUse(): Promise<ISettingsPickedByUser | undefined> {
	const releases = await getAvailableAnnotationReleasesFromGithub();
	const selectedRelease = await askWhichReleaseToUse(releases);
	if (!selectedRelease)
		return undefined;
	const selectedLanguage = await askWhichLanguageToUse(selectedRelease);
	if (!selectedLanguage)
		return undefined;
	return {
		version: selectedRelease.version,
		language: selectedLanguage.language,
		release: selectedRelease,
	}
}

async function downloadAnnotationsZipOrTakeFromCache(context: vscode.ExtensionContext, userSettings: ISettingsPickedByUser): Promise<vscode.Uri> {
	let cachedAnnotationsZip = await getAlreadyDownloadedAnnotationsFromCache(context, userSettings);
	if (!cachedAnnotationsZip) {
		cachedAnnotationsZip = await downloadApiAnnotations(context, userSettings);
	}
	return cachedAnnotationsZip;
}

async function setupCurrentDefoldProjectForLua(context: vscode.ExtensionContext, userSettings: ISettingsPickedByUser) {
	const annotationsZip = await downloadAnnotationsZipOrTakeFromCache(context, {
		...userSettings,
		language: 'lua',
	});
	await unzipArchiveIntoFolder(annotationsZip.fsPath, config.defoldAnnotationsFolder);
	
	const initializer = new LuaProjectInitializer();
	await initializer.run();
}

async function setupCurrentDefoldProjectForTeal(context: vscode.ExtensionContext, userSettings: ISettingsPickedByUser) {
	const annotationsZip = await downloadAnnotationsZipOrTakeFromCache(context, {
		...userSettings,
		language: 'teal',
	});
	await unzipArchiveEntry(
		annotationsZip.fsPath,
		config.defoldTealTypesFolder,
		config.defoldTealTypesFile,
	);
	
	const initializer = new TealProjectInitializer(context);
	await initializer.run();
}

async function saveInitializedState(context: vscode.ExtensionContext, userSettings: ISettingsPickedByUser) {
	await StateMemento.save(context, {
		version: userSettings.version,
		language: userSettings.language,
		assets: [],
		lastMigration: config.lastMigration,
	});
}

async function getAvailableAnnotationReleasesFromGithub(): Promise<IDefoldAnnotationRelease[]> {
	const response = await axios.get('https://api.github.com/repos/mikatuo/defold-lsp-annotations/releases');
	if (response.status < 200 || response.status >= 300 || !response.data) {
		throw new Error(`Failed to fetch Lua annotations for Defold API. Status code: ${response.status}`);
	}

	const releases = parseReleases(response.data);
	return releases.filter(x => !x.draft && x.assets.luaApiAnnotationsUrl)
		.sort((a, b) => b.version.localeCompare(a.version));
}

async function askWhichReleaseToUse(releases: IDefoldAnnotationRelease[]): Promise<IDefoldAnnotationRelease | undefined> {
	const choises = releases.map(x => ({
		label: x.name,
		description: `${x.assets.luaApiAnnotationsUrl ? 'Lua' : ''}${x.assets.luaApiAnnotationsUrl && x.assets.tealApiTypesUrl ? ', ' : ''}${x.assets.tealApiTypesUrl ? 'Teal' : ''}`,
		release: x,
	}));
	const selection = await vscode.window.showQuickPick(choises, {
		placeHolder: 'Select Defold version of the current project',
		ignoreFocusOut: true,
	});
	return selection?.release;
}

async function askWhichLanguageToUse(release: IDefoldAnnotationRelease): Promise<{ language: 'lua' | 'teal', downloadUrl: string } | undefined> {
	const choises = [
		{ label: 'Lua', language: 'lua', downloadUrl: release.assets.luaApiAnnotationsUrl },
		{ label: 'Teal', language: 'teal', downloadUrl: release.assets.tealApiTypesUrl },
	// show only available languages
	].filter(x => x.downloadUrl);
	if (choises.length === 1) {
		return {
			language: choises[0].language as 'lua' | 'teal',
			downloadUrl: choises[0].downloadUrl!,
		};
	}

	const selection = await vscode.window.showQuickPick(choises, {
		placeHolder: 'Select your preferred language',
		ignoreFocusOut: true,
	});
	return selection && {
		language: selection.language as 'lua' | 'teal',
		downloadUrl: selection.downloadUrl!,
	} || undefined;
}

async function getAlreadyDownloadedAnnotationsFromCache(context: vscode.ExtensionContext, userSettings: ISettingsPickedByUser): Promise<vscode.Uri | undefined> {
	const archiveUri = getZipCachePath(context, userSettings);
	try {
		const stats = await vscode.workspace.fs.stat(archiveUri);
		return stats.type === vscode.FileType.File
			? archiveUri
			: undefined;
	} catch {
		return undefined;
	}
}

async function downloadApiAnnotations(context: vscode.ExtensionContext, userSettings: ISettingsPickedByUser): Promise<vscode.Uri> {
	const response = await axios.get(getDownloadUrl(userSettings), { responseType: 'arraybuffer' });
	if (response.status === 200 && response.data) {
		const archiveUri = getZipCachePath(context, userSettings);
		try { await vscode.workspace.fs.delete(archiveUri, { useTrash: false }); } catch {}
		await vscode.workspace.fs.writeFile(archiveUri, response.data);
		return archiveUri;
	} else {
		throw new Error(`Failed to download Lua annotations for Defold. Status code: ${response.status}`);
	}
}

async function unzipArchiveIntoFolder(source: string, destination: string) {
	const archiveManager = new ZipArchiveManager(source);
	await archiveManager.extractAllEntries(
		getWorkspacePath(destination)!,
		{ overwrite: true },
	);
}

async function unzipArchiveEntry(source: string, destination: string, entryName: string) {
	const archiveManager = new ZipArchiveManager(source);
	await archiveManager.extractEntry(
		entryName,
		getWorkspacePath(destination)!,
		{ overwrite: true },
	);
}

async function initializeCurrentProject(userSettings: ISettingsPickedByUser, context: vscode.ExtensionContext) {
	switch (userSettings.language) {
	case 'lua':
		await setupCurrentDefoldProjectForLua(context, userSettings);
		break;
	case 'teal':
		await setupCurrentDefoldProjectForLua(context, userSettings);
		await setupCurrentDefoldProjectForTeal(context, userSettings);
		break;
	default:
		throw new Error(`Support for ${userSettings.language} is not implemented yet`);
	}
}

function parseReleases(data: IGithubRelease[]): IDefoldAnnotationRelease[] {
	return data.map(x => {
		const defoldLuaApiAnnotations = x.assets.find((a: IGithubReleaseAsset) => a.name.startsWith('defold-lua-') && a.name.endsWith('.zip'));
		const defoldTealApiAnnotations = x.assets.find((a: IGithubReleaseAsset) => a.name.startsWith('defold-teal-') && a.name.endsWith('.zip'));
		const helperModule = x.assets.find((a: IGithubReleaseAsset) => a.name.startsWith('defoldy-') && a.name.endsWith('.zip'));
		return {
			version: x.tag_name,
			name: x.name,
			draft: x.draft,
			prerelease: x.prerelease,
			assets: {
				luaApiAnnotationsUrl: defoldLuaApiAnnotations?.browser_download_url,
				tealApiTypesUrl: defoldTealApiAnnotations?.browser_download_url,
				helperModuleUrl: helperModule?.browser_download_url,
			},
		};
	});
}

function getDownloadUrl(userSettings: ISettingsPickedByUser) {
	switch (userSettings.language) {
	case 'lua':
		return userSettings.release.assets.luaApiAnnotationsUrl!;
	case 'teal':
		return userSettings.release.assets.tealApiTypesUrl!;
	default:
		throw new Error(`Support for ${userSettings.language} is not implemented yet`);
	}
}

function getZipCachePath(context: vscode.ExtensionContext, userSettings: ISettingsPickedByUser) {
	switch (userSettings.language) {
	case 'lua':
		return vscode.Uri.joinPath(context.extensionUri, 'cache', 'api', `${userSettings.version}.zip`);
	case 'teal':
		return vscode.Uri.joinPath(context.extensionUri, 'cache', 'api', `${userSettings.version}-teal.zip`);
	default:
		throw new Error(`Support for ${userSettings.language} is not implemented yet`);
	}
}

interface IDefoldAnnotationRelease {
	name: string;
	version: string;
	draft: boolean;
	prerelease: boolean;
	assets: {
		luaApiAnnotationsUrl: string | undefined;
		tealApiTypesUrl: string | undefined;
		helperModuleUrl: string | undefined;
	};
}

interface ISettingsPickedByUser {
	version: string;
	// TODO: allow to choose multiple languages
	language: 'lua' | 'teal';
	release: IDefoldAnnotationRelease;
}