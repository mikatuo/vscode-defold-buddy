import axios from "axios";

// eslint-disable-next-line @typescript-eslint/naming-convention
const Client = require('node-ssdp').Client;

export async function findRunningDefoldEngineService(): Promise<{ip: string, logPort: string} | undefined> {
	const location = await findGameServiceLocationUrl();
	if (!location) { return undefined; }

	console.log('location', location);
	const response = await axios.get(location);
	if (response.status < 200 || response.status >= 300) {
		console.warn(`Failed to get ${location}`);
	}

	const ip = location.split(':')[1].substring(2);

	return {
		ip,
		logPort: response.data.match(/<defold:logPort>(\d+)<\/defold:logPort>/)[1],
	};
}

function findGameServiceLocationUrl(): Promise<string | undefined> {
	let done = false;
	return new Promise((resolve, reject) => {
		const client = new Client();
		let started: Date;

		client.on('response', function (headers: any, statusCode: any, rinfo: any) {
			if (headers.SERVER.indexOf('Defold') !== -1) {
				const diffInMs = new Date().getTime() - started.getTime();
				if (!done) {
					done = true;
					resolve(headers.LOCATION);
				}
			}
		});

		const searchInterval = 1000;
		let i = 0;
		if (!done) {
			client.search('upnp:rootdevice');
			const interval = setInterval(() => {
				if (done) {
					clearInterval(interval);
					return;
				} else if (i > 30) {
					clearInterval(interval);
					console.error(`Failed to find running Defold Engine in ${i * searchInterval}ms`);
					return resolve(undefined);
				}
				started = new Date();
				client.search('upnp:rootdevice');
			}, searchInterval);
		}
	});
}

