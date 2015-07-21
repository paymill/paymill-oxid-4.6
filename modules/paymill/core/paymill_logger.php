<?php

/**
 * paymill_logger
 *
 * @copyright  Copyright (c) 2015 PAYMILL GmbH (https://www.paymill.com)
 */
class paymill_logger implements Services_Paymill_LoggingInterface
{

    /**
     * log the given message
     *
     * @param string $message
     * @param string $debuginfo
     */
    public function log($message, $debuginfo)
    {
        if (oxConfig::getInstance()->getShopConfVar('PAYMILL_ACTIVATE_LOGGING')) {
            $logging = oxNew('paymill_logging');
            $logging->assign(array(
                'identifier' => oxSession::getInstance()->getVar('paymill_identifier'),
                'debug' => $debuginfo,
                'message' => $message,
                'date' => date('Y-m-d H:i:s', oxUtilsDate::getInstance()->getTime())
            ));

            $logging->save();
        }
    }

}