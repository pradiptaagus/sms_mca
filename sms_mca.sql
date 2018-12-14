-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 12, 2018 at 07:17 PM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sms_mca`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCourseBySemester` (IN `semester` INT)  BEGIN
	SELECT course.`code`, course.`name`, course.`consentration`, course.`sks`, course.`semester` 
	FROM course WHERE course.`semester` = semester;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSpecificCourse` (IN `course_code` VARCHAR(10))  BEGIN
	SELECT course.`code`, course.`name`, course.`consentration`, course.`sks`, course.`semester`
	FROM course WHERE CODE LIKE course_code;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSpecificGrade` (IN `course_code` VARCHAR(10), `nim` VARCHAR(10))  BEGIN
	SELECT course.code, course.`name`, grade.`grade` FROM grade
	JOIN course ON grade.`course_id` = course.`id`
	JOIN college ON grade.`college_id` = college.`id`
	WHERE course.`code` LIKE course_code AND college.`nim` = nim;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `showMenu` ()  BEGIN
		select menu.`menu` from menu;
	END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `college`
--

CREATE TABLE `college` (
  `id` int(11) NOT NULL,
  `nim` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gender` enum('m','f') NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `phone_number` varchar(13) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `college`
--

INSERT INTO `college` (`id`, `nim`, `name`, `gender`, `address`, `phone_number`, `created_at`) VALUES
(1, '1605551031', 'Ni Putu Priyastini Dessy Safitri', 'f', 'Br. Pande, Desa Kaba-Kaba, Kediri, Tabanan', '0895605311301', '2018-12-09 15:31:52'),
(2, '1605551032', 'I Wayan Gus Arisna', 'm', '	Br. Karang Dalem 2, Desa Bongkasa, Kec. Abiansemal', '087862237308', '2018-12-09 15:32:04'),
(3, '1605551033', 'I Gede Agus Pradipta', 'm', 'Dusun Banda, Desa Takmung, Kec. Banjarangkan', '085737422549', '2018-12-09 15:33:27'),
(4, '1605551034', 'I Gede Bagus Premana Putra', 'm', 'Br Juntal, Desa Kaba-Kaba, Kediri, Tabanan', '087861895329', '2018-12-09 15:34:03'),
(5, '1605551035', 'I Komang Pande Natayasa', 'm', 'Jln. Giri Kencana No 39, Kec. Kuta Selatan, Kab. Badung', '081529291047', '2018-12-09 15:34:28'),
(6, '	160555103', 'PUTU VISVANI YUSTISIA', 'f', 'Jln. Kembang Sari, Kembang Sari Residence No. 3A, Tonja, Denpasar Timur', '082144343945', '2018-12-09 15:38:11'),
(7, '1605551037', 'PUTU ADHIKA DHARMESTA', 'm', 'Jalan Gunung Cemara No 20', '082237092352', '2018-12-09 15:38:40'),
(8, '1605551038', '	NI MADE DEWIK ELIANTI', 'f', 'Jalan Raya Kuta, Gang Sada Sari II/8', '0361761898', '2018-12-09 15:39:01'),
(9, '1605551039', 'I WAYAN ANANTA RADITYAWAN', 'm', 'Jln Tukad Unda Blok 7 no 8', '082340746677', '2018-12-09 15:39:24'),
(10, '	160555104', 'I GEDE YOGI SASTRA WIRAWAN', 'm', 'Jln. Perumahan Dosen Unud Blok. E NO. 17', '083117503521', '2018-12-09 15:39:41');

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `consentration` enum('mdi','tc','mkj','mb') NOT NULL,
  `sks` tinyint(4) NOT NULL,
  `semester` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`id`, `code`, `name`, `consentration`, `sks`, `semester`) VALUES
(1, 'TID030301', 'Multi Channel Access', 'mdi', 3, 6),
(2, 'TID030305', 'Data Mining', 'mdi', 3, 6),
(3, 'TID030307', 'Enterprise Resource Planning', 'mdi', 3, 6),
(4, 'TID030309', 'Korporasi Maya', 'mdi', 3, 6),
(5, 'TID030310', 'Sertifikasi', 'mdi', 3, 6),
(6, 'TID030312', 'Topik Khusus Manajemen Data dan Informasi', 'mdi', 3, 6),
(7, 'TID036105', 'Praktikum Data Warehouse', 'mdi', 1, 6),
(8, 'TID036304', 'Audit TI', 'mdi', 3, 6),
(9, 'TID039301', 'Manajemen Sains', 'mdi', 3, 6),
(10, 'TID039302', 'Sistem Informasi Geografis Web dan Mobile', 'mdi', 3, 6);

-- --------------------------------------------------------

--
-- Table structure for table `grade`
--

CREATE TABLE `grade` (
  `id` int(11) NOT NULL,
  `college_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `grade` float NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `grade`
--

INSERT INTO `grade` (`id`, `college_id`, `course_id`, `grade`, `created_at`) VALUES
(1, 3, 1, 80, '2018-12-09 15:41:18'),
(2, 3, 2, 80, '2018-12-09 15:58:32'),
(3, 3, 3, 89, '2018-12-09 16:07:54'),
(4, 3, 4, 89, '2018-12-09 16:08:01'),
(5, 3, 5, 90, '2018-12-09 16:08:06'),
(6, 3, 6, 86, '2018-12-09 16:08:15'),
(8, 3, 7, 87, '2018-12-09 16:08:34'),
(9, 3, 8, 98, '2018-12-09 16:08:40'),
(10, 3, 9, 89, '2018-12-09 16:08:48'),
(12, 3, 10, 92, '2018-12-09 16:08:59'),
(13, 2, 1, 90, '2018-12-09 17:38:47');

-- --------------------------------------------------------

--
-- Table structure for table `inbox`
--

CREATE TABLE `inbox` (
  `inbox_id` int(11) NOT NULL,
  `source_device_iden` varchar(30) DEFAULT NULL,
  `sender` varchar(16) DEFAULT NULL,
  `message` text,
  `status` tinyint(4) DEFAULT '0',
  `inbox_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `inbox`
--

INSERT INTO `inbox` (`inbox_id`, `source_device_iden`, `sender`, `message`, `status`, `inbox_time`) VALUES
(1, 'ujCVuSMe5ymsjAiVsKnSTs', '085854119062', 'MENU', 1, '2018-12-10 15:59:44');

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `menu` varchar(100) NOT NULL,
  `command` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `menu`, `command`) VALUES
(1, 'Tampilkan daftar mata kuliah berdasarkan semester', 'getCourseBySemester'),
(2, 'Tampilkan rincian mata kuliah tertentu', 'getSpecificCourse'),
(3, 'Tampilkan nilai mata kuliah tertentu', 'getSpecificGrade');

-- --------------------------------------------------------

--
-- Table structure for table `outbox`
--

CREATE TABLE `outbox` (
  `outbox_id` int(11) NOT NULL,
  `target_device_iden` varchar(30) DEFAULT NULL,
  `source_user_iden` varchar(30) DEFAULT NULL,
  `conversation_iden` varchar(16) DEFAULT NULL,
  `message` text,
  `status` tinyint(4) DEFAULT NULL,
  `outbox_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `outbox`
--

INSERT INTO `outbox` (`outbox_id`, `target_device_iden`, `source_user_iden`, `conversation_iden`, `message`, `status`, `outbox_time`) VALUES
(1, 'ujCVuSMe5ymsjAiVsKnSTs', 'ujCVuSMe5ym', '085854119062', 'Silahkan balas dengan no menu\n1. Tampilkan daftar mata kuliah berdasarkan semester\n2. Tampilkan rincian mata kuliah tertentu\n3. Tampilkan nilai mata kuliah tertentu\n', 1, '2018-12-10 15:59:49');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `college`
--
ALTER TABLE `college`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `grade`
--
ALTER TABLE `grade`
  ADD PRIMARY KEY (`id`),
  ADD KEY `college_id` (`college_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `inbox`
--
ALTER TABLE `inbox`
  ADD PRIMARY KEY (`inbox_id`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outbox`
--
ALTER TABLE `outbox`
  ADD PRIMARY KEY (`outbox_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `college`
--
ALTER TABLE `college`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `grade`
--
ALTER TABLE `grade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `inbox`
--
ALTER TABLE `inbox`
  MODIFY `inbox_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `outbox`
--
ALTER TABLE `outbox`
  MODIFY `outbox_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `grade`
--
ALTER TABLE `grade`
  ADD CONSTRAINT `grade_ibfk_1` FOREIGN KEY (`college_id`) REFERENCES `college` (`id`),
  ADD CONSTRAINT `grade_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
