-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: GameStation
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `app_settings`
--

DROP TABLE IF EXISTS `app_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_settings` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор записи',
  `setting_key` varchar(45) NOT NULL,
  `setting_value` enum('main','best','popular','expected') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_settings`
--

LOCK TABLES `app_settings` WRITE;
/*!40000 ALTER TABLE `app_settings` DISABLE KEYS */;
INSERT INTO `app_settings` VALUES (2,'slider_news','popular','Мод для слайдера новостей'),(3,'slider_games','best','Мод для слайдера игр');
/*!40000 ALTER TABLE `app_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_categories`
--

DROP TABLE IF EXISTS `article_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_categories` (
  `idCategory` int NOT NULL AUTO_INCREMENT,
  `name` varchar(90) NOT NULL,
  PRIMARY KEY (`idCategory`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_categories`
--

LOCK TABLES `article_categories` WRITE;
/*!40000 ALTER TABLE `article_categories` DISABLE KEYS */;
INSERT INTO `article_categories` VALUES (1,'Обзор'),(2,'Подборка');
/*!40000 ALTER TABLE `article_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles` (
  `idArticle` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `score` decimal(10,1) DEFAULT NULL,
  `views` int NOT NULL DEFAULT '0',
  `comments` int NOT NULL DEFAULT '0',
  `status_id` int NOT NULL DEFAULT '1',
  `category_id` int DEFAULT NULL,
  `game_id` int DEFAULT NULL,
  `author_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idArticle`),
  KEY `fk_article_user` (`author_id`),
  KEY `fk_article_game` (`game_id`),
  KEY `fk_article_status` (`status_id`),
  KEY `fk_article_category` (`category_id`) USING BTREE,
  CONSTRAINT `fk_article_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`),
  CONSTRAINT `fk_article_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`),
  CONSTRAINT `fk_article_type` FOREIGN KEY (`category_id`) REFERENCES `article_categories` (`idCategory`),
  CONSTRAINT `fk_article_user` FOREIGN KEY (`author_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brands` (
  `idBrand` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idBrand`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brands`
--

LOCK TABLES `brands` WRITE;
/*!40000 ALTER TABLE `brands` DISABLE KEYS */;
INSERT INTO `brands` VALUES (5,'Apple'),(6,'Atari'),(7,'Commodore'),(2,'Microsoft'),(3,'Nintendo'),(4,'Sega'),(1,'Sony');
/*!40000 ALTER TABLE `brands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `idComment` int NOT NULL AUTO_INCREMENT COMMENT 'Индентификатор комментария',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Контент комментария',
  `entity_type` enum('news','article','review','question') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Тип сущности к которой комментарий',
  `entity_id` int NOT NULL COMMENT 'Идентификатор самой сущности',
  `user_id` int NOT NULL COMMENT 'Идентификато пользователя',
  `parent_comment_id` int DEFAULT NULL COMMENT 'Идентификатор родительского комментария',
  `moderated_by` int DEFAULT NULL COMMENT 'Идентификатор модератора',
  `moderation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Причина модерации',
  `status_id` int NOT NULL DEFAULT '7' COMMENT 'Статус модерации',
  `flags_count` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания комментария',
  PRIMARY KEY (`idComment`),
  KEY `fk_comments_user` (`user_id`),
  KEY `idx_comment` (`entity_type`,`entity_id`),
  KEY `fk_comments_moderated_by` (`moderated_by`),
  KEY `fk_comment_status` (`status_id`),
  CONSTRAINT `fk_comment_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`),
  CONSTRAINT `fk_comments_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_comment_insert` AFTER INSERT ON `comments` FOR EACH ROW BEGIN
    IF NEW.status_id = 7 THEN
        CASE NEW.entity_type
            WHEN 'news' THEN
                UPDATE news SET comments = comments + 1 WHERE idNew = NEW.entity_id;
            WHEN 'theme' THEN
                UPDATE questions SET comments = comments + 1 WHERE idQuestion = NEW.entity_id;
            WHEN 'article' THEN
                UPDATE articles SET comments = comments + 1 WHERE idArticle = NEW.entity_id;
            WHEN 'review' THEN
                UPDATE reviews SET comments = comments + 1 WHERE idReview = NEW.entity_id;
        END CASE;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_comment_update` AFTER UPDATE ON `comments` FOR EACH ROW BEGIN
    DECLARE diff INT;
    
    IF OLD.status_id != NEW.status_id THEN
        IF NEW.status_id = 7 THEN
            SET diff = 1;
        ELSEIF OLD.status_id = 7 THEN
            SET diff = -1;
        ELSE
            SET diff = 0;
        END IF;

        IF diff != 0 THEN
            CASE NEW.entity_type
                WHEN 'news' THEN
                    UPDATE news SET comments = comments + diff WHERE idNew = NEW.entity_id;
                WHEN 'theme' THEN
                    UPDATE questions SET comments = comments + diff WHERE idQuestion = NEW.entity_id;
                WHEN 'article' THEN
                    UPDATE Articles SET comments = comments + diff WHERE idArticle = NEW.entity_id;
                WHEN 'review' THEN
                    UPDATE reviews SET comments = comments + diff WHERE idReview = NEW.entity_id;
            END CASE;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_comment_delete` AFTER DELETE ON `comments` FOR EACH ROW BEGIN
    IF OLD.status_id = 7 THEN
    
        CASE OLD.entity_type
        
            WHEN 'news' THEN
                UPDATE news
                SET comments = comments - 1
                WHERE idNew = OLD.entity_id;
            
            WHEN 'article' THEN
                UPDATE articles 
                SET comments = comments - 1 
                WHERE idArticle = OLD.entity_id;
                
            WHEN 'theme' THEN
                UPDATE questions 
                SET comments = comments - 1 
                WHERE idQuestion = OLD.entity_id;
                
            WHEN 'review' THEN
                UPDATE Reviews 
                SET comments = comments - 1 
                WHERE idReview = OLD.entity_id;
                
        END CASE;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `idCompany` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idCompany`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (69,'Reissad Studio','companies/logos/reissad_studio-logo.png','2026-09-22 17:53:43'),(70,'id Software','companies/logos/id_software-logo.png','2026-09-22 18:04:02'),(71,'Panic Button Games','companies/logos/panic_button_games-logo.png','2026-09-22 18:04:02'),(72,'Overkill Software','companies/logos/overkill_software-logo.png','2026-09-23 10:51:13'),(73,'Starbreeze Studios','companies/logos/starbreeze_studios-logo.png','2026-09-23 10:51:13'),(74,'EA Digital Illusions CE','companies/logos/ea_digital_illusions_ce-logo.png','2026-09-23 12:09:28'),(75,'Electronic Arts','companies/logos/electronic_arts-logo.png','2026-09-23 12:09:28'),(76,'505 Games','companies/logos/505_games-logo.png','2026-09-23 12:11:46'),(77,'Slipgate Ironworks','companies/logos/slipgate_ironworks-logo.png','2026-09-23 12:11:46'),(78,'Focus Entertainment','companies/logos/focus_entertainment-logo.png','2026-09-23 12:11:56'),(79,'Flying Wild Hog','companies/logos/flying_wild_hog-logo.png','2026-09-23 12:11:56'),(80,'Ubisoft Red Storm',NULL,'2026-09-23 12:12:06'),(81,'Massive Entertainment','companies/logos/massive_entertainment-logo.png','2026-09-23 12:12:06'),(82,'Eidos Interactive','companies/logos/eidos_interactive-logo.png','2026-09-23 12:15:10'),(83,'Full Fat','companies/logos/full_fat-logo.png','2026-09-23 12:15:10'),(84,'Shochiku','companies/logos/shochiku-logo.png','2026-09-23 12:15:58'),(85,'AIHASTO',NULL,'2026-09-23 12:15:58'),(86,'Build a Rocket Boy','companies/logos/build_a_rocket_boy-logo.png','2026-09-23 12:17:26'),(87,'22nd Century Toys','companies/logos/22nd_century_toys-logo.png','2026-09-23 12:18:05'),(88,'Devolver Digital','companies/logos/devolver_digital-logo.png','2026-09-23 12:18:05'),(89,'Hazelight Studios','companies/logos/hazelight_studios-logo.png','2026-09-23 12:19:24'),(90,'Fumi Games','companies/logos/fumi_games-logo.png','2026-09-23 12:20:20'),(91,'PlaySide','companies/logos/playside-logo.png','2026-09-23 12:20:20'),(92,'Trioskaz','companies/logos/trioskaz-logo.png','2026-09-23 12:35:22'),(93,'Critical Reflex','companies/logos/critical_reflex-logo.png','2026-09-23 12:35:22'),(94,'Ghost Games','companies/logos/ghost_games-logo.png','2026-09-23 12:41:29'),(95,'Zeekerss','companies/logos/zeekerss-logo.png','2026-09-23 12:43:08'),(96,'semiwork','companies/logos/semiwork-logo.png','2026-09-23 12:44:18'),(97,'Supermassive Games','companies/logos/supermassive_games-logo.png','2026-09-23 12:47:47'),(98,'Sony Computer Entertainment','companies/logos/sony_computer_entertainment-logo.png','2026-09-23 12:47:47'),(99,'ColdWood Interactive','companies/logos/coldwood_interactive-logo.png','2026-09-23 12:48:49'),(100,'Nikita Kryukov',NULL,'2026-09-23 12:49:57'),(101,'MAHOUMAIDEN',NULL,'2026-09-23 12:49:57'),(102,'Giant Squid','companies/logos/giant_squid-logo.png','2026-09-23 12:51:47'),(103,'E-Line Media','companies/logos/e_line_media-logo.png','2026-09-23 12:54:03'),(104,'Deep Field Games','companies/logos/deep_field_games-logo.png','2026-09-23 12:56:38'),(105,'Playstack','companies/logos/playstack-logo.png','2026-09-23 12:56:38'),(106,'City Interactive S.A.','companies/logos/city_interactive_s_a-logo.png','2026-09-23 12:58:28'),(107,'SandCastles Studio','companies/logos/sandcastles_studio-logo.png','2026-09-23 12:59:08'),(108,'Apogee Entertainment','companies/logos/apogee_entertainment-logo.png','2026-09-23 12:59:09'),(109,'Mike Klubnika','companies/logos/mike_klubnika-logo.png','2026-09-23 12:59:46'),(110,'Voids Within',NULL,'2026-09-23 13:03:34'),(111,'UNIKAT Label','companies/logos/unikat_label-logo.png','2026-09-23 13:03:34'),(112,'Morefun Studio Group','companies/logos/morefun_studio_group-logo.png','2026-09-23 13:06:35'),(113,'Battlestate Games','companies/logos/battlestate_games-logo.png','2026-09-23 13:09:54'),(114,'Dennaton Games','companies/logos/dennaton_games-logo.png','2026-09-23 13:16:21'),(115,'Spike Chunsoft','companies/logos/spike_chunsoft-logo.png','2026-09-23 13:16:36'),(116,'Midway Games','companies/logos/midway_games-logo.png','2026-09-23 13:21:17'),(117,'Sylum Entertainment',NULL,'2026-09-23 13:21:17'),(118,'Valve','companies/logos/valve-logo.png','2026-09-23 13:22:14'),(119,'Certain Affinity','companies/logos/certain_affinity-logo.png','2026-09-23 13:22:14'),(120,'Turtle Rock Studios','companies/logos/turtle_rock_studios-logo.png','2026-09-23 13:22:26'),(121,'Sloclap','companies/logos/sloclap-logo.png','2026-09-23 13:41:23'),(122,'Kepler Interactive','companies/logos/kepler_interactive-logo.png','2026-09-23 13:41:23'),(123,'Vivendi Universal','companies/logos/vivendi_universal-logo.png','2026-09-23 13:41:31'),(124,'Sierra Entertainment','companies/logos/sierra_entertainment-logo.png','2026-09-23 13:41:31'),(125,'E-Frontier',NULL,'2026-09-23 13:43:05'),(126,'Legacy Interactive','companies/logos/legacy_interactive-logo.png','2026-09-23 13:43:05'),(127,'Microsoft Studios','companies/logos/microsoft_studios-logo.png','2026-09-23 13:43:23'),(128,'Nordic Games Publishing','companies/logos/nordic_games_publishing-logo.png','2026-09-23 13:43:23'),(129,'System Era Softworks','companies/logos/system_era_softworks-logo.png','2026-09-23 13:47:47'),(130,'Warner Bros. Interactive Entertainment',NULL,'2026-09-23 13:51:47'),(131,'Studio MDHR','companies/logos/studio_mdhr-logo.png','2026-09-23 13:53:02'),(132,'Landfall Games','companies/logos/landfall_games-logo.png','2026-09-23 13:55:03'),(133,'Zorro',NULL,'2026-09-23 13:55:03'),(134,'SadSquare Studio','companies/logos/sadsquare_studio-logo.png','2026-09-23 14:01:20'),(135,'Iron Gate Studios','companies/logos/iron_gate_studios-logo.png','2026-09-23 14:01:39'),(136,'Fishlabs','companies/logos/fishlabs-logo.png','2026-09-23 14:01:39'),(137,'Catobyte','companies/logos/catobyte-logo.png','2026-09-23 14:04:15'),(138,'Bandai Namco Entertainment','companies/logos/bandai_namco_entertainment-logo.png','2026-09-23 14:07:36'),(139,'United Front Games','companies/logos/united_front_games-logo.png','2026-09-23 14:07:36'),(140,'The Chinese Room','companies/logos/the_chinese_room-logo.png','2026-09-23 14:11:52'),(141,'Secret Mode','companies/logos/secret_mode-logo.png','2026-09-23 14:11:52'),(142,'Crytek Frankfurt','companies/logos/crytek_frankfurt-logo.png','2026-09-23 14:22:01'),(143,'Crytek','companies/logos/crytek-logo.png','2026-09-23 14:22:01'),(144,'Ubisoft Montreal','companies/logos/ubisoft_montreal-logo.png','2026-09-23 14:22:08'),(145,'Ubisoft Entertainment','companies/logos/ubisoft_entertainment-logo.png','2026-09-23 14:22:08'),(146,'Campo Santo','companies/logos/campo_santo-logo.png','2026-09-23 14:34:30'),(147,'Panic','companies/logos/panic-logo.png','2026-09-23 14:34:30'),(148,'Endnight Games Ltd','companies/logos/endnight_games_ltd-logo.png','2026-09-23 14:47:24'),(149,'Newnight',NULL,'2026-09-23 14:49:46'),(150,'Rockstar Games','companies/logos/rockstar_games-logo.png','2026-09-23 14:53:52'),(151,'Take-Two Interactive','companies/logos/take_two_interactive-logo.png','2026-09-23 14:53:52'),(152,'Ubisoft Reflections','companies/logos/ubisoft_reflections-logo.png','2026-09-23 14:55:21'),(153,'Ivory Tower','companies/logos/ivory_tower-logo.png','2026-09-23 14:55:22'),(154,'Asobo Studio','companies/logos/asobo_studio-logo.png','2026-09-23 14:56:26'),(155,'Vector3 Studio',NULL,'2026-09-23 14:59:28'),(156,'Gearbox Publishing','companies/logos/gearbox_publishing-logo.png','2026-09-23 14:59:57'),(157,'Unknown Worlds Entertainment','companies/logos/unknown_worlds_entertainment-logo.png','2026-09-23 15:05:30'),(158,'THQ','companies/logos/thq-logo.png','2026-09-23 15:06:13'),(159,'GSC World Publishing','companies/logos/gsc_world_publishing-logo.png','2026-09-23 15:06:13'),(160,'GSC Game World','companies/logos/gsc_game_world-logo.png','2026-09-23 15:22:13'),(161,'Deep Silver','companies/logos/deep_silver-logo.png','2026-09-23 15:22:13'),(162,'Zoo Corporation','companies/logos/zoo_corporation-logo.png','2026-09-23 15:27:10'),(163,'4A Games','companies/logos/4a_games-logo.png','2026-09-23 15:34:08'),(164,'Koch Media','companies/logos/koch_media-logo.png','2026-09-23 15:34:22'),(165,'Illusion Softworks','companies/logos/illusion_softworks-logo.png','2026-09-23 17:42:53'),(166,'Gathering of Developers','companies/logos/gathering_of_developers-logo.png','2026-09-23 17:42:53'),(167,'2K Games','companies/logos/2k_games-logo.png','2026-09-23 17:47:56'),(168,'Hangar 13','companies/logos/hangar_13-logo.png','2026-09-23 17:54:05'),(169,'2K','companies/logos/2k-logo.png','2026-09-23 17:54:05'),(170,'Sowoke Entertainment Bureau','companies/logos/sowoke_entertainment_bureau-logo.png','2026-09-23 18:01:59'),(171,'Marevo Collective','companies/logos/marevo_collective-logo.png','2026-09-23 18:01:59'),(172,'Red Barrels','companies/logos/red_barrels-logo.png','2026-09-23 18:03:13'),(173,'SKH Apps','companies/logos/skh_apps-logo.png','2026-09-23 18:10:06'),(174,'Shawn Hitchcock',NULL,'2026-09-23 18:10:06'),(175,'Platypus Entertainment',NULL,'2026-09-23 18:12:31'),(176,'Ytopia',NULL,'2026-09-23 18:12:31'),(177,'EXBO',NULL,'2026-09-24 11:25:00'),(178,'Frictional Games','companies/logos/frictional_games-logo.png','2026-09-24 11:59:21'),(179,'Techmoon',NULL,'2026-09-24 12:00:45'),(180,'Mediatonic','companies/logos/mediatonic-logo.png','2026-09-24 12:01:37'),(181,'Epic Games','companies/logos/epic_games-logo.png','2026-09-24 12:01:37'),(182,'Behaviour Santiago',NULL,'2026-09-24 12:01:53'),(183,'Bethesda Softworks','companies/logos/bethesda_softworks-logo.png','2026-09-24 12:01:53'),(184,'Liquid Donkey Games',NULL,'2026-09-24 12:02:57'),(185,'Feral Interactive','companies/logos/feral_interactive-logo.png','2026-09-24 12:03:51'),(186,'Avalanche Studios','companies/logos/avalanche_studios-logo.png','2026-09-24 12:03:51'),(187,'CyberFront','companies/logos/cyberfront-logo.png','2026-09-24 12:08:27'),(188,'Gearbox Software','companies/logos/gearbox_software-logo.png','2026-09-24 12:11:45'),(189,'2K Australia','companies/logos/2k_australia-logo.png','2026-09-24 12:15:00'),(190,'Team Psykskallar','companies/logos/team_psykskallar-logo.png','2026-09-24 12:16:13'),(191,'Ultimate Games S.A.','companies/logos/ultimate_games_s_a-logo.png','2026-09-24 12:21:56'),(192,'CookieDev','companies/logos/cookiedev-logo.png','2026-09-24 12:21:56'),(193,'3D Realms','companies/logos/3d_realms-logo.png','2026-09-24 12:22:58'),(194,'Tacty Studio','companies/logos/tacty_studio-logo.png','2026-09-24 12:24:09'),(195,'Klei Entertainment','companies/logos/klei_entertainment-logo.png','2026-09-24 12:25:13'),(196,'Techland','companies/logos/techland-logo.png','2026-09-24 12:25:39'),(197,'Techland Publishing',NULL,'2026-09-24 12:46:53'),(198,'Coffee Stain Publishing','companies/logos/coffee_stain_publishing-logo.png','2026-09-24 13:10:36'),(199,'Ghost Ship Games','companies/logos/ghost_ship_games-logo.png','2026-09-24 13:10:36'),(200,'Sony Interactive Entertainment','companies/logos/sony_interactive_entertainment-logo.png','2026-09-24 13:12:48'),(201,'Insomniac Games','companies/logos/insomniac_games-logo.png','2026-09-24 13:12:48'),(202,'Aspyr Media','companies/logos/aspyr_media-logo.png','2026-09-24 13:24:22'),(203,'Digital Illusions CE: Canada',NULL,'2026-09-24 13:24:26'),(204,'Digital Illusions CE','companies/logos/digital_illusions_ce-logo.png','2026-09-24 13:24:33'),(205,'Square Enix','companies/logos/square_enix-logo.png','2026-09-24 13:28:23'),(206,'High Voltage Software','companies/logos/high_voltage_software-logo.png','2026-09-24 13:30:05'),(207,'Facepunch Studios','companies/logos/facepunch_studios-logo.png','2026-09-24 13:33:26'),(208,'LostOneTeam',NULL,'2026-09-24 13:35:32'),(209,'Blacklight Interactive','companies/logos/blacklight_interactive-logo.png','2026-09-24 13:35:45'),(210,'Team17','companies/logos/team17-logo.png','2026-09-24 13:35:45'),(211,'Creepy Jar','companies/logos/creepy_jar-logo.png','2026-09-24 13:36:02'),(212,'Forever Entertainment S.A.','companies/logos/forever_entertainment_s_a-logo.png','2026-09-24 13:36:02'),(213,'Obsidian Entertainment','companies/logos/obsidian_entertainment-logo.png','2026-09-24 13:36:39'),(214,'Xbox Game Studios','companies/logos/xbox_game_studios-logo.png','2026-09-24 13:36:39'),(215,'Movie Games S.A.','companies/logos/movie_games_s_a-logo.png','2026-09-24 13:38:56'),(216,'Drago Entertainment',NULL,'2026-09-24 13:38:56'),(217,'Shatterline Productions',NULL,'2026-09-24 13:39:33'),(218,'Iceberg Interactive','companies/logos/iceberg_interactive-logo.png','2026-09-24 13:39:38'),(219,'Mojang Studios','companies/logos/mojang_studios-logo.png','2026-09-24 13:41:20'),(220,'Skybox Labs','companies/logos/skybox_labs-logo.png','2026-09-24 13:41:20'),(221,'NetherRealm Studios','companies/logos/netherrealm_studios-logo.png','2026-09-24 13:42:10'),(222,'WB Games','companies/logos/wb_games-logo.png','2026-09-24 13:42:10'),(223,'Shiver Entertainment','companies/logos/shiver_entertainment-logo.png','2026-09-24 13:42:26'),(224,'Crytek Budapest',NULL,'2026-09-24 13:47:10');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `idFavorite` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `game_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idFavorite`),
  UNIQUE KEY `user_id` (`user_id`,`game_id`),
  KEY `game_id` (`game_id`),
  KEY `idx_favorites_user_game` (`user_id`,`game_id`),
  CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE,
  CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friends`
--

DROP TABLE IF EXISTS `friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friends` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `friend_id` int NOT NULL,
  `status_id` int NOT NULL DEFAULT '2',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user` (`user_id`),
  KEY `fk_friend` (`friend_id`),
  KEY `fk_friend_status` (`status_id`),
  KEY `idx_friends_user_friend_status` (`user_id`,`friend_id`,`status_id`),
  CONSTRAINT `fk_friend` FOREIGN KEY (`friend_id`) REFERENCES `users` (`idUser`),
  CONSTRAINT `fk_friend_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`),
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friends`
--

LOCK TABLES `friends` WRITE;
/*!40000 ALTER TABLE `friends` DISABLE KEYS */;
INSERT INTO `friends` VALUES (82,34,36,3,'2026-09-11 14:47:23');
/*!40000 ALTER TABLE `friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_genres`
--

DROP TABLE IF EXISTS `game_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_genres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_game` (`game_id`),
  KEY `fk_genre` (`genre_id`),
  CONSTRAINT `fk_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`idGenre`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=543 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_genres`
--

LOCK TABLES `game_genres` WRITE;
/*!40000 ALTER TABLE `game_genres` DISABLE KEYS */;
INSERT INTO `game_genres` VALUES (243,1321,13),(244,1321,15),(245,1321,32),(246,1322,5),(247,1322,31),(248,1323,5),(249,1323,12),(250,1323,24),(251,1324,5),(252,1324,13),(253,1324,15),(254,1325,5),(255,1326,5),(256,1326,8),(257,1326,31),(258,1327,5),(259,1327,25),(260,1327,31),(261,1328,5),(262,1328,12),(263,1328,15),(264,1328,24),(265,1328,31),(266,1329,25),(267,1329,31),(268,1330,31),(269,1330,32),(270,1331,5),(271,1331,31),(272,1332,5),(273,1332,8),(274,1332,31),(275,1332,32),(276,1332,33),(277,1333,8),(278,1333,9),(279,1333,31),(280,1334,5),(281,1334,31),(282,1334,32),(283,1335,13),(284,1335,32),(285,1336,10),(286,1336,14),(287,1337,32),(288,1338,15),(289,1338,32),(294,1340,31),(295,1341,8),(296,1341,9),(297,1341,31),(298,1342,31),(299,1342,32),(300,1342,34),(301,1343,9),(302,1343,31),(303,1343,32),(304,1344,13),(305,1344,31),(306,1344,32),(307,1345,31),(308,1346,5),(309,1346,12),(310,1346,13),(311,1346,31),(312,1346,32),(313,1347,5),(314,1348,8),(315,1348,32),(316,1349,13),(317,1349,15),(318,1349,32),(319,1350,13),(320,1350,15),(321,1350,32),(322,1351,5),(323,1351,15),(324,1351,24),(325,1352,5),(326,1352,12),(327,1352,13),(328,1352,24),(329,1354,5),(330,1354,32),(331,1354,33),(332,1355,5),(333,1355,32),(334,1355,33),(335,1356,5),(336,1357,5),(337,1358,5),(338,1359,25),(339,1359,32),(340,1360,5),(341,1360,15),(342,1360,24),(343,1361,5),(344,1361,31),(345,1362,5),(346,1362,31),(347,1363,13),(348,1363,31),(349,1363,32),(350,1365,5),(351,1366,5),(352,1366,8),(353,1366,31),(354,1366,32),(355,1366,33),(356,1367,31),(357,1367,32),(358,1368,9),(359,1368,13),(360,1368,31),(361,1368,32),(362,1369,12),(363,1369,31),(364,1369,32),(365,1370,13),(366,1370,31),(367,1370,32),(368,1371,32),(369,1371,33),(370,1372,5),(371,1372,25),(372,1372,31),(373,1373,31),(374,1373,32),(375,1374,5),(376,1375,5),(377,1375,31),(378,1376,31),(379,1376,32),(380,1377,9),(381,1377,13),(382,1377,31),(383,1377,32),(384,1378,13),(385,1378,31),(386,1378,32),(390,1380,10),(391,1380,31),(392,1381,10),(393,1382,32),(394,1383,31),(395,1383,32),(396,1384,31),(397,1384,32),(398,1385,5),(399,1385,12),(400,1386,5),(401,1386,12),(407,1392,5),(408,1392,12),(409,1392,31),(410,1393,5),(411,1393,12),(412,1393,31),(413,1394,5),(414,1394,31),(415,1395,8),(416,1395,9),(417,1395,31),(418,1396,4),(419,1396,5),(420,1396,10),(421,1396,31),(422,1397,5),(423,1397,10),(424,1397,31),(425,1398,5),(426,1398,31),(427,1401,9),(428,1401,31),(429,1401,32),(430,1402,31),(431,1402,32),(432,1403,31),(433,1403,32),(434,1404,31),(435,1404,32),(436,1405,13),(437,1405,15),(438,1405,31),(439,1405,32),(440,1406,5),(441,1406,13),(442,1406,31),(443,1406,32),(444,1407,5),(445,1407,12),(446,1407,31),(447,1408,9),(448,1408,31),(449,1408,32),(451,1410,8),(452,1410,10),(453,1410,32),(454,1411,12),(455,1411,13),(456,1411,15),(457,1412,5),(458,1412,32),(459,1413,10),(460,1413,25),(461,1413,31),(462,1414,5),(463,1414,12),(464,1415,5),(465,1415,12),(466,1416,5),(467,1416,12),(468,1417,5),(469,1417,31),(470,1417,32),(471,1418,13),(472,1418,32),(473,1419,9),(475,1421,10),(476,1421,13),(477,1421,31),(478,1421,32),(479,1422,13),(480,1422,15),(481,1422,31),(482,1422,32),(483,1423,5),(484,1423,12),(485,1423,31),(486,1424,12),(487,1424,31),(488,1425,12),(489,1425,31),(490,1426,5),(491,1426,31),(492,1426,32),(493,1427,25),(494,1427,31),(495,1428,25),(496,1428,31),(497,1429,5),(498,1430,5),(499,1431,5),(500,1432,5),(501,1433,5),(502,1435,5),(503,1435,10),(504,1435,31),(505,1436,5),(506,1436,31),(507,1437,5),(508,1437,12),(509,1437,31),(510,1437,32),(511,1438,32),(512,1439,13),(513,1439,14),(514,1439,15),(515,1439,24),(516,1439,32),(517,1440,13),(518,1440,15),(519,1440,31),(520,1440,32),(521,1441,12),(522,1441,31),(523,1442,13),(524,1442,32),(527,1444,13),(528,1444,32),(529,1445,5),(530,1445,32),(531,1446,5),(532,1447,13),(533,1447,31),(534,1447,33),(535,1448,4),(536,1449,4),(537,1450,5),(538,1450,31),(539,1451,5),(540,1451,31),(541,1452,5),(542,1452,31);
/*!40000 ALTER TABLE `game_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_modes`
--

DROP TABLE IF EXISTS `game_modes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_modes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `mode_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_gameMode` (`game_id`),
  KEY `fk_mode` (`mode_id`),
  CONSTRAINT `fk_gameMode` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_mode` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`idMode`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=482 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_modes`
--

LOCK TABLES `game_modes` WRITE;
/*!40000 ALTER TABLE `game_modes` DISABLE KEYS */;
INSERT INTO `game_modes` VALUES (225,1321,2),(226,1322,1),(227,1323,1),(228,1323,2),(229,1323,3),(230,1324,1),(231,1324,2),(232,1326,1),(233,1327,1),(234,1327,2),(235,1327,3),(236,1328,1),(237,1328,2),(238,1328,3),(239,1328,5),(240,1329,1),(241,1330,1),(242,1331,1),(243,1331,2),(244,1332,1),(245,1333,2),(246,1333,3),(247,1333,4),(248,1334,1),(249,1335,1),(250,1336,1),(251,1336,2),(252,1336,3),(253,1337,1),(254,1337,2),(255,1337,3),(256,1338,1),(257,1338,2),(258,1338,3),(260,1340,1),(261,1341,1),(262,1341,2),(263,1341,3),(264,1342,1),(265,1343,1),(266,1344,1),(267,1345,2),(268,1345,3),(269,1345,4),(270,1346,1),(271,1346,2),(272,1346,3),(273,1347,1),(274,1348,1),(275,1348,2),(276,1348,3),(277,1349,1),(278,1349,2),(279,1350,1),(280,1351,2),(281,1351,3),(282,1351,5),(283,1352,1),(284,1352,2),(285,1352,3),(286,1352,5),(287,1354,1),(288,1355,1),(289,1356,1),(290,1356,2),(291,1357,1),(292,1357,2),(293,1357,3),(294,1358,1),(295,1358,2),(296,1358,3),(297,1359,1),(298,1360,1),(299,1360,2),(300,1360,3),(301,1361,1),(302,1362,1),(303,1363,1),(304,1363,2),(305,1363,3),(306,1365,1),(307,1365,2),(308,1365,3),(309,1366,1),(310,1366,2),(311,1366,3),(312,1367,1),(313,1367,3),(314,1368,1),(315,1369,1),(316,1369,2),(317,1369,3),(318,1370,1),(319,1370,2),(320,1370,3),(321,1371,1),(322,1371,2),(323,1371,3),(324,1372,1),(325,1373,1),(326,1374,1),(327,1374,2),(328,1375,1),(329,1375,2),(330,1376,1),(331,1377,1),(332,1377,2),(333,1377,3),(334,1378,1),(335,1378,2),(336,1378,3),(340,1380,1),(341,1380,2),(342,1380,3),(343,1380,5),(344,1381,1),(345,1381,2),(346,1381,3),(347,1381,5),(348,1382,1),(349,1382,2),(350,1382,3),(351,1383,1),(352,1384,1),(353,1385,1),(354,1385,2),(355,1386,1),(356,1386,2),(359,1392,1),(360,1393,1),(361,1394,1),(362,1395,1),(363,1396,1),(364,1397,1),(365,1398,1),(366,1401,1),(367,1402,1),(368,1403,1),(369,1404,1),(370,1405,1),(371,1405,2),(372,1405,3),(373,1406,1),(374,1406,2),(375,1406,3),(376,1407,2),(377,1407,3),(378,1407,5),(379,1408,1),(381,1410,2),(382,1410,3),(383,1410,6),(384,1411,1),(385,1412,1),(386,1412,2),(387,1412,3),(388,1413,1),(389,1414,1),(390,1414,2),(391,1414,3),(392,1414,4),(393,1415,1),(394,1415,2),(395,1415,3),(396,1415,4),(397,1416,1),(398,1416,2),(399,1416,3),(400,1417,1),(401,1417,2),(402,1417,3),(403,1418,1),(404,1418,2),(405,1418,3),(406,1419,1),(408,1421,1),(409,1421,2),(410,1421,3),(411,1422,1),(412,1422,2),(413,1422,3),(414,1423,1),(415,1423,2),(416,1423,3),(417,1424,1),(418,1424,2),(419,1424,3),(420,1425,1),(421,1425,2),(422,1425,3),(423,1426,1),(424,1426,2),(425,1426,3),(426,1427,1),(427,1428,1),(428,1429,1),(429,1429,2),(430,1430,1),(431,1430,2),(432,1431,1),(433,1431,2),(434,1432,1),(435,1432,2),(436,1433,1),(437,1433,2),(438,1435,1),(439,1435,2),(440,1435,3),(441,1436,1),(442,1436,2),(443,1436,3),(444,1437,2),(445,1437,3),(446,1437,5),(447,1438,1),(448,1438,2),(449,1438,3),(450,1439,1),(451,1439,2),(452,1440,1),(453,1440,2),(454,1440,3),(455,1441,1),(456,1441,2),(457,1441,3),(458,1442,1),(459,1442,2),(460,1442,3),(461,1444,1),(462,1445,1),(463,1445,2),(464,1445,3),(465,1446,1),(466,1446,2),(467,1446,3),(468,1447,1),(469,1447,2),(470,1447,3),(471,1447,4),(472,1447,5),(473,1448,1),(474,1448,2),(475,1449,1),(476,1449,2),(477,1450,1),(478,1450,2),(479,1451,1),(480,1452,1),(481,1452,2);
/*!40000 ALTER TABLE `game_modes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_perspectives`
--

DROP TABLE IF EXISTS `game_perspectives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_perspectives` (
  `id` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `perspective_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_gamePerspective` (`game_id`),
  KEY `fk_perspective` (`perspective_id`),
  CONSTRAINT `fk_gamePerspective` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_perspective` FOREIGN KEY (`perspective_id`) REFERENCES `perspectives` (`idPerspective`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=269 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_perspectives`
--

LOCK TABLES `game_perspectives` WRITE;
/*!40000 ALTER TABLE `game_perspectives` DISABLE KEYS */;
INSERT INTO `game_perspectives` VALUES (133,1321,1),(134,1322,1),(135,1323,1),(136,1324,1),(137,1324,2),(138,1325,1),(139,1326,1),(140,1327,2),(141,1328,2),(142,1330,1),(143,1330,3),(144,1331,2),(145,1332,4),(146,1333,2),(147,1334,1),(148,1335,1),(149,1336,2),(150,1337,1),(151,1338,1),(152,1340,2),(153,1341,2),(154,1341,4),(155,1342,5),(156,1343,2),(157,1344,2),(158,1345,2),(159,1346,1),(160,1347,1),(161,1348,4),(162,1349,1),(163,1350,3),(164,1351,1),(165,1352,1),(166,1354,3),(167,1355,3),(168,1356,1),(169,1357,1),(170,1358,1),(171,1359,2),(172,1360,1),(173,1361,2),(174,1362,2),(175,1363,2),(176,1365,1),(177,1366,3),(178,1366,4),(179,1367,1),(180,1368,1),(181,1369,2),(182,1370,1),(183,1371,4),(184,1372,2),(185,1373,1),(186,1374,1),(187,1375,1),(188,1376,1),(189,1377,1),(190,1377,7),(191,1378,1),(194,1380,1),(195,1380,2),(196,1381,2),(197,1382,1),(198,1383,1),(199,1383,7),(200,1384,1),(201,1385,1),(202,1386,1),(205,1392,1),(206,1393,1),(207,1394,1),(208,1395,1),(209,1396,2),(210,1397,2),(211,1398,2),(212,1401,1),(213,1402,1),(214,1403,1),(215,1404,1),(216,1405,1),(217,1406,1),(218,1407,1),(219,1408,1),(221,1410,2),(222,1411,4),(223,1412,1),(224,1413,2),(225,1414,1),(226,1415,1),(227,1416,1),(228,1417,1),(229,1418,1),(230,1419,1),(232,1421,1),(233,1422,3),(234,1423,1),(235,1424,1),(236,1425,1),(237,1426,1),(238,1427,2),(239,1428,2),(240,1429,1),(241,1429,2),(242,1430,1),(243,1431,1),(244,1431,2),(245,1432,1),(246,1433,1),(247,1435,2),(248,1435,4),(249,1436,2),(250,1437,1),(251,1439,2),(252,1439,3),(253,1440,1),(254,1441,1),(255,1441,2),(256,1442,1),(257,1444,1),(258,1445,1),(259,1446,1),(260,1447,1),(261,1447,2),(262,1447,7),(263,1448,4),(264,1449,4),(265,1450,1),(266,1451,1),(267,1451,2),(268,1452,1);
/*!40000 ALTER TABLE `game_perspectives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_platforms`
--

DROP TABLE IF EXISTS `game_platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_platforms` (
  `game_id` int NOT NULL,
  `platform_id` int NOT NULL,
  PRIMARY KEY (`game_id`,`platform_id`),
  KEY `platform_id` (`platform_id`),
  CONSTRAINT `game_platforms_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  CONSTRAINT `game_platforms_ibfk_2` FOREIGN KEY (`platform_id`) REFERENCES `platforms` (`idPlatform`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_platforms`
--

LOCK TABLES `game_platforms` WRITE;
/*!40000 ALTER TABLE `game_platforms` DISABLE KEYS */;
INSERT INTO `game_platforms` VALUES (1323,3),(1342,3),(1349,3),(1354,3),(1355,3),(1358,3),(1369,3),(1370,3),(1371,3),(1376,3),(1392,3),(1393,3),(1394,3),(1401,3),(1402,3),(1408,3),(1413,3),(1415,3),(1416,3),(1422,3),(1423,3),(1435,3),(1436,3),(1439,3),(1442,3),(1447,3),(1321,6),(1322,6),(1323,6),(1324,6),(1325,6),(1326,6),(1327,6),(1328,6),(1330,6),(1331,6),(1332,6),(1333,6),(1334,6),(1335,6),(1336,6),(1337,6),(1338,6),(1341,6),(1342,6),(1343,6),(1344,6),(1345,6),(1346,6),(1347,6),(1348,6),(1349,6),(1350,6),(1351,6),(1352,6),(1354,6),(1355,6),(1356,6),(1357,6),(1358,6),(1359,6),(1360,6),(1361,6),(1362,6),(1363,6),(1365,6),(1366,6),(1367,6),(1368,6),(1369,6),(1370,6),(1371,6),(1372,6),(1373,6),(1374,6),(1375,6),(1376,6),(1377,6),(1378,6),(1380,6),(1381,6),(1382,6),(1383,6),(1384,6),(1385,6),(1386,6),(1392,6),(1393,6),(1394,6),(1395,6),(1396,6),(1397,6),(1398,6),(1401,6),(1402,6),(1403,6),(1404,6),(1405,6),(1406,6),(1407,6),(1408,6),(1410,6),(1411,6),(1412,6),(1413,6),(1414,6),(1415,6),(1416,6),(1417,6),(1418,6),(1419,6),(1421,6),(1422,6),(1423,6),(1424,6),(1425,6),(1426,6),(1428,6),(1429,6),(1430,6),(1431,6),(1432,6),(1435,6),(1436,6),(1437,6),(1438,6),(1439,6),(1440,6),(1441,6),(1442,6),(1444,6),(1445,6),(1446,6),(1447,6),(1449,6),(1450,6),(1451,6),(1452,6),(1396,8),(1323,9),(1324,9),(1354,9),(1355,9),(1372,9),(1375,9),(1395,9),(1397,9),(1414,9),(1415,9),(1416,9),(1433,9),(1435,9),(1436,9),(1448,9),(1450,9),(1452,9),(1396,11),(1323,12),(1324,12),(1356,12),(1357,12),(1358,12),(1361,12),(1362,12),(1372,12),(1375,12),(1380,12),(1395,12),(1397,12),(1414,12),(1415,12),(1416,12),(1433,12),(1435,12),(1436,12),(1448,12),(1450,12),(1452,12),(1342,14),(1348,14),(1354,14),(1355,14),(1357,14),(1358,14),(1366,14),(1369,14),(1371,14),(1376,14),(1383,14),(1384,14),(1392,14),(1393,14),(1394,14),(1401,14),(1402,14),(1403,14),(1405,14),(1408,14),(1413,14),(1414,14),(1415,14),(1416,14),(1422,14),(1423,14),(1429,14),(1432,14),(1437,14),(1439,14),(1442,14),(1447,14),(1329,20),(1344,39),(1383,39),(1410,39),(1411,39),(1422,39),(1447,39),(1354,46),(1355,46),(1415,46),(1322,48),(1323,48),(1324,48),(1326,48),(1327,48),(1328,48),(1332,48),(1333,48),(1336,48),(1340,48),(1341,48),(1343,48),(1344,48),(1345,48),(1348,48),(1354,48),(1355,48),(1359,48),(1363,48),(1365,48),(1366,48),(1368,48),(1371,48),(1376,48),(1377,48),(1380,48),(1381,48),(1383,48),(1384,48),(1385,48),(1386,48),(1392,48),(1393,48),(1394,48),(1398,48),(1401,48),(1402,48),(1403,48),(1405,48),(1408,48),(1410,48),(1411,48),(1413,48),(1415,48),(1416,48),(1423,48),(1424,48),(1425,48),(1426,48),(1427,48),(1428,48),(1436,48),(1439,48),(1440,48),(1441,48),(1444,48),(1446,48),(1447,48),(1449,48),(1322,49),(1323,49),(1324,49),(1326,49),(1327,49),(1328,49),(1332,49),(1333,49),(1336,49),(1341,49),(1343,49),(1344,49),(1345,49),(1348,49),(1354,49),(1355,49),(1359,49),(1363,49),(1365,49),(1366,49),(1367,49),(1368,49),(1369,49),(1376,49),(1380,49),(1381,49),(1383,49),(1384,49),(1385,49),(1386,49),(1392,49),(1393,49),(1394,49),(1398,49),(1401,49),(1402,49),(1403,49),(1405,49),(1408,49),(1410,49),(1411,49),(1413,49),(1414,49),(1415,49),(1416,49),(1423,49),(1424,49),(1425,49),(1426,49),(1436,49),(1439,49),(1440,49),(1441,49),(1444,49),(1446,49),(1447,49),(1449,49),(1322,130),(1323,130),(1326,130),(1332,130),(1333,130),(1341,130),(1342,130),(1343,130),(1344,130),(1348,130),(1349,130),(1354,130),(1355,130),(1359,130),(1363,130),(1366,130),(1367,130),(1371,130),(1376,130),(1383,130),(1384,130),(1385,130),(1386,130),(1392,130),(1393,130),(1401,130),(1402,130),(1403,130),(1405,130),(1408,130),(1410,130),(1411,130),(1412,130),(1414,130),(1415,130),(1416,130),(1422,130),(1435,130),(1439,130),(1440,130),(1441,130),(1444,130),(1447,130),(1449,130),(1326,167),(1327,167),(1328,167),(1331,167),(1333,167),(1334,167),(1335,167),(1346,167),(1348,167),(1349,167),(1354,167),(1355,167),(1359,167),(1363,167),(1365,167),(1367,167),(1368,167),(1369,167),(1371,167),(1373,167),(1381,167),(1383,167),(1384,167),(1394,167),(1398,167),(1401,167),(1410,167),(1412,167),(1418,167),(1423,167),(1424,167),(1425,167),(1426,167),(1428,167),(1440,167),(1441,167),(1444,167),(1447,167),(1449,167),(1326,169),(1327,169),(1331,169),(1333,169),(1334,169),(1335,169),(1346,169),(1348,169),(1349,169),(1354,169),(1355,169),(1359,169),(1365,169),(1367,169),(1369,169),(1373,169),(1381,169),(1383,169),(1384,169),(1394,169),(1398,169),(1401,169),(1410,169),(1412,169),(1418,169),(1423,169),(1424,169),(1425,169),(1426,169),(1440,169),(1441,169),(1447,169),(1449,169),(1333,508),(1334,508),(1367,508),(1369,508),(1383,508),(1384,508),(1447,508);
/*!40000 ALTER TABLE `game_platforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_ratings`
--

DROP TABLE IF EXISTS `game_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_ratings` (
  `idGameRating` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `user_id` int NOT NULL,
  `overall_score` decimal(3,1) NOT NULL,
  `gameplay` decimal(3,1) DEFAULT '0.0',
  `graphics` decimal(3,1) DEFAULT '0.0',
  `story` decimal(3,1) DEFAULT '0.0',
  `music` decimal(3,1) DEFAULT '0.0',
  `atmosphere` decimal(3,1) DEFAULT '0.0',
  `stability` decimal(3,1) DEFAULT '0.0',
  `replayability` decimal(3,1) DEFAULT '0.0',
  `isDetail` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idGameRating`),
  UNIQUE KEY `unique_user_game_rating` (`user_id`,`game_id`),
  KEY `fk_game_ratings_game` (`game_id`),
  CONSTRAINT `fk_game_ratings_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  CONSTRAINT `fk_game_ratings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_ratings`
--

LOCK TABLES `game_ratings` WRITE;
/*!40000 ALTER TABLE `game_ratings` DISABLE KEYS */;
INSERT INTO `game_ratings` VALUES (105,1321,34,6.8,6.0,7.0,NULL,NULL,7.5,NULL,NULL,1,'2026-09-22 17:55:17'),(106,1322,34,9.2,8.0,8.0,10.0,10.0,10.0,10.0,7.0,1,'2026-09-22 18:04:36'),(107,1324,34,6.7,6.8,7.4,5.7,NULL,7.0,6.0,5.0,1,'2026-09-23 12:10:54'),(108,1325,34,5.8,6.0,6.0,5.0,NULL,6.0,NULL,NULL,1,'2026-09-23 12:11:27'),(109,1328,34,7.6,7.5,8.0,5.0,NULL,10.0,NULL,7.0,1,'2026-09-23 12:12:49'),(110,1326,34,6.2,6.0,6.4,NULL,6.5,6.0,NULL,5.0,1,'2026-09-23 12:13:53'),(111,1327,34,6.5,7.5,6.5,5.0,NULL,7.0,NULL,6.0,1,'2026-09-23 12:14:39'),(112,1329,34,4.8,5.0,5.0,4.0,NULL,5.0,NULL,NULL,1,'2026-09-23 12:15:34'),(113,1330,34,7.1,7.5,6.0,5.0,9.0,8.0,10.0,4.0,1,'2026-09-23 12:17:07'),(114,1331,34,3.3,3.0,6.0,2.0,NULL,2.0,3.0,NULL,1,'2026-09-23 12:17:58'),(115,1332,34,7.2,7.5,6.5,5.0,10.0,7.0,10.0,8.0,1,'2026-09-23 12:19:07'),(116,1333,34,4.5,5.0,5.0,4.0,NULL,4.0,NULL,NULL,1,'2026-09-23 12:20:15'),(117,1334,34,8.0,8.0,8.0,7.0,8.0,9.0,10.0,7.0,1,'2026-09-23 12:33:51'),(118,1335,34,7.3,7.0,7.0,6.5,8.0,8.0,10.0,9.0,1,'2026-09-23 12:39:48'),(119,1336,34,5.8,6.3,6.4,5.0,5.8,5.3,NULL,6.0,1,'2026-09-23 12:42:17'),(120,1337,34,6.3,7.0,5.0,NULL,NULL,7.0,10.0,8.0,1,'2026-09-23 12:43:55'),(121,1338,34,6.2,7.5,5.0,NULL,NULL,6.0,10.0,7.0,1,'2026-09-23 12:45:44'),(122,1340,34,7.0,6.0,6.5,7.5,NULL,8.0,NULL,NULL,1,'2026-09-23 12:48:37'),(123,1341,34,5.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 12:49:04'),(124,1342,34,4.8,3.0,4.0,4.0,7.0,6.0,10.0,6.0,1,'2026-09-23 12:50:50'),(125,1343,34,4.8,4.0,4.0,4.0,6.0,6.0,10.0,NULL,1,'2026-09-23 12:53:26'),(126,1344,34,5.3,4.0,5.0,NULL,6.0,6.0,10.0,NULL,1,'2026-09-23 12:54:37'),(127,1345,34,6.2,6.0,6.0,7.0,5.0,7.0,7.0,NULL,1,'2026-09-23 12:56:21'),(128,1347,34,4.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 12:58:38'),(129,1348,34,3.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 12:59:24'),(130,1349,34,6.8,7.0,5.0,NULL,8.0,7.0,10.0,8.0,1,'2026-09-23 13:03:16'),(131,1350,34,5.8,3.0,5.0,NULL,7.0,8.0,10.0,3.0,1,'2026-09-23 13:05:04'),(132,1351,34,5.3,6.0,6.0,NULL,NULL,4.0,6.0,NULL,1,'2026-09-23 13:08:39'),(133,1352,34,7.6,7.0,6.5,NULL,10.0,7.0,3.0,7.0,1,'2026-09-23 13:13:16'),(134,1353,34,5.3,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 13:14:46'),(135,1354,34,6.0,6.0,5.0,4.0,9.0,6.0,10.0,7.0,1,'2026-09-23 13:19:03'),(136,1355,34,5.9,6.5,5.0,4.0,8.0,6.0,10.0,5.0,1,'2026-09-23 13:19:41'),(138,1358,34,6.5,7.0,5.0,5.5,8.0,7.0,10.0,7.0,1,'2026-09-23 13:33:25'),(139,1359,34,4.0,3.0,5.0,3.0,NULL,5.0,NULL,NULL,1,'2026-09-23 13:42:12'),(140,1360,34,5.4,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 13:42:27'),(141,1362,34,5.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 13:43:41'),(142,1361,34,7.0,6.5,5.0,8.4,7.0,8.0,10.0,6.0,1,'2026-09-23 13:47:19'),(143,1363,34,6.4,7.0,4.5,NULL,6.0,8.0,10.0,4.0,1,'2026-09-23 13:49:52'),(144,1364,34,4.4,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 13:51:32'),(145,1365,34,6.7,7.0,7.0,NULL,NULL,6.0,7.0,NULL,1,'2026-09-23 13:52:19'),(146,1366,34,6.5,7.0,6.5,NULL,NULL,6.0,10.0,7.0,1,'2026-09-23 13:54:02'),(147,1367,34,6.0,7.0,5.0,NULL,NULL,6.0,10.0,7.0,1,'2026-09-23 13:55:58'),(148,1369,34,6.2,7.0,5.5,NULL,NULL,6.0,10.0,6.0,1,'2026-09-23 14:03:01'),(149,1370,34,5.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 14:03:34'),(150,1371,34,4.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 14:04:50'),(151,1372,34,7.3,8.0,6.5,7.5,NULL,7.0,10.0,7.0,1,'2026-09-23 14:11:15'),(152,1373,34,6.6,5.0,6.4,6.0,NULL,9.0,NULL,NULL,1,'2026-09-23 14:20:08'),(153,1374,34,4.1,4.0,4.4,NULL,NULL,4.0,4.0,1.0,1,'2026-09-23 14:25:56'),(154,1375,34,4.0,4.5,5.4,3.0,NULL,3.0,5.0,1.0,1,'2026-09-23 14:28:15'),(155,1376,34,7.2,6.0,6.4,6.5,NULL,10.0,10.0,6.0,1,'2026-09-23 14:44:56'),(156,1377,34,5.6,5.8,5.7,4.0,NULL,7.0,10.0,3.0,1,'2026-09-23 14:49:16'),(157,1378,34,7.0,7.5,7.8,5.5,NULL,7.0,10.0,5.0,1,'2026-09-23 14:53:20'),(159,1380,34,5.7,4.0,6.0,NULL,NULL,7.0,NULL,NULL,1,'2026-09-23 14:57:41'),(160,1381,34,5.8,5.5,6.0,NULL,NULL,6.0,NULL,NULL,1,'2026-09-23 14:58:08'),(161,1382,34,4.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 14:59:36'),(162,1383,34,7.0,7.0,6.5,4.0,8.0,9.5,10.0,4.0,1,'2026-09-23 15:03:57'),(163,1385,34,7.3,5.5,5.7,5.5,10.0,10.0,10.0,10.0,1,'2026-09-23 15:20:15'),(164,1386,34,6.7,6.1,6.0,6.0,7.5,8.0,10.0,7.0,1,'2026-09-23 15:26:42'),(166,1391,34,6.8,7.0,6.0,5.0,8.0,8.0,10.0,7.0,1,'2026-09-23 16:21:48'),(167,1392,34,8.0,7.0,6.0,7.0,10.0,10.0,10.0,10.0,1,'2026-09-23 16:33:10'),(168,1393,34,7.0,6.0,6.0,6.5,8.0,8.5,10.0,7.0,1,'2026-09-23 16:45:27'),(169,1394,34,8.5,8.0,8.0,8.5,8.0,10.0,8.0,10.0,1,'2026-09-23 16:55:45'),(170,1395,34,4.4,4.0,4.5,5.0,NULL,4.0,NULL,1.0,1,'2026-09-23 17:40:22'),(171,1396,34,7.0,7.0,NULL,8.0,NULL,6.0,7.0,4.0,1,'2026-09-23 17:46:34'),(172,1397,34,9.0,8.0,7.0,10.0,10.0,10.0,8.0,10.0,1,'2026-09-23 17:51:25'),(173,1398,34,7.5,7.0,8.0,8.0,NULL,7.0,NULL,6.0,1,'2026-09-23 17:56:54'),(174,1400,34,5.8,5.0,6.0,6.0,NULL,6.0,NULL,NULL,1,'2026-09-23 18:00:16'),(175,1401,34,5.8,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 18:02:11'),(176,1402,34,5.3,3.0,5.0,6.0,NULL,7.0,10.0,1.0,1,'2026-09-23 18:03:41'),(177,1403,34,5.6,4.0,5.8,6.0,NULL,6.5,NULL,1.0,1,'2026-09-23 18:07:24'),(178,1404,34,6.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 18:09:15'),(179,1405,34,4.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-23 18:11:35'),(180,1406,34,6.2,6.0,5.5,NULL,NULL,7.0,6.0,7.0,1,'2026-09-23 18:14:33'),(181,1407,34,5.2,5.0,6.0,3.0,6.0,6.0,10.0,NULL,1,'2026-09-24 11:27:37'),(182,1411,34,6.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-24 12:02:42'),(183,1413,34,6.3,6.0,6.0,5.0,NULL,8.0,10.0,6.0,1,'2026-09-24 12:05:50'),(184,1414,34,6.4,7.0,6.5,5.0,NULL,7.0,8.0,7.0,1,'2026-09-24 12:11:26'),(185,1415,34,7.1,7.5,7.5,5.5,NULL,8.0,10.0,8.0,1,'2026-09-24 12:13:48'),(186,1416,34,5.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-24 12:15:50'),(187,1417,34,7.0,6.0,4.0,6.0,10.0,9.0,10.0,NULL,1,'2026-09-24 12:21:38'),(189,1423,34,7.0,6.3,5.5,6.0,8.0,9.0,10.0,4.0,1,'2026-09-24 12:43:27'),(190,1424,34,8.2,8.5,8.0,7.5,8.0,9.0,8.0,8.0,1,'2026-09-24 12:58:42'),(191,1425,34,7.0,6.5,9.0,6.0,6.0,7.5,7.0,5.0,1,'2026-09-24 13:08:55'),(192,1426,34,6.3,6.0,6.5,NULL,NULL,6.5,7.0,10.0,1,'2026-09-24 13:11:29'),(193,1427,34,8.2,8.0,8.0,8.0,7.0,10.0,10.0,8.0,1,'2026-09-24 13:19:28'),(194,1428,34,8.6,8.0,8.5,8.0,8.3,10.0,10.0,8.0,1,'2026-09-24 13:23:11'),(195,1434,34,5.7,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-24 13:25:14'),(196,1431,34,6.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-24 13:25:40'),(197,1435,34,6.7,9.0,6.0,5.0,7.0,6.5,10.0,6.0,1,'2026-09-24 13:29:30'),(198,1436,34,5.8,7.0,5.0,6.0,NULL,5.0,10.0,1.0,1,'2026-09-24 13:31:01'),(199,1437,34,6.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-24 13:35:21'),(200,1439,34,5.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-24 13:35:57'),(202,1446,34,6.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-24 13:40:16'),(203,1447,34,7.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,'2026-09-24 13:41:57'),(204,1448,34,6.3,7.0,6.0,NULL,NULL,6.0,7.0,5.0,1,'2026-09-24 13:43:46'),(205,1449,34,6.8,6.0,7.5,NULL,NULL,7.0,NULL,NULL,1,'2026-09-24 13:44:08'),(206,1450,34,6.0,7.0,6.0,5.0,NULL,6.0,NULL,NULL,1,'2026-09-24 13:48:54'),(207,1452,34,7.5,8.0,7.0,7.0,NULL,8.0,10.0,7.0,1,'2026-09-24 13:53:01'),(208,1453,34,7.6,8.0,8.0,6.5,NULL,8.0,8.0,5.0,1,'2026-09-24 13:57:31');
/*!40000 ALTER TABLE `game_ratings` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_game_ratings_after_insert` AFTER INSERT ON `game_ratings` FOR EACH ROW BEGIN
    CALL update_game_rating_stats(NEW.game_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_game_ratings_after_update` AFTER UPDATE ON `game_ratings` FOR EACH ROW BEGIN
    CALL update_game_rating_stats(NEW.game_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_game_ratings_after_delete` AFTER DELETE ON `game_ratings` FOR EACH ROW BEGIN
    CALL update_game_rating_stats(OLD.game_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `game_ratings_params`
--

DROP TABLE IF EXISTS `game_ratings_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_ratings_params` (
  `idParam` int NOT NULL AUTO_INCREMENT,
  `name` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `game_id` int NOT NULL,
  `author_id` int NOT NULL,
  PRIMARY KEY (`idParam`),
  KEY `fk_game_param` (`game_id`),
  KEY `fk_author_param` (`author_id`),
  CONSTRAINT `fk_author_param` FOREIGN KEY (`author_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE,
  CONSTRAINT `fk_game_param` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_ratings_params`
--

LOCK TABLES `game_ratings_params` WRITE;
/*!40000 ALTER TABLE `game_ratings_params` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_ratings_params` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_requests`
--

DROP TABLE IF EXISTS `game_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_requests` (
  `idRequest` int NOT NULL AUTO_INCREMENT,
  `nameGame` varchar(255) NOT NULL,
  `store_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status_id` int NOT NULL DEFAULT '2',
  `user_id` int NOT NULL COMMENT 'Кто запросил',
  `moderator_id` int DEFAULT NULL COMMENT 'Кто обрабатывал',
  `notes` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idRequest`),
  KEY `fk_GameRequests_user_id` (`user_id`),
  KEY `fk_request_status` (`status_id`),
  CONSTRAINT `fk_GameRequests_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE,
  CONSTRAINT `fk_request_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_requests`
--

LOCK TABLES `game_requests` WRITE;
/*!40000 ALTER TABLE `game_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_themes`
--

DROP TABLE IF EXISTS `game_themes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_themes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `theme_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_gameTheme` (`game_id`),
  KEY `fk_theme` (`theme_id`),
  CONSTRAINT `fk_gameTheme` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_theme` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`idTheme`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=679 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_themes`
--

LOCK TABLES `game_themes` WRITE;
/*!40000 ALTER TABLE `game_themes` DISABLE KEYS */;
INSERT INTO `game_themes` VALUES (318,1321,1),(319,1322,1),(320,1322,17),(321,1322,18),(322,1322,22),(323,1323,1),(324,1323,23),(325,1324,1),(326,1324,39),(327,1325,1),(328,1326,1),(329,1326,18),(330,1327,1),(331,1327,17),(332,1327,19),(333,1328,1),(334,1328,18),(335,1328,21),(336,1328,33),(337,1328,38),(338,1328,39),(339,1329,1),(340,1329,18),(341,1330,19),(342,1330,20),(343,1330,43),(344,1330,44),(345,1331,1),(346,1331,18),(347,1332,1),(348,1333,1),(349,1334,1),(350,1334,18),(351,1335,19),(352,1336,1),(353,1336,38),(354,1337,1),(355,1337,18),(356,1337,19),(357,1337,27),(358,1338,1),(359,1338,18),(360,1338,19),(361,1338,21),(362,1338,23),(364,1340,19),(365,1340,31),(366,1340,43),(367,1341,1),(368,1341,17),(369,1341,35),(370,1342,19),(371,1343,1),(372,1343,17),(373,1343,34),(374,1344,1),(375,1344,35),(376,1345,1),(377,1346,1),(378,1346,18),(379,1346,21),(380,1346,33),(381,1347,1),(382,1348,1),(383,1348,40),(384,1349,1),(385,1349,19),(386,1350,18),(387,1350,33),(388,1351,1),(389,1351,21),(390,1351,39),(391,1352,1),(392,1352,21),(393,1352,33),(394,1352,39),(395,1354,1),(396,1355,1),(397,1356,1),(398,1357,1),(399,1357,19),(400,1357,21),(401,1358,1),(402,1358,19),(403,1358,21),(404,1359,1),(405,1360,1),(406,1360,23),(407,1361,1),(408,1361,19),(409,1361,20),(410,1361,21),(411,1362,1),(412,1362,18),(413,1362,19),(414,1362,21),(415,1362,31),(416,1363,18),(417,1363,21),(418,1363,33),(419,1363,35),(420,1363,38),(421,1365,1),(422,1365,19),(423,1365,21),(424,1366,1),(425,1366,17),(426,1366,27),(427,1367,1),(428,1367,19),(429,1367,27),(430,1368,1),(431,1368,19),(432,1369,1),(433,1369,17),(434,1369,21),(435,1369,33),(436,1369,38),(437,1370,1),(438,1370,21),(439,1371,1),(440,1371,40),(441,1372,1),(442,1372,33),(443,1372,38),(444,1373,1),(445,1373,17),(446,1373,18),(447,1373,19),(448,1373,23),(449,1374,1),(450,1374,18),(451,1375,1),(452,1375,23),(453,1375,33),(454,1375,38),(455,1376,31),(456,1376,38),(457,1376,43),(458,1377,1),(459,1377,19),(460,1377,21),(461,1377,38),(462,1378,1),(463,1378,19),(464,1378,21),(469,1380,1),(470,1380,38),(471,1381,1),(472,1381,38),(473,1382,1),(474,1382,21),(475,1382,38),(476,1383,18),(477,1383,21),(478,1383,38),(479,1384,18),(480,1384,21),(481,1384,38),(482,1385,1),(483,1385,18),(484,1385,19),(485,1385,21),(486,1385,23),(487,1385,33),(488,1385,38),(489,1386,1),(490,1386,19),(491,1386,21),(492,1386,23),(493,1386,38),(508,1392,1),(509,1392,18),(510,1392,19),(511,1392,20),(512,1392,21),(513,1392,23),(514,1392,39),(515,1393,1),(516,1393,21),(517,1393,23),(518,1394,1),(519,1394,18),(520,1394,19),(521,1394,21),(522,1394,23),(523,1395,1),(524,1395,18),(525,1396,1),(526,1396,23),(527,1396,38),(528,1397,1),(529,1397,17),(530,1397,22),(531,1397,23),(532,1397,33),(533,1397,38),(534,1398,1),(535,1398,31),(536,1398,38),(537,1401,19),(538,1401,20),(539,1401,43),(540,1402,1),(541,1402,19),(542,1402,21),(543,1402,23),(544,1402,43),(545,1403,1),(546,1403,19),(547,1403,21),(548,1403,43),(549,1404,19),(550,1405,1),(551,1405,19),(552,1406,1),(553,1406,21),(554,1407,1),(555,1407,18),(556,1407,38),(557,1408,1),(558,1408,19),(559,1408,21),(561,1410,1),(562,1410,27),(563,1410,40),(564,1411,18),(565,1411,21),(566,1412,1),(567,1412,19),(568,1412,21),(569,1413,1),(570,1413,21),(571,1413,38),(572,1414,1),(573,1414,18),(574,1414,38),(575,1415,1),(576,1415,18),(577,1415,27),(578,1415,33),(579,1415,38),(580,1416,1),(581,1416,18),(582,1416,27),(583,1416,38),(584,1417,1),(585,1417,19),(586,1417,20),(587,1418,1),(588,1421,1),(589,1421,21),(590,1421,38),(591,1422,1),(592,1422,19),(593,1422,21),(594,1422,33),(595,1422,38),(596,1423,1),(597,1423,19),(598,1423,21),(599,1423,23),(600,1423,38),(601,1424,1),(602,1424,19),(603,1424,21),(604,1424,38),(605,1425,1),(606,1425,19),(607,1425,21),(608,1426,1),(609,1426,18),(610,1427,1),(611,1427,23),(612,1427,31),(613,1427,38),(614,1428,1),(615,1428,23),(616,1428,38),(617,1429,1),(618,1429,22),(619,1429,39),(620,1430,1),(621,1430,22),(622,1430,39),(623,1431,1),(624,1431,39),(625,1432,1),(626,1432,18),(627,1433,1),(628,1433,27),(629,1435,1),(630,1435,27),(631,1435,33),(632,1435,38),(633,1436,1),(634,1436,18),(635,1436,27),(636,1436,33),(637,1436,38),(638,1437,1),(639,1437,21),(640,1437,33),(641,1437,38),(642,1438,1),(643,1438,19),(644,1439,35),(645,1439,40),(646,1440,1),(647,1440,21),(648,1440,38),(649,1441,1),(650,1441,21),(651,1442,33),(652,1444,28),(653,1445,1),(654,1445,19),(655,1446,1),(656,1446,18),(657,1446,19),(658,1446,21),(659,1447,1),(660,1447,17),(661,1447,21),(662,1447,33),(663,1447,35),(664,1447,38),(665,1447,41),(666,1449,1),(667,1449,17),(668,1450,1),(669,1450,18),(670,1450,23),(671,1450,38),(672,1451,1),(673,1451,18),(674,1451,23),(675,1451,38),(676,1452,1),(677,1452,18),(678,1452,23);
/*!40000 ALTER TABLE `game_themes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `games` (
  `idGame` int NOT NULL AUTO_INCREMENT,
  `igdb_id` int DEFAULT NULL,
  `steam_id` int DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `rating_overall` decimal(3,1) NOT NULL DEFAULT '0.0',
  `rating_counter` int NOT NULL DEFAULT '0',
  `developer_id` int DEFAULT NULL,
  `publisher_id` int DEFAULT NULL,
  `status_id` int NOT NULL,
  `release_date` date DEFAULT NULL,
  `trailer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `banner` varchar(500) DEFAULT NULL,
  `sort_order` int DEFAULT NULL,
  `story_avg` decimal(3,1) NOT NULL DEFAULT '0.0',
  `graphics_avg` decimal(3,1) NOT NULL DEFAULT '0.0',
  `gameplay_avg` decimal(3,1) NOT NULL DEFAULT '0.0',
  `atmosphere_avg` decimal(3,1) NOT NULL DEFAULT '0.0',
  `optimization_avg` decimal(3,1) NOT NULL DEFAULT '0.0',
  PRIMARY KEY (`idGame`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `cover_id` (`cover`),
  UNIQUE KEY `uniq_igdbid` (`igdb_id`),
  UNIQUE KEY `uniq_steamid` (`steam_id`),
  KEY `idx_game_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1454 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
INSERT INTO `games` VALUES (1321,248994,2406770,'Bodycam','Bodycam — это первый тактический многопользовательский шутер от первого лица с настоящим обзором с нательной камеры на движке Unreal Engine 5. Ближние бои кажутся резкими и громкими. Каждый ракурс, выноска и пуля имеют значение. Играйте в Deathmatch, Team Deathmatch и Wingman на фотореалистичных.',6.8,1,69,NULL,12,'2024-06-07',NULL,'games/covers/bodycam-game_cover_1321.jpg','games/banners/bodycam-banner_1321.jpg',NULL,0.0,7.0,6.0,7.5,0.0),(1322,36952,612880,'Wolfenstein II: The New Colossus','Америка, 1961 г. Генерал Череп убит, но миром правят нацисты. Вы Би Джей Бласковиц, боец сопротивления и последняя надежда человечества. Только вы можете раздуть пламя второй Американской революции.',9.2,1,70,71,10,'2017-10-26','https://cdn.akamai.steamstatic.com/steam/apps/256696071/movie_max.mp4','games/covers/wolfenstein_ii_the_new_colossus-game_cover_1322.jpg','games/banners/wolfenstein_ii_the_new_colossus-banner_1322.jpg',NULL,10.0,8.0,8.0,10.0,10.0),(1323,2058,218620,'Payday 2','PAYDAY 2 - это кооперативный экшн-шутер для четверых игроков, который снова позволяет игрокам надеть маски оригинальной банды PAYDAY - Даллас, Хокстон, Чейнс и Вулф, которые прибыли в Вашингтон для новой крутой серии преступлений.',0.0,0,72,73,10,'2013-08-13',NULL,'games/covers/payday_2-game_cover_1323.jpg','games/banners/payday_2-banner_1323.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1324,1979,1238860,'Battlefield 4','Доминируйте на поле боя с материалами Premium',6.7,1,74,75,10,'2013-10-29','https://cdn.akamai.steamstatic.com/steam/apps/256787502/movie_max.mp4','games/covers/battlefield_4-game_cover_1324.jpg','games/banners/battlefield_4-banner_1324.jpg',NULL,5.7,7.4,6.8,7.0,6.0),(1325,273136,1238820,'Battlefield 3','Наслаждайтесь полной свободой и сражайтесь так, как вам хочется. Изучайте 29 огромных сетевых карт и используйте богатый арсенал техники, оружия и устройств, чтобы повысить накал схватки. Сражаясь, вы с каждой секундой будете приближаться к новому званию и множеству бонусов. Так что вперёд, в бой!',5.8,1,NULL,NULL,10,'2005-10-12','https://cdn.akamai.steamstatic.com/steam/apps/256787639/movie_max.mp4',NULL,'games/banners/battlefield_3-banner_1325.jpg',NULL,5.0,6.0,6.0,6.0,0.0),(1326,121752,1139900,'Ghostrunner','Игра Ghostrunner предлагает уникальный режим одиночной игры: динамичное жестокое сражение в оригинальной атмосфере, в которой научная фантастика сочетается с постапокалиптической тематикой. Игра расскажет вам историю мира, который остался в прошлом и обитатели которого вынуждены постоянно сражаться, чтобы выжить.',6.2,1,76,77,10,'2020-10-27','https://cdn.akamai.steamstatic.com/steam/apps/256789122/movie_max.mp4','games/covers/ghostrunner-game_cover_1326.jpg','games/banners/ghostrunner-banner_1326.jpg',NULL,0.0,6.4,6.0,6.0,0.0),(1327,141547,1065310,'Evil West','Зловещая угроза нависла над Диким Западом. В одиночку или сообща сражайтесь с кровожадными чудищами в беспощадных, взрывных боях и покажите всем, как это делается. Искореняйте полчища вампиров заправленной молнией рукавицей и станьте супергероем Дикого Запада.',6.5,1,78,79,10,'2022-11-22','https://cdn.akamai.steamstatic.com/steam/apps/256913778/movie_max.mp4','games/covers/evil_west-game_cover_1327.jpg','games/banners/evil_west-banner_1327.jpg',NULL,5.0,6.5,7.5,7.0,0.0),(1328,2114,3268800,'Tom Clancy\'s The Division','Набор «Активация» (500 премиальных кредитов + 250 бонусных кредитов + экипировка)',7.6,1,80,81,10,'2016-03-08',NULL,'games/covers/tom_clancy_s_the_division-game_cover_1328.jpg',NULL,NULL,5.0,8.0,7.5,10.0,0.0),(1329,240487,35140,'Batman: Arkham Asylum','Почувствуйте, каково это – быть Бэтменом, и сразитесь лицом к лицу с величайшими злодеями Готэма. Исследуйте каждый дюйм лечебницы Аркхем и свободно передвигайтесь по печально известному острову.',4.8,1,82,83,14,NULL,NULL,'games/covers/batman_arkham_asylum-game_cover_1329.jpg','games/banners/batman_arkham_asylum-banner_1329.jpg',NULL,4.0,5.0,5.0,5.0,0.0),(1330,255777,2527500,'MiSide','Представим, что у вас есть игра, в которой вы ухаживаете за персонажем. Но могли бы вы себе представить, что однажды сами попадете в эту игру?',7.1,1,84,85,10,'2024-12-10',NULL,'games/covers/miside-game_cover_1330.jpg','games/banners/miside-banner_1330.jpg',NULL,5.0,6.0,7.5,8.0,10.0),(1331,320873,3265250,'MindsEye','MindsEye — это постоянно растущая игра с сюжетной кампанией и бесконечным потоком регулярно выпускаемого нового контента, а наш простой редактор позволит делать собственные игры.',3.3,1,86,NULL,10,'2025-06-10',NULL,'games/covers/mindseye-game_cover_1331.jpg','games/banners/mindseye-banner_1331.jpg',NULL,2.0,6.0,3.0,2.0,3.0),(1332,25901,557340,'My Friend Pedro','My Friend Pedro — это жестокая смесь дружбы, фантазии и стремления уничтожить всех на своем пути по приказу разумного банана. Стратегическое использование раздельного прицеливания, замедленного движения и старого доброго вышибания окон позволяет выстраивать одну сногсшибательную боевую сцену за другой.',7.2,1,87,88,10,'2019-06-20','https://cdn.akamai.steamstatic.com/steam/apps/256764790/movie_max.mp4','games/covers/my_friend_pedro-game_cover_1332.jpg','games/banners/my_friend_pedro-banner_1332.jpg',NULL,5.0,6.5,7.5,7.0,10.0),(1333,135243,1426210,'It Takes Two','Отправьтесь в самое безумное путешествие в жизни в игре It Takes Two. Пригласите друга присоединиться бесплатно благодаря версии для друга*, радостно преодолевая многочисленные испытания.',4.5,1,75,89,10,'2021-03-25',NULL,'games/covers/it_takes_two-game_cover_1333.jpg','games/banners/it_takes_two-banner_1333.jpg',NULL,4.0,5.0,5.0,4.0,0.0),(1334,249324,2416450,'Mouse: P.I. For Hire','Вместе с частным детективом Джеком Пеппером докопайтесь до истины в остросюжетных расследованиях с нотками джаза. «Частный детектив МАУС» сочетает в себе очарование классических мультяшных персонажей с адреналиновым азартом шутера от первого лица.',8.0,1,90,91,10,'2026-04-16',NULL,'games/covers/mouse_p_i_for_hire-game_cover_1334.jpg','games/banners/mouse_p_i_for_hire-banner_1334.jpg',NULL,7.0,8.0,8.0,9.0,10.0),(1335,316987,3180070,'No, I\'m Not A Human','ВНИМАНИЕ: Не покидайте свои дома. Заприте все двери. Зашторьте все окна. Впускайте в дом только настоящих людей. Все Гости должны быть устранены. Это — история о параноидальном ужасе, поджидающем у конца времён.',7.3,1,92,93,10,'2025-09-15',NULL,'games/covers/no_i_m_not_a_human-game_cover_1335.jpg','games/banners/no_i_m_not_a_human-banner_1335.jpg',NULL,6.5,7.0,7.0,8.0,10.0),(1336,36662,1262580,'Need for Speed: Payback','Need for Speed™ Payback - Издание Deluxe дает вам преимущество над соперниками. Выделитесь из толпы, получив эксклюзивные возможности кастомизации, скидки в игре, бонусы к репутации и пять поставок в качестве приветственного подарка.',5.8,1,94,75,10,'2017-11-10','https://cdn.akamai.steamstatic.com/steam/apps/256789562/movie_max.mp4','games/covers/need_for_speed_payback-game_cover_1336.jpg','games/banners/need_for_speed_payback-banner_1336.jpg',NULL,5.0,6.4,6.3,5.3,0.0),(1337,212089,1966720,'Lethal Company','A co-op horror about scavenging at abandoned moons to sell scrap to the Company.',6.3,1,95,NULL,12,'2023-10-23',NULL,'games/covers/lethal_company-game_cover_1337.jpg','games/banners/lethal_company-banner_1337.jpg',NULL,0.0,5.0,7.0,7.0,10.0),(1338,332780,3241660,'R.E.P.O.','An online co-op horror game with up to 6 players. Locate valuable, fully physics-based objects and handle them with care as you retrieve and extract to satisfy your creator\'s desires.',6.2,1,96,NULL,12,'2025-02-26',NULL,'games/covers/r_e_p_o-game_cover_1338.jpg','games/banners/r_e_p_o-banner_1338.jpg',NULL,0.0,5.0,7.5,6.0,10.0),(1340,7609,2172010,'Until Dawn','В игре &quot;Дожить до рассвета&quot;, воссозданной и улучшенной для ПК, вы сможете вновь погрузиться в захватывающий кровавый хоррор, в котором жизнь и смерть зависят от каждого принятого решения.',7.0,1,97,98,10,'2015-08-25','https://cdn.akamai.steamstatic.com/steam/apps/257058101/movie_max.mp4','games/covers/until_dawn-game_cover_1340.jpg','games/banners/until_dawn-banner_1340.jpg',NULL,7.5,6.5,6.0,8.0,0.0),(1341,19241,1225570,'Unravel Two','Когда рвешь связи с прошлым, всегда появляются новые.',5.0,1,99,75,10,'2018-06-09',NULL,'games/covers/unravel_two-game_cover_1341.jpg','games/banners/unravel_two-banner_1341.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1342,159720,1604000,'Milk Outside a Bag of Milk Outside a Bag of Milk','Прямое продолжение игры Milk inside a bag of milk inside a bag of milk. Окунитесь в безумный и странный мир еще раз и помогите девочке стать немного счастливее.',4.8,1,100,101,10,'2021-12-16',NULL,'games/covers/milk_outside_a_bag_of_milk_outside_a_bag_of_milk-game_cover_1342.jpg','games/banners/milk_outside_a_bag_of_milk_outside_a_bag_of_milk-banner_1342.jpg',NULL,4.0,4.0,3.0,6.0,10.0),(1343,7352,384190,'Abzu','ABZÛ — это красочное приключение в подводном мире от создателей Journey®, где вам предстоит заниматься дайвингом. Погрузитесь в живописный мир океана, полный загадок и ярких красок. Но будьте осторожны, в морских пучинах вас ждет опасность.',4.8,1,76,102,10,'2016-08-02',NULL,'games/covers/abzu-game_cover_1343.jpg','games/banners/abzu-banner_1343.jpg',NULL,4.0,4.0,4.0,6.0,10.0),(1344,103373,883360,'Beyond Blue','Beyond Blue — это однопользовательская игра в стиле приключенческого повествования, в которой мы оказываемся в пульсирующем голубом сердце нашей планеты. Узнайте, какие чудеса и тайны скрыты в мировом океане.',5.3,1,103,NULL,10,'2020-04-17','https://cdn.akamai.steamstatic.com/steam/apps/256782870/movie_max.mp4','games/covers/beyond_blue-game_cover_1344.jpg','games/banners/beyond_blue-banner_1344.jpg',NULL,0.0,5.0,4.0,6.0,10.0),(1345,36897,1222700,'A Way Out','A Way Out - это уникальное коллективное приключение, где вы играете за одного из двух заключенных, затеявших побег из тюрьмы.',6.2,1,89,75,10,'2018-03-23','https://cdn.akamai.steamstatic.com/steam/apps/256790157/movie_max.mp4','games/covers/a_way_out-game_cover_1345.jpg','games/banners/a_way_out-banner_1345.jpg',NULL,7.0,6.0,6.0,7.0,7.0),(1346,219126,427410,'Abiotic Factor','Совместная игра на выживание с созданием предметов (для 1–6 игроков) в исследовательском центре, наводнили паранормальные угрозы. Вы — величайшие ученые Земли, и вам придется трудиться сообща, создавая гениальные устройства и оружие, чтобы выжить единственным известным вам способом: убивая наукой!',0.0,0,104,105,10,'2025-07-22','https://cdn.akamai.steamstatic.com/steam/apps/257172169/movie_max.mp4','games/covers/abiotic_factor-game_cover_1346.jpg','games/banners/abiotic_factor-banner_1346.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1347,50488,NULL,'Armed Forces Corp.',NULL,4.0,1,106,NULL,10,'2009-02-27',NULL,'games/covers/armed_forces_corp-game_cover_1347.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1348,204524,1607680,'Bread & Fred','Grab your best bud for help in this new co-op challenge to help two adorable penguins, Bread and Fred, reach the top of the snowy summit. Time your jumps, cling to walls and swing across gaps to see how far you can make it before you tumble all the way back down the mountain.',3.0,1,107,108,10,'2023-05-23','https://cdn.akamai.steamstatic.com/steam/apps/256955841/movie_max.mp4','games/covers/bread_fred-game_cover_1348.jpg','games/banners/bread_fred-banner_1348.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1349,281275,2835570,'Buckshot Roulette','Сыграйте в русскую рулетку с дробовиком 12-го калибра. Играют четверо. Остается один. Поставьте на кон свою жизнь. Удачи.',6.8,1,109,93,10,'2023-12-28',NULL,'games/covers/buckshot_roulette-game_cover_1349.jpg','games/banners/buckshot_roulette-banner_1349.jpg',NULL,0.0,5.0,7.0,7.0,10.0),(1350,268295,2379910,'Dystopika','Градостроительная песочница для футуристических городов. Никаких целей, никакого управления, только творчество и атмосфера мрачного уюта.',5.8,1,110,111,10,'2024-06-21','https://cdn.akamai.steamstatic.com/steam/apps/257032600/movie_max.mp4','games/covers/dystopika-game_cover_1350.jpg','games/banners/dystopika-banner_1350.jpg',NULL,0.0,5.0,3.0,8.0,10.0),(1351,298915,2073620,'Arena Breakout: Infinite','Arena Breakout: Infinite — захватывающий тактический экстракшен шутер Арена с реалистичной графикой и звуком. Участвуйте в отчаянных боях, где ставки высоки, а награды еще выше, собирайте добычу и разбогатейте!',5.3,1,112,NULL,11,'2025-09-15',NULL,'games/covers/arena_breakout_infinite-game_cover_1351.jpg','games/banners/arena_breakout_infinite-banner_1351.jpg',NULL,0.0,6.0,6.0,4.0,6.0),(1352,15536,3932890,'Escape from Tarkov','Escape from Tarkov - хардкорный шутер, где каждый рейд - это игра со смертью. Готовься к рейдам, превозмогай и пробивайся сквозь беспощадных бойцов ЧВК и Диких, пользуйся тактическим преимуществом и забирай самый ценный лут. Ты либо выйдешь живым, либо потеряешь все.',7.6,1,113,NULL,10,'2025-11-15','https://cdn.akamai.steamstatic.com/steam/apps/257231524/movie_max.mp4','games/covers/escape_from_tarkov-game_cover_1352.jpg','games/banners/escape_from_tarkov-banner_1352.jpg',NULL,0.0,6.5,7.0,7.0,3.0),(1353,203610,NULL,'Escape from Tarkov: Arena',NULL,5.3,1,113,NULL,11,NULL,NULL,'games/covers/escape_from_tarkov_arena-game_cover_1353.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1354,1384,219150,'Hotline Miami','Hotline Miami — это адреналиновый боевик, полный первобытной жестокости, смертельно опасных перестрелок и крышесносящих драк.',6.0,1,114,88,10,'2012-10-23',NULL,'games/covers/hotline_miami-game_cover_1354.jpg','games/banners/hotline_miami-banner_1354.jpg',NULL,4.0,5.0,6.0,6.0,10.0),(1355,2126,274170,'Hotline Miami 2: Wrong Number','Hotline Miami 2: Wrong Number is the brutal conclusion to the Hotline Miami saga, set against a backdrop of escalating violence and retribution over spilled blood in the original game.',5.9,1,88,115,10,'2015-03-10','https://cdn.akamai.steamstatic.com/steam/apps/2032598/movie_max.mp4','games/covers/hotline_miami_2_wrong_number-game_cover_1355.jpg','games/banners/hotline_miami_2_wrong_number-banner_1355.jpg',NULL,4.0,5.0,6.5,6.0,10.0),(1356,7011,NULL,'Hour of Victory',NULL,0.0,0,116,117,10,'2007-06-25',NULL,'games/covers/hour_of_victory-game_cover_1356.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1357,122,500,'Left 4 Dead','Left 4 Dead — это кооперативный экшен-хоррор для ПК и Xbox 360 от Valve, создателей Counter-Strike, Half-Life и многих других игр. В ней до четырёх игроков-выживших ведут эпическую битву с бесчисленными ордами зомби и ужасными мутантами.',0.0,0,118,119,10,'2008-11-17',NULL,'games/covers/left_4_dead-game_cover_1357.jpg','games/banners/left_4_dead-banner_1357.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1358,124,550,'Left 4 Dead 2','Set in the zombie apocalypse, Left 4 Dead 2 is a co-operative action horror FPS takes you and your friends through the cities, swamps and cemeteries of the Deep South, from Savannah to New Orleans across five expansive campaigns.',6.5,1,120,118,10,'2009-11-17',NULL,'games/covers/left_4_dead_2-game_cover_1358.jpg','games/banners/left_4_dead_2-banner_1358.jpg',NULL,5.5,5.0,7.0,7.0,10.0),(1359,144022,2138710,'Sifu','Sifu — это реалистичный боевик от третьего лица с напряженными боями в стиле кунг-фу и кинематографическими драками. Герой игры — одинокий воин, который ищет возмездия.',4.0,1,121,122,10,'2022-02-08','https://cdn.akamai.steamstatic.com/steam/apps/256919885/movie_max.mp4','games/covers/sifu-game_cover_1359.jpg','games/banners/sifu-banner_1359.jpg',NULL,3.0,5.0,3.0,5.0,0.0),(1360,316,NULL,'SWAT 4',NULL,5.4,1,123,124,10,'2005-04-05',NULL,'games/covers/swat_4-game_cover_1360.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1361,1062,108710,'Alan Wake','A Dark Presence stalks the small town of Bright Falls, pushing Alan Wake to the brink of sanity in his fight to unravel the mystery and save his love.',7.0,1,125,126,10,'2010-05-14',NULL,'games/covers/alan_wake-game_cover_1361.jpg','games/banners/alan_wake-banner_1361.jpg',NULL,8.4,5.0,6.5,8.0,10.0),(1362,2602,202750,'Alan Wake\'s American Nightmare','Новая, интригующая история, толпы ужасающих врагов, мощное вооружение и красивые виды Аризоны, приправленные веселым, но бросающим вызов, новым игровым режимом!',5.5,1,127,128,10,'2012-02-22',NULL,'games/covers/alan_wake_s_american_nightmare-game_cover_1362.jpg','games/banners/alan_wake_s_american_nightmare-banner_1362.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1363,13205,361420,'Astroneer','Меняйте новые странные миры и лепите их, как глину. Постройте базу, освойте управление ресурсами, автоматизируйте производственные линии и разгадайте тайны вселенной в одиночку или с друзьями.',6.4,1,129,NULL,10,'2019-02-06',NULL,'games/covers/astroneer-game_cover_1363.jpg','games/banners/astroneer-banner_1363.jpg',NULL,0.0,4.5,7.0,8.0,10.0),(1364,377823,509980,'Bigfoot','You are a Bigfoot hunter with an important mission: to put an end to rumours once and for all and prove to yourself that Bigfoot is not just a myth or an invention of the mind...',4.4,1,NULL,NULL,10,NULL,NULL,NULL,'games/banners/bigfoot-banner_1364.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1365,116200,924970,'Back 4 Blood','Back 4 Blood – это захватывающий кооперативный шутер от первого лица от создателей признанной критиками франшизы Left 4 Dead.',6.7,1,130,120,10,'2021-10-12','https://cdn.akamai.steamstatic.com/steam/apps/256838462/movie_max.mp4','games/covers/back_4_blood-game_cover_1365.jpg','games/banners/back_4_blood-banner_1365.jpg',NULL,0.0,7.0,7.0,6.0,7.0),(1366,9061,268910,'Cuphead','Cuphead – это в прямом смысле слова &quot;классический&quot; платформер. Классический, потому что все в нем выдержано в духе 1930-х: от графики, кажется, вышедшей из-под пера самого Уолта Диснея, до акварельных фонов и джазового музыкального сопровождения.',6.5,1,131,NULL,10,'2017-09-29','https://cdn.akamai.steamstatic.com/steam/apps/256894191/movie_max.mp4','games/covers/cuphead-game_cover_1366.jpg','games/banners/cuphead-banner_1366.jpg',NULL,0.0,6.5,7.0,6.0,10.0),(1367,294661,2881650,'Content Warning','Снимайте жуткие штуки с друзьями и загружайте видео с ними на SpöökTube, чтобы прославиться! Осторожно, вылазки в одиночку не рекомендуются!',6.0,1,132,133,10,'2024-04-01',NULL,'games/covers/content_warning-game_cover_1367.jpg','games/banners/content_warning-banner_1367.jpg',NULL,0.0,5.0,7.0,6.0,10.0),(1368,18020,594330,'Visage','Игра Visage — это психологический триллер от первого лица. Исследуйте таинственный, постоянно изменяющийся особняк в атмосферном игровом мире, где время течет неспешно, а неправдоподобно уютные интерьеры сменяются чудовищно реалистичными сценами, наводящими неподдельный ужас.',0.0,0,134,NULL,10,'2020-10-29','https://cdn.akamai.steamstatic.com/steam/apps/256807276/movie_max.mp4','games/covers/visage-game_cover_1368.jpg','games/banners/visage-banner_1368.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1369,104967,892970,'Valheim','Симулятор выживания и исследования для компании от 1 до 10 человек. Вас ждет процедурно генерируемый мир, пропитанный духом скандинавских мифов. Сражайтесь, стройте крепости и докажите, что достойны покровительства Одина!',6.2,1,135,136,12,'2026-09-09',NULL,'games/covers/valheim-game_cover_1369.jpg','games/banners/valheim-banner_1369.jpg',NULL,0.0,5.5,7.0,6.0,10.0),(1370,109117,951440,'Volcanoids','Шутер в открытом мире, где нужно выживать и строить базу (ну... вместо базы будет огромный бур). Играйте в одиночку или с друзьями: исследуйте остров, где извергается жуткий вулкан, улучшайте бур и сражайтесь с роботами. И однажды вы узнаете, какую тайну скрывает толща скал.',5.0,1,NULL,NULL,10,'2019-01-29',NULL,'games/covers/volcanoids-game_cover_1370.jpg','games/banners/volcanoids-banner_1370.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1371,55472,673750,'Super Bunny Man','Кооперативный платформер с отличной физикой про парня в костюме кролика! Зовите друга, а то и сразу трех (для игры локально или по сети), чтобы проходить уровни, искать морковки и скакать наперегонки с временем. Станьте поехавшим кроликом и сейте морковный хаос! Теперь вы Super Bunny Man!',4.5,1,137,NULL,12,'2023-05-16','https://cdn.akamai.steamstatic.com/steam/apps/256945744/movie_max.mp4','games/covers/super_bunny_man-game_cover_1371.jpg','games/banners/super_bunny_man-banner_1371.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1372,1267,202170,'Sleeping Dogs','Опробуйте новое дополнение «Nightmare in North Point»!',7.3,1,138,139,10,'2012-08-13',NULL,'games/covers/sleeping_dogs-game_cover_1372.jpg','games/banners/sleeping_dogs-banner_1372.jpg',NULL,7.5,6.5,8.0,7.0,10.0),(1373,252837,1622910,'Still Wakes the Deep','1975 год. В водах Шотландии терпит катастрофу буровая платформа «Бейра Д». Исследуйте тонущую платформу и спасите членов своего экипажа от ужаса за гранью логики и реальности.',6.6,1,140,141,10,'2024-06-18','https://cdn.akamai.steamstatic.com/steam/apps/256977967/movie_max.mp4','games/covers/still_wakes_the_deep-game_cover_1373.jpg','games/banners/still_wakes_the_deep-banner_1373.jpg',NULL,6.0,6.4,5.0,9.0,0.0),(1374,306,2369390,'Far Cry','Возглавьте революцию в этом повстанческом шутере от первого лица в открытом мире. Сражайтесь самодельным оружием, путешествуйте разными способами и создайте повстанческую сеть, чтобы свергнуть режим Кастильо.',4.1,1,142,143,10,'2004-03-23','https://cdn.akamai.steamstatic.com/steam/apps/256941288/movie_max.mp4','games/covers/far_cry-game_cover_1374.jpg','games/banners/far_cry-banner_1374.jpg',NULL,0.0,4.4,4.0,4.0,4.0),(1375,361,19900,'Far Cry 2','Вы — наемник, волею судьбы попавший в эпицентр гражданской войны в небольшой африканской провинции. Страдая от малярии, вы вынуждены сотрудничать с безжалостными военачальниками обеих сторон конфликта чтобы сделать это место своим домом.Вы должны научиться выявлять слабости противника и использовать их в свою пользу.',4.0,1,144,145,10,'2008-10-21','https://cdn.akamai.steamstatic.com/steam/apps/5076/movie_max.mp4','games/covers/far_cry_2-game_cover_1375.jpg','games/banners/far_cry_2-banner_1375.jpg',NULL,3.0,5.4,4.5,3.0,5.0),(1376,9730,383870,'Firewatch','Firewatch — одиночная игра-загадка от первого лица, действие которой происходит в лесах Вайоминга.',7.2,1,146,147,10,'2016-02-09',NULL,'games/covers/firewatch-game_cover_1376.jpg','games/banners/firewatch-banner_1376.jpg',NULL,6.5,6.4,6.0,10.0,10.0),(1377,7504,242760,'The Forest','As the lone survivor of a passenger jet crash, you find yourself in a mysterious forest battling to stay alive against a society of cannibalistic mutants. Build, explore, survive in this terrifying first person survival horror simulator.',5.6,1,148,NULL,12,'2018-04-30',NULL,'games/covers/the_forest-game_cover_1377.jpg','games/banners/the_forest-banner_1377.jpg',NULL,4.0,5.7,5.8,7.0,10.0),(1378,127346,1326470,'Sons of the Forest','Sent to find a missing billionaire on a remote island, you find yourself in a cannibal-infested hellscape. Craft, build, and struggle to survive, alone or with friends, in this terrifying new open-world survival horror simulator.',7.0,1,149,148,12,'2024-02-22',NULL,'games/covers/sons_of_the_forest-game_cover_1378.jpg','games/banners/sons_of_the_forest-banner_1378.jpg',NULL,5.5,7.8,7.5,7.0,10.0),(1380,2137,646910,'The Crew','Приобщитесь к американскому гоночному спорту. Покоряйте дороги, властвуйте на море и господствуйте в небе на просторах одного из самых потрясающих открытых миров в истории. Новинка: играйте в The Crew 2 как онлайн, так и офлайн в новом гибридном режиме, который доступен прямо сейчас!',5.7,1,152,153,10,'2014-12-01','https://cdn.akamai.steamstatic.com/steam/apps/256721267/movie_max.mp4','games/covers/the_crew-game_cover_1380.jpg','games/banners/the_crew-banner_1380.jpg',NULL,0.0,6.0,4.0,7.0,0.0),(1381,28856,889890,'The Crew 2','Прочувствуйте дух американского гоночного спорта по-настоящему благодаря Season Pass. Получите доступ к 25 транспортным средствам (в т.ч. 3 эксклюзивным), постоянную скидку 20% во внутриигровом магазине и другие бонусы!',5.8,1,153,154,10,'2018-06-29',NULL,'games/covers/the_crew_2-game_cover_1381.jpg',NULL,NULL,0.0,6.0,5.5,6.0,0.0),(1382,213475,2080690,'Sunkenland','Приготовьтесь к игре в жанре выживания в стиле &quot;Водный мир&quot;, с модульным строительством базы, поисковом затопленных городов, крафтом, защитой базы и нашествиями NPC-кланов ради ресурсов и территории. Готовы к водной апокалипсису?',4.0,1,155,NULL,12,'2023-08-26','https://cdn.akamai.steamstatic.com/steam/apps/256965890/movie_max.mp4','games/covers/sunkenland-game_cover_1382.jpg','games/banners/sunkenland-banner_1382.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1383,9254,264710,'Subnautica','Descend into the depths of an alien underwater world filled with wonder and peril. Craft equipment, pilot submarines and out-smart wildlife to explore lush coral reefs, volcanoes, cave systems, and more - all while trying to survive.',7.0,1,71,156,12,'2018-01-23','https://cdn.akamai.steamstatic.com/steam/apps/256706800/movie_max.mp4','games/covers/subnautica-game_cover_1383.jpg','games/banners/subnautica-banner_1383.jpg',NULL,4.0,6.5,7.0,9.5,10.0),(1384,107315,848450,'Subnautica: Below Zero','Отправляйтесь в ледяное подводное приключение на чужой планете. Действие Below Zero разворачивается через два года после событий оригинальной игры Subnautica. Выживайте с суровых условиях — стройте жилища, создавайте инструменты и погружайтесь еще глубже в пучину вселенной Subnautica.',0.0,0,157,NULL,10,'2021-05-13','https://cdn.akamai.steamstatic.com/steam/apps/256835066/movie_max.mp4','games/covers/subnautica_below_zero-game_cover_1384.jpg','games/banners/subnautica_below_zero-banner_1384.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1385,320,1643320,'S.T.A.L.K.E.R.: Shadow of Chernobyl','Исследуйте Чернобыльскую Зону Отчуждения полную опасных врагов, смертельных аномалий и мощных артефактов. Напишите собственную эпическую историю, прокладывая тропы к Сердцу Чернобыля. Выбирайте свой путь обдуманно, ведь он определит вашу судьбу в конце.',7.3,1,158,159,10,'2007-03-23','https://cdn.akamai.steamstatic.com/steam/apps/257404210/movie_max.mp4','games/covers/s_t_a_l_k_e_r_shadow_of_chernobyl-game_cover_1385.jpg','games/banners/s_t_a_l_k_e_r_shadow_of_chernobyl-banner_1385.jpg',NULL,5.5,5.7,5.5,10.0,10.0),(1386,4840,2427420,'S.T.A.L.K.E.R.: Clear Sky','S.T.A.L.K.E.R.: Clear Sky — вторая часть Legends of the Zone Trilogy, раскрывающая события, предшествующие первой игре.',6.7,1,160,161,10,'2008-08-22',NULL,'games/covers/s_t_a_l_k_e_r_clear_sky-game_cover_1386.jpg','games/banners/s_t_a_l_k_e_r_clear_sky-banner_1386.jpg',NULL,6.0,6.0,6.1,8.0,10.0),(1391,7605,NULL,'S.T.A.L.K.E.R.: Call of Pripyat',NULL,6.8,1,162,161,10,'2009-10-02',NULL,'games/covers/s_t_a_l_k_e_r_call_of_pripyat-game_cover_1391.jpg',NULL,NULL,5.0,6.0,7.0,8.0,10.0),(1392,80853,286690,'Metro 2033 Redux','In 2013 the world was devastated by an apocalyptic event, annihilating almost all mankind and turning the Earth\'s surface into a poisonous wasteland. A handful of survivors took refuge in the depths of the Moscow underground, and human civilization entered a new Dark Age. The year is 2033.',8.0,1,164,163,10,'2014-08-26','https://cdn.akamai.steamstatic.com/steam/apps/2034180/movie_max.mp4','games/covers/metro_2033_redux-game_cover_1392.jpg','games/banners/metro_2033_redux-banner_1392.jpg',NULL,7.0,6.0,7.0,10.0,10.0),(1393,50199,287390,'Metro: Last Light Redux','It is the year 2034. Beneath the ruins of post-apocalyptic Moscow, in the tunnels of the Metro, the remnants of mankind are besieged by deadly threats from outside – and within. Mutants stalk the catacombs beneath the desolate surface, and hunt amidst the poisoned skies above.',7.0,1,164,161,10,'2014-08-26','https://cdn.akamai.steamstatic.com/steam/apps/2034137/movie_max.mp4','games/covers/metro_last_light_redux-game_cover_1393.jpg','games/banners/metro_last_light_redux-banner_1393.jpg',NULL,6.5,6.0,6.0,8.5,10.0),(1394,37016,412020,'Metro Exodus','Оставьте позади руины московского метро и снова отправляйтесь в путешествие по постапокалиптическим землям России. Вас ждут большие нелинейные уровни, открытый мир и захватывающая сюжетная линия.',8.5,1,161,163,10,'2019-02-15','https://cdn.akamai.steamstatic.com/steam/apps/256686919/movie_max.mp4','games/covers/metro_exodus-game_cover_1394.jpg','games/banners/metro_exodus-banner_1394.jpg',NULL,8.5,8.0,8.0,10.0,8.0),(1395,1051,17410,'Mirror\'s Edge','In a city where information is heavily monitored, couriers called Runners transport sensitive data. In this seemingly utopian paradise, a crime has been committed, &amp; you are being hunted. You are a Runner called Faith and this innovative first-person action-adventure is your story.',4.4,1,74,75,10,'2008-11-11','https://cdn.akamai.steamstatic.com/steam/apps/2029872/movie_max.mp4','games/covers/mirror_s_edge-game_cover_1395.jpg','games/banners/mirror_s_edge-banner_1395.jpg',NULL,5.0,4.5,4.0,4.0,0.0),(1396,39,1941540,'Mafia','Раскройте истоки организованной преступности в Mafia: The Old Country, суровой мафиозной истории о жестоком преступном мире Сицилии 1900-х годов. Бейтесь за выживание в роли Энцо Фавары и докажите свою ценность для Семьи в этом захватывающем приключении в жанре боевика от третьего лица.',7.0,1,165,166,10,'2002-08-29','https://cdn.akamai.steamstatic.com/steam/apps/257179583/movie_max.mp4','games/covers/mafia-game_cover_1396.jpg','games/banners/mafia-banner_1396.jpg',NULL,8.0,0.0,7.0,6.0,7.0),(1397,40,1030830,'Mafia II','Чтобы расплатиться с долгами отца, герой войны Вито Скалетта связывается с мафией. Совершая преступления, он зарабатывает всё больший авторитет в криминальной семье…',9.0,1,167,151,10,'2010-08-24',NULL,'games/covers/mafia_ii-game_cover_1397.jpg','games/banners/mafia_ii-banner_1397.jpg',NULL,10.0,7.0,8.0,10.0,8.0),(1398,134070,1030840,'Mafia: Definitive Edition','После случайной встречи с мафией таксист Томми Анджело попадает в мир организованной преступности. Поначалу он настороженно относится к семье Сальери, однако большие деньги меняют его отношение…',7.5,1,168,169,10,'2020-09-25',NULL,'games/covers/mafia_definitive_edition-game_cover_1398.jpg','games/banners/mafia_definitive_edition-banner_1398.jpg',NULL,8.0,8.0,7.0,7.0,0.0),(1400,314276,NULL,'Mafia: The Old Country',NULL,5.8,1,168,169,10,'2025-08-07',NULL,'games/covers/mafia_the_old_country-game_cover_1400.jpg',NULL,NULL,6.0,6.0,5.0,6.0,0.0),(1401,131660,1254370,'No One Lives Under the Lighthouse','A slow burn retro horror game, in which you arrive at the old lighthouse on a small island near the coast of the United States. After the previous keeper has gone missing, you need to take over his duties and watch after the light.',5.8,1,170,171,10,'2020-04-21',NULL,'games/covers/no_one_lives_under_the_lighthouse-game_cover_1401.jpg','games/banners/no_one_lives_under_the_lighthouse-banner_1401.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1402,1910,238320,'Outlast','Hell is an experiment you can\'t survive in Outlast, a first-person survival horror game developed by veterans of some of the biggest game franchises in history. As investigative journalist Miles Upshur, explore Mount Massive Asylum and try to survive long enough to discover its terrible secret... if you dare.',5.3,1,172,NULL,10,'2013-09-04','https://cdn.akamai.steamstatic.com/steam/apps/2029178/movie_max.mp4','games/covers/outlast-game_cover_1402.jpg','games/banners/outlast-banner_1402.jpg',NULL,6.0,5.0,3.0,7.0,10.0),(1403,14390,414700,'Outlast II','Outlast 2 представляет вашему вниманию Sullivan Knoth и его последователей, которые оставили наш грешный мир позади, чтобы положить начало Вратам Храма, -городу, скрытому от цивилизации, в далекой глуши. Knoth и его группа, готовятся к испытаниям конца света, и вы находитесь прямов центре этих событий.',5.6,1,172,NULL,10,'2017-04-25',NULL,'games/covers/outlast_ii-game_cover_1403.jpg','games/banners/outlast_ii-banner_1403.jpg',NULL,6.0,5.8,4.0,6.5,0.0),(1404,340331,3690750,'Once Upon a Mind: A Little Too Friendly','Психологический хоррор с богатым сюжетом, вдохновленный реальным жизненным опытом. Следуйте за Эмили, 23 года, которая переезжает в Бруклин, чтобы начать все заново, но оказывается втянутой в медленную спираль одержимости и контроля.',6.0,1,NULL,NULL,10,'2025-04-16',NULL,'games/covers/once_upon_a_mind_a_little_too_friendly-game_cover_1404.jpg','games/banners/once_upon_a_mind_a_little_too_friendly-banner_1404.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1405,114455,967050,'Pacify','Онлайн-хоррор для совместной игры, в котором вам предстоит умиротворять, ослаблять и захватывать сверхъестественных существ. Каждый уровень отличается собственным сюжетом, монстрами и вариантами финала. Играйте в одиночку или с друзьями. В игре доступен голосовой чат с забавными эффектами.',4.0,1,173,174,10,'2019-02-22','https://cdn.akamai.steamstatic.com/steam/apps/256740850/movie_max.mp4','games/covers/pacify-game_cover_1405.jpg','games/banners/pacify-banner_1405.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1406,342489,2119830,'Misery','MISERY это ко-оп игра для 1–10 игроков. Вы в зоне ядерной катастрофы и каждый день здесь это борьба: исследуйте радиоактивные руины, стройте бункер, крафтите оружие и вместе с друзьями исследуйте опасный процедурно-сгенерированный мир. Остерегайтесь аномалий, монстров и вооружённых бандитов!',6.2,1,175,176,10,'2025-10-23',NULL,'games/covers/misery-game_cover_1406.jpg','games/banners/misery-banner_1406.jpg',NULL,0.0,5.5,6.0,7.0,6.0),(1407,133748,1818450,'Stalzone','STALZONE — это extraction-шутер с живым открытым миром, где постоянный прогресс сочетается с риском, растущим по мере продвижения в Зону. Тебя ждет Чернобыльская Зона Отчуждения, искаженная аномалиями и разорванная на территории враждующих фракций',5.2,1,177,NULL,10,'2022-12-09','https://cdn.akamai.steamstatic.com/steam/apps/257373299/movie_max.mp4','games/covers/stalzone-game_cover_1407.jpg','games/banners/stalzone-banner_1407.jpg',NULL,3.0,6.0,5.0,6.0,10.0),(1408,111,57300,'Amnesia: The Dark Descent','Amnesia: The Dark Descent, a first person survival horror. A game about immersion, discovery and living through a nightmare. An experience that will chill you to the core.',0.0,0,178,NULL,10,'2010-09-08',NULL,'games/covers/amnesia_the_dark_descent-game_cover_1408.jpg','games/banners/amnesia_the_dark_descent-banner_1408.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1410,119313,NULL,'Fall Guys',NULL,0.0,0,180,181,10,'2020-08-04',NULL,'games/covers/fall_guys-game_cover_1410.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1411,11119,588430,'Fallout Shelter','Fallout Shelter дарит вам возможность управлять высокотехнологичным подземным убежищем от «Волт-Тек». Постройте лучшее убежище, сделайте его обитателей счастливыми, защитите их от опасностей Пустоши.',6.0,1,182,183,10,'2015-06-14',NULL,'games/covers/fallout_shelter-game_cover_1411.jpg','games/banners/fallout_shelter-banner_1411.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1412,128474,696220,'Folklore Hunter','You’re a world-renowned hunter of supernatural beasts. Track down urban legends from all over the world, set traps, solve disturbing puzzles, and defeat the beasts before you succumb to their otherworldly presence.',0.0,0,184,NULL,12,'2026-01-30',NULL,'games/covers/folklore_hunter-game_cover_1412.jpg','games/banners/folklore_hunter-banner_1412.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1413,2552,234140,'Mad Max','Играйте за Безумного Макса, непрогибаемого героя и настоящего бойца, единственное чего он хочет - оставить безумие позади и найти покой.',6.3,1,185,186,10,'2015-09-01','https://cdn.akamai.steamstatic.com/steam/apps/2038914/movie_max.mp4','games/covers/mad_max-game_cover_1413.jpg','games/banners/mad_max-banner_1413.jpg',NULL,5.0,6.0,6.0,8.0,10.0),(1414,498,1285190,'Borderlands','Borderlands 4 — это полный хаоса лутер-шутер, битком набитый миллиардами пушек, смертельно опасными врагами и интенсивным кооперативным экшеном. Вырвитесь на свободу с опасной скрытой планеты в качестве одного из четырех новых безбашенных Искателей Хранилища.',6.4,1,167,187,10,'2009-10-20','https://cdn.akamai.steamstatic.com/steam/apps/257195810/movie_max.mp4','games/covers/borderlands-game_cover_1414.jpg','games/banners/borderlands-banner_1414.jpg',NULL,5.0,6.5,7.0,7.0,8.0),(1415,1011,49520,'Borderlands 2','Дополнение Ultimate Vault Hunter’s Upgrade позволит вам выжать из Borderlands 2 максимум.',7.1,1,188,167,10,'2012-09-18',NULL,'games/covers/borderlands_2-game_cover_1415.jpg','games/banners/borderlands_2-banner_1415.jpg',NULL,5.5,7.5,7.5,8.0,10.0),(1416,6032,261640,'Borderlands: The Pre-Sequel','Launch into the Borderlands universe and shoot ‘n’ loot your way through a brand new adventure that rockets you onto Pandora’s moon in Borderlands: The Pre-Sequel!',5.0,1,189,188,10,'2014-10-14','https://cdn.akamai.steamstatic.com/steam/apps/2035009/movie_max.mp4','games/covers/borderlands_the_pre_sequel-game_cover_1416.jpg','games/banners/borderlands_the_pre_sequel-banner_1416.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1417,3084,223710,'Cry of Fear','Cry of Fear is a psychological single-player and co-op horror game set in a deserted town filled with horrific creatures and nightmarish delusions. You play as a young man desperately searching for answers in the cold Scandinavian night, finding his way through the city as he slowly descends into madness.',7.0,1,190,NULL,10,'2013-04-25',NULL,'games/covers/cry_of_fear-game_cover_1417.jpg',NULL,NULL,6.0,4.0,6.0,9.0,10.0),(1418,301426,2737070,'Crime Simulator','Вы на свободе, но долг остался. Крадитесь, воруйте и проникайте в дома в одиночку или в кооп-режиме на 4 игроков. Используйте отмычки, усыпляющий газ и грубую силу, чтобы выполнять задания, перехитрить охрану и заработать денег до истечения срока. Сможете вернуть долг или все потеряете?',0.0,0,191,192,10,'2025-06-17',NULL,'games/covers/crime_simulator-game_cover_1418.jpg','games/banners/crime_simulator-banner_1418.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1419,228856,274940,'Depth','Окунитесь в темный подводный мир, где вам предстоит стать акулой или водолазом и одолеть своих врагов с помощью смекалки, командной игры и скрытности. Приготовьтесь познать беспощадный экшн и напряженность охоты. В Depth вам всегда придется быть начеку, ведь ИИ-противники или другие игроки не дадут вам отдохнуть ни секунды.',0.0,0,NULL,NULL,10,NULL,NULL,NULL,'games/banners/depth-banner_1419.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1421,290959,2625420,'Drive Beyond Horizons','Исследуйте, выживайте и выходите за пределы горизонта в огромном процедурно генерируемом мире. Настраивайте свой транспорт, сталкивайтесь с непредсказуемыми событиями, собирайте ресурсы и отправляйтесь в уникальное приключение в одиночку или с участием до 4 игроков.',0.0,0,194,NULL,10,'2025-03-24',NULL,'games/covers/drive_beyond_horizons-game_cover_1421.jpg','games/banners/drive_beyond_horizons-banner_1421.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1422,17832,322330,'Don\'t Starve Together','Fight, Farm, Build and Explore Together in the standalone multiplayer expansion to the uncompromising wilderness survival game, Don\'t Starve.',0.0,0,195,NULL,10,'2016-04-21','https://cdn.akamai.steamstatic.com/steam/apps/256833381/movie_max.mp4','games/covers/don_t_starve_together-game_cover_1422.jpg','games/banners/don_t_starve_together-banner_1422.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1423,3042,239140,'Dying Light','Боевик от первого лица с элементами выживания, действие которого разворачиваются в постапокалиптическом мире, кишащем кровожадными зомби. Изучите город, уничтоженный загадочным вирусом: собирайте ресурсы, создавайте оружие и сражайтесь с полчищами мутантов.',7.0,1,196,196,10,'2015-01-26','https://cdn.akamai.steamstatic.com/steam/apps/2036854/movie_max.mp4','games/covers/dying_light-game_cover_1423.jpg','games/banners/dying_light-banner_1423.jpg',NULL,6.0,5.5,6.3,9.0,10.0),(1424,102584,534380,'Dying Light 2: Stay Human','Человечество погрязло в войне с вирусом. Погрузитесь в мир, переживший зомби-апокалипсис, где паркур и боевые навыки — ключ к выживанию. Исследуйте Город при свете дня, но даже не думайте спускаться с крыш по ночам, если вам жизнь дорога.',8.2,1,196,197,10,'2022-02-03',NULL,'games/covers/dying_light_2_stay_human-game_cover_1424.jpg','games/banners/dying_light_2_stay_human-banner_1424.jpg',NULL,7.5,8.0,8.5,9.0,8.0),(1425,314252,3008130,'Dying Light: The Beast','Вы — Кайл Крейн. Долгие годы вы были подопытным и вот наконец вышли на тропу мести. Вас ждет уникальная комбинация боевика в открытом мире и хоррора на выживание. Тому, кто превратил вас в получеловека-полузверя, несдобровать.',7.0,1,196,NULL,10,'2025-09-18','https://cdn.akamai.steamstatic.com/steam/apps/257201584/movie_max.mp4','games/covers/dying_light_the_beast-game_cover_1425.jpg','games/banners/dying_light_the_beast-banner_1425.jpg',NULL,6.0,9.0,6.5,7.5,7.0),(1426,27134,548430,'Deep Rock Galactic','Deep Rock Galactic — кооперативный шутер от первого лица для 1-4 игроков, в котором вас ждут крутые космические дворфы, полностью разрушаемое окружение, процедурно генерируемые системы пещер, а также бесконечные волны инопланетных чудовищ.',6.3,1,198,199,10,'2020-05-13','https://cdn.akamai.steamstatic.com/steam/apps/256783673/movie_max.mp4','games/covers/deep_rock_galactic-game_cover_1426.jpg','games/banners/deep_rock_galactic-banner_1426.jpg',NULL,0.0,6.5,6.0,6.5,7.0),(1427,19565,2651280,'Marvel\'s Spider-Man','Достичь большего. Вместе. Невероятная сила симбиота становится серьезным вызовом для Питера Паркера и Майлза Моралеса. В этой части знаменитой франшизы им предстоит искать баланс между личной жизнью, дружбой и долгом, призывающим помогать людям.',8.2,1,200,201,10,'2018-09-07','https://cdn.akamai.steamstatic.com/steam/apps/257093509/movie_max.mp4','games/covers/marvel_s_spider_man-game_cover_1427.jpg','games/banners/marvel_s_spider_man-banner_1427.jpg',NULL,8.0,8.0,8.0,10.0,10.0),(1428,134581,1817190,'Marvel\'s Spider-Man: Miles Morales','После событий «MARVEL Человек-Паук. Обновленная версия» юный Майлз Моралес пытается привыкнуть к своему новому дому и продолжает дело своего наставника Питера Паркера в качестве нового Человека-паука. Когда его дому грозит страшная опасность, Майлз надевает костюм и становится Человеком-Пауком.',8.6,1,200,201,10,'2020-11-12','https://cdn.akamai.steamstatic.com/steam/apps/256915117/movie_max.mp4','games/covers/marvel_s_spider_man_miles_morales-game_cover_1428.jpg','games/banners/marvel_s_spider_man_miles_morales-banner_1428.jpg',NULL,8.0,8.5,8.0,10.0,10.0),(1429,240,NULL,'Battlefield 1942',NULL,0.0,0,202,75,10,'2002-09-10',NULL,'games/covers/battlefield_1942-game_cover_1429.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1430,335,NULL,'Battlefield Vietnam',NULL,0.0,0,75,203,10,'2004-03-14',NULL,'games/covers/battlefield_vietnam-game_cover_1430.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1431,277,1932460,'Battlefield 2','Battlefield™ 2042 original score by composers Hildur Guðnadóttir &amp; Sam Slater.',6.0,1,75,204,10,'2005-06-21',NULL,'games/covers/battlefield_2-game_cover_1431.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1432,349,NULL,'Battlefield 2142',NULL,0.0,0,75,74,10,'2006-10-17',NULL,'games/covers/battlefield_2142-game_cover_1432.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1433,473,2807960,'Battlefield: Bad Company','Вас ждёт невероятное погружение в тотальную войну. В войне с танками, истребителями и огромным боевым арсеналом ваш отряд — самое смертоносное оружие.',0.0,0,75,74,10,'2008-06-23','https://cdn.akamai.steamstatic.com/steam/apps/257382517/movie_max.mp4','games/covers/battlefield_bad_company-game_cover_1433.jpg','games/banners/battlefield_bad_company-banner_1433.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1434,352,NULL,'Battlefield: Bad Company 2',NULL,5.7,1,75,74,10,'2010-03-02',NULL,'games/covers/battlefield_bad_company_2-game_cover_1434.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1435,873,55230,'Saints Row: The Third','Приготовьтесь стать участником самых нелепых событий из когда-либо виденных в играх, помогая Святым 3-й улицы в борьбе с Синдикатом!',6.7,1,205,161,10,'2011-11-15','https://cdn.akamai.steamstatic.com/steam/apps/80798/movie_max.mp4','games/covers/saints_row_the_third-game_cover_1435.jpg','games/banners/saints_row_the_third-banner_1435.jpg',NULL,5.0,6.0,9.0,6.5,10.0),(1436,1981,206420,'Saints Row IV','Насладитесь безумием Saints Row IV. Святые прошли долгий тяжелый путь от пентхауса до Белого дома, но теперь Земля оказалась под гнетом инопланетян, и только вам под силу спасти ее с помощью арсенала суперспособностей и необычного оружия в самой безумной игре с открытым миром.',5.8,1,206,161,10,'2013-08-20',NULL,'games/covers/saints_row_iv-game_cover_1436.jpg','games/banners/saints_row_iv-banner_1436.jpg',NULL,6.0,5.0,7.0,5.0,10.0),(1437,3277,252490,'Rust','Единственная цель в Rust — выживание. Дикая природа острова, его обитатели, окружение, другие выжившие — всё вокруг хочет твоей смерти. Делай всё, что в твоих силах, чтобы пережить ещё одну ночь.',6.5,1,207,NULL,10,'2018-02-08',NULL,'games/covers/rust-game_cover_1437.jpg','games/banners/rust-banner_1437.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1438,186477,1807080,'Ghost Exile','GhostExile - это кооперативный ужас до 4 игроков. При охоте на призраков вам нужно: определить тип призрака и провести ритуал изгнания - тогда призрак больше не сможет причинить кому-то вред. Будьте осторожны! Поспешные выводы могут привести вас к печальному исходу.',0.0,0,208,NULL,10,'2022-01-07','https://cdn.akamai.steamstatic.com/steam/apps/256867246/movie_max.mp4','games/covers/ghost_exile-game_cover_1438.jpg','games/banners/ghost_exile-banner_1438.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1439,24985,431240,'Golf With Your Friends','Для чего нужны друзья, как не для того, чтобы играть с ними в гольф... в Golf With Your Friends! Забудьте о границах и почувствуйте драйв, играя в захватывающий динамичный синхронный мини-гольф компанией до 12 игроков!',5.0,1,209,210,10,'2020-05-19','https://cdn.akamai.steamstatic.com/steam/apps/257052332/movie_max.mp4','games/covers/golf_with_your_friends-game_cover_1439.jpg','games/banners/golf_with_your_friends-banner_1439.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1440,101461,815370,'Green Hell','Боритесь за жизнь в открытом мире суровых джунглей Амазонии. Задействуйте реальные методы выживания: собирайте ресурсы, добывайте пищу, сражайтесь с представителями местной фауны, обустройте временное жилище или возведите настоящую крепость.',0.0,0,211,212,10,'2019-09-05','https://cdn.akamai.steamstatic.com/steam/apps/256761208/movie_max.mp4','games/covers/green_hell-game_cover_1440.jpg','games/banners/green_hell-banner_1440.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1441,125624,962130,'Grounded','The world is a vast, beautiful and dangerous place – especially when you have been shrunk to the size of an ant. Can you thrive alongside the hordes of giant insects, fighting to survive the perils of the backyard?',0.0,0,213,214,10,'2022-09-27','https://cdn.akamai.steamstatic.com/steam/apps/257016122/movie_max.mp4','games/covers/grounded-game_cover_1441.jpg','games/banners/grounded-banner_1441.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1442,3278,4000,'Garry\'s Mod','Garry\'s Mod is a physics sandbox. There aren\'t any predefined aims or goals. We give you the tools and leave you to play.',0.0,0,118,207,10,'2004-12-24',NULL,'games/covers/garry_s_mod-game_cover_1442.jpg','games/banners/garry_s_mod-banner_1442.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1444,122522,1149620,'Gas Station Simulator','Купите заброшенную заправочную станцию и восстановите ее во всей красе. Ремонт, модернизация и расширение предлагаемых услуг, чтобы идти в ногу с требованиями ваших клиентов.',0.0,0,215,216,10,'2021-09-15',NULL,'games/covers/gas_station_simulator-game_cover_1444.jpg','games/banners/gas_station_simulator-banner_1444.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1445,306881,1250,'Killing Floor','6-player co-op survival horror at its finest! Free updates, free special events and a ridiculous amount of fun!',0.0,0,217,NULL,10,'2005-08-31','https://cdn.akamai.steamstatic.com/steam/apps/5243/movie_max.mp4','games/covers/killing_floor-game_cover_1445.jpg','games/banners/killing_floor-banner_1445.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1446,6748,232090,'Killing Floor 2','Совместная мясорубка на шестерых против мутантов. А теперь и режим «Выживание VS» на 12 игроков — почувствуйте себя в шкуре мутанта!',6.5,1,218,161,12,'2016-11-18','https://cdn.akamai.steamstatic.com/steam/apps/256674823/movie_max.mp4','games/covers/killing_floor_2-game_cover_1446.jpg','games/banners/killing_floor_2-banner_1446.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1447,135400,1912410,'Minecraft','Бросай кирку, хватай меч и отправляйся в новое приключение в Minecraft Dungeons II. Оформите предзаказ сегодня и получите 2 скина героя, Искаженный плащ и питомца Искаженная курица!',7.0,1,219,220,12,'2016-12-19','https://cdn.akamai.steamstatic.com/steam/apps/257403901/movie_max.mp4','games/covers/minecraft-game_cover_1447.jpg',NULL,NULL,0.0,0.0,0.0,0.0,0.0),(1448,241492,307780,'Mortal Kombat X','Встречайте продолжение популярнейшей серии файтингов! Mortal Kombat X – это кинематографическая подача невероятного качества и обновленная игровая механика.',6.3,1,221,222,14,NULL,NULL,'games/covers/mortal_kombat_x-game_cover_1448.jpg','games/banners/mortal_kombat_x-banner_1448.jpg',NULL,0.0,6.0,7.0,6.0,7.0),(1449,112916,NULL,'Mortal Kombat 11',NULL,6.8,1,223,221,10,'2019-04-22',NULL,'games/covers/mortal_kombat_11-game_cover_1449.jpg',NULL,NULL,0.0,7.5,6.0,7.0,0.0),(1450,296,2096610,'Crysis','В Crysis 3 Remastered вы сможете вновь пережить события классического боевика Crysis 3, оптимизированного для современных систем.',6.0,1,142,75,10,'2007-11-13',NULL,'games/covers/crysis-game_cover_1450.jpg','games/banners/crysis-banner_1450.jpg',NULL,5.0,6.0,7.0,6.0,0.0),(1451,336,17330,'Crysis Warhead','Невероятное продолжение лучшей игры для ПК 2007-го года*: На этот раз вам предстоит взглянуть на события глазами сержанта Сайкса. Ничем не примечательная операция в тылу врага превращается в сущий ад, когда вы узнаете, что противник захватил некий объект, могущий повлиять на исход войны в целом. Теперь ваша задача — перехватить этот груз.',0.0,0,75,224,10,'2008-09-16',NULL,'games/covers/crysis_warhead-game_cover_1451.jpg','games/banners/crysis_warhead-banner_1451.jpg',NULL,0.0,0.0,0.0,0.0,0.0),(1452,471,2096600,'Crysis 2','В Crysis 2 Remastered вы сможете вновь окунуться в мир легендарного боевика Crysis 2, оптимизированный для современных систем.',7.5,1,142,75,10,'2011-03-22',NULL,'games/covers/crysis_2-game_cover_1452.jpg','games/banners/crysis_2-banner_1452.jpg',NULL,7.0,7.0,8.0,8.0,10.0),(1453,1268,NULL,'Crysis 3',NULL,7.6,1,142,75,10,'2013-02-19',NULL,'games/covers/crysis_3-game_cover_1453.jpg',NULL,NULL,6.5,8.0,8.0,8.0,8.0);
/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `idGenre` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idGenre`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (36,'MOBA'),(33,'Аркада'),(11,'В реальном времени'),(34,'Визуальная новелла'),(26,'Викторина'),(9,'Головоломка'),(10,'Гонки'),(32,'Инди'),(35,'Карточная'),(2,'Квест'),(7,'Музыка'),(30,'Пинбол'),(8,'Платформер'),(16,'Пошаговая'),(31,'Приключение'),(12,'Ролевая'),(13,'Симулятор'),(25,'Слэшер'),(14,'Спортивная'),(15,'Стратегия'),(24,'Тактика'),(4,'Файтинг'),(5,'Шутер');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes` (
  `user_id` int NOT NULL,
  `entity_id` int NOT NULL,
  `entity_type` varchar(45) NOT NULL,
  PRIMARY KEY (`user_id`,`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES (34,138,'news'),(34,140,'news'),(34,144,'news'),(34,146,'news'),(34,149,'news'),(34,151,'news'),(34,153,'news'),(34,154,'news'),(34,155,'news'),(34,158,'news'),(34,159,'news'),(34,160,'news');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_news_likes_count` AFTER INSERT ON `likes` FOR EACH ROW BEGIN
	IF NEW.entity_type = 'news' THEN
    	UPDATE News
        SET likes_count = (
        	SELECT COUNT(*) FROM Likes
            WHERE entity_type = 'news' AND entity_id = NEW.entity_id
        )
        WHERE idNew = NEW.entity_id;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_news_likes_count_delete` AFTER DELETE ON `likes` FOR EACH ROW BEGIN
	IF OLD.entity_type = 'news' THEN
    	UPDATE News
        SET likes_count = (
        	SELECT COUNT(*) FROM Likes
            WHERE entity_type = 'news' AND entity_id = OLD.entity_id
        )
        WHERE idNew = OLD.entity_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `modes`
--

DROP TABLE IF EXISTS `modes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modes` (
  `idMode` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idMode`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modes`
--

LOCK TABLES `modes` WRITE;
/*!40000 ALTER TABLE `modes` DISABLE KEYS */;
INSERT INTO `modes` VALUES (5,'MMO'),(6,'Баттл Рояль'),(3,'Кооперативная'),(2,'Мультиплеер'),(1,'Одиночная'),(4,'Разделённый экран');
/*!40000 ALTER TABLE `modes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `idNew` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `short_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext NOT NULL,
  `cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `likes` int NOT NULL DEFAULT '0',
  `comments` int NOT NULL DEFAULT '0',
  `views` int NOT NULL DEFAULT '0',
  `status_id` int NOT NULL DEFAULT '1',
  `category_id` int DEFAULT NULL,
  `game_id` int DEFAULT NULL,
  `author_id` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idNew`),
  KEY `fk_news_status` (`status_id`),
  KEY `fk_news_author` (`author_id`),
  KEY `fk_news_game` (`game_id`),
  KEY `fk_news_category` (`category_id`),
  CONSTRAINT `fk_news_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  CONSTRAINT `fk_news_category` FOREIGN KEY (`category_id`) REFERENCES `news_categories` (`idCategory`) ON DELETE SET NULL,
  CONSTRAINT `fk_news_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE SET NULL,
  CONSTRAINT `fk_news_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`)
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_categories`
--

DROP TABLE IF EXISTS `news_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news_categories` (
  `idCategory` int NOT NULL AUTO_INCREMENT,
  `name` varchar(90) NOT NULL,
  PRIMARY KEY (`idCategory`),
  UNIQUE KEY `uq_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_categories`
--

LOCK TABLES `news_categories` WRITE;
/*!40000 ALTER TABLE `news_categories` DISABLE KEYS */;
INSERT INTO `news_categories` VALUES (5,'VR'),(2,'Анонсы'),(7,'Индустрия'),(4,'Консоли'),(6,'Патчи'),(1,'ПК'),(3,'Релизы'),(8,'Слухи');
/*!40000 ALTER TABLE `news_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perspectives`
--

DROP TABLE IF EXISTS `perspectives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perspectives` (
  `idPerspective` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idPerspective`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perspectives`
--

LOCK TABLES `perspectives` WRITE;
/*!40000 ALTER TABLE `perspectives` DISABLE KEYS */;
INSERT INTO `perspectives` VALUES (1,'От первого лица'),(2,'От третьего лица'),(3,'Сверху/Изометрия'),(4,'Вид сбоку'),(5,'Текст'),(6,'Аудио'),(7,'VR');
/*!40000 ALTER TABLE `perspectives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platforms`
--

DROP TABLE IF EXISTS `platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platforms` (
  `idPlatform` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `short` varchar(255) DEFAULT NULL,
  `brand_id` int DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idPlatform`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `short` (`short`),
  KEY `fk_brand_id` (`brand_id`),
  CONSTRAINT `fk_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`idBrand`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=509 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platforms`
--

LOCK TABLES `platforms` WRITE;
/*!40000 ALTER TABLE `platforms` DISABLE KEYS */;
INSERT INTO `platforms` VALUES (3,'Linux','Linux',NULL,'1991-01-01',0),(4,'Commodore 64','C64',3,'1982-08-01',0),(6,'PC','PC',NULL,'1985-11-20',0),(7,'Sony PlayStation','PS',1,'1994-12-03',0),(8,'Sony PlayStation 2','PS2',1,'2000-03-04',0),(9,'Sony PlayStation 3','PS3',1,'2006-11-11',0),(11,'Microsoft Xbox','Xbox',2,'2001-11-15',0),(12,'Microsoft Xbox 360','Xbox 360',2,'2005-11-22',0),(14,'Apple Mac','Mac',5,'1984-01-24',0),(15,'Commodore 128','C128',7,'1985-01-01',0),(18,'Nintendo Entertainment System','NES',3,'1985-10-18',0),(19,'Super Nintendo','SNES',3,'1990-11-21',0),(20,'Nintendo DS','DS',3,'2004-11-21',0),(21,'Nintendo GameCube','GC',3,'2001-09-14',0),(29,'Sega Mega Drive','MD',4,'1988-10-29',0),(30,'Sega 32X','32X',4,'1994-11-21',0),(32,'Sega Saturn','Saturn',4,'1994-11-22',0),(35,'Sega Game Gear','GG',4,'1990-10-06',0),(37,'Nintendo 3DS','3DS',3,'2011-02-26',0),(38,'Sony PlayStation Portable','PSP',1,'2004-12-12',0),(39,'Apple iOS','iOS',5,'2007-06-29',0),(46,'Sony PlayStation Vita','PS Vita',1,'2011-12-17',0),(48,'Sony PlayStation 4','PS4',1,'2013-11-15',0),(49,'Microsoft Xbox One','Xbox One',2,'2013-11-22',0),(59,'Atari 2600','A2600',6,'1977-09-11',0),(60,'Atari 7800','A7800',6,'1986-05-01',0),(61,'Atari Lynx','Lynx',6,'1989-09-01',0),(62,'Atari Jaguar','Jaguar',6,'1993-11-23',0),(63,'Atari ST','ST',6,'1985-06-01',0),(64,'Sega Master System','SMS',4,'1986-10-20',0),(65,'Atari 8-bit','A8bit',6,'1982-01-01',0),(66,'Atari 5200','A5200',6,'1982-11-01',0),(71,'Commodore VIC-20','VIC-20',7,'1980-06-01',0),(75,'Apple II','Apple II',5,'1977-06-10',0),(78,'Sega CD','SCD',4,'1992-12-18',0),(90,'Commodore PET','PET',7,'1977-01-01',0),(93,'Commodore 16','C16',7,'1984-01-01',0),(94,'Commodore Plus/4','Plus/4',7,'1984-01-01',0),(130,'Nintendo Switch','NSW',3,'2017-03-03',0),(158,'Commodore CDTV','CDTV',7,'1991-01-01',0),(159,'Nintendo DSi','DSi',3,'2008-11-01',0),(165,'Sony PlayStation VR','PS VR',1,'2016-10-13',0),(167,'Sony PlayStation 5','PS5',1,'2020-11-12',0),(169,'Microsoft Xbox Series X|S','Xbox Series X|S',2,'2020-11-10',0),(339,'Sega Pico','Pico',4,NULL,0),(390,'Sony PlayStation VR2','PS VR2',1,'2023-02-22',0),(410,'Atari Jaguar CD','Jag CD',6,'1995-09-21',0),(482,'Sega CD 32X','CD32X',4,'1993-08-01',0),(508,'Nintendo Switch 2','NSW2',3,'2025-06-05',0);
/*!40000 ALTER TABLE `platforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_categories`
--

DROP TABLE IF EXISTS `question_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_categories` (
  `idSection` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idSection`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_categories`
--

LOCK TABLES `question_categories` WRITE;
/*!40000 ALTER TABLE `question_categories` DISABLE KEYS */;
INSERT INTO `question_categories` VALUES (5,'admin_question'),(1,'advertisement'),(8,'another'),(6,'find_game'),(7,'problems'),(2,'site_issues'),(11,'system_requirements'),(3,'vacancies');
/*!40000 ALTER TABLE `question_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `idQuestion` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор вопроса',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Заголовок вопроса',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Описание вопроса',
  `status` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'open' COMMENT 'Статус вопроса',
  `comments_count` int NOT NULL DEFAULT '0' COMMENT 'Счётчик комментариев',
  `views_count` int DEFAULT '0' COMMENT 'Счётчик просмотров',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания',
  `section_id` int NOT NULL COMMENT 'Идентификатор раздела',
  `user_id` int NOT NULL COMMENT 'Идентификатор автора',
  `moderated_status` enum('active','hidden','deleted') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active' COMMENT 'Статус модерации',
  `moderated_by` int DEFAULT NULL COMMENT 'Идентификатор модератора',
  `moderation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Причина модерации',
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Примечание',
  PRIMARY KEY (`idQuestion`),
  KEY `fk_qsection` (`section_id`),
  KEY `fk_userQstn` (`user_id`),
  KEY `idx_questions_status_section_date` (`status`,`section_id`,`created_at` DESC),
  KEY `idx_questions_user_id` (`user_id`),
  KEY `fk_questions_moderated_by` (`moderated_by`),
  CONSTRAINT `fk_qsection` FOREIGN KEY (`section_id`) REFERENCES `question_categories` (`idSection`) ON DELETE CASCADE,
  CONSTRAINT `fk_questions_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  CONSTRAINT `fk_userQstn` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `idReport` int NOT NULL AUTO_INCREMENT,
  `reason` enum('spam') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `reporter_id` int NOT NULL,
  `entity_type` enum('comment','news') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `entity_id` int NOT NULL,
  `status_id` int NOT NULL,
  `moterated_by` int NOT NULL,
  `moderation_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `moderated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idReport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `idReview` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор рецензии',
  `title` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Заголовок',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Контент',
  `views` int NOT NULL DEFAULT '0' COMMENT 'Кол-во просмотров',
  `comments` int NOT NULL DEFAULT '0' COMMENT 'Кол-во комментариев',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания',
  `game_id` int NOT NULL COMMENT 'Идентификатор игры',
  `user_id` int NOT NULL COMMENT 'Идентификатор автора',
  `rating_id` int DEFAULT NULL COMMENT 'Идентификатор рейтинга',
  `moderated_status` enum('active','hidden','deleted') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active' COMMENT 'Статус модерации',
  `moderated_by` int DEFAULT NULL COMMENT 'Идентификатор модератора',
  `moderation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Причина модерации',
  PRIMARY KEY (`idReview`),
  UNIQUE KEY `unique_user_game` (`game_id`,`user_id`),
  KEY `fk_reviews_user` (`user_id`),
  KEY `fk_rating_game` (`rating_id`),
  KEY `fk_reviews_moderated_by` (`moderated_by`),
  CONSTRAINT `fk_rating_game` FOREIGN KEY (`rating_id`) REFERENCES `game_ratings` (`idGameRating`) ON DELETE SET NULL,
  CONSTRAINT `fk_reviews_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `idRole` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'user',
  PRIMARY KEY (`idRole`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (4,'admin'),(3,'moderator'),(2,'news_maker'),(1,'user');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screenshots`
--

DROP TABLE IF EXISTS `screenshots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screenshots` (
  `idScreenshot` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `image_key` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`idScreenshot`),
  UNIQUE KEY `unique_image-key` (`image_key`),
  KEY `fk_game_screenshot` (`game_id`),
  CONSTRAINT `fk_game_screenshot` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2867 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screenshots`
--

LOCK TABLES `screenshots` WRITE;
/*!40000 ALTER TABLE `screenshots` DISABLE KEYS */;
INSERT INTO `screenshots` VALUES (2284,1321,'games/screenshots/bodycam-screenshot_1321_1.jpg'),(2285,1321,'games/screenshots/bodycam-screenshot_1321_2.jpg'),(2286,1321,'games/screenshots/bodycam-screenshot_1321_3.jpg'),(2287,1321,'games/screenshots/bodycam-screenshot_1321_4.jpg'),(2288,1321,'games/screenshots/bodycam-screenshot_1321_5.jpg'),(2289,1322,'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_1.jpg'),(2290,1322,'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_2.jpg'),(2291,1322,'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_3.jpg'),(2292,1322,'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_4.jpg'),(2293,1322,'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_5.jpg'),(2294,1323,'games/screenshots/payday_2-screenshot_1323_1.jpg'),(2295,1323,'games/screenshots/payday_2-screenshot_1323_2.jpg'),(2296,1323,'games/screenshots/payday_2-screenshot_1323_3.jpg'),(2297,1323,'games/screenshots/payday_2-screenshot_1323_4.jpg'),(2298,1323,'games/screenshots/payday_2-screenshot_1323_5.jpg'),(2299,1324,'games/screenshots/battlefield_4-screenshot_1324_1.jpg'),(2300,1324,'games/screenshots/battlefield_4-screenshot_1324_2.jpg'),(2301,1324,'games/screenshots/battlefield_4-screenshot_1324_3.jpg'),(2302,1324,'games/screenshots/battlefield_4-screenshot_1324_4.jpg'),(2303,1324,'games/screenshots/battlefield_4-screenshot_1324_5.jpg'),(2304,1325,'games/screenshots/battlefield_3-screenshot_1325_1.jpg'),(2305,1325,'games/screenshots/battlefield_3-screenshot_1325_2.jpg'),(2306,1326,'games/screenshots/ghostrunner-screenshot_1326_1.jpg'),(2307,1326,'games/screenshots/ghostrunner-screenshot_1326_2.jpg'),(2308,1326,'games/screenshots/ghostrunner-screenshot_1326_3.jpg'),(2309,1326,'games/screenshots/ghostrunner-screenshot_1326_4.jpg'),(2310,1326,'games/screenshots/ghostrunner-screenshot_1326_5.jpg'),(2311,1327,'games/screenshots/evil_west-screenshot_1327_1.jpg'),(2312,1327,'games/screenshots/evil_west-screenshot_1327_2.jpg'),(2313,1327,'games/screenshots/evil_west-screenshot_1327_3.jpg'),(2314,1328,'games/screenshots/tom_clancy_s_the_division-screenshot_1328_1.jpg'),(2315,1328,'games/screenshots/tom_clancy_s_the_division-screenshot_1328_2.jpg'),(2316,1328,'games/screenshots/tom_clancy_s_the_division-screenshot_1328_3.jpg'),(2317,1328,'games/screenshots/tom_clancy_s_the_division-screenshot_1328_4.jpg'),(2318,1328,'games/screenshots/tom_clancy_s_the_division-screenshot_1328_5.jpg'),(2319,1329,'games/screenshots/batman_arkham_asylum-screenshot_1329_1.jpg'),(2320,1329,'games/screenshots/batman_arkham_asylum-screenshot_1329_2.jpg'),(2321,1330,'games/screenshots/miside-screenshot_1330_1.jpg'),(2322,1330,'games/screenshots/miside-screenshot_1330_2.jpg'),(2323,1330,'games/screenshots/miside-screenshot_1330_3.jpg'),(2324,1330,'games/screenshots/miside-screenshot_1330_4.jpg'),(2325,1330,'games/screenshots/miside-screenshot_1330_5.jpg'),(2326,1331,'games/screenshots/mindseye-screenshot_1331_1.jpg'),(2327,1331,'games/screenshots/mindseye-screenshot_1331_2.jpg'),(2328,1331,'games/screenshots/mindseye-screenshot_1331_3.jpg'),(2329,1331,'games/screenshots/mindseye-screenshot_1331_4.jpg'),(2330,1331,'games/screenshots/mindseye-screenshot_1331_5.jpg'),(2331,1332,'games/screenshots/my_friend_pedro-screenshot_1332_1.jpg'),(2332,1332,'games/screenshots/my_friend_pedro-screenshot_1332_2.jpg'),(2333,1332,'games/screenshots/my_friend_pedro-screenshot_1332_3.jpg'),(2334,1332,'games/screenshots/my_friend_pedro-screenshot_1332_4.jpg'),(2335,1332,'games/screenshots/my_friend_pedro-screenshot_1332_5.jpg'),(2336,1333,'games/screenshots/it_takes_two-screenshot_1333_1.jpg'),(2337,1333,'games/screenshots/it_takes_two-screenshot_1333_2.jpg'),(2338,1333,'games/screenshots/it_takes_two-screenshot_1333_3.jpg'),(2339,1333,'games/screenshots/it_takes_two-screenshot_1333_4.jpg'),(2340,1334,'games/screenshots/mouse_p_i_for_hire-screenshot_1334_1.jpg'),(2341,1334,'games/screenshots/mouse_p_i_for_hire-screenshot_1334_2.jpg'),(2342,1334,'games/screenshots/mouse_p_i_for_hire-screenshot_1334_3.jpg'),(2343,1334,'games/screenshots/mouse_p_i_for_hire-screenshot_1334_4.jpg'),(2344,1334,'games/screenshots/mouse_p_i_for_hire-screenshot_1334_5.jpg'),(2345,1335,'games/screenshots/no_i_m_not_a_human-screenshot_1335_1.jpg'),(2346,1335,'games/screenshots/no_i_m_not_a_human-screenshot_1335_2.jpg'),(2347,1335,'games/screenshots/no_i_m_not_a_human-screenshot_1335_3.jpg'),(2348,1335,'games/screenshots/no_i_m_not_a_human-screenshot_1335_4.jpg'),(2349,1335,'games/screenshots/no_i_m_not_a_human-screenshot_1335_5.jpg'),(2350,1336,'games/screenshots/need_for_speed_payback-screenshot_1336_1.jpg'),(2351,1336,'games/screenshots/need_for_speed_payback-screenshot_1336_2.jpg'),(2352,1336,'games/screenshots/need_for_speed_payback-screenshot_1336_3.jpg'),(2353,1336,'games/screenshots/need_for_speed_payback-screenshot_1336_4.jpg'),(2354,1336,'games/screenshots/need_for_speed_payback-screenshot_1336_5.jpg'),(2355,1337,'games/screenshots/lethal_company-screenshot_1337_1.jpg'),(2356,1337,'games/screenshots/lethal_company-screenshot_1337_2.jpg'),(2357,1337,'games/screenshots/lethal_company-screenshot_1337_3.jpg'),(2358,1337,'games/screenshots/lethal_company-screenshot_1337_4.jpg'),(2359,1337,'games/screenshots/lethal_company-screenshot_1337_5.jpg'),(2360,1338,'games/screenshots/r_e_p_o-screenshot_1338_1.jpg'),(2361,1338,'games/screenshots/r_e_p_o-screenshot_1338_2.jpg'),(2362,1338,'games/screenshots/r_e_p_o-screenshot_1338_3.jpg'),(2363,1338,'games/screenshots/r_e_p_o-screenshot_1338_4.jpg'),(2364,1338,'games/screenshots/r_e_p_o-screenshot_1338_5.jpg'),(2370,1340,'games/screenshots/until_dawn-screenshot_1340_1.jpg'),(2371,1340,'games/screenshots/until_dawn-screenshot_1340_2.jpg'),(2372,1340,'games/screenshots/until_dawn-screenshot_1340_3.jpg'),(2373,1340,'games/screenshots/until_dawn-screenshot_1340_4.jpg'),(2374,1340,'games/screenshots/until_dawn-screenshot_1340_5.jpg'),(2375,1341,'games/screenshots/unravel_two-screenshot_1341_1.jpg'),(2376,1341,'games/screenshots/unravel_two-screenshot_1341_2.jpg'),(2377,1341,'games/screenshots/unravel_two-screenshot_1341_3.jpg'),(2378,1341,'games/screenshots/unravel_two-screenshot_1341_4.jpg'),(2379,1342,'games/screenshots/milk_outside_a_bag_of_milk_outside_a_bag_of_milk-screenshot_1342_1.jpg'),(2380,1342,'games/screenshots/milk_outside_a_bag_of_milk_outside_a_bag_of_milk-screenshot_1342_2.jpg'),(2381,1342,'games/screenshots/milk_outside_a_bag_of_milk_outside_a_bag_of_milk-screenshot_1342_3.jpg'),(2382,1342,'games/screenshots/milk_outside_a_bag_of_milk_outside_a_bag_of_milk-screenshot_1342_4.jpg'),(2383,1342,'games/screenshots/milk_outside_a_bag_of_milk_outside_a_bag_of_milk-screenshot_1342_5.jpg'),(2384,1343,'games/screenshots/abzu-screenshot_1343_1.jpg'),(2385,1343,'games/screenshots/abzu-screenshot_1343_2.jpg'),(2386,1343,'games/screenshots/abzu-screenshot_1343_3.jpg'),(2387,1343,'games/screenshots/abzu-screenshot_1343_4.jpg'),(2388,1343,'games/screenshots/abzu-screenshot_1343_5.jpg'),(2389,1344,'games/screenshots/beyond_blue-screenshot_1344_1.jpg'),(2390,1344,'games/screenshots/beyond_blue-screenshot_1344_2.jpg'),(2391,1344,'games/screenshots/beyond_blue-screenshot_1344_3.jpg'),(2392,1344,'games/screenshots/beyond_blue-screenshot_1344_4.jpg'),(2393,1344,'games/screenshots/beyond_blue-screenshot_1344_5.jpg'),(2394,1345,'games/screenshots/a_way_out-screenshot_1345_1.jpg'),(2395,1345,'games/screenshots/a_way_out-screenshot_1345_2.jpg'),(2396,1345,'games/screenshots/a_way_out-screenshot_1345_3.jpg'),(2397,1345,'games/screenshots/a_way_out-screenshot_1345_4.jpg'),(2398,1345,'games/screenshots/a_way_out-screenshot_1345_5.jpg'),(2399,1346,'games/screenshots/abiotic_factor-screenshot_1346_1.jpg'),(2400,1346,'games/screenshots/abiotic_factor-screenshot_1346_2.jpg'),(2401,1346,'games/screenshots/abiotic_factor-screenshot_1346_3.jpg'),(2402,1346,'games/screenshots/abiotic_factor-screenshot_1346_4.jpg'),(2403,1346,'games/screenshots/abiotic_factor-screenshot_1346_5.jpg'),(2404,1347,'games/screenshots/armed_forces_corp-screenshot_1347_1.jpg'),(2405,1347,'games/screenshots/armed_forces_corp-screenshot_1347_2.jpg'),(2406,1347,'games/screenshots/armed_forces_corp-screenshot_1347_3.jpg'),(2407,1347,'games/screenshots/armed_forces_corp-screenshot_1347_4.jpg'),(2408,1347,'games/screenshots/armed_forces_corp-screenshot_1347_5.jpg'),(2409,1348,'games/screenshots/bread_fred-screenshot_1348_1.jpg'),(2410,1348,'games/screenshots/bread_fred-screenshot_1348_2.jpg'),(2411,1348,'games/screenshots/bread_fred-screenshot_1348_3.jpg'),(2412,1348,'games/screenshots/bread_fred-screenshot_1348_4.jpg'),(2413,1348,'games/screenshots/bread_fred-screenshot_1348_5.jpg'),(2414,1349,'games/screenshots/buckshot_roulette-screenshot_1349_1.jpg'),(2415,1349,'games/screenshots/buckshot_roulette-screenshot_1349_2.jpg'),(2416,1349,'games/screenshots/buckshot_roulette-screenshot_1349_3.jpg'),(2417,1349,'games/screenshots/buckshot_roulette-screenshot_1349_4.jpg'),(2418,1349,'games/screenshots/buckshot_roulette-screenshot_1349_5.jpg'),(2419,1350,'games/screenshots/dystopika-screenshot_1350_1.jpg'),(2420,1350,'games/screenshots/dystopika-screenshot_1350_2.jpg'),(2421,1350,'games/screenshots/dystopika-screenshot_1350_3.jpg'),(2422,1350,'games/screenshots/dystopika-screenshot_1350_4.jpg'),(2423,1350,'games/screenshots/dystopika-screenshot_1350_5.jpg'),(2424,1351,'games/screenshots/arena_breakout_infinite-screenshot_1351_1.jpg'),(2425,1351,'games/screenshots/arena_breakout_infinite-screenshot_1351_2.jpg'),(2426,1351,'games/screenshots/arena_breakout_infinite-screenshot_1351_3.jpg'),(2427,1351,'games/screenshots/arena_breakout_infinite-screenshot_1351_4.jpg'),(2428,1351,'games/screenshots/arena_breakout_infinite-screenshot_1351_5.jpg'),(2429,1352,'games/screenshots/escape_from_tarkov-screenshot_1352_1.jpg'),(2430,1352,'games/screenshots/escape_from_tarkov-screenshot_1352_2.jpg'),(2431,1352,'games/screenshots/escape_from_tarkov-screenshot_1352_3.jpg'),(2432,1352,'games/screenshots/escape_from_tarkov-screenshot_1352_4.jpg'),(2433,1352,'games/screenshots/escape_from_tarkov-screenshot_1352_5.jpg'),(2434,1354,'games/screenshots/hotline_miami-screenshot_1354_1.jpg'),(2435,1354,'games/screenshots/hotline_miami-screenshot_1354_2.jpg'),(2436,1354,'games/screenshots/hotline_miami-screenshot_1354_3.jpg'),(2437,1354,'games/screenshots/hotline_miami-screenshot_1354_4.jpg'),(2438,1354,'games/screenshots/hotline_miami-screenshot_1354_5.jpg'),(2439,1355,'games/screenshots/hotline_miami_2_wrong_number-screenshot_1355_1.jpg'),(2440,1355,'games/screenshots/hotline_miami_2_wrong_number-screenshot_1355_2.jpg'),(2441,1355,'games/screenshots/hotline_miami_2_wrong_number-screenshot_1355_3.jpg'),(2442,1355,'games/screenshots/hotline_miami_2_wrong_number-screenshot_1355_4.jpg'),(2443,1355,'games/screenshots/hotline_miami_2_wrong_number-screenshot_1355_5.jpg'),(2444,1356,'games/screenshots/hour_of_victory-screenshot_1356_1.jpg'),(2445,1357,'games/screenshots/left_4_dead-screenshot_1357_1.jpg'),(2446,1357,'games/screenshots/left_4_dead-screenshot_1357_2.jpg'),(2447,1357,'games/screenshots/left_4_dead-screenshot_1357_3.jpg'),(2448,1357,'games/screenshots/left_4_dead-screenshot_1357_4.jpg'),(2449,1357,'games/screenshots/left_4_dead-screenshot_1357_5.jpg'),(2450,1358,'games/screenshots/left_4_dead_2-screenshot_1358_1.jpg'),(2451,1358,'games/screenshots/left_4_dead_2-screenshot_1358_2.jpg'),(2452,1358,'games/screenshots/left_4_dead_2-screenshot_1358_3.jpg'),(2453,1358,'games/screenshots/left_4_dead_2-screenshot_1358_4.jpg'),(2454,1358,'games/screenshots/left_4_dead_2-screenshot_1358_5.jpg'),(2455,1359,'games/screenshots/sifu-screenshot_1359_1.jpg'),(2456,1359,'games/screenshots/sifu-screenshot_1359_2.jpg'),(2457,1359,'games/screenshots/sifu-screenshot_1359_3.jpg'),(2458,1359,'games/screenshots/sifu-screenshot_1359_4.jpg'),(2459,1359,'games/screenshots/sifu-screenshot_1359_5.jpg'),(2460,1360,'games/screenshots/swat_4-screenshot_1360_1.jpg'),(2461,1360,'games/screenshots/swat_4-screenshot_1360_2.jpg'),(2462,1360,'games/screenshots/swat_4-screenshot_1360_3.jpg'),(2463,1360,'games/screenshots/swat_4-screenshot_1360_4.jpg'),(2464,1360,'games/screenshots/swat_4-screenshot_1360_5.jpg'),(2465,1361,'games/screenshots/alan_wake-screenshot_1361_1.jpg'),(2466,1361,'games/screenshots/alan_wake-screenshot_1361_2.jpg'),(2467,1361,'games/screenshots/alan_wake-screenshot_1361_3.jpg'),(2468,1361,'games/screenshots/alan_wake-screenshot_1361_4.jpg'),(2469,1361,'games/screenshots/alan_wake-screenshot_1361_5.jpg'),(2470,1362,'games/screenshots/alan_wake_s_american_nightmare-screenshot_1362_1.jpg'),(2471,1362,'games/screenshots/alan_wake_s_american_nightmare-screenshot_1362_2.jpg'),(2472,1362,'games/screenshots/alan_wake_s_american_nightmare-screenshot_1362_3.jpg'),(2473,1362,'games/screenshots/alan_wake_s_american_nightmare-screenshot_1362_4.jpg'),(2474,1362,'games/screenshots/alan_wake_s_american_nightmare-screenshot_1362_5.jpg'),(2475,1363,'games/screenshots/astroneer-screenshot_1363_1.jpg'),(2476,1363,'games/screenshots/astroneer-screenshot_1363_2.jpg'),(2477,1363,'games/screenshots/astroneer-screenshot_1363_3.jpg'),(2478,1363,'games/screenshots/astroneer-screenshot_1363_4.jpg'),(2479,1363,'games/screenshots/astroneer-screenshot_1363_5.jpg'),(2480,1365,'games/screenshots/back_4_blood-screenshot_1365_1.jpg'),(2481,1365,'games/screenshots/back_4_blood-screenshot_1365_2.jpg'),(2482,1365,'games/screenshots/back_4_blood-screenshot_1365_3.jpg'),(2483,1365,'games/screenshots/back_4_blood-screenshot_1365_4.jpg'),(2484,1365,'games/screenshots/back_4_blood-screenshot_1365_5.jpg'),(2485,1366,'games/screenshots/cuphead-screenshot_1366_1.jpg'),(2486,1366,'games/screenshots/cuphead-screenshot_1366_2.jpg'),(2487,1366,'games/screenshots/cuphead-screenshot_1366_3.jpg'),(2488,1366,'games/screenshots/cuphead-screenshot_1366_4.jpg'),(2489,1366,'games/screenshots/cuphead-screenshot_1366_5.jpg'),(2490,1367,'games/screenshots/content_warning-screenshot_1367_1.jpg'),(2491,1367,'games/screenshots/content_warning-screenshot_1367_2.jpg'),(2492,1367,'games/screenshots/content_warning-screenshot_1367_3.jpg'),(2493,1367,'games/screenshots/content_warning-screenshot_1367_4.jpg'),(2494,1367,'games/screenshots/content_warning-screenshot_1367_5.jpg'),(2495,1368,'games/screenshots/visage-screenshot_1368_1.jpg'),(2496,1368,'games/screenshots/visage-screenshot_1368_2.jpg'),(2497,1368,'games/screenshots/visage-screenshot_1368_3.jpg'),(2498,1368,'games/screenshots/visage-screenshot_1368_4.jpg'),(2499,1368,'games/screenshots/visage-screenshot_1368_5.jpg'),(2500,1369,'games/screenshots/valheim-screenshot_1369_1.jpg'),(2501,1369,'games/screenshots/valheim-screenshot_1369_2.jpg'),(2502,1369,'games/screenshots/valheim-screenshot_1369_3.jpg'),(2503,1369,'games/screenshots/valheim-screenshot_1369_4.jpg'),(2504,1369,'games/screenshots/valheim-screenshot_1369_5.jpg'),(2505,1370,'games/screenshots/volcanoids-screenshot_1370_1.jpg'),(2506,1370,'games/screenshots/volcanoids-screenshot_1370_2.jpg'),(2507,1370,'games/screenshots/volcanoids-screenshot_1370_3.jpg'),(2508,1370,'games/screenshots/volcanoids-screenshot_1370_4.jpg'),(2509,1370,'games/screenshots/volcanoids-screenshot_1370_5.jpg'),(2510,1371,'games/screenshots/super_bunny_man-screenshot_1371_1.jpg'),(2511,1371,'games/screenshots/super_bunny_man-screenshot_1371_2.jpg'),(2512,1371,'games/screenshots/super_bunny_man-screenshot_1371_3.jpg'),(2513,1371,'games/screenshots/super_bunny_man-screenshot_1371_4.jpg'),(2514,1371,'games/screenshots/super_bunny_man-screenshot_1371_5.jpg'),(2515,1372,'games/screenshots/sleeping_dogs-screenshot_1372_1.jpg'),(2516,1372,'games/screenshots/sleeping_dogs-screenshot_1372_2.jpg'),(2517,1372,'games/screenshots/sleeping_dogs-screenshot_1372_3.jpg'),(2518,1372,'games/screenshots/sleeping_dogs-screenshot_1372_4.jpg'),(2519,1372,'games/screenshots/sleeping_dogs-screenshot_1372_5.jpg'),(2520,1373,'games/screenshots/still_wakes_the_deep-screenshot_1373_1.jpg'),(2521,1373,'games/screenshots/still_wakes_the_deep-screenshot_1373_2.jpg'),(2522,1373,'games/screenshots/still_wakes_the_deep-screenshot_1373_3.jpg'),(2523,1373,'games/screenshots/still_wakes_the_deep-screenshot_1373_4.jpg'),(2524,1373,'games/screenshots/still_wakes_the_deep-screenshot_1373_5.jpg'),(2525,1374,'games/screenshots/far_cry-screenshot_1374_1.jpg'),(2526,1374,'games/screenshots/far_cry-screenshot_1374_2.jpg'),(2527,1374,'games/screenshots/far_cry-screenshot_1374_3.jpg'),(2528,1374,'games/screenshots/far_cry-screenshot_1374_4.jpg'),(2529,1374,'games/screenshots/far_cry-screenshot_1374_5.jpg'),(2530,1375,'games/screenshots/far_cry_2-screenshot_1375_1.jpg'),(2531,1375,'games/screenshots/far_cry_2-screenshot_1375_2.jpg'),(2532,1375,'games/screenshots/far_cry_2-screenshot_1375_3.jpg'),(2533,1375,'games/screenshots/far_cry_2-screenshot_1375_4.jpg'),(2534,1375,'games/screenshots/far_cry_2-screenshot_1375_5.jpg'),(2535,1376,'games/screenshots/firewatch-screenshot_1376_1.jpg'),(2536,1376,'games/screenshots/firewatch-screenshot_1376_2.jpg'),(2537,1376,'games/screenshots/firewatch-screenshot_1376_3.jpg'),(2538,1376,'games/screenshots/firewatch-screenshot_1376_4.jpg'),(2539,1376,'games/screenshots/firewatch-screenshot_1376_5.jpg'),(2540,1377,'games/screenshots/the_forest-screenshot_1377_1.jpg'),(2541,1377,'games/screenshots/the_forest-screenshot_1377_2.jpg'),(2542,1377,'games/screenshots/the_forest-screenshot_1377_3.jpg'),(2543,1377,'games/screenshots/the_forest-screenshot_1377_4.jpg'),(2544,1378,'games/screenshots/sons_of_the_forest-screenshot_1378_1.jpg'),(2545,1378,'games/screenshots/sons_of_the_forest-screenshot_1378_2.jpg'),(2546,1378,'games/screenshots/sons_of_the_forest-screenshot_1378_3.jpg'),(2547,1378,'games/screenshots/sons_of_the_forest-screenshot_1378_4.jpg'),(2548,1378,'games/screenshots/sons_of_the_forest-screenshot_1378_5.jpg'),(2554,1380,'games/screenshots/the_crew-screenshot_1380_1.jpg'),(2555,1380,'games/screenshots/the_crew-screenshot_1380_2.jpg'),(2556,1380,'games/screenshots/the_crew-screenshot_1380_3.jpg'),(2557,1380,'games/screenshots/the_crew-screenshot_1380_4.jpg'),(2558,1380,'games/screenshots/the_crew-screenshot_1380_5.jpg'),(2559,1381,'games/screenshots/the_crew_2-screenshot_1381_1.jpg'),(2560,1381,'games/screenshots/the_crew_2-screenshot_1381_2.jpg'),(2561,1381,'games/screenshots/the_crew_2-screenshot_1381_3.jpg'),(2562,1381,'games/screenshots/the_crew_2-screenshot_1381_4.jpg'),(2563,1381,'games/screenshots/the_crew_2-screenshot_1381_5.jpg'),(2564,1382,'games/screenshots/sunkenland-screenshot_1382_1.jpg'),(2565,1382,'games/screenshots/sunkenland-screenshot_1382_2.jpg'),(2566,1382,'games/screenshots/sunkenland-screenshot_1382_3.jpg'),(2567,1382,'games/screenshots/sunkenland-screenshot_1382_4.jpg'),(2568,1382,'games/screenshots/sunkenland-screenshot_1382_5.jpg'),(2569,1383,'games/screenshots/subnautica-screenshot_1383_1.jpg'),(2570,1383,'games/screenshots/subnautica-screenshot_1383_2.jpg'),(2571,1383,'games/screenshots/subnautica-screenshot_1383_3.jpg'),(2572,1383,'games/screenshots/subnautica-screenshot_1383_4.jpg'),(2573,1383,'games/screenshots/subnautica-screenshot_1383_5.jpg'),(2574,1384,'games/screenshots/subnautica_below_zero-screenshot_1384_1.jpg'),(2575,1384,'games/screenshots/subnautica_below_zero-screenshot_1384_2.jpg'),(2576,1384,'games/screenshots/subnautica_below_zero-screenshot_1384_3.jpg'),(2577,1384,'games/screenshots/subnautica_below_zero-screenshot_1384_4.jpg'),(2578,1384,'games/screenshots/subnautica_below_zero-screenshot_1384_5.jpg'),(2579,1385,'games/screenshots/s_t_a_l_k_e_r_shadow_of_chernobyl-screenshot_1385_1.jpg'),(2580,1385,'games/screenshots/s_t_a_l_k_e_r_shadow_of_chernobyl-screenshot_1385_2.jpg'),(2581,1385,'games/screenshots/s_t_a_l_k_e_r_shadow_of_chernobyl-screenshot_1385_3.jpg'),(2582,1385,'games/screenshots/s_t_a_l_k_e_r_shadow_of_chernobyl-screenshot_1385_4.jpg'),(2583,1385,'games/screenshots/s_t_a_l_k_e_r_shadow_of_chernobyl-screenshot_1385_5.jpg'),(2584,1386,'games/screenshots/s_t_a_l_k_e_r_clear_sky-screenshot_1386_1.jpg'),(2585,1386,'games/screenshots/s_t_a_l_k_e_r_clear_sky-screenshot_1386_2.jpg'),(2586,1386,'games/screenshots/s_t_a_l_k_e_r_clear_sky-screenshot_1386_3.jpg'),(2587,1386,'games/screenshots/s_t_a_l_k_e_r_clear_sky-screenshot_1386_4.jpg'),(2588,1386,'games/screenshots/s_t_a_l_k_e_r_clear_sky-screenshot_1386_5.jpg'),(2599,1392,'games/screenshots/metro_2033_redux-screenshot_1392_1.jpg'),(2600,1392,'games/screenshots/metro_2033_redux-screenshot_1392_2.jpg'),(2601,1392,'games/screenshots/metro_2033_redux-screenshot_1392_3.jpg'),(2602,1392,'games/screenshots/metro_2033_redux-screenshot_1392_4.jpg'),(2603,1392,'games/screenshots/metro_2033_redux-screenshot_1392_5.jpg'),(2604,1393,'games/screenshots/metro_last_light_redux-screenshot_1393_1.jpg'),(2605,1393,'games/screenshots/metro_last_light_redux-screenshot_1393_2.jpg'),(2606,1393,'games/screenshots/metro_last_light_redux-screenshot_1393_3.jpg'),(2607,1393,'games/screenshots/metro_last_light_redux-screenshot_1393_4.jpg'),(2608,1393,'games/screenshots/metro_last_light_redux-screenshot_1393_5.jpg'),(2609,1394,'games/screenshots/metro_exodus-screenshot_1394_1.jpg'),(2610,1394,'games/screenshots/metro_exodus-screenshot_1394_2.jpg'),(2611,1394,'games/screenshots/metro_exodus-screenshot_1394_3.jpg'),(2612,1394,'games/screenshots/metro_exodus-screenshot_1394_4.jpg'),(2613,1394,'games/screenshots/metro_exodus-screenshot_1394_5.jpg'),(2614,1395,'games/screenshots/mirror_s_edge-screenshot_1395_1.jpg'),(2615,1395,'games/screenshots/mirror_s_edge-screenshot_1395_2.jpg'),(2616,1395,'games/screenshots/mirror_s_edge-screenshot_1395_3.jpg'),(2617,1395,'games/screenshots/mirror_s_edge-screenshot_1395_4.jpg'),(2618,1395,'games/screenshots/mirror_s_edge-screenshot_1395_5.jpg'),(2619,1396,'games/screenshots/mafia-screenshot_1396_1.jpg'),(2620,1396,'games/screenshots/mafia-screenshot_1396_2.jpg'),(2621,1396,'games/screenshots/mafia-screenshot_1396_3.jpg'),(2622,1396,'games/screenshots/mafia-screenshot_1396_4.jpg'),(2623,1397,'games/screenshots/mafia_ii-screenshot_1397_1.jpg'),(2624,1397,'games/screenshots/mafia_ii-screenshot_1397_2.jpg'),(2625,1397,'games/screenshots/mafia_ii-screenshot_1397_3.jpg'),(2626,1397,'games/screenshots/mafia_ii-screenshot_1397_4.jpg'),(2627,1397,'games/screenshots/mafia_ii-screenshot_1397_5.jpg'),(2628,1398,'games/screenshots/mafia_definitive_edition-screenshot_1398_1.jpg'),(2629,1398,'games/screenshots/mafia_definitive_edition-screenshot_1398_2.jpg'),(2630,1398,'games/screenshots/mafia_definitive_edition-screenshot_1398_3.jpg'),(2631,1398,'games/screenshots/mafia_definitive_edition-screenshot_1398_4.jpg'),(2632,1398,'games/screenshots/mafia_definitive_edition-screenshot_1398_5.jpg'),(2633,1401,'games/screenshots/no_one_lives_under_the_lighthouse-screenshot_1401_1.jpg'),(2634,1401,'games/screenshots/no_one_lives_under_the_lighthouse-screenshot_1401_2.jpg'),(2635,1401,'games/screenshots/no_one_lives_under_the_lighthouse-screenshot_1401_3.jpg'),(2636,1401,'games/screenshots/no_one_lives_under_the_lighthouse-screenshot_1401_4.jpg'),(2637,1401,'games/screenshots/no_one_lives_under_the_lighthouse-screenshot_1401_5.jpg'),(2638,1402,'games/screenshots/outlast-screenshot_1402_1.jpg'),(2639,1402,'games/screenshots/outlast-screenshot_1402_2.jpg'),(2640,1402,'games/screenshots/outlast-screenshot_1402_3.jpg'),(2641,1402,'games/screenshots/outlast-screenshot_1402_4.jpg'),(2642,1402,'games/screenshots/outlast-screenshot_1402_5.jpg'),(2643,1403,'games/screenshots/outlast_ii-screenshot_1403_1.jpg'),(2644,1403,'games/screenshots/outlast_ii-screenshot_1403_2.jpg'),(2645,1403,'games/screenshots/outlast_ii-screenshot_1403_3.jpg'),(2646,1403,'games/screenshots/outlast_ii-screenshot_1403_4.jpg'),(2647,1403,'games/screenshots/outlast_ii-screenshot_1403_5.jpg'),(2648,1404,'games/screenshots/once_upon_a_mind_a_little_too_friendly-screenshot_1404_1.jpg'),(2649,1404,'games/screenshots/once_upon_a_mind_a_little_too_friendly-screenshot_1404_2.jpg'),(2650,1404,'games/screenshots/once_upon_a_mind_a_little_too_friendly-screenshot_1404_3.jpg'),(2651,1404,'games/screenshots/once_upon_a_mind_a_little_too_friendly-screenshot_1404_4.jpg'),(2652,1405,'games/screenshots/pacify-screenshot_1405_1.jpg'),(2653,1405,'games/screenshots/pacify-screenshot_1405_2.jpg'),(2654,1405,'games/screenshots/pacify-screenshot_1405_3.jpg'),(2655,1405,'games/screenshots/pacify-screenshot_1405_4.jpg'),(2656,1405,'games/screenshots/pacify-screenshot_1405_5.jpg'),(2657,1406,'games/screenshots/misery-screenshot_1406_1.jpg'),(2658,1406,'games/screenshots/misery-screenshot_1406_2.jpg'),(2659,1406,'games/screenshots/misery-screenshot_1406_3.jpg'),(2660,1406,'games/screenshots/misery-screenshot_1406_4.jpg'),(2661,1406,'games/screenshots/misery-screenshot_1406_5.jpg'),(2662,1407,'games/screenshots/stalzone-screenshot_1407_1.jpg'),(2663,1407,'games/screenshots/stalzone-screenshot_1407_2.jpg'),(2664,1407,'games/screenshots/stalzone-screenshot_1407_3.jpg'),(2665,1407,'games/screenshots/stalzone-screenshot_1407_4.jpg'),(2666,1407,'games/screenshots/stalzone-screenshot_1407_5.jpg'),(2667,1408,'games/screenshots/amnesia_the_dark_descent-screenshot_1408_1.jpg'),(2668,1408,'games/screenshots/amnesia_the_dark_descent-screenshot_1408_2.jpg'),(2669,1408,'games/screenshots/amnesia_the_dark_descent-screenshot_1408_3.jpg'),(2670,1408,'games/screenshots/amnesia_the_dark_descent-screenshot_1408_4.jpg'),(2671,1408,'games/screenshots/amnesia_the_dark_descent-screenshot_1408_5.jpg'),(2673,1410,'games/screenshots/fall_guys-screenshot_1410_1.jpg'),(2674,1410,'games/screenshots/fall_guys-screenshot_1410_2.jpg'),(2675,1410,'games/screenshots/fall_guys-screenshot_1410_3.jpg'),(2676,1410,'games/screenshots/fall_guys-screenshot_1410_4.jpg'),(2677,1410,'games/screenshots/fall_guys-screenshot_1410_5.jpg'),(2678,1411,'games/screenshots/fallout_shelter-screenshot_1411_1.jpg'),(2679,1411,'games/screenshots/fallout_shelter-screenshot_1411_2.jpg'),(2680,1411,'games/screenshots/fallout_shelter-screenshot_1411_3.jpg'),(2681,1411,'games/screenshots/fallout_shelter-screenshot_1411_4.jpg'),(2682,1411,'games/screenshots/fallout_shelter-screenshot_1411_5.jpg'),(2683,1412,'games/screenshots/folklore_hunter-screenshot_1412_1.jpg'),(2684,1412,'games/screenshots/folklore_hunter-screenshot_1412_2.jpg'),(2685,1412,'games/screenshots/folklore_hunter-screenshot_1412_3.jpg'),(2686,1412,'games/screenshots/folklore_hunter-screenshot_1412_4.jpg'),(2687,1412,'games/screenshots/folklore_hunter-screenshot_1412_5.jpg'),(2688,1413,'games/screenshots/mad_max-screenshot_1413_1.jpg'),(2689,1413,'games/screenshots/mad_max-screenshot_1413_2.jpg'),(2690,1413,'games/screenshots/mad_max-screenshot_1413_3.jpg'),(2691,1413,'games/screenshots/mad_max-screenshot_1413_4.jpg'),(2692,1413,'games/screenshots/mad_max-screenshot_1413_5.jpg'),(2693,1414,'games/screenshots/borderlands-screenshot_1414_1.jpg'),(2694,1414,'games/screenshots/borderlands-screenshot_1414_2.jpg'),(2695,1414,'games/screenshots/borderlands-screenshot_1414_3.jpg'),(2696,1414,'games/screenshots/borderlands-screenshot_1414_4.jpg'),(2697,1414,'games/screenshots/borderlands-screenshot_1414_5.jpg'),(2698,1415,'games/screenshots/borderlands_2-screenshot_1415_1.jpg'),(2699,1415,'games/screenshots/borderlands_2-screenshot_1415_2.jpg'),(2700,1415,'games/screenshots/borderlands_2-screenshot_1415_3.jpg'),(2701,1415,'games/screenshots/borderlands_2-screenshot_1415_4.jpg'),(2702,1415,'games/screenshots/borderlands_2-screenshot_1415_5.jpg'),(2703,1416,'games/screenshots/borderlands_the_pre_sequel-screenshot_1416_1.jpg'),(2704,1416,'games/screenshots/borderlands_the_pre_sequel-screenshot_1416_2.jpg'),(2705,1416,'games/screenshots/borderlands_the_pre_sequel-screenshot_1416_3.jpg'),(2706,1416,'games/screenshots/borderlands_the_pre_sequel-screenshot_1416_4.jpg'),(2707,1416,'games/screenshots/borderlands_the_pre_sequel-screenshot_1416_5.jpg'),(2708,1417,'games/screenshots/cry_of_fear-screenshot_1417_1.jpg'),(2709,1417,'games/screenshots/cry_of_fear-screenshot_1417_2.jpg'),(2710,1417,'games/screenshots/cry_of_fear-screenshot_1417_3.jpg'),(2711,1417,'games/screenshots/cry_of_fear-screenshot_1417_4.jpg'),(2712,1417,'games/screenshots/cry_of_fear-screenshot_1417_5.jpg'),(2713,1418,'games/screenshots/crime_simulator-screenshot_1418_1.jpg'),(2714,1418,'games/screenshots/crime_simulator-screenshot_1418_2.jpg'),(2715,1418,'games/screenshots/crime_simulator-screenshot_1418_3.jpg'),(2716,1418,'games/screenshots/crime_simulator-screenshot_1418_4.jpg'),(2717,1418,'games/screenshots/crime_simulator-screenshot_1418_5.jpg'),(2721,1421,'games/screenshots/drive_beyond_horizons-screenshot_1421_1.jpg'),(2722,1421,'games/screenshots/drive_beyond_horizons-screenshot_1421_2.jpg'),(2723,1421,'games/screenshots/drive_beyond_horizons-screenshot_1421_3.jpg'),(2724,1421,'games/screenshots/drive_beyond_horizons-screenshot_1421_4.jpg'),(2725,1421,'games/screenshots/drive_beyond_horizons-screenshot_1421_5.jpg'),(2726,1422,'games/screenshots/don_t_starve_together-screenshot_1422_1.jpg'),(2727,1422,'games/screenshots/don_t_starve_together-screenshot_1422_2.jpg'),(2728,1422,'games/screenshots/don_t_starve_together-screenshot_1422_3.jpg'),(2729,1422,'games/screenshots/don_t_starve_together-screenshot_1422_4.jpg'),(2730,1422,'games/screenshots/don_t_starve_together-screenshot_1422_5.jpg'),(2731,1423,'games/screenshots/dying_light-screenshot_1423_1.jpg'),(2732,1423,'games/screenshots/dying_light-screenshot_1423_2.jpg'),(2733,1423,'games/screenshots/dying_light-screenshot_1423_3.jpg'),(2734,1423,'games/screenshots/dying_light-screenshot_1423_4.jpg'),(2735,1423,'games/screenshots/dying_light-screenshot_1423_5.jpg'),(2736,1424,'games/screenshots/dying_light_2_stay_human-screenshot_1424_1.jpg'),(2737,1424,'games/screenshots/dying_light_2_stay_human-screenshot_1424_2.jpg'),(2738,1424,'games/screenshots/dying_light_2_stay_human-screenshot_1424_3.jpg'),(2739,1424,'games/screenshots/dying_light_2_stay_human-screenshot_1424_4.jpg'),(2740,1424,'games/screenshots/dying_light_2_stay_human-screenshot_1424_5.jpg'),(2741,1425,'games/screenshots/dying_light_the_beast-screenshot_1425_1.jpg'),(2742,1425,'games/screenshots/dying_light_the_beast-screenshot_1425_2.jpg'),(2743,1425,'games/screenshots/dying_light_the_beast-screenshot_1425_3.jpg'),(2744,1425,'games/screenshots/dying_light_the_beast-screenshot_1425_4.jpg'),(2745,1425,'games/screenshots/dying_light_the_beast-screenshot_1425_5.jpg'),(2746,1426,'games/screenshots/deep_rock_galactic-screenshot_1426_1.jpg'),(2747,1426,'games/screenshots/deep_rock_galactic-screenshot_1426_2.jpg'),(2748,1426,'games/screenshots/deep_rock_galactic-screenshot_1426_3.jpg'),(2749,1426,'games/screenshots/deep_rock_galactic-screenshot_1426_4.jpg'),(2750,1426,'games/screenshots/deep_rock_galactic-screenshot_1426_5.jpg'),(2751,1427,'games/screenshots/marvel_s_spider_man-screenshot_1427_1.jpg'),(2752,1427,'games/screenshots/marvel_s_spider_man-screenshot_1427_2.jpg'),(2753,1427,'games/screenshots/marvel_s_spider_man-screenshot_1427_3.jpg'),(2754,1427,'games/screenshots/marvel_s_spider_man-screenshot_1427_4.jpg'),(2755,1427,'games/screenshots/marvel_s_spider_man-screenshot_1427_5.jpg'),(2756,1428,'games/screenshots/marvel_s_spider_man_miles_morales-screenshot_1428_1.jpg'),(2757,1428,'games/screenshots/marvel_s_spider_man_miles_morales-screenshot_1428_2.jpg'),(2758,1428,'games/screenshots/marvel_s_spider_man_miles_morales-screenshot_1428_3.jpg'),(2759,1429,'games/screenshots/battlefield_1942-screenshot_1429_1.jpg'),(2760,1429,'games/screenshots/battlefield_1942-screenshot_1429_2.jpg'),(2761,1429,'games/screenshots/battlefield_1942-screenshot_1429_3.jpg'),(2762,1429,'games/screenshots/battlefield_1942-screenshot_1429_4.jpg'),(2763,1429,'games/screenshots/battlefield_1942-screenshot_1429_5.jpg'),(2764,1430,'games/screenshots/battlefield_vietnam-screenshot_1430_1.jpg'),(2765,1430,'games/screenshots/battlefield_vietnam-screenshot_1430_2.jpg'),(2766,1430,'games/screenshots/battlefield_vietnam-screenshot_1430_3.jpg'),(2767,1430,'games/screenshots/battlefield_vietnam-screenshot_1430_4.jpg'),(2768,1430,'games/screenshots/battlefield_vietnam-screenshot_1430_5.jpg'),(2769,1431,'games/screenshots/battlefield_2-screenshot_1431_1.jpg'),(2770,1431,'games/screenshots/battlefield_2-screenshot_1431_2.jpg'),(2771,1431,'games/screenshots/battlefield_2-screenshot_1431_3.jpg'),(2772,1431,'games/screenshots/battlefield_2-screenshot_1431_4.jpg'),(2773,1431,'games/screenshots/battlefield_2-screenshot_1431_5.jpg'),(2774,1432,'games/screenshots/battlefield_2142-screenshot_1432_1.jpg'),(2775,1432,'games/screenshots/battlefield_2142-screenshot_1432_2.jpg'),(2776,1432,'games/screenshots/battlefield_2142-screenshot_1432_3.jpg'),(2777,1432,'games/screenshots/battlefield_2142-screenshot_1432_4.jpg'),(2778,1432,'games/screenshots/battlefield_2142-screenshot_1432_5.jpg'),(2779,1433,'games/screenshots/battlefield_bad_company-screenshot_1433_1.jpg'),(2780,1433,'games/screenshots/battlefield_bad_company-screenshot_1433_2.jpg'),(2781,1433,'games/screenshots/battlefield_bad_company-screenshot_1433_3.jpg'),(2782,1433,'games/screenshots/battlefield_bad_company-screenshot_1433_4.jpg'),(2783,1433,'games/screenshots/battlefield_bad_company-screenshot_1433_5.jpg'),(2784,1435,'games/screenshots/saints_row_the_third-screenshot_1435_1.jpg'),(2785,1435,'games/screenshots/saints_row_the_third-screenshot_1435_2.jpg'),(2786,1435,'games/screenshots/saints_row_the_third-screenshot_1435_3.jpg'),(2787,1435,'games/screenshots/saints_row_the_third-screenshot_1435_4.jpg'),(2788,1435,'games/screenshots/saints_row_the_third-screenshot_1435_5.jpg'),(2789,1436,'games/screenshots/saints_row_iv-screenshot_1436_1.jpg'),(2790,1436,'games/screenshots/saints_row_iv-screenshot_1436_2.jpg'),(2791,1436,'games/screenshots/saints_row_iv-screenshot_1436_3.jpg'),(2792,1436,'games/screenshots/saints_row_iv-screenshot_1436_4.jpg'),(2793,1436,'games/screenshots/saints_row_iv-screenshot_1436_5.jpg'),(2794,1437,'games/screenshots/rust-screenshot_1437_1.jpg'),(2795,1437,'games/screenshots/rust-screenshot_1437_2.jpg'),(2796,1437,'games/screenshots/rust-screenshot_1437_3.jpg'),(2797,1437,'games/screenshots/rust-screenshot_1437_4.jpg'),(2798,1437,'games/screenshots/rust-screenshot_1437_5.jpg'),(2799,1438,'games/screenshots/ghost_exile-screenshot_1438_1.jpg'),(2800,1438,'games/screenshots/ghost_exile-screenshot_1438_2.jpg'),(2801,1438,'games/screenshots/ghost_exile-screenshot_1438_3.jpg'),(2802,1438,'games/screenshots/ghost_exile-screenshot_1438_4.jpg'),(2803,1438,'games/screenshots/ghost_exile-screenshot_1438_5.jpg'),(2804,1439,'games/screenshots/golf_with_your_friends-screenshot_1439_1.jpg'),(2805,1439,'games/screenshots/golf_with_your_friends-screenshot_1439_2.jpg'),(2806,1439,'games/screenshots/golf_with_your_friends-screenshot_1439_3.jpg'),(2807,1439,'games/screenshots/golf_with_your_friends-screenshot_1439_4.jpg'),(2808,1439,'games/screenshots/golf_with_your_friends-screenshot_1439_5.jpg'),(2809,1440,'games/screenshots/green_hell-screenshot_1440_1.jpg'),(2810,1440,'games/screenshots/green_hell-screenshot_1440_2.jpg'),(2811,1440,'games/screenshots/green_hell-screenshot_1440_3.jpg'),(2812,1440,'games/screenshots/green_hell-screenshot_1440_4.jpg'),(2813,1440,'games/screenshots/green_hell-screenshot_1440_5.jpg'),(2814,1441,'games/screenshots/grounded-screenshot_1441_1.jpg'),(2815,1441,'games/screenshots/grounded-screenshot_1441_2.jpg'),(2816,1441,'games/screenshots/grounded-screenshot_1441_3.jpg'),(2817,1441,'games/screenshots/grounded-screenshot_1441_4.jpg'),(2818,1441,'games/screenshots/grounded-screenshot_1441_5.jpg'),(2819,1442,'games/screenshots/garry_s_mod-screenshot_1442_1.jpg'),(2820,1442,'games/screenshots/garry_s_mod-screenshot_1442_2.jpg'),(2821,1442,'games/screenshots/garry_s_mod-screenshot_1442_3.jpg'),(2822,1442,'games/screenshots/garry_s_mod-screenshot_1442_4.jpg'),(2823,1442,'games/screenshots/garry_s_mod-screenshot_1442_5.jpg'),(2828,1444,'games/screenshots/gas_station_simulator-screenshot_1444_1.jpg'),(2829,1444,'games/screenshots/gas_station_simulator-screenshot_1444_2.jpg'),(2830,1444,'games/screenshots/gas_station_simulator-screenshot_1444_3.jpg'),(2831,1444,'games/screenshots/gas_station_simulator-screenshot_1444_4.jpg'),(2832,1444,'games/screenshots/gas_station_simulator-screenshot_1444_5.jpg'),(2833,1445,'games/screenshots/killing_floor-screenshot_1445_1.jpg'),(2834,1445,'games/screenshots/killing_floor-screenshot_1445_2.jpg'),(2835,1445,'games/screenshots/killing_floor-screenshot_1445_3.jpg'),(2836,1445,'games/screenshots/killing_floor-screenshot_1445_4.jpg'),(2837,1446,'games/screenshots/killing_floor_2-screenshot_1446_1.jpg'),(2838,1446,'games/screenshots/killing_floor_2-screenshot_1446_2.jpg'),(2839,1446,'games/screenshots/killing_floor_2-screenshot_1446_3.jpg'),(2840,1446,'games/screenshots/killing_floor_2-screenshot_1446_4.jpg'),(2841,1446,'games/screenshots/killing_floor_2-screenshot_1446_5.jpg'),(2842,1447,'games/screenshots/minecraft-screenshot_1447_1.jpg'),(2843,1447,'games/screenshots/minecraft-screenshot_1447_2.jpg'),(2844,1447,'games/screenshots/minecraft-screenshot_1447_3.jpg'),(2845,1447,'games/screenshots/minecraft-screenshot_1447_4.jpg'),(2846,1447,'games/screenshots/minecraft-screenshot_1447_5.jpg'),(2847,1449,'games/screenshots/mortal_kombat_11-screenshot_1449_1.jpg'),(2848,1449,'games/screenshots/mortal_kombat_11-screenshot_1449_2.jpg'),(2849,1449,'games/screenshots/mortal_kombat_11-screenshot_1449_3.jpg'),(2850,1449,'games/screenshots/mortal_kombat_11-screenshot_1449_4.jpg'),(2851,1449,'games/screenshots/mortal_kombat_11-screenshot_1449_5.jpg'),(2852,1450,'games/screenshots/crysis-screenshot_1450_1.jpg'),(2853,1450,'games/screenshots/crysis-screenshot_1450_2.jpg'),(2854,1450,'games/screenshots/crysis-screenshot_1450_3.jpg'),(2855,1450,'games/screenshots/crysis-screenshot_1450_4.jpg'),(2856,1450,'games/screenshots/crysis-screenshot_1450_5.jpg'),(2857,1451,'games/screenshots/crysis_warhead-screenshot_1451_1.jpg'),(2858,1451,'games/screenshots/crysis_warhead-screenshot_1451_2.jpg'),(2859,1451,'games/screenshots/crysis_warhead-screenshot_1451_3.jpg'),(2860,1451,'games/screenshots/crysis_warhead-screenshot_1451_4.jpg'),(2861,1451,'games/screenshots/crysis_warhead-screenshot_1451_5.jpg'),(2862,1452,'games/screenshots/crysis_2-screenshot_1452_1.jpg'),(2863,1452,'games/screenshots/crysis_2-screenshot_1452_2.jpg'),(2864,1452,'games/screenshots/crysis_2-screenshot_1452_3.jpg'),(2865,1452,'games/screenshots/crysis_2-screenshot_1452_4.jpg'),(2866,1452,'games/screenshots/crysis_2-screenshot_1452_5.jpg');
/*!40000 ALTER TABLE `screenshots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statuses` (
  `idStatus` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`idStatus`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` VALUES (7,'active'),(3,'approved'),(6,'closed'),(9,'deleted'),(8,'hidden'),(5,'open'),(2,'pending'),(1,'published'),(4,'rejected'),(15,'tbc'),(13,'Альфа'),(11,'Анонсирована'),(14,'Бета'),(12,'В разработке'),(10,'Вышла');
/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `themes`
--

DROP TABLE IF EXISTS `themes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `themes` (
  `idTheme` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idTheme`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `themes`
--

LOCK TABLES `themes` WRITE;
/*!40000 ALTER TABLE `themes` DISABLE KEYS */;
INSERT INTO `themes` VALUES (41,'4X стратегия'),(28,'Бизнес'),(39,'Война'),(21,'Выживание'),(43,'Детектив/Тайна'),(40,'Для вечеринки'),(42,'Для взрослых (18+)'),(35,'Для детей (6+)'),(32,'Документальный'),(31,'Драма'),(22,'Историческая'),(27,'Комедия'),(18,'Научная фантастика'),(34,'Обучающая'),(38,'Открытый мир'),(33,'Песочница'),(44,'Романтика'),(23,'Стелс'),(20,'Триллер'),(17,'Фэнтези'),(19,'Хоррор'),(1,'Экшн');
/*!40000 ALTER TABLE `themes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_collections`
--

DROP TABLE IF EXISTS `user_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_collections` (
  `idCollection` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `game_id` int NOT NULL,
  `collection_type` varchar(45) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idCollection`),
  UNIQUE KEY `unique_user_game_type` (`user_id`,`game_id`,`collection_type`),
  KEY `game_id` (`game_id`),
  KEY `idx_user_game` (`user_id`,`game_id`),
  CONSTRAINT `user_collections_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`),
  CONSTRAINT `user_collections_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_collections`
--

LOCK TABLES `user_collections` WRITE;
/*!40000 ALTER TABLE `user_collections` DISABLE KEYS */;
INSERT INTO `user_collections` VALUES (84,34,1321,'Играл','2026-09-22 17:55:21'),(85,34,1322,'Пройденные','2026-09-22 18:04:10'),(86,34,1323,'Играл','2026-09-23 12:09:48'),(87,34,1324,'Пройденные','2026-09-23 12:09:51'),(88,34,1325,'Пройденные','2026-09-23 12:09:53'),(89,34,1326,'Пройденные','2026-09-23 12:12:12'),(90,34,1327,'Пройденные','2026-09-23 12:12:14'),(91,34,1328,'Пройденные','2026-09-23 12:12:16'),(92,34,1329,'Пройденные','2026-09-23 12:15:15'),(93,34,1330,'Пройденные','2026-09-23 12:17:15'),(94,34,1331,'Пройденные','2026-09-23 12:17:30'),(95,34,1332,'Пройденные','2026-09-23 12:18:12'),(96,34,1333,'Пройденные','2026-09-23 12:19:55'),(97,34,1334,'Пройденные','2026-09-23 12:20:25'),(98,34,1335,'Пройденные','2026-09-23 12:35:39'),(99,34,1336,'Пройденные','2026-09-23 12:41:37'),(100,34,1337,'Играл','2026-09-23 12:43:14'),(101,34,1338,'Играл','2026-09-23 12:44:22'),(102,34,1340,'Пройденные','2026-09-23 12:48:42'),(103,34,1341,'Пройденные','2026-09-23 12:48:55'),(104,34,1342,'Пройденные','2026-09-23 12:50:04'),(105,34,1343,'Пройденные','2026-09-23 12:51:56'),(106,34,1344,'Пройденные','2026-09-23 12:54:09'),(107,34,1345,'Пройденные','2026-09-23 12:55:55'),(108,34,1346,'Заброшено','2026-09-23 12:56:44'),(109,34,1347,'Пройденные','2026-09-23 12:58:35'),(110,34,1348,'Заброшено','2026-09-23 12:59:16'),(111,34,1349,'Пройденные','2026-09-23 12:59:57'),(112,34,1350,'Играл','2026-09-23 13:03:40'),(113,34,1351,'Играл','2026-09-23 13:06:40'),(114,34,1352,'Играл','2026-09-23 13:10:16'),(115,34,1353,'Играл','2026-09-23 13:14:20'),(116,34,1354,'Пройденные','2026-09-23 13:16:42'),(117,34,1355,'Пройденные','2026-09-23 13:16:45'),(118,34,1356,'Пройденные','2026-09-23 13:21:28'),(119,34,1357,'Пройденные','2026-09-23 13:22:21'),(120,34,1358,'Пройденные','2026-09-23 13:22:36'),(121,34,1359,'Заброшено','2026-09-23 13:41:37'),(122,34,1360,'Пройденные','2026-09-23 13:42:15'),(123,34,1361,'Пройденные','2026-09-23 13:43:35'),(124,34,1362,'Пройденные','2026-09-23 13:43:37'),(125,34,1363,'Пройденные','2026-09-23 13:47:54'),(126,34,1364,'Пройденные','2026-09-23 13:51:05'),(127,34,1365,'Пройденные','2026-09-23 13:51:53'),(128,34,1366,'Пройденные','2026-09-23 13:53:07'),(129,34,1367,'Играл','2026-09-23 13:55:08'),(130,34,1368,'Пройденные','2026-09-23 14:01:25'),(131,34,1369,'Пройденные','2026-09-23 14:01:44'),(132,34,1370,'Играл','2026-09-23 14:03:17'),(133,34,1371,'Играл','2026-09-23 14:04:21'),(134,34,1372,'Пройденные','2026-09-23 14:08:18'),(135,34,1373,'Пройденные','2026-09-23 14:12:21'),(136,34,1374,'Пройденные','2026-09-23 14:22:15'),(137,34,1375,'Пройденные','2026-09-23 14:26:00'),(138,34,1376,'Пройденные','2026-09-23 14:45:02'),(139,34,1377,'Пройденные','2026-09-23 14:47:29'),(140,34,1378,'Пройденные','2026-09-23 14:49:59'),(141,34,1380,'Играл','2026-09-23 14:55:27'),(142,34,1381,'Играл','2026-09-23 14:58:27'),(143,34,1382,'Играл','2026-09-23 14:59:33'),(144,34,1383,'Пройденные','2026-09-23 15:00:05'),(145,34,1384,'Хочу сыграть','2026-09-23 15:05:36'),(146,34,1386,'Пройденные','2026-09-23 15:22:29'),(148,34,1391,'Пройденные','2026-09-23 16:21:27'),(149,34,1392,'Пройденные','2026-09-23 16:23:42'),(150,34,1393,'Пройденные','2026-09-23 16:41:28'),(151,34,1394,'Пройденные','2026-09-23 16:48:38'),(152,34,1395,'Пройденные','2026-09-23 17:37:57'),(153,34,1396,'Пройденные','2026-09-23 17:43:04'),(154,34,1397,'Пройденные','2026-09-23 17:48:11'),(155,34,1398,'Пройденные','2026-09-23 17:57:53'),(156,34,1400,'Пройденные','2026-09-23 17:59:41'),(157,34,1401,'Пройденные','2026-09-23 18:02:05'),(158,34,1402,'Пройденные','2026-09-23 18:03:18'),(159,34,1403,'Пройденные','2026-09-23 18:06:06'),(160,34,1404,'Пройденные','2026-09-23 18:09:10'),(161,34,1405,'Пройденные','2026-09-23 18:10:12'),(162,34,1406,'Пройденные','2026-09-23 18:12:39'),(163,34,1385,'Пройденные','2026-09-24 09:32:28'),(164,34,1407,'Играл','2026-09-24 11:25:06'),(165,34,1408,'Пройденные','2026-09-24 11:59:26'),(166,34,1410,'Играл','2026-09-24 12:01:41'),(167,34,1411,'Играл','2026-09-24 12:02:04'),(168,34,1412,'Играл','2026-09-24 12:03:15'),(169,34,1413,'Пройденные','2026-09-24 12:03:56'),(170,34,1414,'Пройденные','2026-09-24 12:08:38'),(171,34,1415,'Пройденные','2026-09-24 12:13:55'),(172,34,1416,'Пройденные','2026-09-24 12:15:46'),(173,34,1417,'Пройденные','2026-09-24 12:16:17'),(174,34,1418,'Играл','2026-09-24 12:22:01'),(175,34,1419,'Играл','2026-09-24 12:22:47'),(176,34,1421,'Пройденные','2026-09-24 12:24:29'),(177,34,1422,'Заброшено','2026-09-24 12:25:22'),(178,34,1423,'Пройденные','2026-09-24 12:25:44'),(179,34,1424,'Пройденные','2026-09-24 12:47:07'),(180,34,1425,'Пройденные','2026-09-24 13:01:17'),(181,34,1426,'Играл','2026-09-24 13:10:41'),(182,34,1427,'Пройденные','2026-09-24 13:13:14'),(183,34,1428,'Пройденные','2026-09-24 13:20:01'),(184,34,1434,'Пройденные','2026-09-24 13:25:01'),(185,34,1433,'Пройденные','2026-09-24 13:25:19'),(186,34,1432,'Играл','2026-09-24 13:25:23'),(187,34,1431,'Играл','2026-09-24 13:25:25'),(188,34,1430,'Играл','2026-09-24 13:25:27'),(189,34,1429,'Играл','2026-09-24 13:25:29'),(190,34,1435,'Пройденные','2026-09-24 13:28:30'),(191,34,1436,'Пройденные','2026-09-24 13:30:13'),(192,34,1437,'Играл','2026-09-24 13:33:32'),(193,34,1438,'Играл','2026-09-24 13:35:39'),(194,34,1439,'Пройденные','2026-09-24 13:35:51'),(195,34,1440,'Пройденные','2026-09-24 13:36:08'),(196,34,1441,'Пройденные','2026-09-24 13:36:50'),(197,34,1442,'Играл','2026-09-24 13:37:55'),(198,34,1444,'Пройденные','2026-09-24 13:39:05'),(199,34,1445,'Играл','2026-09-24 13:39:43'),(200,34,1446,'Играл','2026-09-24 13:39:45'),(201,34,1447,'Пройденные','2026-09-24 13:41:45'),(202,34,1448,'Пройденные','2026-09-24 13:42:32'),(203,34,1449,'Пройденные','2026-09-24 13:42:34'),(204,34,1450,'Пройденные','2026-09-24 13:47:01'),(205,34,1451,'Пройденные','2026-09-24 13:47:46'),(206,34,1452,'Пройденные','2026-09-24 13:47:48'),(207,34,1453,'Пройденные','2026-09-24 13:47:49');
/*!40000 ALTER TABLE `user_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_restrictions`
--

DROP TABLE IF EXISTS `user_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_restrictions` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор записи',
  `user_id` int NOT NULL COMMENT 'Идентификатор пользователя',
  `restriction_type` enum('review','comment','question','profile') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Тип ограничения',
  `banned_until` datetime DEFAULT NULL COMMENT 'Дата разблокировки',
  `moderation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Причина блокировки',
  `moderated_by` int NOT NULL COMMENT 'Идентификатор модератора',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата блокировки',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `moderated_by` (`moderated_by`),
  CONSTRAINT `user_restrictions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE,
  CONSTRAINT `user_restrictions_ibfk_2` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_restrictions`
--

LOCK TABLES `user_restrictions` WRITE;
/*!40000 ALTER TABLE `user_restrictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_restrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `idUser` int NOT NULL AUTO_INCREMENT,
  `nickname` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `banner` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `role_id` int NOT NULL DEFAULT '1',
  `rating` int DEFAULT '0',
  PRIMARY KEY (`idUser`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nickname`),
  KEY `fk_users_role` (`role_id`),
  KEY `idx_users_nickname` (`nickname`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`idRole`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (34,'Cl0WN','dym_mastertv@mail.ru','$2b$10$j5sbQmdyWrhewBEICh30AeISkGZGv5PJGo9uW8AxOh2p.wNwBMQde','2026-05-19 19:12:13','avatars/1790169625769_gs5znk.png','banners/1790169647715_8wo2z4.png',4,0),(36,'renbl231','renbl231@mail.ru','$2b$10$9fTWC0AMUK.T0Qu6DD0c/O5eA7ge0U3B9HdIF.A1Hm2sA86yvA5AW','2026-07-07 13:34:00','avatars/1789415086232_qybo8e.png',NULL,2,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-24 13:59:07
