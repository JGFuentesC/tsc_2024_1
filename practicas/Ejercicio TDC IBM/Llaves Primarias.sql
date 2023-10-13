ALTER TABLE `tdc`.`tbl_card` 
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);


ALTER TABLE `tdc`.`tbl_city` 
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);


ALTER TABLE `tdc`.`tbl_error` 
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);


ALTER TABLE `tdc`.`tbl_mcc`
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);


ALTER TABLE `tdc`.`tbl_merchant`
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `tdc`.`tbl_territory`
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `tdc`.`tbl_txn_error`
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;


ALTER TABLE `tdc`.`tbl_txn_type`
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);


ALTER TABLE `tdc`.`tbl_user`
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);


ALTER TABLE `tdc`.`tbl_zip`
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `tdc`.`tbl_txn`
CHANGE COLUMN `id` `id` INT NOT NULL ,
ADD PRIMARY KEY (`id`);
