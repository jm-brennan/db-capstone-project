-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LittleLemonDB` ;

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Customers` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `CustomerID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `PhoneNumber` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Employees`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Employees` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Employees` (
  `EmployeeID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Role` VARCHAR(45) NULL,
  `Salary` DECIMAL(19,4) NULL,
  `Address` VARCHAR(45) NULL,
  `PhoneNumber` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  PRIMARY KEY (`EmployeeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Bookings` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `BookingDate` DATE NULL,
  `TableNumber` INT NULL,
  `CustomerID` INT NULL,
  `EmployeeID` INT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `fk_customer_id_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `fk_employee_id_idx` (`EmployeeID` ASC) VISIBLE,
  CONSTRAINT `fk_customer_id`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDB`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_employee_id`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `LittleLemonDB`.`Employees` (`EmployeeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`DeliveryStatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`DeliveryStatus` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`DeliveryStatus` (
  `DeliveryID` INT NOT NULL,
  `Status` VARCHAR(45) NULL,
  `DeliveryDate` DATE NULL,
  PRIMARY KEY (`DeliveryID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Orders` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `BookingID` INT NULL,
  `TotalCost` DECIMAL NULL,
  `DeliveryStatusID` INT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_booking_id_idx` (`BookingID` ASC) VISIBLE,
  INDEX `fk_delivery_status_id_idx` (`DeliveryStatusID` ASC) VISIBLE,
  CONSTRAINT `fk_booking_id`
    FOREIGN KEY (`BookingID`)
    REFERENCES `LittleLemonDB`.`Bookings` (`BookingID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_delivery_status_id`
    FOREIGN KEY (`DeliveryStatusID`)
    REFERENCES `LittleLemonDB`.`DeliveryStatus` (`DeliveryID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Menus` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menus` (
  `MenuID` INT NOT NULL AUTO_INCREMENT,
  `Cuisine` VARCHAR(45) NULL,
  PRIMARY KEY (`MenuID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`MenuItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`MenuItems` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`MenuItems` (
  `MenuItemID` INT NOT NULL AUTO_INCREMENT,
  `MenuID` INT NULL,
  `Dish` VARCHAR(45) NULL,
  `CourseType` VARCHAR(45) NULL,
  `Price` DECIMAL(19,4) NULL,
  PRIMARY KEY (`MenuItemID`),
  INDEX `fk_menu_id_idx` (`MenuID` ASC) VISIBLE,
  CONSTRAINT `fk_menu_id`
    FOREIGN KEY (`MenuID`)
    REFERENCES `LittleLemonDB`.`Menus` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`OrderItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`OrderItems` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrderItems` (
  `OrderID` INT NULL,
  `MenuItemID` INT NULL,
  INDEX `fk_mi_id_idx` (`MenuItemID` ASC) VISIBLE,
  INDEX `fk_order_id_idx` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `fk_order_id`
    FOREIGN KEY (`OrderID`)
    REFERENCES `LittleLemonDB`.`Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_mi_id`
    FOREIGN KEY (`MenuItemID`)
    REFERENCES `LittleLemonDB`.`MenuItems` (`MenuItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
