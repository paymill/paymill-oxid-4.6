[{assign var="oxConfig" value=$oView->getConfig()}]
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td>
        <input id="test_Payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]>
    </td>
    <td id="test_PaymentDesc_[{$smarty.foreach.PaymentSelect.iteration}]" colspan="2">
        <label><b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b></label>
    </td>
</tr>
[{if $sPaymentID == 'paymill_cc' && $paymillShowForm_cc}]
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td colspan="3">
        <p class="payment-errors cc" style="display:none;"></p>
    </td>
</tr>
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td></td>
    <td colspan="2">
        <span class="span3 card-icon"></span>
    </td>
</tr>
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td></td>
    <td>
        <label class="card-number-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_NUMBER" }]:</label>
    </td>
    <td>
        <input class="card-number span2" type="text" size="20" />
    </td>
</tr>
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td></td>
    <td>
        <label class="card-cvc-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_SECURITYCODE" }]:</label>
    </td>
    <td>
        <input class="card-cvc span1" type="text" size="4" />
    </td>
</tr>
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td></td>
    <td>
        <label class="card-holdername-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_HOLDERNAME" }]:</label>
    </td>
    <td>
        <input class="card-holdername span3" type="text" size="20" value="[{$oxcmp_user->oxuser__oxfname->value}] [{$oxcmp_user->oxuser__oxlname->value}]" />
    </td>
</tr>
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td></td>
    <td>
        <label class="card-expiry-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_VALIDUNTIL" }]:</label>
    </td>
    <td>
        <select class="card-expiry-month span1" />
<option>01</option>
<option>02</option>
<option>03</option>
<option>04</option>
<option>05</option>
<option>06</option>
<option>07</option>
<option>08</option>
<option>09</option>
<option>10</option>
<option>11</option>
<option>12</option>
</select>

<span> / </span>

<select class="card-expiry-year span1" />
[{foreach from=$oView->getCreditYears() item=year}]
<option>[{$year}]</option>
[{/foreach}]
</select>
</td>
</tr>
[{elseif $sPaymentID == 'paymill_elv' && $paymillShowForm_elv}]
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td colspan="3">
        <p class="payment-errors elv" style="display:none;"></p>
    </td>
</tr>
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td></td>
    <td>
        <label class="elv-holdername-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNTHOLDER" }]:</label>
    </td>
    <td>
        <input class="elv-holdername span3" type="text" size="20" value="[{$oxcmp_user->oxuser__oxfname->value}] [{$oxcmp_user->oxuser__oxlname->value}]" />
    </td>
</tr>
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td></td>
    <td>
        <label class="elv-account-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNT" }]:</label>
    </td>
    <td>
        <input class="elv-account span3" type="text" size="20" />
    </td>
</tr>
<tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
    <td></td>
    <td>
        <label class="elv-bankcode-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_BANKCODE" }]:</label>
    </td>
    <td>
        <input class="elv-bankcode span3" type="text" size="20" />
    </td>
</tr>
[{/if}]
[{if $oxConfig->getShopConfVar('PAYMILL_SHOW_LABEL') }]
<tr>
    <td colspan="3" class="paymill-label">
        [{if $sPaymentID == 'paymill_cc'}]
        [{ oxmultilang ident="PAYMILL_CC_POWERED_TEXT" }]
        [{elseif $sPaymentID == 'paymill_elv'}]
        [{ oxmultilang ident="PAYMILL_ELV_POWERED_TEXT" }]
        [{/if}]
    </td>
</tr>
<tr>
    <td colspan="3" class="paymill-label">
        <img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/logo.png">
    </td>
</tr>
[{/if}]