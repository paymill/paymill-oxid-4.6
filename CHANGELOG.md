## v2.7.0
 * Integration of PayFrame to enable use of SAQ A for easier PCI DSS 3.0 compliance.

## v2.6.0
 * added autocomplete="off" for input fields, browser shall not save sensitive data like credit card number and card verification value
 * changed CVV input field type from "text" to "password"
 * ui change: added support for payment long description (configurable in the OXID backend payment methods settings)
 * ui change: credit card form - valid until months are shown in a new format instead of just having the name of the month it also shows the number, e.g. "1 - January"
 * ui change: hover tooltip for CVV input field (azure theme only)
 * max length of transaction description set to 128 characters
 * added: order number will be updated to the transaction after successful execution of order

## v2.5.0
 * united SEPA and regular ELV forms
 * added backend option to show credit card logos in frontend
 * added prenotification in order mail for direct debit (see Readme.md "Notes about direct debit (ELV) Prenotification" regarding invoice pdf)
 * added check for block entries in oxtplblocks
 * fixed exception in install with alter table sql

## v2.4.0
 * added iban validation
 * added creditcard predetection and improved validation
 * added multilang support

## v2.3.0
 * webhook support
 * translate bridge errors
 * elv sepa support

## v2.2.0
 * maestro handling
 * better logging view
 * better error messages
 * add validateHolder() for card holder validation
 * fastcheckout add possibility to change the payment data
 * reuse clients and update them if email address has changed
 * dynamic credit card icons

## v2.1.3
 * mark complete orders as paid

## v2.1.2
 * now using unique id's instead of classes for as js selector

## v2.1.1
 * support specialchars in names

## v2.1.0
 * improve payment workflow
 * update readme
 * update install.sql
 * update update.sql

## v2.0.0
 * update php wrapper
 * edit api endpoints
 * fix user logout bug
 * adjust admin menu traslation