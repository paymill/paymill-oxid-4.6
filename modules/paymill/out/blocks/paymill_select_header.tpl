[{assign var="oxConfig" value=$oView->getConfig()}]
[{assign var="currency" value=$oView->getActCurrency()}]
<link rel="stylesheet" type="text/css" href="[{ $oViewConf->getBaseDir() }]modules/paymill/paymill_styles.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
    var PAYMILL_PUBLIC_KEY = '[{$paymillPublicKey}]';
    var PAYMILL_AMOUNT = '[{$paymillAmount}]';
    var PAYMILL_CURRENCY = '[{$currency->name}]';
    var PAYMILL_FASTCHECKOUT_CC = [{$fastCheckoutCc}];
    var PAYMILL_FASTCHECKOUT_ELV = [{$fastCheckoutElv}];
    var PAYMILL_DEBUG = '[{$oxConfig->getShopConfVar('PAYMILL_ACTIVATE_DEBUG')}]';
    var PAYMILL_SEPA = '[{$oxConfig->getShopConfVar('PAYMILL_ACTIVATE_SEPA')}]';
    var PAYMILL_TRANSLATION = {
        PAYMILL_internal_server_error: '[{ oxmultilang ident="PAYMILL_internal_server_error" }]',
        PAYMILL_invalid_public_key: '[{ oxmultilang ident="PAYMILL_invalid_public_key" }]',
        PAYMILL_invalid_payment_data: '[{ oxmultilang ident="PAYMILL_invalid_payment_data" }]',
        PAYMILL_unknown_error: '[{ oxmultilang ident="PAYMILL_unknown_error" }]',
        PAYMILL_3ds_cancelled: '[{ oxmultilang ident="PAYMILL_3ds_cancelled" }]',
        PAYMILL_field_invalid_card_number: '[{ oxmultilang ident="PAYMILL_field_invalid_card_number" }]',
        PAYMILL_field_invalid_card_exp_year: '[{ oxmultilang ident="PAYMILL_field_invalid_card_exp_year" }]',
        PAYMILL_field_invalid_card_exp_month: '[{ oxmultilang ident="PAYMILL_field_invalid_card_exp_month" }]',
        PAYMILL_field_invalid_card_exp: '[{ oxmultilang ident="PAYMILL_field_invalid_card_exp" }]',
        PAYMILL_field_invalid_card_cvc: '[{ oxmultilang ident="PAYMILL_field_invalid_card_cvc" }]',
        PAYMILL_field_invalid_card_holder: '[{ oxmultilang ident="PAYMILL_field_invalid_card_holder" }]',
        PAYMILL_field_invalid_amount_int: '[{ oxmultilang ident="PAYMILL_field_invalid_amount_int" }]',
        PAYMILL_field_invalid_amount: '[{ oxmultilang ident="PAYMILL_field_invalid_amount" }]',
        PAYMILL_field_invalid_currency: '[{ oxmultilang ident="PAYMILL_field_invalid_currency" }]',
        PAYMILL_field_invalid_iban: '[{ oxmultilang ident="PAYMILL_field_invalid_iban" }]',
        PAYMILL_field_invalid_country: '[{ oxmultilang ident="PAYMILL_field_invalid_country" }]'
    };

