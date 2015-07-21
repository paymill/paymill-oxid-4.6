PAYMILL - OXID 4.6
==================

Payment module for OXID Version 4.6.x

# Your Advantages
 * PCI DSS compatibility
 * Payment means: Credit Card (Visa, Visa Electron, Mastercard, Maestro, Diners, Discover, JCB, AMEX, China Union Pay), Direct Debit (ELV)
 * Optional fast checkout configuration allowing your customers not to enter their payment detail over and over during checkout
 * Improved payment form with visual feedback for your customers
 * Supported Languages: German, English, Spanish, French, Italian, Portuguese
 * Backend Log with custom View accessible from your shop backend

## PayFrame
We’ve introduced a “payment form” option for easier compliance with PCI requirements.
In addition to having a payment form directly integrated in your checkout page, you can use our embedded PayFrame solution to ensure that payment data never touches your website.
PayFrame is enabled by default, but you can choose between both options in the plugin settings. Later this year, we’re bringing you the ability to customise the appearance and text content of the PayFrame version.
To learn more about the benefits of PayFrame, please visit our [FAQ](https://www.paymill.com/en/faq/how-does-paymills-payframe-solution-work "FAQ").

# Installation and Usage
Download the module here: https://github.com/Paymill/paymill-oxid-4.6/archive/master.zip

- Merge the content of the PAYMILL-OXID-Module directory with your OXID installation.
- Clear the OXID tmp folder.
- In your administration backend activate the Paymill plugin.
- Go to the configuration section where you can insert your private and public key (which you can find in your Paymill cockpit [https://app.paymill.de/](https://app.paymill.de/ "Paymill cockpit")).
- In the main menu goto **PAYMILL > Checklist**; The checklist allows you to verify that the module has been successfully configured. It also fixes missing tables, block etc.

## Activate PAYMILL Payment

To activate PAYMILL payment follow these steps:

- In the main menu goto **Shop Settings > Payment Methods**
- Choose the payment method you want to activate
- Click on **Assign User Groups** and assign the right user groups
- Go to tab **Country**, click on **Assign Countries**, and assign the right countries
- In the main menu goto **Shop Settings > Shipping Methods**
- Choose a shipping type (e.g. **Standard**) and go to tab **Payment**
- Click on **Assign Payment Methods** and assign the payment method
- Repeat last 2 steps for other shipping types

## Update
If you want to update from an version earlier than 2.1 (starting from 2.0.0) you have to run the update.sql first.

## Template-Support

- Basic and Azure template are supported by default.
- To support a custom template based on Azure, adapt the template structure within the modules/paymill/out/blocks directory to your custom theme. The files most interesting for you are 'paymill_select_payment.tpl and 'paymill_select_header.tpl'.
- To support a custom template based on Basic, adapt the template structure within the out/basic/tpl/inc/ directory to your custom theme. See also **Enable Basic Templatesupport**.

### Enable Basic Templatesupport
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

## Error handling

In case of any errors turn on the debug mode in the PAYMILL module settings.
Open the javascript console in your browser and check the debug messages during the checkout process.

## Logging

You can access the logging within your administration backend under **PAYMILL > PAYMILL log**

## Notes about the payment process

The payment is processed when an order is placed in the shop frontend.

Fast Checkout: Fast checkout can be enabled by selecting the option in the PAYMILL Basic Settings. If any customer completes a purchase while the option is active this customer will not be asked for data again. Instead a reference to the customer data will be saved allowing comfort during checkout.

## Notes about direct debit (ELV) Prenotification
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
```php
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