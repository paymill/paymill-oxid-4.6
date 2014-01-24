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
        PAYMILL_field_invalid_amount : '[{ oxmultilang ident="PAYMILL_field_invalid_amount" }]',
        PAYMILL_field_invalid_currency : '[{ oxmultilang ident="PAYMILL_field_invalid_currency" }]',
        PAYMILL_field_invalid_iban : '[{ oxmultilang ident="PAYMILL_field_invalid_iban" }]',   
        PAYMILL_field_invalid_country : '[{ oxmultilang ident="PAYMILL_field_invalid_country" }]'
    };
</script>
<script type="text/javascript" src="https://bridge.paymill.com/"></script>
<script type="text/javascript">
$.noConflict();
jQuery(document).ready(function ($) 
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
        var brand = paymill.cardType($('#paymillCardNumber').val());
        brand = brand.toLowerCase();
        $("#paymillCardNumber")[0].className = $("#paymillCardNumber")[0].className.replace(/paymill-card-number-.*/g, '');
        if (brand !== 'unknown') {
            if (brand === 'american express') {
                brand = 'amex';
            }
            
            $('#paymillCardNumber').addClass("paymill-card-number-" + brand);
        }
    });

    function PaymillResponseHandler(error, result) 
    {
        if (error) {
            paymillDebug('An API error occured:' + error.apierror);
            // Zeigt den Fehler überhalb des Formulars an
            
            var message = error.apierror;
            if(PAYMILL_TRANSLATION["PAYMILL_" + error.apierror]){
                message = PAYMILL_TRANSLATION["PAYMILL_" + error.apierror];
            }
            
            $(".payment-errors").text(message);
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
        if(PAYMILL_DEBUG === "1"){
            console.log(message);
        }
    }

    function paymillSepa()
    {
        if (!$('#paymillElvHolderName').val()) {
            $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTHOLDER" }]');
            $(".payment-errors.elv").css("display","inline-block");
            $("#paymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        if ($('#paymillIban').val() === "") {
            $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_IBAN" }]');
            $(".payment-errors.elv").css("display","inline-block");
            $("#paymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        if ($('#paymillBic').val() === "") {
            $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_BIC" }]');
            $(".payment-errors.elv").css("display","inline-block");
            $("#paymentNextStepBottom").removeAttr("disabled");
            return false;
        }
        
        var params = {
            iban: $('#paymillIban').val(),
            bic: $('#paymillBic').val(),
            accountholder: $('#paymillElvHolderName').val()
        };

        paymill.createToken(params, PaymillResponseHandler);
    }

    function paymillElv()
    {
        if (!$('#paymillElvHolderName').val()) {
            $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTHOLDER" }]');
            $(".payment-errors.elv").css("display","inline-block");
            $("#paymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        if (!paymill.validateAccountNumber($('#paymillElvAccount').val())) {
            $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTNUMBER" }]');
            $(".payment-errors.elv").css("display","inline-block");
            $("#paymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        if (!paymill.validateBankCode($('#paymillElvBankCode').val())) {
            $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_BANKCODE" }]');
            $(".payment-errors.elv").css("display","inline-block");
            $("#paymentNextStepBottom").removeAttr("disabled");
            return false;
        }

        var params = {
            number: $('#paymillElvAccount').val(),
            bank: $('#paymillElvBankCode').val(),
            accountholder: $('#paymillElvHolderName').val()
        };
        paymill.createToken(params, PaymillResponseHandler);
    }
    
    $("#payment").submit(function (event) 
    {
        // Absenden Button deaktivieren um weitere Klicks zu vermeiden
        $('#paymentNextStepBottom').attr("disabled", "disabled");
        paymillDebug('Paymill: Start form validation');
        if ($('#payment_paymill_cc').attr('checked')) {
            if (!PAYMILL_FASTCHECKOUT_CC) {
                if (!paymill.validateCardNumber($('#paymillCardNumber').val())) {
                    $(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDNUMBER" }]');
                    $(".payment-errors.cc").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }

                if (!paymill.validateExpiry($('#paymillCardExpiryMonth').val(), $('#paymillCardExpiryYear').val())) {
                    $(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_EXP" }]');
                    $(".payment-errors.cc").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }

                if (!paymill.validateCvc($('#paymillCardCvc').val(), $('#paymillCardNumber').val())) {
                    if (paymill.cardType($('#paymillCardNumber').val()).toLowerCase() !== 'maestro') {
                        $(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CVC" }]');
                        $(".payment-errors.cc").css("display","inline-block");
                        $("#paymentNextStepBottom").removeAttr("disabled");
                        return false;
                    }
                }

                if (!paymill.validateHolder($('#paymillCardHolderName').val())) {
                    $(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDHOLDER" }]');
                    $(".payment-errors.cc").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                            
                var cvc = '000';

                if ($('#paymillCardCvc').val() !== '') {
                    cvc = $('#paymillCardCvc').val();
                }

                var params = {
                    amount_int: PAYMILL_AMOUNT,  // E.g. "15" for 0.15 Eur
                    currency: PAYMILL_CURRENCY,    // ISO 4217 e.g. "EUR"
                    number: $('#paymillCardNumber').val(),
                    exp_month: $('#paymillCardExpiryMonth').val(),
                    exp_year: $('#paymillCardExpiryYear').val(),
                    cvc: cvc,
                    cardholder: $('#paymillCardHolderName').val()
                };
                paymill.createToken(params, PaymillResponseHandler);
            } else {
                $("#payment").append("<input type='hidden' name='paymillToken' value='dummyToken'/>");
                $("#payment").get(0).submit();
            }
        } else if($('#payment_paymill_elv').attr('checked')) {
            if (!PAYMILL_FASTCHECKOUT_ELV) {
                if (PAYMILL_SEPA === "1") {
                    paymillSepa();
                } else {
                    paymillElv();
                }
            } else {
                $("#payment").append("<input type='hidden' name='paymillToken' value='dummyToken'/>");
                $("#payment").get(0).submit();
            }
        } else{
            $("#paymentNextStepBottom").removeAttr("disabled");
            return true;
        }
        
        return false;
    });
});
</script>
[{$smarty.block.parent}]