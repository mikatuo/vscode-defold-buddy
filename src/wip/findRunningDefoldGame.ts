export function findRunningDefoldEngineService(): Promise<{location: string}> {
	const done = false;
	return new Promise((resolve, reject) => {
		const Client = require('node-ssdp').Client;
		const client = new Client();

		client.on('response', function (headers: any, statusCode: any, rinfo: any) {
			if (headers.SERVER.indexOf('Defold') !== -1) {
				if (!done) {
					resolve({
						location: headers.LOCATION,
						// TODO: axios get headers.LOCATION and parse log port from the response
					});
				}
				console.log('Found running Defold Engine!', headers.LOCATION);
			}
		});
		console.log('SEARCHING...');
		client.search('upnp:rootdevice');
	});
}
