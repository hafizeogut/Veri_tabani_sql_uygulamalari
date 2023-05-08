-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ecommerce` ;

-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8 ;
USE `ecommerce` ;

-- -----------------------------------------------------
-- Table `ecommerce`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_code` VARCHAR(30) NOT NULL,
  `category_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`unit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`unit` (
  `unit_code` VARCHAR(2) NOT NULL,
  `unit_name` VARCHAR(20) NOT NULL,
  `unit_id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`unit_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`currency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`currency` (
  `currency_id` INT NOT NULL AUTO_INCREMENT,
  `currency_code` VARCHAR(3) NOT NULL,
  `currency_name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`currency_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`promotion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`promotion` (
  `promotion_id` INT NOT NULL AUTO_INCREMENT,
  `promotion_code` NVARCHAR(20) NOT NULL,
  `promotion_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`promotion_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`supplier` (
  `supplier_id` INT NOT NULL AUTO_INCREMENT,
  `supplier_code` VARCHAR(30) NOT NULL,
  `supplier_name` VARCHAR(50) NOT NULL,
  `country` VARCHAR(20) NULL,
  `province` VARCHAR(20) NULL,
  PRIMARY KEY (`supplier_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NOT NULL,
  `product_code` VARCHAR(30) NOT NULL,
  `product_name` VARCHAR(100) NOT NULL,
  `product_price` DECIMAL(10,2) NOT NULL,
  `buying_price` DECIMAL(10,2) NULL,
  `vat` DECIMAL(5,2) NOT NULL,
  `stock_qty` INT NOT NULL,
  `unit_id` INT NOT NULL,
  `currency_id` INT NOT NULL,
  `promotion_id` INT NULL,
  `supplier_id` INT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_product_category_idx` (`category_id` ASC) VISIBLE,
  INDEX `fk_product_unit1_idx` (`unit_id` ASC) VISIBLE,
  INDEX `fk_product_currency1_idx` (`currency_id` ASC) VISIBLE,
  INDEX `fk_product_promotion1_idx` (`promotion_id` ASC) VISIBLE,
  INDEX `fk_product_supplier1_idx` (`supplier_id` ASC) VISIBLE,
  CONSTRAINT `fk_product_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `ecommerce`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_unit1`
    FOREIGN KEY (`unit_id`)
    REFERENCES `ecommerce`.`unit` (`unit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_currency1`
    FOREIGN KEY (`currency_id`)
    REFERENCES `ecommerce`.`currency` (`currency_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_promotion1`
    FOREIGN KEY (`promotion_id`)
    REFERENCES `ecommerce`.`promotion` (`promotion_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_supplier1`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `ecommerce`.`supplier` (`supplier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(30) NOT NULL,
  `last_name` VARCHAR(30) NOT NULL,
  `country` VARCHAR(20) NOT NULL,
  `province` VARCHAR(20) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `tc_identity` VARCHAR(20) NULL,
  `registration_date` DATETIME NOT NULL,
  `birth_date` DATETIME NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`basket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`basket` (
  `basket_id` INT NOT NULL AUTO_INCREMENT,
  `basket_qty` INT NOT NULL,
  `product_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  INDEX `fk_basket_product1_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_basket_customer1_idx` (`customer_id` ASC) VISIBLE,
  PRIMARY KEY (`basket_id`),
  CONSTRAINT `fk_basket_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `ecommerce`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_basket_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `ecommerce`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`payment_method`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`payment_method` (
  `payment_method_id` INT NOT NULL AUTO_INCREMENT,
  `payment_code` VARCHAR(3) NOT NULL,
  `payment_name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`payment_method_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`order` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATETIME NOT NULL,
  `order_total` DECIMAL(15,2) NOT NULL,
  `customer_id` INT NOT NULL,
  `payment_method_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_customer_order_customer1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_customer_order_payment_method1_idx` (`payment_method_id` ASC) VISIBLE,
  CONSTRAINT `fk_customer_order_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `ecommerce`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customer_order_payment_method1`
    FOREIGN KEY (`payment_method_id`)
    REFERENCES `ecommerce`.`payment_method` (`payment_method_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`order_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`order_detail` (
  `order_detail_id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `order_qty` INT NOT NULL,
  `product_price` DECIMAL(10,2) NOT NULL,
  `vat` DECIMAL(5,2) NOT NULL,
  `line_total` DECIMAL(15,2) NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`order_detail_id`),
  INDEX `fk_customer_order_detail_customer_order1_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_order_detail_product1_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_customer_order_detail_customer_order1`
    FOREIGN KEY (`order_id`)
    REFERENCES `ecommerce`.`order` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_detail_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `ecommerce`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;










-- -----------------------------------------------------
-- Kategoriler
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`category` (`category_id`, `category_code`, `category_name`)
VALUES 
(1, 'ELB', 'Elbise'),
(2, 'AYK', 'Ayakkabı'),
(3, 'EVT', 'Ev Tekstili');

-- -----------------------------------------------------
-- Para Birimleri
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`currency`(`currency_id`,`currency_code`,`currency_name`)
VALUES
(1,'TL','Türk Lirası'),
(2,'USD','Dolar');

-- -----------------------------------------------------
-- Birimler
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`unit`(`unit_code`,`unit_name`,`unit_id`)
VALUES
('KG','Kilo', 1),
('AD','Adet', 2);

-- -----------------------------------------------------
-- Ödeme Metodları
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`payment_method`(`payment_method_id`,`payment_code`,`payment_name`)
VALUES 
(1, 'KK', 'Kredi Kartı'),
(2, 'BNK', 'Banka Havalesi');

-- -----------------------------------------------------
-- Müşteriler
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`customer`(`customer_id`,`first_name`,
`last_name`,`country`,`province`,`email`,`tc_identity`,
`registration_date`,`birth_date`)
VALUES 
(1, 'Mustafa', 'Tepeören', 'Türkiye', 'İstanbul', 'mustafa@gmail.com', '111222333', '2021-02-01', '1973-11-10'),
(2, 'Ali', 'Yılmaz', 'Türkiye', 'Ankara', 'aliyilmaz@gmail.com', '211222333', '2021-04-15', '1985-06-02'),
(3, 'Ayşe', 'Can', 'Türkiye', 'İzmir', 'aysecan@gmail.com', '311222333', '2021-06-02', '1982-04-01'),
(4, 'Veli', 'Bilir', 'Türkiye', 'İzmir', 'velibilir@gmail.com', '411222333', '2021-06-02', '1982-04-01'),
(5, 'Abuzer', 'Kadayıf', 'Türkiye', 'İzmir', 'abuzerkadayif@gmail.com', NULL, '2021-06-02', '1982-04-01'),
(6, 'Handan', 'Gül', 'Türkiye', 'İstanbul', 'handalgul@gmail.com', NULL, '2021-04-01', '1979-08-15');

INSERT INTO `ecommerce`.`supplier`
(`supplier_id`, `supplier_code`, `supplier_name`, `country`, `province`)
VALUES
(1, 'LC', 'LC Waikiki', 'Türkiye', 'İstanbul'),
(2, 'NIKE', 'NIKE', DEFAULT, DEFAULT),
(3, 'PUMA', 'PUMA', DEFAULT, DEFAULT);



-- -----------------------------------------------------
-- Promosyonlar
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`promotion`
(`promotion_id`,`promotion_code`,`promotion_name`)
VALUES
(1, 'Y10', '%10 İndirim'),
(2, '1A1B', '1 Alana 1 Bedava'),
(3, 'Y50', '%50 İndirim');


-- -----------------------------------------------------
-- Ürünler
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`product`
(`product_id`,`category_id`,`product_code`,`product_name`,
`product_price`,`vat`,`unit_id`,`currency_id`, `stock_qty`, `promotion_id`,
`supplier_id`, `buying_price`)
VALUES
(1, 1, 'GMK1','Yazlık Gömlek', 100, 18, 2, 1, 10, DEFAULT, 1, 75),
(2, 1, 'GMK2','Kışlık Gömlek', 100, 18, 2, 1, 5, 1, 2, 75),
(3, 1, 'TSH','T-Shirt', 50, 18, 2, 1, 100, 2, 2, DEFAULT),
(4, 1, 'POLO','Polo T-Shirt', 25, 18, 2, 2, 80, DEFAULT, 2, DEFAULT),
(5, 2, 'BA1','Yazlık Bayan Ayakkabı', 250, 18, 2, 1, 40, 1, 1, 175),
(6, 2, 'BA2','Kışlık Bayan Ayakkabı', 250, 18, 2, 1, 40, 1, DEFAULT, 175),
(7, 2, 'EA1','Yazlık Erkek Ayakkabı', 200, 18, 2, 1, 40, 2, 1, DEFAULT),
(8, 2, 'EA2','Kışlık Erkek Ayakkabı', 200, 18, 2, 1, 40, 2, 1, DEFAULT),
(9, 3, 'NV1','Tek Kişilik Nevresim', 200, 18, 2, 1, 20, DEFAULT, 2, 150),
(10, 3, 'NV2','Çift Kişilik Nevresim', 400, 18, 2, 1, 20, DEFAULT, DEFAULT, 300),
(11, 3, 'NV3','Çocuk Nevresim Takımı', 150, 18, 2, 1, 50, DEFAULT, DEFAULT, DEFAULT);

-- -----------------------------------------------------
-- Sepet
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`basket`
(`basket_qty`, `product_id`, `customer_id`)
VALUES
(1, 1, 1),
(1, 2, 1),
(2, 2, 5),
(1, 3, 6),
(1, 2, 6),
(2, 4, 4),
(1, 5, 3),
(3, 6, 2),
(1, 7, 1),
(2, 10, 3),
(1, 11, 5);



-- -----------------------------------------------------
-- Siparişler
-- -----------------------------------------------------
INSERT INTO `ecommerce`.`order` 
(`order_id`, `order_date`, `order_total`,`customer_id`,`payment_method_id`)
VALUES 
(1, '2021-06-30', 0, 1, 1),
(2, '2021-07-01', 0, 2, 1),
(3, '2021-07-01', 0, 3, 1),
(4, '2021-07-02', 0, 4, 1),
(5, '2021-07-02', 0, 5, 1),
(6, '2021-07-02', 0, 1, 1),
(7, '2021-07-03', 0, 3, 1);

INSERT INTO `ecommerce`.`order_detail`
(`order_detail_id`, `order_id`, `product_id`, `order_qty`, `product_price`, `vat`, `line_total`)
VALUES
(DEFAULT, 1, 1, 1, 0, 0, 0),
(DEFAULT, 1, 2, 1, 0, 0, 0),
(DEFAULT, 2, 5, 2, 0, 0, 0),
(DEFAULT, 2, 6, 1, 0, 0, 0),
(DEFAULT, 3, 7, 1, 0, 0, 0),
(DEFAULT, 3, 8, 1, 0, 0, 0),
(DEFAULT, 4, 9, 1, 0, 0, 0),
(DEFAULT, 4, 10, 1, 0, 0, 0),
(DEFAULT, 4, 11, 1, 0, 0, 0),
(DEFAULT, 5, 9, 1, 0, 0, 0),
(DEFAULT, 6, 9, 1, 0, 0, 0),
(DEFAULT, 6, 10, 1, 0, 0, 0),
(DEFAULT, 6, 11, 1, 0, 0, 0),
(DEFAULT, 7, 9, 1, 0, 0, 0),
(DEFAULT, 7, 10, 1, 0, 0, 0);

UPDATE order_detail od
SET product_price = (SELECT product_price FROM product WHERE product_id = od.product_id),
    vat = (SELECT vat FROM product WHERE product_id = od.product_id),
    line_total = (SELECT product_price * order_qty);
    
UPDATE `order` o    
SET 
	order_total = (SELECT SUM(line_total) FROM order_detail WHERE order_id = o.order_id);


