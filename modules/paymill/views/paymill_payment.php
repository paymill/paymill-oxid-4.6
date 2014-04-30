<?php
/**
 * paymill_payment
 *
 * @author     Copyright (c) 2013 PayIntelligent GmbH (http://www.payintelligent.de)
 * @copyright  Copyright (c) 2013 Paymill GmbH (https://www.paymill.com)
 */
class paymill_payment extends paymill_payment_parent
{
    private $_fastCheckoutData;

    private $_payments;

    private $_payment;


    /**
     * Rewrite of oxid's getPaymentList method
     * adds some errors to the payment selection if necessary
     *
     * @overload
     */
    public function render()
    {
        if ($this->getUser()) {
            $this->_payments = new Services_Paymill_Payments(
                trim(oxConfig::getInstance()->getShopConfVar('PAYMILL_PRIVATEKEY')),
                paymill_util::API_ENDPOINT
            );

            $this->_fastCheckoutData = oxNew('paymill_fastcheckout');
            $this->_fastCheckoutData->load($this->getUser()->getId());

            $this->_setPayment(
                $this->_fastCheckoutData->paymill_fastcheckout__paymentid_cc->rawValue
            );
            if (array_key_exists('last4', $this->_payment)) {
                $this->addTplParam('fastCheckoutCc', 'true');
                $this->_setPaymillCcPaymentData();
            } else {
                $this->addTplParam('fastCheckoutCc', 'false');
            }

            $this->_setPayment(
                $this->_fastCheckoutData->paymill_fastcheckout__paymentid_elv->rawValue
            );

            if (array_key_exists('account', $this->_payment) || array_key_exists('iban', $this->_payment)) {
                $this->addTplParam('fastCheckoutElv', 'true');
                $this->_setPaymillElvPaymentData();
            } else {
                $this->addTplParam('fastCheckoutElv', 'false');
            }
        }

        $this->addTplParam(
            'paymillPublicKey',
            trim(oxConfig::getInstance()->getShopConfVar('PAYMILL_PUBLICKEY'))
        );

        $this->addTplParam(
            'paymillUtil',
            oxNew('paymill_util')
        );

        $this->_addToTplWhichCreditCardsToShow();

        return parent::render();
    }

    private function _setPayment($paymentId)
    {
        $this->_payment = $this->_payments->getOne(
            $paymentId
        );

        if (is_null($this->_payment)) {
            $this->_payment = array();
        }
    }

    private function _setPaymillCcPaymentData()
    {
        if (!array_key_exists('error', $this->_payment)) {
            $this->addTplParam('paymillCcLastFour', '************' . $this->_getEntry($this->_payment, 'last4'));
            $this->addTplParam('paymillCcCvc', '***');
            $this->addTplParam('paymillCcCardHolder', $this->_getEntry($this->_payment, 'card_holder'));
            $this->addTplParam('paymillCcExpireMonth', $this->_getEntry($this->_payment, 'expire_month'));
            $this->addTplParam('paymillCcExpireYear', $this->_getEntry($this->_payment, 'expire_year'));
            if ($this->_getEntry($this->_payment, 'card_type') === 'american express') {
                $this->addTplParam('brand', 'amex');
            } else {
                $this->addTplParam('brand', $this->_getEntry($this->_payment, 'card_type'));
            }
        }
    }

    private function _setPaymillElvPaymentData()
    {
        if (!array_key_exists('error', $this->_payment)) {
            $this->addTplParam('paymillElvHolder', $this->_getEntry($this->_payment, 'holder'));

            $fastCheckoutAccount = $this->_getEntry($this->_payment, 'account');
            $fastCheckoutCode = $this->_getEntry($this->_payment, 'code');
            $fastCheckoutIban = $this->_getEntry($this->_payment, 'iban');
            $fastCheckoutBic = $this->_getEntry($this->_payment, 'bic');

            if (is_null($fastCheckoutAccount) || is_null($fastCheckoutCode)) {
                $account = $fastCheckoutIban;
                $code = $fastCheckoutBic;
            } else {
                $account = $fastCheckoutAccount;
                $code = $fastCheckoutCode;
            }

            $this->addTplParam('paymillElvAccount', $account);
            $this->addTplParam('paymillElvCode', $code);
        }
    }

    private function _getEntry($data, $key)
    {
        if (!is_array($data)) {
            $data = array();
        }

        return array_key_exists($key, $data) ? $data[$key] : null;
    }

    /**
     * loads the paymentlist
     *
     * @overload
     */
    public function getPaymentList()
    {
        //clear values
        oxSession::deleteVar('paymill_authorized_amount');
        $differentAmount = intval(round(oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_DIFFERENTAMOUNT'), 2) * 100);
        //save authorized Amount for secure Paymentprocessing
        $amount = intval(round(oxSession::getInstance()->getBasket()->getPrice()->getBruttoPrice() * 100) + $differentAmount);
        oxSession::setVar('paymill_authorized_amount', $amount);
        $this->addTplParam('paymillAmount', $amount);

        $paymentList = parent::getPaymentList();

        $privateKey = oxConfig::getInstance()->getShopConfVar('PAYMILL_PRIVATEKEY');
        $publicKey  = oxConfig::getInstance()->getShopConfVar('PAYMILL_PUBLICKEY');

        if (empty($privateKey) || empty($publicKey)) {
            // @TODO log message so user knows that payment was deactivated because of missing private or public key
            unset($paymentList['paymill_elv']);
            unset($paymentList['paymill_cc']);
        }

        return $paymentList;
    }


    /**
     * @overload
     */
    public function validatePayment()
    {
        if (oxConfig::getParameter('paymentid') === "paymill_cc" || oxConfig::getParameter('paymentid') === "paymill_elv") {
            oxSession::deleteVar('paymill_token');
            // set paymill token to session to be available in next step
            if (oxConfig::getParameter('paymillToken')) {
                oxSession::setVar('paymill_token', oxConfig::getParameter('paymillToken'));
            }
        }

        return parent::validatePayment();
    }

    private function _addToTplWhichCreditCardsToShow()
    {
        $settings = array(
            'visa' => oxConfig::getInstance()->getShopConfVar('PAYMILL_VISA'),
            'mastercard' => oxConfig::getInstance()->getShopConfVar('PAYMILL_MASTERCARD'),
            'amex' => oxConfig::getInstance()->getShopConfVar('PAYMILL_AMEX'),
            'carta-si' => oxConfig::getInstance()->getShopConfVar('PAYMILL_CARTA_SI'),
            'carte-bleue' => oxConfig::getInstance()->getShopConfVar('PAYMILL_CARTE_BLEUE'),
            'diners-club' => oxConfig::getInstance()->getShopConfVar('PAYMILL_DINERSCLUB'),
            'jcb' => oxConfig::getInstance()->getShopConfVar('PAYMILL_JCB'),
            'maestro' => oxConfig::getInstance()->getShopConfVar('PAYMILL_MAESTRO'),
            'china-unionpay' => oxConfig::getInstance()->getShopConfVar('PAYMILL_UNIONPAY'),
            'discover' => oxConfig::getInstance()->getShopConfVar('PAYMILL_DISCOVER'),
            'dankort' => oxConfig::getInstance()->getShopConfVar('PAYMILL_DANKORT')
        );

        $ccToShow = array();

        foreach ($settings as $card => $setting) {
            if ($setting) {
                array_push($ccToShow, $card);
            }
        }

        $this->addTplParam('paymillBrands', $ccToShow);
    }

}
