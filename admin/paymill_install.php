<?php

class paymill_install extends oxAdminView
{

    private $oxPayment;
    private $privateKey;
    private $publicKey;

    public function __construct()
    {
        parent::__construct();
        $this->oxPayment = oxNew("oxpayment");
        $this->privateKey = $this->getConfig()->getConfigParam('PAYMILL_PRIVATEKEY');
        $this->publicKey = $this->getConfig()->getConfigParam('PAYMILL_PUBLICKEY');
    }

    public function render()
    {
        $this->assignStatusToTemplate();
        parent::render();
        return 'paymill_install.tpl';
    }

    public function installDatabase()
    {
        oxDb::getDb()->Execute(
            "CREATE TABLE IF NOT EXISTS `paymill_fastcheckout` ( " .
            "`oxid` varchar(100) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL, " .
            "`clientID` varchar(100) NOT NULL, " .
            "`paymentID_CC` varchar(100) DEFAULT NULL, " .
            "`paymentID_ELV` varchar(100) DEFAULT NULL, " .
            "PRIMARY KEY (`oxid`) " .
            "); "
        );
        oxDb::getDb()->Execute(
            "CREATE TABLE IF NOT EXISTS `paymill_logging` ( " .
            "`oxid` varchar(100) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL, " .
            "`identifier` text NOT NULL, " .
            "`debug` text NOT NULL, " .
            "`message` text NOT NULL, " .
            "`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, " .
            "PRIMARY KEY (`oxid`) " .
            ");"
        );
        oxDb::getDb()->Execute(
            "ALTER TABLE  `paymill_fastcheckout` " .
            "CHANGE  `userID` `oxid` VARCHAR( 100 ) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL;"
        );
    }

    public function installPayments()
    {
        oxDb::getDb()->Execute(
            "INSERT INTO oxpayments " .
            "(OXID, OXACTIVE, OXDESC, OXADDSUM, OXADDSUMTYPE, OXFROMBONI, OXFROMAMOUNT, OXTOAMOUNT, OXVALDESC, OXCHECKED, OXDESC_1, OXVALDESC_1, OXDESC_2, OXVALDESC_2, OXDESC_3, OXVALDESC_3, OXLONGDESC, OXLONGDESC_1, OXLONGDESC_2, OXLONGDESC_3, OXSORT, OXTSPAYMENTID) " .
            "VALUES " .
            "('paymill_cc', 1, 'Kreditkartenzahlung', 0, 'abs', 0, 0, 99999, '', 1, 'Credit Card', '', '', '', '', '', '', '', '', '', 0, ''), " .
            "('paymill_elv', 1, 'ELV', 0, 'abs', 0, 0, 99999, '', 1, 'Direct Debit', '', '', '', '', '', '', '', '', '', 0, ''); "
        );
    }

    private function assignStatusToTemplate()
    {
        $this->addTplParam('paymillIsDatabaseInstalled', $this->isDatabaseInstalled());
        $this->addTplParam('paymillIsModulActive', $this->isModulActive());
        $this->addTplParam('paymillIsPrivateKeyValid', $this->isPrivateKeyValid());
        $this->addTplParam('paymillIsPaymentInstalled', $this->isPaymentInstalled());
        $this->addTplParam('paymillIsPaymentConfigured', $this->isPaymentConfigured());
        $this->addTplParam('paymillIsShippingConfigured', $this->isShippingConfigured());
        $this->addTplParam('paymillPublicKey', $this->publicKey);
    }

    private function isDatabaseInstalled()
    {
        $fastCheckout = oxDb::getDb(oxDB::FETCH_MODE_ASSOC)->getRow('CHECK TABLE `paymill_fastcheckout`');
        $logging = oxDb::getDb(oxDB::FETCH_MODE_ASSOC)->getRow('CHECK TABLE `paymill_logging`');
        return $fastCheckout['Msg_text'] === "OK" && $logging['Msg_text'] === "OK";
    }

    private function isModulActive()
    {
        $result = oxDb::getDb()->select(
            'SELECT OXACTIVE FROM oxtplblocks ' .
            'WHERE OXFILE IN("paymill_select_payment.tpl", "paymill_select_header.tpl") ' .
            'AND OXMODULE = "paymill" ' .
            'AND OXACTIVE = "1";'
        );
        return $result->recordCount() > 0;
    }

    private function isPrivateKeyValid()
    {
        $result = false;
        if (strlen($this->privateKey) > 0) {
            $clientObject = oxNew('Services_Paymill_Clients', trim($this->privateKey), paymill_util::API_ENDPOINT);
            $result = !array_key_exists('error', $clientObject->get());
        }
        return $result;
    }

    private function isPaymentInstalled()
    {
        $this->oxPayment->load('paymill_cc');
        $isCCInstalled = !is_null($this->oxPayment->oxpayments__oxid->value);

        $this->oxPayment->load('paymill_elv');
        $isELVInstalled = !is_null($this->oxPayment->oxpayments__oxid->value);
        return $isCCInstalled && $isELVInstalled;
    }

    private function isPaymentConfigured()
    {
        if (!$this->isPaymentInstalled()) {
            return false;
        }
        $this->oxPayment->load('paymill_cc');
        $isCCInstalled = !is_null($this->oxPayment->getGroups()) && $this->oxPayment->getGroups()->count() > 0;

        $this->oxPayment->load('paymill_elv');
        $isELVInstalled = !is_null($this->oxPayment->getGroups()) && $this->oxPayment->getGroups()->count() > 0;
        return $isCCInstalled && $isELVInstalled;
    }

    private function isShippingConfigured()
    {
        $result = oxDb::getDb()->select(
            'SELECT oxobjectid FROM oxobject2payment WHERE oxpaymentid IN("paymill_cc", "paymill_elv") AND oxtype = "oxdelset"'
        );
        return $result->recordCount() > 0;
    }

}
