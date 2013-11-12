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
</script>
<script type="text/javascript" src="https://bridge.paymill.com/"></script>
<script type="text/javascript">
$.noConflict();
jQuery(document).ready(function ($) 
{
    
    //cc
    $('#paymillCardNumber').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
        $('#paymillCardNumber').val('');
    });

    $('#paymillCardExpiryMonth').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
    });


    $('#paymillCardExpiryYear').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
    });

    $('#paymillCardHolderName').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
        $('#paymillCardHolderName').val('');
    });

    $('#paymillCardCvc').live('focus', function() {
        PAYMILL_FASTCHECKOUT_CC = false;
        $('#paymillCardCvc').val('');
    });

    //elv
    $('#paymillElvHolderName').live('focus', function() {
        PAYMILL_FASTCHECKOUT_ELV = false;
        $('#paymillElvHolderName').val('');
    });
    
    $('#paymillElvAccount').live('focus', function() {
        PAYMILL_FASTCHECKOUT_ELV = false;
        $('#paymillElvAccount').val('');
    });
    
    $('#paymillElvBankCode').live('focus', function() {
        PAYMILL_FASTCHECKOUT_ELV = false;
        $('#paymillElvBankCode').val('');
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
            $(".payment-errors").text(error.apierror);
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