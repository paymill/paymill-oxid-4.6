<?php

class paymill_hooks extends oxUBase
{
    public function render()
    {       
        $data = json_decode($this->getInput('php://input'));
        if (!is_null($data) && isset($data->event) && isset($data->event->event_resource)) {
            if (isset($data->event->event_resource->transaction)) {
                $description = array();
                if (preg_match("/OrderID: (\S*)/", $data->event->event_resource->transaction->description, $description)) {
                    $order = oxNew("oxorder");
                    $order->load($description[1]);
                    $status = '';
                    if ($data->event->event_resource->amount == $order->getTotalOrderSum()) {
                        $order->oxorder__oxstorno = oxNew('oxField', 1, oxField::T_RAW);
                        $status = strtoupper($data->event->event_resource->status);
                    } else {
                        $status = 'PARTIAL - ' . strtoupper($data->event->event_resource->status);
                    }
                    
                    $order->oxorder__oxtransstatus = oxNew('oxField', $status, oxField::T_RAW);
                    
                    $order->save();
                }
            }
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
}