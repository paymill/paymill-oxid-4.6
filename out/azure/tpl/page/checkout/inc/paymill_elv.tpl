[{assign var="oxConfig" value=$oView->getConfig()}]
<dl>
    <dt>
        <input id="payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]>
        <label for="payment_[{$sPaymentID}]"><b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b></label>
    </dt>
    <dd class="[{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]activePayment[{/if}]">
        <ul class="form">
            <li class="controls controls-row">
                <p class="payment-errors elv" style="display:none;"></p>
                <div id="payment-form-elv">
                    <div class="controls controls-row">
                        <label class="elv-holdername-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNTHOLDER" }]:</label>
                        <input id="paymillElvHolderName" class="elv-holdername span3" type="text" size="20" value="[{$paymillElvHolder}]"/>
                    </div>
                    <div class="controls controls-row">
                        <label class="elv-account-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNT" }]:</label>
                        <input id="paymillElvAccount" class="elv-account span3" type="text" size="20" value="[{$paymillElvAccount}]"/>
                    </div>
                    <div class="controls controls-row">
                        <label class="elv-bankcode-label">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_BANKCODE" }]:</label>
                        <input id="paymillElvBankCode" class="elv-bankcode span3" type="text" size="20" value="[{$paymillElvCode}]"/>
                    </div>
                </div>
            </li>
            [{if $oxConfig->getShopConfVar('PAYMILL_SHOW_LABEL')}]
            <li>
                <div class="paymill_powered">
                    <div class="paymill_credits">
                        [{ oxmultilang ident="PAYMILL_ELV_POWERED_TEXT" }]
                        <a href="http://www.paymill.de" target="_blank">PAYMILL</a>
                    </div>
                </div>
            </li>
            [{/if}]
        </ul>
    </dd>
</dl>