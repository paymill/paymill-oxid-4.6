<?php

/**
 * paymill_log
 *
 * @author     Copyright (c) 2013 PayIntelligent GmbH (http://www.payintelligent.de)
 * @copyright  Copyright (c) 2013 Paymill GmbH (https://www.paymill.com)
 */
class paymill_log extends Shop_Config
{
    /**
     * modulname
     */

    const PAYMILL_MODULE_NAME = 'paymill';

    /**
     * name of the template
     * @var string
     */
    protected $_sThisTemplate = 'paymill_log.tpl';

    /**
     * Renders the Template
     *
     * @return string
     */
    public function render()
    {

        $myConfig = $this->getConfig();
        $aDbVariables = $this->_loadConfVars($myConfig->getShopId(), $moduleName = '');
        $aConfVars = $aDbVariables['vars'];

        foreach ($this->_aConfParams as $sType => $sParam) {
            $this->_aViewData[$sParam] = $aConfVars[$sType];
        }

        $this->addTplParam('content', file_get_contents('../modules/paymill/log.txt'));
        return $this->_sThisTemplate;
    }

}
