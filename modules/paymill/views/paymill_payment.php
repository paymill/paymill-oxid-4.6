<?php

class paymill_payment extends paymill_payment_parent
{

    /**
     * Rewrite of oxid's getPaymentList method
     * adds some errors to the payment selection if necessary
     *
     * @return array
     */
    public function render()
    {
        $fastCheckout = oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_FASTCHECKOUT');
        $publicKey = trim(oxConfig::getInstance()->getShopConfVar('PAYMILL_PUBLICKEY'));

        //clear values
        oxSession::deleteVar('paymillShowForm_cc');
        oxSession::deleteVar('paymillShowForm_elv');

        if ($this->getSession()->hasVar('paymill_error')) {
            $this->addTplParam('piPaymillError', $this->getSession()->getVar('paymill_error'));
            $this->getSession()->deleteVar('paymill_error');
        }

        $fastcheckout_cc = true;
        $fastcheckout_elv = true;
        if ($fastCheckout && $this->getUser()) {
            $userId = oxDb::getDb(oxDb::FETCH_MODE_ASSOC)->quote($this->getUser()->getId());
            $sql = "SELECT * FROM `paymill_fastcheckout` WHERE `userID`=$userId";
            $fastcheckoutData = oxDb::getDb(oxDB::FETCH_MODE_ASSOC)->Execute($sql);

            $fastcheckout_cc = $fastcheckoutData->fields['paymentID_CC'] == null;
            $fastcheckout_elv = $fastcheckoutData->fields['paymentID_ELV'] == null;

            oxSession::setVar('paymillShowForm_cc', $fastcheckout_cc);
            oxSession::setVar('paymillShowForm_elv', $fastcheckout_elv);
        }
        $this->addTplParam('paymillShowForm_cc', $fastcheckout_cc);
        $this->addTplParam('paymillShowForm_elv', $fastcheckout_elv);
        $this->addTplParam('paymillPublicKey', $publicKey);
        return parent::render();
    }

    public function getPaymentList()
    {
        //clear values
        oxSession::deleteVar('paymill_authorized_amount');

        //save authorized Amount for secure Paymentprocessing
        $amount = oxSession::getInstance()->getBasket()->getPrice()->getBruttoPrice();
        $amount = round($amount * 100);
        oxSession::setVar('paymill_authorized_amount', $amount);
        $this->addTplParam('paymillAmount', $amount);

        return parent::getPaymentList();
    }



    /**
     * @overload
     */
    public function validatePayment()
    {
        // payment selected by user
        $paymentId = oxConfig::getParameter('paymentid');
        oxSession::deleteVar('paymill_token');
        oxSession::deleteVar('paymill_payment');
        // handle paymill payment
        if ($paymentId == "paymill_cc" || $paymentId == "paymill_elv") {
            // set paymill token to session to be available in next step
            $paymill_token = isset($_POST['paymillToken']) ? $_POST['paymillToken'] : 'dummyToken';

            oxSession::setVar('paymill_payment', $paymentId == "paymill_cc" ? 'cc' : 'elv');
            oxSession::setVar('paymill_token', $paymill_token);
        }
        return parent::validatePayment();
    }

}
