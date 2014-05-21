<?php

class paymill_oxemail extends paymill_oxemail_parent
{

    /**
     * [_addUserInfoOrderEMail description]
     * @param [type] $oOrder [description]
     */
    protected function _addUserInfoOrderEMail($oOrder)
    {
        $isPaymillElv = false;
        $date = null;

        if ($oOrder->oxorder__oxpaymenttype->rawValue == "paymill_elv") {
            $oLang = oxLang::getInstance();
            $iLang = $oLang->getTplLanguage();

            $isPaymillElv = true;
            $myConfig = $this->getConfig();
            $daysUntilWithdraw = $myConfig->getConfigParam('PAYMILL_PRENOTIFICATION');
            $orderDate = $oOrder->oxorder__oxorderdate->value;
            $dateTime = new DateTime($orderDate);
            $dateTime->modify('+' . $daysUntilWithdraw . ' day');
            $dateFormat = $oLang->translateString('PAYMILL_DATE_FORMAT', $iLang);
            $date = $dateTime->format($dateFormat);
        }

        $this->setViewData('paymillIsPaymillElv', $isPaymillElv);
        $this->setViewData('paymillDaysUntilWithdraw', $date);

        return parent::_addUserInfoOrderEMail($oOrder);
    }

}