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
        PAYMILL_internal_server_error : '[{ oxmultilang ident="PAYMILL_internal_server_error" }]',
        PAYMILL_invalid_public_key : '[{ oxmultilang ident="PAYMILL_invalid_public_key" }]',
        PAYMILL_invalid_payment_data : '[{ oxmultilang ident="PAYMILL_invalid_payment_data" }]',
        PAYMILL_unknown_error : '[{ oxmultilang ident="PAYMILL_unknown_error" }]',
        PAYMILL_3ds_cancelled : '[{ oxmultilang ident="PAYMILL_3ds_cancelled" }]',
        PAYMILL_field_invalid_card_number : '[{ oxmultilang ident="PAYMILL_field_invalid_card_number" }]',
        PAYMILL_field_invalid_card_exp_year : '[{ oxmultilang ident="PAYMILL_field_invalid_card_exp_year" }]',
        PAYMILL_field_invalid_card_exp_month : '[{ oxmultilang ident="PAYMILL_field_invalid_card_exp_month" }]',
        PAYMILL_field_invalid_card_exp : '[{ oxmultilang ident="PAYMILL_field_invalid_card_exp" }]',
        PAYMILL_field_invalid_card_cvc : '[{ oxmultilang ident="PAYMILL_field_invalid_card_cvc" }]',
        PAYMILL_field_invalid_card_holder : '[{ oxmultilang ident="PAYMILL_field_invalid_card_holder" }]',
        PAYMILL_field_invalid_amount_int : '[{ oxmultilang ident="PAYMILL_field_invalid_amount_int" }]',
        PAYMILL_field_field_invalid_amount : '[{ oxmultilang ident="PAYMILL_field_field_invalid_amount" }]',
        PAYMILL_field_field_field_invalid_currency : '[{ oxmultilang ident="PAYMILL_field_field_field_invalid_currency" }]'        
    };
