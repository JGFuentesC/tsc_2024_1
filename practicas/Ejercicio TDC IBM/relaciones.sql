ALTER TABLE `tdc`.`tbl_txn` 
ADD INDEX `fk_zip_idx` (`id_zip` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn` 
ADD CONSTRAINT `fk_zip`
  FOREIGN KEY (`id_zip`)
  REFERENCES `tdc`.`tbl_zip` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `tdc`.`tbl_txn` 
ADD INDEX `fk_user_idx` (`id_user` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn` 
ADD CONSTRAINT `fk_user`
  FOREIGN KEY (`id_user`)
  REFERENCES `tdc`.`tbl_user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `tdc`.`tbl_txn` 
ADD INDEX `fk_card_idx` (`id_card` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn` 
ADD CONSTRAINT `fk_card`
  FOREIGN KEY (`id_card`)
  REFERENCES `tdc`.`tbl_card` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;



ALTER TABLE `tdc`.`tbl_txn` 
ADD INDEX `fk_txn_type_idx` (`id_txn_type` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn` 
ADD CONSTRAINT `fk_txn_type`
  FOREIGN KEY (`id_txn_type`)
  REFERENCES `tdc`.`tbl_txn_type` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `tdc`.`tbl_txn` 
ADD INDEX `fk_comercio_idx` (`id_comercio` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn` 
ADD CONSTRAINT `fk_comercio`
  FOREIGN KEY (`id_comercio`)
  REFERENCES `tdc`.`tbl_merchant` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  ALTER TABLE `tdc`.`tbl_txn` 
ADD INDEX `fk_territory_idx` (`id_territory` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn` 
ADD CONSTRAINT `fk_territory`
  FOREIGN KEY (`id_territory`)
  REFERENCES `tdc`.`tbl_territory` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `tdc`.`tbl_txn` 
ADD INDEX `fk_city_idx` (`id_city` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn` 
ADD CONSTRAINT `fk_city`
  FOREIGN KEY (`id_city`)
  REFERENCES `tdc`.`tbl_city` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  ALTER TABLE `tdc`.`tbl_txn` 
ADD INDEX `fk_mcc_idx` (`id_mcc` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn` 
ADD CONSTRAINT `fk_mcc`
  FOREIGN KEY (`id_mcc`)
  REFERENCES `tdc`.`tbl_mcc` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `tdc`.`tbl_card` 
ADD INDEX `fk_user_idx` (`id_user` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_card` 
ADD CONSTRAINT `fk_user_card`
  FOREIGN KEY (`id_user`)
  REFERENCES `tdc`.`tbl_user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `tdc`.`tbl_city` 
ADD INDEX `fk_territory_idx` (`id_territory` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_city` 
ADD CONSTRAINT `fk_territory_city`
  FOREIGN KEY (`id_territory`)
  REFERENCES `tdc`.`tbl_territory` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


  ALTER TABLE `tdc`.`tbl_txn_error` 
ADD INDEX `fk_puente_txn_idx` (`id_txn` ASC) VISIBLE,
ADD INDEX `fk_puente_error_idx` (`id_error` ASC) VISIBLE;
;
ALTER TABLE `tdc`.`tbl_txn_error` 
ADD CONSTRAINT `fk_puente_txn`
  FOREIGN KEY (`id_txn`)
  REFERENCES `tdc`.`tbl_txn` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_puente_error`
  FOREIGN KEY (`id_error`)
  REFERENCES `tdc`.`tbl_txn_error` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `tdc`.`tbl_txn_error` 
DROP FOREIGN KEY `fk_puente_error`;
ALTER TABLE `tdc`.`tbl_txn_error` 
ADD INDEX `fk_puente_error_idx` (`id_error` ASC) VISIBLE,
DROP INDEX `fk_puente_error_idx` ;
;
ALTER TABLE `tdc`.`tbl_txn_error` 
ADD CONSTRAINT `fk_puente_error`
  FOREIGN KEY (`id_error`)
  REFERENCES `tdc`.`tbl_error` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
