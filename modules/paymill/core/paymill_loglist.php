<?php

/**
 * paymill_logging
 *
 * @author     Copyright (c) 2013 PayIntelligent GmbH (http://www.payintelligent.de)
 * @copyright  Copyright (c) 2013 Paymill GmbH (https://www.paymill.com)
 */
class paymill_loglist extends oxList
{

    /**
     * Core table name
     *
     * @var string
     */
    protected $_sCoreTable = 'paymill_logging';
    
    /**
     * List Object class name
     *
     * @var string
     */
    protected $_sObjectsInListName = 'paymill_logging';
    
    protected $_limit;
    
    public function setLimit($start, $limit)
    {
        $this->_limit = ' LIMIT ' . $start . ', ' . $limit;
        
        return $this;
    }


    /**
     * Generic function for loading the list with where clause and order by
     *
     * @param string $where
     * @param array $orderBy example: array(array('column' => 'order_id', 'direction' => 'asc'))
     * @return paymill_loglist
     */
    public function getFilteredList($where = null, $orderBy = null)
    {
        $listObject = $this->getBaseObject();
        $fieldList = $listObject->getSelectFields();
        $query = "select $fieldList from " . $listObject->getViewName();

        if ($where !== null) {
            $query .= " where $where ";
        }

        if ($orderBy !== null) {
            $lastArrayItem = end($orderBy);
            $addition = ', ';

            $query .= ' order by ';

            foreach ($orderBy as $orderByItem) {
                if ($orderByItem == $lastArrayItem)
                    $addition = '';
                $query .= $orderByItem['column'] . ' ' . $orderByItem['direction'] . $addition;
            }
        } else {
            $query .= ' order by date desc';
        }
        
        if ($this->_limit) {
            $query .= $this->_limit;
        }
        
        $this->selectString($query);

        return $this;
    }
}