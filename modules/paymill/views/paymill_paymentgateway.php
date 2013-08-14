<?php

/**
 * paymill_paymentgateway
 *
 * @author     Copyright (c) 2013 PayIntelligent GmbH (http://www.payintelligent.de)
 * @copyright  Copyright (c) 2013 Paymill GmbH (https://www.paymill.com)
 */
class paymill_paymentgateway extends paymill_paymentgateway_parent implements Services_Paymill_LoggingInterface
{

    /**
     * @overload
     */
    public function executePayment($dAmount, & $oOrder)
    {
        $this->_iLastErrorNo = null;
        $this->_sLastError = null;

        if (!in_array($oOrder->oxorder__oxpaymenttype->rawValue, array("paymill_cc", "paymill_elv"))) {
            return parent::executePayment($dAmount, & $oOrder);
        }

        $privateKey = trim(oxConfig::getInstance()->getShopConfVar('PAYMILL_PRIVATEKEY'));
        $fastCheckout = oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_FASTCHECKOUT');
        $apiUrl = "https://api.paymill.com/v2/";

        $paymillShowForm_cc = oxSession::getVar('paymillShowForm_cc');
        $paymillShowForm_elv = oxSession::getVar('paymillShowForm_elv');
        $userId = $oOrder->oxorder__oxuserid->rawValue;

        $amount = round($dAmount * 100);
        $name = $oOrder->oxorder__oxbilllname->value . ', ' . $oOrder->oxorder__oxbillfname->value;
        $utf8Name = $this->convertToUtf($name, oxConfig::getInstance()->isUtf());
        if (oxSession::getVar('paymill_token') != null) {
            $token = oxSession::getVar('paymill_token');
            $paymentType = oxSession::getVar('paymill_payment');
        } else {
            $oOrder->getSession()->setVar("paymill_error", "No Token was provided");
            return false;
        }

        $shopversion = oxConfig::getInstance()->getVersion();
        $modul = oxNew('oxModule');
        $modul->load('paymill');

        $parameter = array(
            'token' => $token,
            'amount' => (int) $amount,
            'currency' => strtoupper($oOrder->oxorder__oxcurrency->rawValue),
            'name' => $utf8Name,
            'email' => $oOrder->oxorder__oxbillemail->value,
            'description' => 'OrderID: ' . $oOrder->oxorder__oxid . ' - ' . $utf8Name
        );
        $paymentProcessor = new Services_Paymill_PaymentProcessor($privateKey, $apiUrl, null, $parameter, $this);
        $paymentProcessor->setSource($modul->getInfo('version') . '_oxid_' . $shopversion);
        if ($paymentType == 'cc') {
            $paymentProcessor->setPreAuthAmount((int) oxSession::getVar('paymill_authorized_amount'));
        }

        $fastcheckoutData = oxNew('paymill_fastcheckout');
        if ($fastCheckout == "1") {
            // Be sure Data is aviable
            $fastcheckoutData->load($this->getUser()->getId());
            $fastdata_cc = $fastcheckoutData->paymill_fastcheckout__paymentid_cc->rawValue;
            $fastdata_elv = $fastcheckoutData->paymill_fastcheckout__paymentid_elv->rawValue;
            $fastdata_client = $fastcheckoutData->paymill_fastcheckout__clientid->rawValue;
            if (!$paymillShowForm_cc && $paymentType == "cc" || !$paymillShowForm_elv && $paymentType == "elv") {
                $paymentProcessor->setPaymentId($paymentType == "cc" ? $fastdata_cc : $fastdata_elv);
            }
            if (!$paymillShowForm_cc || !$paymillShowForm_elv) {
                $paymentProcessor->setClientId($fastdata_client);
            }
        }

        $result = $paymentProcessor->processPayment();
        $this->log($result ? 'Payment results in success' : 'Payment results in failure', null);
        if ($fastCheckout == "1" && $result === true) {
            $paymentColumn = $paymentType == "cc" ? 'paymentID_CC' : 'paymentID_ELV';
            if (!$paymillShowForm_cc || !$paymillShowForm_elv) {
                //update existing data
                $newPaymentId = $paymentType == "cc" ? $fastdata_cc : $fastdata_elv;
                if ($newPaymentId == null) {
                    $newPaymentId = $paymentProcessor->getPaymentId();
                }
                $fastcheckoutData->assign(array(
                    'oxid' => $userId,
                    $paymentColumn => $newPaymentId
                ));
                $fastcheckoutData->save();
            } else {
                //insert new data
                $fastcheckoutData->assign(array(
                    'oxid' => $userId,
                    'clientid' => $paymentProcessor->getClientId(),
                    $paymentColumn => $paymentProcessor->getPaymentId()
                ));
                $fastcheckoutData->save();
            }
        }

        return $result === true;
    }

    /**
     * log the gien message
     *
     * @param string $message
     * @param string $debuginfo
     */
    public function log($message, $debuginfo)
    {
        $logfile = dirname(dirname(__FILE__)) . '/log.txt';
        if (oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_LOGGING') == "1") {
            $handle = fopen($logfile, 'a+');
            fwrite($handle, "[" . date(DATE_RFC822) . "] " . $message . "\n");
            fclose($handle);
        }
    }

    public function convertToUtf($value, $utfMode)
    {
        if (!$utfMode) {
            $value = utf8_encode($value);
        }

        return $value;
    }

}
