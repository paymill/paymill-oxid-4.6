<?php

class paymill_util
{
    const API_ENDPOINT = "https://api.paymill.com/v2/";
    
    
    public function convertToUtf($value)
    {
        if (!oxConfig::getInstance()->isUtf()) {
            $value = utf8_decode($value);
        }

        return $value;
    }
}