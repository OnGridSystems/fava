<script lang="ts">
  import { getContext } from "svelte";
  import type { Writable } from "svelte/store";

  import { _ } from "../i18n";
  import { chartCurrency, hierarchyChartMode } from "../stores/chart";

  import type { HierarchyChart } from "./hierarchy";
  import Sunburst from "./Sunburst.svelte";
  import Treemap from "./Treemap.svelte";

  const context: Writable<string[]> = getContext("chart-currencies");

  export let data: HierarchyChart["data"];
  export let width: number;

  $: currencies = [...data.keys()];
  $: currency = $chartCurrency || currencies[0];
  $: context.set(currencies);

  $: treemapData = $hierarchyChartMode === "treemap" && data.get(currency);
</script>

{#if currencies.length === 0}
  <svg {width}>
    <text x={width / 2} y={80} text-anchor="middle">{_("Chart is empty.")}</text
    >
  </svg>
{:else if treemapData}
  <Treemap data={treemapData} {currency} {width} />
{:else if $hierarchyChartMode === "sunburst"}
  <svg {width} height={500}>
    {#each [...data] as [currency, d], i (currency)}
      <g transform={`translate(${(width * i) / currencies.length},0)`}>
        <Sunburst
          data={d}
          {currency}
          width={width / currencies.length}
          height={500}
        />
      </g>
    {/each}
  </svg>
{/if}
