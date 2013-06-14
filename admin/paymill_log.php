<?php
class paymill_log extends Shop_Config
{
  const PAYMILL_MODULE_NAME = 'paymill';

  protected $_sThisTemplate = 'paymill_log.tpl';

  public function render() {

    $myConfig  = $this->getConfig();
    $aDbVariables = $this->_loadConfVars($myConfig->getShopId(), $moduleName = '');
    $aConfVars = $aDbVariables['vars'];

    foreach ($this->_aConfParams as $sType => $sParam) {
      $this->_aViewData[$sParam] = $aConfVars[$sType];
    }

    $this->addTplParam('content', file_get_contents('../modules/paymill/log.txt'));
    return $this->_sThisTemplate;
  }

}
