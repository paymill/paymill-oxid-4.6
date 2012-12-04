Paymill-Oxid
====================

Paymill extension (credit card and direct debit) for Oxid (Version 4.6.x). Tested on Community Edition. Supports Azure template.

![Paymill creditcard payment form](https://raw.github.com/Paymill/Paymill-Oxid/master/Paymill-Oxid-Module/modules/paymill/paymill_form_de.png)

# Installation

## Installation from this git repository 

Use the following command to clone the complete repository including the submodules:
    
    git clone --recursive https://github.com/Paymill/Paymill-Oxid.git

Afterwards merge the contents of the Paymill-Oxid-Module directory with your Oxid installation. 

# Configuration

- Clean your cache and refresh your administration backend.
- In the main menu goto **Erweiterungen -> Module**
- Select module "Paymill" and choose **Aktivieren**
- Reload the admin page
- In the main menu goto **Paymill -> Konfiguration** 
- Enter your Paymill Test- or Livekeys and click on **Speichern**
- Click on **Installiere Tpl-Blöcke** and on **Zahlungsart installieren**
- The field **Paymill API URL** should contain https://api.paymill.de/v2/
- The field **Paymill Bridge URL** should contain https://bridge.paymill.de/

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

# Support for other templates than Azure

Adapt the template structure within the out/azure diretory to your custom theme.

# Error handling

In case of any errors turn on the debug mode in the Paymill payment method configuration. Open the javascript console in your browser and check what's being logged during the checkout process. Additionally you can check the logfile in modules/paymill/log.txt.

# Notes about the payment process

The payment is processed when an order is placed in the shop frontend.