</script>
<script type="text/javascript" src="https://bridge.paymill.com/"></script>
<script type="text/javascript">
pmQuery = jQuery.noConflict();
pmQuery(document).ready(function () 
{   
    //cc
    pmQuery('#paymillCardNumber').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
    });

    pmQuery('#paymillCardExpiryMonth').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
    });


    pmQuery('#paymillCardExpiryYear').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
    });

    pmQuery('#paymillCardHolderName').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
    });

    pmQuery('#paymillCardCvc').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
    });

    //elv
    pmQuery('#paymillElvHolderName').live('focus', function() {
        PAYMILL_FASTCHECKOUT_ELV = false;
    });
    
    pmQuery('#paymillElvAccount').live('focus', function() {
        PAYMILL_FASTCHECKOUT_ELV = false;
    });
    
    pmQuery('#paymillElvBankCode').live('focus', function() {
        PAYMILL_FASTCHECKOUT_ELV = false;
    });
    
    pmQuery('#paymillIban').live('focus', function() {
        PAYMILL_FASTCHECKOUT_ELV = false;
    });
    
    pmQuery('#paymillBic').live('focus', function() {
        PAYMILL_FASTCHECKOUT_ELV = false;
    });
    
    pmQuery('#paymillCardNumber').keyup(function() {
        var brand = paymill.cardType(pmQuery('#paymillCardNumber').val());
        brand = brand.toLowerCase();
        pmQuery("#paymillCardNumber")[0].className = pmQuery("#paymillCardNumber")[0].className.replace(/paymill-card-number-.*/g, '');
        if (brand !== 'unknown') {
            if (brand === 'american express') {
                brand = 'amex';
            }
            
            pmQuery('#paymillCardNumber').addClass("paymill-card-number-" + brand);
        }
    });

    function PaymillResponseHandler(error, result) 
    {
        if (error) {
            paymillDebug('An API error occured:' + error.apierror);
            // Zeigt den Fehler überhalb des Formulars an
            pmQuery(".payment-errors").text(PAYMILL_TRANSLATION["PAYMILL_" + error.apierror]);
            pmQuery(".payment-errors").css("display", "inline-block");
        } else {
            pmQuery(".payment-errors").css("display", "none");
            pmQuery(".payment-errors").text("");
            // Token
            paymillDebug('Received a token: ' + result.token);
            // Token in das Formular einfügen damit es an den Server übergeben wird
            pmQuery('form[name="order"]').append("<input type='hidden' name='paymillToken' value='" + result.token + "'/>");
            pmQuery('form[name="order"]').get(0).submit();
        }
        
        pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
    }

    function paymillDebug(message)
    {
        if(PAYMILL_DEBUG === "1"){
            console.log(message);
        }
    }
    
    function paymillElv()
    {
        if (!pmQuery('#paymillElvHolderName').val()) {
            pmQuery(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTHOLDER" }]');
            pmQuery(".payment-errors.elv").css("display","inline-block");
            pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        if (!paymill.validateAccountNumber(pmQuery('#paymillElvAccount').val())) {
            pmQuery(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTNUMBER" }]');
            pmQuery(".payment-errors.elv").css("display","inline-block");
            pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        if (!paymill.validateBankCode(pmQuery('#paymillElvBankCode').val())) {
            pmQuery(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_BANKCODE" }]');
            pmQuery(".payment-errors.elv").css("display","inline-block");
            pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        var params = {
            number: pmQuery('#paymillElvAccount').val(),
            bank: pmQuery('#paymillElvBankCode').val(),
            accountholder: pmQuery('#paymillElvHolderName').val()
        };
        paymill.createToken(params, PaymillResponseHandler);
    }
    
    function paymillSepa()
    {
        if (!pmQuery('#paymillElvHolderName').val()) {
            pmQuery(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTHOLDER" }]');
            pmQuery(".payment-errors.elv").css("display","inline-block");
            pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        if (pmQuery('#paymillIban').val() === "") {
            pmQuery(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_IBAN" }]');
            pmQuery(".payment-errors.elv").css("display","inline-block");
            pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        if (pmQuery('#paymillBic').val() === "") {
            pmQuery(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_BIC" }]');
            pmQuery(".payment-errors.elv").css("display","inline-block");
            pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        var params = {
            iban: pmQuery('#paymillIban').val(),
            bic: pmQuery('#paymillBic').val(),
            accountholder: pmQuery('#paymillElvHolderName').val()
        };
        paymill.createToken(params, PaymillResponseHandler);
    }

    pmQuery('form[name="order"]').submit(function (event)
    {
        // Absenden Button deaktivieren um weitere Klicks zu vermeiden
        pmQuery('#test_PaymentNextStepBottom').attr("disabled", "disabled");
        paymillDebug('Paymill: Start form validation');
        if (pmQuery('#payment_paymill_cc').attr('checked')) {
            if (!PAYMILL_FASTCHECKOUT_CC) {
                if (!paymill.validateCardNumber(pmQuery('#paymillCardNumber').val())) {
                    pmQuery(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDNUMBER" }]');
                    pmQuery(".payment-errors.cc").css("display","inline-block");
                    pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
                    return false;
                }

                if (!paymill.validateExpiry(pmQuery('#paymillCardExpiryMonth').val(), pmQuery('#paymillCardExpiryYear').val())) {
                    pmQuery(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_EXP" }]');
                    pmQuery(".payment-errors.cc").css("display","inline-block");
                    pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
                    return false;
                }

                if (!paymill.validateCvc(pmQuery('#paymillCardCvc').val(), pmQuery('#paymillCardNumber').val())) {
                    if (paymill.cardType(pmQuery('#paymillCardNumber').val()).toLowerCase() !== 'maestro') {
                        pmQuery(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CVC" }]');
                        pmQuery(".payment-errors.cc").css("display","inline-block");
                        pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
                        return false;
                    }
                }

                if (!paymill.validateHolder(pmQuery('#paymillCardHolderName').val())) {
                    pmQuery(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDHOLDER" }]');
                    pmQuery(".payment-errors.cc").css("display","inline-block");
                    pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                            
                var cvc = '000';

                if (pmQuery('#paymillCardCvc').val() !== '') {
                    cvc = pmQuery('#paymillCardCvc').val();
                }

                var params = {
                    amount_int: PAYMILL_AMOUNT,  // E.g. "15" for 0.15 Eur
                    currency: PAYMILL_CURRENCY,    // ISO 4217 e.g. "EUR"
                    number: pmQuery('#paymillCardNumber').val(),
                    exp_month: pmQuery('#paymillCardExpiryMonth').val(),
                    exp_year: pmQuery('#paymillCardExpiryYear').val(),
                    cvc: cvc,
                    cardholder: pmQuery('#paymillCardHolderName').val()
                };
                paymill.createToken(params, PaymillResponseHandler);
            } else {
                pmQuery('form[name="order"]').append("<input type='hidden' name='paymillToken' value='dummyToken'/>");
                pmQuery('form[name="order"]').get(0).submit();
            }
        } else if(pmQuery('#payment_paymill_elv').attr('checked')) {
            if (!PAYMILL_FASTCHECKOUT_ELV) {
                if (PAYMILL_SEPA === "1") {
                    paymillSepa();
                } else {
                    paymillElv();
                }
            } else {
                pmQuery('form[name="order"]').append("<input type='hidden' name='paymillToken' value='dummyToken'/>");
                pmQuery('form[name="order"]').get(0).submit();
            }
        } else{
            pmQuery("#test_PaymentNextStepBottom").removeAttr("disabled");
            return true;
        }
        
        return false;
    });
});
</script>