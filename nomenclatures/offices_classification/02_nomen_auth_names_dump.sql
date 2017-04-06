-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: `your_database`
-- ------------------------------------------------------
-- Server version	5.6.25

-- ---------------------------------------------------------------------------------
-- Database

USE `your_database`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `nomen_appln_auth`
--

DROP TABLE IF EXISTS `nomen_appln_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nomen_appln_auth` (
  `appln_auth` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `auth_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `acronym` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `status` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`appln_auth`),
  KEY `appln_auth` (`appln_auth`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nomen_appln_auth`
--

LOCK TABLES `nomen_appln_auth` WRITE;
/*!40000 ALTER TABLE `nomen_appln_auth` DISABLE KEYS */;
INSERT INTO `nomen_appln_auth` VALUES ('AD','Andorra','','in use'),('AE','United Arab Emirates','','in use'),('AF','Afghanistan','','in use'),('AG','Antigua and Barbuda','','in use'),('AI','Anguilla','','in use'),('AL','Albania','','in use'),('AM','Armenia','','in use'),('AN','Netherlands Antilles','','in use'),('AO','Angola','','in use'),('AP','African Regional Intellectual Property Organization','ARIPO','in use'),('AR','Argentina','','in use'),('AT','Austria','','in use'),('AU','Australia','','in use'),('AW','Aruba','','in use'),('AZ','Azerbaijan','','in use'),('BA','Bosnia and Herzegovina','','in use'),('BB','Barbados','','in use'),('BD','Bangladesh','','in use'),('BE','Belgium','','in use'),('BF','Burkina Faso','','in use'),('BG','Bulgaria','','in use'),('BH','Bahrain','','in use'),('BI','Burundi','','in use'),('BJ','Benin','','in use'),('BM','Bermuda','','in use'),('BN','Brunei Darussalam','','in use'),('BO','Bolivia','','in use'),('BR','Brazil','','in use'),('BS','Bahamas','','in use'),('BT','Bhutan','','in use'),('BV','Bouvet Island','','in use'),('BW','Botswana','','in use'),('BX','Benelux Trademark and Designs Office','BBM-BBDM','in use'),('BY','Belarus','','in use'),('BZ','Belize','','in use'),('CA','Canada','','in use'),('CD','Democratic Republic of the Congo','','in use'),('CF','Central African Republic','','in use'),('CG','Congo','','in use'),('CH','Switzerland','','in use'),('CI','Côte d’Ivoire','','in use'),('CK','Cook Islands','','in use'),('CL','Chile','','in use'),('CM','Cameroon','','in use'),('CN','China','SIPO','in use'),('CO','Colombia','','in use'),('CR','Costa Rica','','in use'),('CU','Cuba','','in use'),('CV','Cape Verde','','in use'),('CY','Cyprus','','in use'),('CZ','Czech Republic','','in use'),('DE','German Patent and Trade Mark Office','DPMA','in use'),('DJ','Djibouti','','in use'),('DK','Denmark','','in use'),('DM','Dominica','','in use'),('DO','Dominican Republic','','in use'),('DZ','Algeria','','in use'),('EA','Eurasian Patent Organization','EAPO','in use'),('EC','Ecuador','','in use'),('EE','Estonia','','in use'),('EG','Egypt','','in use'),('EH','Western Sahara','','in use'),('EM','Office for Harmonization in the Internal Market (Trademarks and Designs)','OHIM','in use'),('EP','European Patent Office','EPO','in use'),('ER','Eritrea','','in use'),('ES','Spain','','in use'),('ET','Ethiopia','','in use'),('FI','Finland','','in use'),('FJ','Fiji','','in use'),('FK','Falkland Islands Malvinas','','in use'),('FO','Faroe Islands','','in use'),('FR','France','INPI','in use'),('GA','Gabon','','in use'),('GB','United Kingdom','IPO','in use'),('GC','Patent Office of the Cooperation Council for the Arab States of the Gulf','GCC','in use'),('GD','Grenada','','in use'),('GE','Georgia','','in use'),('GG','Guernsey','','in use'),('GH','Ghana','','in use'),('GI','Gibraltar','','in use'),('GL','Greenland','','in use'),('GM','Gambia','','in use'),('GN','Guinea','','in use'),('GQ','Equatorial Guinea','','in use'),('GR','Greece','','in use'),('GS','South Georgia and the South Sandwich Islands','','in use'),('GT','Guatemala','','in use'),('GW','Guinea-Bissau','','in use'),('GY','Guyana','','in use'),('HK','The Hong Kong Special Administrative Region of the People\'s Republic of China','','in use'),('HN','Honduras','','in use'),('HR','Croatia','','in use'),('HT','Haiti','','in use'),('HU','Hungary','','in use'),('IB','International Bureau of the World Intellectual Property Organization','WIPO','in use'),('ID','Indonesia','','in use'),('IE','Ireland','','in use'),('IL','Israel','','in use'),('IM','Isle of Man','','in use'),('IN','India','','in use'),('IQ','Iraq','','in use'),('IR','Iran','','in use'),('IS','Iceland','','in use'),('IT','Italy','','in use'),('JE','Jersey','','in use'),('JM','Jamaica','','in use'),('JO','Jordan','','in use'),('JP','Japan Patent Office','JPO','in use'),('KE','Kenya','','in use'),('KG','Kyrgyzstan','','in use'),('KH','Cambodia','','in use'),('KI','Kiribati','','in use'),('KM','Comoros','','in use'),('KN','Saint Kitts and Nevis','','in use'),('KP','Democratic People\'s Republic of Korea','','in use'),('KR','Republic of Korea','','in use'),('KW','Kuwait','','in use'),('KY','Cayman Islands','','in use'),('KZ','Kazakhstan','','in use'),('LA','Lao People\'s Democratic Republic','','in use'),('LB','Lebanon','','in use'),('LC','Saint Lucia','','in use'),('LI','Liechtenstein','','in use'),('LK','Sri Lanka','','in use'),('LR','Liberia','','in use'),('LS','Lesotho','','in use'),('LT','Lithuania','','in use'),('LU','Luxembourg','','in use'),('LV','Latvia','','in use'),('LY','Libyan Arab Jamahiriya','','in use'),('MA','Morocco','','in use'),('MC','Monaco','','in use'),('MD','Republic of Moldova','','in use'),('ME','Montenegro','','in use'),('MG','Madagascar','','in use'),('MK','The former Yugoslav Republic of Macedonia','','in use'),('ML','Mali','','in use'),('MM','Myanmar','','in use'),('MN','Mongolia','','in use'),('MO','Macao','','in use'),('MP','Northern Mariana Islands','','in use'),('MR','Mauritania','','in use'),('MS','Montserrat','','in use'),('MT','Malta','','in use'),('MU','Mauritius','','in use'),('MV','Maldives','','in use'),('MW','Malawi','','in use'),('MX','Mexico','','in use'),('MY','Malaysia','','in use'),('MZ','Mozambique','','in use'),('NA','Namibia','','in use'),('NE','Niger','','in use'),('NG','Nigeria','','in use'),('NI','Nicaragua','','in use'),('NL','Netherlands','','in use'),('NO','Norway','','in use'),('NP','Nepal','','in use'),('NR','Nauru','','in use'),('NZ','New Zealand','','in use'),('OA','African Intellectual Property Organization','OAPI','in use'),('OM','Oman','','in use'),('PA','Panama','','in use'),('PE','Peru','','in use'),('PG','Papua New Guinea','','in use'),('PH','Philippines','','in use'),('PK','Pakistan','','in use'),('PL','Poland','','in use'),('PT','Portugal','','in use'),('PW','Palau','','in use'),('PY','Paraguay','','in use'),('QA','Qatar','','in use'),('QZ','Community Plant Variety Office (European Community)','CPVO','in use'),('RO','Romania','','in use'),('RS','Serbia','','in use'),('RU','Russian Federation','','in use'),('RW','Rwanda','','in use'),('SA','Saudi Arabia','','in use'),('SB','Solomon Islands','','in use'),('SC','Seychelles','','in use'),('SD','Sudan','','in use'),('SE','Sweden','','in use'),('SG','Singapore','','in use'),('SH','Saint Helena','','in use'),('SI','Slovenia','','in use'),('SK','Slovakia','','in use'),('SL','Sierra Leone','','in use'),('SM','San Marino','','in use'),('SN','Senegal','','in use'),('SO','Somalia','','in use'),('SR','Suriname','','in use'),('ST','Sao Tome and Principe','','in use'),('SV','El Salvador','','in use'),('SY','Syrian Arab Republic','','in use'),('SZ','Swaziland','','in use'),('TC','Turks and Caicos Islands','','in use'),('TD','Chad','','in use'),('TG','Togo','','in use'),('TH','Thailand','','in use'),('TJ','Tajikistan','','in use'),('TL','Timor-Leste','','in use'),('TM','Turkmenistan','','in use'),('TN','Tunisia','','in use'),('TO','Tonga','','in use'),('TR','Turkey','','in use'),('TT','Trinidad and Tobago','','in use'),('TV','Tuvalu','','in use'),('TW','Taiwan -  Province of China','','in use'),('TZ','United Republic of Tanzania','','in use'),('UA','Ukraine','','in use'),('UG','Uganda','','in use'),('US','United States Patent and Trademark Office','USPTO','in use'),('UY','Uruguay','','in use'),('UZ','Uzbekistan','','in use'),('VA','Holy See','','in use'),('VC','Saint Vincent and the Grenadines','','in use'),('VE','Venezuela','','in use'),('VG','Virgin Islands','','in use'),('VN','Viet Nam','','in use'),('VU','Vanuatu','','in use'),('WO','World Intellectual Property Organization','WIPO','in use'),('WS','Samoa','','in use'),('YE','Yemen','','in use'),('ZA','South Africa','','in use'),('ZM','Zambia','','in use'),('ZW','Zimbabwe','','in use'),('CS','Serbia and Montenegro','','deprecate'),('ZZ','Unknown','','unknown'),('11','Unknown','','deprecate'),('AA','Unknown','','deprecate'),('DD','German Democratic Republic','','deprecate'),('RE','Unknown','','deprecate'),('RH','Unknown','','deprecate'),('SU','Soviet Union','','deprecate'),('TP','Unknown','','deprecate'),('U9','Unknown','','deprecate'),('W0','Unknown','','deprecate'),('XH','Unknown','','deprecate'),('XP','Unknown','','deprecate'),('YU','Yugoslavia','','deprecate'),('ZR','Unknown','','deprecate');
/*!40000 ALTER TABLE `nomen_appln_auth` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-06 12:09:03
