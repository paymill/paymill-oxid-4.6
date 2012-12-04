[{assign var="oxConfig" value=$oView->getConfig()}]
<link rel="stylesheet" type="text/css" href="[{ $oViewConf->getBaseDir() }]/modules/paymill/paymill_styles.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">

</script>
<dl>
    <dt>
        <input id="payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]>
        <label for="payment_[{$sPaymentID}]"><b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b></label>
    </dt>
    <dd class="[{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]activePayment[{/if}]">

        <ul class="form">
            <li>
                <img src="[{ $oViewConf->getBaseDir() }]/modules/paymill/icon_elv.png" />
            </li>
            <li>
                <label>Kontoinhaber</label>
                <input type="text" size="20" maxlength="50" value="[{$oxcmp_user->oxuser__oxfname->value}] [{$oxcmp_user->oxuser__oxlname->value}]" id="paymill_accountholder" />
                <p class="oxValidateError" id="holderErrors">
                    Bitte geben Sie den Kontoinhaber an.
                </p>
            </li>
            <li>
                <label>Kontonummer</label>
                <input type="text" size="20" maxlength="35" value="" autocomplete="off" id="paymill_accountnumber" />
                <p class="oxValidateError" id="accountnumberErrors">
                    Bitte geben Sie eine g&uuml;ltige Kontonummer ein.
                </p>
            </li>
            
            
            <li>
                <label>Bankleitzahl</label>
                <input type="text" size="20" maxlength="20" value=""  autocomplete="off" id="paymill_banknumber" />
                <p class="oxValidateError" id="banknumberErrors">
                    Bitte geben Sie eine g&uuml;ltige BLZ ein.
                </p>
            </li>
            [{if $oxConfig->getShopConfVar('paymill_show_label') == "yes" }]
            <li>
                <div class="paymill_powered"><div class="paymill_credits">[{ oxmultilang ident="PAYMILL_ELV_POWERED_TEXT" }] <a href="http://www.paymill.de" target="_blank">Paymill</a></div></div>
            </li>
            [{/if}]
        </ul>
        
        <input type="hidden" id="paymill_elv_transaction_token" name="paymill_elv_transaction_token" value="" />
        <script type="text/javascript">
            var PAYMILL_PUBLIC_KEY = '[{$oxConfig->getShopConfVar('paymill_public_key')}]';
        </script>
        <script type="text/javascript" src="[{$oxConfig->getShopConfVar('paymill_bridge_url')}]"></script>
        <script type="text/javascript">
            $(document).ready(function() {

                function paymill_elv_resonse_handler(error, result) {
                    paymill_elv_debug("Started Paymill response handler");
                    if (error) {
                        paymill_elv_debug("API returned error" + error.apierror);
                    } else {
                        paymill_elv_debug("Received token from Paymill API: " + result.token);
                        $('#paymill_elv_transaction_token').val(result.token);
                        $('#paymill_cc_transaction_token').val("");
                        $('#payment').get(0).submit();
                    }
                }

                function paymill_elv_handler() {
                
                    paymill_elv_debug("Paymill handler triggered");
                
                    $('#banknumberErrors').hide();
                    $('#accountnumberErrors').hide();
                    $('#holderErrors').hide();

                    var error = false;

                    if (!paymill.validateAccountNumber($('#paymill_accountnumber').val())) {
                        $('#accountnumberErrors').show();
                        error = true;
                    }
                    if (!paymill.validateBankCode($('#paymill_banknumber').val())) {
                        $('#banknumberErrors').show();
                        error = true;
                    }
                    if (!$('#paymill_accountholder').val()) {
                        $('#holderErrors').show();
                        error = true;
                    }
                    if (error) {
                        return false;
                    }
                
                    paymill_elv_debug("Validations successful");
                
                    paymill.createToken({
                        number: $('#paymill_accountnumber').val(), 
                        bank: $('#paymill_banknumber').val(), 
                        accountholder: $('#paymill_accountholder').val()
                    }, paymill_elv_resonse_handler
                    );
                    return false;
                }
                
                function paymill_elv_debug(message) {
                    if ("[{$oxConfig->getShopConfVar('paymill_debug_mode')}]" == "yes") {
                        console.log("[PaymillELV] " + message);
                    }
                }

                function paymill_elv_is_paymill_payment() {
                    var radioButton = document.getElementById('payment_[{$sPaymentID}]');
                    return radioButton.checked;
                }

                function paymill_elv_select() {
                    paymill_elv_debug("Select ELV as onSubmit");
                    var form = document.getElementById('paymill_elv_transaction_token').form;
                    form.onsubmit = function() { paymill_elv_handler(); return false; }                      
                } 

                if (paymill_elv_is_paymill_payment()) {
                    paymill_elv_select();
                }

                $('#payment_[{$sPaymentID}]').click(function() {
                    paymill_elv_select();
                });
            });
        </script>
    </dd>
</dl>