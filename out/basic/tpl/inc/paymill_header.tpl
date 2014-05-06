[{assign var="oxConfig" value=$oView->getConfig()}]
[{assign var="currency" value=$oView->getActCurrency()}]
<link rel="stylesheet" type="text/css" href="[{ $oViewConf->getBaseDir() }]modules/paymill/paymill_styles.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
    // @TODO Basic Theme support for new javascript code
    var PAYMILL_PUBLIC_KEY = '[{$paymillPublicKey}]';
    var PAYMILL_AMOUNT = '[{$paymillAmount}]';
    var PAYMILL_CURRENCY = '[{$currency->name}]';
    var PAYMILL_FASTCHECKOUT_CC = [{$fastCheckoutCc}];
    var PAYMILL_FASTCHECKOUT_ELV = [{$fastCheckoutElv}];
    var PAYMILL_DEBUG = '[{$oxConfig->getShopConfVar('PAYMILL_ACTIVATE_DEBUG')}]';
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
        PAYMILL_field_invalid_amount: '[{ oxmultilang ident="PAYMILLfield_invalid_amount" }]',
        PAYMILL_field_invalid_currency: '[{ oxmultilang ident="PAYMILL_field_invalid_currency" }]',
        PAYMILL_field_invalid_iban: '[{ oxmultilang ident="PAYMILL_field_invalid_iban" }]',
        PAYMILL_field_invalid_country: '[{ oxmultilang ident="PAYMILL_field_invalid_country" }]'
    };
    var PAYMILL_CC_BRANDS = [{$paymillBrands|@json_encode}];
</script>
<script type="text/javascript" src="https://bridge.paymill.com/"></script>
<script type="text/javascript" src="[{ $oViewConf->getBaseDir() }]modules/paymill/javascript/Iban.js"></script>
<script type="text/javascript" src="[{ $oViewConf->getBaseDir() }]modules/paymill/javascript/BrandDetection.js"></script>
<script type="text/javascript">
var prefilledInputValues = [];

