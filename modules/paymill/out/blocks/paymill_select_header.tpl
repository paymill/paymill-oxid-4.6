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
        PAYMILL_field_invalid_country: '[{ oxmultilang ident="PAYMILL_field_invalid_country" }]',
        PAYMILL_VALIDATION_IBAN: '[{ oxmultilang ident="PAYMILL_VALIDATION_IBAN" }]',
        PAYMILL_VALIDATION_BIC: '[{ oxmultilang ident="PAYMILL_VALIDATION_BIC" }]',
        PAYMILL_VALIDATION_ACCOUNTNUMBER: '[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTNUMBER" }]',
        PAYMILL_VALIDATION_BANKCODE: '[{ oxmultilang ident="PAYMILL_VALIDATION_BANKCODE" }]',
        PAYMILL_VALIDATION_CARDNUMBER: '[{ oxmultilang ident="PAYMILL_VALIDATION_CARDNUMBER" }]',
        PAYMILL_VALIDATION_EXP: '[{ oxmultilang ident="PAYMILL_VALIDATION_EXP" }]',
        PAYMILL_VALIDATION_CVC: '[{ oxmultilang ident="PAYMILL_VALIDATION_CVC" }]',
        PAYMILL_VALIDATION_CARDHOLDER: '[{ oxmultilang ident="PAYMILL_VALIDATION_CARDHOLDER" }]',
        PAYMILL_VALIDATION_ACCOUNTHOLDER: '[{ oxmultilang ident="PAYMILL_VALIDATION_ACCOUNTHOLDER" }]'
    };

    var PAYMILL_CC_BRANDS = [{$paymillBrands|@json_encode}];
</script>
<script type="text/javascript" src="https://bridge.paymill.com/"></script>
<script type="text/javascript" src="[{ $oViewConf->getBaseDir() }]modules/paymill/javascript/Iban.js"></script>
<script type="text/javascript" src="[{ $oViewConf->getBaseDir() }]modules/paymill/javascript/BrandDetection.js"></script>
<script type="text/javascript" src="[{ $oViewConf->getBaseDir() }]modules/paymill/javascript/Payment.js"></script>
[{$smarty.block.parent}]
