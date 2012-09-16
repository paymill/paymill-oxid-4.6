<?php

class paymill__payment extends paymill__payment_parent {
    
    /**
     * @overload
     */
    public function validatePayment()
    {
        // payment selected by user
        $paymentId = oxConfig::getParameter('paymentid');
        $parentResult = parent::validatePayment();

        // handle paymill payment
        if ($paymentId == "paymill_credit_card") {
            // set paymill token to session to be available in next step
            $paymill_transaction_token = $_POST['paymill_transaction_token'];
            oxSession::setVar('paymill_transaction_token', $paymill_transaction_token);
            
        } else {
           
        }
        return $parentResult;
    }
}
