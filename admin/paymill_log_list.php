<?php

class paymill_log_list extends paymill_log_abstract
{
    private $_searchKey;
    
    private $_page;
    
    private $_recordLimit = 8;
    
    private $_pageCount;
    
    public function render()
    {
        parent::render();
        $this->_page = oxConfig::getParameter('seite');
        $this->_searchKey = oxConfig::getParameter('search_key');
        $this->addTplParam('list', $this->_getData());
        $this->addTplParam('editUrl', $this->_getAdminUrl() . '&cl=paymill_log_entry');
        $this->addTplParam('pageCount', $this->_pageCount);
        return 'paymill_log_list.tpl';
    }

    private function _getData()
    {   
        $logList = oxNew('paymill_loglist');
        
        $where = null;
        if (!empty($this->_searchKey)) {
            $where = 'debug like "%' . $this->_searchKey . '%"';
        }
        
        if (empty($this->_page)) {
            $this->_page = 1;
        }

        $start = $this->_page * $this->_recordLimit - $this->_recordLimit;
        
        $this->_pageCount = count($logList->getFilteredList($where)) / $this->_recordLimit;
        
        $data = $logList->setLimit($start, $this->_recordLimit)->getFilteredList($where)->getArray();
        
        return $data;
    }
    
}
