[{if $sPaymentID == 'paymill_credit_card'}]
  [{include file="page/checkout/inc/paymill_credit_card.tpl"}]
[{else}]
  [{$smarty.block.parent}]
[{/if}]