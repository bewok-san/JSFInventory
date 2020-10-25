-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 25, 2020 at 12:58 PM
-- Server version: 10.4.13-MariaDB
-- PHP Version: 7.4.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fashion_inventory`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'admin1', 'admin1');

-- --------------------------------------------------------

--
-- Table structure for table `party`
--

CREATE TABLE `party` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `address` varchar(200) NOT NULL,
  `city` varchar(100) NOT NULL,
  `zip` int(6) NOT NULL,
  `contact` varchar(100) NOT NULL,
  `note` varchar(200) NOT NULL,
  `role` enum('Factory','Branch','','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `party`
--

INSERT INTO `party` (`id`, `name`, `address`, `city`, `zip`, `contact`, `note`, `role`) VALUES
(2, 'PT Halimun Tekstil', 'Jl Raya Mayor Oking no 7', 'Bogor', 19283, 'halimun.tekstil@email.com', 'Factory for supply shirt', 'Factory'),
(3, 'Adidas Factory', 'Sawangan no 5 ', 'Bogor ', 19283, 'wk.adidas@email.com', 'Factory for Adidas shoes', 'Factory'),
(4, 'Lala Fashion', 'Djuanda no 5', 'Depok', 23455, '@lala.fashion', 'Branch for woman fashion', 'Branch'),
(6, 'Felicia Shoes', 'Jl Raya Gunung Putri no 09', 'Bogor', 92381, '@felicia.shoes', 'Branch for woman shoes', 'Branch');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `size` varchar(50) NOT NULL,
  `label` varchar(200) NOT NULL,
  `type` enum('Shirt','Pants','Shoes','Jacket') NOT NULL,
  `stock` int(11) NOT NULL,
  `received` int(11) NOT NULL,
  `shipped` int(11) NOT NULL,
  `note` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `size`, `label`, `type`, `stock`, `received`, `shipped`, `note`) VALUES
(1, 'Victor Shirt Badminton', 'XL', 'Victor Shirt Badminton [T-95010 F]', 'Shirt', 4, 6, 2, 'Polyester Material'),
(2, 'Adidas AlphaBounce ', '42', 'Adidas AlphaBounce Sneaker', 'Shoes', 10, 25, 15, 'Made in Vietnam'),
(7, 'as', 'asd', 'asd', 'Pants', 8, 10, 2, 'asd');

-- --------------------------------------------------------

--
-- Table structure for table `trans`
--

CREATE TABLE `trans` (
  `id` int(11) NOT NULL,
  `party_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `amount` int(5) NOT NULL,
  `date` date NOT NULL,
  `type` enum('Incoming','Outcoming','','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `trans`
--

INSERT INTO `trans` (`id`, `party_id`, `product_id`, `amount`, `date`, `type`) VALUES
(8, 2, 1, 6, '2020-07-22', 'Incoming'),
(9, 4, 1, 2, '2020-07-22', 'Outcoming'),
(10, 3, 2, 20, '2020-07-22', 'Incoming'),
(11, 4, 2, 15, '2020-07-22', 'Outcoming'),
(12, 3, 2, 5, '2020-10-25', 'Incoming'),
(13, 2, 7, 10, '2020-01-25', 'Incoming'),
(14, 4, 7, 2, '2020-01-25', 'Outcoming');

--
-- Triggers `trans`
--
DELIMITER $$
CREATE TRIGGER `checkStock` BEFORE INSERT ON `trans` FOR EACH ROW BEGIN
    DECLARE vstock INT(255);
    SET vstock = (SELECT stock from products WHERE id = new.product_id) ;
                        
    IF new.type = 'Outcoming' THEN
    IF new.amount > vstock THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = "check the stock carefully!";
    END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateStock` AFTER INSERT ON `trans` FOR EACH ROW IF new.type = 'Incoming' THEN
UPDATE products SET stock = stock + new.amount, received = received + new.amount WHERE id = new.product_id;
ELSEIF new.type = 'Outcoming' THEN
UPDATE products SET stock = stock - new.amount, shipped = shipped + new.amount WHERE id = new.product_id;
END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateStock2` AFTER UPDATE ON `trans` FOR EACH ROW IF NEW
    .type = 'Incoming' THEN 
    IF NEW.amount > old.amount THEN
UPDATE
    products
SET
    stock = (NEW.amount - old.amount) + stock ,
    received = (NEW.amount - old.amount) + received 
WHERE
    id = NEW.product_id; ELSEIF NEW.amount < old.amount THEN
UPDATE
    products
SET
    stock = (old.amount - NEW.amount) - stock,
    received = (old.amount - NEW.amount) -received
WHERE
    id = NEW.product_id;
END IF; ELSEIF NEW.type = 'Outcoming' THEN 
IF NEW.amount > old.amount THEN
UPDATE
    products
SET
    stock = (NEW.amount - old.amount) - stock ,
    shipped = (NEW.amount - old.amount) + shipped
WHERE
    id = NEW.product_id; ELSEIF NEW.amount < old.amount THEN
UPDATE
    products
SET
    stock = (old.amount - NEW.amount) + stock ,
    shipped = shipped - (old.amount - NEW.amount) 
WHERE
    id = NEW.product_id;
END IF;
END IF
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `party`
--
ALTER TABLE `party`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trans`
--
ALTER TABLE `trans`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `party`
--
ALTER TABLE `party`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `trans`
--
ALTER TABLE `trans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
