# Paymill module for OXID eShop 4

Paymill extension for Oxid (Version 4.6.x). Tested on Community Edition. Supports Azure template.

# Installation

- Merge the content of the copy_this directory with your Oxid installation. 
- Clean your cache and refresh your administration backend.
- In the main menu goto **Erweiterungen -> Module**
- Select module "Paymill" and choose **Aktivieren**
- Reload the admin page
- In the main menu goto **Paymill -> Konfiguration** 
- Enter your Paymill Test- or Livekeys and click on **Speichern**
- Click on **Installiere Tpl-Blöcke** and on **Zahlungsart installieren**

# Activate Paymill Payment

After installation you have a new payment method **Kreditkartenzahlung**. To activate Paymill payment follow these steps:

- In the main menu goto **Shopeinstellungen > Zahlungsarten**
- Choose **Kreditkartenzahlung**
- Click on **Benutzergruppen zuordnen** and assign the right user groups
- Go to tab **Länder**, click on **Länder zuordnen**, and assign the right countries
- In the main menu goto **Shopeinstellungen > Versandarten**
- Choose a shipping type (e.g. **Standard**) and go to tab **Zahlungsarten** 
- Click on **Zahlungsarten zuordnen** and assign **Kreditkartenzahlung**
- Repeat last 2 steps for other shipping types

# Support for other templates than Azure

Adapt the template structure within the out/azure diretory to your custom theme. 