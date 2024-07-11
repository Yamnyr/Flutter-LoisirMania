-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 11 juil. 2024 à 12:13
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `blibliotheque`
--

-- --------------------------------------------------------

--
-- Structure de la table `loisir`
--

DROP DATABASE IF EXISTS `blibliotheque`;
CREATE DATABASE IF NOT EXISTS `blibliotheque`;
USE `blibliotheque`;

CREATE TABLE `loisir` (
  `idloisir` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `images` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `date_sortie` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `loisir`
--

INSERT INTO `loisir` (`idloisir`, `type`, `nom`, `images`, `description`, `date_sortie`) VALUES
(1, 1, 'Furiosa', 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/hbxqFdWXHeLIJfagMMhVG5SV5tb.jpg', 'Alors que le monde s\'écroule, la jeune Furiosa tombe entre les mains d\'une horde de motards dirigée par le seigneur de la guerre Dementus. ', '2024-05-22'),
(2, 1, 'La Planète des Singes', 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/4925wPllJdQmHd1RxbZ62ZekaW3.jpg', 'Plusieurs générations après le règne de César, les singes ont définitivement pris le pouvoir. Les humains, quant à eux, ont régressé à l\'état sauvage et vivent en retrait.', '2024-05-08'),
(8, 6, 'The Bikeriders', 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/tx6UlWCONmgKIt51dHPWspF4Mgh.jpg', 'Dans les années 1960. L\'ascension d\'un club de motards fictif du Midwest vue à travers la vie de ses membres passant d\'un lieu de rassemblement pour les marginaux locaux à un gang plus dangereux.\n\n', '2024-06-14'),
(14, 3, 'Prisoners', 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/fUk1f0iOAezl5PZ7gQW6nrguOXk.jpg', 'Dans la banlieue de Boston, deux fillettes de 6 ans, Anna et Joy, ont disparu. Le détective Loki privilégie la thèse du kidnapping suite au témoignage de Keller, le père d’Anna. ', '2013-09-09'),
(15, 2, 'Mr. Robot', 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/oKIBhzZzDX07SoE2bOLhq2EE8rf.jpg', 'Elliot est un jeune programmeur anti-social qui souffre d\'un trouble du comportement qui le pousse à croire qu\'il ne peut rencontrer des gens qu\'en les hackant.', '2014-12-30'),
(16, 2, 'test', 'test', 'test', '2024-07-11');

-- --------------------------------------------------------

--
-- Structure de la table `note`
--

CREATE TABLE `note` (
  `id` int(11) NOT NULL,
  `loisir` int(11) NOT NULL,
  `note` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `note`
--

INSERT INTO `note` (`id`, `loisir`, `note`) VALUES
(1, 1, 5),
(2, 1, 0),
(3, 2, 2),
(4, 2, 3),
(9, 2, 2),
(10, 2, 1),
(11, 2, 1),
(12, 2, 5),
(13, 8, 5),
(14, 14, 3),
(15, 14, 1),
(16, 1, 5),
(17, 1, 1),
(18, 8, 1),
(19, 2, 5),
(20, 15, 5),
(21, 15, 1),
(22, 14, 5);

-- --------------------------------------------------------

--
-- Structure de la table `type`
--

CREATE TABLE `type` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `type`
--

INSERT INTO `type` (`id`, `nom`) VALUES
(1, 'Film'),
(2, 'Serie'),
(3, 'Livre\n'),
(4, 'BD'),
(5, 'Comics'),
(6, 'Mangas');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `loisir`
--
ALTER TABLE `loisir`
  ADD PRIMARY KEY (`idloisir`),
  ADD KEY `fk_type` (`type`);

--
-- Index pour la table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_loisir` (`loisir`);

--
-- Index pour la table `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `loisir`
--
ALTER TABLE `loisir`
  MODIFY `idloisir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `note`
--
ALTER TABLE `note`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `type`
--
ALTER TABLE `type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `loisir`
--
ALTER TABLE `loisir`
  ADD CONSTRAINT `fk_type` FOREIGN KEY (`type`) REFERENCES `type` (`id`);

--
-- Contraintes pour la table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `fk_loisir` FOREIGN KEY (`loisir`) REFERENCES `loisir` (`idloisir`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
