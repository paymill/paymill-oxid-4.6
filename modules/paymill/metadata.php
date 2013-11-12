<?php

$sMetadataVersion = '1.0';
$aModule = array(
    'id' => 'paymill',
    'title' => 'Paymill',
    'description' => 'Paymill Payment',
    'thumbnail' => 'image/logo.png',
    'version' => '2.2.0',
    'author' => 'Paymill GmbH',
    'url' => 'http://www.paymill.de',
    'email' => 'support@paymill.de',
    'extend' => array(
        'payment' => 'paymill/views/paymill_payment',
        'oxpaymentgateway' => 'paymill/views/paymill_paymentgateway'
    ),
    'files' => array(
        'Services_Paymill_PaymentProcessor' => 'paymill/lib/Services/Paymill/PaymentProcessor.php',
        'Services_Paymill_LoggingInterface' => 'paymill/lib/Services/Paymill/LoggingInterface.php',
        'Services_Paymill_Clients' => 'paymill/lib/Services/Paymill/Clients.php',
        'Services_Paymill_Payments' => 'paymill/lib/Services/Paymill/Payments.php',
        'paymill_fastcheckout' => 'paymill/core/paymill_fastcheckout.php',
        'paymill_logging' => 'paymill/core/paymill_logging.php',
        'paymill_loglist' => 'paymill/core/paymill_loglist.php',
        'paymill_util' => 'paymill/util/paymill_util.php'
    ),
    'blocks' => array(
        array('template' => 'page/checkout/payment.tpl', 'block' => 'select_payment', 'file' => 'paymill_select_payment.tpl'),
        array('template' => 'page/checkout/payment.tpl', 'block' => 'checkout_payment_main', 'file' => 'paymill_select_header.tpl'),
    ),
    'settings' => array(
        array('group' => 'main', 'name' => 'PAYMILL_PRIVATEKEY', 'type' => 'str', 'value' => ''),
        array('group' => 'main', 'name' => 'PAYMILL_PUBLICKEY', 'type' => 'str', 'value' => ''),
        array('group' => 'main', 'name' => 'PAYMILL_ACTIVATE_DEBUG', 'type' => 'bool', 'value' => 'false'),
        array('group' => 'main', 'name' => 'PAYMILL_ACTIVATE_LOGGING', 'type' => 'bool', 'value' => 'false'),
        array('group' => 'main', 'name' => 'PAYMILL_ACTIVATE_DIFFERENTAMOUNT', 'type' => 'str', 'value' => 0),
        array('group' => 'main', 'name' => 'PAYMILL_ACTIVATE_FASTCHECKOUT', 'type' => 'bool', 'value' => 'false'),
        array('group' => 'main', 'name' => 'PAYMILL_SHOW_LABEL', 'type' => 'bool', 'value' => 'true'),
        array('group' => 'main', 'name' => 'PAYMILL_SET_PAYMENTDATE', 'type' => 'bool', 'value' => 'true'),
    )
);