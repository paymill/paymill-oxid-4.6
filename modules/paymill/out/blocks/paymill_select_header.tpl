[{assign var="oxConfig" value=$oView->getConfig()}]
[{assign var="currency" value=$oView->getActCurrency()}]
<link rel="stylesheet" type="text/css" href="[{ $oViewConf->getBaseDir() }]modules/paymill/paymill_styles.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
    var PAYMILL_PUBLIC_KEY = '[{$paymillPublicKey}]';
    var PAYMILL_AMOUNT = '[{$paymillAmount}]';
    var PAYMILL_CURRENCY = '[{$currency->name}]';
    var PAYMILL_SHOWFORM_CC = '[{$paymillShowForm_cc}]';
    var PAYMILL_SHOWFORM_ELV = '[{$paymillShowForm_elv}]';
    var PAYMILL_DEBUG = '[{$oxConfig->getShopConfVar('PAYMILL_ACTIVATE_DEBUG')}]';
</script>
<script type="text/javascript" src="https://bridge.paymill.com/"></script>
<script type="text/javascript">
$.noConflict();
jQuery(document).ready(function ($) {
    $('.card-number').keyup(function() {
        var brand = paymill.cardType($('.card-number').val());
            brand = brand.toLowerCase();
            switch(brand){
                case 'visa':
                    $('.card-icon').html('<img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/32x20_visa.png" >');
                    $('.card-icon').show();
                    break;
                case 'mastercard':
                    $('.card-icon').html('<img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/32x20_mastercard.png" >');
                    $('.card-icon').show();
                    break;
                case 'american express':
                    $('.card-icon').html('<img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/32x20_amex.png" >');
                    $('.card-icon').show();
                    break;
                case 'jcb':
                    $('.card-icon').html('<img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/32x20_jcb.png" >');
                    $('.card-icon').show();
                    break;
                case 'maestro':
                    $('.card-icon').html('<img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/32x20_maestro.png" >');
                    $('.card-icon').show();
                    break;
                case 'diners club':
                    $('.card-icon').html('<img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/32x20_dinersclub.png" >');
                    $('.card-icon').show();
                    break;
                case 'discover':
                    $('.card-icon').html('<img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/32x20_discover.png" >');
                    $('.card-icon').show();
                    break;
                case 'unionpay':
                    $('.card-icon').html('<img src="[{ $oViewConf->getBaseDir() }]modules/paymill/image/32x20_unionpay.png" >');
                    $('.card-icon').show();
                    break;
                case 'unknown':
                default:
                    $('.card-icon').hide();
                    break;
            }
            $('.card-icon :first-child').css('position','absolute');

    });

    function PaymillResponseHandler(error, result) {
        if (error) {
            paymillDebug('An API error occured:' + error.apierror);
            // Zeigt den Fehler überhalb des Formulars an
            $(".payment-errors").text(error.apierror);
            $(".payment-errors").css("display","inline-block");
        } else {
            $(".payment-errors").css("display","none");
            $(".payment-errors").text("");
            var form = $("#payment");
            // Token
            var token = result.token;
            paymillDebug('Received a token: ' + token);
            // Token in das Formular einfügen damit es an den Server übergeben wird
            form.append("<input type='hidden' name='paymillToken' value='" + token + "'/>");
            form.get(0).submit();
        }
        $("#paymentNextStepBottom").removeAttr("disabled");
    }

    function paymillDebug(message){
        if(PAYMILL_DEBUG == "1"){
            console.log(message);
        }
    }

    $("#payment").submit(function (event) {
        // Absenden Button deaktivieren um weitere Klicks zu vermeiden
        $('#paymentNextStepBottom').attr("disabled", "disabled");
        paymillDebug('Paymill: Start form validation');
        paymenttype = $('#payment_paymill_cc').attr('checked') ? 'cc' : $('#payment_paymill_elv').attr('checked') ? 'elv': 'other';
            if(paymenttype == "cc" && PAYMILL_SHOWFORM_CC){
                if (false == paymill.validateCardNumber($('.card-number').val())) {
                    $(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDNUMBER" }]');
                    $(".payment-errors.cc").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                if (false == paymill.validateExpiry($('.card-expiry-month').val(), $('.card-expiry-year').val())) {
                    $(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_EXP" }]');
                    $(".payment-errors.cc").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                if (false == paymill.validateCvc($('.card-cvc').val(), $('.card-number').val())) {
                    $(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CVC" }]');
                    $(".payment-errors.cc").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                if ($('.card-holdername').val() == '') {
                    $(".payment-errors.cc").text('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDHOLDER" }]');
                    $(".payment-errors.cc").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                var params = {
                    amount_int:     PAYMILL_AMOUNT,  // E.g. "15" for 0.15 Eur
                    currency:       PAYMILL_CURRENCY,    // ISO 4217 e.g. "EUR"
                    number:         $('.card-number').val(),
                    exp_month:      $('.card-expiry-month').val(),
                    exp_year:       $('.card-expiry-year').val(),
                    cvc:            $('.card-cvc').val(),
                    cardholder:     $('.card-holdername').val()
                };
            }else if(paymenttype == "elv" && PAYMILL_SHOWFORM_ELV){

                if (false == $('.elv-holdername').val()) {
                    $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTHOLDER" }]');
                    $(".payment-errors.elv").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                if (false == paymill.validateAccountNumber($('.elv-account').val())) {
                    $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTNUMBER" }]');
                    $(".payment-errors.elv").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                if (false == paymill.validateBankCode($('.elv-bankcode').val())) {
                    $(".payment-errors.elv").text('[{ oxmultilang ident="PAYMILL_VALIDATION_BANKCODE" }]');
                    $(".payment-errors.elv").css("display","inline-block");
                    $("#paymentNextStepBottom").removeAttr("disabled");
                    return false;
                }
                var params = {
                    number:         $('.elv-account').val(),
                    bank:           $('.elv-bankcode').val(),
                    accountholder:  $('.elv-holdername').val()
                };
            }else{
                $("#paymentNextStepBottom").removeAttr("disabled");
                return true;
            }
        paymill.createToken(params, PaymillResponseHandler);
        return false;
    });
});
</script>
[{$smarty.block.parent}]