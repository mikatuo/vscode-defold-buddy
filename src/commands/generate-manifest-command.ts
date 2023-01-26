import * as vscode from 'vscode';
import { Command } from './command';
import { saveWorkspaceFile } from '../utils/common';
import { GameProjectConfig } from '../utils/game-project-config';

export class GenerateManifestCommand extends Command {
    async execute() {
		const settings = await promptUserAboutSettings();
		
        const manifestBody = generateManifest(settings);
		const manifestSaved = await saveWorkspaceFile('generated.appmanifest', manifestBody);
		if (!manifestSaved) { vscode.window.showErrorMessage('Failed to save the manifest'); }

		vscode.window.showInformationMessage('The manifest has been generated.');
		const config = await GameProjectConfig.fromFile('game.project');
		config.set({
			section: 'native_extension',
			key: 'app_manifest',
			value: '/generated.appmanifest',
		});
		const configSaved = await config.save();
		if (!configSaved) { vscode.window.showErrorMessage('Failed to update the game project config'); }

		vscode.window.showInformationMessage('The project config has been updated');
    }
}

async function promptUserAboutSettings(): Promise<IManifestSettings> {
	const selectedChoises = await vscode.window.showQuickPick([
		{ label: 'Exclude Physics 2D', description: 'Remove 2D physics (Box2D)', value: 'physics2d' },
		{ label: 'Exclude Physics 3D', description: 'Remove 3D physics (Bullet)', value: 'physics3d' },
		{ label: 'Exclude Record', description: 'Remove the video recording capabilities (Windows, Mac, Linux)', value: 'record' },
		{ label: 'Exclude Profiler', description: 'Remove the on-screen and web profiler', value: 'profiler' },
		{ label: 'Exclude Sound', description: '', value: 'sound' },
		{ label: 'Exclude Input', description: '', value: 'input' },
		{ label: 'Exclude LiveUpdate', description: '', value: 'liveupdate' },
		{ label: 'Exclude Basis Universal transcoder', description: '', value: 'basisTranscoder' },
		{ label: 'Use Android support lib', description: 'Use the old Android support libraries instead of AndroidX', value: 'androidsupport' },
		{ label: 'Use OpenGL', picked: true, description: '', value: 'opengl' },
		{ label: 'Use Vulkan', description: 'BETA (Windows, macOS, Linux, Android, iOS)', value: 'vulkan' },
	], { canPickMany: true, placeHolder: 'Press ENTER once you are ready to proceed' }) || [];

	const selectedSettings = selectedChoises.reduce((settings, choise) => {
		settings[choise.value] = true;
		return settings;
	}, <any>{}) as IManifestSettings;

	const defaultSettings = {
		physics2d: false,
		physics3d: false,
		record: false,
		profiler: false,
		sound: false,
		input: false,
		liveupdate: false,
		basisTranscoder: false,
		androidsupport: false,
		opengl: true,
		vulkan: false,
	};

	const settings = {
		...defaultSettings,
		...selectedSettings
	};
	if (!settings.opengl && !settings.vulkan) {
		// make sure that at least OpenGL is selected
		settings.opengl = true;
	}
	return settings;
}

const libNameLookup: any = {
	['x86-win32']: {
		'vpx': 'vpx',
		'vulkan': 'vulkan-1'
	},
	['x86_64-win32']: {
		'vpx': 'vpx',
		'vulkan': 'vulkan-1'
	},
};

const PLATFORMS = [ 'x86_64-osx', 'x86_64-linux', 'js-web', 'wasm-web', 'x86-win32', 'x86_64-win32', 'armv7-android', 'arm64-android', 'armv7-ios', 'arm64-ios', 'x86_64-ios'];
const PLATFORMS_VULKAN = [ 'x86_64-osx', 'x86_64-linux', 'x86-win32', 'x86_64-win32', 'armv7-android', 'arm64-android', 'arm64-ios'];
const WINDOWS = [ 'x86-win32', 'x86_64-win32' ];
const LINUX = [ 'x86_64-linux' ];
const WEB = [ 'js-web', 'wasm-web' ];
const ANDROID = [ 'armv7-android', 'arm64-android' ];
const MACOS = [ 'x86_64-osx' ];
const IOS = [ 'armv7-ios', 'arm64-ios', 'x86_64-ios' ];

