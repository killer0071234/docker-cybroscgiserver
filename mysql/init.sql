
-- -----------------------------------------------------
-- Current state
-- -----------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cybro
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cybro` DEFAULT CHARACTER SET utf8;
USE `cybro`;

-- -----------------------------------------------------
-- Table `cybro`.`measurements`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cybro`.`measurements` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `nad` INT(11) NOT NULL COMMENT 'Cybro device NAD',
  `tag` VARCHAR(40) NOT NULL COMMENT 'Cybro variable name',
  `value` VARCHAR(16) NOT NULL COMMENT 'Cybro variable value',
  `timestamp` DATETIME NOT NULL COMMENT 'Date and time when record is created',
  PRIMARY KEY (`id`),
  INDEX `tag_index` (`tag` ASC))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COMMENT = 'Table holds measurements data, defined by sample tag in data_logger.xml';

-- -----------------------------------------------------
-- Table `cybro`.`alarms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cybro`.`alarms` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `type` INT(11) NOT NULL COMMENT '1-alarm, 2-event',
  `nad` INT(11) NOT NULL COMMENT 'Cybro device NAD',
  `tag` VARCHAR(40) NOT NULL COMMENT 'Cybro variable name',
  `value` VARCHAR(16) NOT NULL COMMENT 'Cybro variable value',
  `priority` TINYINT(1) NOT NULL COMMENT 'Task priority: 0-low, 1-medium, 2-high',
  `class` VARCHAR(20) NOT NULL COMMENT 'Maps to task class tag in data_logger.xml, user-defineable.',
  `message` VARCHAR(50) NOT NULL COMMENT 'Alarm message configured by user',
  `timestamp_raise` DATETIME NOT NULL COMMENT 'Date and time alarm was triggered',
  `timestamp_gone` DATETIME NOT NULL COMMENT 'Date and time state of cybro variable returned to normal',
  `timestamp_ack` DATETIME NOT NULL COMMENT 'Date and time operator acknowledged alarm',
  PRIMARY KEY (`id`),
  INDEX `tag_index` (`tag` ASC))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COMMENT = 'Table holds triggered alarms and events, defined in data_logger.xml';

-- -----------------------------------------------------
-- Table `cybro`.`relays`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cybro`.`relays` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `user_id` INT(11) NOT NULL,
  `enabled` TINYINT(1) NOT NULL,
  `session_id` INT(11) UNSIGNED NOT NULL COMMENT 'Allowed client id',
  `message_count_rx` INT(11) NOT NULL,
  `message_count_tx` INT(11) NOT NULL,
  `last_message` DATETIME NULL DEFAULT NULL,
  `last_controller_nad` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id_refs_user_ptr_id_2c1e7d40` (`user_id` ASC))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COMMENT = 'Table holds list of allowed clients for relaying abus messages from CyPro to Cybro';
