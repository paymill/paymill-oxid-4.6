INSERT INTO oxpayments (OXID, OXACTIVE, OXDESC, OXADDSUM, OXADDSUMTYPE, OXFROMBONI, OXFROMAMOUNT, OXTOAMOUNT, OXVALDESC, OXCHECKED, OXDESC_1, OXVALDESC_1, OXDESC_2, OXVALDESC_2, OXDESC_3, OXVALDESC_3, OXLONGDESC, OXLONGDESC_1, OXLONGDESC_2, OXLONGDESC_3, OXSORT, OXTSPAYMENTID)
VALUES
('paymill_cc', 1, 'Kreditkartenzahlung', 0, 'abs', 0, 0, 99999, '', 1, 'Credit Card', '', '', '', '', '', '', '', '', '', 0, ''),
('paymill_elv', 1, 'ELV', 0, 'abs', 0, 0, 99999, '', 1, 'Direct Debit', '', '', '', '', '', '', '', '', '', 0, '');

CREATE TABLE IF NOT EXISTS `paymill_fastcheckout` (
  `oxid` varchar(100) NOT NULL,
  `clientID` varchar(100) NOT NULL,
  `paymentID_CC` varchar(100) DEFAULT NULL,
  `paymentID_ELV` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`oxid`)
);

CREATE TABLE IF NOT EXISTS `paymill_logging` (
  `oxid` varchar(100) NOT NULL,
  `identifier` text NOT NULL,
  `debug` text NOT NULL,
  `message` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`oxid`)
);