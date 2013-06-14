[{if $piPaymillError}]
    <br><div style="text-align:center;">
        <span  style="border:1px solid red;padding:3px;">
            Paymill: [{ $piPaymillError }]
        </span>
    </div>
[{/if}]
[{$smarty.block.parent}]