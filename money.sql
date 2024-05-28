-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for rexshackredmbuild_c50ff1
CREATE DATABASE IF NOT EXISTS `rexshackredmbuild_c50ff1` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `rexshackredmbuild_c50ff1`;

-- Dumping structure for table rexshackredmbuild_c50ff1.money_boxes
CREATE TABLE IF NOT EXISTS `money_boxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `netId` int(11) NOT NULL,
  `cashAmount` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table rexshackredmbuild_c50ff1.money_boxes: ~34 rows (approximately)
INSERT INTO `money_boxes` (`id`, `netId`, `cashAmount`, `x`, `y`, `z`) VALUES
	(24, 38, 100, -351.152, 753.969, 116.511),
	(25, 17, 100, -352.009, 753.389, 116.478),
	(26, 23, 100, -352.404, 752.98, 116.478),
	(27, 22, 100, -353.077, 751.859, 116.495),
	(28, 88, 100, -351.943, 752.809, 116.511),
	(29, 49, 100, -351.468, 751.767, 116.562),
	(30, 94, 100, -350.848, 750.923, 116.528),
	(31, 32, 100, -349.886, 749.868, 116.596),
	(32, 48, 100, -349.121, 749.433, 116.646),
	(33, 69, 100, -350.993, 751.398, 116.545),
	(34, 49, 100, -349.78, 751.279, 116.495),
	(35, 57, 100, -348.593, 751.793, 116.511),
	(36, 38, 100, -348.752, 752.611, 116.495),
	(37, 81, 100, -347.868, 753.64, 116.461),
	(38, 59, 100, -347.921, 753.785, 116.478),
	(39, 54, 100, -348.527, 753.653, 116.495),
	(40, 99, 100, -348.923, 753.429, 116.495),
	(41, 30, 100, -348.686, 754.721, 116.495),
	(42, 75, 100, -349.938, 752.308, 116.495),
	(43, 25, 100, -349.925, 753.508, 116.511),
	(44, 30, 100, -349.648, 754.668, 116.511),
	(45, 44, 100, -350.044, 752.98, 116.511),
	(46, 47, 100, -350.255, 754.365, 116.511),
	(47, 82, 100, -350.4, 753.363, 116.511),
	(48, 82, 100, -351.231, 754.22, 116.511),
	(49, 45, 100, -352.299, 754.642, 116.495),
	(50, 46, 100, -351.587, 753.903, 116.495),
	(51, 65, 100, -352.127, 754.747, 116.495),
	(52, 87, 100, -352.352, 753.455, 116.478),
	(53, 45, 100, -351.429, 752.637, 116.528),
	(54, 41, 100, -350.374, 752.097, 116.511),
	(55, 57, 100, -350.242, 753.613, 116.511),
	(56, 68, 100, -349.912, 754.114, 115.719),
	(57, 91, 100, -352.418, 753.521, 116.461);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
