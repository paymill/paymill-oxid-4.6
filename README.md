PAYMILL - Oxid 4.6
==================

Payment plugin for OXID Version 4.6.x

Download the module here: https://github.com/Paymill/Paymill-Oxid/archive/master.zip

- Merge the content of the PAYMILL-Oxid-Module directory with your OXID installation.
- In your administration backend activate the Paymill plugin.
- Go to the configuration section where you can insert your private and public key (that you can find in your Paymill cockpit [https://app.paymill.de/](https://app.paymill.de/ "Paymill cockpit")).

# Activate PAYMILL Payment

To activate PAYMILL payment follow these steps:

- In the main menu goto **Shopeinstellungen > Zahlungsarten**
- Choose the payment method you want to activate
- Click on **Benutzergruppen zuordnen** and assign the right user groups
- Go to tab **Länder**, click on **Länder zuordnen**, and assign the right countries
- In the main menu goto **Shopeinstellungen > Versandarten**
- Choose a shipping type (e.g. **Standard**) and go to tab **Zahlungsarten**
- Click on **Zahlungsarten zuordnen** and assign the payment method
- Repeat last 2 steps for other shipping types

# Update
If you want to update from an version earlier than 2.1 you have to run the update.sql first.

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
- Open "Shoproot/out/basic/tpl/email/html/order_cust.tpl" in your preferred editor.
- Change the following lines:

Old:
```php
[{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTMETHOD" }] <b>[{ $payment->oxpayments__oxdesc->value }] [{ if $basket->getPaymentCosts() }]([{ $basket->getFPaymentCosts() }] [{ $currency->sign}])[{/if}]</b><br>
[{/if}]<br>
```
New:
```php
[{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTMETHOD" }] <b>[{ $payment->oxpayments__oxdesc->value }] [{ if $basket->getPaymentCosts() }]([{ $basket->getFPaymentCosts() }] [{ $currency->sign}])[{/if}]</b><br>
[{/if}]<br>
<!--PAYMILL START-->
[{if $paymillIsPaymillElv}]
  <p>[{oxmultilang ident="PAYMILL_PRENOTIFICATION_TEXT"}] [{$paymillDaysUntilWithdraw}]</p>
[{/if}]
<!--PAYMILL END-->
```

- Open "Shoproot/out/basic/tpl/email/plain/order_cust.tpl" in your preferred editor.
- Change the following lines:

Old:
```php
[{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTMETHOD" }] [{ $payment->oxpayments__oxdesc->getRawValue() }] [{ if $basket->getPaymentCosts() }]([{ $basket->getFPaymentCosts() }] [{ $currency->sign}])[{/if}]
[{/if}]
```
New:
```php
[{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTMETHOD" }] [{ $payment->oxpayments__oxdesc->getRawValue() }] [{ if $basket->getPaymentCosts() }]([{ $basket->getFPaymentCosts() }] [{ $currency->sign}])[{/if}]
[{/if}]
<!--PAYMILL START-->
[{if $paymillIsPaymillElv}]
  <br>[{oxmultilang ident="PAYMILL_PRENOTIFICATION_TEXT"}] [{$paymillDaysUntilWithdraw}]<br>
[{/if}]
<!--PAYMILL END-->
```

# Error handling

In case of any errors turn on the debug mode in the PAYMILL payment method configuration.
Open the javascript console in your browser and check the debug messages during the checkout process.

# Logging

- If you enable logging in the plugin configuration make sure that log.txt inside the plugin directory is writable by your web server. Otherwise logging information will not be stored to the logfile.
- You can access the logging within your administration backend under Paymill -> Log

# Notes about the payment process

Fast Checkout: Fast checkout can be enabled by selecting the option in the PAYMILL Basic Settings. If any customer completes a purchase while the option is active this customer will not be asked for data again. Instead a reference to the customer data will be saved allowing comfort during checkout.

The payment is processed when an order is placed in the shop frontend.

# Notes about direct debit (ELV) Prenotification
Because the invoice pdf cannot be automatically extended without breaking custom invoices, we decided to not extend the invoice pdf. To add prenotification to the invoice manually add following snippet:

- Open "Shoproot/modules/invoicepdf/myorder.php" in your preferred editor.
- Change the following lines:

Old:
```php
protected function _setPayUntilInfo( &$iStartPos )
{
    $text = $this->_oData->translate( 'ORDER_OVERVIEW_PDF_PAYUPTO' ).date( 'd.m.Y', mktime( 0, 0, 0, date ( 'm' ), date ( 'd' ) + 7, date( 'Y' ) ) );
    $this->font( $this->getFont(), '', 10 );
    $this->text( 15, $iStartPos + 4, $text );
    $iStartPos += 4;
}
```
New:
protected function _setPayUntilInfo( &$iStartPos )
{
    // PAYMILL Start
    $oPayment = oxNew('oxpayment');
    $oPayment->loadInLang($this->_oData->getSelectedLang(), $this->_oData->oxorder__oxpaymenttype->value);

    if ($oPayment->oxpayments__oxid->value == "paymill_elv") {
        $translatedText = $this->_oData->translate('PAYMILL_PRENOTIFICATION_TEXT');

        $myConfig = oxConfig::getInstance();
        $daysUntilWithdraw = $myConfig->getConfigParam('PAYMILL_PRENOTIFICATION');
        $orderDate = $this->_oData->oxorder__oxorderdate->value;
        $dateTime = new DateTime($orderDate);
        $dateTime->modify('+' . $daysUntilWithdraw . ' day');
        $dateFormat = $this->_oData->translate('PAYMILL_DATE_FORMAT');
        $date = $dateTime->format($dateFormat);

        $text = $translatedText . ' ' . $date;
    } else {
    // PAYMILL END
        $text = $this->_oData->translate( 'ORDER_OVERVIEW_PDF_PAYUPTO' ).date( 'd.m.Y', mktime( 0, 0, 0, date ( 'm' ), date ( 'd' ) + 7, date( 'Y' ) ) );
    // PAYMILL START
    }
    // PAYMILL END

        $this->font( $this->getFont(), '', 10 );
        $this->text( 15, $iStartPos + 4, $text );
        $iStartPos += 4;
}
```
