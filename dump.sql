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
-- Table structure for table `appsettings`
--

DROP TABLE IF EXISTS `appsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appsettings` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор записи',
  `slider_game_mode` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'best' COMMENT 'Мод игрового слайдера',
  `slider_news_mode` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'main' COMMENT 'Мод новостного слайдера',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appsettings`
--

LOCK TABLES `appsettings` WRITE;
/*!40000 ALTER TABLE `appsettings` DISABLE KEYS */;
INSERT INTO `appsettings` VALUES (1,'best','popular');
/*!40000 ALTER TABLE `appsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles` (
  `idArticle` int NOT NULL AUTO_INCREMENT,
  `type_article` varchar(45) NOT NULL,
  `game_id` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `image` varchar(500) NOT NULL,
  `score` decimal(10,0) DEFAULT NULL,
  `views_count` int NOT NULL DEFAULT '0',
  `comments_count` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(45) NOT NULL DEFAULT 'awaiting',
  `author_id` int NOT NULL,
  PRIMARY KEY (`idArticle`),
  UNIQUE KEY `unique_game_review` (`game_id`,`type_article`),
  KEY `fk_article_user` (`author_id`),
  CONSTRAINT `fk_article_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`),
  CONSTRAINT `fk_article_user` FOREIGN KEY (`author_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES (24,'selections',NULL,'Лучшие игры до 500 рублей в Steam — май 2026','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779212411459-6649zlkhr.jpg\" alt=\"\" data-minio-key=\"articles/content/1779212411459-6649zlkhr.jpg\"><i>Обложка GameStation</i><br><p class=\"text-content\">Мир видеоигр огромен и необъятен. Несмотря на огромное количество известных тайтлов, которые почти не покидают инфополе, очень легко пропустить действительно значимый проект. Собственноручно же найти настоящие жемчужины среди бесконечной ленты популярных проектов — задача ещё более вызывающая. Особенно если бюджет ограничен, а хочется найти игру, в которую можно возвращаться снова и снова.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Собрали небольшую подборку из 10 платных игр в Steam стоимостью 500 рублей или меньше, среди которых найдутся как уже проверенная временем классика, так и относительно свежие открытия последних лет. Цены и скидки актуальны на май 2026 года.</p><br><p class=\"text-content\"><b>The King is Watching</b></p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779212476718-xhb5bqbhv.webp\" alt=\"\" data-minio-key=\"articles/content/1779212476718-xhb5bqbhv.webp\"><i>Источник: видеоигра The King is Watching</i><br><p class=\"text-content\">Разработчик: Hypnohead</p><p class=\"text-content\">Дата выхода: 2025</p><p class=\"text-content\">Жанр: стратегия, roguelite</p><p class=\"text-content\">Цена: 599 рублей</p><br><p class=\"text-content\">R.E.P.O.</p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779212544603-w4ov6zb34.jpg\" alt=\"\" data-minio-key=\"articles/content/1779212544603-w4ov6zb34.jpg\"><i>Источник: видеоигра R.E.P.O.</i><br><p class=\"text-content\">R.E.P.O. — типичный представитель эпохи «френдслопа» и наиболее успешный подражатель Lethal Company. Вы играете группой сборщиков ценностей в постапокалиптическом мире: совершаете вылазки в жуткие поместья, чтобы вытащить добра на нужную сумму, попутно избегая разнообразных чудовищ.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Порой главным врагом становятся не монстры и даже не растущая квота, а физика: тяжёлые вещи валятся из рук и бьются о стены, товарищи мешают друг другу, а где-то рядом бродят чудовища — превращая простую переноску предметов в праздник хаоса, совмещающий веселье, напряжение и командную игру.</p><br><p class=\"text-content\">Stardew Valley</p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779212603777-c1ugu952k.jpg\" alt=\"\" data-minio-key=\"articles/content/1779212603777-c1ugu952k.jpg\"><i>Источник: видеоигра Stardew Valley</i><br><p class=\"text-content\">Разработчик: concernedApe</p><p class=\"text-content\">Дата выхода: 2016</p><p class=\"text-content\">Жанр: симулятор фермы, RPG</p><p class=\"text-content\">Цена: 149 ₽ по скидке до 21 мая</p><p class=\"text-content\"><br></p><p class=\"text-content\">Stardew Valley — эталонный представитель симуляторов фермы. Игрок получает в наследство старую ферму и постепенно превращает её в процветающее хозяйство, попутно становясь частью большого и живого комьюнити деревни «Пеликан».</p><p class=\"text-content\">Под маской казуальной игры скрывается проект на десятки, а то и сотни часов. Здесь можно заниматься фермой, строить отношения с местными, исследовать подземелья, рыбачить и просто наслаждаться размеренной сельской жизнью.</p></div></div></div></div>','articles/covers/1779212648703-1k4gs88cp.jpg',0,4,0,'2026-05-19 20:44:08','awaiting',34),(25,'reviews',NULL,'Отказ PlayStation от выпуска своих одиночных игр — хорошо это или плохо','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779213487717-9f58cz8gs.jpg\" alt=\"\" data-minio-key=\"articles/content/1779213487717-9f58cz8gs.jpg\"><i>Обложка: видеоигра Marvel’s Wolverine</i><br><p class=\"text-content\">Журналист <b>Джейсон Шрайер</b> ещё раз написал о том, что Sony круто меняет свою политику в отношении эксклюзивов. Одиночные игры от внутренних студий перестанут выпускать на PC в принципе — ни через год, ни через два года после релиза на персональных компьютерах в них сыграть не выйдет. Официально корпорация этого ещё не подтвердила, но, вероятно, в скором времени такой анонс всё-таки последует.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Разговоры вокруг этой новости, разумеется, начались сразу же. Причём, как и полагается любому спору вокруг эксклюзивов, они немедленно переросли в метания фекалиями.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Поклонники <a href=\"fdsfsdf\">PlayStation</a> — самые, во всяком случае, голосистые — решением довольны. По их мнению это поможет компании «восстановить доброе имя бренда» и «привлечь к консолям новую аудиторию». Противники же такого решения отмечают, что если уж игры Sony неважно чувствуют себя на PC — то никакой «новой аудитории» на консолях не будет. Что до «восстановления доброго имени бренда», то тут компании лучше было бы ударяться не в эксклюзивы, а тщательнее следить за качеством своих игр. Обе стороны, конечно же, друг друга слышать не желают, а потому в X (Twitter), на Reddit и других крупных площадках пылают костры и печёные платформенные еретики.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Алексей Егоров, редактор базы игр и автор «GameStation»</p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779213608787-lwn4jmjyb.jpg\" alt=\"\" data-minio-key=\"articles/content/1779213608787-lwn4jmjyb.jpg\"><i>Источник: видеоигра Bloodborne</i><br><p class=\"text-content\">Некогда Sony ухитрилась прогреть меня на покупку <b>PlayStation 4 Pro</b>. Покупка была совершена спонтанно, и привела в общем-то к закономерному результату: консоль осталась пылиться где-то рядом с телевизором. За всё время, что она стоит у меня дома, я прошел дай бог десяток-полтора игр. Причём некоторые не по зову сердца, а строго по работе.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Так что я как раз из тех людей, кто принял анонс о «сливе» эксклюзивов на PC с интересом и благосклонностью. Не то, чтобы мне не хватало игр — бэклог и так такой толщины, что с ума сойти можно — но почему бы и нет? Да и в груди робко теплилась надежда на PC-версию <a href=\"fsdf\">Bloodborne</a>.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Той надежды, правда, уже давно нет — равно как и какого-либо интереса к консольным эксклюзивам Sony. Раньше я исправно платил за вышедшие на PC эксклюзивы, поддерживая портирование копеечкой. Теперь же, если информация Шрайера подтвердится, этой копеечки компания от меня не получит. Она от меня вообще ничего не получит — не побегу же я покупать себе <b>PlayStation 5</b>, когда у меня дома стоит достаточно мощный PC. И никаких достаточно любопытных эксклюзивов в запасе у Sony тоже нет.</p></div></div>','articles/covers/1779213672036-4k3a1ulq9.jpg',NULL,4,0,'2026-05-19 21:01:12','awaiting',34),(26,'reviews',NULL,'Что известно о GTA 6 — карта, персонажи и механики','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779213814022-y0hhq29d2.jpg\" alt=\"\" data-minio-key=\"articles/content/1779213814022-y0hhq29d2.jpg\"></div><div class=\"img-block flex-column\"><br><i>Обложка: видеоигра Grand Theft Auto VI</i><br><p class=\"text-content\"><b>Grand Theft Auto VI </b>стала культурным явлением задолго до своего выхода. С момента выхода <b>GTA V</b> прошло больше десяти лет: <b>Grand</b> <b>Theft Auto Online</b> успела превратиться в самостоятельную платформу, а вышедшая следом <b>Red Dead Redemption 2</b> задрала планку качества и ожиданий игроков от следующей игры студии почти до абсурда.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Но если отбросить фанатские теории, фантазии, утечки и попытки разглядеть содержимое игры по отражению в <a href=\"аываыва\">луже из трейлера</a>, картина уже складывается вполне понятная, а информации о грядущем хите вполне достаточно. GTA 6 вернёт нас в Vice City, но теперь город станет частью целого штата Leonida. В центре истории окажутся Джейсон Дюваль и Люсия Каминос — пара преступников, которые окажутся втянуты в масштабный заговор.</p><br><p class=\"text-content\">Не только Vice City</p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779213884578-8pbcd6lyh.jpg\" alt=\"\" data-minio-key=\"articles/content/1779213884578-8pbcd6lyh.jpg\"><i>Источник: видеоигра Grand Theft Auto VI</i><br><p class=\"text-content\">Главное отличие <b>Grand Theft Auto VI </b>от <b>Grand Theft Auto: Vice City </b>уже понятно: Rockstar делает не просто современную версию знакомого города, а целый штат. Действие развернётся в Leonida — местной сатирической версии Флориды с курортным лоском, глухими болотами, иконичными промзонами и просторным национальным парком.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Vice City останется центром этой карты. Несмотря на разные эпохи, город сохранит узнаваемую смесь пляжной роскоши, ночных клубов, дорогих машин, криминала, пальм, блеска и полной социальной деградации. Но теперь вокруг него будет куда больше пространства. Rockstar уже показала несколько крупных зон: Leonida Keys, Grassrivers, Port Gellhorn, Ambrosia и Mount Kalaga National Park.</p><br><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779213932643-m359r1yc2.jpg\" alt=\"\" data-minio-key=\"articles/content/1779213932643-m359r1yc2.jpg\"><i>Источник: видеоигра Grand Theft Auto VI</i>\r\n        </div></div></div><p class=\"text-content\">Leonida Keys — курортный архипелаг, на котором не стихают вечеринки, а за горизонт уходят дорогие яхты. Grassrivers — болотистая глубинка с аллигаторами и прочим южным колоритом. Port Gellhorn — заброшенный курорт, лучшие времена которого остались далеко позади. Ambrosia отвечает за промышленную и более «деревенскую» стороны штата, а Mount Kalaga National Park позволит насладиться атмосферой лесов и заняться охотой, рыбалкой и покорением дикой природы.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Точный размер карты Rockstar пока не раскрывала, поэтому все разговоры о том, что она будет «в два» или «в три» раза больше <b>Grand Theft Auto V</b>, стоит воспринимать с осторожностью. Гораздо важнее, что Leonida берёт своим разнообразием — таким, каким могла похвастаться <b>Grand Theft Auto: San Andreas</b>. А если Rockstar удастся наполнить штат уникальными событиями, мир <b>Grand Theft Auto VI</b> может оказаться гораздо насыщеннее предыдущих частей серии.</p><br><p class=\"text-content\"><b>Главные герои и завязка</b></p><div class=\"img-block flex-column\"><img src=\"http://localhost:9000/gamestation-media/articles/content/1779213976668-asbe74fgx.jpg\" alt=\"\" data-minio-key=\"articles/content/1779213976668-asbe74fgx.jpg\"><i>Источник: видеоигра Grand Theft Auto VI</i><br><p class=\"text-content\">Впервые в основной номерной Grand Theft Auto центральным лицом истории станет женский персонаж. Люсия Каминос выходит из тюрьмы и пытается начать всё с чистого листа — прожить жизнь, о которой когда-то мечтала её мать. Но эта жизнь, судя по всему, будет вполне традиционной для серии: перестрелки, ограбления, сомнительные связи и сменяющие друг друга проблемы.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Джейсон Дюваль — второй главный герой. Вырос среди мошенников и преступников, успел послужить в армии, а затем начал работать на местных наркокурьеров. Он хочет спокойной жизни, но трейлеры довольно прозрачно намекают, что о спокойной жизни протагонисты GTA могут только мечтать.</p><p class=\"text-content\"><br></p><p class=\"text-content\">По тону игра явно тяготеет к истории в духе Бонни и Клайда, но с поправкой на фирменный стиль Rockstar. Помимо банального верхнего слоя о романтической паре на криминальном дне, официальное описание обещает: одно «плёвое» дело пойдёт не по плану, и герои окажутся в центре масштабных событий. Причём динамика между персонажами обещает быть глубже, чем в Grand Theft Auto IV. Серьёзный тон и способность Rockstar рассказывать не только абсурдные и авантюрные, но и по-настоящему человечные истории мы увидели в RDR2. Можно предположить, что в новой игре важной темой станет доверие: Джейсон и Люсия вынуждены полагаться друг на друга, если хотят выбраться из передряги живыми.</p>\r\n        </div>','articles/covers/1779213996224-dujv35s4g.jpg',0,3,0,'2026-05-19 21:06:36','awaiting',34),(27,'reviews',NULL,'Зло победило — 10 игр, в которых нет хорошей концовки','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779214524275-p3z6w3ryf.jpg\" alt=\"\" data-minio-key=\"articles/content/1779214524275-p3z6w3ryf.jpg\">\r\n        </div><div class=\"img-block flex-column\"><i>Крута респект тебе</i><br><p class=\"text-content\">Большинство произведений строится по схожему принципу: <b>главный герой</b> сталкивается с трудностями, а затем набирается сил и побеждает всех врагов. Формула присуща и книгам, и кино, и видеоиграм, но далеко не все творцы выбирают следование устоявшимся канонам. Именно поэтому в историю вошли игры, в которых нет однозначно хорошей <b>концовки</b> — персонаж теряет кого-то близкого, не достигает своей цели или же вовсе проигрывает злу. Именно о таких играх, ломающих шаблоны, мы и поговорим.</p><br><p class=\"text-content\"><b>Red Dead Redemption</b></p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779214899158-3b8kqhzeg.jpg\" alt=\"\" data-minio-key=\"articles/content/1779214899158-3b8kqhzeg.jpg\"></div><div class=\"img-block flex-column\">Источник: видеоигра Red Dead Redemption\r\n        </div><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/temp/articles/content/1779214644624-3av7m0sl7.jpg\" alt=\"\" data-minio-key=\"temp/articles/content/1779214644624-3av7m0sl7.jpg\"></div><div class=\"img-block flex-column\"><p class=\"text-content\"><b>Red Dead Redemption</b> — культовый вестерн, показавший способность Rockstar Games выходить за привычные рамки. Мир Дикого Запада, как и вселенная GTA, полон безумных персонажей, харизматичных мошенников и отпетых отморозков. При этом все они отходят на второй план: в центре внимания дилогии — банда Ван дер Линде.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Одним из членов распавшегося отряда был <b>Джон Марстон</b> — главный герой первой части, вынужденный преследовать бывших товарищей ради спасения жены и сына из рук федеральных агентов. На этом пути отважный ковбой участвует в бесконечных перестрелках, выживает в открытом мире и сталкивается с моральными дилеммами. Честь стала отдельной механикой — на неё влияют действия игрока.</p><p class=\"text-content\"><br></p><p class=\"text-content\">В <b>Red Dead Redemption</b> нет по-настоящему хорошей концовки: и основной, и скрытый финалы сполна отражают название игры. Почему же мы не добавили в подборку вторую часть — о приключениях Артура Моргана? Формально её сюжет завершается победой протагониста над злодеями и приводит к началу истории Джона Марстона.</p><br><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779214949463-8hcz3z8w7.jpg\" alt=\"\" data-minio-key=\"articles/content/1779214949463-8hcz3z8w7.jpg\"></div><div class=\"img-block flex-column\">Источник: видеоигра Spec Ops: The Line</div><div class=\"img-block flex-column\"><p class=\"text-content\">Пожалуй, об артхаусной направленности <b>Spec Ops: The Line </b>слышал каждый заядлый геймер. Боевик от третьего лица — конкретное пацифистское высказывание, показывающее человеческую жестокость на душещипательных примерах, а не на отстреле компьютерных болванчиков. Оригинальный подход проявляется и в концовках.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Главный герой, независимо от выбора в финале, уже не будет прежним. Его спасательная миссия в разрушенном песчаными бурями Дубае оборачивается кошмаром наяву — ужасом, от которого пострадали и соратники персонажа, и его враги, и загнанные в ловушку мирные жители. <b>Смерть</b> или жизнь — ничто не спасёт от посттравматического расстройства.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Spec Ops: The Line</b> — классика седьмого поколения консолей, официально достать которую нынче очень трудно. Но познакомиться с экшеном стоит: под личиной шутера скрывается история с серьёзными темами и крайне необычными художественными приёмами. Многие из них получится заметить лишь при повторном прохождении, когда суть сюжета уже ясна.</p></div><p class=\"text-content\"><br></p></div></div>','articles/covers/1779214539082-wp3mn8vvi.jpg',0,4,0,'2026-05-19 21:15:39','awaiting',34),(28,'reviews',NULL,'Мы поиграли в Cyberpunk 2077 спустя годы — стало ли лучше?','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215210555-kgp9sxrk8.jpg\" alt=\"\" data-minio-key=\"articles/content/1779215210555-kgp9sxrk8.jpg\"></div><div class=\"img-block flex-column\"><br>\r\n        </div><p class=\"text-content\">Признаюсь честно: в релизный<span style=\"color: rgb(240, 25, 55);\"> Cyberpunk 2077</span><b></b> я почти не играл. Слышал про баги, провалы на консолях, удалённую игру из PS Store — история была настолько громкой, что даже не хотелось прикасаться. Прошло несколько лет, вышло дополнение<span style=\"color: rgb(240, 25, 55);\"> Phantom Liberty</span><b></b>, игра получила кучу патчей — и я решил дать шанс.</p><p class=\"text-content\"><br></p><p class=\"text-content\">И знаете что? Это определённо один из лучших RPG-экшенов, в который я играл за последние годы. Но не всё так гладко.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Что понравилось: Первое, что цепляет — атмосфера. <span style=\"color: rgb(240, 25, 55);\">Найт-Сити</span> — это не просто город, это персонаж. Огромный, грязный, неоновый, живой. Ты идёшь по улице, а над головой пролетают машины, везде голограммы, киберпанки с имплантами, продавцы еды — мир действительно ощущается плотным.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Сюжет и персонажи — сильнейшая сторона игры. Джонни Сильверхенд в исполнении Киану Ривза — это харизма на миллион. Диалоги с ним, споры, флешбэки — всё это работает. <span style=\"color: var(--font-secondary);\">Джуди</span>, Панам, Ривер — каждому второстепенному персонажу сопереживаешь, а их личные квесты запоминаются лучше основного сюжета.</p><p class=\"text-content\"><br></p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215299033-fv51tore9.jpg\" alt=\"\" data-minio-key=\"articles/content/1779215299033-fv51tore9.jpg\"></div><div class=\"img-block flex-column\"><br>\r\n        </div><p class=\"text-content\">Особо отмечу<b> </b><span style=\"color: rgb(240, 25, 55);\"><b>Phantom Liberty</b>.</span> Дополнение добавляет новый район Dogtown, шпионский сюжет с Идрисом Эльбой и несколько лучших миссий во всей игре. Одна из них (та самая, в бункере) заставила меня реально напрягаться — такого в играх давно не было.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Что не понравилось:&nbsp;<b><span style=\"color: rgb(240, 25, 55);\">Открытый мир</span></b> — красивый, но пустоватый. Вайбов GTA нет. Полиция появляется из воздуха (да, патчи исправили систему розыска, но до идеала далеко), интерактива с окружением почти нет — в киберкофе не зайти, уличные торговцы это просто меню.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Баги никуда не делись. Да, стало лучше, намного лучше. Но я всё ещё видел: вылетевшую из рук гитару, которая осталась висеть в воздухе; персонажей, идущих сквозь двери; квестовый предмет, который не подбирался с первого раза. Теперь это не \"мем\", а редкие, но заметные мелочи.</p><p class=\"text-content\"><br></p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215312975-fl6fehzv8.jpg\" alt=\"\" data-minio-key=\"articles/content/1779215312975-fl6fehzv8.jpg\"></div><div class=\"img-block flex-column\"><br>\r\n        </div><p class=\"text-content\">Боевая система — неплохая, но с перекосом. Стоит прокачать нетраннеров (хакеров), как игра превращается в \"посмотрел на врага — он мёртв\". Сложность скатывается. А если идёшь в чистого сола (штурмовика) — сначала будет тяжеловато. Дисбаланс чувствуется.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Вердикт: да, однозначно стоит пройти. <b>Cyberpunk 2077</b> уже не тот провальный проект 2020 года. Это полноценная, глубокая RPG с отличным сюжетом, шикарной атмосферой и десятками часов контента. Если вы любите сюжетные игры, киберпанк, хорошие диалоги — проходите обязательно. А если ждали идеальный иммерсивный симулятор — возможно, стоит понизить ожидания.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Лично я прошёл основную игру за 50 часов, не делая все побочки. Phantom Liberty добавил ещё 15. И я не жалею ни минуты.</p>','articles/covers/1779215315009-2fehyygpl.jpg',8,5,0,'2026-05-19 21:28:35','awaiting',34),(29,'reviews',NULL,'Мы поиграли в Forza Horizon 6 — лучшая гоночная игра года?','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215507812-0ve3zc41c.webp\" alt=\"\" data-minio-key=\"articles/content/1779215507812-0ve3zc41c.webp\"><br><p class=\"text-content\">Признаюсь, к гоночным играм у меня всегда было двойственное отношение. С одной стороны, люблю скорость, красивые машины, свободу. С другой — быстро надоедает просто ездить по кругу. Но <b><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"font-size: 20px; line-height: 28px;\">Forza Horizon 6</span></span></b> меня удивила.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Что понравилось:</p><p class=\"text-content\">Первое — <b>графика и мир</b>. Разработчики перенесли действие в Японию. И это потрясающе! Ты гоняешь по залитым неоном улицам Токио, потом вылетаешь на горные серпантины Фудзи, затем оказываешься в живописных деревушках у моря. Мир живой: идут дожди, туман, смена дня и ночи — всё это влияет на управление машиной.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Второе</b> — разнообразие гонок. Тут тебе и уличные гонки по городу, и дрифт в горах, и бездорожье на пляже. Система сезонов теперь не просто картинка — в дождь машину ведёт иначе, а зимой приходится ставить шипованную резину. Это добавляет глубины.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Третье</b> — музыка и атмосфера. Радиостанции как всегда на высоте. Есть классическое радио Horizon с энергичными треками, есть отдельная станция с японским роком, есть даже lo-fi под которую просто кайфово кататься без цели.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Четвёртое</b> — огромный выбор машин. Более 700 автомобилей от классических японок (Supra, RX-7, Skyline) до гиперкаров Ferrari и Lamborghini. Каждая настраивается под тебя — меняй двигатель, коробку, подвеску, внешний вид.</p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215570358-8tegsd4tt.webp\" alt=\"\" data-minio-key=\"articles/content/1779215570358-8tegsd4tt.webp\">\r\n        </div><p class=\"text-content\">Что не понравилось:</p><p class=\"text-content\">Первое — сюжет почти отсутствует. Да, это открытая песочница, но хотелось бы хоть какой-то истории. Есть стартовый ролик, пара диалогов с ведущими — и всё. Мотивации особой нет.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Второе — музыка на старте быстро надоедает. Ротация треков не очень большая, часа через три игры начинаешь включать свои плейлисты.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Третье — копилка. Дорогие машины приходится выбивать очень долго. Без миктротранзакций (которые есть) на топовый гиперкар придётся копить часов 20-30 чистой игры. Это заставляет играть, но кого-то отпугнёт.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Четвёртое — мультиплеер. Он есть и он работает неплохо, но бывают вылеты, долгие загрузки. На старте пару раз ловил ошибку при подключении.</p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215626256-nvc615qyg.jpg\" alt=\"\" data-minio-key=\"articles/content/1779215626256-nvc615qyg.jpg\">\r\n        </div><p class=\"text-content\"><b>Вердикт:</b></p><p class=\"text-content\">Стоит ли играть? Да, однозначно. Forza Horizon 6 — это лучшая аркадная гоночная игра на данный момент. Она не требует от тебя сверхреакции как симуляторы, она дарит свободу и кайф от вождения. Отличная графика, музыка, огромный мир — всё это создаёт настроение.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Если вы фанат гоночных игр — берите не думая. Если просто любите иногда покататься — тоже берите, не разочарует. А если ждали хардкорный симулятор вроде Assetto Corsa — это не сюда.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Лично я накатал уже 40 часов и пока не планирую останавливаться. Открыл только половину карты, собрал 50 машин. И каждый раз нахожу что-то новое — уличную гонку, крутой ракурс для фото, секретную дорогу в горах.</p><p class=\"text-content\"><b>Оценка: 9/10</b>. Минус балл за слабый сюжет и затянутую экономику. Но геймплейно — шедевр.</p></div><p class=\"text-content\"><br></p>','articles/covers/1779215630931-ksvrgsdnm.webp',9,6,0,'2026-05-19 21:33:50','awaiting',34),(31,'reviews',NULL,'God of War Ragnarök на ПК — идельный порт или сырой?','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215858862-28tq0yid3.jpg\" alt=\"\" data-minio-key=\"articles/content/1779215858862-28tq0yid3.jpg\"><br><p class=\"text-content\">Долгожданный порт <b><span style=\"color: rgb(240, 25, 55);\">God of War Ragnarök</span></b> наконец-то добрался до ПК. Первая часть на компьютере была отличной оптимизацией. Что со второй? Рассказываю честно.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Что понравилось: Первое — оптимизация. Игра работает отлично! На среднем железе<b> (RTX 3060, 16 ГБ ОЗУ)</b> выдает стабильные 60 FPS в 1080p с высокими настройками. DLSS и FSR работают как часы, картинка не мылится, производительность растёт. Sony явно сделала выводы из прошлых портов (как The Last of Us, например).</p><p class=\"text-content\"><br></p><p class=\"text-content\">Второе — это всё ещё тот же крутой слэшер с глубоким сюжетом. Кратос и Атрей возвращаются спустя три года после прошлой части. Скандинавская мифология раскрыта шикарно: Тор, Один, Фрейя — каждый прописан отлично.</p><p class=\"text-content\"><br></p><p></p><p class=\"text-content\">Третье — боевая система. Она стала ещё разнообразнее. Теперь у Атрейса собственный арсенал (лук, магия), Кратосу добавили новые руны и способности. Драки стали быстрее, зрелищнее, жёстче.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Четвёртое — визуал. Игра потрясающе выглядит даже на средних настройках. В 4K с DLSS на максимуме — просто кино. Эффекты частиц, снег, вода, модели персонажей — всё на высоте. Консольный опыт вдогонку с лучшей картинкой.</p><p class=\"text-content\"><br></p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215944236-zioeoog38.webp\" alt=\"\" data-minio-key=\"articles/content/1779215944236-zioeoog38.webp\">\r\n        </div><p class=\"text-content\">Что не понравилось: Первое — цена. Sony просит 60 баксов за порт игры, которой уже два года на PlayStation. Многовато, особенно если ты прошёл её на консоли. Но если вы не играли — возможно, оправдано.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Второе — есть микролаги в открытом мире. На ПК я пару раз замечал микрофризы при загрузке новых областей. Они незаметны если не присматриваться, но присутствуют. Надеюсь, первый патч поправит.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Третье — управление на мыши и клавиатуре неидеальное. Игра явно заточена под геймпад. Кнопки переключения оружия неудобные, прицеливание луком — так себе. Рекомендую играть с контроллером.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><span style=\"color: rgb(240, 25, 55);\"><span style=\"color: var(--font-primary-75);\">Четвёртое — требовательность к видеопамяти. На максимальных настройках в 4K игра жрёт больше 10 ГБ VRAM. На 8 ГБ придётся снижать текстуры.</span></span></p><p class=\"text-content\"><br></p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779215951375-b4f4gaofv.jpg\" alt=\"\" data-minio-key=\"articles/content/1779215951375-b4f4gaofv.jpg\">\r\n        </div><p class=\"text-content\">Стоит ли брать? Если у вас <b>PlayStation</b> и вы уже прошли — нет смысла. Если вы пропустили на консоли и ждали ПК-версию — однозначно берите. Ragnarök — это одна из лучших игр прошлого поколения, и ПК-порт вышел очень достойным.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Минус за цену, мелкие лаги и неидеальное управление с клавиатуры. Но геймплей и сюжет перекрывают эти мелочи. Лично я прошёл на ПК за <b>45 часов</b>, сделал почти всё. Не пожалел, хотя уже проходил на PS5. Ради хорошей частоты кадров и графики — стоит.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Оценка: 5/10.</b> Отличный порт, но не идеальный.</p>\r\n    <p class=\"text-content\"><br></p></div>','articles/covers/1779215955053-mklm7s1fx.jpg',5,3,0,'2026-05-19 21:39:15','awaiting',34),(32,'reviews',NULL,'Samson: Обзор неудачного клона GTA','<p class=\"text-content\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_Medium;\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_Medium;\">Поклонники<b> <span style=\"color: rgb(240, 25, 55);\">GTA</span></b> ждали релиза&nbsp; <b><span style=\"color: rgb(240, 25, 55);\">Samson</span> </b>— судя по анонсу, именно эта игра помогла бы им скоротать время в ожидании новой части главной криминальной саги. Тем более что разрабатывала Samson студия Liquid Swords, которую основал Кристофер Сандберг (Christofer Sundberg), соучредитель Avalanche Studios. Он заявлял, что Samson — это ответ на кризис в индустрии, «сфокусированный проект, созданный осознанно, без лишнего». Но почему в итоге его игра способна лишь окончательно убить веру в<span style=\"font-family: Roboto_SemiBold;\"> изл</span>ечение индустрии и при чём тут сериал «Прослушка»?</span></span></span></span></span></span></span></p><p class=\"text-content\"><br></p><p class=\"text-content\"><span style=\"font-size: 24px; line-height: 32px;\"><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"font-size: 24px; line-height: 32px;\"><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"font-size: 20px; line-height: 28px;\"><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"color: rgb(240, 25, 55);\"><span style=\"color: var(--font-primary-75);\"><span style=\"color: var(--font-secondary);\"><span style=\"color: var(--font-primary-75);\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_Medium;\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"font-family: Roboto_Medium;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"font-family: Roboto_Medium;\"><span style=\"color: rgb(240, 25, 55);\"><span style=\"color: var(--font-primary-75);\"><span style=\"color: rgb(240, 25, 55);\"><span style=\"color: var(--font-primary-75);\"><span style=\"font-family: Roboto_Medium;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"font-family: Roboto_Medium;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"color: rgb(240, 25, 55);\"><span style=\"color: var(--font-secondary);\"><span style=\"color: rgb(240, 25, 55);\"><span style=\"font-family: Roboto_Bold;\"><span style=\"font-size: 32px; line-height: 40px;\">Самсон и долги</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><span style=\"color: var(--font-primary-75);\"><img src=\"http://localhost:9000/gamestation-media/articles/content/1779216384255-iy2zi2s0m.jpg\" alt=\"\" data-minio-key=\"articles/content/1779216384255-iy2zi2s0m.jpg\"></span><div class=\"img-block flex-column\"><br><p class=\"text-content\">Работа делится на автомобильную и пешую, когда мы кого-то избиваем, возвращаем украденный товар или выслеживаем. За рулём нужно что-то куда-то доставить как можно быстрее, подхватить подельников и сбежать от копов или протаранить и устранить другого бандита на колёсах. Плюс есть гонки по ночным улицам Тиндалстона. Однако выполнить всё за день не получится — каждая работа отнимает очки действий, а они ограниченны — получается сделать максимум три заказа, а потом придётся отсыпаться дома, чтобы заплатить ежедневный взнос в счёт долга.</p><p class=\"text-content\"><br></p><p class=\"text-content\">При этом Самсон балансирует на грани обычного бандита и хорошего парня, чуть ли не Робин Гуда. Он колотит преимущественно убийц, предателей и воров (правда, разве в этом городе есть другие?), возвращает украденное, заботится о сестре и своих друзьях. Одного из них в начале игры подстрелили, и потом мы долго пытаемся выяснить, кто за этим стоит. Более того, Самсон и его друзья узнают, что в городе появился крайне опасный наркотик «Белый шёпот» и вообще творится какая-то дичь — неизвестные похищают людей и даже, кажется, разбирают на органы. Это всё как-то связано и с новым наркотиком, и с нападением на друзей Самсона. Мы пытаемся выяснить как и начинаем охоту на дилеров «Шёпота». А тех, кто на нём сидит, наш герой отправляет в церковь или в клинику.</p><br><p class=\"text-content\"><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"font-family: Roboto_SemiBold;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"color: rgb(240, 25, 55);\">Этот город — худший на земле?</span></span></span></span></p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779216423991-izcoefiao.jpg\" alt=\"\" data-minio-key=\"articles/content/1779216423991-izcoefiao.jpg\"></div>\r\n        </div><p class=\"text-content\">В общем, в сюжете есть интрига, а в образе главного героя — какая-никакая глубина (или хотя бы намёк на неё). Впрочем, интереснее и глубже проработан сам город, который тут выступает в качестве очень важного персонажа. Он не слишком приятный, и вы должны быть морально готовы делать усилие над собой, чтобы постоянно наблюдать бесконечные бандитские разборки.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Но все эти грязные, исписанные граффити дома и улочки, на которых кто-то тусуется, кто-то дерётся, колется или умирает от передоза, выведены с таким вниманием к деталям, что в этот город веришь. И его хочется исследовать — всегда можно выйти из тачки, отвлечься от дел и пройтись по подворотням.</p><br><p class=\"text-content\"><b></b><span style=\"color: rgb(240, 25, 55);\"><span style=\"font-family: Roboto_Bold;\"><b>Плюсы</b>:</span></span> сюжет местами интригует; неплохо прописанные персонажи; город отлично проработан, его интересно исследовать; автомобильные миссии способны зарядить адреналином; симпатичная графика.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b></b><span style=\"font-family: Roboto_Bold;\"><b></b><span style=\"color: rgb(240, 25, 55);\"><b>Минусы</b>:</span></span> плачевное техническое состояние игры; несбалансированные драки; сюжет неадекватно затягивается и сваливается в бред; баланс устроен так, что в игре про тачки выполнять автомобильные миссии невыгодно; задания быстро начинают повторяться и превращаются в рутину.</p>','articles/covers/1779216470214-0192twn41.jpg',3,9,0,'2026-05-19 21:47:50','awaiting',34),(33,'reviews',NULL,'Code Vein II: Обзор неоднозначного анимешного соулслайка','<p class=\"text-content\">Как только не называли (и не обзывали)&nbsp; <b>Code Vein</b>, а теперь и сиквел! Самое распространённое — «<b>Dark Souls</b> в стиле аниме». А вторую часть, которая вышла в открытый мир, сравнивают с&nbsp; <b>Elden Ring</b>. И часто это не очень лестные сравнения. А по факту мы получили эпическую игру со своим набором недостатков и важных достоинств. И для меня плюсы перевесили минусы — сейчас объясню почему.</p><br><p class=\"text-content\"><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"font-size: 24px; line-height: 32px;\"><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"font-size: 32px; line-height: 40px;\">Кровь, слёзы и секс</span></span></span></span><br></p><p class=\"text-content\"><br></p><p class=\"text-content\">Анимешный соулслайк — это странно, интригующе и пугающе. И первая <b>Code Vein </b>полностью оправдывала эти ожидания. Здесь разодетые мальчики и сексапильные девочки с большими глазами и другими частями тела бьются в жестоких сражениях, а сюжет словно взят из подросткового аниме. Там полно странных названий, ничего поначалу не понятно, многих хочется затащить в постель и почти всех жалко.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><span style=\"line-height: 40px;\"><span style=\"line-height: 32px;\"><span style=\"line-height: 40px;\"><span style=\"line-height: 26px;\"></span></span></span></span></p><p class=\"text-content\">Даже в комментариях к нашему обзору разгорелись дискуссии по поводу того, что происходит по сюжету и лору, но суть в том, что в результате очередного апокалипсиса появились искусственно выведенные из покойников вампиры, которых называют бессмертными (или ревенантами), — их создали для борьбы с последствиями катастрофы. А вампиры разделились на более-менее хороших, плохих и совсем плохих, которые окончательно слетели с катушек и превратились в жаждущих крови потерянных.</p><br><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779216911159-dcyd70xkk.jpg\" alt=\"\" data-minio-key=\"articles/content/1779216911159-dcyd70xkk.jpg\"><br><p class=\"text-content\">В истории много слёз, драмы, преодоления и жертвенности. Всё это скрепляется фансервисом, совместными купаниями и пафосными кат-сценами. С этой точки зрения&nbsp; Code Vein II пошла ещё дальше. И дело не только в том, что груди у многих девушек стали больше, — главное, что в сюжете ещё больше странного и непонятного.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b><span style=\"font-size: 24px; line-height: 32px;\">Соулслайк с человеческим лицом</span></b></p><p class=\"text-content\">Многие называют сиквел мягким перезапуском: история тут другая, и её нельзя назвать продолжением — действие происходит в другом мире. Но при этом есть общие мотивы и термины.</p><p class=\"text-content\"><br></p><p class=\"text-content\">В Code Vein II также произошла катастрофа, известная как Сдвиг, и существуют бессмертные с острыми клыками. Но помимо них появились охотники на бессмертных, которые на деле могут действовать с бессмертными для защиты человечества. Для укрепления связи бессмертные отдают охотникам своё сердце, которое те носят у себя на спине.</p><p class=\"text-content\"><br></p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779216943921-ydflxbn67.jpg\" alt=\"\" data-minio-key=\"articles/content/1779216943921-ydflxbn67.jpg\">\r\n        </div>\r\n        </div><p class=\"text-content\">Мы играем за такого охотника (или охотницу — редактор персонажа в наличии), которому предстоит спасти мир от надвигающегося апокалипсиса. Для этого мы должны отправиться в прошлое, найти там великих героев из числа бессмертных, которые вроде как однажды уже спасли мир, пожертвовав собой и запечатав что-то страшное, а потом вернуться в настоящее и… убить их.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Чего? Кого позвать? Но главное во всём этом то, что нам нужно войти в доверие к героям в прошлом, чтобы нащупать важные для них эмоции и пробудить их от вечного сна в настоящем. И грохнуть.</p><br><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/articles/content/1779216985966-8w2xzl4df.jpg\" alt=\"\" data-minio-key=\"articles/content/1779216985966-8w2xzl4df.jpg\"><br><p class=\"text-content\">На самом деле, с&nbsp; <b><span style=\"font-size: 24px; line-height: 32px;\">Code Vein II</span></b> у меня случился стокгольмский синдром. Эта игра взяла меня в плен, я потратил на неё десятки часов и пару дней подряд ложился в три часа ночи, я сломал мышку и хотел сломать эти пальцы, которые даже с геймпадом не могли одолеть героя Лайла. Я материл авторов за затянутые миссии, скучные побочки и далеко расставленные чекпоинты, но в итоге не мог от игры оторваться и с болезненным восторгом заглядывал в глаза своей мучительнице в ожидании очередной порции сладкой боли. А когда одолел-таки и Лайла, и Жозе, и многих других боссов, то испытал наслаждение, которого в играх давно не испытывал.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Плюсы:</b> эмоциональный сюжет, который отчасти зависит от наших решений; отлично проработанные персонажи — в исполинских боссах видишь не чудовищ, а людей; механика путешествий во времени; открытый мир, который интересно и полезно исследовать; улучшенные по сравнению с оригиналом сражения; прорва возможностей для экспериментов с билдами; эффектные дизайн боссов и битвы с ними; переработанная механика напарников; выразительные звук и музыка.</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Минусы:</b> открытому миру не помешали бы более разнообразные побочные квесты; есть душные и затянутые миссии; некоторые инструменты кажутся явно полезнее других; графика местами устаревшая; некоторые жалуются на технические проблемы (у меня их не было, но должен предупредить).</p>\r\n        </div>','articles/covers/1779217003374-555y8yc7b.jpg',6,6,0,'2026-05-19 21:56:43','awaiting',34),(37,'reviews',NULL,'От Лос-Сантоса до Берега Смерти: какой ты легендарный водитель?','<div class=\"img-block flex-column\">\r\n                <img src=\"http://localhost:9000/gamestation-media/articles/content/1779290971668-j1whmz427.jpg\" alt=\"\" data-minio-key=\"articles/content/1779290971668-j1whmz427.jpg\">\r\n            </div>\r\n            <p class=\"text-content\"><span style=\"font-size: 14px; line-height: 22px;\"><i><span style=\"font-family: Roboto_Bold;\"><span style=\"font-family: Roboto_Medium;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"font-family: Roboto_Medium;\"><span style=\"color: var(--font-primary);\"><span style=\"font-family: Roboto_Medium;\">фото сгенерировано ИИ</span></span></span></span></span></span></i></span><br></p><br><p class=\"text-content\">В играх и кино успех зависит не только от того, кто жмёт на газ, но и от того, кто задаёт правила поездки. Кто-то мастерски выбивает скидки у торговцев, кто-то выстраивает сложнейшие маршруты через карту, а кто-то ценит контроль и личный комфорт.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Пройди наш тест и узнай, какой ты главный герой дорожных приключений. А мы подскажем, как перенести этот опыт в реальную жизнь и управлять своими поездками с помощью сервиса для заказа такси <span style=\"color: rgb(240, 25, 55);\"><span style=\"font-size: 20px; line-height: 28px;\"><span style=\"font-family: Roboto_Bold;\"><span style=\"font-family: Roboto_Medium;\"><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"font-size: 20px; line-height: 28px;\">Drivee</span></span></span></span></span></span>.</p><br><p class=\"text-content\"><span style=\"color: rgb(240, 25, 55);\">Такси</span> — привычное и удобное средство перемещения людей в современном мире, без которого уже тяжело представить свою размеренную жизнь. Люди давно уже пересели из древних карет в высокотехнологичные автомобили и ежедневно совершают миллионы поездок по своим делам. Не удивительно, что такси так часто уделяют внимание в массовой культуре: от показа небольших фрагментов из жизни обычных людей, например, появление такси-автобуса «Ночной рыцарь» в «Гарри Поттер и узник Азкабана», до создания огромной кинофраншизы «Такси» с кучей частей.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Сегодня мы отдаём дань уважения этому важному городскому транспорту и вспоминаем самые чумовые такси из игр: от Grand Theft Auto до более «особенных» моментов для геймеров.</p><p class=\"text-content\"><br></p><div class=\"img-block flex-column\">\r\n                <img src=\"http://localhost:9000/gamestation-media/articles/content/1779291129153-z7p8pb9p9.webp\" alt=\"\" data-minio-key=\"articles/content/1779291129153-z7p8pb9p9.webp\"></div>','articles/covers/1779291135648-g7vc9rnrm.jpg',0,3,0,'2026-05-20 18:32:15','awaiting',34),(38,'reviews',NULL,'Cyberpunk 2077 в 2025 году купили больше раз, чем в 2024 году — интерес к игре вырос','<div class=\"img-block flex-column\">\r\n                <img src=\"http://localhost:9000/gamestation-media/articles/content/1779291229541-y8srpola6.jpg\" alt=\"\" data-minio-key=\"articles/content/1779291229541-y8srpola6.jpg\">\r\n            </div>\r\n            <p class=\"text-content\"><span style=\"font-size: 14px; line-height: 22px;\"><i><span style=\"color: var(--font-primary);\">Обложка: скриншот Cyberpunk 2077</span></i></span></p><br><p class=\"text-content\"><span style=\"color: rgb(240, 25, 55);\">CD Projekt</span> поделилась финансовым отчётом за 2025 финансовый год. Компания заработала 867 миллионов злотых (около 233,5 млн долларов), а чистая прибыль составила 521 миллион злотых (около 140,3 млн долларов). По показателям прибыльности 2025 год стал вторым лучшим в истории CD Projekt.</p><p class=\"text-content\"><br></p><p class=\"text-content\">При этом в 2025 финансовом году не обошлось и без трат. Компания инвестировала более 513 миллионов злотых (около 138,2 млн долларов) в разработку будущих игр, сосредоточившись на <span style=\"color: rgb(240, 25, 55);\">Ведьмак 4</span> и <span style=\"color: rgb(240, 25, 55);\">Cyberpunk 2</span>. Также CD Projekt RED начала трудиться над Project Hadar — новинкой, которая будет основана на уникальной вселенной.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Увы, CD Projekt не стала обновлять данные по продажам своих игр — они актуальны на 26 ноября 2025 года. Тираж <span style=\"color: rgb(240, 25, 55);\">Cyberpunk 2077</span> превысил 35 миллионов копий, а дополнения <span style=\"color: rgb(240, 25, 55);\">Phantom Liberty</span> — 10 миллионов. Причём в 2025 году интерес покупателей к «Киберпанку» вырос в сравнении с 2024 годом, возможно, из-за порта на Nintendo Switch 2.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Ролевая игра <span style=\"color: rgb(240, 25, 55);\">«Ведьмак 3: Дикая Охота»</span> продалась 60 миллионов раз с момента релиза в 2015 году. CD Projekt отмечает, что первые две части The Witcher также стабильно продаются на PC.</p><br><p class=\"text-content\"><span style=\"font-size: 32px; line-height: 40px;\"><span style=\"font-family: Roboto_Bold;\">Продажи Cyberpunk 2077 и The Witcher 3 по годам и платформам</span></span></p><p class=\"text-content\"><br></p><p></p><div class=\"img-block flex-column\">\r\n                <img src=\"http://localhost:9000/gamestation-media/temp/articles/content/1779377150900-qrla4v17v.jpg\" alt=\"\" data-minio-key=\"temp/articles/content/1779377150900-qrla4v17v.jpg\">\r\n            </div><p class=\"text-content\">Финансовый директор CD Projekt подытожил, что 2025 год стал временем интенсивной работы над будущими играми. При этом существующий каталог смог показать «непоколебимую силу».</p>','articles/covers/1779291426994-699uoi090.jpg',0,5,0,'2026-05-20 18:37:07','awaiting',34);
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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания комментария',
  `user_id` int NOT NULL COMMENT 'Идентификато пользователя',
  `entity_type` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Тип сущности к которой комментарий',
  `entity_id` int NOT NULL COMMENT 'Идентификатор самой сущности',
  `parent_comment_id` int DEFAULT NULL COMMENT 'Идентификатор родительского комментария',
  `moderated_status` enum('active','hidden','deleted') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active' COMMENT 'Статус модерации',
  `moderated_by` int DEFAULT NULL COMMENT 'Идентификатор модератора',
  `moderation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Причина модерации',
  PRIMARY KEY (`idComment`),
  KEY `fk_comments_user` (`user_id`),
  KEY `idx_comment` (`entity_type`,`entity_id`),
  KEY `fk_comments_moderated_by` (`moderated_by`),
  CONSTRAINT `fk_comments_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (226,'Это реально крута','2026-05-19 20:28:49',34,'news',159,NULL,'active',NULL,NULL),(227,'Эх было бы славно','2026-05-19 20:31:09',34,'news',155,NULL,'active',NULL,NULL),(228,'Да я знаю)','2026-05-19 20:31:15',34,'news',155,227,'active',NULL,NULL),(229,'Крута','2026-05-19 23:53:36',34,'theme',39,NULL,'active',NULL,NULL),(231,'Да я не думал что он дальше будет взламывать','2026-05-20 19:16:18',34,'news',154,NULL,'active',NULL,NULL),(232,'Не ну ток не давно скачал и впринципе разобрался в этом','2026-05-20 22:02:57',34,'news',140,NULL,'active',NULL,NULL),(233,'Ну если будет цена в 69.99 это будет шикарно','2026-05-20 22:03:33',34,'news',151,NULL,'active',NULL,NULL),(234,'Эт ну это классика','2026-05-20 22:04:13',34,'news',160,NULL,'active',NULL,NULL),(235,'Надеемся что так будет','2026-05-21 10:33:49',34,'news',153,NULL,'active',NULL,NULL);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_comments_count_insert` AFTER INSERT ON `comments` FOR EACH ROW BEGIN
    CASE NEW.entity_type
        WHEN 'news' THEN
            UPDATE News SET comments_count = (
                SELECT COUNT(*) FROM Comments 
                WHERE entity_type = 'news' 
                  AND entity_id = NEW.entity_id
                  AND moderated_status = 'active'
            ) WHERE idNew = NEW.entity_id;

        WHEN 'theme' THEN
            UPDATE Questions SET comments_count = (
                SELECT COUNT(*) FROM Comments 
                WHERE entity_type = 'theme' 
                  AND entity_id = NEW.entity_id
                  AND moderated_status = 'active'
            ) WHERE idQuestion = NEW.entity_id;

        WHEN 'article' THEN
            UPDATE Articles SET comments_count = (
                SELECT COUNT(*) FROM Comments 
                WHERE entity_type = 'article' 
                  AND entity_id = NEW.entity_id
                  AND moderated_status = 'active'
            ) WHERE idArticle = NEW.entity_id;

        WHEN 'review' THEN
            UPDATE Reviews SET comments_count = (
                SELECT COUNT(*) FROM Comments
                WHERE entity_type = 'review' 
                  AND entity_id = NEW.entity_id
                  AND moderated_status = 'active'
            ) WHERE idReview = NEW.entity_id;
    END CASE;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_comments_count_delete` AFTER DELETE ON `comments` FOR EACH ROW BEGIN
    CASE OLD.entity_type
        WHEN 'news' THEN
            UPDATE News SET comments_count = (
                SELECT COUNT(*) FROM Comments 
                WHERE entity_type = 'news' 
                  AND entity_id = OLD.entity_id
                  AND moderated_status = 'active'
            ) WHERE idNew = OLD.entity_id;
        
        WHEN 'theme' THEN
            UPDATE Questions SET comments_count = (
                SELECT COUNT(*) FROM Comments 
                WHERE entity_type = 'theme' 
                  AND entity_id = OLD.entity_id
                  AND moderated_status = 'active'
            ) WHERE idQuestion = OLD.entity_id;
        
        WHEN 'article' THEN
            UPDATE Articles SET comments_count = (
                SELECT COUNT(*) FROM Comments 
                WHERE entity_type = 'article' 
                  AND entity_id = OLD.entity_id
                  AND moderated_status = 'active'
            ) WHERE idArticle = OLD.entity_id;

        WHEN 'review' THEN
            UPDATE Reviews SET comments_count = (
                SELECT COUNT(*) FROM Comments
                WHERE entity_type = 'review' 
                  AND entity_id = OLD.entity_id
                  AND moderated_status = 'active'
            ) WHERE idReview = OLD.entity_id;
    END CASE;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  `status` varchar(45) NOT NULL DEFAULT 'awaiting',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user` (`user_id`),
  KEY `fk_friend` (`friend_id`),
  CONSTRAINT `fk_friend` FOREIGN KEY (`friend_id`) REFERENCES `users` (`idUser`),
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friends`
--

