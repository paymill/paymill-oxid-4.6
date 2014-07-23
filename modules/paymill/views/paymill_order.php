<?php

/**
 * paymill_order
 *
 * @author     Copyright (c) 2013 PayIntelligent GmbH (http://www.payintelligent.de)
 * @copyright  Copyright (c) 2013 Paymill GmbH (https://www.paymill.com)
 */
class paymill_order extends paymill_order_parent
{

    /**
     * @see order::execute()
     * Updates the PAYMILL transaction with the order_number which is set in execute
     */
    public function execute()
    {
        $nextStep = parent::execute();
        $logger = oxNew('paymill_logger');

        if (strpos($nextStep,'thankyou') !== false
            && $this->isPaymillPayment()
            && $this->getConfig()->getConfigParam('blStoreOrderNrInFinalize')
        ) {
            $orderId = oxSession::getVar('sess_challenge');
            $transactionId = oxSession::getVar('paymillPgTransId');

            $oOrder = oxNew('oxorder');
            $oOrder->load($orderId);

            $description = $this->createPaymillDescription($oOrder);

            $privateKey = trim(
                $this->getConfig()->getShopConfVar('PAYMILL_PRIVATEKEY')
            );

            $paymillTransactions = oxNew(
                'Services_Paymill_Transactions',
                $privateKey,
                paymill_util::API_ENDPOINT
            );

            $updateResponse = $paymillTransactions->update(
                array(
                    'id' => $transactionId,
                    'description' => $description
                )
            );

            if ($updateResponse['response_code'] === 20000) {
                $logSuccess = 'Successfully updated the description of ';
            } else {
                $logSuccess = 'There was an error updating the description of ';
            }

            $logger->log($logSuccess . $transactionId, $description);
        }

        // proceeding to next view
        return $nextStep;
    }

    /**
     * Was this Order payed for with PAYMILL?
     * @return boolean PAYMILL context?
     */
    private function isPaymillPayment()
    {
        $paymentId = oxSession::getVar('paymentid');
        return in_array($paymentId, array('paymill_cc', 'paymill_elv'));
    }

    /**
     * Create transaction description from order
     * @param  oxOrder $oOrder Order
     * @return String          description
     */
    private function createPaymillDescription(oxOrder $oOrder)
    {
        $orderNumberDesc = 'OrderNumber: ' . $oOrder->oxorder__oxordernr . ' - ';
        $orderIdDesc = 'OrderID: ' . $oOrder->oxorder__oxid . ' - ';

        $utf8Name = $this->convertToUtf(
            $oOrder->oxorder__oxbilllname->value . ', ' . $oOrder->oxorder__oxbillfname->value
        );

        $description = $orderNumberDesc . $orderIdDesc . $utf8Name;
        $description = strlen($description) > 128? substr($description,0,128) : $description;

        return $description;
    }

    /**
     * Convert a string to utf-8
     * @param  string $value
     * @return string
     */
    private function convertToUtf($value)
    {
       $obj = oxNew('paymill_util');
       return $obj->convertToUtf($value);
    }

}