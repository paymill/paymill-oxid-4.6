Paymill-Oxid 4.6
==================

Payment plugin for OXID Version 4.6.5

Download the module here: https://github.com/Paymill/Paymill-Oxid/archive/master.zip

- Merge the content of the Paymill-Oxid-Module directory with your OXID installation.
- Import the install.sql to your database.
- In your administration backend activate the Paymill plugin.
- Go to the configuration section where you can insert your private and public key (that you can find in your Paymill cockpit [https://app.paymill.de/](https://app.paymill.de/ "Paymill cockpit")).

# Activate Paymill Payment

To activate Paymill payment follow these steps:

- In the main menu goto **Shopeinstellungen > Zahlungsarten**
- Choose the payment method you want to activate
- Click on **Benutzergruppen zuordnen** and assign the right user groups
- Go to tab **Länder**, click on **Länder zuordnen**, and assign the right countries
- In the main menu goto **Shopeinstellungen > Versandarten**
- Choose a shipping type (e.g. **Standard**) and go to tab **Zahlungsarten**
- Click on **Zahlungsarten zuordnen** and assign the payment method
- Repeat last 2 steps for other shipping types

# Template-Support

- Basic and Azure template are supported by default.
- To support a custom template adapt the template structure within the out/azure directory to your custom theme.

## Enable Basic Templatesupport
- Open "Shoproot/out/basic/tpl/page/checkout/payment.tpl" in your preferred editor.
- Change the following lines:

Old:
```php
[{include file="_header.tpl" title=$template_title location=$template_title}]
<!-- ordering steps -->
[{include file="inc/steps_item.tpl" highlight=3}]
```
New:
```php
[{include file="_header.tpl" title=$template_title location=$template_title}]
<!--PAYMILL START-->
	[{include file="inc/paymill_header.tpl"}]
<!--PAYMILL END-->
<!-- ordering steps -->
[{include file="inc/steps_item.tpl" highlight=3}]
```

Old:
```php
[{assign var="iPayError" value=$oView->getPaymentError() }]
```

New:
```php
[{assign var="iPayError" value=$oView->getPaymentError() }]
<!--PAYMILL START-->
  [{ if $piPaymillError}]
	<br><div class="errorbox" style="color:red;">[{ $piPaymillError }]</div>
  [{ /if }]
<!--PAYMILL END-->
```

Old:
```php
[{elseif $sPaymentID == "oxiddebitnote"}]
    [{ assign var="dynvalue" value=$oView->getDynValue()}]
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
      <td><input id="test_Payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]></td>
      <td id="test_PaymentDesc_[{$smarty.foreach.PaymentSelect.iteration}]" colspan="2"><label><b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b></label></td>
    </tr>
    ...
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
      <td></td>
      <td><label>[{ oxmultilang ident="PAYMENT_ACCOUNTHOLDER2" }]</label></td>
      <td><input type="text" size="20" maxlength="64" name="dynvalue[lsktoinhaber]" value="[{ if $dynvalue.lsktoinhaber }][{ $dynvalue.lsktoinhaber }][{else}][{$oxcmp_user->oxuser__oxfname->value}] [{$oxcmp_user->oxuser__oxlname->value}][{/if}]"></td>
    </tr>
[{else}]
```
New:
```php
[{elseif $sPaymentID == "oxiddebitnote"}]
    [{ assign var="dynvalue" value=$oView->getDynValue()}]
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
      <td><input id="test_Payment_[{$sPaymentID}]" type="radio" name="paymentid" value="[{$sPaymentID}]" [{if $oView->getCheckedPaymentId() == $paymentmethod->oxpayments__oxid->value}]checked[{/if}]></td>
      <td id="test_PaymentDesc_[{$smarty.foreach.PaymentSelect.iteration}]" colspan="2"><label><b>[{ $paymentmethod->oxpayments__oxdesc->value}]</b></label></td>
    </tr>
    ...
    <tr onclick="oxid.form.select('paymentid',[{$inptcounter}]);">
      <td></td>
      <td><label>[{ oxmultilang ident="PAYMENT_ACCOUNTHOLDER2" }]</label></td>
      <td><input type="text" size="20" maxlength="64" name="dynvalue[lsktoinhaber]" value="[{ if $dynvalue.lsktoinhaber }][{ $dynvalue.lsktoinhaber }][{else}][{$oxcmp_user->oxuser__oxfname->value}] [{$oxcmp_user->oxuser__oxlname->value}][{/if}]"></td>
    </tr>
<!--PAYMILL START-->
[{elseif $sPaymentID == "paymill_cc"}]
      [{include file="inc/paymill_payment.tpl"}]
[{elseif $sPaymentID == "paymill_elv"}]
      [{include file="inc/paymill_payment.tpl"}]
<!--PAYMILL END-->
[{else}]
```

# Error handling

In case of any errors turn on the debug mode in the Paymill payment method configuration.
Open the javascript console in your browser and check the debug messages during the checkout process.

# Logging

- If you enable logging in the plugin configuration make sure that log.txt inside the plugin directory is writable by your web server. Otherwise logging information will not be stored to the logfile.
- You can access the logging within your administration backend under Paymill -> Log

# Notes about the payment process

The payment is processed when an order is placed in the shop frontend.