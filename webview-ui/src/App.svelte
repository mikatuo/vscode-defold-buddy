<script lang="ts">
	import {
		provideVSCodeDesignSystem,
		vsCodeButton,
		vsCodeProgressRing,
		vsCodeTag,
    vsCodeTextField,
	} from "@vscode/webview-ui-toolkit";
	import { vscode } from "./utilities/vscode";
	import { onMount } from "svelte";
	import StateManager from "./utilities/stateManager";
	import type { IAssetMetadata, IFilterableAsset } from "./types/assetMetadata";
	import type { ITagFilter } from "./types/tagFilter";
	import { DefoldAssetsLoader } from "./utilities/defoldAssetsLoader";

	import "./css/global.css";

	let loading = true;
	let loadingProgress = 0;
	let assets: IFilterableAsset[];
	let tags: ITagFilter[];
  let value: string = '';

	provideVSCodeDesignSystem().register(
		vsCodeButton(),
		vsCodeProgressRing(),
		vsCodeTag(),
    vsCodeTextField(),
	);

	function addDependencyToProject(asset: IAssetMetadata) {
		vscode.postMessage({
			command: "add_dependency",
			text: JSON.stringify(asset),
		});
	}

	function copyFilesIntoProject(asset: IAssetMetadata) {
		vscode.postMessage({
			command: "copy_dependency",
			text: JSON.stringify(asset),
		});
	}

	function filterAssetsByTag(tag: ITagFilter) {
    // update selected tag
		tags = tags.map((t) => {
			t.selected = t.id === tag.id;
			return t;
		});
    // hide assets that don't match the tag
    assets = assets.map((asset) => {
      if (tag.id === 'all')
        asset.hidden = false;
      else
        asset.hidden = asset.tags.every(t => t.toLowerCase() !== tag.id);
      return asset;
    });
	}

  function filterAssetsByText(event) {
    const value = event.target.value.toLowerCase();
    assets = assets.map((asset) => {
      if (value === '')
        asset.hidden = false;
      else
        asset.hidden = asset.name.toLowerCase().indexOf(value) === -1 &&
          asset.description.toLowerCase().indexOf(value) === -1;
      return asset;
    });
  }

	async function loadAssets(): Promise<IAssetMetadata[]> {
		loading = true;
		try {
			const state = StateManager.load();
			if (state.assets.length > 0) {
				console.log("FROM CACHE", state.assets);
				return state.assets;
			}
			const loader = new DefoldAssetsLoader();
			const sub = loader.$loadProgress.subscribe((progress) => {
				loadingProgress = Math.round(progress * 100);
			});
			const assets = await loader.load();
			sub.unsubscribe();
			state.assets = assets;
			StateManager.save(state);
			return assets;
		} finally {
			loading = false;
		}
	}

	onMount(async () => {
		assets = await loadAssets();
		assets = assets.filter(skipNonAssets)
					.sort(sortByStarsDescending);
		tags = buildTagFilters(assets);
		console.log(tags);
	});

	function skipNonAssets(asset: IFilterableAsset): boolean {
		if (asset.library_url)
			return true;
		// skip non assets
		if (asset.tags.some((t) => t.toLowerCase() === 'tools' || t.toLowerCase() === 'editor' || t.toLowerCase() === 'tutorials'))
			return false;
		// skip if no github repo
		if (!asset.project_url.match(/github.com\/(?<author>[^\/]+)\/(?<repo>[^\/]+)/))
			return false;
		return true;
	}

	function sortByStarsDescending(a: IAssetMetadata, b: IAssetMetadata): number {
		if (a.stars > b.stars) return -1;
		if (a.stars < b.stars) return 1;
		return 0;
	}

	function buildTagFilters(assets: IAssetMetadata[]): ITagFilter[] {
    // build an index of unique tags with count
		const indexOfUniqueTagsWithCount = assets.reduce((res, asset) => {
			asset.tags.forEach((tag) => {
				const tagId = tag.toLocaleLowerCase();
				if (!res[tagId]) {
					res[tagId] = {
						id: tagId,
						name: tag,
						count: 1,
					};
				} else {
					res[tagId].count++;
				}
			});
			return res;
		}, new Map<string, ITagFilter>());
    // sort by name
		let tags = Object.values(indexOfUniqueTagsWithCount)
			.map(normalizeTagNames)
			.sort(sortByName);
    // add ALL tag
		tags.unshift({
			id: 'all',
			name: 'ALL',
			count: assets.length,
			selected: true,
		});
		return tags;
	}
	


function sortByName(a: any,b: any): number {
  return (a.name>b.name? 1:-1);
}

function normalizeTagNames(tag: ITagFilter): ITagFilter {
    if (tag.id === 'gui') tag.name = 'GUI';
    // capitalize first letter
    else tag.name = tag.name[0].toUpperCase() + tag.name.slice(1);
    return tag;
}
</script>

