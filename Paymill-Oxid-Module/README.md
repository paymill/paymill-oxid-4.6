Paymill-Oxid 4.6
==================

Payment plugin for Oxid Version 4.6.5

Download the module here: https://github.com/Paymill/Paymill-Oxid/archive/master.zip

- Merge the content of the Paymill-Oxid-Module directory with your Oxid installation.
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

- Basic- & Azure-template are supported by default.
- To support a custom template adapt the template structure within the out/azure diretory to your custom theme.

# Error handling

In case of any errors turn on the debug mode in the Paymill payment method configuration.
Open the javascript console in your browser and check what's being logged during the checkout process.

# Logging

- If you enable logging in the plugin configuration make sure that log.txt inside the plugin directory is writable. Otherwise logging information will not be stored to the logfile.
- You can access the Logging with your shop-backend under Paymill -> Log

# Notes about the payment process

The payment is processed when an order is placed in the shop frontend.