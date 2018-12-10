/*
SQLyog Ultimate v12.5.1 (64 bit)
MySQL - 10.1.36-MariaDB : Database - sms_mca
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`sms_mca` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `sms_mca`;

/*Table structure for table `college` */

DROP TABLE IF EXISTS `college`;

CREATE TABLE `college` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nim` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gender` enum('m','f') NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `phone_number` varchar(13) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

/*Data for the table `college` */

insert  into `college`(`id`,`nim`,`name`,`gender`,`address`,`phone_number`,`created_at`) values 
(1,'1605551031','Ni Putu Priyastini Dessy Safitri','f','Br. Pande, Desa Kaba-Kaba, Kediri, Tabanan','0895605311301','2018-12-09 23:31:52'),
(2,'1605551032','I Wayan Gus Arisna','m','	Br. Karang Dalem 2, Desa Bongkasa, Kec. Abiansemal','087862237308','2018-12-09 23:32:04'),
(3,'1605551033','I Gede Agus Pradipta','m','Dusun Banda, Desa Takmung, Kec. Banjarangkan','085737422549','2018-12-09 23:33:27'),
(4,'1605551034','I Gede Bagus Premana Putra','m','Br Juntal, Desa Kaba-Kaba, Kediri, Tabanan','087861895329','2018-12-09 23:34:03'),
(5,'1605551035','I Komang Pande Natayasa','m','Jln. Giri Kencana No 39, Kec. Kuta Selatan, Kab. Badung','081529291047','2018-12-09 23:34:28'),
(6,'	160555103','PUTU VISVANI YUSTISIA','f','Jln. Kembang Sari, Kembang Sari Residence No. 3A, Tonja, Denpasar Timur','082144343945','2018-12-09 23:38:11'),
(7,'1605551037','PUTU ADHIKA DHARMESTA','m','Jalan Gunung Cemara No 20','082237092352','2018-12-09 23:38:40'),
(8,'1605551038','	NI MADE DEWIK ELIANTI','f','Jalan Raya Kuta, Gang Sada Sari II/8','0361761898','2018-12-09 23:39:01'),
(9,'1605551039','I WAYAN ANANTA RADITYAWAN','m','Jln Tukad Unda Blok 7 no 8','082340746677','2018-12-09 23:39:24'),
(10,'	160555104','I GEDE YOGI SASTRA WIRAWAN','m','Jln. Perumahan Dosen Unud Blok. E NO. 17','083117503521','2018-12-09 23:39:41');

/*Table structure for table `course` */

DROP TABLE IF EXISTS `course`;

CREATE TABLE `course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `consentration` enum('mdi','tc','mkj','mb') NOT NULL,
  `sks` tinyint(4) NOT NULL,
  `semester` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

/*Data for the table `course` */

insert  into `course`(`id`,`code`,`name`,`consentration`,`sks`,`semester`) values 
(1,'TID030301','Multi Channel Access','mdi',3,6),
(2,'TID030305','Data Mining','mdi',3,6),
(3,'TID030307','Enterprise Resource Planning','mdi',3,6),
(4,'TID030309','Korporasi Maya','mdi',3,6),
(5,'TID030310','Sertifikasi','mdi',3,6),
(6,'TID030312','Topik Khusus Manajemen Data dan Informasi','mdi',3,6),
(7,'TID036105','Praktikum Data Warehouse','mdi',1,6),
(8,'TID036304','Audit TI','mdi',3,6),
(9,'TID039301','Manajemen Sains','mdi',3,6),
(10,'TID039302','Sistem Informasi Geografis Web dan Mobile','mdi',3,6);

/*Table structure for table `grade` */

DROP TABLE IF EXISTS `grade`;

CREATE TABLE `grade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `college_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `grade` float NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `college_id` (`college_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `grade_ibfk_1` FOREIGN KEY (`college_id`) REFERENCES `college` (`id`),
  CONSTRAINT `grade_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

/*Data for the table `grade` */

insert  into `grade`(`id`,`college_id`,`course_id`,`grade`,`created_at`) values 
(1,3,1,80,'2018-12-09 23:41:18'),
(2,3,2,80,'2018-12-09 23:58:32'),
(3,3,3,89,'2018-12-10 00:07:54'),
(4,3,4,89,'2018-12-10 00:08:01'),
(5,3,5,90,'2018-12-10 00:08:06'),
(6,3,6,86,'2018-12-10 00:08:15'),
(8,3,7,87,'2018-12-10 00:08:34'),
(9,3,8,98,'2018-12-10 00:08:40'),
(10,3,9,89,'2018-12-10 00:08:48'),
(12,3,10,92,'2018-12-10 00:08:59'),
(13,2,1,90,'2018-12-10 01:38:47');

/*Table structure for table `inbox` */

DROP TABLE IF EXISTS `inbox`;

CREATE TABLE `inbox` (
  `inbox_id` int(11) NOT NULL AUTO_INCREMENT,
  `source_device_iden` varchar(30) DEFAULT NULL,
  `sender` varchar(16) DEFAULT NULL,
  `message` text,
  `status` tinyint(4) DEFAULT '0',
  `inbox_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inbox_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `inbox` */

