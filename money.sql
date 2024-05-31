




CREATE TABLE IF NOT EXISTS `money_boxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `netId` int(11) NOT NULL,
  `cashAmount` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

