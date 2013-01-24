[{$smarty.block.parent}]
[{if isset($piPaymillError) }]
<div class="status error">
    [{$piPaymillError}]
</div>
[{/if}]