function generateManifest(settings: IManifestSettings): string {
	const exclusions: { settings: any, platforms: any } = {
		settings: [],
		platforms: [],
	};
	PLATFORMS.forEach(function(platform: string) {
		exclusions.platforms[platform] = {
			id: platform,
			excludeLibs: [],
			excludeJsLibs: [],
			excludeJars: [],
			excludeSymbols: [],
			libs: [],
			frameworks: [],
			symbols: [],
			linkFlags: [],
		};
	});

	if (settings.physics2d || settings.physics3d) {
		if (settings.physics2d) {
			exclusions.settings.push('Physics2D');
		}
		if (settings.physics3d) {
			exclusions.settings.push('Physics3D');
		}

		pushExcludedLibs(PLATFORMS, exclusions.platforms, ['physics' ]);
		if (settings.physics2d && settings.physics3d) {
			pushLibs(PLATFORMS, exclusions.platforms, [ 'physics_null' ]);
			pushExcludedLibs(PLATFORMS, exclusions.platforms, [ 'LinearMath', 'BulletDynamics', 'BulletCollision', 'Box2D' ]);
		}
		else if (settings.physics2d) {
			pushLibs(PLATFORMS, exclusions.platforms, [ 'physics_3d' ]);
			pushExcludedLibs(PLATFORMS, exclusions.platforms, [ 'Box2D' ]);
		}
		else if (settings.physics3d) {
			pushLibs(PLATFORMS, exclusions.platforms, [ 'physics_2d' ]);
			pushExcludedLibs(PLATFORMS, exclusions.platforms, [ 'LinearMath', 'BulletDynamics', 'BulletCollision' ]);
		}
	}
	if (settings.record) {
		exclusions.settings.push('Record');
		pushExcludedLibs(PLATFORMS, exclusions.platforms, [ 'record', 'vpx' ]);
		pushLibs(PLATFORMS, exclusions.platforms, [ 'record_null' ]);
	}
	if (settings.profiler) {
		exclusions.settings.push('Profiler');
		pushLibs(PLATFORMS, exclusions.platforms, [ 'profilerext_null' ]);
		pushExcludedLibs(PLATFORMS, exclusions.platforms, [ 'profilerext' ]);
		pushExcludedSymbols(PLATFORMS, exclusions.platforms, [ 'ProfilerExt' ]);
	}
	if (settings.sound) {
		exclusions.settings.push('Sound');
		pushExcludedLibs(PLATFORMS, exclusions.platforms, ['sound', 'tremolo']);
		pushExcludedSymbols(PLATFORMS, exclusions.platforms, ['DefaultSoundDevice', 'AudioDecoderWav', 'AudioDecoderStbVorbis', 'AudioDecoderTremolo']);
		pushLibs(PLATFORMS, exclusions.platforms, ['sound_null']);
	}
	if (settings.input) {
		exclusions.settings.push('Input');
		pushExcludedLibs(PLATFORMS, exclusions.platforms, ['hid']);
		pushLibs(PLATFORMS, exclusions.platforms, ['hid_null']);
	}
	if (settings.liveupdate) {
		exclusions.settings.push('LiveUpdate');
		pushExcludedLibs(PLATFORMS, exclusions.platforms, ['liveupdate']);
		pushLibs(PLATFORMS, exclusions.platforms, ['liveupdate_null']);
	}
	if (settings.basisTranscoder) {
		exclusions.settings.push('Basis Transcoder');
		pushExcludedLibs(PLATFORMS, exclusions.platforms, ['graphics_transcoder_basisu', 'basis_transcoder']);
		pushLibs(PLATFORMS, exclusions.platforms, ['graphics_transcoder_null']);
	}
	if (settings.vulkan) {
		exclusions.settings.push('Vulkan');
		pushLibs([ 'x86_64-osx', 'arm64-ios' ], exclusions.platforms, ['graphics_vulkan', 'MoltenVK']);
		pushLibs(ANDROID, exclusions.platforms, ['graphics_vulkan']);
		pushLibs(WINDOWS, exclusions.platforms, ['graphics_vulkan', 'vulkan']);
		pushLibs(LINUX, exclusions.platforms, ['graphics_vulkan', 'X11-xcb']);
		pushFrameworks([ 'x86_64-osx' ], exclusions.platforms, ['Metal', 'IOSurface', 'QuartzCore']);
		pushFrameworks([ 'arm64-ios' ], exclusions.platforms, ['Metal', 'QuartzCore']);
		pushSymbols(PLATFORMS_VULKAN, exclusions.platforms, ['GraphicsAdapterVulkan']);
	}
	if (!settings.opengl) {
		pushExcludedLibs(PLATFORMS_VULKAN, exclusions.platforms, ['graphics']);
		pushExcludedSymbols(PLATFORMS_VULKAN, exclusions.platforms, ['GraphicsAdapterOpenGL']);
	}
	else {
		exclusions.settings.push('OpenGL');
	}

	const tab = '    '; // 4 spaces
	const newLine = '\n';
	let manifest = `# App manifest generated ${new Date()}${newLine}`;
	manifest += `# Settings: ${exclusions.settings.join()}${newLine}`;
	manifest += `platforms:${newLine}`;
	PLATFORMS.forEach(function(platform) {
		manifest += `${tab}${platform}:${newLine}`;
		manifest += `${tab}${tab}context:${newLine}`;
		manifest += `${tab}${tab}${tab}excludeLibs: [${exclusions.platforms[platform].excludeLibs.join()}]${newLine}`;
		if (isWeb(platform)) {
			manifest += `${tab}${tab}${tab}excludeJsLibs: [${exclusions.platforms[platform].excludeJsLibs.join()}]${newLine}`;
		}
		if (isAndroid(platform)) {
			manifest += `${tab}${tab}${tab}excludeJars: [${exclusions.platforms[platform].excludeJars.join()}]${newLine}`;
		}
		manifest += `${tab}${tab}${tab}excludeSymbols: [${exclusions.platforms[platform].excludeSymbols.join()}]${newLine}`;
		manifest += `${tab}${tab}${tab}symbols: [${exclusions.platforms[platform].symbols.join()}]${newLine}`;
		manifest += `${tab}${tab}${tab}libs: [${exclusions.platforms[platform].libs.join()}]${newLine}`;
		if (isIos(platform) || isMacos(platform)) {
			manifest += `${tab}${tab}${tab}frameworks: [${exclusions.platforms[platform].frameworks.join()}]${newLine}`;
		}
		manifest += `${tab}${tab}${tab}linkFlags: [${exclusions.platforms[platform].linkFlags.join()}]${newLine}`;
		if (isAndroid(platform)) {
			manifest += `${tab}${tab}${tab}jetifier: ${settings.androidsupport ? 'false' : 'true'}${newLine}`;
		}
		manifest += `${newLine}`;
	});

	return manifest;
}

