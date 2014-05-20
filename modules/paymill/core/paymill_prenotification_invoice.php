<?php

/**
 * Class paymill_prenotification_invoice
 */
class paymill_prenotification_invoice extends paymill_prenotification_invoice_parent
{

    public function __construct( $oData, $oPdf )
    {
        parent::__construct($oData, $oPdf);
        exit('test');
    }

    /**
     * {@inheritdoc}
     *
     * Adds additional PAYMILL information.
     *
     * @param int &$iStartPos text start position
     */
    protected function _setPaymentMethodInfo(&$iStartPos)
    {
        exit('test');
        $oPayment = oxNew('oxpayment');
        $oPayment->loadInLang($this->_oData->getSelectedLang(), $this->_oData->oxorder__oxpaymenttype->value);
        if ($oPayment->oxpayments__oxid->value == "paymill_elv") {
            $result = (int) $this->getConfig()->getConfigParam('PAYMILL_PRENOTIFICATION');
            $oPayment = oxNew('oxpayment');
            $oPayment->loadInLang($this->_oData->getSelectedLang(), $this->_oData->oxorder__oxpaymenttype->value);

            $text = $this->_oData->translate('PAYMILL_PRENOTIFICATION_TEXT') . " " . $result;
            $this->font('Arial', '', 10);
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;
        } else {
            parent::_setPaymentMethodInfo($iStartPos);
        }
    }

    /**
     * {@inheritdoc}
     *
     * Adds additional PAYMILL information.
     *
     * @param int &$iStartPos text start position
     */
    protected function _setPayUntilInfo(&$iStartPos)
    {
        $oPayment = oxNew('oxpayment');
        $oPayment->loadInLang($this->_oData->getSelectedLang(), $this->_oData->oxorder__oxpaymenttype->value);
        if ($oPayment->oxpayments__oxid->value == "pi_ratepay_rechnung") {
            $settings = oxNew('pi_ratepay_settings');
            $settings->loadByType('invoice');

            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_PAYUNTIL_1');
            $this->text(15, $iStartPos + 4, $text);

            $width = 15 + $this->_oPdf->getStringWidth($text);
            $due = $settings->pi_ratepay_settings__duedate->rawValue;
            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_PAYUNTIL_2');
            $this->text($width, $iStartPos + 4, $due . $text);
            $iStartPos += 4;

            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_PAYTRANSFER');
            $this->text(15, $iStartPos + 8, $text);
            $iStartPos += 8;

            $value = $settings->pi_ratepay_settings__account_holder->rawValue;
            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_ACCOUNTHOLDER') . " $value";
            $this->text(15, $iStartPos + 8, $text);
            $iStartPos += 8;

            $value = $settings->pi_ratepay_settings__bank_name->rawValue;
            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_BANKNAME') . " $value";
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;

            $value = $settings->pi_ratepay_settings__bank_code_number->rawValue;
            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_BANKCODENUMBER') . " $value";
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;

            $value = $settings->pi_ratepay_settings__account_number->rawValue;
            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_ACCOUNTNUMBER') . " $value";
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;


            $oid = $this->_oData->getId();

            $ratepayOrder = oxNew('pi_ratepay_orders');
            $ratepayOrder->loadByOrderNumber($oid);

            $value = $ratepayOrder->pi_ratepay_orders__descriptor->rawValue;
            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_REFERENCE') . " " . $value;
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;


            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_INTERNATIONALDESC');
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;

            $value = $settings->pi_ratepay_settings__swift_bic->rawValue;
            $values = $settings->pi_ratepay_settings__iban->rawValue;
            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_SWIFTBIC') . " $value " . $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_IBAN') . " $values";
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;

            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_ADDITIONALINFO_1');
            $this->text(15, $iStartPos + 8, $text);
            $iStartPos += 8;

            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_ADDITIONALINFO_2');
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;

            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_ADDITIONALINFO_3');
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;

            $text = $this->_oData->translate('PI_RATEPAY_RECHNUNG_PDF_ADDITIONALINFO_4');
            $this->text(15, $iStartPos + 4, $text);
            $iStartPos += 4;

            $value = $settings->pi_ratepay_settings__invoice_field->rawValue;

            if ($value != "") {
                $iStartPos += 4;
                $textArray = explode("\r\n", $value);

                foreach ($textArray as $text) {
                    $this->text(15, $iStartPos + 4, $text);
                    $iStartPos += 4;
                }
            }
        } else {
            parent::_setPayUntilInfo($iStartPos);
        }
    }

}
