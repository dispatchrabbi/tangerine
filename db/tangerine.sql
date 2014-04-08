SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `tangerine` DEFAULT CHARACTER SET utf8 ;
USE `tangerine` ;

-- -----------------------------------------------------
-- Table `tangerine`.`carriers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`carriers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `viable` TINYINT(1) NOT NULL ,
  `pattern` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`teams`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`teams` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `assignment` VARCHAR(255) NOT NULL DEFAULT '' ,
  `supervisor` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `team_supervisor_idx` (`supervisor` ASC) ,
  CONSTRAINT `team_supervisor`
    FOREIGN KEY (`supervisor` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`pairs`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`pairs` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `label` TEXT NOT NULL DEFAULT '' COMMENT 'label\\\'s format is still under consideration' ,
  `team` INT UNSIGNED ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `pair_team_idx` (`team` ASC) ,
  CONSTRAINT `pair_team`
    FOREIGN KEY (`team` )
    REFERENCES `tangerine`.`teams` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`details`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`details` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `description` TEXT NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`permission_groups`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`permission_groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `permissions` SET('canLogIn') NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) ,
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`ops`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`ops` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `first` VARCHAR(255) NOT NULL ,
  `last` VARCHAR(255) NOT NULL ,
  `suffix` VARCHAR(255) NOT NULL DEFAULT '' ,
  `callsign` VARCHAR(255) NOT NULL ,
  `squad` INT UNSIGNED NOT NULL ,
  `title` VARCHAR(255) NOT NULL DEFAULT 'op' ,
  `supervisor` INT UNSIGNED NULL ,
  `cellNumber` VARCHAR(10) NULL ,
  `carrier` INT UNSIGNED NULL ,
  `email` VARCHAR(255) NOT NULL ,
  `dob` DATE NULL ,
  `gender` VARCHAR(255) NOT NULL ,
  `pronouns` VARCHAR(255) NOT NULL DEFAULT '' ,
  `medicalNotes` TEXT NOT NULL DEFAULT '' ,
  `onShift` TINYINT(1) NOT NULL DEFAULT 0 ,
  `availability` VARCHAR(255) NOT NULL DEFAULT 'unavailable' ,
  `pair` INT UNSIGNED NULL ,
  `detail` INT UNSIGNED NULL ,
  `hasArrived` TINYINT(1) NOT NULL DEFAULT 0 ,
  `password` TEXT NULL ,
  `checkedIn` DATETIME NULL ,
  `checkedOut` DATETIME NULL ,
  `permissions` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `callsign_UNIQUE` (`callsign` ASC) ,
  INDEX `op_squad_idx` (`squad` ASC) ,
  INDEX `op_supervisor_idx` (`supervisor` ASC) ,
  INDEX `op_carrier_idx` (`carrier` ASC) ,
  INDEX `op_pair_idx` (`pair` ASC) ,
  INDEX `op_detail_idx` (`detail` ASC) ,
  INDEX `op_permissions_idx` (`permissions` ASC) ,
  CONSTRAINT `op_squad`
    FOREIGN KEY (`squad` )
    REFERENCES `tangerine`.`squads` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `op_supervisor`
    FOREIGN KEY (`supervisor` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `op_carrier`
    FOREIGN KEY (`carrier` )
    REFERENCES `tangerine`.`carriers` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `op_pair`
    FOREIGN KEY (`pair` )
    REFERENCES `tangerine`.`pairs` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `op_detail`
    FOREIGN KEY (`detail` )
    REFERENCES `tangerine`.`details` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `op_permissions`
    FOREIGN KEY (`permissions` )
    REFERENCES `tangerine`.`permission_groups` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`squads`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`squads` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `commander` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) ,
  INDEX `squad_commander_idx` (`commander` ASC) ,
  CONSTRAINT `squad_commander`
    FOREIGN KEY (`commander` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`channels`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`channels` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `number` VARCHAR(255) NOT NULL ,
  `purpose` VARCHAR(255) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `number_UNIQUE` (`number` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`attendees`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`attendees` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` TEXT NOT NULL DEFAULT '' ,
  `badgeName` TEXT NOT NULL DEFAULT '' ,
  `badgeNumber` TEXT NOT NULL DEFAULT '' ,
  `contactInfo` TEXT NOT NULL DEFAULT '' ,
  `notes` TEXT NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`) ,
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`gear`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`gear` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `serialNumber` VARCHAR(255) NOT NULL ,
  `type` VARCHAR(255) NOT NULL ,
  `owner` INT UNSIGNED NULL ,
  `flags` SET('broken') NOT NULL DEFAULT '',
  `channel` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `serialNumber_UNIQUE` (`serialNumber` ASC) ,
  INDEX `op_idx` (`owner` ASC) ,
  CONSTRAINT `gear_owner`
    FOREIGN KEY (`owner` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
  CONSTRAINT `gear_channel`
    FOREIGN KEY (`channel`)
    REFERENCES `tangerine`.`channels` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`gear_transactions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`gear_transactions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `gear` INT UNSIGNED NOT NULL ,
  `timestamp` DATETIME NOT NULL ,
  `type` VARCHAR(255) NOT NULL ,
  `actor` INT UNSIGNED NOT NULL ,
  `target` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `geart_timestamp` (`timestamp` ASC) ,
  INDEX `geart_gear_idx` (`gear` ASC) ,
  INDEX `geart_actor_idx` (`actor` ASC) ,
  INDEX `geart_target_idx` (`actor` ASC) ,
  CONSTRAINT `gear_transactions_gear`
    FOREIGN KEY (`gear` )
    REFERENCES `tangerine`.`gear` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `gear_transactions_actor`
    FOREIGN KEY (`actor` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `gear_transactions_target`
    FOREIGN KEY (`actor` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `tangerine`.`incident_reports`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`incident_reports` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `description` VARCHAR(255) NOT NULL ,
  `timestamp` DATETIME NOT NULL ,
  `offense` TEXT NOT NULL DEFAULT '' ,
  `actionTaken` TEXT NOT NULL DEFAULT '' ,
  `narrative` TEXT NOT NULL ,
  `lastModified` DATETIME NOT NULL ,
  `author` INT UNSIGNED NOT NULL ,
  `submittedTime` DATETIME NULL ,
  `checker` INT UNSIGNED NULL ,
  `checkedTime` DATETIME NULL ,
  `acceptor` INT UNSIGNED NULL ,
  `acceptedTime` DATETIME NULL ,
  `status` VARCHAR(255) NOT NULL DEFAULT 'unfinished' ,
  `changesNeeded` TEXT NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`) ,
  INDEX `incident_reports_submittedTime` (`sumbittedTime` ASC) ,
  INDEX `incident_reports_author_idx` (`author` ASC) ,
  INDEX `incident_reports_checker_idx` (`author` ASC) ,
  INDEX `incident_reports_acceptor_idx` (`acceptor` ASC) ,
  CONSTRAINT `incident_reports_author`
    FOREIGN KEY (`author` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `incident_reports_checker`
    FOREIGN KEY (`author` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `incident_reports_acceptor`
    FOREIGN KEY (`acceptor` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`missing_person_reports`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`missing_person_reports` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `description` TEXT NOT NULL DEFAULT '' ,
  `contact` TEXT NOT NULL ,
  `contactRelation` TEXT NOT NULL ,
  `contactInfo` TEXT NOT NULL ,
  `reporter` INT UNSIGNED NOT NULL ,
  `reportedTime` DATETIME NOT NULL ,
  `flags` SET('amber') DEFAULT '' ,
  `foundTime` DATETIME NULL ,
  `foundDescription` TEXT NULL ,
  `status` VARCHAR(255) NOT NULL DEFAULT 'open' ,
  PRIMARY KEY (`id`) ,
  INDEX `missing_person_reports_reportedTime` (`reportedTime` ASC) ,
  INDEX `missing_person_reports_reporter_idx` (`reporter` ASC) ,
  CONSTRAINT `missing_person_reports_reporter`
    FOREIGN KEY (`reporter` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`missing_person_characteristics`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`missing_person_characteristics` (
  `report` INT UNSIGNED NOT NULL ,
  `key` VARCHAR(255) NOT NULL ,
  `value` TEXT NOT NULL ,
  PRIMARY KEY (`report`, `key`) ,
  INDEX `characteristic_report_idx` (`report` ASC) ,
  CONSTRAINT `characteristic_report`
    FOREIGN KEY (`report` )
    REFERENCES `tangerine`.`missing_person_reports` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`offenders`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`offenders` (
  `report` INT UNSIGNED NOT NULL ,
  `offender` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`report`, `offender`) ,
  INDEX `offenders_offender_idx` (`offender` ASC) ,
  CONSTRAINT `offenders_report`
    FOREIGN KEY (`report` )
    REFERENCES `tangerine`.`incident_reports` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `offenders_offender`
    FOREIGN KEY (`offender` )
    REFERENCES `tangerine`.`attendees` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`incident_ops`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`incident_ops` (
  `report` INT UNSIGNED NOT NULL ,
  `op` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`report`, `op`) ,
  INDEX `incident_ops_op_idx` (`op` ASC) ,
  CONSTRAINT `incident_ops_report`
    FOREIGN KEY (`report` )
    REFERENCES `tangerine`.`incident_reports` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `incident_ops_op`
    FOREIGN KEY (`op` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`log_entries`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`log_entries` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `message` TEXT NOT NULL ,
  `logger` INT UNSIGNED NOT NULL ,
  `type` VARCHAR(255) NOT NULL ,
  `from` TEXT NOT NULL DEFAULT '' ,
  `to` TEXT NOT NULL DEFAULT '' ,
  `channel` INT UNSIGNED NULL ,
  `op` INT UNSIGNED NULL ,
  `pair` INT UNSIGNED NULL ,
  `team` INT UNSIGNED NULL ,
  `detail` INT UNSIGNED NULL ,
  `availability` VARCHAR(255) NULL ,
--  `onShift` TINYINT(1) NULL , -- does not actually make sense yet
  PRIMARY KEY (`id`) ,
  INDEX `log_entry_logger_idx` (`logger` ASC) ,
  INDEX `log_entry_channel_idx` (`channel` ASC) ,
  INDEX `log_entry_op_idx` (`op` ASC) ,
  INDEX `log_entry_pair_idx` (`pair` ASC) ,
  INDEX `log_entry_team_idx` (`team` ASC) ,
  INDEX `log_entry_detail_idx` (`detail` ASC) ,
  CONSTRAINT `log_entry_logger`
    FOREIGN KEY (`logger` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `log_entry_channel`
    FOREIGN KEY (`channel` )
    REFERENCES `tangerine`.`channels` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `log_entry_op`
    FOREIGN KEY (`op` )
    REFERENCES `tangerine`.`ops` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `log_entry_pair`
    FOREIGN KEY (`pair` )
    REFERENCES `tangerine`.`pairs` (`id` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `log_entry_team`
    FOREIGN KEY (`team` )
    REFERENCES `tangerine`.`teams` (`id` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `log_entry_detail`
    FOREIGN KEY (`detail` )
    REFERENCES `tangerine`.`details` (`id` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`related`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`related` (
  `report` INT UNSIGNED NOT NULL ,
  `attendee` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`report`, `attendee`) ,
  INDEX `offenders_report_idx` (`report` ASC) ,
  INDEX `offenders_offender_idx` (`attendee` ASC) ,
  CONSTRAINT `related_report`
    FOREIGN KEY (`report` )
    REFERENCES `tangerine`.`incident_reports` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `related_attendee`
    FOREIGN KEY (`attendee` )
    REFERENCES `tangerine`.`attendees` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`victims`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`victims` (
  `report` INT UNSIGNED NOT NULL ,
  `victim` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`report`, `victim`) ,
  INDEX `offenders_offender_idx` (`victim` ASC) ,
  CONSTRAINT `victims_report`
    FOREIGN KEY (`report` )
    REFERENCES `tangerine`.`incident_reports` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `victims_victim`
    FOREIGN KEY (`victim` )
    REFERENCES `tangerine`.`attendees` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tangerine`.`witnesses`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `tangerine`.`witnesses` (
  `report` INT UNSIGNED NOT NULL ,
  `witness` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`report`, `witness`) ,
  INDEX `offenders_offender_idx` (`witness` ASC) ,
  CONSTRAINT `witnesses_report`
    FOREIGN KEY (`report` )
    REFERENCES `tangerine`.`incident_reports` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `witnesses_witness`
    FOREIGN KEY (`witness` )
    REFERENCES `tangerine`.`attendees` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
