<?php
$sMetadataVersion = '1.0';
$aModule = array(
    'id'           => 'paymill',
    'title'        => 'Paymill',
    'description'  => 'Paymill Payment',
    'thumbnail'    => 'logo.png',
    'version'      => '2.0',
    'author'       => 'Paymill GmbH',
    'url'          => 'http://www.paymill.de',
    'email'        => 'support@paymill.de',
    'extend'       => array(
    ),
    'files' => array(
    ),
    'blocks' => array(
        array('template' => 'page/checkout/payment.tpl', 'block'=>'select_payment', 'file'=>'paymill_select_payment.tpl'),
        array('template' => 'page/checkout/payment.tpl', 'block'=>'checkout_payment_main', 'file'=>'paymill_select_header.tpl')
    ),
    'settings' => array(
        array( 'group' => 'main','name' => 'PAYMILL_PRIVATEKEY', 'type' => 'str', 'value' => ''),
        array( 'group' => 'main','name' => 'PAYMILL_PUBLICKEY', 'type' => 'str', 'value' => ''),
        array( 'group' => 'main','name' => 'PAYMILL_ACTIVATE_ELV', 'type' => 'bool', 'value' => 'false'),
        array( 'group' => 'main','name' => 'PAYMILL_ACTIVATE_CC', 'type' => 'bool', 'value' => 'false'),
        array( 'group' => 'main','name' => 'PAYMILL_ACTIVATE_DEBUG', 'type' => 'bool', 'value' => 'false'),
        array( 'group' => 'main','name' => 'PAYMILL_ACTIVATE_LOGGING', 'type' => 'bool', 'value' => 'false'),
        array( 'group' => 'main','name' => 'PAYMILL_ACTIVATE_FASTCHECKOUT', 'type' => 'bool', 'value' => 'false'),
    )
);