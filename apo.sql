-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 05, 2026 at 05:19 AM
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
-- Table structure for table `1vehicles`
--

CREATE TABLE `1vehicles` (
  `id` int NOT NULL,
  `model` int NOT NULL,
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `angle` float NOT NULL DEFAULT '0',
  `color1` int NOT NULL DEFAULT '1',
  `color2` int NOT NULL DEFAULT '1',
  `health` float NOT NULL DEFAULT '1000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

--
-- Dumping data for table `bans`
--

INSERT INTO `bans` (`id`, `player_name`, `ip`, `admin_name`, `reason`, `ban_time`, `duration`) VALUES
(3, 'burger', '127.0.0.1', 'Ela_Bosak', 'derp', 1748541266, 0);

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

--
-- Dumping data for table `clans`
--

INSERT INTO `clans` (`idclan`, `clanname`, `Owner`, `maxrank`, `clancolor`, `enterposx`, `enterposy`, `enterposz`, `enterinterior`, `entervw`, `exitposx`, `exitposy`, `exitposz`, `exitinterior`, `exitvw`, `chestposx`, `chestposy`, `chestposz`, `clanexp0`, `clanexp1`, `clanexp2`, `clanexp3`, `clanexp4`, `inv0`, `inv1`, `inv2`, `inv3`, `inv4`, `inv5`, `inv6`, `inv7`, `inv8`, `inv9`, `inv10`, `inv11`, `inv12`, `inv13`, `inv14`, `inv15`, `inv16`, `inv17`, `inv18`, `inv19`, `inv20`, `inv21`, `inv22`, `inv23`, `inv24`, `inv25`) VALUES
(15, 'Flafla', 'Tysanio', 5, 5, 26.345, -11.116, 3.117, 0, 0, 223.431, 1287.08, 1082.14, 1, 0, 59.339, 6.031, 1.416, 0, 0, 0, 0, 0, 0, 129, 20, 10, 5, 10, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 6, 0, 0, 0, 0, 0, 40);

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

--
-- Dumping data for table `gang_zones`
--

INSERT INTO `gang_zones` (`id`, `minx`, `miny`, `maxx`, `maxy`, `team_id`, `ressources`) VALUES
(1, 100, 100, 200, 200, 0, 2009),
(2, 300, 300, 400, 400, 0, 2009),
(3, 500, 100, 600, 200, 0, 2009),
(4, 100, 500, 200, 600, 0, 2009),
(5, 250, 250, 350, 350, 0, 2009),
(7, 21.023, -36.605, 80.415, 28.628, 15, 174),
(8, -7.714, -116.087, 48.855, -60.486, 15, 1977);

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

--
-- Dumping data for table `missions`
--

INSERT INTO `missions` (`id`, `x`, `y`, `z`) VALUES
(1, 8158.56, 13905.2, 5.716),
(2, 8136.23, 13910, 5.131),
(3, 8125.88, 13898.3, 5.191),
(4, 8131.56, 13888.7, 5.683),
(5, 8130.94, 13873.3, 6.072),
(6, 8116.33, 13874.9, 5.895),
(7, 8122.55, 13910, 5.036),
(8, 8130.97, 13921.3, 5.395),
(9, 8131.37, 13930.1, 5.395);

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

--
-- Dumping data for table `objects`
--

INSERT INTO `objects` (`objectsID`, `objectsModel`, `objectsX`, `objectsY`, `objectsZ`, `objectsRX`, `objectsRY`, `objectsRZ`, `objectsInterior`, `objectsWorld`) VALUES
(3, 2000, 13.9771, 12.2515, 2.207, 0, 0, 9.7132, 0, 0);

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

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`ID`, `Username`, `Password`, `IP`, `Admin`, `VIP`, `Score`, `Life`, `Armor`, `skin`, `posx`, `posy`, `posz`, `interior`, `food`, `water`, `idclan`, `clanrank`, `clanexp0`, `clanexp1`, `clanexp2`, `clanexp3`, `clanexp4`, `inv0`, `inv1`, `inv2`, `inv3`, `inv4`, `inv5`, `inv6`, `inv7`, `inv8`, `inv9`, `inv10`, `inv11`, `inv12`, `inv13`, `inv14`, `inv15`, `inv16`, `inv17`, `inv18`, `inv19`, `inv20`, `inv21`, `inv22`, `inv23`, `inv24`, `inv25`, `Weap0`, `AWeap0`, `Weap1`, `AWeap1`, `Weap2`, `AWeap2`, `Weap3`, `AWeap3`, `Weap4`, `AWeap4`, `Weap5`, `AWeap5`, `Weap6`, `AWeap6`, `Weap7`, `AWeap7`, `Weap8`, `AWeap8`, `Weap9`, `AWeap9`, `Weap10`, `AWeap10`, `Weap11`, `AWeap11`, `Weap12`, `AWeap12`, `discordid`) VALUES
(5, 'Moomnanm', 'B121AA7419C0411D7D8A3C25BE56B1833D2EB497E8A80379153FD726B158C83953B900C596A624A55E9A05DFC112C1D51C6F61F84A39AD32CC33CD09DC77A312', '181.46.68.70', 0, 0, 0, 100, 0, 5, 0, 0, 0, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ''),
(6, 'Scarcrow', '3780CCB1444AE4BCBFCE0111E7077FE990E568A5E3E23CFA65AACC948722ADF44FB1924F42EF860C0E446682FA5712DFD9A8E4F46487774CEDB4E0EB4EA7D8D0', '41.109.33.112', 2, 0, 0, 100, 0, 26564, 8405.59, 14272.5, 7.295, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 26, 7, 38, 38, 23, 18, 17, 15, 29, 25, 22, 35, 25, 14, 16, 18, 18, 18, 21, 15, 25, 28, 18, 29, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ''),
(7, 'Bruhity', 'F23879DD58C5189F351378D25C9E0CCFA8254D2BF71D27870B16284D09A896B2C8B2EE29383944DC8354422B1272B57CEA40D49EE89D75273DB25A228D0D10A5', '37.186.32.91', 0, 0, 0, 100, 0, 5, 0, 0, 0, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ''),
(8, 'Thoriro', '3153C38F4763659A4AA314E3CA3AE56FA8CA5D182B0F2708C24754A7336753BD82C3CF422E35BB106F3601094E3D4AE829E738DB65D96711852E83D96F41A2CA', '189.74.223.195', 0, 0, 0, 100, 0, 5, 0, 0, 0, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ''),
(9, 'Tysanio', '0CF74B7CEDDE064386DC1EA8483C38BAA0F7137B347AA3633DCDE65285BB62546C7FF9E91897D393A64B17BBC49462BFA45F1DD7D9CCC025C00F78A88085139E', '127.0.0.1', 2, 3, 10, 100, 0, 26005, 43.518, -24.457, 1.81, 0, 100, 100, 15, 5, 1049, 649, 649, 649, 1650, -1, 3691, 349, 649, 353, 649, 650, 649, 7651, 719, 649, 700, 1349, 696, 649, 4152, 649, 649, 650, 999, 649, 649, 650, 650, 7658, 653, 0, 0, 0, 0, 22, 88, 0, 0, 29, 0, 30, 0, 0, 0, 38, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `spawnpos`
--

CREATE TABLE `spawnpos` (
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `spawnpos`
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
(8370.82, 14242.8, 7.182),
(8372.34, 14239.7, 7.231),
(8371.11, 14236.7, 7.215),
(8368.73, 14235.2, 7.183),
(8366.22, 14237.5, 7.244),
(8365.15, 14239.4, 7.256),
(8555.7, 14181.7, 6.646),
(8150.19, 13924.8, 5.388),
(8180.09, 13945, 5.409),
(8146.87, 13941.7, 5.386),
(8123, 13931, 5.395),
(8108.21, 13900.9, 5.588),
(8158.71, 13934.7, 5.395),
(8283.79, 13866, 1.318),
(8299.23, 13853.1, 1.375),
(8301.51, 13836.8, 1.352),
(8345.76, 13837.1, 2.691),
(8375, 13837.6, 3.67),
(8418.55, 13899.6, 3.992),
(8376.68, 13837.9, 3.67),
(8370.67, 13866.2, 8.614),
(8367.38, 13844.5, 8.66),
(8503.32, 13913.4, 3.632),
(8511.97, 13907.4, 3.679),
(8518.06, 13915.2, 3.679),
(8533.53, 13919.7, 3.679),
(8556.46, 13929.9, 3.679),
(8562.29, 13929.8, 3.679),
(8590.04, 13900.6, 3.679),
(8588.94, 13881.2, 3.671),
(8584.79, 13872.7, 3.671),
(8571.24, 13857.8, 3.761),
(8563.9, 13834.5, 3.908),
(8720.7, 13756.5, 4.018),
(8795.59, 13797.4, 6.183),
(8761.92, 13770, 5.467),
(8718.19, 13807.3, 3.79),
(8682.21, 13792.8, 3.606),
(8693.14, 13834.3, 3.545),
(8510.01, 13840.9, 3.612),
(8527.5, 13779.5, 4.992),
(8449.14, 13783.6, 7.206),
(8672.36, 13846.3, 3.438),
(8714.51, 13837.5, 3.41),
(8753.69, 13814.3, 5.094),
(8809.01, 13810.8, 5.396),
(8797.7, 13786.3, 5.437),
(8788.54, 13774.6, 5.45),
(8556.42, 13792.1, 4.902),
(8542.08, 13783.3, 5.496),
(8181.91, 13937, 5.223),
(8184.32, 13887.6, 5.95);

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

--
-- Dumping data for table `storages`
--

INSERT INTO `storages` (`storagesID`, `storagesModel`, `storagesLock`, `storagesX`, `storagesY`, `storagesZ`, `storagesRX`, `storagesRY`, `storagesRZ`, `storagesInterior`, `storagesWorld`, `inv0`, `inv1`, `inv2`, `inv3`, `inv4`, `inv5`, `inv6`, `inv7`, `inv8`, `inv9`, `inv10`, `inv11`, `inv12`, `inv13`, `inv14`, `inv15`, `inv16`, `inv17`, `inv18`, `inv19`, `inv20`, `inv21`, `inv22`, `inv23`, `inv24`, `inv25`) VALUES
(1, 1271, 9, 18.6488, 7.8740, 2.4996, 0.0000, 0.0000, 304.8529, 0, 0, 0, 10, 0, 0, 100, 0, 0, 0, 0, 50, 0, 0, 0, 40, 0, 0, 0, 0, 80, 0, 0, 0, 10, 0, 0, 500),
(2, 1271, 9, 11.7187, 9.0788, 3.1171, 0.0000, 0.0000, 253.1522, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 1271, 0, 0.9719, -8.7686, 3.1171, 0.0000, 0.0000, 89.6867, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

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

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`id`, `model`, `posX`, `posY`, `posZ`, `rot`, `owner`, `color1`, `color2`, `mods`, `paintjob`, `fuel`) VALUES
(1, 521, -15.35, -3.23, 2.68, 144.19, 'Ela_Bosak', 2, 4, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 91.93),
(2, 523, -2.41, -25.22, 2.68, 206.74, NULL, -1, -1, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 1),
(7, 555, 26.57, -44.41, 2.8, 288.57, NULL, -1, -1, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 30.76),
(8, 411, -24.33, 19.51, 2.71, 316.07, NULL, -1, -1, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 74.71),
(12, 557, 19.42, 59.18, 3.49, 316.6, NULL, 12, 2, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', 2, 12.1),
(13, 558, -32.95, -25.89, 2.69, 47.55, NULL, -1, -1, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 70),
(15, 534, 2648.37, -2005.13, 13.1, 265.3, NULL, 12, 23, '-1,-1,-1,1122,-1,-1,1127,1078,-1,-1,1179,1180,-1,-1,1179,1180,-1,-1,1122,-1,-1,-1,1100,', 1, 100),
(16, 411, 10.17, 51.37, 2.84, 334.89, NULL, 7, 80, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 67.59),
(17, 411, 8.65, 2.26, 2.83, 54.87, 'Ela_Bosak', 1, 1, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 7.87),
(18, 481, 5.44, 11.43, 2.62, 45.25, NULL, -1, -1, '', -1, 100),
(19, 481, -2.03, 23.04, 2.63, 221.69, NULL, -1, -1, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 100),
(20, 568, -19.84, -11.6, 2.98, 340.43, NULL, -1, -1, '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,', -1, 35.73);

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
-- Dumping data for table `weapon_drops`
--

INSERT INTO `weapon_drops` (`id`, `weaponid`, `ammo`, `pos_x`, `pos_y`, `pos_z`) VALUES
(3, 1, 30, 5, 0, 0),
(5, 22, 72, 15.8918, 19.1954, 3.11719),
(6, 25, 39, 11.6605, 3.46157, 3.10965),
(8, 31, 41, 6.8892, 15.6741, 3.11719),
(9, 22, 28, 133.706, -69.4187, 1.57812),
(11, 2, 22, 9.54902, 1.84253, 3.10965),
(12, 22, 22, 7.53384, 4.37984, 3.10965);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `1vehicles`
--
ALTER TABLE `1vehicles`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT for table `1vehicles`
--
ALTER TABLE `1vehicles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `clans`
--
ALTER TABLE `clans`
  MODIFY `idclan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `entrances`
--
ALTER TABLE `entrances`
  MODIFY `entranceID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gang_zones`
--
ALTER TABLE `gang_zones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `missions`
--
ALTER TABLE `missions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `objects`
--
ALTER TABLE `objects`
  MODIFY `objectsID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `storages`
--
ALTER TABLE `storages`
  MODIFY `storagesID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `weapon_drops`
--
ALTER TABLE `weapon_drops`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
