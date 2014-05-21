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
        $this->addTplParam('paymillIsPrenotificationSet', $this->isPrenotificationSet());
        $this->addTplParam('paymillPublicKey', $this->publicKey);
        $this->addTplParam('paymillAreTplBlocksSet', $this->areBlocksSet());
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

    private function isPrenotificationSet()
    {
        $result = (int) $this->getConfig()->getConfigParam('PAYMILL_PRENOTIFICATION');

        $isSet = is_int($result) && $result > 0;

        return $isSet;
    }

    /**
     * Are email blocks set in oxtplblocks table
     * @return bool
     */
    private function areBlocksSet()
    {
        $emailHtml = $this->queryForBlock('email_html_order_cust_paymentinfo');
        $emailPlain = $this->queryForBlock(
            'email_plain_order_cust_paymentinfo'
        );
        return $emailHtml && $emailPlain;
    }

    /**
     * Db query for oxBlockname specified, returns true if block in table
     * oxtplblocks present
     * @param  string $oxBlockname
     * @return bool
     */
    private function queryForBlock($oxBlockname)
    {
        $shopId   = $this->getConfig()->getShopId();
        $db = oxDb::getDb();
        $result = $db->getOne(
            "SELECT 1 FROM oxtplblocks"
            . " WHERE oxmodule = 'paymill'"
            . " AND oxshopid = " . $db->quote($shopId)
            . " AND oxblockname = " . $db->quote($oxBlockname)
            . " LIMIT 1"
        );

        return (bool) $result;
    }

    /**
     * Update new PAYMILL blocks if missing
     */
    public function updateBlocks()
    {
        if (!$this->queryForBlock('email_html_order_cust_paymentinfo')) {
            $this->insertBlock(
                'email_html_order_cust_paymentinfo',
                'email/html/order_cust.tpl',
                'paymill_html_order_cust.tpl'
            );
        }

        if (!$this->queryForBlock('email_plain_order_cust_paymentinfo')) {
            $this->insertBlock(
                'email_plain_order_cust_paymentinfo',
                'email/plain/order_cust.tpl',
                'paymill_plain_order_cust.tpl'
            );
        }
    }

    /**
     * Insert entry for PAYMILL to oxtplblocks table
     * @param  string $oxBlockname
     * @param  string $oxTemplate
     * @param  string $oxFile
     */
    private function insertBlock($oxBlockname, $oxTemplate, $oxFile)
    {
        $db = oxDb::getDb();
        $shopId = $this->getConfig()->getShopId();
        $oxId = oxUtilsObject::getInstance()->generateUId();
        $sql = "INSERT INTO `oxtplblocks` (
                    `OXID`, `OXACTIVE`, `OXSHOPID`, `OXTEMPLATE`,
                    `OXBLOCKNAME`, `OXPOS`, `OXFILE`, `OXMODULE`
                ) VALUES (
                    " . $db->quote($oxId) . ",
                    1,
                    " . $db->quote($shopId) . ",
                    " . $db->quote($oxTemplate) . ",
                    " . $db->quote($oxBlockname) . ",
                    '1',
                    ".$db->quote($oxFile).", 'paymill'
                )
        ";

        // @TODO add exception handling
        $db->execute($sql);
    }

}