</script>
<script type="text/javascript" src="https://bridge.paymill.com/"></script>
<script type="text/javascript" src="[{ $oViewConf->getBaseDir() }]modules/paymill/javascript/Iban.js"></script>
<script type="text/javascript" src="[{ $oViewConf->getBaseDir() }]modules/paymill/javascript/BrandDetection.js"></script>
<script type="text/javascript">
    $.noConflict();
    jQuery(document).ready(function($)
    {
        //cc
        $('#paymillCardNumber').live('focus', function() {
            PAYMILL_FASTCHECKOUT_CC = false;
        });

        $('#paymillCardExpiryMonth').live('focus', function() {
            PAYMILL_FASTCHECKOUT_CC = false;
        });


        $('#paymillCardExpiryYear').live('focus', function() {
            PAYMILL_FASTCHECKOUT_CC = false;
        });

        $('#paymillCardHolderName').live('focus', function() {
            PAYMILL_FASTCHECKOUT_CC = false;
        });

        $('#paymillCardCvc').live('focus', function() {
            PAYMILL_FASTCHECKOUT_CC = false;
        });

        //elv
        $('#paymillElvHolderName').live('focus', function() {
            PAYMILL_FASTCHECKOUT_ELV = false;
        });

        $('#paymillElvAccount').live('focus', function() {
            PAYMILL_FASTCHECKOUT_ELV = false;
        });

        $('#paymillElvBankCode').live('focus', function() {
            PAYMILL_FASTCHECKOUT_ELV = false;
        });

        $('#paymillIban').live('focus', function() {
            PAYMILL_FASTCHECKOUT_ELV = false;
        });

        $('#paymillBic').live('focus', function() {
            PAYMILL_FASTCHECKOUT_ELV = false;
        });

        $('#paymillCardNumber').keyup(function() {
            $("#paymillCardNumber")[0].className = $("#paymillCardNumber")[0].className.replace(/paymill-card-number-.*/g, '');
            var cardnumber = $('#paymillCardNumber').val();
            var detector = new BrandDetection();
            var brand = detector.detect(cardnumber);
            if (brand !== 'unknown') {
                $('#paymillCardNumber').addClass("paymill-card-number-" + brand);
                if (!detector.validate(cardnumber)) {
                    $('#paymillCardNumber').addClass("paymill-card-number-grayscale");
                }
            }
        });

        function PaymillResponseHandler(error, result)
        {
            if (error) {
                paymillDebug('An API error occured:' + error.apierror);
                // Zeigt den Fehler überhalb des Formulars an
                $(".payment-errors").text($("<div/>").html(PAYMILL_TRANSLATION["PAYMILL_" + error.apierror]).text());
                $(".payment-errors").css("display", "inline-block");
            } else {
                $(".payment-errors").css("display", "none");
                $(".payment-errors").text("");
                // Token
                paymillDebug('Received a token: ' + result.token);
                // Token in das Formular einfügen damit es an den Server übergeben wird
                $("#payment").append("<input type='hidden' name='paymillToken' value='" + result.token + "'/>");
                $("#payment").get(0).submit();
            }

            $("#paymentNextStepBottom").removeAttr("disabled");
        }

        function paymillDebug(message)
        {
            if (PAYMILL_DEBUG === "1") {
                console.log(message);
            }
        }

        $('#payment').submit(function(event){
            // prevent form submit
            event.preventDefault();

            // disable submit-button to prevent multiple clicks
            $('#paymentNextStepBottom').attr("disabled", "disabled");

            var tokenRequestParams = null;
            var elv = false;
            var cc = false;

            // @TODO More and better Debugging Messages
            paymillDebug('Paymill: Start form validation');
            if ($('#payment_paymill_cc').attr('checked')
                && validatePaymillCcFormData()
            ) {
                cc = true;
                tokenRequestParams = createCcTokenRequestParams();
            } else if ($('#payment_paymill_elv').attr('checked')
                && validatePaymillElvFormData()
            ) {
                elv = true;
                tokenRequestParams = createElvTokenRequestParams();
            }

            // @TODO consider fastcheckout
            if (tokenRequestParams !== null) {
                paymill.createToken(tokenRequestParams, PaymillResponseHandler);
            } else {
                // @TODO remove this?
                var paymentErrorSelectorType = cc? '.cc' : '.elv';
                var paymentError = $(
                    '.payment-errors' . paymentErrorSelectorType
                );
                paymentError.text(
                    $("<div/>").html(
                        '[{ oxmultilang ident="PAYMILL_NO_TOKEN_CREATED" }]'
                    ).text()
                );
                paymentError.css("display", "inline-block");

                $("#paymentNextStepBottom").removeAttr("disabled");
            }
        });

        function validatePaymillElvFormData()
        {
            var accountNumber = $('#paymillElvAccount').val();
            var bankCode = ('#paymillElvBankCode').val();
            var accountHolder = $('#paymillElvHolderName').val();

            var valid = true;
            var errors = '<ul>';

            if (!accountHolder) {
                errors .= '<li>'
                    . '[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTHOLDER" }]'
                    . '</li>';
                valid = false;
            }

            if (isValueAnIban(accountNumber)) {
                var iban = new Iban();
                if (!iban.validate($('#paymillIban').val())) {
                    errors .= '<li>'
                        . '[{ oxmultilang ident="PAYMILL_VALIDATION_IBAN" }]'
                        . '</li>';
                    valid = false;
                }

                if ($('#paymillBic').val() === "") {
                    errors .= '<li>'
                        . '[{ oxmultilang ident="PAYMILL_VALIDATION_BIC" }]'
                        . '</li>';
                    valid = false;
                }
            } else {
                if (!paymill.validateAccountNumber($('#paymillElvAccount').val())) {
                    errors .= '<li>'
                        . '[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTNUMBER" }]'
                        . '</li>';
                    valid = false;
                }

                if (!paymill.validateBankCode($('#paymillElvBankCode').val())) {
                    errors .= '<li>'
                        . '[{ oxmultilang ident="PAYMILL_VALIDATION_BANKCODE" }]'
                        . '</li>';
                    valid = false;
                }
            }

            if (!valid) {
                errors .= '</ul>';
                $(".payment-errors.elv").text($("<div/>").html(errors).text());
                $(".payment-errors.elv").css("display", "inline-block");
                $("#paymentNextStepBottom").removeAttr("disabled");
                return valid;
            }

            return valid;
        }

        function createElvTokenRequestParams()
        {
            var tokenRequestParams = null;
            var accountNumber = $('#paymillElvAccount').val();
            var bankCode = ('#paymillElvBankCode').val();
            var accountHolder = $('#paymillElvHolderName').val();

            if (isValueAnIban(accountNumber)) {
                tokenRequestParams = {
                    iban: accountNumber.replace(/\s+/g, ""),
                    bic: bankCode,
                    accountholder: accountHolder
                };
            } else {
                tokenRequestParams = {
                    number: accountNumber,
                    bank: bankCode,
                    accountholder: accountHolder
                }
            }

            return tokenRequestParams;
        }

        function isValueAnIban(inputValue)
        {
            return /^\D{2}/.test(inputValue);
        }

        function validatePaymillCcFormData()
        {
            if (!paymill.validateCardNumber($('#paymillCardNumber').val())) {
                $(".payment-errors.cc").text($("<div/>").html('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDNUMBER" }]').text());
                $(".payment-errors.cc").css("display", "inline-block");
                $("#paymentNextStepBottom").removeAttr("disabled");
                return false;
            }

            if (!paymill.validateExpiry($('#paymillCardExpiryMonth').val(), $('#paymillCardExpiryYear').val())) {
                $(".payment-errors.cc").text($("<div/>").html('[{ oxmultilang ident="PAYMILL_VALIDATION_EXP" }]').text());
                $(".payment-errors.cc").css("display", "inline-block");
                $("#paymentNextStepBottom").removeAttr("disabled");
                return false;
            }

            if (!paymill.validateCvc($('#paymillCardCvc').val(), $('#paymillCardNumber').val())) {
                if (paymill.cardType($('#paymillCardNumber').val()).toLowerCase() !== 'maestro') {
                    $(".payment-errors.cc").text($("<div/>").html('[{ oxmultilang ident="PAYMILL_VALIDATION_CVC" }]').text());
                    $(".payment-errors.cc").css("display", "inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
            }

            if (!paymill.validateHolder($('#paymillCardHolderName').val())) {
                $(".payment-errors.cc").text($("<div/>").html('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDHOLDER" }]').text());
                $(".payment-errors.cc").css("display", "inline-block");
                $("#paymentNextStepBottom").removeAttr("disabled");
                return false;
            }

            return true;
        }

        /**
         * Gathers form-input-values and creates request parameters for
         * creditcard token request.
         * @return {object} token request paramaters
         */
        function createCcTokenRequestParams()
        {
            var cvc = $('#paymillCardCvc').val();
            if (cvc === '') {
                cvc = '000';
            }

            var tokenRequestParams = {
                amount_int: PAYMILL_AMOUNT, // E.g. "15" for 0.15 Eur
                currency: PAYMILL_CURRENCY, // ISO 4217 e.g. "EUR"
                number: $('#paymillCardNumber').val(),
                exp_month: $('#paymillCardExpiryMonth').val(),
                exp_year: $('#paymillCardExpiryYear').val(),
                cvc: cvc,
                cardholder: $('#paymillCardHolderName').val()
            };

            return tokenRequestParams;
        }
    });
</script>
[{$smarty.block.parent}]