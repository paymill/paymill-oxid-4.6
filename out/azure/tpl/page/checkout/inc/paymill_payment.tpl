[{assign var="oxConfig" value=$oView->getConfig()}]
<dl>
    <dt>
    <input id="payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]>
    <label for="payment_[{$sPaymentID}]"><b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b></label>
    </dt>
    [{if ($sPaymentID == 'paymill_cc' && $paymillShowForm_cc) || ($sPaymentID == 'paymill_elv' && $paymillShowForm_elv)}]
    <dd class="[{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]activePayment[{/if}]">
        <ul class="form">
            <li class="controls controls-row">
                [{if $sPaymentID == 'paymill_cc' && $paymillShowForm_cc}]
                <p class="payment-errors cc" style="display:none;"></p>
                <div id="payment-form-cc">
                    <div class="controls controls-row">
                        <span class="span3 card-icon"></span>
                    </div>
                    <div class="controls controls-row">
                        <label class="card-number-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_NUMBER" }]:</label>
                        <input class="card-number span2" type="text" size="20" />
                        <label class="card-cvc-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_SECURITYCODE" }]:</label>
                        <input class="card-cvc span1" type="text" size="4" />
                    </div>
                    <div class="controls controls-row">
                        <label class="card-holdername-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_HOLDERNAME" }]:</label>
                        <input class="card-holdername span3" type="text" size="20" value="[{$oxcmp_user->oxuser__oxfname->value}] [{$oxcmp_user->oxuser__oxlname->value}]" />
                    </div>
                    <div class="controls controls-row">
                        <label class="card-expiry-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_VALIDUNTIL" }]:</label>
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
                    </div>
                </div>
                [{elseif $sPaymentID == 'paymill_elv' && $paymillShowForm_elv}]
                <p class="payment-errors elv" style="display:none;"></p>
                <div id="payment-form-elv">
                    <div class="controls controls-row">
                        <label class="elv-holdername-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNTHOLDER" }]:</label>
                        <input class="elv-holdername span3" type="text" size="20" value="[{$oxcmp_user->oxuser__oxfname->value}] [{$oxcmp_user->oxuser__oxlname->value}]" />
                    </div>
                    <div class="controls controls-row">
                        <label class="elv-account-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNT" }]:</label>
                        <input class="elv-account span3" type="text" size="20" />
                    </div>
                    <div class="controls controls-row">
                        <label class="elv-bankcode-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_BANKCODE" }]:</label>
                        <input class="elv-bankcode span3" type="text" size="20" />
                    </div>
                </div>
                [{/if}]
            </li>
            [{if $oxConfig->getShopConfVar('PAYMILL_SHOW_LABEL') }]
            <li>
                <div class="paymill_powered">
                    <div class="paymill_credits">
                        [{if $sPaymentID == 'paymill_cc'}]
                        [{ oxmultilang ident="PAYMILL_CC_POWERED_TEXT" }]
                        [{elseif $sPaymentID == 'paymill_elv'}]
                        [{ oxmultilang ident="PAYMILL_ELV_POWERED_TEXT" }]
                        [{/if}]
                        <a href="http://www.paymill.de" target="_blank">Paymill</a>
                    </div>
                </div>
            </li>
            [{/if}]
        </ul>
    </dd>
    [{/if}]

</dl>