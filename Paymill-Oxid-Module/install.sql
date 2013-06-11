INSERT INTO oxpayments (OXID, OXACTIVE, OXDESC, OXADDSUM, OXADDSUMTYPE, OXFROMBONI, OXFROMAMOUNT, OXTOAMOUNT, OXVALDESC, OXCHECKED, OXDESC_1, OXVALDESC_1, OXDESC_2, OXVALDESC_2, OXDESC_3, OXVALDESC_3, OXLONGDESC, OXLONGDESC_1, OXLONGDESC_2, OXLONGDESC_3, OXSORT, OXTSPAYMENTID)
VALUES
('paymill_cc', 1, 'Paymill Creditcard', 0, 'abs', 0, 0, 0, '', 1, 'PAYMILL', '', '', '', '', '', '', '', '', '', 0, ''),
('paymill_elv', 1, 'Paymill Elv', 0, 'abs', 0, 0, 0, '', 1, 'PAYMILL', '', '', '', '', '', '', '', '', '', 0, '');

CREATE TABLE IF NOT EXISTS `paymill_fastcheckout` (
  `userID` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `clientID` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `paymentID_CC` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `paymentID_ELV` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `userID` (`userID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;