interface IManifestSettings {
	physics2d: boolean;
	physics3d: boolean;
	record: boolean;
	profiler: boolean;
	sound: boolean;
	input: boolean;
	liveupdate: boolean;
	basisTranscoder: boolean;
	androidsupport: boolean;
	opengl: boolean;
	vulkan: boolean;
}

///////////////

function findIn(list: string[], what: string) {
	for (let i=0; i < list.length; i++) {
		if (list[i] === what) {
			return true;
		}
	}
	return false;
}

function isWindows(platform: string) {
	return findIn(WINDOWS, platform);
}

function isWeb(platform: string) {
	return findIn(WEB, platform);
}

function isAndroid(platform: string) {
	return findIn(ANDROID, platform);
}

function isMacos(platform: string) {
	return findIn(MACOS, platform);
}

function isIos(platform: string) {
	return findIn(IOS, platform);
}

function platformifyExcludedLib(platform: string, name: string) {
	if (libNameLookup[platform] && libNameLookup[platform][name]) {
		return '"' + libNameLookup[platform][name] + '"';
	}
	return isWindows(platform) ? ('"' + "lib" + name + '"') : (`"${name}"`);
}

function platformifyLib(platform: string, name: string) {
	if (libNameLookup[platform] && libNameLookup[platform][name]) {
		return '"' + libNameLookup[platform][name] + '.lib"';
	}
	return isWindows(platform) ? ('"' + "lib" + name + '.lib"') : (`"${name}"`);
}

function pushExcludedLibs(platforms: string[], exclusions: any, names: string[]) {
	names.forEach(function(name) {
		platforms.forEach(function(platform) {
			exclusions[platform].excludeLibs.push(platformifyExcludedLib(platform, name));
		});
	});
}
function pushExcludedJars(platforms: string[], exclusions: any, names: string[]) {
	names.forEach(function(name) {
		platforms.forEach(function(platform) {
			exclusions[platform].excludeJars.push(`"${name}"`);
		});
	});
}
function pushExcludedSymbols(platforms: string[], exclusions: any, names: string[]) {
	names.forEach(function(name) {
		platforms.forEach(function(platform) {
			exclusions[platform].excludeSymbols.push(`"${name}"`);
		});
	});
}
function pushLibs(platforms: string[], exclusions: any, names: string[]) {
	names.forEach(function(name) {
		platforms.forEach(function(platform) {
			exclusions[platform].libs.push(platformifyLib(platform, name));
		});
	});
}
function pushSymbols(platforms: string[], exclusions: any, names: string[]) {
	names.forEach(function(name) {
		platforms.forEach(function(platform) {
			exclusions[platform].symbols.push(`"${name}"`);
		});
	});
}
function pushFrameworks(platforms: string[], exclusions: any, names: string[]) {
	names.forEach(function(name) {
		platforms.forEach(function(platform) {
			exclusions[platform].frameworks.push(`"${name}"`);
		});
	});
}
