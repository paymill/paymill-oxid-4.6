<html>
    <head>
        <title>[{ oxmultilang ident="GENERAL_ADMIN_TITLE" }]</title>
        <link rel="stylesheet" type="text/css" href="[{ $oViewConf->getBaseDir() }]modules/paymill/paymill_styles.css" />
        <script type="text/javascript">
            var PAYMILL_PUBLIC_KEY = '[{$paymillPublicKey}]';</script>
        <script type="text/javascript" src="https://bridge.paymill.com/"></script>
        <script type="text/javascript">
                    function PaymillResponseHandler(error, result)
                    {
                        var publicKey = document.getElementById('paymillPublicKey');
                        var newClass = ' paymill_red';
                        var icon = '&#10007';
                        if (result.hasOwnProperty('token')) {
                            if (/tok_.*/.test(result.token)) {
                                newClass = ' paymill_green';
                                icon = '&#10003';
                            }
                        }
                        publicKey.className = publicKey.className + newClass;
                        document.getElementById('paymillPublicKeyIcon').innerHTML = icon;
                    }
            if (paymill.isTestKey(paymill.getApiKey())) {
                    paymill.createToken({
                    amount_int: 1, // E.g. "15" for 0.15 Eur
                            currency: "EUR", // ISO 4217 e.g. "EUR"
                            number: "5105105105105100",
                            exp_month: 02,
                            exp_year: 2020,
                            cvc: 123
                    }, PaymillResponseHandler);
            }
        </script>
    </head>
    <body>
        <div class="paymill_main">
            <fieldset class="row">
                <h3>PAYMILL EasyInstall</h3>
            </fieldset>
            <fieldset class="row [{if $paymillIsDatabaseInstalled}]paymill_green[{else}]paymill_red[{/if}]">
                [{if $paymillIsDatabaseInstalled}]&#10003;[{else}]&#10007;[{/if}]
                <label>Datenbanktabellen vorhanden</label>
                [{if !$paymillIsDatabaseInstalled}]
                <form id="paymill_database" action="[{$oViewConf->getSelfLink()}]" method="post">
                    <input type="submit" value='[{ oxmultilang ident="PAYMILL_INSTALL" }]'>
                    <input type="hidden" name="cl" value="[{$oViewConf->getActiveClassName()}]">
                    <input type="hidden" name="fnc" value="installDatabase">
                    [{$oViewConf->getHiddenSid()}]
                </form>
                [{/if}]
            </fieldset>
            <fieldset class="row [{if $paymillIsPrivateKeyValid}]paymill_green[{else}]paymill_red[{/if}]">
                [{if $paymillIsPrivateKeyValid}]&#10003;[{else}]&#10007;[{/if}]
                <label>PrivateKey valide</label>
            </fieldset>
            <fieldset id="paymillPublicKey" class="row">
                <span id="paymillPublicKeyIcon">&nbsp;</span>
                <label>PublicKey valide</label>
            </fieldset>
            <fieldset class="row">
                <label>*&Uuml;berpr&uuml;fung nur im TestModus m&ouml;glich</label>
            </fieldset>
            <fieldset class="row [{if $paymillIsPaymentInstalled}]paymill_green[{else}]paymill_red[{/if}]">
                [{if $paymillIsPaymentInstalled}]&#10003;[{else}]&#10007;[{/if}]
                <label>Zahlarten installiert</label>
                [{if !$paymillIsPaymentInstalled}]
                <form id="paymill_payments" action="[{$oViewConf->getSelfLink()}]" method="post">
                    <input type="submit" value='[{ oxmultilang ident="PAYMILL_INSTALL" }]'>
                    <input type="hidden" name="cl" value="[{$oViewConf->getActiveClassName()}]">
                    <input type="hidden" name="fnc" value="installPayments">
                    [{$oViewConf->getHiddenSid()}]
                </form>
                [{/if}]
            </fieldset>
            <fieldset class="row [{if $paymillIsPaymentConfigured}]paymill_green[{else}]paymill_red[{/if}]">
                [{if $paymillIsPaymentConfigured}]&#10003;[{else}]&#10007;[{/if}]
                <label>Zahlarten konfiguriert</label>
            </fieldset>
            <fieldset class="row [{if $paymillIsShippingConfigured}]paymill_green[{else}]paymill_red[{/if}]">
                [{if $paymillIsShippingConfigured}]&#10003;[{else}]&#10007;[{/if}]
                <label>Versandarten konfiguriert</label>
            </fieldset>
        </div>
        [{include file="bottomnaviitem.tpl"}]
    </body>
</html>

