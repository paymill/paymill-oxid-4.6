<?php

class paymill_log_entry extends paymill_log_abstract
{
    public function render()
    {
        $this->addTplParam(
            'debug', 
            $this->_getEntry(oxConfig::getParameter('entryId'))->paymill_logging__debug->rawValue
        );
        
        return 'paymill_log_entry.tpl';
    }
    
    protected function _getEntry($entryId)
    {
        $data = oxNew('paymill_logging');
        $data->load($entryId);
        
        return $data;
    }
}
