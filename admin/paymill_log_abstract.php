<?php

abstract class paymill_log_abstract extends oxAdminView
{
    public function render()
    {
        parent::render();
        $this->addTplParam('listUrl', $this->_getAdminUrl() . '&cl=paymill_log_list');
    }
    
    protected function _getAdminUrl()
    {
        return oxConfig::getInstance()->getShopUrl(null, true) 
                . 'admin/index.php?stoken=' . oxConfig::getParameter('stoken') 
                . '&force_admin_sid=' . oxConfig::getParameter('force_admin_sid');
    }
}