-- Author: Robin Wen
-- Date: 15:09:09 2015-04-01
-- Desc: MySQL audit of trigger.
-- Ref: http://t.cn/RA5KS9K

USE robin;

-- Create table t_car.
DROP TABLE t_car;
CREATE TABLE t_car(
`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
`car_number`   VARCHAR(45)  DEFAULT '' COMMENT '车牌号',
`card_number`  VARCHAR(45)  DEFAULT '' COMMENT '卡片编号',
`pay`          DECIMAL(6,1)  DEFAULT 0 COMMENT '金额',
PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create table t_record, record operation.
DROP TABLE t_record;
CREATE TABLE  t_record(
`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
`username`     VARCHAR(45)       DEFAULT '' COMMENT '登录mysql的用户名',
`client_ip`      VARCHAR(45)  DEFAULT '' COMMENT '远程访问mysql服务器的客户端ip地址',
`update_Before`  VARCHAR(45)         DEFAULT '' COMMENT '修改前的金额',
`update_After`   VARCHAR(45)         DEFAULT '' COMMENT '修改后的金额',
`gmt_create`    TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create trigger for mysql audit.
DELIMITER $$
DROP TRIGGER tri_t_car;
CREATE TRIGGER tri_t_car BEFORE UPDATE ON t_car FOR EACH ROW
BEGIN
   IF NEW.pay<>OLD.pay THEN
      INSERT INTO t_record(username,client_ip,update_Before,update_After,gmt_create) VALUES(SUBSTRING_INDEX(USER(),'@',1),SUBSTRING_INDEX(USER(),'@',-1),OLD.pay,NEW.pay,NOW());
   END IF;
END $$
DELIMITER ;

-- Generate testing data.
INSERT INTO t_car(car_number,card_number,pay)
VALUES(SUBSTRING(RAND(),3,20),SUBSTRING(RAND(),3,10),SUBSTRING(RAND(),3,3)),
(SUBSTRING(RAND(),3,20),SUBSTRING(RAND(),3,10),SUBSTRING(RAND(),3,3)),
(SUBSTRING(RAND(),3,20),SUBSTRING(RAND(),3,10),SUBSTRING(RAND(),3,3));
