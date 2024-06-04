CREATE TABLE `player_levels` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`reputation` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`citizenid`) USING BTREE,
	INDEX `id` (`id`) USING BTREE,
	CONSTRAINT `reputation` CHECK (json_valid(`reputation`))
)
COMMENT='Players experience per job.'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2
;