<main>
  {#if loading}
    <div class="loader">
      <vscode-progress-ring />
      <span>{loadingProgress} %</span>
    </div>
  {/if}

  <!-- Header -->
  <div class="header">
    <img src="https://defold.com/images/icons/community-assets-on-dark.svg" alt="" style="width: 150px !important"/>
    <div class="second">
      <h1>Asset Portal</h1>
      <p>
        Whether you're looking for extensions, pathfinders, sprite sets, example
        projects or code snippets—you name it, we've got it!
      </p>
    </div>
    <div class="last">
      <vscode-button>
        <a class="button secondary" target="_blank" href="https://defold.com/submit_asset">Submit asset</a>
      </vscode-button>
    </div>
  </div>

  <!-- Filters -->
  <div class="filters">
    {#if tags}
      <p style="margin-bottom: 0">TAGS</p>
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); grid-gap: 0 1rem; font-size: 0.9em;">
        {#each tags as tag}
          <!-- svelte-ignore a11y-invalid-attribute -->
          <a href="#" class:active={tag.selected} on:click={(event) => { event.preventDefault(); filterAssetsByTag(tag); }}>
            {tag.name} ({tag.count})
          </a>
        {/each}
      </div>
    {/if}

    <vscode-text-field placeholder="Type to filter..." on:input={(event) => filterAssetsByText(event)}>
      Search
    </vscode-text-field>
  </div>

  <!-- Assets -->
  {#if assets}
    <div class="assets-container">
      {#each assets.filter(x => !x.hidden) as asset}
        <div class="asset">
          <!-- Author -->
          <div class="author">
            <span>{asset.author}</span>
          </div>
          <!-- Image -->
          {#if !asset.images?.thumb}
            <div class="image" style="background: url('https://defold.com/images/asset-nothumb.jpg') center/cover"/>
          {:else if asset.images.thumb.startsWith("http")}
            <div class="image" style="background: url('{asset.images.thumb}') center/cover"/>
          {:else}
            <div class="image" style="background: url('https://raw.githubusercontent.com/defold/asset-portal/master/assets/images/{asset.images.thumb}') center/cover"/>
          {/if}
          <!-- Title -->
          <div class="title">
            <div>
              <b>
                <a href={asset.project_url} target="_blank" style="color: inherit">
                  {asset.name}
                </a>
              </b>
              <p class="tags">
                {asset.tags.join(", ")}
              </p>
            </div>
            {#if asset.stars}
              <div class="stars-container">
                <p class="right">
                  <span class="octicon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="16" viewBox="0 0 14 16">
            <path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74L14 6z"/>
          </svg>
                  </span>
                  {asset.stars}
                </p>
              </div>
            {/if}
          </div>
          <!-- Description -->
          <div class="description">
            {asset.description}
          </div>
          <!-- Controls -->
          <div class="controls">
            <div class="buttons">
              <vscode-button on:click={() => addDependencyToProject(asset)}>Add to project</vscode-button>
              <!-- <vscode-button on:click={() => copyFilesIntoProject(asset)}>Copy files</vscode-button> -->
            </div>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</main>

<style>
  main {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    height: 100%;

    max-width: 1200px;
    margin: 0 auto;
  }

  /**********
	*  header *
	**********/
  .header {
    display: flex;
    flex-direction: row;
    align-items: center;
    margin: 1em 0;
    width: 100%;
  }

  .header > .second {
    margin: 0 3em;
  }

  .header > .last {
    display: flex;
    align-self: flex-start;
    margin-top: 20px;
    width: 150px;
    height: 39px;
  }

  .header > .last vscode-button {
    width: 100%;
    height: 100%;
  }

  vscode-button a {
    color: inherit;
    text-decoration: none;
  }

  /***********
	*  filters *
	***********/

  .filters {
    width: 100%;
    margin-top: 1em;
    margin-bottom: 2em;
  }

  .filters a {
    color: inherit;
    font-size: 0.9em;
  }

  .filters a.active {
    font-weight: bold;
    color: white;
  }

  .filters vscode-text-field {
    margin-top: 1em;
  }

  /**********
	*  assets *
	**********/

  p {
    margin-top: 0;
  }

  .right {
    text-align: right;
  }

  /* take full screen with content centered with flex */
  .loader {
    width: 100%;
    height: 100%;
    position: fixed;
    top: 0;
    left: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    background-color: var(--vscode-editor-background);
    z-index: 1000;
  }

  .loader vscode-progress-ring {
    width: 10%;
    height: 10%;
    margin: 10px;
  }

  .assets-container {
    display: grid;
    grid-template-columns: repeat(4, minmax(250px, 350px));
    grid-gap: 1.3em;
    padding: 0px;
  }
  @media (max-width: 1100px) {
    .assets-container {
      grid-template-columns: repeat(3, minmax(250px, 350px));
    }
  }
  @media (max-width: 800px) {
    .assets-container {
      grid-template-columns: repeat(2, minmax(200px, 400px));
    }
  }

  .asset {
    display: flex;
    flex-direction: column;
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
    margin-bottom: 0;
    border-radius: 4px;
    background-color: var(--grey);
  }

  .asset .author {
    position: relative;
    padding: 0em;
    color: #eee;
    cursor: default;
  }

  .asset .author > * {
    position: absolute;
    top: 5px;
    right: 8px;
    text-shadow: 1px 1px 1px black, -1px 1px 1px black, 1px -1px 1px black,
      -1px -1px 1px black;
  }

  .asset .image {
    padding: 0;
    margin: 0;
    height: 190px;
    border-radius: 4px 4px 0 0;
  }

  .asset .title {
    display: grid;
    grid-template-columns: 70% auto;
    grid-gap: 0;
  }

  .asset .stars-container .octicon {
    fill: #daaa3f;
    vertical-align: middle;
    margin-right: 2px;
  }

  .asset .tags {
    font-size: smaller;
    margin-bottom: 0px;
  }

  .asset .description {
    font-size: smaller;
    margin-bottom: 0;
  }

  .asset .controls {
    padding-top: 0.5em;
    padding-left: 0;
    width: 100%;
    display: flex;
    flex-grow: 1;
    align-items: end;
  }

  .asset .controls .buttons {
    width: 100%;
    display: flex;
    justify-content: space-between;
  }

  .asset .controls vscode-button {
    width: 100%;
    min-height: 30px;
  }

  .asset .title,
  .asset .description {
    padding-left: 1em;
    padding-right: 1em;
    padding-top: 1em;
    padding-bottom: 0;
  }
</style>
