<?php

class paymill_hooks extends oxUBase
{

    public function render()
    {
        $data = json_decode($this->getInput('php://input'));
        if ($this->validateRequest($data) && preg_match("/OrderID: (\S*)/", $data->event->event_resource->transaction->description, $description)) {
            $order = oxNew("oxorder");
            $order->load($description[1]);

            $this->log("Webhook Ordernumber", var_export($description[1],true));
            $status = '';
            if ((int) $data->event->event_resource->amount === (int) $data->event->event_resource->transaction->amount) {
                $order->oxorder__oxstorno = oxNew('oxField', 1, oxField::T_RAW);
                $status = strtoupper($data->event->event_resource->status);
            } else {
                $status = 'PARTIAL - ' . strtoupper($data->event->event_resource->status);
            }
            $this->log("Webhook new Status", var_export($status,true));
            $order->oxorder__oxtransstatus = oxNew('oxField', $status, oxField::T_RAW);
            $order->save();
        }
        exit($this->setHeader("HTTP/1.1 200 OK"));
    }

    /**
     * Return the data from
     * the given stream source
     *
     * @param string $source
     * @return string
     */
    public function getInput($source)
    {
        return file_get_contents($source);
    }

    /**
     * Set the given http header
     *
     * @param string $header
     */
    public function setHeader($header)
    {
        header($header);
    }

    private function validateRequest($data)
    {
        $valid = false;
        // check structure
        if (!is_null($data) && isset($data->event) && isset($data->event->event_resource) && isset($data->event->event_resource->transaction)) {
            $transactionObject = new Services_Paymill_Transactions(
                trim(oxConfig::getInstance()->getShopConfVar('PAYMILL_PRIVATEKEY')), paymill_util::API_ENDPOINT
            );
            $transaction = $transactionObject->getOne($data->event->event_resource->transaction->id);

            // Validate data
            if (isset($transaction['id']) && ($transaction['id'] === $data->event->event_resource->transaction->id)) {
                $valid = true;
            }
        }
        $this->log("Webhook Validation", var_export($valid,true));
        return $valid;
    }

    private function log($message, $debuginfo)
    {
        if (oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_LOGGING')) {
            $logging = oxNew('paymill_logging');
            $logging->assign(array(
                'identifier' => $this->getSession()->getVar('paymill_identifier'),
                'debug' => $debuginfo,
                'message' => $message,
                'date' => date('Y-m-d H:i:s', oxUtilsDate::getInstance()->getTime())
            ));

            $logging->save();
        }
    }

}
