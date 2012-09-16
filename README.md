Paymill-Magento
====================

Paymill extension for Oxid (Version 4.6.x). Tested on Community Edition. Supports Azure template.

# Installation

Merge the content of the copy_this directory with your Oxid installation. Clean your cache and refresh your administration backend. In the main menu click on **Paymill > Konfiguration** and insert your Paymill Test- or Livekeys. Afterwards click on **Speichern**, then on **Installiere Tpl-Blöcke** and finally on **Zahlungsart installieren**. You will then have a new payment method **Kreditkartenzahlung** under **Shopeinstellungen > Zahlungsarten**. 

To activate that payment method you may need to assign user groups, countries and shipping methods.

Additionally go to **Extensions > Modules** and activate the Paymill Module.

# Support for other templates than Azure

Adapt the template structure within the out/azure diretory to your custom theme. 