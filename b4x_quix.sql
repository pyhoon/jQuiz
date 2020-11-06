-- MySQL dump for database b4x_quiz

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `answers`;
CREATE TABLE `answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `answer` varchar(255) NOT NULL,
  `question` int(11) NOT NULL DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_date` datetime DEFAULT NULL,
  `enabled` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `answers` (`id`, `answer`, `question`, `created_date`, `modified_date`, `enabled`) VALUES
(1,    'MySQL',    3,    '2020-08-08 18:05:11',    NULL,    1),
(2,    'SQLite',    3,    '2020-08-08 18:30:00',    NULL,    1),
(3,    'PHP',    3,    '2020-08-08 18:34:22',    '2020-08-09 03:02:20',    1),
(4,    'True',    2,    '2020-08-08 18:46:23',    NULL,    1),
(5,    'False',    2,    '2020-08-08 18:46:30',    NULL,    1),
(6,    'B4A',    1,    '2020-08-08 18:47:00',    NULL,    1),
(7,    'B4J',    1,    '2020-08-08 18:47:10',    NULL,    1),
(8,    'B4i',    1,    '2020-08-08 18:47:20',    NULL,    1),
(9,    'B4i runs on Windows 10.',    4,    '2020-08-09 07:35:47',    NULL,    1),
(10,    'B4i can develop mac OS desktop app.',    4,    '2020-08-09 07:36:35',    NULL,    1),
(11,    'B4i is use to build and release app in jar format.',    4,    '2020-08-09 07:38:30',    '2020-08-15 04:30:49',    1),
(12,    'VSCode',    1,    '2020-08-10 14:15:23',    '2020-08-15 04:32:05',    1),
(13,    'Android',    5,    '2020-08-29 16:07:55',    NULL,    1),
(14,    'Microsoft Office',    5,    '2020-08-29 16:08:43',    NULL,    1),
(15,    'iOS',    5,    '2020-08-29 16:08:54',    NULL,    1),
(16,    'C stands for Create new record in database',    6,    '2020-10-05 19:12:36',    '2020-10-27 19:10:37',    1),
(17,    'R stands for Read or retrieve saved records',    6,    '2020-10-05 19:14:14',    '2020-10-27 19:11:07',    1),
(18,    'B4J is a 100% free development tool for desktop, server and IoT solutions.',    7,    '2020-10-27 10:33:55',    NULL,    1),
(19,    'With B4J you can easily create desktop applications (UI), console programs (non-UI) and server solutions.',    7,    '2020-10-27 10:34:12',    NULL,    1),
(20,    'The compiled apps can run on Windows, Mac, Linux and ARM boards (such as Raspberry Pi).',    7,    '2020-10-27 10:34:23',    NULL,    1),
(21,    'All of the above.',    7,    '2020-10-27 10:34:36',    NULL,    1),
(22,    'B4J creates cross platform desktop application that run on Windows, Mac, Linux and ARM boards.',    8,    '2020-10-27 10:52:19',    NULL,    1),
(23,    'B4A creates mobile apps that run on Apple iOS and iPad OS.',    8,    '2020-10-27 10:54:41',    '2020-10-27 18:55:27',    1),
(24,    'B4R is a 100% free development tool for native Arduino, ESP8266 and ESP32 programs.',    8,    '2020-10-27 10:56:28',    NULL,    1),
(25,    'B4i with the hosted Mac builder allow you to develop iOS applications on Windows.',    8,    '2020-10-27 11:03:19',    NULL,    1),
(26,    'U stands for Update or modify existing records.',    6,    '2020-10-27 11:12:42',    NULL,    1),
(27,    'D stands for Debug or error checking of the records.',    6,    '2020-10-27 11:14:18',    '2020-10-27 19:15:15',    1),
(28,    'SELECT',    9,    '2020-10-27 11:17:35',    NULL,    1),
(29,    'WHERE',    9,    '2020-10-27 11:17:50',    NULL,    1),
(30,    'SORT BY',    9,    '2020-10-27 11:20:55',    NULL,    1),
(31,    'GROUP BY',    9,    '2020-10-27 11:21:48',    NULL,    1);

DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL,
  `topic` int(11) NOT NULL DEFAULT '0',
  `answer` int(11) NOT NULL DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_date` datetime DEFAULT NULL,
  `enabled` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `questions` (`id`, `question`, `topic`, `answer`, `created_date`, `modified_date`, `enabled`) VALUES
(1,    'Which of the following is not a product of Anywhere Software?',    1,    12,    '2020-08-07 18:52:02',    '2020-10-27 18:30:01',    1),
(2,    'B4A is use to build Android apps.\r\nTrue or False?',    1,    4,    '2020-08-08 06:41:22',    '2020-08-30 03:15:14',    1),
(3,    'Which of the following is not a database?',    3,    3,    '2020-08-08 06:44:40',    '2020-10-06 16:04:05',    1),
(4,    'B4i is one of the B4X suite family.\r\nWhich statement is true about B4i?',    1,    9,    '2020-08-09 07:35:17',    '2020-08-30 10:16:07',    1),
(5,    'Which of the following is not mobile operating system?',    2,    14,    '2020-08-15 07:17:30',    '2020-08-30 00:08:58',    1),
(6,    'Which of the following does not describe CRUD of database operation?',    3,    27,    '2020-10-05 19:10:54',    '2020-10-27 19:14:25',    1),
(7,    'Which of the following statements is most accurate?',    1,    21,    '2020-10-27 10:33:32',    '2020-10-27 18:34:40',    1),
(8,    'Which is not true about the following products of B4X suite?',    1,    23,    '2020-10-27 10:50:44',    '2020-10-27 19:03:35',    1),
(9,    'Which is the following not a SQL keyword?',    3,    30,    '2020-10-27 11:17:19',    '2020-10-27 19:21:10',    1);

DROP TABLE IF EXISTS `results`;
CREATE TABLE `results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL DEFAULT '0',
  `topic` int(11) NOT NULL DEFAULT '0',
  `score` varchar(255) DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `results` (`id`, `user`, `topic`, `score`, `created_date`, `modified_date`) VALUES
(1,    3,    1,    '5/5',    '2020-11-03 16:34:34',    NULL),
(2,    3,    2,    '1/1',    '2020-11-03 16:34:40',    NULL),
(3,    3,    3,    '3/3',    '2020-11-03 16:34:52',    NULL);

DROP TABLE IF EXISTS `topics`;
CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic` varchar(255) NOT NULL,
  `shortdesc` varchar(255) NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_date` datetime DEFAULT NULL,
  `enabled` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `topics` (`id`, `topic`, `shortdesc`, `created_date`, `modified_date`, `enabled`) VALUES
(1,    'Topic 1: B4X',    'Questions related to B4X programming language and tools',    '2020-08-07 17:40:12',    '2020-09-01 00:06:26',    1),
(2,    'Topic 2: Mobile Development',    'Mobile development and applications related',    '2020-08-07 17:54:55',    '2020-10-27 19:28:28',    1),
(3,    'Topic 3: Database',    'Database or SQL commands',    '2020-08-14 20:33:01',    '2020-10-27 19:25:44',    1),
(4,    'Topic 4: Other',    'Software development and hardware related questions',    '2020-08-28 06:16:40',    '2020-10-27 19:29:36',    1),
(5,    'Topic 5',    '',    '2020-08-28 06:17:03',    '2020-10-27 19:26:37',    0);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT 'user',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_date` datetime DEFAULT NULL,
  `enabled` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_date`, `modified_date`, `enabled`) VALUES
(1,    'Admin',    NULL,    '21232f297a57a5a743894a0e4a801fc3',    'admin',    '2020-08-14 15:43:14',    NULL,    1),
(2,    'test',    'test@test.com',    '098f6bcd4621d373cade4e832627b4f6',    'user',    '2020-08-14 15:44:44',    '2020-10-06 03:09:12',    0),
(3,    'demo',    'demo@demo.com',    'fe01ce2a7fbac8fafaed7c982a04e229',    'user',    '2020-08-29 04:41:13',    '2020-09-01 12:37:04',    1);
