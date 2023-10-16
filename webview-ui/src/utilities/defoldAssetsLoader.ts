import axios from 'axios';
import type { IAssetMetadata } from '../types/assetMetadata';
import { Subject } from 'rxjs';

declare global { var baseUrl: string; }

export class DefoldAssetsLoader {
	$loadProgress = new Subject<number>();

	async load(): Promise<IAssetMetadata[]> {
		const response = await axios.get<IGithubRepoContentItem[]>('https://api.github.com/repos/defold/asset-portal/contents/assets');
		const assetsDownloadList = response.data.filter(item => item.download_url !== null);

		const downloadedAssets: IAssetMetadata[] = [];
		for await (const item of assetsDownloadList) {
            try {
                const baseUrl = window.baseUrl ? `${window.baseUrl}/` : '';
                const localAssetResponse = await axios.get<IAssetMetadata>(`${baseUrl}assets/${item.name}`);
                if (localAssetResponse.status >= 200 && localAssetResponse.status < 300) {
                    console.log(`Loaded asset from local storage: ${item.name}`);
                    downloadedAssets.push(localAssetResponse.data);
                } else {
                    console.log(`Loaded asset from Github: ${item.name}`);
                    const githubAssetResponse = await axios.get<IAssetMetadata>(item.download_url);
                    downloadedAssets.push(githubAssetResponse.data);
                }
                this.$loadProgress.next(downloadedAssets.length / (assetsDownloadList.length));
            } catch (error) {
                console.log(`Failed to load asset: ${item.name}`);
                console.log(error);
            }
		}
		return downloadedAssets;
	}
}

export interface IGithubRepoContentItem {
    name: string;
    path: string;
    sha: string;
    size: number;
    url: string;
    html_url: string;
    git_url: string;
    download_url: string | null;
    type: string;
    _links: {
        self: string;
        git: string;
        html: string;
    };
}