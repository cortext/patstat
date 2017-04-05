-- MySQL dump 10.13  Distrib 5.7.12, for Win32 (AMD64)
--
-- Host: localhost    Database: t_juan
-- ------------------------------------------------------
-- Server version	5.6.25

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
  `appln_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nomen_appln_auth` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
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
INSERT INTO `nomen_appln_auth` VALUES ('AD','Andorra','','in use'),('AE','United Arab Emirates','','in use'),('AF','Afghanistan',NULL,'in use'),('AG','Antigua and Barbuda',NULL,'in use'),('AI','Anguilla',NULL,'in use'),('AL','Albania',NULL,'in use'),('AM','Armenia',NULL,'in use'),('AN','Netherlands Antilles',NULL,'in use'),('AO','Angola',NULL,'in use'),('AP','African Regional Intellectual Property Organization','ARIPO\r','in use'),('AR','Argentina',NULL,'in use'),('AT','Austria',NULL,'in use'),('AU','Australia',NULL,'in use'),('AW','Aruba',NULL,'in use'),('AZ','Azerbaijan',NULL,'in use'),('BA','Bosnia and Herzegovina',NULL,'in use'),('BB','Barbados',NULL,'in use'),('BD','Bangladesh',NULL,'in use'),('BE','Belgium',NULL,'in use'),('BF','Burkina Faso',NULL,'in use'),('BG','Bulgaria',NULL,'in use'),('BH','Bahrain',NULL,'in use'),('BI','Burundi',NULL,'in use'),('BJ','Benin',NULL,'in use'),('BM','Bermuda',NULL,'in use'),('BN','Brunei Darussalam',NULL,'in use'),('BO','Bolivia',NULL,'in use'),('BR','Brazil',NULL,'in use'),('BS','Bahamas',NULL,'in use'),('BT','Bhutan',NULL,'in use'),('BV','Bouvet Island',NULL,'in use'),('BW','Botswana',NULL,'in use'),('BX','Benelux Trademark and Designs Office','BBM-BBDM\r','in use'),('BY','Belarus',NULL,'in use'),('BZ','Belize',NULL,'in use'),('CA','Canada',NULL,'in use'),('CD','Democratic Republic of the Congo',NULL,'in use'),('CF','Central African Republic',NULL,'in use'),('CG','Congo',NULL,'in use'),('CH','Switzerland',NULL,'in use'),('CI','Côte d’Ivoire',NULL,'in use'),('CK','Cook Islands',NULL,'in use'),('CL','Chile',NULL,'in use'),('CM','Cameroon',NULL,'in use'),('CN','China',NULL,'in use'),('CO','Colombia',NULL,'in use'),('CR','Costa Rica',NULL,'in use'),('CU','Cuba',NULL,'in use'),('CV','Cape Verde',NULL,'in use'),('CY','Cyprus',NULL,'in use'),('CZ','Czech Republic',NULL,'in use'),('DE','Germany (3)',NULL,'in use'),('DJ','Djibouti',NULL,'in use'),('DK','Denmark',NULL,'in use'),('DM','Dominica',NULL,'in use'),('DO','Dominican Republic',NULL,'in use'),('DZ','Algeria',NULL,'in use'),('EA','Eurasian Patent Organization','EAPO\r','in use'),('EC','Ecuador',NULL,'in use'),('EE','Estonia',NULL,'in use'),('EG','Egypt',NULL,'in use'),('EH','Western Sahara','5\r','in use'),('EM','Office for Harmonization in the Internal Market (Trademarks and Designs)','OHIM\r','in use'),('EP','European Patent Office','EPO\r','in use'),('ER','Eritrea',NULL,'in use'),('ES','Spain',NULL,'in use'),('ET','Ethiopia',NULL,'in use'),('FI','Finland',NULL,'in use'),('FJ','Fiji',NULL,'in use'),('FK','Falkland Islands','Malvinas\r','in use'),('FO','Faroe Islands',NULL,'in use'),('FR','France',NULL,'in use'),('GA','Gabon',NULL,'in use'),('GB','United Kingdom',NULL,'in use'),('GC','Patent Office of the Cooperation Council for the Arab States of the Gulf','GCC\r','in use'),('GD','Grenada',NULL,'in use'),('GE','Georgia',NULL,'in use'),('GG','Guernsey',NULL,'in use'),('GH','Ghana',NULL,'in use'),('GI','Gibraltar',NULL,'in use'),('GL','Greenland',NULL,'in use'),('GM','Gambia',NULL,'in use'),('GN','Guinea',NULL,'in use'),('GQ','Equatorial Guinea',NULL,'in use'),('GR','Greece',NULL,'in use'),('GS','South Georgia and the South Sandwich Islands',NULL,'in use'),('GT','Guatemala',NULL,'in use'),('GW','Guinea-Bissau',NULL,'in use'),('GY','Guyana',NULL,'in use'),('HK','The Hong Kong Special Administrative Region of the People\'s Republic of China',NULL,'in use'),('HN','Honduras',NULL,'in use'),('HR','Croatia',NULL,'in use'),('HT','Haiti',NULL,'in use'),('HU','Hungary',NULL,'in use'),('IB','International Bureau of the World Intellectual Property Organization','WIPO\r','in use'),('ID','Indonesia',NULL,'in use'),('IE','Ireland',NULL,'in use'),('IL','Israel',NULL,'in use'),('IM','Isle of Man',NULL,'in use'),('IN','India',NULL,'in use'),('IQ','Iraq',NULL,'in use'),('IR','Iran','Islamic Republic of\r','in use'),('IS','Iceland',NULL,'in use'),('IT','Italy',NULL,'in use'),('JE','Jersey',NULL,'in use'),('JM','Jamaica',NULL,'in use'),('JO','Jordan',NULL,'in use'),('JP','Japan',NULL,'in use'),('KE','Kenya',NULL,'in use'),('KG','Kyrgyzstan',NULL,'in use'),('KH','Cambodia',NULL,'in use'),('KI','Kiribati',NULL,'in use'),('KM','Comoros',NULL,'in use'),('KN','Saint Kitts and Nevis',NULL,'in use'),('KP','Democratic People\'s Republic of Korea',NULL,'in use'),('KR','Republic of Korea',NULL,'in use'),('KW','Kuwait',NULL,'in use'),('KY','Cayman Islands',NULL,'in use'),('KZ','Kazakhstan',NULL,'in use'),('LA','Lao People\'s Democratic Republic',NULL,'in use'),('LB','Lebanon',NULL,'in use'),('LC','Saint Lucia',NULL,'in use'),('LI','Liechtenstein',NULL,'in use'),('LK','Sri Lanka',NULL,'in use'),('LR','Liberia',NULL,'in use'),('LS','Lesotho',NULL,'in use'),('LT','Lithuania',NULL,'in use'),('LU','Luxembourg',NULL,'in use'),('LV','Latvia',NULL,'in use'),('LY','Libyan Arab Jamahiriya',NULL,'in use'),('MA','Morocco',NULL,'in use'),('MC','Monaco',NULL,'in use'),('MD','Republic of Moldova',NULL,'in use'),('ME','Montenegro',NULL,'in use'),('MG','Madagascar',NULL,'in use'),('MK','The former Yugoslav Republic of Macedonia',NULL,'in use'),('ML','Mali',NULL,'in use'),('MM','Myanmar',NULL,'in use'),('MN','Mongolia',NULL,'in use'),('MO','Macao',NULL,'in use'),('MP','Northern Mariana Islands',NULL,'in use'),('MR','Mauritania',NULL,'in use'),('MS','Montserrat',NULL,'in use'),('MT','Malta',NULL,'in use'),('MU','Mauritius',NULL,'in use'),('MV','Maldives',NULL,'in use'),('MW','Malawi',NULL,'in use'),('MX','Mexico',NULL,'in use'),('MY','Malaysia',NULL,'in use'),('MZ','Mozambique',NULL,'in use'),('NA','Namibia',NULL,'in use'),('NE','Niger',NULL,'in use'),('NG','Nigeria',NULL,'in use'),('NI','Nicaragua',NULL,'in use'),('NL','Netherlands',NULL,'in use'),('NO','Norway',NULL,'in use'),('NP','Nepal',NULL,'in use'),('NR','Nauru',NULL,'in use'),('NZ','New Zealand',NULL,'in use'),('OA','African Intellectual Property Organization','OAPI\r','in use'),('OM','Oman',NULL,'in use'),('PA','Panama',NULL,'in use'),('PE','Peru',NULL,'in use'),('PG','Papua New Guinea',NULL,'in use'),('PH','Philippines',NULL,'in use'),('PK','Pakistan',NULL,'in use'),('PL','Poland',NULL,'in use'),('PT','Portugal',NULL,'in use'),('PW','Palau',NULL,'in use'),('PY','Paraguay',NULL,'in use'),('QA','Qatar',NULL,'in use'),('QZ','Community Plant Variety Office (European Community)','CPVO\r','in use'),('RO','Romania',NULL,'in use'),('RS','Serbia',NULL,'in use'),('RU','Russian Federation',NULL,'in use'),('RW','Rwanda',NULL,'in use'),('SA','Saudi Arabia',NULL,'in use'),('SB','Solomon Islands',NULL,'in use'),('SC','Seychelles',NULL,'in use'),('SD','Sudan',NULL,'in use'),('SE','Sweden',NULL,'in use'),('SG','Singapore',NULL,'in use'),('SH','Saint Helena',NULL,'in use'),('SI','Slovenia',NULL,'in use'),('SK','Slovakia',NULL,'in use'),('SL','Sierra Leone',NULL,'in use'),('SM','San Marino',NULL,'in use'),('SN','Senegal',NULL,'in use'),('SO','Somalia',NULL,'in use'),('SR','Suriname',NULL,'in use'),('ST','Sao Tome and Principe',NULL,'in use'),('SV','El Salvador',NULL,'in use'),('SY','Syrian Arab Republic',NULL,'in use'),('SZ','Swaziland',NULL,'in use'),('TC','Turks and Caicos Islands',NULL,'in use'),('TD','Chad',NULL,'in use'),('TG','Togo',NULL,'in use'),('TH','Thailand',NULL,'in use'),('TJ','Tajikistan',NULL,'in use'),('TL','Timor-Leste',NULL,'in use'),('TM','Turkmenistan',NULL,'in use'),('TN','Tunisia',NULL,'in use'),('TO','Tonga',NULL,'in use'),('TR','Turkey',NULL,'in use'),('TT','Trinidad and Tobago',NULL,'in use'),('TV','Tuvalu',NULL,'in use'),('TW','Taiwan -  Province of China',NULL,'in use'),('TZ','United Republic of Tanzania',NULL,'in use'),('UA','Ukraine',NULL,'in use'),('UG','Uganda',NULL,'in use'),('US','United States of America',NULL,'in use'),('UY','Uruguay',NULL,'in use'),('UZ','Uzbekistan',NULL,'in use'),('VA','Holy See',NULL,'in use'),('VC','Saint Vincent and the Grenadines',NULL,'in use'),('VE','Venezuela',NULL,'in use'),('VG','Virgin Islands','British\r','in use'),('VN','Viet Nam',NULL,'in use'),('VU','Vanuatu',NULL,'in use'),('WO','World Intellectual Property Organization (International Bureau of)','WIPO\r','in use'),('WS','Samoa',NULL,'in use'),('YE','Yemen',NULL,'in use'),('ZA','South Africa',NULL,'in use'),('ZM','Zambia',NULL,'in use'),('ZW','Zimbabwe',NULL,'in use'),('CS','Serbia and Montenegro',NULL,'deprecate'),('ZZ','Unknown',NULL,'unknown'),('11','Unknown',NULL,'deprecate'),('AA','Unknown',NULL,'deprecate'),('DD','German Democratic Republic',NULL,'deprecate'),('RE','Unknown',NULL,'deprecate'),('RH','Unknown',NULL,'deprecate'),('SU','Soviet Union',NULL,'deprecate'),('TP','Unknown',NULL,'deprecate'),('U9','Unknown',NULL,'deprecate'),('W0','Unknown',NULL,'deprecate'),('XH','Unknown',NULL,'deprecate'),('XP','Unknown',NULL,'deprecate'),('YU','Yugoslavia',NULL,'deprecate'),('ZR','Unknown',NULL,'deprecate');
/*!40000 ALTER TABLE `nomen_appln_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 't_juan'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-04 11:19:03
