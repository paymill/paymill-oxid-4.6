<?php

/**
 * paymill_util
 *
 * @copyright  Copyright (c) 2015 PAYMILL GmbH (https://www.paymill.com)
 */
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