$.noConflict();
jQuery(document).ready(function($) {
    prefilledInputValues = getFormData();

    $('#paymillCardNumber').on('input keyup', function() {
        $("#paymillCardNumber")[0].className = $("#paymillCardNumber")[0].className.replace(/paymill-card-number-.*/g, '');
        var cardnumber = $('#paymillCardNumber').val();
        var detector = new BrandDetection();
        var brand = detector.detect(cardnumber);

        if (shouldBrandBeRendered(brand)) {
            $('#paymillCardNumber').addClass("paymill-card-number-" + brand);
            if (!detector.validate(cardnumber)) {
                $('#paymillCardNumber').addClass("paymill-card-number-grayscale");
            }
        }
    });

    $( "form[name='order']" ).submit(function(event) {
        var cc = $('#payment_paymill_cc').attr('checked') === 'checked';
        var elv = $('#payment_paymill_elv').attr('checked') === 'checked';

        if (cc || elv) {
            // prevent form submit
            event.preventDefault();

            // disable submit-button to prevent multiple clicks
            $('#test_PaymentNextStepBottom').attr("disabled", "disabled");

            if (!isFastCheckout(cc, elv)) {
                generateToken(cc, elv);
            } else {
                fastCheckout();
            }
        }

        return true;
    });

    /**
     * Get values of PAYMILL-Payment form-inputs
     * @return {[string]} array of PAYMILL form-input-values
     */
    function getFormData() {
        var formData = [];
        $('.paymill_input').each(function() {
            formData.push($(this).val());
        });
        return formData;
    }

    /**
     * Tests if brand should be rendered in view
     * @param  {string} brand brand name
     * @return {boolean} should brand be rendered
     */
    function shouldBrandBeRendered(brand)
    {
        var shouldBrandBeRendered = brand !== 'unknown' && (
                $.inArray(brand, PAYMILL_CC_BRANDS) !== -1
                || PAYMILL_CC_BRANDS.length === 0
        );
        return shouldBrandBeRendered;
    }

    /**
     * console.log message if PAYMILL_Debug is allowed
     * @param  {string} message Debug message
     */
    function paymillDebug(message)
    {
        if (PAYMILL_DEBUG === "1") {
            console.log(message);
        }
    }

    /**
     * First tests if fast checkout is allowed then verifies if form data has
     * not changed since the script has loaded, only if the data did not change
     * fast checkout should be tried.
     * @param  {Boolean}  cc  user has chosen credit card payment
     * @param  {Boolean}  elv user has chosen elv payment
     * @return {Boolean}  is fast checkout allowed in this context
     */
    function isFastCheckout(cc, elv)
    {
        if ((cc && PAYMILL_FASTCHECKOUT_CC) || (elv && PAYMILL_FASTCHECKOUT_ELV)) {
            var formdata = getFormData();
            return prefilledInputValues.toString() === formdata.toString();
        }

        return false;
    }

    /**
     * Adds dummy token to form and calls the response handler
     */
    function fastCheckout()
    {
        $("#paymill_form").append(
            "<input type='hidden' name='paymillFastcheckout' value='" +
            true + "'/>"
        );
        result = new Object();
        result.token = 'dummyToken';
        PaymillResponseHandler(null, result);
    }

    /**
     * Generate PAYMILL token
     * @param  {Boolean} cc  has user chosen credit card payment
     * @param  {Boolean} elv hast user chosen elv payment
     */
    function generateToken(cc, elv)
    {
        var tokenRequestParams = null;
        var paymentError;

        var paymentErrorSelectorType = cc? '.cc' : '.elv';
        var paymentError = $(
         '.payment-errors' + paymentErrorSelectorType
        );

        // remove old errors
        $('.payment-errors' + paymentErrorSelectorType + ' ul').remove();

        // @TODO More and better Debugging Messages
        paymillDebug('Paymill: Start form validation');

        if (cc && validatePaymillCcFormData()) {
         tokenRequestParams = createCcTokenRequestParams();
        } else if (elv && validatePaymillElvFormData()) {
         tokenRequestParams = createElvTokenRequestParams();
        }

        if (tokenRequestParams !== null) {
            paymill.createToken(tokenRequestParams, PaymillResponseHandler);
        } else {
            paymentError.css("display", "inline-block");
            $("#test_PaymentNextStepBottom").removeAttr("disabled");
        }
    }

    function PaymillResponseHandler(error, result)
    {
        if (error) {
            paymillDebug('An API error occured:' + error.apierror);
            // shows errors above the PAYMILL specific part of the form
            $(".payment-errors").text($("<div/>").html(PAYMILL_TRANSLATION["PAYMILL_" + error.apierror]).text());
            $(".payment-errors").css("display", "inline-block");
        } else {
            $(".payment-errors").css("display", "none");
            $(".payment-errors").text("");
            // Token
            paymillDebug('Received a token: ' + result.token);
            // add token into hidden input field for request to the server
            $("form[name='order']").append("<input type='hidden' name='paymillToken' value='" + result.token + "'/>");
            $("form[name='order']").get(0).submit();
        }

        $("#test_PaymentNextStepBottom").removeAttr("disabled");
    }

    /**
     * ELV-form-data validation
     * @return {Boolean} Are form-data valid
     */
    function validatePaymillElvFormData()
    {
        var accountNumber = $('#paymillElvAccount').val();
        var bankCode = $('#paymillElvBankCode').val();
        var accountHolder = $('#paymillElvHolderName').val();

        var valid = true;
        var errors = [];

        if (!accountHolder) {
            errors.push('[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTHOLDER" }]');
            valid = false;
        }

        if (isValueAnIban(accountNumber)) {
            var iban = new Iban();
            if (!iban.validate($('#paymillIban').val())) {
                errors.push(
                    '[{ oxmultilang ident="PAYMILL_VALIDATION_IBAN" }]'
                );
                valid = false;
            }

            if ($('#paymillBic').val() === "") {
                errors.push(
                    '[{ oxmultilang ident="PAYMILL_VALIDATION_BIC" }]'
                );
                valid = false;
            }
        } else {
            if (!paymill.validateAccountNumber($('#paymillElvAccount').val())) {
                errors.push(
                    '[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTNUMBER" }]'
                );
                valid = false;
            }

            if (!paymill.validateBankCode($('#paymillElvBankCode').val())) {
                errors.push(
                    '[{ oxmultilang ident="PAYMILL_VALIDATION_BANKCODE" }]'
                );
                valid = false;
            }
        }

        if (!valid) {
            createErrorBoxMarkup($(".payment-errors.elv"), errors);
            return valid;
        }

        return valid;
    }

    function createElvTokenRequestParams()
    {
        var tokenRequestParams = null;
        var accountNumber = $('#paymillElvAccount').val();
        var bankCode = $('#paymillElvBankCode').val();
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
        var valid = true;
        var errors = [];

        if (!paymill.validateCardNumber($('#paymillCardNumber').val())) {
            errors.push(
                '[{ oxmultilang ident="PAYMILL_VALIDATION_CARDNUMBER" }]'
            );
            valid = false;
        }

        if (!paymill.validateExpiry($('#paymillCardExpiryMonth').val(), $('#paymillCardExpiryYear').val())) {
            errors.push('[{ oxmultilang ident="PAYMILL_VALIDATION_EXP" }]');
            valid = false;
        }

        if (!paymill.validateCvc($('#paymillCardCvc').val(), $('#paymillCardNumber').val())) {
            if (paymill.cardType($('#paymillCardNumber').val()).toLowerCase() !== 'maestro') {
                errors.push('[{ oxmultilang ident="PAYMILL_VALIDATION_CVC" }]');
                valid = false;
            }
        }

        if (!paymill.validateHolder($('#paymillCardHolderName').val())) {
            errors.push('[{ oxmultilang ident="PAYMILL_VALIDATION_CARDHOLDER" }]');
            valid = false;
        }

        if (!valid) {
            createErrorBoxMarkup($(".payment-errors.cc"), errors);
            return valid;
        }

        return valid;
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

    function createErrorBoxMarkup(paymentErrorsContainer, errors)
    {
        var list = $('<ul />').appendTo(paymentErrorsContainer);

        errors.forEach(function(entry) {
            $('<li />').text(
                $("<span />").html(entry).text()
            ).appendTo(list);
        });
    }

});
</script>