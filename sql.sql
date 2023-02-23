-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 23 fév. 2023 à 18:44
-- Version du serveur : 10.4.27-MariaDB
-- Version de PHP : 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `apo`
--

-- --------------------------------------------------------

--
-- Structure de la table `clans`
--

CREATE TABLE `clans` (
  `idclan` int(11) NOT NULL,
  `clanname` varchar(24) NOT NULL,
  `Owner` varchar(24) NOT NULL,
  `maxrank` int(4) NOT NULL,
  `enterposx` float NOT NULL,
  `enterposy` float NOT NULL,
  `enterposz` float NOT NULL,
  `enterinterior` int(4) NOT NULL,
  `entervw` int(4) NOT NULL,
  `exitposx` float NOT NULL,
  `exitposy` float NOT NULL,
  `exitposz` float NOT NULL,
  `exitinterior` int(4) NOT NULL,
  `exitvw` int(4) NOT NULL,
  `chestposx` float NOT NULL,
  `chestposy` float NOT NULL,
  `chestposz` float NOT NULL,
  `clanexp0` int(4) NOT NULL,
  `clanexp1` int(4) NOT NULL,
  `clanexp2` int(4) NOT NULL,
  `clanexp3` int(4) NOT NULL,
  `clanexp4` int(4) NOT NULL,
  `inv0` int(4) NOT NULL,
  `inv1` int(4) NOT NULL,
  `inv2` int(4) NOT NULL,
  `inv3` int(4) NOT NULL,
  `inv4` int(4) NOT NULL,
  `inv5` int(4) NOT NULL,
  `inv6` int(4) NOT NULL,
  `inv7` int(4) NOT NULL,
  `inv8` int(4) NOT NULL,
  `inv9` int(4) NOT NULL,
  `inv10` int(4) NOT NULL,
  `inv11` int(4) NOT NULL,
  `inv12` int(4) NOT NULL,
  `inv13` int(4) NOT NULL,
  `inv14` int(4) NOT NULL,
  `inv15` int(4) NOT NULL,
  `inv16` int(4) NOT NULL,
  `inv17` int(4) NOT NULL,
  `inv18` int(4) NOT NULL,
  `inv19` int(4) NOT NULL,
  `inv20` int(4) NOT NULL,
  `inv21` int(4) NOT NULL,
  `inv22` int(4) NOT NULL,
  `inv23` int(4) NOT NULL,
  `inv24` int(4) NOT NULL,
  `inv25` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `clans`
--
-- --------------------------------------------------------

--
-- Structure de la table `dropwep`
--

CREATE TABLE `dropwep` (
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `posrx` float NOT NULL DEFAULT 93.7,
  `posry` float NOT NULL DEFAULT 120,
  `posrz` float NOT NULL DEFAULT 120,
  `gunid` int(4) NOT NULL,
  `gunammo` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `dropwep`
--

INSERT INTO `dropwep` (`posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`, `gunid`, `gunammo`) VALUES
(-3.796, 11.963, 2.117, 93.7, 120, 120, 363, 400);

-- --------------------------------------------------------

--
-- Structure de la table `objects`
--

CREATE TABLE `objects` (
  `objectsID` int(11) NOT NULL,
  `objectsModel` int(11) DEFAULT 0,
  `objectsX` float DEFAULT 0,
  `objectsY` float DEFAULT 0,
  `objectsZ` float DEFAULT 0,
  `objectsRX` float DEFAULT 0,
  `objectsRY` float DEFAULT 0,
  `objectsRZ` float DEFAULT 0,
  `objectsInterior` int(11) DEFAULT 0,
  `objectsWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `objects`
--

INSERT INTO `objects` (`objectsID`, `objectsModel`, `objectsX`, `objectsY`, `objectsZ`, `objectsRX`, `objectsRY`, `objectsRZ`, `objectsInterior`, `objectsWorld`) VALUES
(3, 19861, 8408.88, 14237.4, 8.6103, 0, 0, 90.2853, 0, 0),
(4, 11746, 7464.93, 14761, 1003.09, -5.1999, -4.5999, 174.962, 23, 0),
(6, 19302, 7464.93, 14760.4, 1003.22, 0, 0, 92.2947, 23, 0),
(7, 2944, 7464.81, 14761.2, 1003.46, 0, 0, 0.0306, 23, 0);

-- --------------------------------------------------------

--
-- Structure de la table `players`
--

CREATE TABLE `players` (
  `ID` int(10) NOT NULL,
  `Username` varchar(24) NOT NULL,
  `Password` varchar(129) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `Admin` int(10) NOT NULL,
  `VIP` int(10) NOT NULL,
  `Score` int(10) NOT NULL,
  `Life` float NOT NULL DEFAULT 100,
  `Armor` float NOT NULL,
  `skin` int(5) NOT NULL DEFAULT 5,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `interior` int(4) NOT NULL DEFAULT 0,
  `clanexp0` int(5) NOT NULL DEFAULT 0,
  `clanexp1` int(5) NOT NULL DEFAULT 0,
  `clanexp2` int(5) NOT NULL DEFAULT 0,
  `clanexp3` int(5) NOT NULL DEFAULT 0,
  `clanexp4` int(5) NOT NULL DEFAULT 0,
  `inv0` int(4) NOT NULL,
  `inv1` int(4) NOT NULL,
  `inv2` int(4) NOT NULL,
  `inv3` int(4) NOT NULL,
  `inv4` int(4) NOT NULL,
  `inv5` int(4) NOT NULL,
  `inv6` int(4) NOT NULL,
  `inv7` int(4) NOT NULL,
  `inv8` int(4) NOT NULL,
  `inv9` int(4) NOT NULL,
  `inv10` int(4) NOT NULL,
  `inv11` int(4) NOT NULL,
  `inv12` int(4) NOT NULL,
  `inv13` int(4) NOT NULL,
  `inv14` int(4) NOT NULL,
  `inv15` int(4) NOT NULL,
  `inv16` int(4) NOT NULL,
  `inv17` int(4) NOT NULL,
  `inv18` int(4) NOT NULL,
  `inv19` int(4) NOT NULL,
  `inv20` int(4) NOT NULL,
  `inv21` int(4) NOT NULL,
  `inv22` int(4) NOT NULL,
  `inv23` int(4) NOT NULL,
  `inv24` int(4) NOT NULL,
  `inv25` int(4) NOT NULL DEFAULT 0,
  `Weap0` int(4) NOT NULL DEFAULT 0,
  `AWeap0` int(4) NOT NULL DEFAULT 0,
  `Weap1` int(4) NOT NULL DEFAULT 0,
  `AWeap1` int(4) NOT NULL DEFAULT 0,
  `Weap2` int(4) NOT NULL DEFAULT 0,
  `AWeap2` int(4) NOT NULL DEFAULT 0,
  `Weap3` int(4) NOT NULL DEFAULT 0,
  `AWeap3` int(4) NOT NULL DEFAULT 0,
  `Weap4` int(4) NOT NULL DEFAULT 0,
  `AWeap4` int(4) NOT NULL DEFAULT 0,
  `Weap5` int(4) NOT NULL DEFAULT 0,
  `AWeap5` int(4) NOT NULL DEFAULT 0,
  `Weap6` int(4) NOT NULL DEFAULT 0,
  `AWeap6` int(4) NOT NULL DEFAULT 0,
  `Weap7` int(4) NOT NULL DEFAULT 0,
  `AWeap7` int(4) NOT NULL DEFAULT 0,
  `Weap8` int(4) NOT NULL DEFAULT 0,
  `AWeap8` int(4) NOT NULL DEFAULT 0,
  `Weap9` int(4) NOT NULL DEFAULT 0,
  `AWeap9` int(4) NOT NULL DEFAULT 0,
  `Weap10` int(4) NOT NULL DEFAULT 0,
  `AWeap10` int(4) NOT NULL DEFAULT 0,
  `Weap11` int(4) NOT NULL DEFAULT 0,
  `AWeap11` int(4) NOT NULL DEFAULT 0,
  `Weap12` int(4) NOT NULL DEFAULT 0,
  `AWeap12` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `players`
--
-- --------------------------------------------------------

--
-- Structure de la table `spawnpos`
--

CREATE TABLE `spawnpos` (
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `spawnpos`
--

INSERT INTO `spawnpos` (`posx`, `posy`, `posz`) VALUES
(8361.49, 13740.6, 3.907),
(8354.55, 13729.8, 3.893),
(8356.15, 13751.7, 3.765),
(8335.29, 13737.1, 5.449),
(8326.94, 13740.3, 6.328),
(8310.48, 13753.5, 6.376),
(8315.49, 13763, 6.378),
(8253.1, 13838.5, 1.412),
(8262.01, 13816.2, 1.352),
(8367.59, 13776.2, 3.542),
(8387.79, 13784.6, 3.905),
(8368.21, 13795.9, 4.066),
(8366.97, 13804.1, 4.066),
(8375.39, 13809.2, 4.066),
(8383.6, 13799.9, 4.066),
(8387.95, 13788.2, 4.028),
(8442.76, 13780.7, 10.362),
(8497.86, 13808.1, 3.73),
(8502.5, 13799.8, 3.855),
(8507.19, 13801, 4.272),
(8518.8, 13790.8, 4.76),
(8552.52, 13829.8, 3.927),
(8555.37, 13918.9, 4.204),
(8798.82, 13832.1, 6.035),
(8796.41, 13833.1, 6.035),
(8809.67, 13871.6, 3.284),
(8806.58, 13874.5, 3.266),
(8775.12, 13911.6, 3.529),
(8751.29, 14028.4, 3.008),
(8708.66, 14045, 4.365),
(8695.8, 14051.3, 4.333),
(8703.56, 14061.9, 4.379),
(8694.92, 14058.5, 4.34),
(8426.31, 14261.2, 7.065),
(8366.27, 14262.1, 7.131),
(8369.57, 14240.1, 7.23),
(8368.62, 14243.2, 7.179),
(8370.82, 14242.8, 7.182),
(8372.34, 14239.7, 7.231),
(8371.11, 14236.7, 7.215),
(8368.73, 14235.2, 7.183),
(8366.22, 14237.5, 7.244),
(8365.15, 14239.4, 7.256),
(8555.7, 14181.7, 6.646),
(8555.88, 14182.1, 6.635);

-- --------------------------------------------------------

--
-- Structure de la table `storage`
--

CREATE TABLE `storage` (
  `typesize` int(10) NOT NULL,
  `lock` int(10) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `posrx` float NOT NULL,
  `posry` float NOT NULL,
  `posrz` float NOT NULL,
  `inv0` int(4) NOT NULL,
  `inv1` int(4) NOT NULL,
  `inv2` int(4) NOT NULL,
  `inv3` int(4) NOT NULL,
  `inv4` int(4) NOT NULL,
  `inv5` int(4) NOT NULL,
  `inv6` int(4) NOT NULL,
  `inv7` int(4) NOT NULL,
  `inv8` int(4) NOT NULL,
  `inv9` int(4) NOT NULL,
  `inv10` int(4) NOT NULL,
  `inv11` int(4) NOT NULL,
  `inv12` int(4) NOT NULL,
  `inv13` int(4) NOT NULL,
  `inv14` int(4) NOT NULL,
  `inv15` int(4) NOT NULL,
  `inv16` int(4) NOT NULL,
  `inv17` int(4) NOT NULL,
  `inv18` int(4) NOT NULL,
  `inv19` int(4) NOT NULL,
  `inv20` int(4) NOT NULL,
  `inv21` int(4) NOT NULL,
  `inv22` int(4) NOT NULL,
  `inv23` int(4) NOT NULL,
  `inv24` int(4) NOT NULL,
  `inv25` int(4) NOT NULL,
  `Username` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `storage`
--

INSERT INTO `storage` (`typesize`, `lock`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`, `inv0`, `inv1`, `inv2`, `inv3`, `inv4`, `inv5`, `inv6`, `inv7`, `inv8`, `inv9`, `inv10`, `inv11`, `inv12`, `inv13`, `inv14`, `inv15`, `inv16`, `inv17`, `inv18`, `inv19`, `inv20`, `inv21`, `inv22`, `inv23`, `inv24`, `inv25`, `Username`) VALUES
(2, 0, 11.129, 12.804, 2.49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Tysanio'),
(3, 0, 13.769, 0.638, 2.12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Tysanio');

-- --------------------------------------------------------

--
-- Structure de la table `vehicles`
--

CREATE TABLE `vehicles` (
  `vehID` int(11) NOT NULL,
  `vehModel` int(11) NOT NULL,
  `vehName` varchar(25) NOT NULL,
  `vehOwner` varchar(25) NOT NULL DEFAULT '-',
  `vehLock` int(11) NOT NULL,
  `vehMod_1` int(11) NOT NULL,
  `vehMod_2` int(11) NOT NULL,
  `vehMod_3` int(11) NOT NULL,
  `vehMod_4` int(11) NOT NULL,
  `vehMod_5` int(11) NOT NULL,
  `vehMod_6` int(11) NOT NULL,
  `vehMod_7` int(11) NOT NULL,
  `vehMod_8` int(11) NOT NULL,
  `vehMod_9` int(11) NOT NULL,
  `vehMod_10` int(11) NOT NULL,
  `vehMod_11` int(11) NOT NULL,
  `vehMod_12` int(11) NOT NULL,
  `vehMod_13` int(11) NOT NULL,
  `vehMod_14` int(11) NOT NULL,
  `vehColorOne` int(11) NOT NULL,
  `vehColorTwo` int(11) NOT NULL,
  `vehX` float NOT NULL,
  `vehY` float NOT NULL,
  `vehZ` float NOT NULL,
  `vehA` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vehicles`
--

INSERT INTO `vehicles` (`vehID`, `vehModel`, `vehName`, `vehOwner`, `vehLock`, `vehMod_1`, `vehMod_2`, `vehMod_3`, `vehMod_4`, `vehMod_5`, `vehMod_6`, `vehMod_7`, `vehMod_8`, `vehMod_9`, `vehMod_10`, `vehMod_11`, `vehMod_12`, `vehMod_13`, `vehMod_14`, `vehColorOne`, `vehColorTwo`, `vehX`, `vehY`, `vehZ`, `vehA`) VALUES
(1, 600, 'picador', '-', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 678.923, -500.413, 15.903, 182.9),
(3, 522, 'nrg500', 'Tysanio', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 8148.84, 13900, 5.62, 314.187),
(4, 589, 'club', '-', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, -128.643, -185.031, 1.562, 164.897);

-- --------------------------------------------------------

--
-- Structure de la table `zones`
--

CREATE TABLE `zones` (
  `namezone` varchar(24) NOT NULL,
  `clanid` int(4) NOT NULL,
  `zoneposx` float NOT NULL,
  `zoneposy` float NOT NULL,
  `zoneposxx` float NOT NULL,
  `zoneposyy` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `zones`
--

INSERT INTO `zones` (`namezone`, `clanid`, `zoneposx`, `zoneposy`, `zoneposxx`, `zoneposyy`) VALUES
('Test', 4, -293, -152, 122, 226);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `clans`
--
ALTER TABLE `clans`
  ADD PRIMARY KEY (`idclan`);

--
-- Index pour la table `dropwep`
--
ALTER TABLE `dropwep`
  ADD UNIQUE KEY `posx` (`posx`,`gunid`);

--
-- Index pour la table `objects`
--
ALTER TABLE `objects`
  ADD PRIMARY KEY (`objectsID`),
  ADD UNIQUE KEY `objectsID` (`objectsID`);

--
-- Index pour la table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Index pour la table `storage`
--
ALTER TABLE `storage`
  ADD UNIQUE KEY `posx` (`posx`,`posy`,`posz`);

--
-- Index pour la table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehID`);

--
-- Index pour la table `zones`
--
ALTER TABLE `zones`
  ADD UNIQUE KEY `namezone` (`namezone`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `clans`
--
ALTER TABLE `clans`
  MODIFY `idclan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `objects`
--
ALTER TABLE `objects`
  MODIFY `objectsID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `players`
--
ALTER TABLE `players`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT pour la table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
