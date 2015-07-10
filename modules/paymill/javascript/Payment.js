/**
 * Payment
 *
 * @copyright  Copyright (c) 2015 PAYMILL GmbH (https://www.paymill.com)
 */

var prefilledInputValues = [];

$.noConflict();
jQuery(document).ready(function($) {
	prefilledInputValues = getFormData();

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

	function shouldBrandBeRendered(brand)
	{
		return (brand !== 'unknown' && ($.inArray(brand, PAYMILL_CC_BRANDS) !== -1 || PAYMILL_CC_BRANDS.length === 0));
	}

	function paymillDebug(message)
	{
		if (PAYMILL_DEBUG === "1") {
			console.log(message);
		}
	}

	$(PAYMILL_PAYMENT_FORM).submit(function(event) {
		var cc = $('#payment_paymill_cc').attr('checked') === 'checked';
		var elv = $('#payment_paymill_elv').attr('checked') === 'checked';

		if ((cc && !PAYMILL_COMPLIANCE) || elv) {
			// prevent form submit
			event.preventDefault();
			clearErrors();

			// disable submit-button to prevent multiple clicks
			$(PAYMILL_NEXT_STEP_BUTTON).attr("disabled", "disabled");

			if (!isFastCheckout(cc, elv)) {
				generateToken(cc, elv);
			} else {
				fastCheckout(cc, elv);
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

	function isFastCheckout(cc, elv)
	{
		if ((cc && PAYMILL_FASTCHECKOUT_CC) || (elv && PAYMILL_FASTCHECKOUT_ELV)) {
			var formdata = getFormData();
			return prefilledInputValues.toString() === formdata.toString();
		}

		return false;
	}

	function fastCheckout()
	{
		$("#paymill_form").append("<input type='hidden' name='paymillFastcheckout' value='" + true + "'/>");
		result = new Object();
		result.token = 'dummyToken';
		PaymillResponseHandler(null, result);
	}

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
			$(PAYMILL_NEXT_STEP_BUTTON).removeAttr("disabled");
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
			// Token
			paymillDebug('Received a token: ' + result.token);
			// add token into hidden input field for request to the server
			$(PAYMILL_PAYMENT_FORM).append("<input type='hidden' name='paymillToken' value='" + result.token + "'/>");
			$(PAYMILL_PAYMENT_FORM).get(0).submit();
		}

		$(PAYMILL_NEXT_STEP_BUTTON).removeAttr("disabled");
	}

	function validatePaymillElvFormData()
	{
		var accountNumber = $('#paymillElvAccount').val();
		var bankCode = $('#paymillElvBankCode').val();
		var accountHolder = $('#paymillElvHolderName').val();

		var valid = true;
		var errors = [];

		if (!accountHolder) {
			errors.push(PAYMILL_TRANSLATION.PAYMILL_VALIDATION_ACCOUNTHOLDER);
			valid = false;
		}

		if (isValueAnIban(accountNumber)) {
			var iban = new Iban();
			if (!iban.validate(accountNumber)) {
				errors.push(
					PAYMILL_TRANSLATION.PAYMILL_VALIDATION_IBAN
				);
				valid = false;
			}

			if (bankCode === "") {
				errors.push(
					PAYMILL_TRANSLATION.PAYMILL_VALIDATION_BIC
				);
				valid = false;
			}
		} else {
			if (!paymill.validateAccountNumber(accountNumber)) {
				errors.push(
					PAYMILL_TRANSLATION.PAYMILL_VALIDATION_ACCOUNTNUMBER
				);
				valid = false;
			}

			if (!paymill.validateBankCode(bankCode)) {
				errors.push(
					PAYMILL_TRANSLATION.PAYMILL_VALIDATION_BANKCODE
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
				PAYMILL_TRANSLATION.PAYMILL_VALIDATION_CARDNUMBER
			);
			valid = false;
		}

		if (!paymill.validateExpiry(
			$('#paymillCardExpiryMonth').val(),
			$('#paymillCardExpiryYear').val()
		)) {
			errors.push(PAYMILL_TRANSLATION.PAYMILL_VALIDATION_EXP);
			valid = false;
		}

		if (!paymill.validateCvc(
			$('#paymillCardCvc').val(),
			$('#paymillCardNumber').val()
		)) {
			if (paymill.cardType(
				$('#paymillCardNumber').val()
			).toLowerCase() !== 'maestro') {
				errors.push(PAYMILL_TRANSLATION.PAYMILL_VALIDATION_CVC);
				valid = false;
			}
		}

		if (!paymill.validateHolder($('#paymillCardHolderName').val())) {
			errors.push(PAYMILL_TRANSLATION.PAYMILL_VALIDATION_CARDHOLDER);
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