<?php

class paymill_paymentgateway extends paymill_paymentgateway_parent
{

    /**
     * @overload
     */
    public function executePayment( $dAmount, & $oOrder)
    {
        $this->_iLastErrorNo = null;
        $this->_sLastError = null;

        if(!in_array($oOrder->oxorder__oxpaymenttype->rawValue, array("paymill_cc", "paymill_elv"))){
            return parent::executePayment($dAmount, & $oOrder);
        }

        $privateKey = trim(oxConfig::getInstance()->getShopConfVar('PAYMILL_PRIVATEKEY'));
        $fastCheckout = oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_FASTCHECKOUT');
        $apiUrl = "https://api.paymill.com/v2/";

        $paymillShowForm_cc = oxSession::getVar('paymillShowForm_cc');
        $paymillShowForm_elv = oxSession::getVar('paymillShowForm_elv');
        $userId = oxDb::getDb(oxDb::FETCH_MODE_ASSOC)->quote($oOrder->oxorder__oxuserid->rawValue);

        $amount = round($dAmount * 100);
        $name = $oOrder->oxorder__oxbilllname->value . ', ' . $oOrder->oxorder__oxbillfname->value;

        if (oxSession::getVar('paymill_token') != null) {
            $token = oxSession::getVar('paymill_token');
            $paymentType = oxSession::getVar('paymill_payment');
        } else {
            $oOrder->getSession()->setVar("paymill_error", "No Token was provided");
            return false;
        }

        $parameter = array(
            'token' => $token,
            'amount' => (int) $amount,
            'authorizedAmount' => (int) oxSession::getVar('paymill_authorized_amount'),
            'currency' => strtoupper($oOrder->oxorder__oxcurrency->rawValue),
            'name' => $name,
            'email' => $oOrder->oxorder__oxbillemail->value,
            'description' => 'OrderID: ' . $oOrder->oxorder__oxid . ' - ' . $name
        );
        $paymentProcessor = new PaymentProcessor($privateKey, $apiUrl, null, $parameter, $this);

        if ($fastCheckout == "1") {
            // Be sure Data is aviable
            $sql = "SELECT * FROM `paymill_fastcheckout` WHERE `userID`=$userId";
            $fastcheckoutData = oxDb::getDb(oxDB::FETCH_MODE_ASSOC)->Execute($sql);
            try {
                oxDb::getDb(oxDB::FETCH_MODE_ASSOC)->Execute($sql);
            } catch (Exception $exception) {
                $this->log($exception->getMessage(), $exception->getLine());
            }
            if (!$paymillShowForm_cc && $paymentType == "cc" || !$paymillShowForm_elv && $paymentType == "elv") {
                $paymentProcessor->setPaymentId($paymentType == "cc" ? $fastcheckoutData->fields['paymentID_CC'] : $fastcheckoutData->fields['paymentID_ELV']);
            }
            if (!$paymillShowForm_cc || !$paymillShowForm_elv) {
                $paymentProcessor->setClientId($fastcheckoutData->fields['clientID']);
            }
        }

        $result = $paymentProcessor->processPayment();
        $this->log($result ? 'Payment results in success' : 'Payment results in failure', null);
        if ($fastCheckout == "1" && $result === true) {
            $paymentColumn = $paymentType == "cc" ? 'paymentID_CC' : 'paymentID_ELV';
            if (!$paymillShowForm_cc || !$paymillShowForm_elv) {
                //update existing data
                $newPaymentId = $paymentType == "cc" ? $fastcheckoutData->fields['paymentID_CC'] : $fastcheckoutData->fields['paymentID_ELV'];
                if ($newPaymentId == null) {
                    $newPaymentId = $paymentProcessor->getPaymentId();
                }
                $newPaymentId = oxDb::getDb(oxDb::FETCH_MODE_ASSOC)->quote($newPaymentId);
                $sql = "UPDATE `paymill_fastcheckout`SET `$paymentColumn`=$newPaymentId WHERE `userID`=$userId";
            } else {
                //insert new data
                $newClientId = oxDb::getDb(oxDb::FETCH_MODE_ASSOC)->quote($paymentProcessor->getClientId());
                $newPaymentId = oxDb::getDb(oxDb::FETCH_MODE_ASSOC)->quote($paymentProcessor->getPaymentId());
                $sql = "INSERT INTO `paymill_fastcheckout` (`userID`, `clientID`, `$paymentColumn`)VALUES ($userId, $newClientId, $newPaymentId)";
            }
            try {
                oxDb::getDb(oxDB::FETCH_MODE_ASSOC)->Execute($sql);
            } catch (Exception $exception) {
                $this->log($exception->getMessage(), $exception->getLine());
            }
        }

        return $result === true;
    }

    public function log($message, $debuginfo)
    {
        $logfile = dirname(dirname(__FILE__)) . '/log.txt';
        if (oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_LOGGING') == "1") {
            $handle = fopen($logfile, 'a+');
            fwrite($handle, "[" . date(DATE_RFC822) . "] " . $message . "\n");
            fclose($handle);
        }
    }

}
