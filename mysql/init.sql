#mysql config for cybroscgi server
CREATE DATABASE `solar` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;

CREATE USER 'solaruser'@'%' IDENTIFIED BY 'solarpassword';

GRANT ALL PRIVILEGES ON * . * TO 'solaruser'@'%' IDENTIFIED BY 'solarpassword' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;

GRANT ALL PRIVILEGES ON `solar` . * TO 'solaruser'@'%';

FLUSH PRIVILEGES;

-- --------------------------------------------------------
--
-- Table structure for table `alarms`
--

CREATE TABLE IF NOT EXISTS `alarms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `nad` int(11) NOT NULL,
  `priority` tinyint(4) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `tag` varchar(40) NOT NULL,
  `value` varchar(16) NOT NULL,
  `class` varchar(20) NOT NULL,
  `message` varchar(50) NOT NULL,
  `timestamp_raise` datetime NOT NULL,
  `timestamp_gone` datetime NOT NULL,
  `timestamp_ack` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tag_index` (`tag`),
  KEY `tag_id_refs_id_8c986686` (`tag_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------
--
-- Table structure for table `controllers`
--

CREATE TABLE IF NOT EXISTS `controllers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nad` int(11) NOT NULL,
  `location` varchar(50) NOT NULL,
  `function` varchar(1000) NOT NULL,
  `created_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `plant_id` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL,
  `connection_type` int(11) NOT NULL DEFAULT '0',
  `password` varchar(30) NOT NULL DEFAULT '',
  `comm_status` int(11) NOT NULL DEFAULT '0',
  `date_added` datetime NOT NULL,
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nad_index` (`nad`),
  KEY `controllers_created_id` (`created_id`),
  KEY `controllers_owner_id` (`owner_id`),
  KEY `controllers_plant_id` (`plant_id`),
  KEY `plant_id_refs_id_9918366d` (`plant_id`),
  KEY `owner_id_refs_user_ptr_id_7e341e7c` (`owner_id`),
  KEY `created_id_refs_user_ptr_id_7e341e7c` (`created_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------
--
-- Table structure for table `measurements`
--

CREATE TABLE IF NOT EXISTS `measurements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nad` int(11) NOT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `tag` varchar(40) NOT NULL,
  `value` varchar(16) NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tag_index` (`tag`),
  KEY `timestamp_index` (`timestamp`),
  KEY `tag_id_refs_id_43bfa9c1` (`tag_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------
--
-- Table structure for table `relays`
--

CREATE TABLE IF NOT EXISTS `relays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `session_id` int(11) unsigned NOT NULL,
  `message_count_tx` int(11) NOT NULL,
  `message_count_rx` int(11) NOT NULL,
  `last_message` datetime DEFAULT NULL,
  `last_controller_nad` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_refs_user_ptr_id_2c1e7d40` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
