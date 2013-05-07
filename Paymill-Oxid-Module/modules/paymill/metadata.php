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

    ),
    'settings' => array(
        array( 'group' => 'main','name' => 'privatekey', 'type' => 'str', 'value' => ''),
        array( 'group' => 'main','name' => 'publickey', 'type' => 'str', 'value' => ''),
        array( 'group' => 'main','name' => 'activate_elv', 'type' => 'bool', 'value' => 'false'),
        array( 'group' => 'main','name' => 'activate_cc', 'type' => 'bool', 'value' => 'false'),
        array( 'group' => 'main','name' => 'activate_debug', 'type' => 'bool', 'value' => 'false'),
        array( 'group' => 'main','name' => 'activate_logging', 'type' => 'bool', 'value' => 'false'),
        array( 'group' => 'main','name' => 'activate_fastcheckout', 'type' => 'bool', 'value' => 'false'),
    )
);