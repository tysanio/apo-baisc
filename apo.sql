-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 08, 2026 at 03:06 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `apo`
--
-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `id` int NOT NULL,
  `player_name` varchar(24) COLLATE utf8mb4_general_ci NOT NULL,
  `ip` varchar(16) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `admin_name` varchar(24) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reason` text COLLATE utf8mb4_general_ci,
  `ban_time` int DEFAULT NULL,
  `duration` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clans`
--

CREATE TABLE `clans` (
  `idclan` int NOT NULL,
  `clanname` varchar(24) NOT NULL,
  `Owner` varchar(24) NOT NULL,
  `maxrank` int NOT NULL,
  `clancolor` int NOT NULL DEFAULT '0',
  `enterposx` float NOT NULL,
  `enterposy` float NOT NULL,
  `enterposz` float NOT NULL,
  `enterinterior` int NOT NULL,
  `entervw` int NOT NULL,
  `exitposx` float NOT NULL,
  `exitposy` float NOT NULL,
  `exitposz` float NOT NULL,
  `exitinterior` int NOT NULL,
  `exitvw` int NOT NULL,
  `chestposx` float NOT NULL,
  `chestposy` float NOT NULL,
  `chestposz` float NOT NULL,
  `clanexp0` int NOT NULL,
  `clanexp1` int NOT NULL,
  `clanexp2` int NOT NULL,
  `clanexp3` int NOT NULL,
  `clanexp4` int NOT NULL,
  `inv0` int NOT NULL,
  `inv1` int NOT NULL,
  `inv2` int NOT NULL,
  `inv3` int NOT NULL,
  `inv4` int NOT NULL,
  `inv5` int NOT NULL,
  `inv6` int NOT NULL,
  `inv7` int NOT NULL,
  `inv8` int NOT NULL,
  `inv9` int NOT NULL,
  `inv10` int NOT NULL,
  `inv11` int NOT NULL,
  `inv12` int NOT NULL,
  `inv13` int NOT NULL,
  `inv14` int NOT NULL,
  `inv15` int NOT NULL,
  `inv16` int NOT NULL,
  `inv17` int NOT NULL,
  `inv18` int NOT NULL,
  `inv19` int NOT NULL,
  `inv20` int NOT NULL,
  `inv21` int NOT NULL,
  `inv22` int NOT NULL,
  `inv23` int NOT NULL,
  `inv24` int NOT NULL,
  `inv25` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `entrances`
--

CREATE TABLE `entrances` (
  `entranceID` int NOT NULL,
  `entranceName` varchar(32) NOT NULL,
  `entranceLocked` int NOT NULL,
  `entrancePosX` float NOT NULL DEFAULT '0',
  `entrancePosY` float NOT NULL DEFAULT '0',
  `entrancePosZ` float NOT NULL DEFAULT '0',
  `entrancePosA` float NOT NULL DEFAULT '0',
  `entranceIntX` float NOT NULL DEFAULT '0',
  `entranceIntY` float NOT NULL DEFAULT '0',
  `entranceIntZ` float NOT NULL DEFAULT '0',
  `entranceIntA` float NOT NULL DEFAULT '0',
  `entranceInterior` int NOT NULL,
  `entranceExterior` int NOT NULL,
  `entranceExteriorVW` int NOT NULL,
  `entranceWorld` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fuel_stations`
--

CREATE TABLE `fuel_stations` (
  `id` int NOT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `stock` int DEFAULT '0',
  `price_per_liter` int DEFAULT '10'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fuel_stations`
--

INSERT INTO `fuel_stations` (`id`, `pos_x`, `pos_y`, `pos_z`, `stock`, `price_per_liter`) VALUES
(2, 1958.38, 1343.16, 15.375, 500, 5),
(3, -19.072, -0.088, 3.11, 538, 10),
(4, -13.771, 37.033, 3.11, 890, 5);

-- --------------------------------------------------------

--
-- Table structure for table `gang_zones`
--

CREATE TABLE `gang_zones` (
  `id` int NOT NULL,
  `minx` float NOT NULL,
  `miny` float NOT NULL,
  `maxx` float NOT NULL,
  `maxy` float NOT NULL,
  `team_id` int DEFAULT '0',
  `ressources` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `missions`
--

CREATE TABLE `missions` (
  `id` int NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `objects`
--

CREATE TABLE `objects` (
  `objectsID` int NOT NULL,
  `objectsModel` int DEFAULT '0',
  `objectsX` float DEFAULT '0',
  `objectsY` float DEFAULT '0',
  `objectsZ` float DEFAULT '0',
  `objectsRX` float DEFAULT '0',
  `objectsRY` float DEFAULT '0',
  `objectsRZ` float DEFAULT '0',
  `objectsInterior` int DEFAULT '0',
  `objectsWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `ID` int NOT NULL,
  `Username` varchar(24) NOT NULL,
  `Password` varchar(129) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `Admin` int NOT NULL,
  `VIP` int NOT NULL,
  `Score` int NOT NULL,
  `Life` float NOT NULL DEFAULT '100',
  `Armor` float NOT NULL,
  `skin` int NOT NULL DEFAULT '5',
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `interior` int NOT NULL DEFAULT '0',
  `food` int NOT NULL DEFAULT '100',
  `water` int NOT NULL DEFAULT '100',
  `idclan` int NOT NULL,
  `clanrank` int NOT NULL,
  `clanexp0` int NOT NULL DEFAULT '0',
  `clanexp1` int NOT NULL DEFAULT '0',
  `clanexp2` int NOT NULL DEFAULT '0',
  `clanexp3` int NOT NULL DEFAULT '0',
  `clanexp4` int NOT NULL DEFAULT '0',
  `inv0` int NOT NULL,
  `inv1` int NOT NULL,
  `inv2` int NOT NULL,
  `inv3` int NOT NULL,
  `inv4` int NOT NULL,
  `inv5` int NOT NULL,
  `inv6` int NOT NULL,
  `inv7` int NOT NULL,
  `inv8` int NOT NULL,
  `inv9` int NOT NULL,
  `inv10` int NOT NULL,
  `inv11` int NOT NULL,
  `inv12` int NOT NULL,
  `inv13` int NOT NULL,
  `inv14` int NOT NULL,
  `inv15` int NOT NULL,
  `inv16` int NOT NULL,
  `inv17` int NOT NULL,
  `inv18` int NOT NULL,
  `inv19` int NOT NULL,
  `inv20` int NOT NULL,
  `inv21` int NOT NULL,
  `inv22` int NOT NULL,
  `inv23` int NOT NULL,
  `inv24` int NOT NULL,
  `inv25` int NOT NULL DEFAULT '0',
  `Weap0` int NOT NULL DEFAULT '0',
  `AWeap0` int NOT NULL DEFAULT '0',
  `Weap1` int NOT NULL DEFAULT '0',
  `AWeap1` int NOT NULL DEFAULT '0',
  `Weap2` int NOT NULL DEFAULT '0',
  `AWeap2` int NOT NULL DEFAULT '0',
  `Weap3` int NOT NULL DEFAULT '0',
  `AWeap3` int NOT NULL DEFAULT '0',
  `Weap4` int NOT NULL DEFAULT '0',
  `AWeap4` int NOT NULL DEFAULT '0',
  `Weap5` int NOT NULL DEFAULT '0',
  `AWeap5` int NOT NULL DEFAULT '0',
  `Weap6` int NOT NULL DEFAULT '0',
  `AWeap6` int NOT NULL DEFAULT '0',
  `Weap7` int NOT NULL DEFAULT '0',
  `AWeap7` int NOT NULL DEFAULT '0',
  `Weap8` int NOT NULL DEFAULT '0',
  `AWeap8` int NOT NULL DEFAULT '0',
  `Weap9` int NOT NULL DEFAULT '0',
  `AWeap9` int NOT NULL DEFAULT '0',
  `Weap10` int NOT NULL DEFAULT '0',
  `AWeap10` int NOT NULL DEFAULT '0',
  `Weap11` int NOT NULL DEFAULT '0',
  `AWeap11` int NOT NULL DEFAULT '0',
  `Weap12` int NOT NULL DEFAULT '0',
  `AWeap12` int NOT NULL DEFAULT '0',
  `discordid` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- --------------------------------------------------------

--
-- Table structure for table `spawnpos`
--

CREATE TABLE `spawnpos` (
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `storages`
--

CREATE TABLE `storages` (
  `storagesID` int UNSIGNED NOT NULL,
  `storagesModel` int UNSIGNED NOT NULL DEFAULT '3798',
  `storagesLock` int NOT NULL DEFAULT '0',
  `storagesX` float(10,4) NOT NULL,
  `storagesY` float(10,4) NOT NULL,
  `storagesZ` float(10,4) NOT NULL,
  `storagesRX` float(10,4) NOT NULL,
  `storagesRY` float(10,4) NOT NULL,
  `storagesRZ` float(10,4) NOT NULL,
  `storagesInterior` int NOT NULL DEFAULT '0',
  `storagesWorld` int NOT NULL DEFAULT '0',
  `inv0` int NOT NULL DEFAULT '0',
  `inv1` int NOT NULL DEFAULT '0',
  `inv2` int NOT NULL DEFAULT '0',
  `inv3` int NOT NULL DEFAULT '0',
  `inv4` int NOT NULL DEFAULT '0',
  `inv5` int NOT NULL DEFAULT '0',
  `inv6` int NOT NULL DEFAULT '0',
  `inv7` int NOT NULL DEFAULT '0',
  `inv8` int NOT NULL DEFAULT '0',
  `inv9` int NOT NULL DEFAULT '0',
  `inv10` int NOT NULL DEFAULT '0',
  `inv11` int NOT NULL DEFAULT '0',
  `inv12` int NOT NULL DEFAULT '0',
  `inv13` int NOT NULL DEFAULT '0',
  `inv14` int NOT NULL DEFAULT '0',
  `inv15` int NOT NULL DEFAULT '0',
  `inv16` int NOT NULL DEFAULT '0',
  `inv17` int NOT NULL DEFAULT '0',
  `inv18` int NOT NULL DEFAULT '0',
  `inv19` int NOT NULL DEFAULT '0',
  `inv20` int NOT NULL DEFAULT '0',
  `inv21` int NOT NULL DEFAULT '0',
  `inv22` int NOT NULL DEFAULT '0',
  `inv23` int NOT NULL DEFAULT '0',
  `inv24` int NOT NULL DEFAULT '0',
  `inv25` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int NOT NULL,
  `model` int NOT NULL,
  `posX` float DEFAULT NULL,
  `posY` float DEFAULT NULL,
  `posZ` float DEFAULT NULL,
  `rot` float DEFAULT NULL,
  `owner` varchar(24) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `color1` int DEFAULT '-1',
  `color2` int DEFAULT '-1',
  `mods` text COLLATE utf8mb4_general_ci,
  `paintjob` int DEFAULT '-1',
  `fuel` float NOT NULL DEFAULT '100'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weapon_drops`
--

CREATE TABLE `weapon_drops` (
  `id` int NOT NULL,
  `weaponid` int NOT NULL,
  `ammo` int NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clans`
--
ALTER TABLE `clans`
  ADD PRIMARY KEY (`idclan`);

--
-- Indexes for table `entrances`
--
ALTER TABLE `entrances`
  ADD PRIMARY KEY (`entranceID`);

--
-- Indexes for table `gang_zones`
--
ALTER TABLE `gang_zones`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `missions`
--
ALTER TABLE `missions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `objects`
--
ALTER TABLE `objects`
  ADD PRIMARY KEY (`objectsID`),
  ADD UNIQUE KEY `objectsID` (`objectsID`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `storages`
--
ALTER TABLE `storages`
  ADD PRIMARY KEY (`storagesID`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weapon_drops`
--
ALTER TABLE `weapon_drops`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--
--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT for table `clans`
--
ALTER TABLE `clans`
  MODIFY `idclan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT for table `entrances`
--
ALTER TABLE `entrances`
  MODIFY `entranceID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gang_zones`
--
ALTER TABLE `gang_zones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT for table `missions`
--
ALTER TABLE `missions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT for table `objects`
--
ALTER TABLE `objects`
  MODIFY `objectsID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT for table `storages`
--
ALTER TABLE `storages`
  MODIFY `storagesID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT for table `weapon_drops`
--
ALTER TABLE `weapon_drops`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