insert  into `inbox`(`inbox_id`,`source_device_iden`,`sender`,`message`,`status`,`inbox_time`) values 
(1,'ujCVuSMe5ymsjAiVsKnSTs','085854119062','MENU',1,'2018-12-10 23:59:44');

/*Table structure for table `menu` */

DROP TABLE IF EXISTS `menu`;

CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu` varchar(100) NOT NULL,
  `command` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `menu` */

insert  into `menu`(`id`,`menu`,`command`) values 
(1,'Tampilkan daftar mata kuliah berdasarkan semester','getCourseBySemester'),
(2,'Tampilkan rincian mata kuliah tertentu','getSpecificCourse'),
(3,'Tampilkan nilai mata kuliah tertentu','getSpecificGrade');

/*Table structure for table `outbox` */

DROP TABLE IF EXISTS `outbox`;

CREATE TABLE `outbox` (
  `outbox_id` int(11) NOT NULL AUTO_INCREMENT,
  `target_device_iden` varchar(30) DEFAULT NULL,
  `source_user_iden` varchar(30) DEFAULT NULL,
  `conversation_iden` varchar(16) DEFAULT NULL,
  `message` text,
  `status` tinyint(4) DEFAULT NULL,
  `outbox_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`outbox_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `outbox` */

insert  into `outbox`(`outbox_id`,`target_device_iden`,`source_user_iden`,`conversation_iden`,`message`,`status`,`outbox_time`) values 
(1,'ujCVuSMe5ymsjAiVsKnSTs','ujCVuSMe5ym','085854119062','Silahkan balas dengan no menu\n1. Tampilkan daftar mata kuliah berdasarkan semester\n2. Tampilkan rincian mata kuliah tertentu\n3. Tampilkan nilai mata kuliah tertentu\n',1,'2018-12-10 23:59:49');

/* Procedure structure for procedure `getCourseBySemester` */

/*!50003 DROP PROCEDURE IF EXISTS  `getCourseBySemester` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `getCourseBySemester`(in semester int)
BEGIN
	SELECT course.`code`, course.`name`, course.`consentration`, course.`sks`, course.`semester` 
	FROM course WHERE course.`semester` = semester;
END */$$
DELIMITER ;

/* Procedure structure for procedure `getSpecificCourse` */

/*!50003 DROP PROCEDURE IF EXISTS  `getSpecificCourse` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `getSpecificCourse`(in course_code varchar(10))
BEGIN
	SELECT course.`code`, course.`name`, course.`consentration`, course.`sks`, course.`semester`
	FROM course WHERE CODE LIKE course_code;
END */$$
DELIMITER ;

/* Procedure structure for procedure `getSpecificGrade` */

/*!50003 DROP PROCEDURE IF EXISTS  `getSpecificGrade` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `getSpecificGrade`(in course_code varchar(10), nim varchar(10))
BEGIN
	SELECT course.code, course.`name`, grade.`grade` FROM grade
	JOIN course ON grade.`course_id` = course.`id`
	JOIN college ON grade.`college_id` = college.`id`
	WHERE course.`code` LIKE course_code AND college.`nim` = nim;
END */$$
DELIMITER ;

/* Procedure structure for procedure `showMenu` */

/*!50003 DROP PROCEDURE IF EXISTS  `showMenu` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `showMenu`()
BEGIN
		select menu.`menu` from menu;
	END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
