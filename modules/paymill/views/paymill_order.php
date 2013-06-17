<?php

class paymill_order extends paymill_order_parent
{

    /**
     * @overload
     */
    public function execute()
    {
        if (in_array($this->getBasket()->getPaymentId(), array("paymill_cc", "paymill_elv"))) {
            if (!$this->getSession()->checkSessionChallenge()) {
                return;
            }

            $myConfig = $this->getConfig();

            if (!oxConfig::getParameter('ord_agb') && $myConfig->getConfigParam('blConfirmAGB')) {
                $this->_blConfirmAGBError = 1;
                return;
            }

            // for compatibility reasons for a while. will be removed in future
            if (oxConfig::getParameter('ord_custinfo') !== null && !oxConfig::getParameter('ord_custinfo') && $this->isConfirmCustInfoActive()) {
                $this->_blConfirmCustInfoError = 1;
                return;
            }

            // additional check if we really really have a user now
            if (!$oUser = $this->getUser()) {
                return 'user';
            }

            // get basket contents
            $oBasket = $this->getSession()->getBasket();
            if ($oBasket->getProductsCount()) {

                try {
                    $oOrder = oxNew('oxorder');

                    // finalizing ordering process (validating, storing order into DB, executing payment, setting status ...)
                    $iSuccess = $oOrder->finalizeOrder($oBasket, $oUser);

                    if (!$this->paymillPayment()) {
                        if (!$this->getSession()->hasVar("paymill_error")) {
                            $this->getSession()->setVar("paymill_error", "Payment could not be processed.");
                        }
                        $oOrder->delete();
                        return 'payment';
                    }

                    $oOrder->oxorder__oxpaid->value = (string) date('Y-m-d H:i:s');
                    $oOrder->save();

                    // performing special actions after user finishes order (assignment to special user groups)
                    $oUser->onOrderExecute($oBasket, $iSuccess);

                    //clear values
                    oxSession::deleteVar('paymillShowForm_cc');
                    oxSession::deleteVar('paymillShowForm_elv');
                    oxSession::deleteVar('paymill_authorized_amount');

                    // proceeding to next view
                    return $this->_getNextStep($iSuccess);
                } catch (oxOutOfStockException $oEx) {
                    oxUtilsView::getInstance()->addErrorToDisplay($oEx, false, true, 'basket');
                } catch (oxNoArticleException $oEx) {
                    oxUtilsView::getInstance()->addErrorToDisplay($oEx);
                } catch (oxArticleInputException $oEx) {
                    oxUtilsView::getInstance()->addErrorToDisplay($oEx);
                }
            }
        } else {
            return parent::execute();
        }
    }

    /**
     * @overload
     */
    protected function paymillPayment()
    {
        $privateKey = trim(oxConfig::getInstance()->getShopConfVar('PAYMILL_PRIVATEKEY'));
        $fastCheckout = oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_FASTCHECKOUT');
        $apiUrl = "https://api.paymill.com/v2/";

        $basket = $this->getBasket();
        $user = $basket->getBasketUser();

        $paymillShowForm_cc = oxSession::getVar('paymillShowForm_cc');
        $paymillShowForm_elv = oxSession::getVar('paymillShowForm_elv');
        $userId = oxDb::getDb(oxDb::FETCH_MODE_ASSOC)->quote($this->getUser()->getId());

        $amount = oxSession::getInstance()->getBasket()->getPrice()->getBruttoPrice();
        $amount = round($amount * 100);
        $name = $user->oxuser__oxlname . ', ' . $user->oxuser__oxfname;

        if (oxSession::getVar('paymill_token') != null) {
            $token = oxSession::getVar('paymill_token');
            $paymentType = oxSession::getVar('paymill_payment');
        } else {
            $this->getSession()->setVar("paymill_error", "No Token was provided");
            return false;
        }

        $parameter = array(
            'token' => $token,
            'amount' => (int) $amount,
            'authorizedAmount' => (int) oxSession::getVar('paymill_authorized_amount'),
            'currency' => strtoupper($basket->getBasketCurrency()->name),
            'name' => $name,
            'email' => $user->oxuser__oxusername->rawValue,
            'description' => 'OrderID: ' . $basket->getOrderId() . ' - ' . $name
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
