[{assign var="oxConfig" value=$oView->getConfig()}]
<dl>
    <dt>
        <input id="payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]>
        <label for="payment_[{$sPaymentID}]">
            <b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b>
        </label>
    </dt>
    <dd class="[{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]activePayment[{/if}]">
        <ul class="form">
            <li class="controls controls-row">
                <p class="payment-errors cc" style="display:none;"></p>
                <div id="payment-form-cc">
                    <div class="controls controls-row">
                        <label class="card-number-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_NUMBER" }]:</label>
                        <input id="paymillCardNumber" class="card-number span1" type="text" size="20" value="[{$paymillCcLastFour}]"/>
                    </div>
                    <div class="controls controls-row">
                        <label class="card-cvc-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_SECURITYCODE" }]<span class="tooltip" title='[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_CC_TOOLTIP" }]'>?</span>:</label>
                        <input id="paymillCardCvc" class="card-cvc span1" type="text" size="4" value="[{$paymillCcCvc}]"/>
                    </div>
                    <div class="controls controls-row">
                        <label class="card-holdername-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_HOLDERNAME" }]:</label>
                        <input id="paymillCardHolderName" class="card-holdername span1" type="text" size="20" value="[{$paymillCcCardHolder}]" />
                    </div>
                    <div class="controls controls-row">
                        <label class="card-expiry-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_VALIDUNTIL" }]:</label>
                        <select id="paymillCardExpiryMonth" class="card-expiry-month span1">
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
                        <select id="paymillCardExpiryYear" class="card-expiry-year span1">
                            [{foreach from=$oView->getCreditYears() item=year}]
                            [{if $year eq $paymillCcExpireYear}]
                            <option selected="selected">[{$year}]</option>
                            [{else}]
                            <option>[{$year}]</option>
                            [{/if}]
                            [{/foreach}]
                        </select>
                    </div>
                </div>
            </li>
            [{if $oxConfig->getShopConfVar('PAYMILL_SHOW_LABEL')}]
            <li>
                <div class="paymill_powered">
                    <div class="paymill_credits">
                        [{ oxmultilang ident="PAYMILL_CC_POWERED_TEXT" }]
                        <a href="http://www.paymill.de" target="_blank">PAYMILL</a>
                    </div>
                </div>
            </li>
            [{/if}]
        </ul>
    </dd>
</dl>