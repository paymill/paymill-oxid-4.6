[{assign var="oxConfig" value=$oView->getConfig()}]
[{if $sPaymentID == 'paymill_cc'}]
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
            <input id="payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]>
        </td>
        <td colspan="2" id="test_PaymentDesc_[{$smarty.foreach.PaymentSelect.iteration}]">
            <label for="payment_[{$sPaymentID}]">
                <b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b>
            </label>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <p class="payment-errors cc" style="display:none;"></p>
        </td>
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
        </td>
        <td>
            <label class="card-number-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_NUMBER" }]:</label>
        </td>
        <td>
            <input id="paymillCardNumber" class="card-number span1 [{if $brand}]paymill-card-number-[{$brand}][{/if}]" type="text" size="20" value="[{$paymillCcLastFour}]"/>
        </td>
    </tr>
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
        </td>
        <td>
            <label class="card-cvc-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_SECURITYCODE" }]<span class="tooltip" title='[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_CC_TOOLTIP" }]'>?</span>:</label>
        </td>
        <td>
            <input id="paymillCardCvc" class="card-cvc span1" type="text" size="20" value="[{$paymillCcCvc}]"/>
        </td>
    </tr>
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
        </td>
        <td>
            <label class="card-holdername-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_HOLDERNAME" }]:</label>
        </td>
        <td>
            <input id="paymillCardHolderName" class="card-holdername span1" type="text" size="20" value="[{$paymillCcCardHolder}]" />
        </td>
    </tr>
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
        </td>
        <td>
            <label class="card-expiry-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_VALIDUNTIL" }]:</label>
        </td>
        <td>
            <select id="paymillCardExpiryMonth" class="card-expiry-month">
                <option value="1">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_JAN" }]</option>
                <option value="2">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_FEB" }]</option>
                <option value="3">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_MAR" }]</option>
                <option value="4">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_APR" }]</option>
                <option value="5">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_MAY" }]</option>
                <option value="6">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_JUN" }]</option>
                <option value="7">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_JUL" }]</option>
                <option value="8">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_AUG" }]</option>
                <option value="9">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_SEP" }]</option>
                <option value="10">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_OCT" }]</option>
                <option value="11">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_NOV" }]</option>
                <option value="12">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_MONTH_DEC" }]</option>
            </select>
            <span> / </span>
            <select id="paymillCardExpiryYear" class="card-expiry-year">
                [{foreach from=$oView->getCreditYears() item=year}]
                [{if $year eq $paymillCcExpireYear}]
                <option selected="selected">[{$year}]</option>
                [{else}]
                <option>[{$year}]</option>
                [{/if}]
                [{/foreach}]
            </select>
        </td>
    </tr>
    [{if $oxConfig->getShopConfVar('PAYMILL_SHOW_LABEL')}]
    <tr>
        <td colspan="3">
            <div class="paymill_powered">
                <div class="paymill_credits">
                    [{ oxmultilang ident="PAYMILL_CC_POWERED_TEXT" }]
                    <a href="http://www.paymill.de" target="_blank">PAYMILL</a>
                </div>
            </div>
        </td>
    </tr>
    [{/if}]
[{elseif $sPaymentID == 'paymill_elv'}]
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
            <input id="payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]>
        </td>
        <td colspan="2" id="test_PaymentDesc_[{$smarty.foreach.PaymentSelect.iteration}]" >
            <label for="payment_[{$sPaymentID}]"><b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b></label>
        </td>
    </tr>
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td colspan="3">
            <p class="payment-errors elv" style="display:none;"></p>
        </td>
    </tr>
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
        </td>
        <td>
            <label class="elv-holdername-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNTHOLDER" }]:</label>
        </td>
        <td>
            <input id="paymillElvHolderName" class="elv-holdername span1" type="text" size="20" value="[{$paymillElvHolder}]"/>
        </td>
    </tr>
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
        </td>
        <td>
            <label class="elv-account-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNT" }]:</label>
        </td>
        <td>
            <input id="paymillElvAccount" class="elv-account span1" type="text" size="20" value="[{$paymillElvAccount}]"/>
        </td>
    </tr>
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
        <td>
        </td>
        <td>
            <label class="elv-bankcode-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_BANKCODE" }]:</label>
        </td>
        <td>
            <input id="paymillElvBankCode" class="elv-bankcode span1" type="text" size="20" value="[{$paymillElvCode}]"/>
        </td>
    </tr>
    [{if $oxConfig->getShopConfVar('PAYMILL_SHOW_LABEL')}]
    <tr>
        <td colspan="3">
            <div class="paymill_powered">
                <div class="paymill_credits">
                    [{ oxmultilang ident="PAYMILL_ELV_POWERED_TEXT" }]
                    <a href="http://www.paymill.de" target="_blank">PAYMILL</a>
                </div>
            </div>
        </td>
    </tr>
    [{/if}]
[{/if}]