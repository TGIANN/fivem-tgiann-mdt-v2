-- --------------------------------------------------------
-- Sunucu:                       127.0.0.1
-- Sunucu sürümü:                10.4.18-MariaDB - mariadb.org binary distribution
-- Sunucu İşletim Sistemi:       Win64
-- HeidiSQL Sürüm:               11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

ALTER TABLE `users` ADD COLUMN `aranma` mediumtext DEFAULT "[]";
ALTER TABLE `users` ADD COLUMN `photo` mediumtext NULL;

-- tablo yapısı dökülüyor qbus.tgiann_mdt_arananlar
CREATE TABLE IF NOT EXISTS `tgiann_mdt_arananlar` (
  `citizenid` varchar(50) DEFAULT NULL,
  `sebep` longtext DEFAULT NULL,
  `baslangic` varchar(255) DEFAULT NULL,
  `bitis` varchar(255) DEFAULT NULL,
  `isim` varchar(255) DEFAULT NULL,
  `img` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Veri çıktısı seçilmemişti

-- tablo yapısı dökülüyor qbus.tgiann_mdt_cezalar
CREATE TABLE IF NOT EXISTS `tgiann_mdt_cezalar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `aciklama` longtext DEFAULT NULL,
  `ceza` varchar(255) DEFAULT NULL,
  `polis` mediumtext DEFAULT NULL,
  `zanli` mediumtext DEFAULT NULL,
  `cezalar` longtext DEFAULT NULL,
  `olayid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1634 DEFAULT CHARSET=utf8;

-- Veri çıktısı seçilmemişti

-- tablo yapısı dökülüyor qbus.tgiann_mdt_olaylar
CREATE TABLE IF NOT EXISTS `tgiann_mdt_olaylar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aciklama` longtext DEFAULT NULL,
  `polis` mediumtext DEFAULT NULL,
  `zanli` mediumtext DEFAULT NULL,
  `zaman` varchar(50) DEFAULT current_timestamp(),
  `esyalar` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1188 DEFAULT CHARSET=utf8;

-- Veri çıktısı seçilmemişti

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
