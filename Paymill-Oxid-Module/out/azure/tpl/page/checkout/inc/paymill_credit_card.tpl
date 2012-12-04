[{assign var="oxConfig" value=$oView->getConfig()}]
<link rel="stylesheet" type="text/css" href="[{ $oViewConf->getBaseDir() }]/modules/paymill/paymill_styles.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<dl>
    <dt>
        <input id="payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]>
        <label for="payment_[{$sPaymentID}]"><b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b></label>
    </dt>
    <dd class="[{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]activePayment[{/if}]">

        <ul class="form">
            <li>
                <img src="[{ $oViewConf->getBaseDir() }]/modules/paymill/icon_mastercard.png" />
                <img src="[{ $oViewConf->getBaseDir() }]/modules/paymill/icon_visa.png" />
            </li>
            <li>
                <label>[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_NUMBER" }]</label>
                <input type="text" size="20" maxlength="35" value="" autocomplete="off" id="paymill_card_number" />
                <p class="oxValidateError" id="cardErrors">
                    [{ oxmultilang ident="PAYMILL_VALIDATION_CARDNUMBER" }]
                </p>
            </li>
            <li>
                <label>[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_ACCOUNTHOLDER" }]</label>
                <input type="text" size="20" maxlength="50" value="[{$oxcmp_user->oxuser__oxfname->value}] [{$oxcmp_user->oxuser__oxlname->value}]" id="paymill_card_holder" />
                <p class="oxValidateError" id="holderErrors">
                    [{ oxmultilang ident="PAYMILL_VALIDATION_CARDHOLDER" }]
                </p>
            </li>
            <li>
                <label>[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_VALIDUNTIL" }]</label>
                <select id="paymill_exp_month">
                    <option >01</option>
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

                &nbsp;/&nbsp;

                <select id="paymill_exp_year">
                    [{foreach from=$oView->getCreditYears() item=year}]
                    <option>[{$year}]</option>
                    [{/foreach}]
                </select>
                <p class="oxValidateError" id="expErrors">
                    [{ oxmultilang ident="PAYMILL_VALIDATION_EXP" }]
                </p>
            </li>
            <li>
                <label>[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_SECURITYCODE" }]</label>
                <input type="text" size="20" maxlength="6" value=""  autocomplete="off" id="paymill_cvc" />
                <p class="oxValidateError" id="cvcErrors">
                    [{ oxmultilang ident="PAYMILL_VALIDATION_CVC" }]
                </p>
                <br>
                <div class="note">[{ oxmultilang ident="PAGE_CHECKOUT_PAYMENT_SECURITYCODEDESCRIPTION" }]</div>
            </li>
            [{if $oxConfig->getShopConfVar('paymill_show_label') == "yes" }]
            <li>
                <div class="paymill_powered"><div class="paymill_credits">[{ oxmultilang ident="PAYMILL_POWERED_TEXT" }] <a href="http://www.paymill.de" target="_blank">Paymill</a></div></div>
            </li>
            [{/if}]
        </ul>
        
        <input type="hidden" id="paymill_cc_transaction_token" name="paymill_cc_transaction_token" value="" />
        <script type="text/javascript">
            var PAYMILL_PUBLIC_KEY = '[{$oxConfig->getShopConfVar('paymill_public_key')}]';
        </script>
        <script type="text/javascript" src="[{$oxConfig->getShopConfVar('paymill_bridge_url')}]"></script>
        <script type="text/javascript">
            $(document).ready(function() {

                function paymill_cc_select() {
                    var form = document.getElementById('paymill_cc_transaction_token').form;
                    form.onsubmit = function() { paymill_cc_handler(); return false; }   
                }

                function paymill_cc_resonse_handler(error, result) {
                    paymill_cc_debug("Started Paymill response handler");
                    if (error) {
                        paymill_cc_debug("API returned error" + error.apierror);
                    } else {
                        paymill_cc_debug("Received token from Paymill API: " + result.token);
                        $('#paymill_cc_transaction_token').val(result.token);
                        $('#paymill_elv_transaction_token').val("");
                        $('#payment').get(0).submit();
                    }
                }

                function paymill_cc_handler() {
                
                    paymill_cc_debug("Paymill handler triggered");
                
                    $('#cvcErrors').hide();
                    $('#expErrors').hide();
                    $('#cardErrors').hide();
                    $('#holderErrors').hide();

                    var error = false;

                    if (!paymill.validateCardNumber($('#paymill_card_number').val())) {
                        $('#cardErrors').show();
                        error = true;
                    }
                    if (!paymill.validateExpiry($('#paymill_exp_month').val(), $('#paymill_exp_year').val())) {
                        $('#expErrors').show();
                        error = true;
                    }
                    if (!paymill.validateCvc($('#paymill_cvc').val())) {
                        $('#cvcErrors').show();
                        error = true;
                    }
                    if (!$('#paymill_card_holder').val()) {
                        $('#holderErrors').show();
                        error = true;
                    }
                    if (error) {
                        return false;
                    }
                
                    paymill_cc_debug("Validations successful");
                
                    paymill.createToken({
                        number: $('#paymill_card_number').val(), 
                        exp_month: $('#paymill_exp_month').val(), 
                        exp_year: $('#paymill_exp_year').val(), 
                        cvc: $('#paymill_cvc').val(), 
                        amount: '[{php}]
                            $amount = oxSession::getInstance()->getBasket()->getPrice()->getBruttoPrice();
                            $amount = number_format($amount, 2, '.', '');
                            print $amount;
                        [{/php}]',
                        cardholdername: $('#paymill_card_holder').val(),
                        currency: '[{$currency->name}]' 
                        }, paymill_cc_resonse_handler
                    );
                    return false;
                }
                
                function paymill_cc_debug(message) {
                    if ("[{$oxConfig->getShopConfVar('paymill_debug_mode')}]" == "yes") {
                        console.log("[PaymillCC] " + message);
                    }
                }

                function paymill_cc_is_paymill_payment() {
                    var radioButton = document.getElementById('payment_[{$sPaymentID}]');
                    return radioButton.checked;
                }

                function paymill_cc_select() {
                    paymill_cc_debug("Select CC as onSubmit");
                    var form = document.getElementById('paymill_cc_transaction_token').form;
                    form.onsubmit = function() { paymill_cc_handler(); return false; }                      
                } 

                if (paymill_cc_is_paymill_payment()) {
                    paymill_cc_select();
                }

                $('#payment_[{$sPaymentID}]').click(function() {
                    paymill_cc_select();
                });



            });
        </script>
    </dd>
</dl>