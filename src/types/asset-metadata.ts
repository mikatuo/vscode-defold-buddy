export interface IAssetMetadata {
	author: string;
	description: string;
	id: string;
	images: {
		hero: string;
		thumb: string;
	};
	library_url: string;
	license: string;
	name: string;
	platforms: string[];
	project_url: string;
	stars: number;
	tags: string[];
	timestamp: number;
	website_url: string;
}