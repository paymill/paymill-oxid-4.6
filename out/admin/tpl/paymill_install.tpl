<html>
    <head>
        [{include file="headitem.tpl" title="PAYMILL_TITLE"|oxmultilangassign}]
        <title>[{ oxmultilang ident="GENERAL_ADMIN_TITLE" }]</title>
        <link rel="stylesheet" type="text/css" href="[{ $oViewConf->getBaseDir() }]modules/paymill/paymill_styles.css" />
        <script type="text/javascript">
            var PAYMILL_PUBLIC_KEY = '[{$paymillPublicKey}]';</script>
        <script type="text/javascript" src="https://bridge.paymill.com/"></script>
        <script type="text/javascript">
            function PaymillResponseHandler(error, result)
            {
                var publicKey = document.getElementById('paymillPublicKey');
                var newClass = ' paymill_green';
                var icon = '&#10003';
                if (error !== null && error.hasOwnProperty('apierror')) {
                    if (error.apierror === 'invalid_public_key') {
                        newClass = ' paymill_red';
                        icon = '&#10007';
                    }
                }
                publicKey.className = publicKey.className + newClass;
                document.getElementById('paymillPublicKeyIcon').innerHTML = icon;
            }

            paymill.createToken({
                amount_int: 1, // E.g. "15" for 0.15 Eur
                currency: "EUR", // ISO 4217 e.g. "EUR"
                number: "5105105105105100",
                exp_month: 02,
                exp_year: 2020,
                cvc: 123
            }, PaymillResponseHandler);
        </script>
    </head>
    <body>
        <h3>[{ oxmultilang ident="PAYMILL_TITLE" }] [{ oxmultilang ident="PAYMILL_INSTALL" }]</h3>
        <div class="row [{if $paymillIsDatabaseInstalled}]paymill_green[{else}]paymill_red[{/if}]">
            [{if $paymillIsDatabaseInstalled}]&#10003;[{else}]&#10007;[{/if}]
            <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_DATABASE" }]</label>
            [{if !$paymillIsDatabaseInstalled}]
            <form id="paymill_payments" action="[{$oViewConf->getSelfLink()}]" method="post">
                <input type="hidden" name="cl" value="[{$oViewConf->getActiveClassName()}]">
                [{$oViewConf->getHiddenSid()}]
                <input type="submit" class="install_button" value='[{ oxmultilang ident="PAYMILL_INSTALL_BUTTON" }]'>
                <input type="hidden" name="fnc" value="installDatabase">
            </form>
            [{/if}]
        </div>
        <div class="row [{if $paymillAreTplBlocksSet}]paymill_green[{else}]paymill_red[{/if}]">
            [{if $paymillAreTplBlocksSet}]&#10003;[{else}]&#10007;[{/if}]
            <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_BLOCKS }]</label>
            [{if !$paymillAreTplBlocksSet}]
            <form id="paymill_payments" action="[{$oViewConf->getSelfLink()}]" method="post">
                <input type="hidden" name="cl" value="[{$oViewConf->getActiveClassName()}]">
                [{$oViewConf->getHiddenSid()}]
                <input type="submit" class="install_button" value='[{ oxmultilang ident="PAYMILL_INSTALL_BUTTON" }]'>
                <input type="hidden" name="fnc" value="updateBlocks">
            </form>
            [{/if}]
        </div>
        <div class="row [{if $paymillIsPrivateKeyValid}]paymill_green[{else}]paymill_red[{/if}]">
            [{if $paymillIsPrivateKeyValid}]&#10003;[{else}]&#10007;[{/if}]
            <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_PRIVATEKEY" }]</label>
        </div>
        <div id="paymillPublicKey" class="row">
            <span id="paymillPublicKeyIcon">&nbsp;</span>
            <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_PUBLICKEY" }]</label>
        </div>
        <div class="row [{if $paymillIsPaymentInstalled}]paymill_green[{else}]paymill_red[{/if}]">
            [{if $paymillIsPaymentInstalled}]&#10003;[{else}]&#10007;[{/if}]
            <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_PAYMENT" }]</label>
            [{if !$paymillIsPaymentInstalled}]
            <form id="paymill_payments" action="[{$oViewConf->getSelfLink()}]" method="post">
                <input type="hidden" name="cl" value="[{$oViewConf->getActiveClassName()}]">
                [{$oViewConf->getHiddenSid()}]
                <input type="submit" class="install_button" value='[{ oxmultilang ident="PAYMILL_INSTALL_BUTTON" }]'>
                <input type="hidden" name="fnc" value="installPayments">
            </form>
            [{/if}]
        </div>
        <div class="row [{if $paymillIsPaymentConfigured}]paymill_green[{else}]paymill_red[{/if}]">
            [{if $paymillIsPaymentConfigured}]&#10003;[{else}]&#10007;[{/if}]
            <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_PAYMENT_CONFIG" }]</label>
        </div>
        <div class="row [{if $paymillIsShippingConfigured}]paymill_green[{else}]paymill_red[{/if}]">
            [{if $paymillIsShippingConfigured}]&#10003;[{else}]&#10007;[{/if}]
            <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_SHIPPING_CONFIG" }]</label>
        </div>
        <div class="row [{if $paymillIsPrenotificationSet}]paymill_green[{else}]paymill_red[{/if}]">
            [{if $paymillIsPrenotificationSet}]
            &#10003;
            <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_PRENOTIFICATION" }]</label>
            [{else}]
            X <label>[{ oxmultilang ident="PAYMILL_INSTALL_LABEL_PRENOTIFICATION_FAILED" }]</label>
            [{/if}]
        </div>
    [{include file="pagetabsnippet.tpl"}]

    [{include file="bottomnaviitem.tpl"}]

    [{include file="bottomitem.tpl"}]
</body>
</html>

