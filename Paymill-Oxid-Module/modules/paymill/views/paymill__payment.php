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

        oxSession::setVar('paymill_cc_transaction_token', '');
        oxSession::setVar('paymill_elv_transaction_token', '');
        
        // handle paymill payment
        if ($paymentId == "paymill_credit_card") {
            // set paymill token to session to be available in next step
            $paymill_cc_transaction_token = $_POST['paymill_cc_transaction_token'];
            oxSession::setVar('paymill_cc_transaction_token', $paymill_cc_transaction_token);
        } else if ($paymentId == "paymill_elv")  {
           // set paymill token to session to be available in next step
            $paymill_elv_transaction_token = $_POST['paymill_elv_transaction_token'];
            oxSession::setVar('paymill_elv_transaction_token', $paymill_elv_transaction_token);
        }

        return $parentResult;
    }
}
?>