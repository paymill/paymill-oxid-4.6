<?php

class paymill_log extends paymill_log_abstract
{
    public function render()
    {
        parent::render();
        return 'paymill_log.tpl';
    }
}
