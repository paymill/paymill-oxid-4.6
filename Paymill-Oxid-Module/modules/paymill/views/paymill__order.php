<?php

class paymill__order extends paymill__order_parent {

    /**
     * @overload
     */
    protected function _getNextStep($orderState) {

        $order = oxNew('oxorder');
        $order->load(oxSession::getVar('sess_challenge'));

        if (!$order->isLoaded()) { 
            return parent::_getNextStep($orderState);    
        }

        // check if order is paymill order
        if ($order->oxorder__oxpaymenttype->value == "paymill_credit_card") {

            $paymill_transaction_token = oxSession::getVar('paymill_transaction_token');

            $paymillApiEndpoint = 'https://api.paymill.de/v1/';
            $paymillPrivateApiKey = oxConfig::getInstance()->getShopConfVar('paymill_private_key');

            $libPath = getShopBasePath() . 'modules/paymill/lib/';
            require_once($libPath . 'Services/Paymill/Transactions.php');
            require_once($libPath . 'Services/Paymill/Creditcards.php');
            require_once($libPath . 'Services/Paymill/Clients.php');

            // build amount
            $amount = oxSession::getInstance()->getBasket()->getPrice()->getBruttoPrice();
            $amount = number_format($amount, 2, '.', '');
            $amount = $amount * 100;

            // setup client params
            $clientParams = array(
                'email' => $order->oxorder__oxbillemail->value,
                'description' =>  $order->oxorder__oxbillfname->value.' '.$order->oxorder__oxbilllname->value
            );

            // setup credit card params
            $creditcardParams = array(
                'token' => $paymill_transaction_token
            );

            // setup transaction params
            $transactionParams = array(
                'amount' => $amount,
                'currency' => 'eur',
                'description' => 'Order ' . $order->oxorder__oxordernr->value
            );

            // Access objects for the Paymill API
            $clientsObject = new Services_Paymill_Clients(
                $paymillPrivateApiKey, $paymillApiEndpoint
            );
            $creditcardsObject = new Services_Paymill_Creditcards(
                $paymillPrivateApiKey, $paymillApiEndpoint
            );
            $transactionsObject = new Services_Paymill_Transactions(
                $paymillPrivateApiKey, $paymillApiEndpoint
            );

            try {
                // create card
                $creditcard = $creditcardsObject->create($creditcardParams);

                // create client
                $clientParams['creditcard'] = $creditcard['id'];
                $client = $clientsObject->create($clientParams);

                // create transaction
                $transactionParams['client'] = $client['id'];
                $transaction = $transactionsObject->create($transactionParams);

                if (is_array($transaction) && array_key_exists('status', $transaction)) {
                    if ($transaction['status'] == "closed") {
                    } elseif ($transaction['status'] == "open") {
                        throw new Exception("Zahlung fehlgeschlagen.");
                    } else {
                        throw new Exception("Zahlung fehlgeschlagen.");
                    }
                } else {
                    throw new Exception("Zahlung fehlgeschlagen.");
                }
            } catch (Exception $ex) {
                // handle error
            } 
            return parent::_getNextStep($orderState);  
        } else {
            return parent::_getNextStep($orderState);  
        }
    }  


}
