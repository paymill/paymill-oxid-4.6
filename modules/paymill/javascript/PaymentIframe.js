jQuery(document).ready(function($) {
    var options = {
        labels: {
            number: decodeTranslations(PAYMILL_TRANSLATION_LABELS.PAYMILL_card_number_label),
            cvc: decodeTranslations(PAYMILL_TRANSLATION_LABELS.PAYMILL_card_cvc_label),
            cardholder: decodeTranslations(PAYMILL_TRANSLATION_LABELS.PAYMILL_card_holdername_label),
            exp: decodeTranslations(PAYMILL_TRANSLATION_LABELS.PAYMILL_card_expiry_label)
        },
        placeholders: {
            number: 'XXXX XXXX XXXX XXXX',
            cvc: 'XXX',
            cardholder: 'John Doe',
            exp_month: 'MM',
            exp_year: 'YYYY'
        },
        errors: {
            number: decodeTranslations(PAYMILL_TRANSLATION.PAYMILL_VALIDATION_CARDNUMBER),
            cvc: decodeTranslations(PAYMILL_TRANSLATION.PAYMILL_VALIDATION_CVC),
            exp: decodeTranslations(PAYMILL_TRANSLATION.PAYMILL_VALIDATION_EXP)
        }
    };

    if (PAYMILL_COMPLIANCE_CSS && PAYMILL_COMPLIANCE_CSS.match("^https://.*$")) {
        options.stylesheet = PAYMILL_COMPLIANCE_CSS;
    }

    paymill.embedFrame('payment-form-cc', options, function(error) {
        if (error && PAYMILL_DEBUG === "1") {
            console.log(error.apierror, error.message);
        } else {
            // Frame was loaded successfully and is ready to be used.
        }
    });

    console.log(PAYMILL_PAYMENT_FORM);

    $(PAYMILL_PAYMENT_FORM).submit(function (event) {
        var cc;

        cc = $('#payment_paymill_cc').attr('checked');

        if (cc && PAYMILL_COMPLIANCE) {
            // prevent form submit
            event.preventDefault();

            clearErrors();

            // disable submit-button to prevent multiple clicks
            $(PAYMILL_NEXT_STEP_BUTTON).attr("disabled", "disabled");

            if (PAYMILL_FASTCHECKOUT_CC && !PAYMILL_FASTCHECKOUT_CC_CHANGED) {
                fastCheckout();
            } else {
                createToken();
            }
        }

        return true;
    });

    $('#payment_paymill_cc').click(clearErrors);
    $('#payment_paymill_elv').click(clearErrors);

    function clearErrors()
    {
        $(".payment-errors").css("display", "none");
        $(".payment-errors").text("");
    }

    $('#paymillFastCheckoutIframeChange').click(function (event) {
        $('#payment-form-cc').toggle();
        PAYMILL_FASTCHECKOUT_CC_CHANGED = true;
    });

    function createToken()
    {
        paymill.createTokenViaFrame({
            amount_int: PAYMILL_AMOUNT,
            currency: PAYMILL_CURRENCY
        }, paymillResponseHandler);
    }

    function fastCheckout()
    {
        $("#paymill_form").append("<input id='paymillFastcheckoutHidden' type='hidden' name='paymillFastcheckout' value='" + true + "'/>");
        result = new Object();
        result.token = 'dummyToken';
        paymillResponseHandler(null, result);
    }

    function paymillResponseHandler(error, result)
    {
        // Handle error or process result.
        if (error) {
            paymillDebug('An API error occured:' + error.apierror);
            // shows errors above the PAYMILL specific part of the form
            $('.payment-errors.cc').text($("<div/>").html(PAYMILL_TRANSLATION["PAYMILL_" + error.apierror]).text());
            $('.payment-errors.cc').css("display", "inline-block");
        } else {
            // Token
            paymillDebug('Received a token: ' + result.token);
            // add token into hidden input field for request to the server
            $(PAYMILL_PAYMENT_FORM).append("<input type='hidden' name='paymillToken' value='" + result.token + "'/>");
            $(PAYMILL_PAYMENT_FORM).get(0).submit();
        }

        $(PAYMILL_NEXT_STEP_BUTTON).removeAttr("disabled");
    }

    function paymillDebug(message)
    {
        if (PAYMILL_DEBUG === "1") {
            console.log(message);
        }
    }

    /**
     * Warning potentially harmful should only be used with date from trusted source.
     * @param  {string} translation
     * @return {string}
     */
    function decodeTranslations(translation) {
        var textarea = document.createElement("textarea");
        textarea.innerHTML = translation;
        return textarea.value;
    }

});