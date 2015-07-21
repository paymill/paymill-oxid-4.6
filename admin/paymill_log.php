<?php

/**
 * paymill_log
 *
 * @copyright  Copyright (c) 2015 PAYMILL GmbH (https://www.paymill.com)
 */
class paymill_log extends paymill_log_abstract
{
    public function render()
    {
        parent::render();
        return 'paymill_log.tpl';
    }
}
