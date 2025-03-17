-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Vært: mysql87.unoeuro.com
-- Genereringstid: 16. 03 2025 kl. 18:42:03
-- Serverversion: 8.0.37-29
-- PHP-version: 8.1.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `avanha_dk_db_drp`
--

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `afdelinger`
--

CREATE TABLE `afdelinger` (
  `afdelingID` int NOT NULL,
  `afdeling` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `order_number` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Data dump for tabellen `afdelinger`
--

INSERT INTO `afdelinger` (`afdelingID`, `afdeling`, `order_number`) VALUES
(1, 'Patruljeafdeling', 1),
(2, 'Efterforskning', 2),
(3, 'Kriminalteknisk afdeling', 3),
(4, 'Indsatsleder', 4),
(5, 'Motorcykelbetjente', 5),
(6, 'Helikopterenhed', 6),
(7, 'Civil afdeling', 7),
(8, 'Reaktionsenheden', 8),
(9, 'Bankrøveri task force', 9),
(10, 'Uddannelsesafdeling', 10),
(11, 'Razzia team', 11),
(35, 'Dommer', 7),
(36, 'Advokatledelse', 6);

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `afdelinger_ems`
--

CREATE TABLE `afdelinger_ems` (
  `afdelingID` int NOT NULL,
  `afdeling` varchar(255) NOT NULL,
  `order_number` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Data dump for tabellen `afdelinger_ems`
--

INSERT INTO `afdelinger_ems` (`afdelingID`, `afdeling`, `order_number`) VALUES
(1, 'Akutafdeling', 1),
(2, 'Traumecenter', 2),
(3, 'Ambulanceafdeling', 3),
(4, 'Intensivafdeling', 4),
(5, 'Hjælperteam', 5),
(6, 'Helikopterenhed', 6),
(7, 'Træning og uddannelse', 7),
(8, 'Nødbehandling', 8),
(9, 'Psykologisk støtteafdeling', 9),
(10, 'Katastrofeberedskab', 10),
(11, 'Ressourceforvaltning', 11);

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `dailyreport`
--

CREATE TABLE `dailyreport` (
  `id` int NOT NULL,
  `dato` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(255) NOT NULL,
  `kommentar` longtext NOT NULL,
  `titel` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `gangs`
--

CREATE TABLE `gangs` (
  `id` int NOT NULL,
  `gang_name` varchar(255) NOT NULL,
  `order_number` int NOT NULL DEFAULT '0',
  `created_by` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Data dump for tabellen `gangs`
--


-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `housing`
--

CREATE TABLE `housing` (
  `id` int NOT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `entry` json DEFAULT NULL,
  `ownername` varchar(50) DEFAULT NULL,
  `slet` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `licenses`
--

CREATE TABLE `licenses` (
  `id` int NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `license_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `licenses_subjects`
--

CREATE TABLE `licenses_subjects` (
  `id` int NOT NULL,
  `license_emne` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `order_number` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `locations`
--

CREATE TABLE `locations` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `coords` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Data dump for tabellen `locations`
--


-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `population`
--

CREATE TABLE `population` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `dob` varchar(255) NOT NULL,
  `height` int NOT NULL,
  `sex` varchar(255) NOT NULL,
  `phone_number` int NOT NULL,
  `gang` varchar(255) DEFAULT NULL,
  `note` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Data dump for tabellen `population`
--


-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `population_cases`
--

CREATE TABLE `population_cases` (
  `id` int NOT NULL,
  `dato` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pid` int NOT NULL,
  `userid` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `sigtet` longtext NOT NULL,
  `ticket` int NOT NULL,
  `prison` int NOT NULL,
  `klip` int NOT NULL,
  `status` varchar(255) NOT NULL,
  `comment` longtext NOT NULL,
  `cases` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `erkender` tinyint DEFAULT '0',
  `conditional` tinyint DEFAULT '0'
) ;

--
-- Data dump for tabellen `population_cases`
--


-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `population_ems`
--

CREATE TABLE `population_ems` (
  `id` int NOT NULL,
  `steamid` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `dob` varchar(255) NOT NULL,
  `height` int NOT NULL,
  `sex` varchar(255) NOT NULL,
  `phone_number` int NOT NULL,
  `note` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `population_journals`
--

CREATE TABLE `population_journals` (
  `id` int NOT NULL,
  `dato` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pid` int NOT NULL,
  `userid` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `arrival` varchar(255) NOT NULL,
  `damage_report` longtext NOT NULL,
  `treatment_before_arrival` longtext NOT NULL,
  `condition_at_arrival_resp` longtext NOT NULL,
  `condition_at_arrival_cirk` longtext NOT NULL,
  `condition_at_arrival_bleed` longtext NOT NULL,
  `condition_at_arrival_pain` longtext NOT NULL,
  `damage_assessment` longtext NOT NULL,
  `follow_up_treatment` longtext NOT NULL,
  `recept_given` varchar(255) NOT NULL,
  `medicin_given` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `population_psykjournals`
--

CREATE TABLE `population_psykjournals` (
  `id` int NOT NULL,
  `dato` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pid` int NOT NULL,
  `userid` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `reason` longtext NOT NULL,
  `epikrise` longtext NOT NULL,
  `conversation` longtext NOT NULL,
  `medicin_treatment` longtext NOT NULL,
  `psykolog_assessment` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `population_vehicles`
--

CREATE TABLE `population_vehicles` (
  `id` int NOT NULL,
  `dato` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(255) NOT NULL,
  `plate` varchar(255) NOT NULL,
  `reason` longtext NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `owner` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Data dump for tabellen `population_vehicles`
--


-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `population_wanted`
--

CREATE TABLE `population_wanted` (
  `id` int NOT NULL,
  `dato` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(255) NOT NULL,
  `target_id` int NOT NULL,
  `sigtet` longtext NOT NULL,
  `reason` longtext NOT NULL,
  `ticket` int NOT NULL,
  `prison` int NOT NULL,
  `frakendelse` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `klip` int DEFAULT '0',
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Data dump for tabellen `population_wanted`
--

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `punishment`
--

CREATE TABLE `punishment` (
  `id` int NOT NULL,
  `ticketemne` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `order_number` int NOT NULL,
  `hasPrison` tinyint(1) NOT NULL DEFAULT '0',
  `hasVehicle` tinyint(1) NOT NULL DEFAULT '0',
  `hasStoffer` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Data dump for tabellen `punishment`
--

INSERT INTO `punishment` (`id`, `ticketemne`, `order_number`, `hasPrison`, `hasVehicle`, `hasStoffer`) VALUES
(13, 'Færdselsloven', 1, 0, 0, 1),
(14, 'Straffeloven', 0, 1, 0, 0),
(15, 'Våben & kniv loven', 0, 1, 0, 0),
(16, 'Ordensbekendtgørelsen', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `tickets`
--

CREATE TABLE `tickets` (
  `id` int NOT NULL,
  `emne` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `paragraf` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sigtelse` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ticket` int NOT NULL,
  `klip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `frakendelse` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `information` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prison` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Data dump for tabellen `tickets`
--

INSERT INTO `tickets` (`id`, `emne`, `paragraf`, `sigtelse`, `ticket`, `klip`, `frakendelse`, `information`, `prison`) VALUES
(239, 'Færdselsloven', 'FL. §4, stk. 1', 'Kørsel frem mod rødt lyssignal', 2500, '1', 'Nej', '', '0'),
(240, 'Færdselsloven', 'FL. §4, stk. 1', 'Færdselstavle eller pile ikke respekteret', 1500, '0', 'Nej', '', '0'),
(241, 'Færdselsloven', 'FL. §4, stk. 1', 'Kørsel mod kørselsretning', 2500, '1', 'Nej', '', '0'),
(242, 'Færdselsloven', 'FL. §4, stk. 1', 'Overskredet spærrelinie ved overhaling', 2000, '1', 'Nej', '', '0'),
(243, 'Færdselsloven', 'FL. §6, stk. 1', 'Springe på eller hage sig fast i køretøj m.v./ophold på trinbræt', 700, '0', 'Nej', '', '0'),
(244, 'Færdselsloven', 'FL. §10, skt.  1-2 og 4-6', 'Færden over eller langs kørebanen m.v. (Ikke benytte fortov, fodgængerfelt m.v.)', 700, '0', 'Nej', '', '0'),
(245, 'Færdselsloven', 'FL. §15, stk. 1', 'Unladt at holde så langt til højre som muligt', 1500, '0', 'Nej', '', '0'),
(246, 'Færdselsloven', 'FL. §15, stk. 4', 'Unladt at køre højre om helleanlæg', 2500, '1', 'Nej', '', '0'),
(247, 'Færdselsloven', 'FL. §21, stk. 1', 'Foretaget overhaling højre om', 2500, '1', 'Nej', '', '0'),
(248, 'Færdselsloven', 'FL. §26, stk. 2', 'Ubetinget vigepligt (fuldt stop)', 2500, '1', 'Nej', '', '0'),
(249, 'Færdselsloven', 'FL. §28, stk. 4', 'Undladt at sikre køretøj', 1000, '0', 'Nej', '', '0'),
(250, 'Færdselsloven', 'FL. §33, stk. 1', 'Motorkøretøj eller knallert uden tændte lygter i lygtetændingstiden', 1000, '0', 'Nej', '', '0'),
(251, 'Færdselsloven', 'FL. §38', 'Unødig støj/røg m.v. (burnout)', 1000, '0', 'Nej', '', '0'),
(252, 'Færdselsloven', 'FL. §55 a', 'Benyttet håndholdt mobiltelefon under kørsel', 1500, '1', 'Nej', '', '0'),
(253, 'Færdselsloven', 'FL. §67, stk. 2', 'Køretøjs mangel/fejl', 1000, '0', 'Nej', '', '0'),
(254, 'Færdselsloven', 'FL. §9', 'Kørsel firbi ulykkessted uden at hjælpe', 7500, '0', 'Nej', '', '0'),
(255, 'Færdselsloven', 'FL. §15', 'Kørsel med kort afstand til forankørende', 2000, '0', 'Nej', '', '0'),
(256, 'Færdselsloven', 'FL. §33 stk. 7', 'Motorkøretøj eller knallert uden tændte lygter i lygtetændingstiden', 1000, '0', 'Nej', '', '0'),
(257, 'Færdselsloven', 'FL. §37 stk. 4', 'Kap eller væddeløbskørsel på offentlig vej', 2500, '0', 'Nej', '', '0'),
(258, 'Færdselsloven', 'FL. §41', 'Hasarderet kørsel', 5000, '1', 'Nej', '', '0'),
(259, 'Færdselsloven', 'FL. §41 stk. 2', 'Uansvarlig kørsel', 10000, '3', 'Ja', '', '0'),
(260, 'Færdselsloven', 'FL. §53/54', 'Kørsel i påvirket tilstand', 1500, '0', 'Ja', '', '0'),
(261, 'Færdselsloven', 'FL. §56 stk. 1', 'Kørsel uden medbringelse af kørekort', 1000, '0', 'Nej', '', '0'),
(262, 'Færdselsloven', 'FL. §56 stk. 1', 'Kørsel i frakendelsestiden 1. gang', 7500, '0', 'Nej', '', '0'),
(263, 'Færdselsloven', 'FL. §56 stk. 1', 'Kørsel i frakendelsestiden 2. gang', 15000, '0', 'Nej', '', '0'),
(264, 'Færdselsloven', 'FL. §56 stk. 1', 'Kørsel i frakendelsestiden 3. gang', 30000, '0', 'Nej', '', '0'),
(265, 'Færdselsloven', 'FL. §56 stk. 1', 'Kørsel ude førerret 1. gang', 5000, '0', 'Nej', '', '0'),
(266, 'Færdselsloven', 'FL. §56 stk. 1', 'Kørsel ude førerret 2. gang', 10000, '0', 'Nej', '', '0'),
(267, 'Færdselsloven', 'FL. §56 stk. 1', 'Kørsel ude førerret 3. gang', 15000, '0', 'Nej', '', '0'),
(268, 'Færdselsloven', 'FL. §81', 'Fædsel uden styrthjelm', 1500, '0', 'Nej', '', '0'),
(269, 'Færdselsloven', 'FL. §65 stk. 1 /  §118 stk. 2', 'Oplysningspligten', 3000, '0', 'Nej', '', '0'),
(270, 'Færdselsloven', 'FL. §66 stk. 1', 'Tonede ruder', 2500, '0', 'Nej', '', '0'),
(271, 'Færdselsloven', 'FL. §67 stk. 1', 'Udlån af køretøj til borger uden kørekort', 5000, '0', 'Nej', '', '0'),
(272, 'Færdselsloven', 'FL. 4 stk. 2', ' Kørsel frem mod rødt lyssignal på cykel', 1250, '0', 'Nej', '', '0'),
(273, 'Færdselsloven', '§ 14 a.', 'Cykling i fodgængerfeltet, på ortov eller gangsti', 700, '0', 'Nej', '', '0'),
(274, 'Færdselsloven', '§ 14 b.', 'Kørsel uden lys i lygtetændingstiden', 700, '0', 'Nej', '', '0'),
(275, 'Færdselsloven', '§ 14 c.', 'Nægter at respektere skilte og afmærkning på cykel', 700, '0', 'Nej', '', '0'),
(276, 'Færdselsloven', '§ 14 d.', 'Benyttet håndholdt mobiltelefon under cykling', 1000, '0', 'Nej', '', '0'),
(277, 'Færdselsloven', '§ 14 d.', 'Overtræde ubetinget vigepligt/fuldt stop cykel', 1000, '0', 'Nej', '', '0'),
(278, 'Færdselsloven', '§ 14 d.', 'Uansvarlig kørsel på cykel, grundet påvirkning af euforiserende stoffer/alkohol', 2500, '0', 'Nej', '', '0'),
(279, 'Straffeloven', 'SL. §199', 'Overfald på embedsmand', 20000, '0', 'Nej', '', '0'),
(280, 'Straffeloven', 'SL. §199', 'Trusler mod embedsmand', 10000, '0', 'Nej', '', '0'),
(281, 'Straffeloven', 'SL. §121', 'Fornærmelser/krænkelser mod embedsmand', 3500, '0', 'Nej', '', ''),
(282, 'Straffeloven', 'SL. §122', 'Forrsøgt bestikkelse af politiet', 10000, '0', 'Nej', '', '0'),
(283, 'Straffeloven', 'SL. §134 b', 'Maskering', 2500, '0', 'Nej', '', '0'),
(284, 'Straffeloven', 'SL. §135', 'Misbrug af nødopkald', 1500, '0', 'Nej', '', '0'),
(285, 'Straffeloven', 'SL. §162', 'Falske anklager', 7500, '0', 'Nej', '', '0'),
(286, 'Straffeloven', 'SL. §172', 'Identifikations forfalskning', 10000, '0', 'Nej', '', '0'),
(287, 'Straffeloven', 'SL. §237', 'Mord', 40000, '0', 'Nej', '', '0'),
(288, 'Straffeloven', 'SL. §237', 'Mordforsøg', 30000, '0', 'Nej', '', '0'),
(289, 'Straffeloven', 'SL. §237', 'Mord på embedsmand', 50000, '0', 'Nej', '', '0'),
(290, 'Straffeloven', 'SL. §237', 'Mordforsøg på embedsmand', 35000, '0', 'Nej', '', '0'),
(291, 'Straffeloven', 'SL. §241', 'Uagtsomt manddrab', 20000, '0', 'Nej', '', '0'),
(292, 'Straffeloven', 'SL. §244', 'Overfald', 15000, '0', 'Nej', '', '0'),
(293, 'Straffeloven', 'SL. §244', 'Overfald på borger med flydende væsker', 5000, '0', 'Nej', '', '0'),
(294, 'Straffeloven', 'SL. §252', 'Sætte andre folks liv i fare', 10000, '0', 'Nej', '', '0'),
(295, 'Straffeloven', 'SL. §253', 'Flugt fra færdselsuheld', 5000, '0', 'Nej', '', '0'),
(296, 'Straffeloven', 'SL. §261', 'Gidseltaging', 30000, '0', 'Nej', '', '0'),
(297, 'Straffeloven', 'SL. §261', 'Gidseltaging på embedsmand', 40000, '0', 'Nej', '', '0'),
(298, 'Straffeloven', 'SL. §264', ' Ulovlig indtrængen', 10000, '0', 'Nej', '', '0'),
(299, 'Straffeloven', 'SL. §266', 'Trusler', 7500, '0', 'Nej', '', '0'),
(300, 'Straffeloven', 'SL. §288', 'Bankrøveri', 100000, '0', 'Nej', '', '0'),
(301, 'Straffeloven', 'SL. §288', 'Butikstyveri', 20000, '0', 'Nej', '', '0'),
(302, 'Straffeloven', 'SL. §289', 'Besiddelse af sorte penge', 0, '0', 'Nej', '', '0'),
(303, 'Straffeloven', 'SL. §291', 'Hæreværk', 5000, '0', 'Nej', '', '0'),
(304, 'Straffeloven', 'SL. §293 a', 'Brugstyveri', 25000, '0', 'Nej', '', '0'),
(305, 'Straffeloven', 'SL. §124', 'Flugt fra politiet', 25000, '0', 'Nej', '', '0'),
(306, 'Straffeloven', 'SL. §252', 'Hensynsløs kørsel', 30000, '0', 'Nej', '', '0'),
(307, 'Straffeloven', 'SL. §232', 'Krænkende adfærd, herunder sexchikane', 15000, '0', 'Nej', '', '0'),
(308, 'Straffeloven', 'SL. §288', 'Røveri mod pengetransport', 33000, '0', 'Nej', '', '0'),
(309, 'Straffeloven', 'SL. §276', 'Inbrudstyveri', 10000, '0', 'Nej', '', '0'),
(310, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Assault Rifle', 500000, '0', 'Nej', '', ''),
(311, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Compact Rifle', 250000, '0', 'Nej', '', '0'),
(312, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Gussenberg', 250000, '0', 'Nej', '', '0'),
(313, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Micro SMG', 200000, '0', 'Nej', '', '0'),
(314, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Mini SMG', 200000, '0', 'Nej', '', '0'),
(315, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Tec-9', 200000, '0', 'Nej', '', '0'),
(316, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Desert Eagle', 170000, '0', 'Nej', '', '0'),
(317, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Sawed Off', 150000, '0', 'Nej', '', '0'),
(318, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Vintage Pistol', 100000, '0', 'Nej', '', '0'),
(319, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Pistol', 100000, '0', 'Nej', '', '0'),
(320, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af SNS Pistol', 50000, '0', 'Nej', '', '0'),
(321, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Stikvåben', 5000, '0', 'Nej', '', '0'),
(322, 'Våben & kniv loven', 'VL. §1', 'Besiddelse af Ammunition', 50, '0', 'Nej', '', '0'),
(323, 'Våben & kniv loven', 'VL. §1', 'Ulovlig obevaring af våben', 10000, '0', 'Nej', '', '0'),
(324, 'Ordensbekendtgørelsen', 'OB. §3', 'Nægter at efter komme politiets anvisninger', 5000, '0', 'Nej', '', '0'),
(325, 'Ordensbekendtgørelsen', 'OB. §3', 'Gadeuorden', 7500, '0', 'Nej', '', '0'),
(326, 'Ordensbekendtgørelsen', 'OB. §3', 'Voldelig optræden', 8000, '0', 'Nej', '', '0'),
(327, 'Ordensbekendtgørelsen', 'OB. §3', 'Voldelig optræden med slagsmål', 10000, '0', 'Nej', '', '0'),
(328, 'Ordensbekendtgørelsen', 'OB. §3', 'Upassende opførsel', 5000, '0', 'Nej', '', '0'),
(329, 'Ordensbekendtgørelsen', 'OB. §3', 'Ulovlige samkomster', 2500, '0', 'Nej', '', '0');

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `firstname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lastname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `job` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `afdeling` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `licenses` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `WebsiteAdmin` tinyint(1) NOT NULL,
  `phone_number` varchar(255) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `only_admin` tinyint(1) NOT NULL DEFAULT '0',
  `isOnDuty` int NOT NULL DEFAULT '1',
  `steamid` varchar(255) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `patrol_id` varchar(255) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `patrol_category` varchar(255) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `patrol_task` longtext COLLATE utf8mb4_danish_ci NOT NULL,
  `patrol_user_override` int NOT NULL DEFAULT '0',
  `hasGangAccess` tinyint(1) NOT NULL DEFAULT '0',
  `nickname` varchar(255) COLLATE utf8mb4_danish_ci NOT NULL DEFAULT '',
  `department` varchar(255) COLLATE utf8mb4_danish_ci NOT NULL DEFAULT 'none',
  `hasPdfPrivilege` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Data dump for tabellen `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `created_at`, `firstname`, `lastname`, `job`, `role`, `afdeling`, `licenses`, `WebsiteAdmin`, `phone_number`, `only_admin`, `isOnDuty`, `steamid`, `patrol_id`, `patrol_category`, `patrol_task`, `patrol_user_override`, `hasGangAccess`, `nickname`, `department`, `hasPdfPrivilege`) VALUES
(667, '00', '$2y$10$XTqSXmkwgGGMMUm2SdBFfOoqy.Sa1o6YxQkXNia1F9BN0dTsX0CBi', '2025-03-16 19:39:33', 'admin', 'admin', 'police', 'Elev', 'Patruljeafdeling', '', 1, NULL, 0, 1, NULL, NULL, NULL, '', 0, 0, '', 'none', 0);

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `users_ems`
--

CREATE TABLE `users_ems` (
  `id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `job` varchar(255) NOT NULL,
  `WebsiteAdmin` tinyint(1) NOT NULL DEFAULT '0',
  `role` varchar(255) NOT NULL,
  `afdeling` varchar(255) NOT NULL,
  `hasPsykologAccess` tinyint(1) NOT NULL DEFAULT '0',
  `only_admin` tinyint(1) NOT NULL DEFAULT '0',
  `isOnDuty` tinyint(1) NOT NULL DEFAULT '1',
  `steamid` varchar(255) DEFAULT NULL,
  `patrol_id` varchar(255) DEFAULT NULL,
  `patrol_category` varchar(255) DEFAULT NULL,
  `patrol_task` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Data dump for tabellen `users_ems`
--

INSERT INTO `users_ems` (`id`, `username`, `password`, `created_at`, `firstname`, `lastname`, `job`, `WebsiteAdmin`, `role`, `afdeling`, `hasPsykologAccess`, `only_admin`, `isOnDuty`, `steamid`, `patrol_id`, `patrol_category`, `patrol_task`) VALUES
(92, '00', '$2y$10$yBn4oBGQrRqFB93L/9KuGef/CZQnNcydwetb3N0SzQ/4iTgHCgVJS', '2025-03-16 19:43:41', 'admin', 'admin', 'ems', 1, 'Elev', 'Akutafdeling', 0, 0, 1, NULL, NULL, NULL, '');

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `wanted`
--

CREATE TABLE `wanted` (
  `id` int NOT NULL,
  `dato` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `target_id` int DEFAULT NULL,
  `target` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sigtet` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reason` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ticket` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prison` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `frakendelse` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `wanted_vehicles`
--

CREATE TABLE `wanted_vehicles` (
  `id` int NOT NULL,
  `dato` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(255) NOT NULL,
  `plate` varchar(255) NOT NULL,
  `reason` mediumtext NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Begrænsninger for dumpede tabeller
--

--
-- Indeks for tabel `afdelinger`
--
ALTER TABLE `afdelinger`
  ADD PRIMARY KEY (`afdelingID`);

--
-- Indeks for tabel `afdelinger_ems`
--
ALTER TABLE `afdelinger_ems`
  ADD PRIMARY KEY (`afdelingID`);

--
-- Indeks for tabel `dailyreport`
--
ALTER TABLE `dailyreport`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `gangs`
--
ALTER TABLE `gangs`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `housing`
--
ALTER TABLE `housing`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `licenses`
--
ALTER TABLE `licenses`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `licenses_subjects`
--
ALTER TABLE `licenses_subjects`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `population`
--
ALTER TABLE `population`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `population_cases`
--
ALTER TABLE `population_cases`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `population_ems`
--
ALTER TABLE `population_ems`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `population_journals`
--
ALTER TABLE `population_journals`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `population_psykjournals`
--
ALTER TABLE `population_psykjournals`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `population_vehicles`
--
ALTER TABLE `population_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `population_wanted`
--
ALTER TABLE `population_wanted`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `punishment`
--
ALTER TABLE `punishment`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`),
  ADD KEY `username_2` (`username`);

--
-- Indeks for tabel `users_ems`
--
ALTER TABLE `users_ems`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username_ems` (`username`);

--
-- Indeks for tabel `wanted`
--
ALTER TABLE `wanted`
  ADD PRIMARY KEY (`id`);

--
-- Indeks for tabel `wanted_vehicles`
--
ALTER TABLE `wanted_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Brug ikke AUTO_INCREMENT for slettede tabeller
--

--
-- Tilføj AUTO_INCREMENT i tabel `afdelinger`
--
ALTER TABLE `afdelinger`
  MODIFY `afdelingID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Tilføj AUTO_INCREMENT i tabel `afdelinger_ems`
--
ALTER TABLE `afdelinger_ems`
  MODIFY `afdelingID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Tilføj AUTO_INCREMENT i tabel `dailyreport`
--
ALTER TABLE `dailyreport`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=145;

--
-- Tilføj AUTO_INCREMENT i tabel `gangs`
--
ALTER TABLE `gangs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- Tilføj AUTO_INCREMENT i tabel `licenses`
--
ALTER TABLE `licenses`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Tilføj AUTO_INCREMENT i tabel `licenses_subjects`
--
ALTER TABLE `licenses_subjects`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Tilføj AUTO_INCREMENT i tabel `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Tilføj AUTO_INCREMENT i tabel `population`
--
ALTER TABLE `population`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1508;

--
-- Tilføj AUTO_INCREMENT i tabel `population_cases`
--
ALTER TABLE `population_cases`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Tilføj AUTO_INCREMENT i tabel `population_ems`
--
ALTER TABLE `population_ems`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=410;

--
-- Tilføj AUTO_INCREMENT i tabel `population_journals`
--
ALTER TABLE `population_journals`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=519;

--
-- Tilføj AUTO_INCREMENT i tabel `population_psykjournals`
--
ALTER TABLE `population_psykjournals`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tilføj AUTO_INCREMENT i tabel `population_vehicles`
--
ALTER TABLE `population_vehicles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=241;

--
-- Tilføj AUTO_INCREMENT i tabel `population_wanted`
--
ALTER TABLE `population_wanted`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=641;

--
-- Tilføj AUTO_INCREMENT i tabel `punishment`
--
ALTER TABLE `punishment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Tilføj AUTO_INCREMENT i tabel `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=330;

--
-- Tilføj AUTO_INCREMENT i tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=668;

--
-- Tilføj AUTO_INCREMENT i tabel `users_ems`
--
ALTER TABLE `users_ems`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- Tilføj AUTO_INCREMENT i tabel `wanted`
--
ALTER TABLE `wanted`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3387;

--
-- Tilføj AUTO_INCREMENT i tabel `wanted_vehicles`
--
ALTER TABLE `wanted_vehicles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=632;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
