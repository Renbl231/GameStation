-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Сен 23 2026 г., 13:40
-- Версия сервера: 8.0.30
-- Версия PHP: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `GameStation`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `update_game_rating_stats` (IN `gameId` INT)   BEGIN
    UPDATE games g
    JOIN (
        SELECT 
            AVG(overall_score) AS avg_overall,
            AVG(gameplay) AS avg_gameplay,
            AVG(graphics) AS avg_graphics,
            AVG(story) AS avg_story,
            AVG(atmosphere) AS avg_atmosphere,
            AVG(stability) AS avg_stability,
            COUNT(*) AS rating_count
        FROM game_ratings
        WHERE game_id = gameId
    ) r ON g.idGame = gameId
    SET 
        g.rating_overall = COALESCE(r.avg_overall, 0.0),
        g.rating_counter = COALESCE(r.rating_count, 0),
        g.gameplay_avg = COALESCE(r.avg_gameplay, 0.0),
        g.graphics_avg = COALESCE(r.avg_graphics, 0.0),
        g.story_avg = COALESCE(r.avg_story, 0.0),
        g.atmosphere_avg = COALESCE(r.avg_atmosphere, 0.0),
        g.optimization_avg = COALESCE(r.avg_stability, 0.0);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `app_settings`
--

CREATE TABLE `app_settings` (
  `id` int NOT NULL COMMENT 'Идентификатор записи',
  `setting_key` varchar(45) NOT NULL,
  `setting_value` enum('main','best','popular','expected') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `app_settings`
--

INSERT INTO `app_settings` (`id`, `setting_key`, `setting_value`, `description`) VALUES
(2, 'slider_news', 'popular', 'Мод для слайдера новостей'),
(3, 'slider_games', 'best', 'Мод для слайдера игр');

-- --------------------------------------------------------

--
-- Структура таблицы `articles`
--

CREATE TABLE `articles` (
  `idArticle` int NOT NULL,
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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `article_categories`
--

CREATE TABLE `article_categories` (
  `idCategory` int NOT NULL,
  `name` varchar(90) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `article_categories`
--

INSERT INTO `article_categories` (`idCategory`, `name`) VALUES
(1, 'Обзор'),
(2, 'Подборка');

-- --------------------------------------------------------

--
-- Структура таблицы `brands`
--

CREATE TABLE `brands` (
  `idBrand` int NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `brands`
--

INSERT INTO `brands` (`idBrand`, `name`) VALUES
(5, 'Apple'),
(6, 'Atari'),
(7, 'Commodore'),
(2, 'Microsoft'),
(3, 'Nintendo'),
(4, 'Sega'),
(1, 'Sony');

-- --------------------------------------------------------

--
-- Структура таблицы `comments`
--

CREATE TABLE `comments` (
  `idComment` int NOT NULL COMMENT 'Индентификатор комментария',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Контент комментария',
  `entity_type` enum('news','article','review','question') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Тип сущности к которой комментарий',
  `entity_id` int NOT NULL COMMENT 'Идентификатор самой сущности',
  `user_id` int NOT NULL COMMENT 'Идентификато пользователя',
  `parent_comment_id` int DEFAULT NULL COMMENT 'Идентификатор родительского комментария',
  `moderated_by` int DEFAULT NULL COMMENT 'Идентификатор модератора',
  `moderation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Причина модерации',
  `status_id` int NOT NULL DEFAULT '7' COMMENT 'Статус модерации',
  `flags_count` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания комментария'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Триггеры `comments`
--
DELIMITER $$
CREATE TRIGGER `after_comment_delete` AFTER DELETE ON `comments` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_comment_insert` AFTER INSERT ON `comments` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_comment_update` AFTER UPDATE ON `comments` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `companies`
--

CREATE TABLE `companies` (
  `idCompany` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `companies`
--

INSERT INTO `companies` (`idCompany`, `name`, `logo`, `created_at`) VALUES
(69, 'Reissad Studio', 'companies/logos/reissad_studio-logo.png', '2026-09-22 17:53:43'),
(70, 'id Software', 'companies/logos/id_software-logo.png', '2026-09-22 18:04:02'),
(71, 'Panic Button Games', 'companies/logos/panic_button_games-logo.png', '2026-09-22 18:04:02');

-- --------------------------------------------------------

--
-- Структура таблицы `favorites`
--

CREATE TABLE `favorites` (
  `idFavorite` int NOT NULL,
  `user_id` int NOT NULL,
  `game_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `friends`
--

CREATE TABLE `friends` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `friend_id` int NOT NULL,
  `status_id` int NOT NULL DEFAULT '2',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `friends`
--

INSERT INTO `friends` (`id`, `user_id`, `friend_id`, `status_id`, `created_at`) VALUES
(82, 34, 36, 3, '2026-09-11 14:47:23');

-- --------------------------------------------------------

--
-- Структура таблицы `games`
--

CREATE TABLE `games` (
  `idGame` int NOT NULL,
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
  `optimization_avg` decimal(3,1) NOT NULL DEFAULT '0.0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `games`
--

INSERT INTO `games` (`idGame`, `igdb_id`, `steam_id`, `name`, `summary`, `rating_overall`, `rating_counter`, `developer_id`, `publisher_id`, `status_id`, `release_date`, `trailer`, `cover`, `banner`, `sort_order`, `story_avg`, `graphics_avg`, `gameplay_avg`, `atmosphere_avg`, `optimization_avg`) VALUES
(1321, 248994, 2406770, 'Bodycam', 'Bodycam — это первый тактический многопользовательский шутер от первого лица с настоящим обзором с нательной камеры на движке Unreal Engine 5. Ближние бои кажутся резкими и громкими. Каждый ракурс, выноска и пуля имеют значение. Играйте в Deathmatch, Team Deathmatch и Wingman на фотореалистичных.', '6.8', 1, 69, NULL, 12, '2024-06-07', NULL, 'games/covers/bodycam-game_cover_1321.jpg', 'games/banners/bodycam-banner_1321.jpg', NULL, '0.0', '7.0', '6.0', '7.5', '0.0'),
(1322, 36952, 612880, 'Wolfenstein II: The New Colossus', 'Америка, 1961 г. Генерал Череп убит, но миром правят нацисты. Вы Би Джей Бласковиц, боец сопротивления и последняя надежда человечества. Только вы можете раздуть пламя второй Американской революции.', '9.2', 1, 70, 71, 10, '2017-10-26', 'https://cdn.akamai.steamstatic.com/steam/apps/256696071/movie_max.mp4', 'games/covers/wolfenstein_ii_the_new_colossus-game_cover_1322.jpg', 'games/banners/wolfenstein_ii_the_new_colossus-banner_1322.jpg', NULL, '10.0', '8.0', '8.0', '10.0', '10.0');

-- --------------------------------------------------------

--
-- Структура таблицы `game_genres`
--

CREATE TABLE `game_genres` (
  `id` int NOT NULL,
  `game_id` int NOT NULL,
  `genre_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `game_genres`
--

INSERT INTO `game_genres` (`id`, `game_id`, `genre_id`) VALUES
(243, 1321, 13),
(244, 1321, 15),
(245, 1321, 32),
(246, 1322, 5),
(247, 1322, 31);

-- --------------------------------------------------------

--
-- Структура таблицы `game_modes`
--

CREATE TABLE `game_modes` (
  `id` int NOT NULL,
  `game_id` int NOT NULL,
  `mode_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `game_modes`
--

INSERT INTO `game_modes` (`id`, `game_id`, `mode_id`) VALUES
(225, 1321, 2),
(226, 1322, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `game_perspectives`
--

CREATE TABLE `game_perspectives` (
  `id` int NOT NULL,
  `game_id` int NOT NULL,
  `perspective_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `game_perspectives`
--

INSERT INTO `game_perspectives` (`id`, `game_id`, `perspective_id`) VALUES
(133, 1321, 1),
(134, 1322, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `game_platforms`
--

CREATE TABLE `game_platforms` (
  `game_id` int NOT NULL,
  `platform_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `game_platforms`
--

INSERT INTO `game_platforms` (`game_id`, `platform_id`) VALUES
(1321, 6),
(1322, 6),
(1322, 48),
(1322, 49),
(1322, 130);

-- --------------------------------------------------------

--
-- Структура таблицы `game_ratings`
--

CREATE TABLE `game_ratings` (
  `idGameRating` int NOT NULL,
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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `game_ratings`
--

INSERT INTO `game_ratings` (`idGameRating`, `game_id`, `user_id`, `overall_score`, `gameplay`, `graphics`, `story`, `music`, `atmosphere`, `stability`, `replayability`, `isDetail`, `created_at`) VALUES
(105, 1321, 34, '6.8', '6.0', '7.0', NULL, NULL, '7.5', NULL, NULL, 1, '2026-09-22 17:55:17'),
(106, 1322, 34, '9.2', '8.0', '8.0', '10.0', '10.0', '10.0', '10.0', '7.0', 1, '2026-09-22 18:04:36');

--
-- Триггеры `game_ratings`
--
DELIMITER $$
CREATE TRIGGER `update_game_ratings_after_delete` AFTER DELETE ON `game_ratings` FOR EACH ROW BEGIN
    CALL update_game_rating_stats(OLD.game_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_game_ratings_after_insert` AFTER INSERT ON `game_ratings` FOR EACH ROW BEGIN
    CALL update_game_rating_stats(NEW.game_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_game_ratings_after_update` AFTER UPDATE ON `game_ratings` FOR EACH ROW BEGIN
    CALL update_game_rating_stats(NEW.game_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `game_ratings_params`
--

CREATE TABLE `game_ratings_params` (
  `idParam` int NOT NULL,
  `name` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `game_id` int NOT NULL,
  `author_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `game_requests`
--

CREATE TABLE `game_requests` (
  `idRequest` int NOT NULL,
  `nameGame` varchar(255) NOT NULL,
  `store_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status_id` int NOT NULL DEFAULT '2',
  `user_id` int NOT NULL COMMENT 'Кто запросил',
  `moderator_id` int DEFAULT NULL COMMENT 'Кто обрабатывал',
  `notes` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `game_themes`
--

CREATE TABLE `game_themes` (
  `id` int NOT NULL,
  `game_id` int NOT NULL,
  `theme_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `game_themes`
--

INSERT INTO `game_themes` (`id`, `game_id`, `theme_id`) VALUES
(318, 1321, 1),
(319, 1322, 1),
(320, 1322, 17),
(321, 1322, 18),
(322, 1322, 22);

-- --------------------------------------------------------

--
-- Структура таблицы `genres`
--

CREATE TABLE `genres` (
  `idGenre` int NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `genres`
--

INSERT INTO `genres` (`idGenre`, `name`) VALUES
(36, 'MOBA'),
(33, 'Аркада'),
(11, 'В реальном времени'),
(34, 'Визуальная новелла'),
(26, 'Викторина'),
(9, 'Головоломка'),
(10, 'Гонки'),
(32, 'Инди'),
(35, 'Карточная'),
(2, 'Квест'),
(7, 'Музыка'),
(30, 'Пинбол'),
(8, 'Платформер'),
(16, 'Пошаговая'),
(31, 'Приключение'),
(12, 'Ролевая'),
(13, 'Симулятор'),
(25, 'Слэшер'),
(14, 'Спортивная'),
(15, 'Стратегия'),
(24, 'Тактика'),
(4, 'Файтинг'),
(5, 'Шутер');

-- --------------------------------------------------------

--
-- Структура таблицы `likes`
--

CREATE TABLE `likes` (
  `user_id` int NOT NULL,
  `entity_id` int NOT NULL,
  `entity_type` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `likes`
--

INSERT INTO `likes` (`user_id`, `entity_id`, `entity_type`) VALUES
(34, 138, 'news'),
(34, 140, 'news'),
(34, 144, 'news'),
(34, 146, 'news'),
(34, 149, 'news'),
(34, 151, 'news'),
(34, 153, 'news'),
(34, 154, 'news'),
(34, 155, 'news'),
(34, 158, 'news'),
(34, 159, 'news'),
(34, 160, 'news');

--
-- Триггеры `likes`
--
DELIMITER $$
CREATE TRIGGER `update_news_likes_count` AFTER INSERT ON `likes` FOR EACH ROW BEGIN
	IF NEW.entity_type = 'news' THEN
    	UPDATE News
        SET likes_count = (
        	SELECT COUNT(*) FROM Likes
            WHERE entity_type = 'news' AND entity_id = NEW.entity_id
        )
        WHERE idNew = NEW.entity_id;
    END IF;
  END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_news_likes_count_delete` AFTER DELETE ON `likes` FOR EACH ROW BEGIN
	IF OLD.entity_type = 'news' THEN
    	UPDATE News
        SET likes_count = (
        	SELECT COUNT(*) FROM Likes
            WHERE entity_type = 'news' AND entity_id = OLD.entity_id
        )
        WHERE idNew = OLD.entity_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `modes`
--

CREATE TABLE `modes` (
  `idMode` int NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `modes`
--

INSERT INTO `modes` (`idMode`, `name`) VALUES
(5, 'MMO'),
(6, 'Баттл Рояль'),
(3, 'Кооперативная'),
(2, 'Мультиплеер'),
(1, 'Одиночная'),
(4, 'Разделённый экран');

-- --------------------------------------------------------

--
-- Структура таблицы `news`
--

CREATE TABLE `news` (
  `idNew` int NOT NULL,
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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `news_categories`
--

CREATE TABLE `news_categories` (
  `idCategory` int NOT NULL,
  `name` varchar(90) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `news_categories`
--

INSERT INTO `news_categories` (`idCategory`, `name`) VALUES
(5, 'VR'),
(2, 'Анонсы'),
(7, 'Индустрия'),
(4, 'Консоли'),
(6, 'Патчи'),
(1, 'ПК'),
(3, 'Релизы'),
(8, 'Слухи');

-- --------------------------------------------------------

--
-- Структура таблицы `perspectives`
--

CREATE TABLE `perspectives` (
  `idPerspective` int NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `perspectives`
--

INSERT INTO `perspectives` (`idPerspective`, `name`) VALUES
(1, 'От первого лица'),
(2, 'От третьего лица'),
(3, 'Сверху/Изометрия'),
(4, 'Вид сбоку'),
(5, 'Текст'),
(6, 'Аудио'),
(7, 'VR');

-- --------------------------------------------------------

--
-- Структура таблицы `platforms`
--

CREATE TABLE `platforms` (
  `idPlatform` int NOT NULL,
  `name` varchar(45) NOT NULL,
  `short` varchar(255) DEFAULT NULL,
  `brand_id` int DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `platforms`
--

INSERT INTO `platforms` (`idPlatform`, `name`, `short`, `brand_id`, `release_date`, `is_active`) VALUES
(3, 'Linux', 'Linux', NULL, '1991-01-01', 0),
(4, 'Commodore 64', 'C64', 3, '1982-08-01', 0),
(6, 'PC', 'PC', NULL, '1985-11-20', 0),
(7, 'Sony PlayStation', 'PS', 1, '1994-12-03', 0),
(8, 'Sony PlayStation 2', 'PS2', 1, '2000-03-04', 0),
(9, 'Sony PlayStation 3', 'PS3', 1, '2006-11-11', 0),
(11, 'Microsoft Xbox', 'Xbox', 2, '2001-11-15', 0),
(12, 'Microsoft Xbox 360', 'Xbox 360', 2, '2005-11-22', 0),
(14, 'Apple Mac', 'Mac', 5, '1984-01-24', 0),
(15, 'Commodore 128', 'C128', 7, '1985-01-01', 0),
(18, 'Nintendo Entertainment System', 'NES', 3, '1985-10-18', 0),
(19, 'Super Nintendo', 'SNES', 3, '1990-11-21', 0),
(20, 'Nintendo DS', 'DS', 3, '2004-11-21', 0),
(21, 'Nintendo GameCube', 'GC', 3, '2001-09-14', 0),
(29, 'Sega Mega Drive', 'MD', 4, '1988-10-29', 0),
(30, 'Sega 32X', '32X', 4, '1994-11-21', 0),
(32, 'Sega Saturn', 'Saturn', 4, '1994-11-22', 0),
(35, 'Sega Game Gear', 'GG', 4, '1990-10-06', 0),
(37, 'Nintendo 3DS', '3DS', 3, '2011-02-26', 0),
(38, 'Sony PlayStation Portable', 'PSP', 1, '2004-12-12', 0),
(39, 'Apple iOS', 'iOS', 5, '2007-06-29', 0),
(46, 'Sony PlayStation Vita', 'PS Vita', 1, '2011-12-17', 0),
(48, 'Sony PlayStation 4', 'PS4', 1, '2013-11-15', 0),
(49, 'Microsoft Xbox One', 'Xbox One', 2, '2013-11-22', 0),
(59, 'Atari 2600', 'A2600', 6, '1977-09-11', 0),
(60, 'Atari 7800', 'A7800', 6, '1986-05-01', 0),
(61, 'Atari Lynx', 'Lynx', 6, '1989-09-01', 0),
(62, 'Atari Jaguar', 'Jaguar', 6, '1993-11-23', 0),
(63, 'Atari ST', 'ST', 6, '1985-06-01', 0),
(64, 'Sega Master System', 'SMS', 4, '1986-10-20', 0),
(65, 'Atari 8-bit', 'A8bit', 6, '1982-01-01', 0),
(66, 'Atari 5200', 'A5200', 6, '1982-11-01', 0),
(71, 'Commodore VIC-20', 'VIC-20', 7, '1980-06-01', 0),
(75, 'Apple II', 'Apple II', 5, '1977-06-10', 0),
(78, 'Sega CD', 'SCD', 4, '1992-12-18', 0),
(90, 'Commodore PET', 'PET', 7, '1977-01-01', 0),
(93, 'Commodore 16', 'C16', 7, '1984-01-01', 0),
(94, 'Commodore Plus/4', 'Plus/4', 7, '1984-01-01', 0),
(130, 'Nintendo Switch', 'NSW', 3, '2017-03-03', 0),
(158, 'Commodore CDTV', 'CDTV', 7, '1991-01-01', 0),
(159, 'Nintendo DSi', 'DSi', 3, '2008-11-01', 0),
(165, 'Sony PlayStation VR', 'PS VR', 1, '2016-10-13', 0),
(167, 'Sony PlayStation 5', 'PS5', 1, '2020-11-12', 0),
(169, 'Microsoft Xbox Series X|S', 'Xbox Series X|S', 2, '2020-11-10', 0),
(339, 'Sega Pico', 'Pico', 4, NULL, 0),
(390, 'Sony PlayStation VR2', 'PS VR2', 1, '2023-02-22', 0),
(410, 'Atari Jaguar CD', 'Jag CD', 6, '1995-09-21', 0),
(482, 'Sega CD 32X', 'CD32X', 4, '1993-08-01', 0),
(508, 'Nintendo Switch 2', 'NSW2', 3, '2025-06-05', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `questions`
--

CREATE TABLE `questions` (
  `idQuestion` int NOT NULL COMMENT 'Идентификатор вопроса',
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
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Примечание'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `question_categories`
--

CREATE TABLE `question_categories` (
  `idSection` int NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `question_categories`
--

INSERT INTO `question_categories` (`idSection`, `name`) VALUES
(5, 'admin_question'),
(1, 'advertisement'),
(8, 'another'),
(6, 'find_game'),
(7, 'problems'),
(2, 'site_issues'),
(11, 'system_requirements'),
(3, 'vacancies');

-- --------------------------------------------------------

--
-- Структура таблицы `reports`
--

CREATE TABLE `reports` (
  `idReport` int NOT NULL,
  `reason` enum('spam') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `reporter_id` int NOT NULL,
  `entity_type` enum('comment','news') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `entity_id` int NOT NULL,
  `status_id` int NOT NULL,
  `moterated_by` int NOT NULL,
  `moderation_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `moderated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `reviews`
--

CREATE TABLE `reviews` (
  `idReview` int NOT NULL COMMENT 'Идентификатор рецензии',
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
  `moderation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Причина модерации'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `idRole` int NOT NULL,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`idRole`, `name`) VALUES
(4, 'admin'),
(3, 'moderator'),
(2, 'news_maker'),
(1, 'user');

-- --------------------------------------------------------

--
-- Структура таблицы `screenshots`
--

CREATE TABLE `screenshots` (
  `idScreenshot` int NOT NULL,
  `game_id` int NOT NULL,
  `image_key` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `screenshots`
--

INSERT INTO `screenshots` (`idScreenshot`, `game_id`, `image_key`) VALUES
(2284, 1321, 'games/screenshots/bodycam-screenshot_1321_1.jpg'),
(2285, 1321, 'games/screenshots/bodycam-screenshot_1321_2.jpg'),
(2286, 1321, 'games/screenshots/bodycam-screenshot_1321_3.jpg'),
(2287, 1321, 'games/screenshots/bodycam-screenshot_1321_4.jpg'),
(2288, 1321, 'games/screenshots/bodycam-screenshot_1321_5.jpg'),
(2289, 1322, 'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_1.jpg'),
(2290, 1322, 'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_2.jpg'),
(2291, 1322, 'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_3.jpg'),
(2292, 1322, 'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_4.jpg'),
(2293, 1322, 'games/screenshots/wolfenstein_ii_the_new_colossus-screenshot_1322_5.jpg');

-- --------------------------------------------------------

--
-- Структура таблицы `statuses`
--

CREATE TABLE `statuses` (
  `idStatus` int NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `statuses`
--

INSERT INTO `statuses` (`idStatus`, `name`) VALUES
(7, 'active'),
(3, 'approved'),
(6, 'closed'),
(9, 'deleted'),
(8, 'hidden'),
(5, 'open'),
(2, 'pending'),
(1, 'published'),
(4, 'rejected'),
(15, 'tbc'),
(13, 'Альфа'),
(11, 'Анонсирована'),
(14, 'Бета'),
(12, 'В разработке'),
(10, 'Вышла');

-- --------------------------------------------------------

--
-- Структура таблицы `themes`
--

CREATE TABLE `themes` (
  `idTheme` int NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `themes`
--

INSERT INTO `themes` (`idTheme`, `name`) VALUES
(41, '4X стратегия'),
(28, 'Бизнес'),
(39, 'Война'),
(21, 'Выживание'),
(43, 'Детектив/Тайна'),
(40, 'Для вечеринки'),
(42, 'Для взрослых (18+)'),
(35, 'Для детей (6+)'),
(32, 'Документальный'),
(31, 'Драма'),
(22, 'Историческая'),
(27, 'Комедия'),
(18, 'Научная фантастика'),
(34, 'Обучающая'),
(38, 'Открытый мир'),
(33, 'Песочница'),
(44, 'Романтика'),
(23, 'Стелс'),
(20, 'Триллер'),
(17, 'Фэнтези'),
(19, 'Хоррор'),
(1, 'Экшн');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `idUser` int NOT NULL,
  `nickname` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `banner` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `role_id` int NOT NULL DEFAULT '1',
  `rating` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`idUser`, `nickname`, `email`, `password`, `created_at`, `avatar`, `banner`, `role_id`, `rating`) VALUES
(34, 'Cl0WN', 'dym_mastertv@mail.ru', '$2b$10$j5sbQmdyWrhewBEICh30AeISkGZGv5PJGo9uW8AxOh2p.wNwBMQde', '2026-05-19 19:12:13', 'avatars/1790088740554_x2vs7a.png', 'banners/1790088745151_ubp46p.png', 4, 0),
(36, 'renbl231', 'renbl231@mail.ru', '$2b$10$9fTWC0AMUK.T0Qu6DD0c/O5eA7ge0U3B9HdIF.A1Hm2sA86yvA5AW', '2026-07-07 13:34:00', 'avatars/1789415086232_qybo8e.png', NULL, 2, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `user_collections`
--

CREATE TABLE `user_collections` (
  `idCollection` int NOT NULL,
  `user_id` int NOT NULL,
  `game_id` int NOT NULL,
  `collection_type` varchar(45) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `user_collections`
--

INSERT INTO `user_collections` (`idCollection`, `user_id`, `game_id`, `collection_type`, `created_at`) VALUES
(84, 34, 1321, 'Играл', '2026-09-22 17:55:21'),
(85, 34, 1322, 'Пройденные', '2026-09-22 18:04:10');

-- --------------------------------------------------------

--
-- Структура таблицы `user_restrictions`
--

CREATE TABLE `user_restrictions` (
  `id` int NOT NULL COMMENT 'Идентификатор записи',
  `user_id` int NOT NULL COMMENT 'Идентификатор пользователя',
  `restriction_type` enum('review','comment','question','profile') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Тип ограничения',
  `banned_until` datetime DEFAULT NULL COMMENT 'Дата разблокировки',
  `moderation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Причина блокировки',
  `moderated_by` int NOT NULL COMMENT 'Идентификатор модератора',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата блокировки'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `app_settings`
--
ALTER TABLE `app_settings`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`idArticle`),
  ADD KEY `fk_article_user` (`author_id`),
  ADD KEY `fk_article_game` (`game_id`),
  ADD KEY `fk_article_status` (`status_id`),
  ADD KEY `fk_article_category` (`category_id`) USING BTREE;

--
-- Индексы таблицы `article_categories`
--
ALTER TABLE `article_categories`
  ADD PRIMARY KEY (`idCategory`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`idBrand`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`idComment`),
  ADD KEY `fk_comments_user` (`user_id`),
  ADD KEY `idx_comment` (`entity_type`,`entity_id`),
  ADD KEY `fk_comments_moderated_by` (`moderated_by`),
  ADD KEY `fk_comment_status` (`status_id`);

--
-- Индексы таблицы `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`idCompany`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`idFavorite`),
  ADD UNIQUE KEY `user_id` (`user_id`,`game_id`),
  ADD KEY `game_id` (`game_id`),
  ADD KEY `idx_favorites_user_game` (`user_id`,`game_id`);

--
-- Индексы таблицы `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user` (`user_id`),
  ADD KEY `fk_friend` (`friend_id`),
  ADD KEY `fk_friend_status` (`status_id`),
  ADD KEY `idx_friends_user_friend_status` (`user_id`,`friend_id`,`status_id`);

--
-- Индексы таблицы `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`idGame`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `cover_id` (`cover`),
  ADD UNIQUE KEY `trailer_id` (`trailer`),
  ADD UNIQUE KEY `uniq_igdbid` (`igdb_id`),
  ADD UNIQUE KEY `uniq_steamid` (`steam_id`),
  ADD KEY `idx_game_name` (`name`);

--
-- Индексы таблицы `game_genres`
--
ALTER TABLE `game_genres`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_game` (`game_id`),
  ADD KEY `fk_genre` (`genre_id`);

--
-- Индексы таблицы `game_modes`
--
ALTER TABLE `game_modes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_gameMode` (`game_id`),
  ADD KEY `fk_mode` (`mode_id`);

--
-- Индексы таблицы `game_perspectives`
--
ALTER TABLE `game_perspectives`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_gamePerspective` (`game_id`),
  ADD KEY `fk_perspective` (`perspective_id`);

--
-- Индексы таблицы `game_platforms`
--
ALTER TABLE `game_platforms`
  ADD PRIMARY KEY (`game_id`,`platform_id`),
  ADD KEY `platform_id` (`platform_id`);

--
-- Индексы таблицы `game_ratings`
--
ALTER TABLE `game_ratings`
  ADD PRIMARY KEY (`idGameRating`),
  ADD UNIQUE KEY `unique_user_game_rating` (`user_id`,`game_id`),
  ADD KEY `fk_game_ratings_game` (`game_id`);

--
-- Индексы таблицы `game_ratings_params`
--
ALTER TABLE `game_ratings_params`
  ADD PRIMARY KEY (`idParam`),
  ADD KEY `fk_game_param` (`game_id`),
  ADD KEY `fk_author_param` (`author_id`);

--
-- Индексы таблицы `game_requests`
--
ALTER TABLE `game_requests`
  ADD PRIMARY KEY (`idRequest`),
  ADD KEY `fk_GameRequests_user_id` (`user_id`),
  ADD KEY `fk_request_status` (`status_id`);

--
-- Индексы таблицы `game_themes`
--
ALTER TABLE `game_themes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_gameTheme` (`game_id`),
  ADD KEY `fk_theme` (`theme_id`);

--
-- Индексы таблицы `genres`
--
ALTER TABLE `genres`
  ADD PRIMARY KEY (`idGenre`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`user_id`,`entity_id`);

--
-- Индексы таблицы `modes`
--
ALTER TABLE `modes`
  ADD PRIMARY KEY (`idMode`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`idNew`),
  ADD KEY `fk_news_status` (`status_id`),
  ADD KEY `fk_news_author` (`author_id`),
  ADD KEY `fk_news_game` (`game_id`),
  ADD KEY `fk_news_category` (`category_id`);

--
-- Индексы таблицы `news_categories`
--
ALTER TABLE `news_categories`
  ADD PRIMARY KEY (`idCategory`),
  ADD UNIQUE KEY `uq_name` (`name`);

--
-- Индексы таблицы `perspectives`
--
ALTER TABLE `perspectives`
  ADD PRIMARY KEY (`idPerspective`);

--
-- Индексы таблицы `platforms`
--
ALTER TABLE `platforms`
  ADD PRIMARY KEY (`idPlatform`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `short` (`short`),
  ADD KEY `fk_brand_id` (`brand_id`);

--
-- Индексы таблицы `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`idQuestion`),
  ADD KEY `fk_qsection` (`section_id`),
  ADD KEY `fk_userQstn` (`user_id`),
  ADD KEY `idx_questions_status_section_date` (`status`,`section_id`,`created_at` DESC),
  ADD KEY `idx_questions_user_id` (`user_id`),
  ADD KEY `fk_questions_moderated_by` (`moderated_by`);

--
-- Индексы таблицы `question_categories`
--
ALTER TABLE `question_categories`
  ADD PRIMARY KEY (`idSection`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`idReport`);

--
-- Индексы таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`idReview`),
  ADD UNIQUE KEY `unique_user_game` (`game_id`,`user_id`),
  ADD KEY `fk_reviews_user` (`user_id`),
  ADD KEY `fk_rating_game` (`rating_id`),
  ADD KEY `fk_reviews_moderated_by` (`moderated_by`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idRole`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `screenshots`
--
ALTER TABLE `screenshots`
  ADD PRIMARY KEY (`idScreenshot`),
  ADD UNIQUE KEY `unique_image-key` (`image_key`),
  ADD KEY `fk_game_screenshot` (`game_id`);

--
-- Индексы таблицы `statuses`
--
ALTER TABLE `statuses`
  ADD PRIMARY KEY (`idStatus`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `themes`
--
ALTER TABLE `themes`
  ADD PRIMARY KEY (`idTheme`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`idUser`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `nickname` (`nickname`),
  ADD KEY `fk_users_role` (`role_id`),
  ADD KEY `idx_users_nickname` (`nickname`);

--
-- Индексы таблицы `user_collections`
--
ALTER TABLE `user_collections`
  ADD PRIMARY KEY (`idCollection`),
  ADD UNIQUE KEY `unique_user_game_type` (`user_id`,`game_id`,`collection_type`),
  ADD KEY `game_id` (`game_id`),
  ADD KEY `idx_user_game` (`user_id`,`game_id`);

--
-- Индексы таблицы `user_restrictions`
--
ALTER TABLE `user_restrictions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `moderated_by` (`moderated_by`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `app_settings`
--
ALTER TABLE `app_settings`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор записи', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `articles`
--
ALTER TABLE `articles`
  MODIFY `idArticle` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT для таблицы `article_categories`
--
ALTER TABLE `article_categories`
  MODIFY `idCategory` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `brands`
--
ALTER TABLE `brands`
  MODIFY `idBrand` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `comments`
--
ALTER TABLE `comments`
  MODIFY `idComment` int NOT NULL AUTO_INCREMENT COMMENT 'Индентификатор комментария', AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT для таблицы `companies`
--
ALTER TABLE `companies`
  MODIFY `idCompany` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT для таблицы `favorites`
--
ALTER TABLE `favorites`
  MODIFY `idFavorite` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT для таблицы `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT для таблицы `games`
--
ALTER TABLE `games`
  MODIFY `idGame` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1323;

--
-- AUTO_INCREMENT для таблицы `game_genres`
--
ALTER TABLE `game_genres`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=248;

--
-- AUTO_INCREMENT для таблицы `game_modes`
--
ALTER TABLE `game_modes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=227;

--
-- AUTO_INCREMENT для таблицы `game_perspectives`
--
ALTER TABLE `game_perspectives`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT для таблицы `game_ratings`
--
ALTER TABLE `game_ratings`
  MODIFY `idGameRating` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT для таблицы `game_ratings_params`
--
ALTER TABLE `game_ratings_params`
  MODIFY `idParam` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `game_requests`
--
ALTER TABLE `game_requests`
  MODIFY `idRequest` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `game_themes`
--
ALTER TABLE `game_themes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=323;

--
-- AUTO_INCREMENT для таблицы `genres`
--
ALTER TABLE `genres`
  MODIFY `idGenre` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT для таблицы `modes`
--
ALTER TABLE `modes`
  MODIFY `idMode` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `news`
--
ALTER TABLE `news`
  MODIFY `idNew` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=240;

--
-- AUTO_INCREMENT для таблицы `news_categories`
--
ALTER TABLE `news_categories`
  MODIFY `idCategory` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `perspectives`
--
ALTER TABLE `perspectives`
  MODIFY `idPerspective` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `platforms`
--
ALTER TABLE `platforms`
  MODIFY `idPlatform` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=509;

--
-- AUTO_INCREMENT для таблицы `questions`
--
ALTER TABLE `questions`
  MODIFY `idQuestion` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор вопроса', AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT для таблицы `question_categories`
--
ALTER TABLE `question_categories`
  MODIFY `idSection` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `reports`
--
ALTER TABLE `reports`
  MODIFY `idReport` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `reviews`
--
ALTER TABLE `reviews`
  MODIFY `idReview` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор рецензии';

--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `idRole` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `screenshots`
--
ALTER TABLE `screenshots`
  MODIFY `idScreenshot` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2294;

--
-- AUTO_INCREMENT для таблицы `statuses`
--
ALTER TABLE `statuses`
  MODIFY `idStatus` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT для таблицы `themes`
--
ALTER TABLE `themes`
  MODIFY `idTheme` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `idUser` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT для таблицы `user_collections`
--
ALTER TABLE `user_collections`
  MODIFY `idCollection` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT для таблицы `user_restrictions`
--
ALTER TABLE `user_restrictions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор записи', AUTO_INCREMENT=15;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `fk_article_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`),
  ADD CONSTRAINT `fk_article_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`),
  ADD CONSTRAINT `fk_article_type` FOREIGN KEY (`category_id`) REFERENCES `article_categories` (`idCategory`),
  ADD CONSTRAINT `fk_article_user` FOREIGN KEY (`author_id`) REFERENCES `users` (`idUser`);

--
-- Ограничения внешнего ключа таблицы `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `fk_comment_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`),
  ADD CONSTRAINT `fk_comments_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`idUser`) ON DELETE CASCADE,
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `Games` (`idGame`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `friends`
--
ALTER TABLE `friends`
  ADD CONSTRAINT `fk_friend` FOREIGN KEY (`friend_id`) REFERENCES `users` (`idUser`),
  ADD CONSTRAINT `fk_friend_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`),
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`);

--
-- Ограничения внешнего ключа таблицы `game_genres`
--
ALTER TABLE `game_genres`
  ADD CONSTRAINT `fk_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`idGenre`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `game_modes`
--
ALTER TABLE `game_modes`
  ADD CONSTRAINT `fk_gameMode` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mode` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`idMode`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `game_perspectives`
--
ALTER TABLE `game_perspectives`
  ADD CONSTRAINT `fk_gamePerspective` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_perspective` FOREIGN KEY (`perspective_id`) REFERENCES `perspectives` (`idPerspective`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `game_platforms`
--
ALTER TABLE `game_platforms`
  ADD CONSTRAINT `game_platforms_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  ADD CONSTRAINT `game_platforms_ibfk_2` FOREIGN KEY (`platform_id`) REFERENCES `platforms` (`idPlatform`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `game_ratings`
--
ALTER TABLE `game_ratings`
  ADD CONSTRAINT `fk_game_ratings_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_game_ratings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`);

--
-- Ограничения внешнего ключа таблицы `game_ratings_params`
--
ALTER TABLE `game_ratings_params`
  ADD CONSTRAINT `fk_author_param` FOREIGN KEY (`author_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_game_param` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `game_requests`
--
ALTER TABLE `game_requests`
  ADD CONSTRAINT `fk_GameRequests_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_request_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`);

--
-- Ограничения внешнего ключа таблицы `game_themes`
--
ALTER TABLE `game_themes`
  ADD CONSTRAINT `fk_gameTheme` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_theme` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`idTheme`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `fk_news_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_news_category` FOREIGN KEY (`category_id`) REFERENCES `news_categories` (`idCategory`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_news_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_news_status` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`idStatus`);

--
-- Ограничения внешнего ключа таблицы `platforms`
--
ALTER TABLE `platforms`
  ADD CONSTRAINT `fk_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`idBrand`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `fk_qsection` FOREIGN KEY (`section_id`) REFERENCES `question_categories` (`idSection`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_questions_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_userQstn` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`);

--
-- Ограничения внешнего ключа таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_rating_game` FOREIGN KEY (`rating_id`) REFERENCES `game_ratings` (`idGameRating`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_reviews_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_reviews_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`);

--
-- Ограничения внешнего ключа таблицы `screenshots`
--
ALTER TABLE `screenshots`
  ADD CONSTRAINT `fk_game_screenshot` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`idRole`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_collections`
--
ALTER TABLE `user_collections`
  ADD CONSTRAINT `user_collections_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`),
  ADD CONSTRAINT `user_collections_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_restrictions`
--
ALTER TABLE `user_restrictions`
  ADD CONSTRAINT `user_restrictions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_restrictions_ibfk_2` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
