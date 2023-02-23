
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


-- --------------------------------------------------------

--
-- Structure de la table `batiements`
--

CREATE TABLE `batiements` (
  `batiementID` int NOT NULL,
  `batiementModel` int NOT NULL DEFAULT '0',
  `batiementInterior` int NOT NULL DEFAULT '0',
  `batiementWorld` int NOT NULL DEFAULT '0',
  `batiementX` float NOT NULL DEFAULT '0',
  `batiementY` float NOT NULL DEFAULT '0',
  `batiementZ` float NOT NULL DEFAULT '0',
  `batiementRX` float NOT NULL DEFAULT '0',
  `batiementRY` float NOT NULL DEFAULT '0',
  `batiementRZ` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


--
-- Index pour la table `batiements`
--
ALTER TABLE `batiements`
  ADD PRIMARY KEY (`batiementID`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `batiements`
--
ALTER TABLE `batiements`
  MODIFY `batiementID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=592;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