LOCK TABLES `friends` WRITE;
/*!40000 ALTER TABLE `friends` DISABLE KEYS */;
INSERT INTO `friends` VALUES (60,34,33,'approved','2026-05-19 19:24:40');
/*!40000 ALTER TABLE `friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gamegenres`
--

DROP TABLE IF EXISTS `gamegenres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gamegenres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_game` (`game_id`),
  KEY `fk_genre` (`genre_id`),
  CONSTRAINT `fk_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`idGenre`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1011 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gamegenres`
--

LOCK TABLES `gamegenres` WRITE;
/*!40000 ALTER TABLE `gamegenres` DISABLE KEYS */;
INSERT INTO `gamegenres` VALUES (805,1138,12),(806,1138,15),(807,1138,16),(808,1139,12),(809,1139,31),(810,1140,12),(811,1140,31),(812,1141,5),(813,1141,31),(815,1143,5),(816,1143,12),(817,1143,31),(818,1144,5),(819,1144,31),(820,1145,12),(821,1145,31),(822,1145,32),(823,1146,5),(824,1146,24),(825,1146,31),(826,1147,12),(827,1147,31),(828,1148,9),(829,1148,31),(833,1150,12),(834,1150,25),(835,1150,31),(836,1151,9),(837,1151,31),(838,1152,8),(839,1152,31),(840,1152,32),(841,1153,8),(842,1153,31),(843,1154,12),(844,1154,31),(845,1155,9),(846,1155,31),(847,1156,5),(848,1156,12),(849,1156,31),(850,1157,8),(851,1157,9),(852,1157,31),(853,1158,9),(854,1158,31),(858,1160,5),(859,1160,31),(860,1161,5),(861,1161,24),(862,1161,31),(863,1162,12),(864,1162,31),(865,1163,5),(866,1164,12),(867,1164,31),(871,1166,12),(872,1166,25),(873,1168,31),(874,1169,5),(875,1169,10),(876,1169,31),(877,1170,12),(878,1170,25),(879,1170,31),(880,1170,32),(882,1172,5),(883,1172,12),(884,1172,31),(885,1174,15),(886,1174,36),(891,1178,8),(892,1178,25),(893,1178,31),(894,1179,8),(895,1179,31),(899,1181,5),(900,1181,24),(901,1181,31),(911,1186,5),(912,1186,8),(913,1186,31),(914,1187,12),(915,1187,25),(916,1187,31),(917,1188,12),(918,1188,25),(919,1189,8),(920,1189,9),(921,1189,31),(925,1159,12),(926,1159,25),(927,1159,31),(928,1165,5),(929,1165,10),(930,1165,31),(931,1176,5),(932,1176,12),(933,1176,31),(934,1190,9),(935,1190,12),(936,1190,31),(937,1191,8),(938,1191,31),(939,1192,9),(940,1192,31),(941,1192,32),(944,1193,31),(945,1194,5),(946,1194,31),(947,1195,31),(957,1196,32),(958,1197,5),(959,1197,12),(960,1197,13),(961,1197,31),(962,1197,32),(965,1198,5),(969,1199,9),(970,1199,32),(972,1200,31),(976,1203,31),(977,1203,5),(984,1204,13),(985,1204,31),(986,1204,32),(988,1205,5),(989,1206,8),(990,1206,32),(996,1208,5),(997,1208,12),(1000,1209,5),(1001,1209,12),(1002,1210,5),(1003,1210,12),(1005,1211,5),(1007,1212,5),(1009,1213,5),(1010,1214,5);
/*!40000 ALTER TABLE `gamegenres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gamemodes`
--

DROP TABLE IF EXISTS `gamemodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gamemodes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `mode_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_gameMode` (`game_id`),
  KEY `fk_mode` (`mode_id`),
  CONSTRAINT `fk_gameMode` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_mode` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`idMode`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=629 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gamemodes`
--

LOCK TABLES `gamemodes` WRITE;
/*!40000 ALTER TABLE `gamemodes` DISABLE KEYS */;
INSERT INTO `gamemodes` VALUES (453,1138,1),(454,1138,2),(455,1138,3),(456,1138,4),(457,1139,1),(458,1140,1),(459,1140,2),(460,1140,3),(461,1141,1),(462,1141,2),(464,1143,1),(465,1143,2),(466,1143,3),(467,1144,1),(468,1144,2),(469,1145,1),(470,1146,1),(471,1147,1),(472,1148,1),(474,1150,1),(475,1151,1),(476,1152,1),(477,1153,1),(478,1153,2),(479,1154,1),(480,1154,2),(481,1154,3),(482,1155,1),(483,1156,1),(484,1157,1),(485,1157,2),(486,1157,3),(487,1157,4),(488,1158,1),(490,1160,1),(491,1160,2),(492,1161,1),(493,1162,1),(494,1163,1),(495,1164,1),(498,1166,1),(499,1168,1),(500,1169,1),(501,1169,2),(502,1169,3),(503,1170,1),(506,1172,1),(507,1172,2),(508,1174,2),(509,1174,3),(512,1178,1),(513,1179,1),(514,1179,3),(516,1181,1),(524,1186,1),(525,1186,2),(526,1186,3),(527,1187,1),(528,1188,1),(529,1188,2),(530,1188,3),(531,1189,2),(532,1189,3),(533,1189,4),(536,1159,1),(537,1165,3),(538,1165,1),(539,1176,1),(540,1190,1),(541,1191,1),(542,1192,1),(544,1193,1),(545,1194,1),(546,1195,2),(547,1195,3),(548,1195,4),(558,1196,1),(559,1196,3),(560,1197,1),(561,1197,2),(562,1197,3),(565,1198,1),(567,1199,1),(570,1200,1),(571,1200,2),(576,1202,1),(580,1203,1),(581,1203,2),(582,1203,3),(585,1204,1),(589,1205,1),(590,1205,2),(591,1205,3),(592,1206,1),(593,1206,2),(594,1206,3),(596,1207,1),(597,1207,2),(604,1208,1),(605,1208,3),(610,1209,1),(611,1209,3),(612,1210,1),(613,1210,2),(614,1210,3),(617,1211,1),(618,1211,2),(621,1212,1),(622,1212,2),(625,1213,1),(626,1213,2),(627,1214,1),(628,1214,2);
/*!40000 ALTER TABLE `gamemodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gameperspectives`
--

DROP TABLE IF EXISTS `gameperspectives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gameperspectives` (
  `id` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `perspective_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_gamePerspective` (`game_id`),
  KEY `fk_perspective` (`perspective_id`),
  CONSTRAINT `fk_gamePerspective` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_perspective` FOREIGN KEY (`perspective_id`) REFERENCES `perspectives` (`idPerspective`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=475 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gameperspectives`
--

LOCK TABLES `gameperspectives` WRITE;
/*!40000 ALTER TABLE `gameperspectives` DISABLE KEYS */;
INSERT INTO `gameperspectives` VALUES (361,1138,3),(362,1139,2),(363,1140,2),(364,1141,2),(366,1143,1),(367,1143,2),(368,1144,2),(369,1145,3),(370,1145,5),(371,1146,1),(372,1146,2),(373,1146,3),(374,1147,2),(375,1148,2),(377,1150,2),(378,1151,3),(379,1152,4),(380,1153,4),(381,1154,2),(382,1155,2),(383,1156,2),(384,1157,1),(385,1158,2),(387,1160,2),(388,1161,2),(389,1162,2),(390,1162,3),(391,1163,1),(392,1164,2),(395,1166,2),(396,1166,4),(397,1166,5),(398,1168,2),(399,1169,1),(400,1169,2),(401,1170,3),(403,1172,2),(404,1174,2),(405,1174,3),(407,1178,2),(408,1179,2),(410,1181,2),(415,1186,2),(416,1187,2),(417,1188,3),(418,1189,2),(421,1159,2),(422,1165,1),(423,1165,2),(424,1176,1),(425,1190,1),(426,1191,4),(427,1192,2),(429,1193,2),(430,1194,2),(431,1195,2),(436,1196,2),(437,1197,1),(440,1198,1),(442,1199,1),(444,1200,2),(448,1202,1),(450,1203,1),(453,1204,2),(455,1205,1),(456,1206,4),(458,1207,1),(461,1208,1),(463,1209,1),(464,1210,1),(467,1211,1),(469,1212,1),(472,1213,1),(473,1213,2),(474,1214,1);
/*!40000 ALTER TABLE `gameperspectives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gameplatforms`
--

DROP TABLE IF EXISTS `gameplatforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gameplatforms` (
  `game_id` int NOT NULL,
  `platform_id` int NOT NULL,
  PRIMARY KEY (`game_id`,`platform_id`),
  KEY `platform_id` (`platform_id`),
  CONSTRAINT `gameplatforms_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  CONSTRAINT `gameplatforms_ibfk_2` FOREIGN KEY (`platform_id`) REFERENCES `platforms` (`idPlatform`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gameplatforms`
--

LOCK TABLES `gameplatforms` WRITE;
/*!40000 ALTER TABLE `gameplatforms` DISABLE KEYS */;
INSERT INTO `gameplatforms` VALUES (1138,3),(1152,3),(1157,3),(1163,3),(1174,3),(1199,3),(1209,3),(1210,3),(1155,4),(1138,6),(1139,6),(1140,6),(1143,6),(1145,6),(1150,6),(1152,6),(1156,6),(1157,6),(1159,6),(1163,6),(1164,6),(1165,6),(1166,6),(1168,6),(1169,6),(1170,6),(1172,6),(1174,6),(1176,6),(1178,6),(1188,6),(1189,6),(1190,6),(1192,6),(1193,6),(1194,6),(1195,6),(1196,6),(1197,6),(1198,6),(1199,6),(1200,6),(1202,6),(1203,6),(1204,6),(1205,6),(1206,6),(1207,6),(1208,6),(1209,6),(1210,6),(1211,6),(1212,6),(1213,6),(1214,6),(1161,7),(1162,7),(1146,8),(1158,8),(1165,8),(1181,8),(1200,8),(1144,9),(1147,9),(1156,9),(1157,9),(1161,9),(1162,9),(1163,9),(1165,9),(1169,9),(1172,9),(1178,9),(1186,9),(1190,9),(1208,9),(1209,9),(1210,9),(1163,11),(1164,11),(1165,11),(1156,12),(1157,12),(1163,12),(1165,12),(1169,12),(1172,12),(1178,12),(1190,12),(1193,12),(1194,12),(1208,12),(1209,12),(1210,12),(1138,14),(1145,14),(1152,14),(1157,14),(1163,14),(1164,14),(1165,14),(1170,14),(1174,14),(1188,14),(1199,14),(1206,14),(1208,14),(1209,14),(1210,14),(1214,14),(1151,19),(1153,19),(1161,38),(1162,38),(1164,39),(1165,39),(1170,39),(1204,39),(1209,46),(1139,48),(1140,48),(1141,48),(1143,48),(1147,48),(1150,48),(1152,48),(1154,48),(1159,48),(1160,48),(1165,48),(1166,48),(1168,48),(1169,48),(1170,48),(1176,48),(1178,48),(1187,48),(1189,48),(1192,48),(1195,48),(1196,48),(1199,48),(1200,48),(1204,48),(1205,48),(1206,48),(1209,48),(1210,48),(1139,49),(1140,49),(1143,49),(1152,49),(1168,49),(1169,49),(1170,49),(1176,49),(1178,49),(1189,49),(1192,49),(1195,49),(1196,49),(1199,49),(1204,49),(1205,49),(1206,49),(1208,49),(1209,49),(1210,49),(1139,130),(1148,130),(1152,130),(1157,130),(1164,130),(1170,130),(1179,130),(1189,130),(1192,130),(1196,130),(1199,130),(1204,130),(1206,130),(1208,130),(1209,130),(1210,130),(1138,167),(1139,167),(1140,167),(1152,167),(1159,167),(1170,167),(1187,167),(1189,167),(1196,167),(1197,167),(1205,167),(1206,167),(1138,169),(1139,169),(1140,169),(1152,169),(1170,169),(1189,169),(1197,169),(1205,169),(1206,169),(1207,169),(1140,508),(1152,508),(1179,508);
/*!40000 ALTER TABLE `gameplatforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gameratings`
--

DROP TABLE IF EXISTS `gameratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gameratings` (
  `idGameRating` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL COMMENT 'внешний ключ на игру',
  `user_id` int NOT NULL COMMENT 'внешний ключ на пользователя',
  `overall_score` decimal(3,1) NOT NULL,
  `gameplay` int DEFAULT '0',
  `graphics` int DEFAULT '0',
  `story` int DEFAULT '0',
  `music` int DEFAULT '0',
  `atmosphere` int NOT NULL DEFAULT '0',
  `optimization` int NOT NULL DEFAULT '0',
  `innovation` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idGameRating`),
  UNIQUE KEY `unique_user_game_rating` (`user_id`,`game_id`),
  KEY `fk_game_ratings_game` (`game_id`),
  CONSTRAINT `fk_game_ratings_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  CONSTRAINT `fk_game_ratings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gameratings`
--

LOCK TABLES `gameratings` WRITE;
/*!40000 ALTER TABLE `gameratings` DISABLE KEYS */;
INSERT INTO `gameratings` VALUES (50,1146,34,5.8,5,7,NULL,NULL,4,8,5,'2026-05-19 23:15:20'),(51,1153,34,5.0,0,0,0,0,0,0,0,'2026-05-19 23:40:56'),(55,1192,34,4.4,3,4,3,6,7,5,3,'2026-05-20 19:50:05'),(56,1193,34,6.2,5,6,8,NULL,7,6,5,'2026-05-20 19:57:38'),(57,1194,34,5.0,0,0,0,0,0,0,0,'2026-05-20 20:28:48'),(58,1165,34,6.4,8,5,7,8,5,7,5,'2026-05-20 20:41:25'),(59,1195,34,6.3,6,6,7,NULL,7,7,5,'2026-05-20 21:03:40'),(60,1139,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:27'),(61,1191,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:30'),(62,1152,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:33'),(63,1140,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:36'),(64,1190,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:38'),(65,1159,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:43'),(66,1143,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:45'),(67,1141,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:48'),(68,1174,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:51'),(69,1154,34,2.0,0,0,0,0,0,0,0,'2026-05-20 21:13:54'),(70,1196,34,7.5,8,6,NULL,7,8,10,6,'2026-05-20 21:27:20'),(71,1198,34,4.0,0,0,0,0,0,0,0,'2026-05-20 22:01:09'),(72,1199,34,5.0,0,0,0,0,0,0,0,'2026-05-20 22:06:48'),(73,1200,34,7.0,0,0,0,0,0,0,0,'2026-05-20 22:09:50'),(74,1202,34,2.0,0,0,0,0,0,0,0,'2026-05-20 22:13:58'),(75,1203,34,5.0,0,0,0,0,0,0,0,'2026-05-20 22:27:08'),(76,1193,33,7.0,0,0,0,0,0,0,0,'2026-05-21 10:07:32'),(77,1196,33,7.0,0,0,0,0,0,0,0,'2026-05-21 10:08:29'),(78,1198,33,5.0,0,0,0,0,0,0,0,'2026-05-21 10:08:44'),(79,1204,34,5.8,4,5,NULL,6,7,10,3,'2026-05-21 10:49:22'),(80,1205,34,6.4,7,7,NULL,NULL,6,7,5,'2026-05-21 11:27:48'),(81,1206,34,4.0,0,0,0,0,0,0,0,'2026-05-21 11:38:26'),(82,1207,34,7.3,6,7,NULL,8,7,10,6,'2026-05-21 11:48:40'),(83,1208,34,7.0,8,6,5,NULL,7,8,8,'2026-05-21 12:03:50'),(84,1209,34,7.5,9,7,6,NULL,8,8,7,'2026-05-21 12:31:36'),(85,1210,34,5.0,0,0,0,0,0,0,0,'2026-05-21 12:46:35');
/*!40000 ALTER TABLE `gameratings` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_game_rating_insert` AFTER INSERT ON `gameratings` FOR EACH ROW BEGIN
  UPDATE Games g JOIN (
    SELECT game_id, ROUND(AVG(overall_score), 1) as avg_rating, COUNT(*) as rating_count
    FROM GameRatings GROUP BY game_id HAVING game_id = NEW.game_id
  ) r ON g.idGame = r.game_id
  SET g.rating_overall = COALESCE(r.avg_rating, 0.0),
      g.rating_counter = COALESCE(r.rating_count, 0);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_game_rating_update` AFTER UPDATE ON `gameratings` FOR EACH ROW BEGIN
  UPDATE Games g JOIN (
    SELECT game_id, ROUND(AVG(overall_score), 1) as avg_rating, COUNT(*) as rating_count
    FROM GameRatings GROUP BY game_id HAVING game_id = NEW.game_id
  ) r ON g.idGame = r.game_id
  SET g.rating_overall = COALESCE(r.avg_rating, 0.0),
      g.rating_counter = COALESCE(r.rating_count, 0);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_game_rating_delete` AFTER DELETE ON `gameratings` FOR EACH ROW BEGIN
  UPDATE Games g JOIN (
    SELECT game_id, ROUND(AVG(overall_score), 1) as avg_rating, COUNT(*) as rating_count
    FROM GameRatings GROUP BY game_id HAVING game_id = OLD.game_id
  ) r ON g.idGame = r.game_id
  SET g.rating_overall = COALESCE(r.avg_rating, 0.0),
      g.rating_counter = COALESCE(r.rating_count, 0)
  WHERE g.idGame = OLD.game_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `gamerequests`
--

DROP TABLE IF EXISTS `gamerequests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gamerequests` (
  `idRequest` int NOT NULL AUTO_INCREMENT,
  `nameGame` varchar(255) NOT NULL,
  `store_url` varchar(255) NOT NULL,
  `cover_url` varchar(500) NOT NULL,
  `baner_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` varchar(45) NOT NULL DEFAULT 'pending',
  `user_id` int NOT NULL COMMENT 'Кто запросил',
  `moderator_id` int DEFAULT NULL COMMENT 'Кто обрабатывал',
  `notes` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idRequest`),
  KEY `fk_GameRequests_user_id` (`user_id`),
  CONSTRAINT `fk_GameRequests_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gamerequests`
--

LOCK TABLES `gamerequests` WRITE;
/*!40000 ALTER TABLE `gamerequests` DISABLE KEYS */;
/*!40000 ALTER TABLE `gamerequests` ENABLE KEYS */;
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
  `developer` varchar(90) DEFAULT NULL,
  `publisher` varchar(90) DEFAULT NULL,
  `status` varchar(45) NOT NULL DEFAULT 'released',
  `release_date` date DEFAULT NULL,
  `trailer_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cover_url` varchar(500) NOT NULL,
  `banner` varchar(500) DEFAULT NULL,
  `sort_order` int DEFAULT NULL,
  PRIMARY KEY (`idGame`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `cover_id` (`cover_url`),
  UNIQUE KEY `trailer_id` (`trailer_url`),
  UNIQUE KEY `uniq_igdbid` (`igdb_id`),
  UNIQUE KEY `uniq_steamid` (`steam_id`),
  KEY `idx_game_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
INSERT INTO `games` VALUES (1138,119171,1086940,'Baldur\'s Gate III','Соберите отряд и вернитесь в Забытые Королевства. Вас ждет история о дружбе и предательстве, выживании и самопожертвовании, о сладком зове абсолютной власти.',0.0,0,'Wushu Studios','Anshar Studios','Вышла','2023-08-03','https://steamcdn-a.akamaihd.net/steam/apps/256961600/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co670h.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1086940/library_hero.jpg',NULL),(1139,1942,292030,'The Witcher 3: Wild Hunt','Вы — Геральт из Ривии, наемный убийца чудовищ. Вы путешествуете по миру, в котором бушует война и на каждом шагу подстерегают чудовища. Вам предстоит выполнить заказ и найти Цири — Дитя Предназначения, живое оружие, способное изменить облик этого мира.',2.0,1,'WB Games','cdp.pl','Вышла','2015-05-19','https://steamcdn-a.akamaihd.net/steam/apps/2039385/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/coaarl.jpg','https://steamcdn-a.akamaihd.net/steam/apps/292030/library_hero.jpg',NULL),(1140,119133,1245620,'Elden Ring','НОВЫЙ ФЭНТЕЗИЙНЫЙ РОЛЕВОЙ БОЕВИК. Восстань, погасшая душа! Междуземье ждёт своего повелителя. Пусть благодать приведёт тебя к Кольцу Элден.',2.0,1,'Bandai Namco Entertainment','FromSoftware','Вышла','2022-02-25','https://steamcdn-a.akamaihd.net/steam/apps/257002650/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co4jni.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1245620/library_hero.jpg',NULL),(1141,6036,NULL,'The Last of Us Remastered',NULL,2.0,1,'Naughty Dog','Sony Computer Entertainment','Вышла','2014-07-26',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co5zks.jpg',NULL,NULL),(1143,25076,1174180,'Red Dead Redemption 2','Артур Морган и другие подручные Датча ван дер Линде вынуждены пуститься в бега. Их преследуют федеральные агенты и охотники за головами. Чтобы выжить, банде придется участвовать в кражах, грабежах и перестрелках в самом сердце Америки.',2.0,1,'Take-Two Interactive','Rockstar Games','Вышла','2018-10-26','https://steamcdn-a.akamaihd.net/steam/apps/256767979/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1q1f.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1174180/library_hero.jpg',NULL),(1144,1009,2531310,'The Last of Us','Погрузитесь в мир игры, удостоенной более 300 наград «Игра года»: теперь и на ПК! Окунитесь в историю Элли и Эбби с обновленной графикой, новыми игровыми режимами (например, «Без возврата» в стиле «роглайк») и другими улучшениями.',0.0,0,'Naughty Dog','Sony Computer Entertainment','Вышла','2013-06-14','https://steamcdn-a.akamaihd.net/steam/apps/257121063/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1r7f.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2531310/library_hero.jpg',NULL),(1145,26472,632470,'Disco Elysium','Disco Elysium - The Final Cut — революция в жанре РПГ. Ваш персонаж — детектив с уникальными навыками, которому предстоит исследовать целый район. Допрашивайте персонажей, расследуйте убийства или берите взятки. Кем вы станете: героем или неудачником?',0.0,0,'ZA/UM','The Knights of Unity','Вышла','2019-10-15','https://steamcdn-a.akamaihd.net/steam/apps/256827872/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1sfj.jpg','https://steamcdn-a.akamaihd.net/steam/apps/632470/library_hero.jpg',NULL),(1146,379,2131650,'Metal Gear Solid 3: Snake Eater','Metal Gear Solid 3: Snake Eater — пятая по счету игра из серии METAL GEAR, где раскрывается оригинальная история персонажа Naked Snake и его наставника The Boss.',5.8,1,'Konami Computer Entertainment Japan','Konami','Вышла','2004-11-17','https://steamcdn-a.akamaihd.net/steam/apps/256979303/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co5ei5.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2131650/library_hero.jpg',NULL),(1147,9927,1687950,'Persona 5','Возглавьте отряд Призрачных Похитителей в красивой, отмеченной наградами пошаговой ролевой игре. Исследуйте подземелья, обдумывайте стратегию боя и проводите слияние персон. Живите в Токио, сражайтесь с тенями, проникайте в головы бесчестных негодяев и меняйте мир к лучшему!',0.0,0,'Atlus','P Studio','Вышла','2016-09-15','https://steamcdn-a.akamaihd.net/steam/apps/256911919/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1r76.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1687950/library_hero.jpg',NULL),(1148,7346,NULL,'The Legend of Zelda: Breath of the Wild',NULL,0.0,0,'Monolith Soft','Nintendo','Вышла','2017-03-03',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co3p2d.jpg',NULL,NULL),(1150,19560,1593500,'God of War','Отомстив богам Олимпа, Кратос живет в царстве скандинавских божеств и чудовищ. В этом суровом беспощадном мире он должен не только самостоятельно бороться за выживание... но и научить этому сына.',0.0,0,'Sony Interactive Entertainment','SIE Santa Monica Studio','Вышла','2018-04-20',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/cobkt6.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1593500/library_hero.jpg',NULL),(1151,1026,NULL,'The Legend of Zelda: A Link to the Past',NULL,0.0,0,'St. GIGA','Nintendo Entertainment Analysis & Development','Вышла','1991-11-21',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co3vzn.jpg',NULL,NULL),(1152,14593,367520,'Hollow Knight','Hollow Knight – это эпическое приключение в огромном разрушенном королевстве, полном насекомых и героев. Исследуйте извилистые пещеры, сражайтесь с порчеными тварями и заводите дружбу со странными жуками – все это в классической двухмерной ручной рисовке.',2.0,1,'Team Cherry',NULL,'Вышла','2017-02-24',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/cobfzp.jpg','https://steamcdn-a.akamaihd.net/steam/apps/367520/library_hero.jpg',NULL),(1153,1070,NULL,'Super Mario World',NULL,5.0,1,'Nintendo Entertainment Analysis & Development','Nintendo','Вышла','1990-11-21',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co8lo8.jpg',NULL,NULL),(1154,7334,NULL,'Bloodborne',NULL,2.0,1,'FromSoftware','Sony Computer Entertainment','Вышла','2015-03-24',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/cob99l.jpg',NULL,NULL),(1155,1029,NULL,'The Legend of Zelda: Ocarina of Time',NULL,0.0,0,'Nintendo Entertainment Analysis & Development','Nintendo','Бета','1998-11-21',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co3nnx.jpg',NULL,NULL),(1156,74,2362420,'Mass Effect 2','Вы готовы потерять все, чтобы спасти галактику? Вы должны быть готовы, капитан Шепард. Пришло время собрать самых сильных союзников и заручиться помощью лучших бойцов галактики, чтобы дать отпор Жнецам.',0.0,0,'Electronic Arts','BioWare','Вышла','2010-01-26','https://steamcdn-a.akamaihd.net/steam/apps/256946706/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co20ac.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2362420/library_hero.jpg',NULL),(1157,72,620,'Portal 2','Программа вечного тестирования расширена: создавайте совместные головоломки для себя и друзей!',0.0,0,'Valve','Electronic Arts','Вышла','2011-04-18','https://steamcdn-a.akamaihd.net/steam/apps/80788/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1rs4.jpg','https://steamcdn-a.akamaihd.net/steam/apps/620/library_hero.jpg',NULL),(1158,481,2124490,'Silent Hill 2','Письмо покойной жены привело Джеймса в Сайлент Хилл – место, с которым связано множество воспоминаний. Его встречает окутанный туманом город-призрак, по которому бродят жуткие монстры. Сражайтесь с монстрами, решайте головоломки и ищите следы жены Джеймса в ремейке SILENT HILL 2.',0.0,0,'Team Silent','Konami','Вышла','2001-09-24','https://steamcdn-a.akamaihd.net/steam/apps/257026897/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2vyg.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2124490/library_hero.jpg',NULL),(1159,112875,2322010,'God of War Ragnarök','Кратос и Атрей отправляются на поиски ответов в преддверии неотвратимо надвигающегося Рагнарёка. Теперь игра доступна и на PC.',2.0,1,'Sony Interactive Entertainment','SIE Santa Monica Studio','Вышла','2022-11-08','https://steamcdn-a.akamaihd.net/steam/apps/257054534/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/coba3d.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2322010/library_hero.jpg',3),(1160,7331,NULL,'Uncharted 4: A Thief\'s End',NULL,0.0,0,'Naughty Dog','Sony Interactive Entertainment','Вышла','2016-05-10',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1r7h.jpg',NULL,NULL),(1161,375,2417610,'Metal Gear Solid','Римейк выпущенной в 2004 году игры METAL GEAR SOLID 3: SNAKE EATER. Та же захватывающая история и увлекательный мир, но с абсолютно новой графикой и трёхмерным звуком, которые ещё лучше передают атмосферу джунглей. Вас ждёт невероятное сочетание выживания, экшена и стелса.',0.0,0,'Konami Computer Entertainment Japan','Konami','Вышла','1998-09-03','https://steamcdn-a.akamaihd.net/steam/apps/257150826/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/cobpak.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2417610/library_hero.jpg',NULL),(1162,427,3837340,'Final Fantasy VII','Обожаемый поколениями фанатов шедевр FINAL FANTASY VII выходит в Steam® с рядом новых особенностей! Эпическое приключение невообразимого масштаба и битва за судьбу планеты возвращается.',0.0,0,'Square Product Development Division 1','Square Enix','Вышла','1997-09-07','https://steamcdn-a.akamaihd.net/steam/apps/257282518/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2kx2.jpg','https://steamcdn-a.akamaihd.net/steam/apps/3837340/library_hero.jpg',NULL),(1163,233,220,'Half-Life 2','Гордон Фримен вновь пробуждается в оккупированном центре Сити-17 и возглавляет отчаянное сопротивление против Альянса. К нему присоединяется Аликс Вэнс. Сыграйте в этот эпохальный шутер от первого лица с беспрецедентной физикой, обеспечивающей невероятный уровень погружения, и головокружительными сражениями.',0.0,0,'Valve','NVIDIA Lightspeed Studios','Вышла','2004-11-16',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1nmw.jpg','https://steamcdn-a.akamaihd.net/steam/apps/220/library_hero.jpg',NULL),(1164,116,32370,'Star Wars: Knights of the Old Republic','It is four thousand years before the Galactic Empire and hundreds of Jedi Knights have fallen in battle against the ruthless Sith. You are the last hope of the Jedi Order. Can you master the awesome power of the Force on your quest to save the Republic? Or will you fall to the lure of the dark side?',0.0,0,'LucasArts','Activision','Вышла','2003-07-15','https://steamcdn-a.akamaihd.net/steam/apps/256671298/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1tmz.jpg','https://steamcdn-a.akamaihd.net/steam/apps/32370/library_hero.jpg',NULL),(1165,732,1547000,'Grand Theft Auto: San Andreas','Grand Theft Auto: San Andreas: на дворе – начало 90-х. После того как пара копов повесила на него убийство, которого он не совершал, Карл «Си-Джей» Джонсон должен отправиться в путешествие, чтобы обезопасить близких и установить контроль над улицами штата Сан-Андреас.',6.4,1,'Rockstar North','Take-Two Interactive','Вышла','2026-10-24',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2lb9.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1547000/library_hero.jpg',1),(1166,11208,524220,'NieR: Automata','NieR: Automata tells the story of androids 2B, 9S and A2 and their battle to reclaim the machine-driven dystopia overrun by powerful machines.',1.0,1,'PlatinumGames','Square Enix','Вышла','2017-02-23','https://steamcdn-a.akamaihd.net/steam/apps/257127027/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co5pcj.jpg','https://steamcdn-a.akamaihd.net/steam/apps/524220/library_hero.jpg',NULL),(1167,26192,NULL,'The Last of Us Part II',NULL,0.0,0,'Sony Interactive Entertainment','Naughty Dog','Вышла','2020-06-19',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co5ziw.jpg',NULL,NULL),(1168,76882,814380,'Sekiro: Shadows Die Twice','Игра года - The Game Awards 2019 Лучший боевик 2019 г. - IGN Составляйте и воплощайте собственные планы мести в удостоенном множества наград боевике от студии FromSoftware, создавшей Bloodborne и серию Dark Souls. Отомстите врагам. Верните свою честь. Освойте искусство убивать.',0.0,0,'Activision','FromSoftware','Вышла','2019-03-22','https://steamcdn-a.akamaihd.net/steam/apps/256745700/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2a23.jpg','https://steamcdn-a.akamaihd.net/steam/apps/814380/library_hero.jpg',NULL),(1169,1020,3240220,'Grand Theft Auto V','Погрузитесь в хиты – Grand Theft Auto V и Grand Theft Auto Online – улучшенные для нового поколения. Потрясающая графика, ускоренная загрузка, 3D-звук и многое другое, а также эксклюзивные материалы для игроков GTA Online.',0.0,0,'Take-Two Interactive','Rockstar Games','Вышла','2013-09-17',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2lbd.jpg','https://steamcdn-a.akamaihd.net/steam/apps/3240220/library_hero.jpg',NULL),(1170,113112,1145360,'Hades','Бросьте вызов богу мёртвых и прорубите себе путь из Подземного мира в игре в жанрах «рогалик» и «данжен-кроулер» от создателей Bastion, Transistor и Pyre.',0.0,0,'Supergiant Games','Netflix','Вышла','2020-09-17','https://steamcdn-a.akamaihd.net/steam/apps/256801288/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/cob9kr.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1145360/library_hero.jpg',NULL),(1172,434,2668510,'Red Dead Redemption','Игра-предшественница знаменитой Red Dead Redemption 2 впервые стала доступна на PC. В ней вам предстоит прожить историю бывшего бандита Джона Марстона, который пытается выследить уцелевших членов банды Ван дер Линде.',0.0,0,'Rockstar Games','Rockstar North','Вышла','2010-05-18',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2lcv.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2668510/library_hero.jpg',NULL),(1174,2963,570,'Dota 2','Ежедневно миллионы игроков по всему миру сражаются от лица одного из более сотни героев Dota 2, и даже после тысячи часов в ней есть чему научиться. Благодаря регулярным обновлениям игра живёт своей жизнью: геймплей, возможности и герои постоянно преображаются.',2.0,1,'Valve',NULL,'Вышла','2013-07-09',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/cobfk4.jpg','https://steamcdn-a.akamaihd.net/steam/apps/570/library_hero.jpg',NULL),(1175,80,NULL,'The Witcher',NULL,0.0,0,'CD Projekt RED','Atari, Inc.','Вышла','2007-10-26',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1xrx.jpg',NULL,NULL),(1176,11118,403640,'Dishonored 2','В игре Dishonored 2, вы снова окажетесь в роли ассасина со сверхъестественными способностями. Сайт IGN назвал эту игру «удивительной» и «идеальным продолжением», Eurogamer признал ее «шедевром», а Game Informer считает, что «эта история о мести – одна из лучших в своем жанре и проходить мимо нее ни в коем случае нельзя»; Dishonored 2 –...',0.0,0,'Arkane Studios','Bethesda Softworks','Вышла','2016-11-10','https://steamcdn-a.akamaihd.net/steam/apps/256669327/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co9e29.jpg','https://steamcdn-a.akamaihd.net/steam/apps/403640/library_hero.jpg',2),(1178,2988,115320,'Prototype 2','Станьте идеальным оружием-метаморфом!',0.0,0,'Activision','Radical Entertainment','Вышла','2012-04-24',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co20jt.jpg','https://steamcdn-a.akamaihd.net/steam/apps/115320/library_hero.jpg',NULL),(1179,26758,NULL,'Super Mario Odyssey',NULL,0.0,0,'Nintendo','1-UP Studio','Вышла','2017-10-27',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1mxf.jpg',NULL,NULL),(1181,376,2131640,'Metal Gear Solid 2: Sons of Liberty','Четвертый проект серии METAL GEAR с новым геймплеем. Сюжет разворачивается вокруг происшествий в 2007 и 2009 годах и повествует о двух героях — Solid Snake и Raiden.',0.0,0,'Konami','Konami Computer Entertainment Japan','Вышла','2001-11-13','https://steamcdn-a.akamaihd.net/steam/apps/256979298/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co5e1c.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2131640/library_hero.jpg',NULL),(1186,565,NULL,'Uncharted 2: Among Thieves',NULL,0.0,0,'Naughty Dog','Sony Computer Entertainment','Вышла','2009-10-13',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1tnb.jpg',NULL,NULL),(1187,75235,2215430,'Ghost of Tsushima','Грядёт великий шторм. Пройдите весь путь Призрака в полной режиссёрской версии игры «Призрак Цусимы» на ПК. Приключенческий боевик в открытом мире предлагает вам увидеть все чудеса острова. Над игрой работали Sucker Punch Productions, Nixxes Software и PlayStation Studios.',0.0,0,'Sony Interactive Entertainment','Sucker Punch Productions','Вышла','2020-07-17','https://steamcdn-a.akamaihd.net/steam/apps/257022043/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2crj.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2215430/library_hero.jpg',NULL),(1188,126,2536520,'Diablo II','Классика экшен-RPG в жанре мрачного фэнтези вернулась в обновленной версии: вас ждут новый класс, усовершенствования игрового процесса и переработанный контент на высоких уровнях. Сочетайте мощные умения и предметы, становитесь сильнее и побеждайте армии Преисподней в команде до 8 игроков.',0.0,0,'Blizzard North','Blizzard Entertainment','Вышла','2000-06-29','https://steamcdn-a.akamaihd.net/steam/apps/257273203/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co3gfq.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2536520/library_hero.jpg',NULL),(1189,135243,1426210,'It Takes Two','Отправьтесь в самое безумное путешествие в жизни в игре It Takes Two. Пригласите друга присоединиться бесплатно благодаря версии для друга*, радостно преодолевая многочисленные испытания.',0.0,0,'Electronic Arts','Hazelight Studios','Вышла','2021-03-25',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/cob22v.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1426210/library_hero.jpg',NULL),(1190,533,205100,'Dishonored','Dishonored is an immersive first-person action game that casts you as a supernatural assassin driven by revenge. With Dishonored’s flexible combat system, creatively eliminate your targets as you combine the supernatural abilities, weapons and unusual gadgets at your disposal.',2.0,1,'Arkane Studios','Bethesda Softworks','Вышла','2012-10-09',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/coabgu.jpg','https://steamcdn-a.akamaihd.net/steam/apps/205100/library_hero.jpg',NULL),(1191,372563,1030300,'Hollow Knight Silksong','Исследуйте огромное проклятое царство в Hollow Knight: Silksong! Открывайте его тайны, сражайтесь и боритесь за свою жизнь, поднимаясь к вершинам земель, где правят шёлк и песня.',2.0,1,'Elvies',NULL,'Вышла','2021-07-28',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/coaob9.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1030300/library_hero.jpg',NULL),(1192,7352,384190,'Abzu','ABZÛ — это красочное приключение в подводном мире от создателей Journey®, где вам предстоит заниматься дайвингом. Погрузитесь в живописный мир океана, полный загадок и ярких красок. Но будьте осторожны, в морских пучинах вас ждет опасность.',4.4,1,'505 Games','Giant Squid','Вышла','2016-08-02',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co28sy.jpg','https://steamcdn-a.akamaihd.net/steam/apps/384190/library_hero.jpg',NULL),(1193,1062,108710,'Alan Wake','A Dark Presence stalks the small town of Bright Falls, pushing Alan Wake to the brink of sanity in his fight to unravel the mystery and save his love.',6.6,2,'E-Frontier','Legacy Interactive','Вышла','2010-05-13',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2dft.jpg','https://steamcdn-a.akamaihd.net/steam/apps/108710/library_hero.jpg',NULL),(1194,NULL,NULL,'Alan Wake\'s American Nightmare','Писатель вновь оказывается в ловушке Темного Места, которое на этот раз переносит его в вымышленный городок Найт-Спрингс посреди пустыни Аризоны . Алан вынужден противостоять своему самому страшному врагу — темному двойнику мистеру Скрэтчу (Mr. Scratch), который жаждет выбраться в реальный мир. Чтобы выбраться из замкнутого круга, главному герою предстоит не только использовать привычную силу света против порождений тьмы, но и научиться управлять самой реальностью, проходя через повторяющуюся временную петлю',5.0,1,'Remedy Entertainment','Microsoft Game Studios','Вышла','2012-02-22',NULL,'games/covers/1779308674938-lk2q1uto4.jpeg','games/banners/1779308674956-g9pl3pqlw.jpg',NULL),(1195,36897,1222700,'A Way Out','A Way Out - это уникальное коллективное приключение, где вы играете за одного из двух заключенных, затеявших побег из тюрьмы.',6.3,1,'Hazelight Studios','Electronic Arts','Вышла','2018-03-23','https://steamcdn-a.akamaihd.net/steam/apps/256790157/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1vca.jpg','https://steamcdn-a.akamaihd.net/steam/apps/1222700/library_hero.jpg',NULL),(1196,13205,361420,'Astroneer','Меняйте новые странные миры и лепите их, как глину. Постройте базу, освойте управление ресурсами, автоматизируйте производственные линии и разгадайте тайны вселенной в одиночку или с друзьями.',7.3,2,'System Era Softworks','System Era Softworks','Вышла','2019-02-06',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/cobyfe.jpg','https://steamcdn-a.akamaihd.net/steam/apps/361420/library_hero.jpg',NULL),(1197,219126,427410,'Abiotic Factor','Совместная игра на выживание с созданием предметов (для 1–6 игроков) в исследовательском центре, наводнили паранормальные угрозы. Вы — величайшие ученые Земли, и вам придется трудиться сообща, создавая гениальные устройства и оружие, чтобы выжить единственным известным вам способом: убивая наукой!',0.0,0,'Deep Field Games','Playstack','Вышла','2025-07-22','https://steamcdn-a.akamaihd.net/steam/apps/257172169/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co85d2.jpg','https://steamcdn-a.akamaihd.net/steam/apps/427410/library_hero.jpg',NULL),(1198,NULL,NULL,'Armed Forces Corp','Armed Forces Corp — это динамичный шутер от первого лица, выпущенный польской студией City Interactive. Вы — член высококвалифицированной и хорошо вооруженной группы наемников под названием «Вооруженный отряд». Ваша задача — проникнуть в небоскреб, захваченный хорошо организованными террористами, и извлечь ценную информацию.',4.5,2,'City Interactive (CI Games)','City Interactive (CI Games)','Вышла','2009-02-27',NULL,'games/covers/1779314365767-0u3a8s5u6.jpg',NULL,NULL),(1199,111,57300,'Amnesia: The Dark Descent','Amnesia: The Dark Descent — хоррор на выживание от первого лица. Игра о погружении, открытиях и преодолении кошмара. Впечатления, которые проберут вас до глубины души.',5.0,1,'Frictional Games','Frictional Games','Вышла','2010-09-08',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1qq5.jpg','https://steamcdn-a.akamaihd.net/steam/apps/57300/library_hero.jpg',NULL),(1200,2720,12200,'Bully','Bully рассказывает историю озорного 15-летнего Джимми Хопкинса, который проходит через всю смехоту и неловкость подросткового возраста. Побеждайте спортсменов в вышибалы, разыгрывайте мажоров, спасайте ботанов, целуйте девчонок и прокладывайте себе путь в социальной иерархии в самой ужасной школе на свете.',7.0,1,'Take-Two Interactive','Rockstar New England','Вышла','2006-10-17',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2lc9.jpg','https://steamcdn-a.akamaihd.net/steam/apps/12200/library_hero.jpg',NULL),(1202,NULL,NULL,'Buried','Вы очнулись в гробу заживо. Кислород на исходе, и вы не помните, как здесь оказались. Должен быть выход, сможете ли вы найти его вовремя?',2.0,1,'Authogin','Authogin','Вышла','2023-09-30',NULL,'games/covers/1779315228938-mu3wiq983.jpg','games/banners/1779315314184-hoi76qwy8.jpg',NULL),(1203,NULL,NULL,'BIGFOOT','Вы — охотник на снежного человека, и перед вами стоит важная задача: раз и навсегда положить конец слухам и доказать себе, что снежный человек — это не просто миф или плод воображения...',5.0,1,'CyberLight Game Studio','CyberLight Game Studio','Вышла','2017-12-31',NULL,'games/covers/1779315958725-3fooc35pb.jpg','games/banners/1779315882146-msc9n5r5o.jpg',NULL),(1204,103373,883360,'Beyond Blue','Beyond Blue — это однопользовательская игра в стиле приключенческого повествования, в которой мы оказываемся в пульсирующем голубом сердце нашей планеты. Узнайте, какие чудеса и тайны скрыты в мировом океане.',5.8,1,'E-Line Media','E-Line Media.','Вышла','2020-04-17','https://steamcdn-a.akamaihd.net/steam/apps/256782870/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co292r.jpg','https://steamcdn-a.akamaihd.net/steam/apps/883360/library_hero.jpg',NULL),(1205,116200,924970,'Back 4 Blood','Back 4 Blood – это захватывающий кооперативный шутер от первого лица от создателей признанной критиками франшизы Left 4 Dead.',6.4,1,'Warner Bros. Interactive Entertainment','Turtle Rock Studios','Вышла','2021-10-12','https://steamcdn-a.akamaihd.net/steam/apps/256838462/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2mhj.jpg','https://steamcdn-a.akamaihd.net/steam/apps/924970/library_hero.jpg',NULL),(1206,204524,NULL,'Bread & Fred',NULL,4.0,1,'SandCastles Studio','Apogee Entertainment','Вышла','2023-05-23',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co88n4.jpg',NULL,NULL),(1207,288941,2835570,'Buckshot Roulette','Сыграйте в русскую рулетку с дробовиком 12-го калибра. Играют четверо. Остается один. Поставьте на кон свою жизнь. Удачи.',7.3,1,'Mike Klubnika','CRITICAL REFLEX','Вышла','2024-07-04',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co857l.jpg','https://steamcdn-a.akamaihd.net/steam/apps/2835570/library_hero.jpg',NULL),(1208,498,1285190,'Borderlands','Приготовьтесь к умопомрачительному безумию! Играйте за одного из четырех кровожадных наемников и уничтожайте все, что встанет у вас на пути! Borderlands — это захватывающий экшен, безумные бои от первого лица, огромный арсенал оружия, элементы ролевой игры и кооперативный режим для четырех игроков. Это прорывная игра, которая бросает вызов',7.0,1,'2K Games','CyberFront','Вышла','2009-10-20',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co20tx.jpg','games/banners/1779364675232-otsaccjrx.jpg',NULL),(1209,1011,49520,'Borderlands 2','С момента событий первой части прошло пять лет. Планета Пандора больше не пустынная свалка — теперь здесь хозяйничает корпорация «Гиперион» во главе с харизматичным психом по прозвищу Красавчик Джек. Он присвоил себе заслуги охотников за Хранилищем, объявил себя диктатором планеты и начал кампанию по уничтожению местного населения.\r\n\r\nВы — один из новых охотников за Хранилищем, попавший в ловушку Джека с самого начала игры. Вам предстоит объединиться с другими искателями приключений, найти старых героев первой части и положить конец тирании Красавчика Джека',7.5,1,'Gearbox Software','2K Games','Вышла','2012-09-18',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co9ba3.jpg','https://steamcdn-a.akamaihd.net/steam/apps/49520/library_hero.jpg',NULL),(1210,6032,261640,'Borderlands: The Pre-Sequel','Launch into the Borderlands universe and shoot ‘n’ loot your way through a brand new adventure that rockets you onto Pandora’s moon in Borderlands: The Pre-Sequel!',5.0,1,'2K Australia','Gearbox Software','Вышла','2014-10-14','https://steamcdn-a.akamaihd.net/steam/apps/2035009/movie_max.mp4','https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co20tq.jpg','https://steamcdn-a.akamaihd.net/steam/apps/261640/library_hero.jpg',NULL),(1211,240,NULL,'Battlefield 1942','Шутер, действие которого разворачивается во время Второй Мировой Войны. Игра содержит более 50 различный миссий: от бомбардировки Европы до десантной высадки на побережье Японии.Игра удивительно кинематографична, просто наблюдать за сражениями в BF уже огромное удовольствие. Играя в BF после CS просто радуешься сочным текстурам, детализированным моделям игроков, огромным открытым пространствам, замечательным моделям бронетехники.BF является замечательно синефильским, удивительно динамичным сетевым шутером, с успехом конкурирующим с грандами жанра. Он прост, красив и изящен.',4.0,1,'Aspyr Media','Electronic Arts','Вышла','2002-09-10',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1xb2.jpg',NULL,NULL),(1212,335,NULL,'Battlefield Vietnam','Новая итерация многопользовательсткого шутера от создателей неоклассики жанра - Battlefield 1942.На этот раз нас отправляют на свирепую войну во Вьетнаме, где нам предстоит выбрать одну из двух хорошо оснащенных противоборствующих сторон (Соединенные Штаты или Северная Вьетнамская Армия (NVA)). Игра привлекает опять-таки реальными историческими особенностями и свойствами, где даже оружие и средства передвижения соответствуют подлинникам Вьетнамского конфликта. Основным средством передвижения США был вертолёт, что чётко передается в Battlefield Vietnam. В то время как NVA пользовалась Российской техникой – тяжелым танком T-54 и самолётом Mig-21.',3.0,1,'Electronic Arts','Digital Illusions CE: Canada','Вышла','2004-03-14',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1xb1.jpg',NULL,NULL),(1213,277,NULL,'Battlefield 2','Battlefield возвращается! Глобальный военный экшен переносит игроков в современные конфликты. Освойте небо на сверхзвуковых истребителях, крушите врага на танках или поддерживайте с воздуха с боевых вертолётов. Система прогрессии вознаградит вас званиями, опытом и новым оружием. Главные достоинства — эпические перестрелки на огромных картах, реалистичная графика и удобное управление отрядами.',0.0,0,'Electronic Arts','Digital Illusions CE','Вышла','2005-06-21',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co2nal.jpg',NULL,NULL),(1214,349,NULL,'Battlefield 2142',NULL,0.0,0,'Electronic Arts','EA Digital Illusions CE','Вышла','2006-10-17',NULL,'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/co1xbb.jpg',NULL,NULL);
/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gamethemes`
--

DROP TABLE IF EXISTS `gamethemes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gamethemes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `game_id` int NOT NULL,
  `theme_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_gameTheme` (`game_id`),
  KEY `fk_theme` (`theme_id`),
  CONSTRAINT `fk_gameTheme` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_theme` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`idTheme`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1218 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gamethemes`
--

LOCK TABLES `gamethemes` WRITE;
/*!40000 ALTER TABLE `gamethemes` DISABLE KEYS */;
INSERT INTO `gamethemes` VALUES (930,1138,1),(931,1138,17),(932,1139,1),(933,1139,17),(934,1139,38),(935,1140,1),(936,1140,17),(937,1140,38),(938,1141,1),(939,1141,19),(940,1141,21),(941,1141,23),(945,1143,1),(946,1143,31),(947,1143,38),(948,1144,1),(949,1144,19),(950,1144,21),(951,1144,23),(952,1145,20),(953,1145,31),(954,1145,43),(955,1146,1),(956,1146,17),(957,1146,21),(958,1146,22),(959,1146,23),(960,1146,31),(961,1147,17),(962,1147,27),(963,1147,31),(964,1147,43),(965,1148,1),(966,1148,17),(967,1148,18),(968,1148,33),(969,1148,38),(973,1150,1),(974,1150,17),(975,1150,22),(976,1151,1),(977,1151,17),(978,1152,1),(979,1152,17),(980,1153,1),(981,1153,17),(982,1154,1),(983,1154,17),(984,1154,19),(985,1154,38),(986,1155,1),(987,1155,17),(988,1155,33),(989,1155,38),(990,1156,1),(991,1156,18),(992,1157,1),(993,1157,18),(994,1157,27),(995,1158,19),(996,1158,21),(997,1158,31),(998,1158,43),(1002,1160,1),(1003,1160,17),(1004,1160,22),(1005,1160,23),(1006,1161,1),(1007,1161,18),(1008,1161,21),(1009,1161,23),(1010,1162,17),(1011,1162,18),(1012,1163,1),(1013,1163,18),(1014,1163,19),(1015,1164,1),(1016,1164,18),(1017,1164,23),(1018,1164,38),(1022,1166,1),(1023,1166,17),(1024,1166,18),(1025,1166,31),(1026,1166,38),(1027,1168,1),(1028,1168,17),(1029,1168,22),(1030,1168,23),(1031,1169,1),(1032,1169,27),(1033,1169,33),(1034,1169,38),(1035,1170,1),(1036,1170,17),(1037,1170,31),(1040,1172,1),(1041,1172,33),(1042,1172,38),(1043,1174,1),(1044,1174,17),(1045,1174,39),(1049,1178,1),(1050,1178,18),(1051,1178,19),(1052,1178,21),(1053,1178,33),(1054,1178,38),(1055,1179,1),(1056,1179,17),(1057,1179,33),(1058,1179,38),(1063,1181,1),(1064,1181,23),(1072,1186,1),(1073,1186,17),(1074,1186,22),(1075,1187,1),(1076,1187,22),(1077,1187,23),(1078,1187,31),(1079,1187,38),(1080,1188,1),(1081,1188,17),(1082,1189,1),(1086,1159,1),(1087,1159,17),(1088,1159,38),(1089,1165,38),(1090,1165,23),(1091,1165,1),(1092,1176,1),(1093,1176,23),(1094,1190,1),(1095,1190,23),(1096,1191,1),(1097,1191,17),(1098,1192,1),(1099,1192,17),(1100,1192,34),(1105,1193,1),(1106,1193,19),(1107,1193,20),(1108,1194,1),(1109,1194,19),(1110,1195,1),(1128,1196,18),(1129,1196,21),(1130,1196,33),(1131,1196,38),(1132,1197,1),(1133,1197,18),(1134,1197,21),(1135,1197,33),(1138,1198,1),(1142,1199,19),(1143,1199,21),(1148,1200,1),(1149,1200,27),(1150,1200,38),(1154,1202,19),(1157,1203,1),(1158,1203,19),(1163,1204,1),(1164,1204,35),(1168,1205,19),(1169,1205,1),(1170,1206,1),(1171,1206,40),(1173,1207,19),(1174,1207,1),(1175,1207,20),(1183,1208,1),(1184,1208,18),(1185,1208,38),(1186,1208,27),(1192,1209,1),(1193,1209,18),(1194,1209,27),(1195,1209,38),(1196,1210,1),(1197,1210,18),(1198,1210,27),(1199,1210,38),(1203,1211,1),(1204,1211,22),(1205,1211,39),(1209,1212,1),(1210,1212,22),(1211,1212,39),(1214,1213,1),(1215,1213,39),(1216,1214,1),(1217,1214,18);
/*!40000 ALTER TABLE `gamethemes` ENABLE KEYS */;
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
  `image` varchar(500) NOT NULL,
  `likes_count` int NOT NULL DEFAULT '0',
  `comments_count` int NOT NULL DEFAULT '0',
  `views_count` int NOT NULL DEFAULT '0',
  `category` varchar(45) NOT NULL,
  `publisher_id` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idNew`),
  KEY `publisher_id` (`publisher_id`),
  KEY `idx_news_category_date` (`category`,`created_at` DESC),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`publisher_id`) REFERENCES `users` (`idUser`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (138,'The Witcher 3: Wild Hunt исполнилось 11 лет','CD Project RED поздравили всех со знаменательной датой The Witcher 3','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779208045808-jurnasjp0.webp\" alt=\"\" data-minio-key=\"news/content/1779208045808-jurnasjp0.webp\"><br><p class=\"text-content\">19 мая 2026 года исполнилось 11 лет со дня выхода одной из самых значимых RPG современности - <b>The Witcher 3: Wild Hunt</b> от студии CD Project RED. Официальный аккаунт компании в соцсети <a href=\"https://www.playground.ru/witcher_3_wild_hunt/news/the_witcher_3_wild_hunt_ispolnilos_11_let_cd_project_red_pozdravili_vseh_so_znamenatelnoj_datoj-1845835\">X</a> опубликовал поздравительный пост, посвященный юбилею:</p><br><p class=\"text-content\">\"11 лет сражений с монстрами, путешествий по полям сражений и упорного движения вперёд - путь ведьмака никогда не бывает лёгким. С днём рождения, The Witcher 3: Wild Hunt!\"</p><br><p class=\"text-content\">К посту прикреплен специальный скриншот, созданный виртуальным фотографом Троем Ноланом.</p><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779208166805-0icgse91v.webp\" alt=\"\" data-minio-key=\"news/content/1779208166805-0icgse91v.webp\"></div></div>','news/covers/1779208177213-j7xxu4viy.webp',1,0,5,'Индустрия',34,'2026-05-19 19:29:37'),(139,'Кен Левин объяснил, почему ушёл от BioShock','Создатель серии боялся стать заложником собственной франшизы','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779208545143-v9dsomf3d.webp\" alt=\"\" data-minio-key=\"news/content/1779208545143-v9dsomf3d.webp\"><br><p class=\"text-content\">Для многих игроков имя Кена Левина навсегда связано с <b>BioShock</b> — серией, которая превратила философский immersive sim в один из главных AAA-феноменов 2000-х. Однако сам разработчик признаётся: в какой-то момент он понял, что продолжать держаться за эту вселенную стало опасно не только творчески, но и лично.</p><p class=\"text-content\"><br></p><p class=\"text-content\">В интервью IGN Левин рассказал, почему после закрытия Irrational Games решил оставить BioShock, несмотря на огромный успех франшизы и любовь аудитории. По словам разработчика, проблема была не в усталости от серии и не в потере интереса к миру Восторга и Колумбии. Наоборот — он до сих пор хранит у себя дома огромную фигуру Биг Дэдди и считает BioShock важнейшей частью своей жизни.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Но именно это, как признаётся Левин, его и пугало.</p><p class=\"text-content\"><br></p><p class=\"text-content\">«Франшизы могут завладеть тобой, если слишком крепко за них держаться», — объяснил разработчик. По его словам, было страшно уходить от настолько успешной серии, особенно когда можно было безопасно продолжать выпускать новые части под знакомым брендом. Однако Левин не хотел делать «ещё одну игру BioShock», просто меняя декорации и сохраняя привычную формулу.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Это довольно редкое признание для современной индустрии, где крупные издатели обычно стараются выжимать из известных серий максимум до полного истощения. На фоне бесконечных сиквелов, ремейков и сервисных игр позиция Левина выглядит почти старомодной — автор предпочёл риск творческому комфорту.</p><p class=\"text-content\"><br></p><p class=\"text-content\">При этом сам разработчик признаёт, что полностью уйти от наследия BioShock невозможно. Его новая игра Judas уже по первым трейлерам вызывает у игроков очень знакомые ассоциации: странный ретрофутуризм, философские темы, напряжённые диалоги и ощущение распадающегося мира. Не случайно журналисты уже называют проект «BioShock 4, который нельзя называть BioShock 4».</p><p class=\"text-content\"><br></p><p class=\"text-content\">Сам Левин с этим спорит лишь частично. По его словам, в Judas действительно много «ДНК» прошлых работ студии, но игроки будут удивлены тем, насколько проект отличается от BioShock по структуре и подходу к повествованию.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Особенно интересно звучат его размышления о том, что вообще делает BioShock — BioShock. Левин признался, что даже спустя годы не может дать точного определения серии. Да, есть шутер от первого лица, альтернативная история, философские идеи и знаменитая формула «маяк, человек, город». Но, по его словам, суть франшизы всегда была чем-то большим, чем набор механик и декораций.</p><p class=\"text-content\"><br></p><p class=\"text-content\">И, возможно, именно поэтому уход Левина от серии ощущается одновременно логичным и немного грустным. С одной стороны, BioShock давно заслужил право существовать без своего создателя. С другой — сложно избавиться от ощущения, что именно его одержимость идеями и странными мирами делала эти игры настолько особенными.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Теперь же разработчик пытается доказать главное: он способен создать новую культовую вселенную, а не жить в тени собственного прошлого. И Judas, похоже, станет самым важным тестом в его карьере со времён Infinite.</p>\r\n        </div>','news/covers/1779208592920-b1hlqj1ag.webp',0,0,2,'Индустрия',34,'2026-05-19 19:36:32'),(140,'Донат в Neverness to Everness','Зачем нужны Рифткристаллы и почему о валюте лучше подумать заранее','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779208812666-mtxpabwl5.webp\" alt=\"\" data-minio-key=\"news/content/1779208812666-mtxpabwl5.webp\"><br><p class=\"text-content\">У <a href=\"https://www.playground.ru/neverness_to_everness/guide/donat_v_neverness_to_everness_zachem_nuzhny_riftkristally_i_pochemu_o_valyute_luchshe_podumat_zaranee-1845838\" style=\"\">Neverness to Everness</a> сейчас довольно интересная ситуация. С одной стороны — игра только начинает набирать обороты, а игроки ещё изучают её системы и экономику. С другой — уже видно, что проект явно строится как большая сервисная RPG с регулярными обновлениями, новыми персонажами, транспортом, активностями и крупными баннерами.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Именно поэтому вопрос доната здесь возникает довольно быстро. Причём не в формате «нужно ли платить, чтобы играть», а скорее: как не оказаться без валюты в момент, когда игра начнёт активно подбрасывать действительно интересный контент.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Если вы уже задумывались, где удобнее покупать Рифткристаллы и стоит ли вообще копить их на старте — ниже как раз разберёмся, зачем они нужны и почему сейчас это особенно актуально.</p><br><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779208857095-88bfpbmd3.webp\" alt=\"\" data-minio-key=\"news/content/1779208857095-88bfpbmd3.webp\">\r\n        </div>\r\n        </div><p class=\"text-content\">Основная премиальная валюта в игре — Рифткристаллы. Именно через них строится большая часть платной экономики.</p><p class=\"text-content\"><br></p><p class=\"text-content\">На практике они используются для:</p><p class=\"text-content\"><br></p><p class=\"text-content\">круток баннеров персонажей;</p><p class=\"text-content\">покупки лимитированных наборов;</p><p class=\"text-content\">получения косметики и оформления;</p><p class=\"text-content\">ускорения отдельных элементов прогрессии;</p><p class=\"text-content\">участия в части временных активностей и специальных предложений.</p><p class=\"text-content\">И здесь важно понимать главный момент: в NTE донат — это не столько про «стать сильнее», сколько про свободу выбора.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Потому что игра довольно быстро начинает подталкивать игрока к вопросу: «А на что именно ты хочешь копить?»</p>','news/covers/1779208872737-n5favz97l.webp',1,1,6,'Слухи',34,'2026-05-19 19:41:12'),(141,'Sony снова столкнулась с коллективным иском из-за повышения цен на PlayStation 5','Против Sony подали новый коллективный иск, связанный с повышением цен на PlayStation 5 после введения американских тарифов в 2025 году.','<p class=\"text-content\"><img src=\"http://localhost:9000/gamestation-media/news/content/1779209185352-lb7b1snye.webp\" alt=\"\" data-minio-key=\"news/content/1779209185352-lb7b1snye.webp\"><br></p><p class=\"text-content\">Против <b>Sony</b> подали новый коллективный иск, связанный с повышением цен на PlayStation 5 после введения американских тарифов в 2025 году. Истцы утверждают, что компания может получить двойную выгоду за счёт возврата тарифных выплат, не компенсируя расходы покупателям.</p><br><p class=\"text-content\">Согласно материалам дела, Sony подняла стоимость PS5 из-за дополнительных тарифов, введённых администрацией Дональда Трампа. Позже Верховный суд США признал большую часть этих тарифов неконституционными, после чего компаниям разрешили оформлять возврат средств.</p><br><p class=\"text-content\">Авторы иска считают, что Sony сохранит деньги от компенсаций себе, хотя фактически дополнительные расходы уже оплатили покупатели консолей. По их мнению, компания должна вернуть часть средств всем, кто приобрёл PlayStation 5 после повышения цен.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Это уже не первый судебный спор для Sony за последние годы. Ранее компания сталкивалась с исками из-за цен в PlayStation Store, дрифта стиков DualSense и ограничений на продажу цифровых товаров сторонними площадками.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Похожими претензиями сейчас также столкнулись Nintendo, Amazon, Nike и Adidas. Некоторые логистические компании, включая UPS и FedEx, уже заявили, что готовы возвращать компенсации клиентам напрямую. Пока неизвестно, как Sony ответит на новый иск и смогут ли владельцы PS5 получить компенсации.</p>','news/covers/1779209230484-pihyi0yjc.webp',0,0,1,'Консоли',34,'2026-05-19 19:47:10'),(143,'Ошибка Best Buy обвалила акции Take-Two','предзаказы GTA 6 так и не начались','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779209447070-6889uxns0.webp\" alt=\"\" data-minio-key=\"news/content/1779209447070-6889uxns0.webp\"><br><p class=\"text-content\">Весь уикенд фанаты и инвесторы жили в ожидании 18 мая. Причиной ажиотажа стало письмо от розничной сети Best Buy, которое попало в распоряжение блогеров. В нем четко указывалось, что рекламная кампания предзаказов на физическую версию GTA 6 пройдет с 18 по 21 мая, а партнеры получат 5% комиссии . Многие восприняли это как сигнал к открытию бронирования, что вызвало резкий скачок акций Take-Two на прошлой неделе . Однако, когда долгожданный понедельник наступил, а заветная кнопка \"Pre-order\" так и не появилась ни на сайте Best Buy, ни в официальных источниках Rockstar, на бирже началась паника.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Разочарование игроков мгновенно трансформировалось в распродажу акций. Хотя у Rockstar еще есть время до 21 мая, чтобы открыть прием заказов (в частности, перед отчетом Take-Two), терпение рынка лопнуло. На представленном графике TKE·GETTEX видна резкая просадка: бумаги Take-Two Interactive обвалились на 3.44% до отметки $201.13. Это классический пример того, как покупка на слухах сменяется продажей на факте отсутствия новостей. Инвесторы, надеявшиеся на анонс третьего трейлера и старт предзаказов, спешно фиксируют убытки.</p>\r\n        </div>','news/covers/1779209470933-tyfp02b0x.webp',0,0,1,'Слухи',34,'2026-05-19 19:51:10'),(144,'Voices38 работает над взломом Assassin\'s Creed: Shadows и Crimson Desert','voices38 подтвердил, что уже работает над следующим взломом игры с защитой Denuvo.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779209547531-ira2demny.webp\" alt=\"\" data-minio-key=\"news/content/1779209547531-ira2demny.webp\"><br><p class=\"text-content\">Сегодня взломщик voices38 подтвердил, что уже работает над следующим взломом игры с защитой Denuvo.</p><br><p class=\"text-content\">Один из пользователей, который ранее правильно сообщил о предстоящем взломе Pragmata, поделился новой информацией о следующем взломе. По его данным, сейчас voices38 работает сразу над двумя взломами: <a href=\"Один из пользователей, который ранее правильно сообщил о предстоящем взломе Pragmata, поделился новой информацией о следующем взломе. По его данным, сейчас voices38 работает сразу над двумя взломами: Assassin\'s Creed: Shadows и Crimson Desert. Инсайдер при этом не знает, какой из них выйдет следующим.\r\n\r\nСудя по всему, источником его информации является один из тестеров voices38.\">Assassin\'s Creed: Shadows</a> и <a href=\"Один из пользователей, который ранее правильно сообщил о предстоящем взломе Pragmata, поделился новой информацией о следующем взломе. По его данным, сейчас voices38 работает сразу над двумя взломами: Assassin\'s Creed: Shadows и Crimson Desert. Инсайдер при этом не знает, какой из них выйдет следующим.\r\n\r\nСудя по всему, источником его информации является один из тестеров voices38.\">Crimson Desert</a>. Инсайдер при этом не знает, какой из них выйдет следующим.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Судя по всему, источником его информации является один из тестеров<b> voices38.</b></p>\r\n        </div>','news/covers/1779209595459-gmc4forjb.webp',1,0,1,'Слухи',34,'2026-05-19 19:53:15'),(145,'Эмбарго на превью-материалы Assassin\'s Creed: Black Flag Resynced снимут 21 мая','Сегодня в сети раньше времени появилась информация о точной дате публикации первых превью по игре Assassin\'s Creed: Black Flag Resynced.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779209660666-dhth2ilm5.webp\" alt=\"\" data-minio-key=\"news/content/1779209660666-dhth2ilm5.webp\"><br><p class=\"text-content\">Сегодня в сети раньше времени появилась информация о точной дате публикации первых превью по игре Assassin\'s Creed: Black Flag Resynced. Согласно австралийскому подразделению IGN, запрет на публикацию превью ремейка культовой пиратской саги будет снят 21 мая в 20:00 по московскому времени.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Весь май многочисленные представители игровой прессы и блогеры имели возможность опробовать игру в деле, но до недавнего времени точная дата, когда можно будет поделиться впечатлениями, оставалась неизвестной. Судя по всему, 21 мая стоит ожидать волны подробных материалов, посвящённых геймплею, графике и другим особенностям обновлённой версии.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Релиз Assassin\'s Creed: Black Flag Resynced состоится 9 июля 2026 года для PC, PS5 и Xbox Series X/S.</p>\r\n        </div>','news/covers/1779209675515-svjcp7esz.webp',0,0,1,'Анонсы',34,'2026-05-19 19:54:35'),(146,'Battlestate Games готовит сразу три новые игры во вселенной EFT','Студия раскрыла планы по расширению вселенной Escape from Tarkov.','<div class=\"img-block flex-column\"><p class=\"text-content\"><img src=\"http://localhost:9000/gamestation-media/news/content/1779209733117-ko6fzk9xi.webp\" alt=\"\" data-minio-key=\"news/content/1779209733117-ko6fzk9xi.webp\"><br></p><p class=\"text-content\">Battlestate Games раскрыла планы по расширению вселенной Escape from Tarkov. Во время масштабной презентации TarkovTV глава студии Никита Буянов подтвердил, что сейчас в разработке находятся сразу три новых проекта по франшизе.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Одной из игр станет мобильный проект, однако разработчики сразу уточнили, что это не порт основной Escape from Tarkov на смартфоны. Подробностей о нём пока почти нет.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Кроме того, студия работает над одиночной игрой во вселенной Тарков. Её собираются выпускать в формате эпизодов, а сам проект будет сосредоточен на сюжетной составляющей.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Третьей новинкой стала Escape from Tarkov: Guncyclopedia — бесплатный спин-офф для Steam, посвящённый оружейному конструктору из основной игры. Пользователи смогут собирать различные конфигурации оружия, тестировать их на стрельбищах и экспериментировать с модулями без необходимости заходить в сам Тарков. В Battlestate Games даже допустили, что в будущем проект может получить VR-версию.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Помимо новых игр, студия подтвердила, что консольная версия Escape from Tarkov всё ещё находится в разработке. Сейчас Battlestate Games ведёт переговоры с несколькими компаниями по поводу выпуска шутера на PlayStation и Xbox.</p></div>','news/covers/1779209751406-mx1nl9zhy.webp',1,0,4,'Анонсы',34,'2026-05-19 19:55:51'),(147,'Разработчики Escape from Tarkov раздали редкие промокоды с голосом Никиты Буянова','Студия Battlestate Games неожиданно раздала игрокам Escape from Tarkov один из самых редких внутриигровых бонусов','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779209871020-mcc3noau0.webp\" alt=\"\" data-minio-key=\"news/content/1779209871020-mcc3noau0.webp\"><br><p class=\"text-content\">Студия <b>Battlestate Games</b> неожиданно раздала игрокам Escape from Tarkov один из самых редких внутриигровых бонусов — специальную озвучку от главы студии Никиты Буянова. Вместо того чтобы ждать, пока Twitch Drops заработают корректно, разработчики решили временно открыть прямой доступ к награде через промокод.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Игрокам достаточно активировать код WILWILBE, чтобы мгновенно получить легендарные голосовые реплики. Сделать это можно как на официальном сайте Escape from Tarkov, так и через лаунчер — после ввода появится зелёное окно, подтверждающее успешное получение.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Однако подарком смогут воспользоваться не все: срок действия кода крайне ограничен. Разработчики предупреждают, что он перестанет работать через три дня, поэтому тем, кто прочтёт новость после 2–3 декабря, получить озвучку уже не удастся.</p></div>','news/covers/1779209915455-5im5xyngi.webp',0,0,1,'Индустрия',34,'2026-05-19 19:58:35'),(148,'Capcom третий год подряд продает на ПК больше игр, чем на консолях','Компания Capcom третий год подряд демонстрирует преобладание продаж своих игр на ПК по сравнению с консолями.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779210005449-slaznjwz7.webp\" alt=\"\" data-minio-key=\"news/content/1779210005449-slaznjwz7.webp\"><br><p class=\"text-content\">Компания Capcom третий год подряд демонстрирует преобладание продаж своих игр на ПК по сравнению с консолями. При этом доля цифрового контента в структуре продаж достигла рекордных 93%.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Согласно последнему финансовому отчету за 2025 фискальный год (завершился 31 марта), общие продажи японского издателя составили почти 60 миллионов копий, что на 5 миллионов превысил внутренние прогнозы компании. Персональные компьютеры стали ключевым источником дохода: на этой платформе было реализовано 32,17 миллиона копий игр, в то время как на консолях — 22,76 миллиона.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Данная тенденция носит долгосрочный характер. Еще в 2022 году на долю ПК приходилось 52% от всех продаж компании, после чего этот показатель планомерно рос. Основным драйвером продаж на ПК стала ценовая стратегия издателя, завязанная на регулярном проведении масштабных распродаж, что традиционно привлекает аудиторию этой платформы.</p>\r\n        </div>','news/covers/1779210036650-2kii11aw4.webp',0,0,2,'PC',34,'2026-05-19 20:00:36'),(149,'\"Настоящая золотая эра пиратства\"','Пользователи впечатлены тем, как быстро voices38 взламывает последнюю Denuvo','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779210114931-b2uxxy1u7.png\" alt=\"\" data-minio-key=\"news/content/1779210114931-b2uxxy1u7.png\"><br><p class=\"text-content\">Сегодня взломщик <b>voices38</b> порадовал пиратов новым взломом: в этот раз защита<b> Denuvo</b> пала в<a href=\"Сегодня взломщик voices38 порадовал пиратов новым взломом: в этот раз защита Denuvo пала в Pragmata - свежем экшене от Capcom.\"> Pragmata</a> - свежем экшене от Capcom.</p><br><p class=\"text-content\">Примечательно, что с релиза Pragmata не прошло и месяца, при этом параллельно voices38 успел взломать еще несколько других крупных долгожданных игр - Stellar Blade и Black Myth: Wukong.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Пользователи не могли не отметить как сильно поменялась ситуация для ПК-пиратов по сравнению с предыдущими годами, учитывая стремительное развитие навыков voices38 и параллельные сотни взломов Denuvo с помощью гипервизора от DenuvOwO.</p>\r\n        </div>','news/covers/1779210178446-z20muu256.png',1,0,1,'PC',34,'2026-05-19 20:02:58'),(150,'Состоялся общий релиз Forza Horizon 6','Состоялся общий релиз Forza Horizon 6 - новая часть культовой серии впервые отправила игроков в Японию','<div class=\"img-block flex-column\"><p class=\"text-content\"><img src=\"http://localhost:9000/gamestation-media/news/content/1779210212100-trshqv87u.webp\" alt=\"\" data-minio-key=\"news/content/1779210212100-trshqv87u.webp\"><br></p><p class=\"text-content\">Forza Horizon 6 официально вышла на Xbox Series X|S и PC. После нескольких дней раннего доступа для владельцев Premium Edition состоялся полноценный мировой релиз новой части гоночной серии от Playground Games и Xbox Game Studios.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Главной особенностью Forza Horizon 6 стала Япония — впервые в истории серии Horizon Festival проходит среди улиц Токио, горных серпантинов, сельских регионов и прибрежных трасс страны. Разработчики называют карту самой крупной и насыщенной в истории франшизы. В игре доступно более 550 автомобилей на старте, включая Toyota GR GT Prototype 2025 года и новый Land Cruiser.</p><p class=\"text-content\"><br></p><p class=\"text-content\">В новой части появилась переработанная система прогрессии с упором на исследование страны, коллекционирование и автомобильную культуру Японии. Среди нововведений — Car Meets, вдохновлённые настоящими японскими автосообществами, улучшенный тюнинг и расширенные социальные функции.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Игра уже получила высокие оценки профильной прессы. Критики хвалят масштаб открытого мира, визуальную составляющую и атмосферу японского автоспорта, хотя часть обзоров отмечает, что проект развивает идеи предыдущих частей эволюционно, а не революционно.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Forza Horizon 6 также доступна в подписке Xbox Game Pass с первого дня. Версия для PlayStation 5 подтверждена официально, однако её релиз ожидается позже в 2026 году.</p>\r\n        </div>','news/covers/1779210235265-yrywt9l70.webp',0,0,2,'Релизы',34,'2026-05-19 20:03:55'),(151,'Предзаказы GTA 6 могут стартовать 12 мая по цене 69.99','Утверждается, что предварительные заказы GTA 6 откроются 12 мая, а рекомендованная розничная цена составит £69.99.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779210302313-gvt0x4pe6.webp\" alt=\"\" data-minio-key=\"news/content/1779210302313-gvt0x4pe6.webp\"><br><p class=\"text-content\">В сети появилась новая порция слухов о долгожданной Grand Theft Auto VI. На этот раз источником стал аккаунт RockStation в X (Twitter),</p><p class=\"text-content\">который поделился сообщением от подписчика.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Согласно этому сообщению, один из британских ретейлеров (название не раскрывается) разослал своим сотрудникам внутренний пресс-пакет. В нём утверждается, что предварительные заказы GTA 6 откроются 12 мая, а рекомендованная розничная цена составит £69.99.</p><br><div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779210340985-tpx67fn4f.webp\" alt=\"\" data-minio-key=\"news/content/1779210340985-tpx67fn4f.webp\"><br><p class=\"text-content\">Автор поста, RockStation, признаёт, что на данный момент проверить эту информацию невозможно. Тем не менее, он отмечает, что у него есть связи в сети магазинов Smyth’s (крупный британский ретейлер игр). RockStation пообещал связаться с ними утром, чтобы попытаться прояснить ситуацию и подтвердить или опровергнуть слух.</p><p class=\"text-content\"><br></p><p class=\"text-content\">UPD: Спустя несколько часов после публикации первоначального слуха о предзаказах GTA 6 произошло событие, которое многие фанаты сочли косвенным подтверждением достоверности информации. Спустя несколько часов после публикации пост был удалён самим автором,а его аккаунт стал приватным.</p></div></div>','news/covers/1779210362857-dok1qpzp7.webp',1,1,1,'Слухи',34,'2026-05-19 20:06:02'),(152,'Lisuan Technology представляет игровую видеокарту LX 7G100','На сцену выходит китайская Lisuan Technology с моделью Lisuan LX 7G100 — и у новинки уже есть важное достижение.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779210899702-zxtsa9446.webp\" alt=\"\" data-minio-key=\"news/content/1779210899702-zxtsa9446.webp\"><br><p class=\"text-content\">Выход нового игрового графического процессора — всегда серьёзное испытание: разработчикам нужно добиться совместимости с ПО и оптимизировать драйверы. Даже Intel потребовались годы, чтобы довести до ума Arc Graphics и составить конкуренцию NVIDIA GeForce RTX и AMD Radeon RX. Теперь на сцену выходит китайская Lisuan Technology с моделью Lisuan LX 7G100 — и у новинки уже есть важное достижение.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Графический процессор получил сертификат Microsoft WHQL (Windows Hardware Quality Labs) — впервые среди китайских производителей GPU. Это значит, что официальный драйвер для Lisuan LX 7G100 пройдёт строгую проверку Microsoft и будет гарантированно совместим с Windows.</p></div>','news/covers/1779210938537-am3lhr6g9.webp',0,0,0,'Анонсы',34,'2026-05-19 20:15:38'),(153,'CD Projekt RED заявила, что The Witcher 4 и Cyberpunk 2 не повторят ошибок Cyberpunk 2077','CD Projekt RED уверяет, что извлекла уроки из проблемной разработки Cyberpunk 2077 и не собирается повторять те же ошибки в The Witcher 4 и Cyberpunk 2.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211204563-izd0q7vea.webp\" alt=\"\" data-minio-key=\"news/content/1779211204563-izd0q7vea.webp\"><br><p class=\"text-content\">CD Projekt RED уверяет, что извлекла уроки из проблемной разработки Cyberpunk 2077 и не собирается повторять те же ошибки в The Witcher 4 и Cyberpunk 2. По словам сотрудников студии, ключевые изменения произошли внутри самого производственного процесса.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Разработчики признались, что в прошлом компания практически не занималась системной документацией проектов. Во времена первых частей The Witcher многие технические решения и наработки существовали лишь «в головах сотрудников», из-за чего спустя годы студии оказалось сложно восстановить часть информации для ремейка оригинальной игры.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Особенно серьёзно проблема проявилась во время создания Cyberpunk 2077. Команда накопила тысячи страниц документации, разбросанной по разным сервисам и внутренним системам. Со временем поддерживать её в актуальном состоянии стало слишком сложно, а разработчики и аутсорс-команды сталкивались с путаницей и нехваткой информации.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Теперь CD Projekt RED изменила подход. В студии ввели единые стандарты хранения данных и сделали документацию обязательной частью каждого этапа производства. Без этого команды больше не смогут переходить к следующей стадии разработки.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Авторы уверяют, что новая система позволит разработчикам The Witcher 4 и Cyberpunk 2 быстрее обмениваться решениями между командами и избегать хаоса, который сопровождал производство Cyberpunk 2077.</p>\r\n        </div>','news/covers/1779211218278-4c8ixvgcr.webp',1,1,5,'Слухи',34,'2026-05-19 20:20:18'),(154,'За 6 часов до релиза: DenuvOwO выпустили гипервизор-взлом для LEGO Batman: Legacy of the Dark Knight','DenuvOwO уже выпустили взлом для LEGO Batman: Legacy of the Dark Knight. Примечательно, что ранний релиз для обладателей Deluxe-издания состоится лишь через 6 часов.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211270907-48wfejs11.webp\" alt=\"\" data-minio-key=\"news/content/1779211270907-48wfejs11.webp\"><br><p class=\"text-content\">Несмотря на удаление Discord-канала, группа DenuvOwO продолжила выпускать гипервизор-взломы Denuvo.</p><p class=\"text-content\"><br></p><p class=\"text-content\">DenuvOwO уже выпустили взлом для LEGO Batman: Legacy of the Dark Knight. Примечательно, что ранний релиз для обладателей Deluxe-издания состоится лишь через 6 часов. Таким образом, наряду с Pragmata, игра с Denuvo снова попала в руки пиратов раньше, чем для обладателей лицензионных копий. Судя по всему, Irdeto так ничего и не смогла предпринять против гипервизора.</p><p class=\"text-content\"><br></p><p class=\"text-content\">LEGO Batman: Legacy of the Dark Knight \"Crack - Запуск игры без защиты Denuvo через гипервизор\".</p><p class=\"text-content\"><br></p><p class=\"text-content\">В LEGO Batman: Legacy of the Dark Knight игроку предстоит отправиться в путешествие, которое начинается с зарождения Бэтмена, когда молодой Брюс Уэйн проходит тренировку в Лиге теней, становится героем Готэм-сити и создает семью союзников с участием Джима Гордона, Женщины-кошки, Робина, Найтвинга и Бэтгерл.</p>\r\n        </div>','news/covers/1779211290064-vz6op5f4t.webp',1,1,5,'PC',34,'2026-05-19 20:21:30'),(155,'CDPR признала хаос разработки Cyberpunk 2077 и обещает не повторить его','CD Projekt объясняет, что извлекла уроки из хаотичной разработки игры.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211355700-lhb01ikce.webp\" alt=\"\" data-minio-key=\"news/content/1779211355700-lhb01ikce.webp\"><br><p class=\"text-content\"><b>Cyberpunk 2077</b> — одна из самых амбициозных игр в истории, которую по масштабу превзойдут только грядущая GTA 6 и Cyberpunk 2. По мере продолжения разработки сиквела, в котором недавно появились новые сценаристы, <b>CD Projekt </b>объясняет, что извлекла уроки из хаотичной разработки игры.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Выступая на ежегодной конференции Digital Dragons, старший технический сценарист Адриан Фульнечек объяснил, что разработка Cyberpunk 2077 была «хаосом» из-за плохого управления документацией, что доставило студии немало хлопот.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Фульнечек пояснил, что разработка Cyberpunk не была первым случаем, когда плохая документация препятствовала проекту. Когда разработчики уходили между проектами, документация не хранилась в безопасности, книги с лором терялись, а новые сотрудники испытывали трудности с освоением инструментов. «Тогда никто не думал на 20 лет вперёд», — сказал он, добавив, что до The Witcher 3 «это была сплочённая группа, поэтому знания не хранились где-то в базе данных, а передавались из рук в руки».</p><p class=\"text-content\"><br></p><p class=\"text-content\">Что касается The Witcher 3, он объяснил, что команда испытывала большие трудности с созданием инструментов для модификаций, которые могли бы использовать игроки.</p>\r\n        </div>','news/covers/1779211375023-uizhquu7y.webp',1,2,2,'PC',34,'2026-05-19 20:22:55'),(156,'Модификацию S.T.A.L.K.E.R. Anomaly перенесли в виртуальную реальность!','Anomaly (версии 1.5.3) теперь доступна в виртуальной реальности благодаря новому аддону на базе модифицированного движка X-Ray.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211428424-q2ldd2t64.webp\" alt=\"\" data-minio-key=\"news/content/1779211428424-q2ldd2t64.webp\"><br><p class=\"text-content\">Что внутри?</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Спойлер</b></p><p class=\"text-content\">Это не обычный порт через VorpX. Разработчики представили полноценную публичную альфу (версия 0.3) с нативной поддержкой OpenXR. Ключевые технические особенности:</p><p class=\"text-content\"><br></p><p class=\"text-content\">Полный 6DoF и IK рук: Ваше тело и движения рук полностью отслеживаются в пространстве, что критично для выживания в перестрелках.</p><p class=\"text-content\">Физика предметов: Предметы можно не просто «активировать», а физически поднимать, бросать и складывать в рюкзак, который теперь ощущается как реальная зона на плече.</p><p class=\"text-content\">VR-интерфейс: ПДА, инвентарь и меню переработаны для удобного взаимодействия в шлеме. Больше никакой «плоской» картинки перед глазами — только полное погружение.</p><p class=\"text-content\">Совместимость</p><p class=\"text-content\"><br></p><p class=\"text-content\"><b>Спойлер</b></p><p class=\"text-content\">Проект поддерживает практически все современные устройства через OpenXR, включая Meta Quest 2/3/Pro (через Link/Air Link), Valve Index, Pico 4, а также PSVR2 при подключении к ПК.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Текущее состояние</p><p class=\"text-content\"><br></p><p class=\"text-content\">Несмотря на статус «альфы», в игре уже реализован базовый геймплей Anomaly: от исследования локаций до выполнения квестов и боев с мутантами. Однако разработчики предупреждают: полноценное двуручное оружие и финальная модель физического ПДА появятся в следующих обновлениях.</p>\r\n        </div>','news/covers/1779211461087-kwxjz1kse.webp',0,0,1,'VR',34,'2026-05-19 20:24:21'),(157,'Создатель удаленного VR-мода для Cyberpunk 2077 обвинил CD Projekt Red в том, что теперь его мод пиратят','Люк Росс, создатель популярных VR-модов для разных игр, заявил, что его эксклюзивный мод для Cyberpunk 2077','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211517432-uxro7sa55.webp\" alt=\"\" data-minio-key=\"news/content/1779211517432-uxro7sa55.webp\"><br><p class=\"text-content\">Люк Росс, создатель популярных VR-модов для разных игр, заявил, что его эксклюзивный мод для Cyberpunk 2077 теперь массово пиратят из-за конфликта с CD Projekt Red. Поводом стала DMCA-жалоба, которую польская студия 9 января направила платформе Patreon, потребовав удалить платный VR-мод для Cyberpunk 2077. Мод, позволяющий играть в шутер от первого лица в виртуальной реальности, был немедленно снят с публикации. В интервью изданию IGN Росс рассказал:</p><p class=\"text-content\"><br></p><p class=\"text-content\">У меня вообще не было права голоса. Команда Patreon, как это обычно и бывает, выполнила запрос и удалила мод по своей собственной инициативе.</p><p class=\"text-content\">Росс попытался связаться с CD Projekt Red для поиска взаимовыгодного решения. Однако студия в ответ лишь сослалась на нарушение правил использования контента и не стала вступать в переговоры. Позиция CD Projekt Red была публично разъяснена Яном Роснером, вице-президентом по бизнес-развитию.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Мы никогда не разрешаем монетизацию нашей интеллектуальной собственности без нашего прямого разрешения или договоренностей. На прошлой неделе мы связались с Люком и проинформировали его, что ему либо необходимо сделать мод бесплатным для всех (с возможностью добровольных пожертвований), либо удалить его.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Люк Росс, который зарабатывает около $20000 в месяц на своих модах, с такой трактовкой не согласен. По его мнению, требование сделать софт бесплатным неправомерно, так как мод не содержит ни кода, ни ассетов CD Projekt. Однако после удаления мода с Patreon пользователи, опасаясь потерять доступ к VR-режиму для любимой игры, начали массово распространять его пиратские копии. Более того, часть сообщества оправдывает это пиратство как \"наказание\" для самого моддера за несоблюдение правил CD Projekt.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Люди нагло заявляют, что раз я не соблюдал пользовательское соглашение CDPR, то моя работа теперь стала \"всеобщим достоянием\", и меня следует наказать, украв ее. Так что, в определенном смысле, CDPR добились своего.</p><p class=\"text-content\"><br></p><p class=\"text-content\">В соцсетях и на странице Люка на Patreon развернулась жесткая полемика. Одни пользователи поддерживают студию, обвиняя Росса в жадности, ведь ему было предложено легальное решение - сделать мод бесплатным с возможностью донатов. Другие резко критикуют CD Projekt за \"удар по моддингу\" и считают, что студия могла бы найти более гибкий подход, учитывая уникальность и техническую сложность проекта Росса.</p><p class=\"text-content\"><br></p><p class=\"text-content\">На данный момент будущее VR-мода для Cyberpunk 2077 остается неопределенным. Росс не исключает возможности выпуска бесплатной версии, но отмечает, что технически это сложная задача, так как его ПО поддерживает более 40 игр.</p>\r\n        </div>','news/covers/1779211538056-bbre1yn0t.webp',0,0,0,'VR',34,'2026-05-19 20:25:38'),(158,'Энтузиаст занимается разработкой VR-режима для Resident Evil Requiem','Знаменитый в игровом сообществе энтузиаст Praydog начал адаптацию Resident Evil Requiem под шлемы виртуальной реальности.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211584066-g6jb3y25y.webp\" alt=\"\" data-minio-key=\"news/content/1779211584066-g6jb3y25y.webp\"><br><p class=\"text-content\">Знаменитый в игровом сообществе энтузиаст Praydog начал адаптацию Resident Evil Requiem под шлемы виртуальной реальности. Поражает то, насколько быстро автору удалось перенести свежий хит в VR. Ядро базовых механик получилось «завести» и адаптировать под гарнитуры всего через пару дней после официального старта продаж игры.</p><p class=\"text-content\"><br></p><p class=\"text-content\">В данный момент мод находится на этапе крайне ранней и активной разработки. Как сообщается, автор занимается полировкой и борется с багами, вроде раздвоения элементов интерфейса или отсутствия поддержки управления захватом движений - пока в прототипе нужно использовать геймпад или клавиатуру с мышью. Однако даже на этом этапе в такой перспективе игра выглядит просто феноменально. Измененный угол обзора делает каждую стычку с зомби или бегство по узким лабиринтам в разы напряженнее. Первые тестеры проекта уже делятся своими результатами, отмечая, что на мощных системах с видеокартой уровня RTX 4080S при включенном DLSS играбельный VR выдает стабильные 60 FPS.</p>\r\n        </div>','news/covers/1779211605812-dpzfers9i.webp',1,0,2,'VR',34,'2026-05-19 20:26:45'),(159,'Продажи серии Dishonored превысили 12,5 миллиона копий','Серия стелс-экшенов Dishonored от Arkane Studios достигла впечатляющего коммерческого успеха — суммарные продажи игр франшизы превысили 12,5 миллиона копий по всему миру.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211677670-69opoxezl.webp\" alt=\"\" data-minio-key=\"news/content/1779211677670-69opoxezl.webp\"><i>Dishonored</i><br><p class=\"text-content\">Эту информацию сообщал Кент Хадсон на своей страничке в LinkedIn, чья консалтинговая компания помогала в разработке игр.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Я руковожу консалтинговой компанией, предлагающей креативный анализ и дизайнерские решения для разрабатываемых видеоигр. Среди моих клиентов — Arkane Studios (франшиза Dishonored, более 12,5 млн проданных копий по всей серии), Irrational Games (BioShock Infinite, более 11 млн проданных копий), Three One Zero (ADR1FT) и LucasArts (Star Wars 1313).</p><p class=\"text-content\"><br></p><p class=\"text-content\">Этот показатель подтверждает устойчивый интерес игроков к уникальному сочетанию иммерсивного геймплея, свободы прохождения и мрачной атмосферы, за которую серия и получила признание как критиков, так и аудитории.</p></div>','news/covers/1779211713386-607jiqolq.webp',1,1,1,'PC',34,'2026-05-19 20:28:33'),(160,'По словам разработчиков, вы не поймете Dishonored 2, пока не пройдете ее дважды','В Dishonored 2 ваши решения будут настолько глубоко и масштабно влиять на геймплей, что за время прохождения игры в первый раз вы сможете изучить лишь часть заготовленного контента.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211792468-2hmkmmx63.jpeg\" alt=\"\" data-minio-key=\"news/content/1779211792468-2hmkmmx63.jpeg\"><br><p class=\"text-content\">В<b> Dishonored 2 </b>ваши решения будут настолько глубоко и масштабно влиять на геймплей, что за время прохождения игры в первый раз вы сможете изучить лишь часть заготовленного контента.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Глава креативной разработки Dishonored 2 Харви Смит рассказал порталу Finder, что первое прохождение позволит оценить примерно четверть всей игры. И если вы захотите увидеть больше, вам нужно будет пройти ее еще хотя бы раз.</p><p class=\"text-content\"><br></p><p class=\"text-content\">«Всякий раз, когда вы играете в Dishonored 2, прохождение получается новым, поскольку вы находите другие пути, другие способности, вызываете много или же мало волнений, а также выбираете Корво либо Эмили», — рассказал Смит.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Он добавил, что для повторного прохождения Dishonored 2 будет гораздо больше причин, чем было у оригинальной игры. Вы услышите новые разговоры, откроете новые детали сюжета и поймете влияние окружения на повествование.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Кроме того, доступных очков для открытия сверхспособностей героев будет недостаточно, чтобы в течение одного прохождения испытать все суперсилы.</p>\r\n        </div>','news/covers/1779211825393-g28fh8531.jpeg',1,1,3,'PC',34,'2026-05-19 20:30:25'),(161,'Xbox анонсирует Player Voice для сбора отзывов','Сегодня Microsoft представила Xbox Player Voice, новую официальную платформу, предназначенную для обмена, сбора и организации отзывов сообщества.','<div class=\"img-block flex-column\">\r\n            <img src=\"http://localhost:9000/gamestation-media/news/content/1779211943491-9hskmug2j.webp\" alt=\"\" data-minio-key=\"news/content/1779211943491-9hskmug2j.webp\"><br><p class=\"text-content\">Сегодня Microsoft представила Xbox Player Voice, новую официальную платформу, предназначенную для обмена, сбора и организации отзывов сообщества. Пользователи могут предлагать идеи, голосовать за идеи других игроков и помогать формировать будущие приоритеты для экосистемы Xbox.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Портал заменит текущий сайт поддержки Xbox Cloud Gaming, а также будет включать форумы, социальные сети и раздел, посвящённый программе Xbox Insider, полезный для тестирования новых сборок и сообщения об ошибках.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Сегодня мы представляем Xbox Player Voice, новое пространство, предназначенное для сбора ваших отзывов и повышения их видимости. Цель проста: упростить обмен предложениями и показать, как они учитываются. Цель проста: упростить обмен предложениями и показать, как они решаются.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Давайте будем откровенны: это не значит, что каждый отзыв превратится в функцию или приведёт к изменениям. Работа на большой глобальной платформе требует баланса многих факторов. Но большая прозрачность помогает преодолеть разрыв между тем, что вы нам говорите, и тем, что вы видите на Xbox.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Портал Player Voice уже активен и доступен по этому адресу. Несмотря на то, что он работает недолго, один запрос уже лидирует в рейтинге с сотнями голосов: возвращение эксклюзивов от внутренних студий на консоли Xbox.</p><p class=\"text-content\"><br></p><p class=\"text-content\">Популярные предложения также включают в себя увеличение инвестиций в обратную совместимость, возможность сделать онлайн-мультиплеер бесплатным без подписки Game Pass, новую систему достижений и введение семейного плана для Xbox Game Pass.</p>\r\n        </div>','news/covers/1779211966013-4f14aopiv.webp',0,0,1,'Консоли',34,'2026-05-19 20:32:46');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
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
  `brand_id` int DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idPlatform`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_brand_id` (`brand_id`),
  CONSTRAINT `fk_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`idBrand`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=509 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platforms`
--

LOCK TABLES `platforms` WRITE;
/*!40000 ALTER TABLE `platforms` DISABLE KEYS */;
INSERT INTO `platforms` VALUES (3,'Linux',NULL,NULL,0),(4,'64',3,NULL,0),(6,'PC',NULL,NULL,0),(7,'PlayStation',1,NULL,0),(8,'PlayStation 2',1,NULL,0),(9,'PlayStation 3',1,NULL,0),(11,'Xbox',2,NULL,0),(12,'Xbox 360',2,NULL,0),(14,'Mac',5,NULL,0),(15,'128',7,NULL,0),(18,'Entertainment System',3,NULL,0),(19,'Super Nintendo Entertainment System',3,NULL,0),(20,'DS',3,NULL,0),(21,'GameCube',3,NULL,0),(29,'Mega Drive',4,NULL,0),(30,'32X',4,NULL,0),(32,'Saturn',4,NULL,0),(35,'Game Gear',4,NULL,0),(37,'3DS',3,NULL,0),(38,'PlayStation Portable',1,NULL,0),(39,'iOS',5,NULL,0),(46,'PlayStation Vita',1,NULL,0),(48,'PlayStation 4',1,NULL,0),(49,'Xbox One',2,NULL,0),(59,'2600',6,NULL,0),(60,'7800',6,NULL,0),(61,'Lynx',6,NULL,0),(62,'Jaguar',6,NULL,0),(63,'ST',6,NULL,0),(64,'Master System',4,NULL,0),(65,'8-bit',6,NULL,0),(66,'5200',6,NULL,0),(71,'VIC-20',7,NULL,0),(75,'II',5,NULL,0),(78,'CD',4,NULL,0),(90,'PET',7,NULL,0),(93,'16',7,NULL,0),(94,'Plus/4',7,NULL,0),(130,'Switch',3,NULL,0),(158,'CDTV',7,NULL,0),(159,'DSi',3,NULL,0),(165,'PlayStation VR',1,NULL,0),(167,'PlayStation 5',1,NULL,0),(169,'Xbox Series X|S',2,NULL,0),(339,'Pico',4,NULL,0),(390,'PlayStation VR2',1,NULL,0),(410,'Jaguar CD',6,NULL,0),(482,'CD 32X',4,NULL,0),(508,'Switch 2',3,NULL,0);
/*!40000 ALTER TABLE `platforms` ENABLE KEYS */;
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
  CONSTRAINT `fk_qsection` FOREIGN KEY (`section_id`) REFERENCES `questionsections` (`idSection`) ON DELETE CASCADE,
  CONSTRAINT `fk_questions_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  CONSTRAINT `fk_userQstn` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (31,'Ищу игру с глубоким сюжетом как в The Last of Us','Описание: Ребята, выручайте. Прошёл The Last of Us 1 и 2, теперь страдаю. Ищу игры с таким же мощным сюжетом, чтобы за душу брало. Жанр не важен, главное — история и персонажи. Что посоветуете? Платформа — PC и PS5.','open',0,0,'2026-05-19 22:12:19',6,34,'active',NULL,NULL,NULL),(32,'Помогите победить босса Malenia в Elden Ring','Застрял на Malenia уже 3 дня, убиваю как-то раз 20% второго этапа и всё. Билд: двуручный меч +10, 60 ловкости, 45 выносливости. Какой билд лучше занести? Может тактику какую-то? Призываю Мимика, но она все равно её хилит. Спасибо.','open',0,0,'2026-05-19 22:13:05',10,34,'active',NULL,NULL,NULL),(33,'Лор и сюжет: почему Марика разбила Кольцо?','Вопрос по лору Elden Ring. Я так и не понял логику Марики. Зачем она разбила Кольцо? Из-за смерти Годвина? Или это был заранее продуманный план? А зачем она потом сковала Хору Лу? Давайте обсудим, очень запутанно написано.','open',0,0,'2026-05-19 22:13:20',9,34,'active',NULL,NULL,NULL),(34,'Системные требования для GTA 6 — потянет ли мой ПК?','Слухи что GTA 6 выйдет на ПК в конце 2026. Вот моя сборка: RTX 3060 12GB, Ryzen 5 5600x, 16GB RAM. Как думаете, на минималках в 1080p вытянет? Или надо апгрейд затевать до 4060/4070? Жду ваши мысли.','open',0,0,'2026-05-19 22:13:33',11,34,'active',NULL,NULL,NULL),(35,'Помогите найти игру, где можно строить крепость и защищаться от орд','Хочется игру, где ты строишь крепость/базу, а потом на тебя бегут волны врагов. Что-то типа They Are Billions, но может быть другой сеттинг — фэнтези, космос, постапокалипсис. Желательно с кооперативом.','open',0,0,'2026-05-19 22:13:47',6,34,'active',NULL,NULL,NULL),(36,'Помогите пройти уровень в Stalker 2 — застрял на болотах','В Stalker 2, в локации Великие Болота, не могу пройти к лаборатории X-19. Постоянно либо аномалии убивают, либо кровососы. Какой маршрут лучше? В какой костюм переодеться? И есть ли смысл тащить с собой дробовик? Заранее спасибо.','open',0,0,'2026-05-19 22:13:56',10,34,'active',NULL,NULL,NULL),(37,'Обсуждаем лор Bloodborne: что там с кошмарами?','Недавно прошёл Bloodborne, сюжет понял процентов на 30. Кто такие Старшие Боги? Почему главный герой охотится на зверей? Что за девочка с брошью? Кто истинный финальный босс по лору? Зову всех любителей лора разобрать всё по косточкам.','open',0,1,'2026-05-19 22:14:07',9,34,'active',NULL,NULL,NULL),(38,'Моды на транспорт в Cyberpunk 2077 — что поставить?','В ванилле транспорт управляется так себе, хочется поставить моды. Какие самые крутые на сегодня? Может летающие машины? Или реальный тюнинг? А что по управляемости — приблизить к GTA? Ссылки на Nexus приветствуются.','open',0,3,'2026-05-19 22:14:14',12,34,'active',NULL,NULL,NULL),(39,'Тяжёлый выбор: купить новую видеокарту или игровую консоль?','Есть бюджет 60-70 тысяч рублей. Что выгоднее сейчас? Апгрейдить ПК (присматриваюсь к RTX 4070) или купить Xbox Series X / PS5? С одной стороны — ПК универсальнее, с другой — на консоли эксклюзивы выходят сразу и там коробочное решение без танцев с бубном. Кто что думает?','closed',1,1,'2026-05-19 22:14:23',8,34,'active',NULL,NULL,NULL),(41,'аываываыва','аываыв','closed',0,0,'2026-05-20 00:12:01',2,34,'active',NULL,NULL,'Да окей потом сделаем'),(43,'Я сосал','Я сосал','closed',0,0,'2026-05-20 02:41:37',1,34,'active',NULL,NULL,'папапрапрапр'),(44,'dffdsf','dfdfdfdf','open',0,0,'2026-05-20 13:35:25',3,34,'active',NULL,NULL,NULL),(45,'fghfgh','fghfghfghfgh','open',0,0,'2026-05-20 13:35:43',3,33,'active',NULL,NULL,NULL);
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionsections`
--

DROP TABLE IF EXISTS `questionsections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questionsections` (
  `idSection` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idSection`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionsections`
--

LOCK TABLES `questionsections` WRITE;
/*!40000 ALTER TABLE `questionsections` DISABLE KEYS */;
INSERT INTO `questionsections` VALUES (5,'admin_question'),(1,'advertisement'),(8,'another'),(6,'find_game'),(4,'games_database'),(9,'lore_story'),(12,'mods'),(7,'problems'),(2,'site_issues'),(11,'system_requirements'),(3,'vacancies'),(10,'walkthrough');
/*!40000 ALTER TABLE `questionsections` ENABLE KEYS */;
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
  `views_count` int NOT NULL DEFAULT '0' COMMENT 'Кол-во просмотров',
  `comments_count` int NOT NULL DEFAULT '0' COMMENT 'Кол-во комментариев',
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
  CONSTRAINT `fk_rating_game` FOREIGN KEY (`rating_id`) REFERENCES `gameratings` (`idGameRating`) ON DELETE SET NULL,
  CONSTRAINT `fk_reviews_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_moderated_by` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`) ON DELETE SET NULL,
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (29,'Умиротворение и спокойствие','ABZU - это та игра где ты не должен куда-то бежать или стрелять, просто плывёшь по океану и расслабляешься.\n\nКогда ты играешь в эту игру ты получаешь эффект умиротворения и внутреннее спокойствие, практически не думаешь ни о чём. Больше всего мне понравилась именно атмосфера игры и её музыка.\n\nК плюсам можно отнести то что она проходится достаточно быстро, порядка двух часов и она не успевает вам надоесть за это время.\n\nЕсли вы любите чиловые игры где практически и думать не нужно, то я могу посоветовать вам пройти её. ',2,0,'2026-05-20 19:56:55',1192,34,55,'active',NULL,NULL),(30,'Неплохой экшн хоррор','Alan wake... звучит очень много обещающе. И вправду когда я начинал играть в эту игру в детстве мне было по настоящему страшно. Но все же мои руки дошли до этой игры. И вот на дворе 2026г и я начал проходить эту игру. \n\nКогда я зашёл в игру, рассказ Алана действительно замотивировал меня играть в неё. Мне очень понравилась его история, его рассказы, а одна мысль от того что мы должны спасти его возлюбленную мотивировала меня ещё больше. \n\nСюжет игры, да и сама атмосфера этой игры сильно затянула меня так, что я пытался посмотреть каждый угол, каждый камешек местности.\n\nЕсли смотреть в плане графики, то на 2026г у игры действительно неплохая графика, а с вышедшим ремастером наверное ещё лучше.\n\nСмотря в сторону геймплея это будет пострелушка (посвети, подожди, стреляй), но меня это ничуть не от толкнуло. И я продолжал играть, ведь мне действительно нравилась история этой игры.\n\nПлюсы: атмосфера, великолепный сюжет.\nМинусы: однообразные перестрелки, но я не считаю, что это прям минус.\n\nИтог: если вы хотите погрузиться в мрачную атмосферу и действительно втянуться в сюжет — рекомендую вам пройти эту игру.',1,0,'2026-05-20 20:12:24',1193,34,56,'active',NULL,NULL),(31,'День сурка','Игра представляет собой отдельное DLC, которое продолжает история Алана Уэйка. Почему же именно день сурка ? да всё просто, разработчики тебя заставляют 3 раза пробегаться по одним и тем же локациям. Сначала когда я проходил я не особо понял, я думал может с игрой что не так стало, но на деле нет, просто цикл.\n\nУ DLC не такая сильная атмосфера и сюжет как у первой части игры. Но когда я проходил это DLC мне в принципе понравилось.\n\nПлюсы: короткий сюжет\nМинусы: циклические локации (не прям минус, но решил отнести)\n\nИтог: если вам понравилась первая часть — можете пройти и DLC.',1,0,'2026-05-20 20:34:39',1194,34,57,'active',NULL,NULL),(32,'Моё детство','Gta San Andreas,  скольким же геймерам это игра запала в душу. А я вот в первые прошёл её полностью в 2026г... да это конечно можно считать позором. Играя в детстве в неё я наслаждался её открым миром и её проработкой.\n\nНо почему-же я не прошёл игру в детстве ? да всё просто, я просто не мог пройти миссию с лоурайдерами, ведь у меня не прожимались кнопки потому что нужно оказывается их было настроить для начала...\n\nРазработчики и вправду постарались на славу и отполировали игру. Ведь нам дают открытый мир и говорят делай что хочешь. Когда я проходил, я удивлялся что для своего года, игра скорее всего была прорывной в плане открытого мира и геймплея. Музыка в игре это что-то с чем-то. она действительно даёт ощущение что ты в каком-то гетто районе и едешь на своей тачке.\n\nГоворя про эту игры вы скорее всего сразу вспоминаете такие проекты как SAMP, MTA. Я думаю почти каждый в свои годы играл на каком-то из этих проектов. Да что говорить о детстве, в наши дни досихпор существуют проекты сделанные на этой игре и они собирают не малые показатели онлайна.\n\nПлюсы: Сюжет, Оптимизация, Геймплей, Музыка - всё это складывается в одно целое и даёт тот самый вайб.\n\nМинусы: Сломанные анимации прыжка (во время того когда ты перепрыгиваешь допустим забор, твой персонаж может попросту умереть и да это бесило)',1,0,'2026-05-20 20:54:53',1165,34,58,'active',NULL,NULL),(33,'Сыграйте с другом, пока не поздно','Тот самый побег с близкими тебе людьми. Игра очень интересная и классная в том плане, что вы должны именно играть в двоём со своим корешем или может девушкой. Мне понравилось как поэтапно раскрывается история двух главных героев.\n\nЕсли у вас есть свободный вечер и друг на диване — проходите не думая. A Way Out подарит эмоции, которые запомнятся надолго, ведь кто знает, кто из вас выйдет из положения...\n\nПлюсы: Сюжет, атмосфера игры с другом\nМинусы: Короткий сюжет, мне действительно не хватило ещё пару часиков этой игры',4,0,'2026-05-20 21:11:05',1195,34,59,'active',NULL,NULL),(34,'Атмосфера одиночества','Впервые я поиграл в эту игру наверное в 2025г вместе с лучшим другом. Кажется что тогда время было лучше и трава зеленее... Я помню как нам было весело вместе строить базу, исследовать мир, летать на другие планеты и ходить за ресурсами. Помню как в тот вечер сидел играл и попивал Coca-Cola :) был жёсткий вайбик.\n\nИгра зацепила меня своей атмосферой и геймплеем: терраформирование, система кислорода и многое другое. Когда играешь в неё один, появляется чувство одиночества, ощущение всей этой планеты. Саунд-дизайн просто великолепный — именно благодаря ему ты ловишь то самое чувство.\n\nА знаешь, что делает эту игру ещё более ценной? История её создания. история, о том как команда энтузиастов создала свою игру на самом деле очень интересная, но и в другой момент грустная. Как разработчики вместе вкладывали силы в этот проект и в один прекрасный момент когда выпустилась игра и она действительно зашла аудитории, продажи пошли в гору, спустя какое-то время, скончался один из главных разработчиков (художник, дизайнер) этой игры Paul Pepera.',2,0,'2026-05-20 21:39:55',1196,34,70,'active',NULL,NULL),(35,'Неплохой шутан детства','Помню диск с этой игрой у меня появился из какого-то игрового журнала.\nСама по себе игра в наше време предложить игру ничего не может. Да там есть замедление времени  когда штурмишь например комнату какую-то и да, раньше наверное это было круто, играя в детстве мне было интересно в неё играть.\n\nИгра очень короткая, за вечер можно спокойно пройти',1,0,'2026-05-21 10:28:40',1198,33,78,'active',NULL,NULL),(36,'Исследование чудес мирового океана','Сразу скажу что игра проходится не долго. Весь геймплей игры представляет собой просто сканирование и исследование океана (чил геймплей). Атмосфера игры особенно на большой глубине раскрывается больше, когда я погрузился в темноту мне стало не по себе, хотя в игре нет какой-либо опасности.\n\nМузыка в игре: музыка в игре скорее всего мне больше и запомнилась и я даже кстати добавил пару треков себе.\n\nРекомендую тем кому не надоедает такой рутинный геймплей ',1,0,'2026-05-21 10:52:30',1204,34,79,'active',NULL,NULL),(37,'Неплохой зомби шутер','Играл вместе с друзьями и я думаю только так Back 4 Blood раскрывается. Ведь с друзьями практически всегда весело играть в такие игры.\n\nКогда играешь в эту игру сразу вспоминаешь старую и добрую LEFT 4 DEAD. У игры неплохой потенциал, я не смотрю на скины и т.д, а сужу с точки геймплея. Графика в игре тоже не подкачала.\n\nВ общем игруха добротная, советую поиграть и посмеяться вместе с друзьями. ',1,0,'2026-05-21 11:36:40',1205,34,80,'active',NULL,NULL),(38,'Улучшенная русская рулетка','Разработчик очень классно передела эту атмосферу благодаря визуальном стилю игры и её музыке. Разнообразил русскую рулетку другими предметами. Ты должен запоминать сколько патрон осталось в игре, какие из них холостые, а какие нет. Мультиплеер при игре с друзьями первое время завлекает, но позже просто становится скучно.\n\nПлюсы: Визуальный стиль, атмосфера\nМинусы: Быстро надоедает',1,0,'2026-05-21 11:54:08',1207,34,82,'active',NULL,NULL),(39,'Прародитель жанра лутер-шутер','Отличная игрушка для 2009г. Геймплей, визуальный стиль - всё это делает эту игру интересной. Побочные квесты, полуоткрытый мир, постройка билдов.\n\nСюжет игры не сказать что зацепил меня, так сказать есть и ладно.\n\nПлюсы: Оптимизация, геймплей\nМинусы: Игрушка не новая так что бывает что допустим тот-же FOV поставить нельзя, да и бывают проблемы с герцовкой монитора (почему-то не ставится). \n\nИтог: Советую пройти игру тем, кто ещё не пробовал данный жанр',1,0,'2026-05-21 12:39:15',1208,34,83,'active',NULL,NULL),(40,'Идеальный лутер-шутер','Почему-же Borderlands 2 - Идеальный лутер-шутер. Всё просто, разработчики взяли лучшие аспекты первой части, доработали и привнесли что-то новое.\n\nСюжет у игры стал получше, визуальный стиль ещё больше стал затягивать. Геймплей доработали, добавили ещё больше оружия и билдов. Особенно мне запомнился разговаривающий дробовик.\n\nПлюсы: Геймплей, Визуальный стиль\nМинусы: Всё ещё присутствуют однотипные квесты по типу убей 10 таких-то врагов, но это больше не минус, а скорее моя претензия',2,0,'2026-05-21 12:46:20',1209,34,84,'active',NULL,NULL),(41,'Для компании то что нужно','Borderlands: The Pre-Sequel - события разворачиваются между первой и второй частями игры. Да может быть эта часть игры получилось не как первые две, но всё же она мне понравилась. В компании было весело играть, а особенно когда ты практически проходишь игру без прокачки перса и оружия. \n\nФинальная битва у нас заняла около 2 - 3 часов, хахах да всё так и было. Мы практически не прокачивали навыки, не собирали оружие и именно поэтому нам было так тяжко. Но это и запомнилось мне больше всего. Посиделки в клубе под музыку и многое другое сделали наше прохождение весёлым и интересным.',2,0,'2026-05-21 12:51:40',1210,34,85,'active',NULL,NULL);
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
  `image_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Именно varchar поскольку api отдаётstring',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Поле для ручного добавления скриншота',
  PRIMARY KEY (`idScreenshot`),
  UNIQUE KEY `image_url` (`image_url`),
  KEY `fk_game_screenshot` (`game_id`),
  CONSTRAINT `fk_game_screenshot` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1782 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screenshots`
--

LOCK TABLES `screenshots` WRITE;
/*!40000 ALTER TABLE `screenshots` DISABLE KEYS */;
INSERT INTO `screenshots` VALUES (1427,1138,'sc81fj',NULL),(1428,1138,'sc81fh',NULL),(1429,1138,'sc81ff',NULL),(1430,1138,'sc81fl',NULL),(1431,1138,'sc81fn',NULL),(1432,1139,'farvemmmxav0bgt6wx7t',NULL),(1433,1139,'z5t0yuhyiiui1ickwhgj',NULL),(1434,1139,'em1y2ugcwy2myuhvb9db',NULL),(1435,1139,'usxccsncekxg0wd1v6ee',NULL),(1436,1139,'mnljdjtrh44x4snmierh',NULL),(1437,1140,'scagdm',NULL),(1438,1140,'scagdn',NULL),(1439,1140,'scagdo',NULL),(1440,1140,'scagdp',NULL),(1441,1140,'scagdq',NULL),(1442,1141,'lqz37tmv2r4lcjaxczwx',NULL),(1443,1141,'iqzfweidhwepz0bf4fhr',NULL),(1444,1141,'oz4rxwu528bmckp1qqzt',NULL),(1445,1141,'wdzisarwedjsqeg5iah4',NULL),(1446,1141,'d64boffz2tkso1cuj1lk',NULL),(1452,1143,'xegpfnsvlyeld0zkjnrc',NULL),(1453,1143,'c9xalka7stjkx4mes7kp',NULL),(1454,1143,'dhw6ucx9laj5esv6rngn',NULL),(1455,1143,'tdxv4zzkqyjnm9pmwxw0',NULL),(1456,1143,'qg7gx276z3hsqlr9xpt6',NULL),(1457,1144,'scxnly',NULL),(1458,1144,'scxnlz',NULL),(1459,1144,'scxnm0',NULL),(1460,1144,'scxnm1',NULL),(1461,1144,'scxnm2',NULL),(1462,1145,'jgfwlctsfh8yljnjdeab',NULL),(1463,1145,'vqxtn7qqv5qns9pneqzm',NULL),(1464,1145,'qfml0sjrmeiv5gf6tgg1',NULL),(1465,1145,'i53pbmgl9oga7zmqchqw',NULL),(1466,1145,'ftni2bw4ygi0eyaqo2hv',NULL),(1467,1146,'sc6vob',NULL),(1468,1146,'sc6vo9',NULL),(1469,1146,'sc6vo7',NULL),(1470,1146,'scj1il',NULL),(1471,1146,'scj1im',NULL),(1472,1147,'k9vp7u6khokwawwctcgc',NULL),(1473,1147,'tow7qunrq6rvwouracii',NULL),(1474,1147,'hlev27g508rkq1prpghw',NULL),(1475,1147,'gin55k9eyfq8udk0taym',NULL),(1476,1147,'pm074uf0po31urbrjyxz',NULL),(1477,1148,'sckj69',NULL),(1478,1148,'sckj6a',NULL),(1479,1148,'sckj6b',NULL),(1480,1148,'sckj6c',NULL),(1481,1148,'sckj6d',NULL),(1487,1150,'rm35ytrytuka9qkylqyk',NULL),(1488,1150,'ywrkjcrbeemmb51flsfj',NULL),(1489,1150,'qseegzssgetrybgbplrv',NULL),(1490,1150,'jvdoaxza3cawklvof1sl',NULL),(1491,1150,'gpt3d0gpue5mat4kkso6',NULL),(1492,1151,'mussjiqbllmh1lxkavc4',NULL),(1493,1151,'tip6pqunpn88oufxkl05',NULL),(1494,1151,'tgy8bav1xegsdkjcwce2',NULL),(1495,1151,'lw052zlyygibyccnh8re',NULL),(1496,1151,'arzyywgcajea7r1bbjbt',NULL),(1497,1152,'p3svrq6ewzxnn7p1a3v9',NULL),(1498,1152,'ityinxmtkakwbokpcwws',NULL),(1499,1152,'bkgxmg2m4h8wf5g9tblh',NULL),(1500,1152,'a3f72xprqkfuqdmha5ks',NULL),(1501,1152,'q634ullxbvipm6q6mcq9',NULL),(1502,1153,'sc8e1z',NULL),(1503,1153,'sc8e20',NULL),(1504,1153,'sc8e21',NULL),(1505,1153,'sc8e1y',NULL),(1506,1153,'sc8e22',NULL),(1507,1154,'uqmif3sshdrbbcd0pu8l',NULL),(1508,1154,'adssvwsfbaxcrucjolv9',NULL),(1509,1154,'hc9nb80b0xni5wxm5zh3',NULL),(1510,1154,'aokcsspzrqyaaoug7jnn',NULL),(1511,1154,'bklmdxphzoflbgtushg0',NULL),(1512,1155,'sckeaj',NULL),(1513,1155,'sckeak',NULL),(1514,1155,'sckeal',NULL),(1515,1155,'sckeam',NULL),(1516,1155,'sckeae',NULL),(1517,1156,'k22nwxzx6eb4ek7xbjps',NULL),(1518,1156,'xsdmofyywtzsgrcadaym',NULL),(1519,1156,'gzp0z0rcwlw3symd33gy',NULL),(1520,1156,'wvtfwo7zwey0j3mzvlbv',NULL),(1521,1156,'bk0fi4frntydsqma0g0q',NULL),(1522,1157,'i9ys3zdhph1mh3futdit',NULL),(1523,1157,'rvrge8js7xnhr4z1vrbk',NULL),(1524,1157,'m4hdhjptmmwvrjbojzp0',NULL),(1525,1157,'cmxaa4r52exlqvzwtxkh',NULL),(1526,1157,'vghkwbdabx0cri7thb9y',NULL),(1527,1158,'sc8915',NULL),(1528,1158,'sc8917',NULL),(1529,1158,'sc8916',NULL),(1530,1158,'sc8919',NULL),(1531,1158,'sc891b',NULL),(1532,1159,'scd71v',NULL),(1533,1159,'scd71w',NULL),(1534,1159,'scd71x',NULL),(1535,1159,'scd71y',NULL),(1536,1159,'scd71z',NULL),(1537,1160,'fn1wbuvikoacxt4zvfxl',NULL),(1538,1160,'b41umzxjcehm8fozl3gf',NULL),(1539,1160,'qwytrspu8brvow9x9y15',NULL),(1540,1160,'rtu8k7vm5x4mw5hilh2z',NULL),(1541,1160,'tqt0sxjytiovh3g96cl0',NULL),(1542,1161,'scj0v9',NULL),(1543,1161,'scj0vg',NULL),(1544,1161,'scj0vf',NULL),(1545,1161,'scj0va',NULL),(1546,1161,'scj0vb',NULL),(1547,1162,'schnqk',NULL),(1548,1162,'schnql',NULL),(1549,1162,'schmzc',NULL),(1550,1162,'schmzd',NULL),(1551,1162,'schmze',NULL),(1552,1163,'mpphkihhk8yh9m2zaafd',NULL),(1553,1163,'iau5t12jemoelx0xuzna',NULL),(1554,1163,'muyxb9cljgsy245fcimx',NULL),(1555,1163,'nnlfbf8blflrlmuarfej',NULL),(1556,1163,'ga0lj5zqeqd7moyzxij9',NULL),(1557,1164,'meykaqey1soxhtcpawbk',NULL),(1558,1164,'tr3gnlvwjny4hhoxohjf',NULL),(1559,1164,'h4j196xtabauif8kfyzk',NULL),(1560,1164,'u5wjmqgocr56mbjiy39o',NULL),(1561,1164,'t6sbntrryrakyhizdoab',NULL),(1562,1165,'eswubyh9h3uereuyumjq',NULL),(1563,1165,'e11zpyhhjc9qdqgrx7v0',NULL),(1564,1165,'hircn6ewsgu70ynlzis5',NULL),(1565,1165,'sojdbdt93e06wojplpsj',NULL),(1566,1165,'dbbtmdz0q1536npbpr5o',NULL),(1567,1166,'gzkc9kfusk2qss9vnuj4',NULL),(1568,1166,'m5ytymipeljiatfrblhs',NULL),(1569,1166,'bgmyc8eupb0coy0giatf',NULL),(1570,1166,'banme9peksg7gcxr26oa',NULL),(1571,1166,'et43nztghwnyzqd0br9q',NULL),(1572,1168,'smay0rol1vbibwop2t7n',NULL),(1573,1168,'cmootzhyx1l7scxeihej',NULL),(1574,1168,'sn1rmqcvrwomyuttaoyq',NULL),(1575,1168,'ocxemodvr6oa72argpyo',NULL),(1576,1168,'jjn6e6ivua5u142iukql',NULL),(1577,1169,'hjnzngnrtwr82jzmmkef',NULL),(1578,1169,'n3t2agwuxlqggp3kryf9',NULL),(1579,1169,'o7q3ikzmkjxbftrd64ok',NULL),(1580,1169,'eepecmqsq6uqxiaukar1',NULL),(1581,1169,'vfdeo6kgu0o4cyzd0sng',NULL),(1582,1170,'sc8lik',NULL),(1583,1170,'sc8lim',NULL),(1584,1170,'sc8lin',NULL),(1585,1170,'sc8lij',NULL),(1586,1170,'sc8lil',NULL),(1592,1172,'q7homzi5rjybswimfakb',NULL),(1593,1172,'eaj8ukcnb9pqrupxxr5g',NULL),(1594,1172,'dn5pz8gvd4jobsqrcjy3',NULL),(1595,1172,'kb2l3ty0uwvktogoiicx',NULL),(1596,1172,'b8hdl5qreh7cnce6ste8',NULL),(1599,1174,'sc7frs',NULL),(1600,1174,'sc7fru',NULL),(1601,1174,'sc87le',NULL),(1602,1174,'sc87lf',NULL),(1603,1174,'sct0am',NULL),(1604,1176,'zuia09etftbctjuxlkm2',NULL),(1605,1176,'gwzz1tjttrjdgoqokvdo',NULL),(1606,1176,'xrfbfmwnkacej9twdyuv',NULL),(1607,1176,'axfa10t9md3bcqvdyxlk',NULL),(1608,1176,'rgh8d9ockrwnduixjc5d',NULL),(1614,1178,'chl4alkzxbuhpxrfsb27',NULL),(1615,1178,'mp4ovdbufhflc8yrz43r',NULL),(1616,1178,'shfbucl9tk6qrm1trkg3',NULL),(1617,1178,'bzbqe7ezz9z6nj9tsx3t',NULL),(1618,1178,'arky3zlafy3uleroq3z5',NULL),(1619,1179,'qgcn3akcfv4rvojqdbvb',NULL),(1620,1179,'tznt5qzxdqdzqxsy1crl',NULL),(1621,1179,'kcapvog4g7ko1n21x57t',NULL),(1622,1179,'kmbewcsuuytnsxvemltw',NULL),(1623,1179,'tcgnbkmz7f0tgglfol9m',NULL),(1629,1181,'scj1a6',NULL),(1630,1181,'scj19z',NULL),(1631,1181,'scj1a0',NULL),(1632,1181,'scj1a1',NULL),(1633,1181,'scj1a2',NULL),(1651,1186,'vle5aurbgpszueahjpng',NULL),(1652,1186,'y8hfgmvpa4cfiigzp7px',NULL),(1653,1186,'wiaemy9tvcghaxhdwise',NULL),(1654,1186,'lixunrfynbqpnbmf4eqr',NULL),(1655,1186,'il4jraotz45isic3z6wp',NULL),(1656,1187,'opsy0q92riwnnsmvumja',NULL),(1657,1187,'lykfms7zl20y2wlkaji7',NULL),(1658,1187,'heyxlphesv7cpuml9ids',NULL),(1659,1187,'lffd1zevma6zyflxgojh',NULL),(1660,1187,'zchu45pjxufkppw5veux',NULL),(1661,1188,'scjgji',NULL),(1662,1188,'scjgjj',NULL),(1663,1188,'scjgjk',NULL),(1664,1188,'scjgjl',NULL),(1665,1188,'scjgjm',NULL),(1666,1189,'sc8cg4',NULL),(1667,1189,'sc8cg5',NULL),(1668,1189,'sc8cg6',NULL),(1669,1189,'sc8cg7',NULL),(1670,1190,'g7gj1dq82qv2wvv3izxg',NULL),(1671,1190,'gket6hnfqf2o6btpluck',NULL),(1672,1190,'feem9stvuzbeuhue9itk',NULL),(1673,1190,'tuxvvb4tqnnnatdy4c4b',NULL),(1674,1190,'utk6olfwdeqkw7bwxbd7',NULL),(1675,1191,'scznq9',NULL),(1676,1191,'scznqa',NULL),(1677,1192,'rdsm1mvbg5tgcpnb6ptz',NULL),(1678,1192,'gs9t4krjtweyzyh02yle',NULL),(1679,1192,'k74gnfibbbrjphfmzcqd',NULL),(1680,1192,'qyjlxhmghgdwyur7ptk3',NULL),(1681,1192,'xdyb6fjatrbenezshv9k',NULL),(1682,1193,'yvbeukf7akfc2fkkzpmc',NULL),(1683,1193,'mxscclds496mp4wqrhje',NULL),(1684,1193,'o3bjopus7brxrqxqal3m',NULL),(1685,1193,'vibjzy3bhdkevvz31cte',NULL),(1686,1193,'u9z3xj0m1nragrlxnene',NULL),(1687,1194,NULL,'games/screenshots/1779308674974-i1vru2cat.jpg'),(1688,1194,NULL,'games/screenshots/1779308674987-n9z8rjovn.jpg'),(1689,1194,NULL,'games/screenshots/1779308674993-olvim8zkc.jpg'),(1690,1194,NULL,'games/screenshots/1779308675004-jyw7qed45.jpg'),(1691,1195,'f4stmmaz0damsllwwmnz',NULL),(1692,1195,'b8p42cvdrnzg0czlm3js',NULL),(1693,1195,'bd114fpqp3d9l3n4sre0',NULL),(1694,1195,'whgl6wi39lv8u5w89o63',NULL),(1695,1195,'e3uewyuh6wbgj52z6h5r',NULL),(1696,1196,'sc105d7',NULL),(1697,1196,'sc105db',NULL),(1698,1196,'sc105dc',NULL),(1699,1196,'sc105da',NULL),(1700,1196,'sc105dd',NULL),(1701,1197,'scj1iw',NULL),(1702,1197,'scj1ix',NULL),(1703,1197,'scj1iy',NULL),(1704,1197,'scj1iu',NULL),(1705,1197,'scj1iv',NULL),(1706,1198,NULL,'games/screenshots/1779314330551-qgbhephle.jpg'),(1707,1198,NULL,'games/screenshots/1779314330558-0oioynpmj.jpg'),(1708,1198,NULL,'games/screenshots/1779314330565-cwuz2rvgu.webp'),(1709,1198,NULL,'games/screenshots/1779314330571-8rfyyvrcy.jpg'),(1710,1199,'l2d3w5bt2mfpwxp84xs0',NULL),(1711,1199,'cwjli17pk0x9qk4af1dc',NULL),(1712,1199,'xvuh525qyxihrn8bnru0',NULL),(1713,1199,'wad51g1rxhpwmkmbzyoi',NULL),(1714,1199,'gyyicpkwuffdypssnuc2',NULL),(1715,1200,'sc10f9e',NULL),(1716,1200,'sc10f9f',NULL),(1717,1200,'sc10f9g',NULL),(1718,1200,'sc10f9h',NULL),(1719,1200,'sc10f9i',NULL),(1725,1203,NULL,'games/screenshots/1779315882162-ejksm9vhy.jpg'),(1726,1203,NULL,'games/screenshots/1779315882173-bsjc9xl8h.jpg'),(1727,1203,NULL,'games/screenshots/1779315882189-sl4j3ot4r.jpg'),(1728,1203,NULL,'games/screenshots/1779315882199-em46fs6x5.jpg'),(1729,1204,'jor6dorsicjvchvmgjns',NULL),(1730,1204,'tegtkthlpmsdgyvmifoj',NULL),(1731,1204,'e19uknd7vy6njogo4mhv',NULL),(1732,1204,'egqpnmow9jsoi2yhpdgj',NULL),(1733,1204,'m0awrdzw395rntovj2sg',NULL),(1734,1205,'sc8v6a',NULL),(1735,1205,'sc8v6b',NULL),(1736,1205,'sc8v6c',NULL),(1737,1205,'sc8v6d',NULL),(1738,1205,'sctjbq',NULL),(1739,1206,'schdgn',NULL),(1740,1206,'schdgi',NULL),(1741,1206,'schdgj',NULL),(1742,1206,'schdgk',NULL),(1743,1206,'schdgl',NULL),(1744,1207,'scqubw',NULL),(1745,1207,'scqubx',NULL),(1746,1207,'scquby',NULL),(1747,1207,'scqubz',NULL),(1748,1208,'ncdxymc01khbijcrzak2',NULL),(1749,1208,'eil7fkii3rbettbh9bgp',NULL),(1750,1208,'ksqlljhqizbhocmflgrd',NULL),(1751,1208,'xolsvffcjdamjrgslfny',NULL),(1752,1208,'miudghxqpvczuzzzqdec',NULL),(1753,1209,'ithhctwgt8rsxbxe5uy5',NULL),(1754,1209,'eocdvaynboqmud9hmysu',NULL),(1755,1209,'bz4asonezfuq945jg1qr',NULL),(1756,1209,'ixynqzoedwo8vc5nzqma',NULL),(1757,1209,'balxsfafzeyy3ki3sc0z',NULL),(1758,1210,'h4fjlbicz4rulqbagzat',NULL),(1759,1210,'v3os5wukzqgogxukbe4z',NULL),(1760,1210,'kxi9xccobbqk8gmomp9h',NULL),(1761,1210,'a0ooiqnuzsdcsetwqvot',NULL),(1762,1210,'nqvvqpna2vbzxejszoyz',NULL),(1763,1211,'sc5dvctnt695tqwiwfnb',NULL),(1764,1211,'t8reggdvdnzhb4w95xkp',NULL),(1765,1211,'ubvhxnmshoao287xvool',NULL),(1766,1211,'jotobwlm4bgaoa95hrqn',NULL),(1767,1212,'nhpwrjyne8pqute0jbsh',NULL),(1768,1212,'lllbxcbnjnwdtjxpa16n',NULL),(1769,1212,'xbqeunra9radrziwlan0',NULL),(1770,1212,'iputhrachavaorhw95oi',NULL),(1771,1212,'kglumupggmpm5kosbrjb',NULL),(1772,1213,'s0moeyvaasjdhtzlzqjm',NULL),(1773,1213,'cgqoxefpdoljhk7etaqz',NULL),(1774,1213,'ub6bbsdznpv8rcmzlnmx',NULL),(1775,1213,'jfy3ju7dwgwjwjuyqs5b',NULL),(1776,1213,'gujamu6mgufkf8izkfpf',NULL),(1777,1214,'ohmqa8lcyzfjrewwzaoa',NULL),(1778,1214,'bxe4cmpzugebdkod49ut',NULL),(1779,1214,'yenk3jy37oh5eelqgdq9',NULL),(1780,1214,'vfcseimn1ywyn9zlcehv',NULL),(1781,1214,'b67vj6myt6lryfnghfxh',NULL);
/*!40000 ALTER TABLE `screenshots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `selectiongames`
--

DROP TABLE IF EXISTS `selectiongames`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selectiongames` (
  `selection_id` int NOT NULL,
  `game_id` int NOT NULL,
  `sort_order` int DEFAULT '0',
  PRIMARY KEY (`selection_id`,`game_id`),
  KEY `game_id` (`game_id`),
  CONSTRAINT `selectiongames_ibfk_1` FOREIGN KEY (`selection_id`) REFERENCES `selections` (`idSelection`) ON DELETE CASCADE,
  CONSTRAINT `selectiongames_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `selectiongames`
--

LOCK TABLES `selectiongames` WRITE;
/*!40000 ALTER TABLE `selectiongames` DISABLE KEYS */;
/*!40000 ALTER TABLE `selectiongames` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `selections`
--

DROP TABLE IF EXISTS `selections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selections` (
  `idSelection` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `views_count` int NOT NULL DEFAULT '0',
  `comments_count` int NOT NULL DEFAULT '0',
  `status` varchar(45) NOT NULL DEFAULT 'approved',
  `author_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idSelection`),
  KEY `fk_selection_author` (`author_id`),
  CONSTRAINT `fk_selection_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `selections`
--

LOCK TABLES `selections` WRITE;
/*!40000 ALTER TABLE `selections` DISABLE KEYS */;
/*!40000 ALTER TABLE `selections` ENABLE KEYS */;
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
-- Table structure for table `usercollections`
--

DROP TABLE IF EXISTS `usercollections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usercollections` (
  `idCollection` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `game_id` int NOT NULL,
  `collection_type` varchar(45) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idCollection`),
  UNIQUE KEY `unique_user_game_type` (`user_id`,`game_id`,`collection_type`),
  KEY `game_id` (`game_id`),
  KEY `idx_user_game` (`user_id`,`game_id`),
  CONSTRAINT `usercollections_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`),
  CONSTRAINT `usercollections_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `games` (`idGame`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usercollections`
--

LOCK TABLES `usercollections` WRITE;
/*!40000 ALTER TABLE `usercollections` DISABLE KEYS */;
INSERT INTO `usercollections` VALUES (53,34,1192,'Пройденные','2026-05-20 19:29:57'),(54,34,1193,'Пройденные','2026-05-20 20:03:40'),(55,34,1194,'Пройденные','2026-05-20 20:35:48'),(56,34,1165,'Пройденные','2026-05-20 20:35:56'),(57,34,1195,'Пройденные','2026-05-20 21:12:01'),(58,34,1197,'Заброшено','2026-05-20 21:46:50'),(59,34,1198,'Пройденные','2026-05-20 22:01:20'),(60,34,1199,'Пройденные','2026-05-20 22:06:55'),(61,34,1202,'Пройденные','2026-05-20 22:13:55'),(62,34,1203,'Пройденные','2026-05-20 22:26:33'),(63,34,1200,'Пройденные','2026-05-20 22:27:28'),(64,34,1196,'Пройденные','2026-05-20 22:27:35'),(65,34,1204,'Пройденные','2026-05-21 10:42:06'),(66,34,1205,'Пройденные','2026-05-21 11:21:25'),(67,34,1206,'Заброшено','2026-05-21 11:38:21'),(68,34,1207,'Пройденные','2026-05-21 11:54:18'),(69,34,1208,'Пройденные','2026-05-21 12:31:54'),(70,34,1209,'Пройденные','2026-05-21 12:31:56'),(71,34,1210,'Пройденные','2026-05-21 12:46:29'),(72,34,1211,'Пройденные','2026-05-21 21:58:45');
/*!40000 ALTER TABLE `usercollections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userrestrictions`
--

DROP TABLE IF EXISTS `userrestrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userrestrictions` (
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
  CONSTRAINT `userrestrictions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`idUser`) ON DELETE CASCADE,
  CONSTRAINT `userrestrictions_ibfk_2` FOREIGN KEY (`moderated_by`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userrestrictions`
--

LOCK TABLES `userrestrictions` WRITE;
/*!40000 ALTER TABLE `userrestrictions` DISABLE KEYS */;
INSERT INTO `userrestrictions` VALUES (13,34,'review',NULL,'Просто даун и всё',33,'2026-05-19 21:12:52');
/*!40000 ALTER TABLE `userrestrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `idUser` int NOT NULL AUTO_INCREMENT,
  `nickname` varchar(45) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `avatar_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `banner_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `role_id` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`idUser`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nickname`),
  KEY `fk_users_role` (`role_id`),
  KEY `idx_users_nickname` (`nickname`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`idRole`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (33,'egacwqgfgp','dym_master_tv@mail.ru','$2b$10$W6eHfWRaoFCDYEZ9AAHEW.0vNXF1W6wJ6ogYWu68M8sHdjX3Hgpi.','2026-05-19 19:07:34',NULL,NULL,3),(34,'Cl0WN1CH','dym_mastertv@mail.ru','$2b$10$TDtBhTbsmDTsXkrDt3uWoeBGKENstv34QEyJIS90vH4ch4C9uMzou','2026-05-19 19:12:13','avatars/1779225538771-twjt5gir3.gif','banners/1779278056265-n2hx0c344.gif',4),(35,'nfa4cp','renbl321_x@mail.ru','$2b$10$rXWPgs6WjzotU8BWy3XYyOCKWxI8x5BrRRYMc4MOZEzxuSSLKrl22','2026-05-21 15:17:17',NULL,NULL,1);
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

-- Dump completed on 2026-05-22 15:28:52
