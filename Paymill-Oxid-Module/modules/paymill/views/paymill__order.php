<?php

class paymill__order extends paymill__order_parent
{

    /**
     * @overload
     */
    protected function paymillPayment()
    {


        // build amount
        $amount = oxSession::getInstance()->getBasket()->getPrice()->getBruttoPrice();
        $amount = round($amount * 100);

        // build name
        $basket = $this->getBasket();
        $user = $basket->getBasketUser();
        $name = $user->oxuser__oxlname . ', ' . $user->oxuser__oxfname;

        // seems unnecessary but for v3,v4 etc. this should sty here
        $paymillLibraryVersion = oxConfig::getInstance()->getShopConfVar('paymill_lib_version');
        if ($paymillLibraryVersion == "v2") {
            $libBase = getShopBasePath() . 'modules/paymill/lib/v2/lib/';
            $libVersion = 'v2';
        } else {
            // FALLBACK
            $libBase = getShopBasePath() . 'modules/paymill/lib/v2/lib/';
            $libVersion = 'v2';
        }
        if (oxSession::getVar('paymill_cc_transaction_token')) {
            $token = oxSession::getVar('paymill_cc_transaction_token');
            $type = 'creditcard';
        } else if (oxSession::getVar('paymill_elv_transaction_token')) {
            $token = oxSession::getVar('paymill_elv_transaction_token');
            $type = 'debit';
        } else {
            $this->getSession()->setVar("paymill_error", "No transaction code was provided");
            return false;
        }
        // process the payment
        $result = $this->processPayment(array(
            'libVersion' => oxConfig::getInstance()->getShopConfVar('paymill_lib_version'),
            'token' => $token,
            'type' => $type,
            'amount' => $amount,
            'currency' => strtoupper($basket->getBasketCurrency()->name),
            'name' => $name,
            'email' => $user->oxuser__oxusername,
            'description' => 'Order ' . $basket->getOrderId() . '; ' . $name,
            'libBase' => $libBase,
            'privateKey' => oxConfig::getInstance()->getShopConfVar('paymill_private_key'),
            'apiUrl' => oxConfig::getInstance()->getShopConfVar('paymill_api_url'),
            'loggerCallback' => array('paymill__order', 'logAction')
                ));
        return $result === true;
    }

    /**
     * @overload
     */
    public function execute()
    {
        if (in_array($this->getBasket()->getPaymentId(), array("paymill_credit_card", "paymill_elv"))) {
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
                    if (!$this->paymillPayment()) {
                        $this->getSession()->setVar("paymill_error", "Payment could not be processed");
                        return 'payment';
                    }
                    // finalizing ordering process (validating, storing order into DB, executing payment, setting status ...)
                    $iSuccess = $oOrder->finalizeOrder($oBasket, $oUser);

                    // performing special actions after user finishes order (assignment to special user groups)
                    $oUser->onOrderExecute($oBasket, $iSuccess);

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
     * Processes the payment against the paymill API
     * @param $params array The settings array
     * @return boolean
     */
    private function processPayment($params)
    {

        // setup the logger
        $logger = $params['loggerCallback'];

        // setup client params
        $clientParams = array(
            'email' => $params['email'],
            'description' => $params['name']
        );

        // setup credit card params
        $paymentParams = array(
            'token' => $params['token']
        );

        if ($params['type'] == 'debit') {
            $paymentParams['type'] = 'debit';
        }

        // setup transaction params
        $transactionParams = array(
            'amount' => $params['amount'],
            'currency' => $params['currency'],
            'description' => $params['description']
        );

        require_once $params['libBase'] . 'Services/Paymill/Transactions.php';
        require_once $params['libBase'] . 'Services/Paymill/Clients.php';
        require_once $params['libBase'] . 'Services/Paymill/Payments.php';

        $clientsObject = new Services_Paymill_Clients(
                        $params['privateKey'], $params['apiUrl']
        );
        $transactionsObject = new Services_Paymill_Transactions(
                        $params['privateKey'], $params['apiUrl']
        );
        $paymentsObject = new Services_Paymill_Payments(
                        $params['privateKey'], $params['apiUrl']
        );

        // perform conection to the Paymill API and trigger the payment
        try {

            $client = $clientsObject->create($clientParams);
            if (!isset($client['id'])) {
                call_user_func_array($logger, array("No client created" . var_export($client, true)));
                return false;
            } else {
                call_user_func_array($logger, array("Client created: " . $client['id']));
            }

            // create card
            $paymentParams['client'] = $client['id'];
            $payment = $paymentsObject->create($paymentParams);
            if (!isset($payment['id'])) {
                call_user_func_array($logger, array("No payment (credit card) created: " . var_export($payment, true) . " with params " . var_export($paymentParams, true)));
                return false;
            } else {
                call_user_func_array($logger, array("Payment (credit card) created: " . $payment['id']));
            }

            // create transaction
            $transactionParams['payment'] = $payment['id'];
            $transaction = $transactionsObject->create($transactionParams);
            if(isset($transaction['data']['response_code'])){
                call_user_func_array($logger, array("An Error occured: " . var_export($transaction, true)));
                return false;
            }

            if (!isset($transaction['id'])) {
                call_user_func_array($logger, array("No transaction created" . var_export($transaction, true)));
                return false;
            } else {
                call_user_func_array($logger, array("Transaction created: " . $transaction['id']));
            }

            // check result
            if (is_array($transaction) && array_key_exists('status', $transaction)) {
                if ($transaction['status'] == "closed") {
                    // transaction was successfully issued
                    return true;
                } elseif ($transaction['status'] == "open") {
                    // transaction was issued but status is open for any reason
                    call_user_func_array($logger, array("Status is open."));
                    return false;
                } else {
                    // another error occured
                    call_user_func_array($logger, array("Unknown error." . var_export($transaction, true)));
                    return false;
                }
            } else {
                // another error occured
                call_user_func_array($logger, array("Transaction could not be issued."));
                return false;
            }
        } catch (Services_Paymill_Exception $ex) {
            // paymill wrapper threw an exception
            call_user_func_array($logger, array("Exception thrown from paymill wrapper: " . $ex->getMessage()));
            return false;
        }

        return true;
    }

    public static function logAction($message)
    {
        $logfile = dirname(dirname(__FILE__)) . '/log.txt';
        if (oxConfig::getInstance()->getShopConfVar('paymill_private_key') == "1" && is_writable($logfile)) {
            $handle = fopen($logfile, 'a');
            fwrite($handle, "[" . date(DATE_RFC822) . "] " . $message . "\n");
            fclose($handle);
        }
    }

}