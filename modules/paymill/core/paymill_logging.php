<?php

/**
 * paymill_logging
 *
 * @copyright  Copyright (c) 2015 PAYMILL GmbH (https://www.paymill.com)
 */
class paymill_logging extends oxBase
{
    /**
     * Current class name
     *
     * @var string
     */
    protected $_sClassName = 'paymill_logging';

    /**
     * Class constructor
     */
    public function __construct()
    {
        parent::__construct();
        $this->init('paymill_logging');
    }
}