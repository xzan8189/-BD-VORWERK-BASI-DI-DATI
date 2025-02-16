DROP DATABASE IF EXISTS progetto;
CREATE DATABASE progetto;

DROP USER IF EXISTS 'ospite'@'localhost';
CREATE USER 'ospite'@'localhost' IDENTIFIED BY 'ospite';
GRANT ALL ON progetto.* TO 'ospite'@'localhost';

USE progetto;

CREATE TABLE PARTECIPANTE (
	`CF` CHAR(16) NOT NULL,
    `Nome` VARCHAR(15) NOT NULL,
	`Cognome` VARCHAR(15) NOT NULL,
    `Email` VARCHAR(30) NOT NULL UNIQUE,
    PRIMARY KEY (`CF`),
    CHECK (LENGTH(`CF`)=16 AND RIGHT(`Email`, 8)='@mail.it')
);

CREATE TABLE CLIENTE (
	`CF` CHAR(16) NOT NULL,
    `Nome` VARCHAR(15) NOT NULL,
	`Cognome` VARCHAR(15) NOT NULL,
	`Luogo_nascita` VARCHAR(15) NOT NULL,
	`Data_nascita` DATE NOT NULL,
	`Email` VARCHAR(30) NOT NULL UNIQUE,
    `Via` VARCHAR(30) NOT NULL,
	`Civico` INT NOT NULL,
	`CAP` CHAR(5) NOT NULL,
    `Data_corrente` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`CF`),
    CHECK (LENGTH(`CF`)=16 AND LENGTH(`CAP`)=5 AND DATEDIFF(`Data_corrente`,`Data_nascita`)>=6480 AND RIGHT(`Email`, 8)='@mail.it')
);

CREATE TABLE DIPENDENTE (
	`CF` CHAR(16) NOT NULL,
	`Nome` VARCHAR(15) NOT NULL,
	`Cognome` VARCHAR(15) NOT NULL,
	`Data_ass` DATE NOT NULL,
	`Tipo` ENUM('RAPPRESENTANTE', 'IMPIEGATO') NOT NULL,
	PRIMARY KEY (`CF`),
    CHECK (LENGTH(`CF`)=16)
);

CREATE TABLE TELEFONO_D (
	`Numero` CHAR(10) NOT NULL PRIMARY KEY,
	`CF` CHAR(16) NOT NULL REFERENCES DIPENDENTE(`CF`) ON DELETE CASCADE,
    CHECK (LENGTH(`CF`)=16 AND LENGTH(`Numero`)=10)
);

CREATE TABLE TELEFONO_C (
	`Numero` CHAR(10) NOT NULL PRIMARY KEY,
	`CF` CHAR(16) NOT NULL REFERENCES CLIENTE(`CF`) ON DELETE CASCADE,
    CHECK (LENGTH(`CF`)=16 AND LENGTH(`Numero`)=10)
);

CREATE TABLE SPEDIZIONE_1 (
	`#spedizione` INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	`Corr` VARCHAR(30) NOT NULL,
	`Data` DATE NULL,
	`CF` CHAR(16) NULL REFERENCES DIPENDENTE(`CF`) ON DELETE SET NULL,

    CHECK (LENGTH(`CF`)=16)
);

alter table spedizione_1 auto_increment=10050;

CREATE TABLE SPEDIZIONE_2 ( 
	`Corr` VARCHAR(30) NOT NULL,
	`Tel` CHAR(10) NOT NULL,
	PRIMARY KEY (`Corr`),
    CHECK (LENGTH(`Tel`)=10)
);

CREATE TABLE ROBOT_2 (
	`Modello` ENUM('TM5', 'TM6') NOT NULL,
	`Prezzo` DOUBLE NOT NULL,
	PRIMARY KEY (`Modello`),
    CHECK ((`Modello`='TM5'AND `Prezzo`=1000) OR (`Modello`='TM6'AND `Prezzo`=1600))
);

CREATE TABLE ROBOT_1 (
	`Seriale` CHAR(6) NOT NULL PRIMARY KEY,
	`Modello` ENUM('TM5', 'TM6') NOT NULL,
	`#spedizione` INT NULL REFERENCES SPEDIZIONE_1(`#spedizione`) ON DELETE SET NULL,
    CHECK (LENGTH(`Seriale`)=6)
); 

CREATE TABLE RICETTA (
	`Nome` VARCHAR(80) NOT NULL,
	`Autore` VARCHAR(30) NOT NULL,
	`Difficoltà` INT NOT NULL,
	`Descrizione` VARCHAR(400) NOT NULL,
	PRIMARY KEY (`Nome`,`Autore`),
    CHECK (`Difficoltà`>=1 AND `Difficoltà`<=10)
);

CREATE TABLE INGREDIENTE (
	`Nome` VARCHAR(15) NOT NULL,
	PRIMARY KEY (`Nome`)
);

CREATE TABLE PREMIO ( 
	`Nome` VARCHAR(60) NOT NULL,
	`Punti` INT NOT NULL,
	`#unità` INT NOT NULL,
	PRIMARY KEY (`Nome`),
    CHECK (`Punti`>= 350 AND `#unità`>=0)
);

CREATE TABLE ACCOUNTT(
	`Username` VARCHAR(15) NOT NULL PRIMARY KEY,
	`Password` VARCHAR(30) NOT NULL,
	`Punti` INT NOT NULL,
	`CF` CHAR(16) NOT NULL UNIQUE REFERENCES CLIENTE(`CF`) ON DELETE CASCADE,
    CHECK (`Punti`>= 0)
);

CREATE TABLE ABBONATO ( 
	`Username` VARCHAR(15) NOT NULL,
	`Data_fine` DATE NOT NULL,
	FOREIGN KEY (`Username`) REFERENCES ACCOUNTT(`Username`) ON DELETE CASCADE,
	PRIMARY KEY (`Username`)
);

CREATE TABLE DIMOSTRAZIONE (
	`CF` CHAR(16) NOT NULL,
	`Username` VARCHAR(16) NOT NULL,
	`Data` DATE NOT NULL,
	`Luogo` VARCHAR(30) NOT NULL,
    FOREIGN KEY (`CF`) REFERENCES DIPENDENTE(`CF`) ON DELETE CASCADE,
    FOREIGN KEY (`Username`) REFERENCES ACCOUNTT(`Username`) ON DELETE CASCADE,
	PRIMARY KEY (`CF`, `Username`, `Data`)
);

CREATE TABLE VENDITA ( 
	`CF_C` CHAR(16) NOT NULL,
	`CF_D` CHAR(16) NOT NULL ,
    `Data_richiesta` DATE NOT NULL,
	`IBAN` CHAR(27) NULL,
	`Quota_rate` DECIMAL(5, 2) NULL,
	`#rate` ENUM('12', '24', '36') NULL,
	`Seriale` CHAR(6) NOT NULL UNIQUE REFERENCES ROBOT_1(`Seriale`),
    FOREIGN KEY (`CF_D`) REFERENCES DIPENDENTE(`CF`) ON DELETE CASCADE,
    FOREIGN KEY (`CF_C`) REFERENCES CLIENTE(`CF`) ON DELETE CASCADE,
	PRIMARY KEY (`CF_D`, `CF_C`, `Data_richiesta`),
    CHECK (LENGTH(`IBAN`)=27)
);

CREATE TABLE BASE (
	`Nome` VARCHAR(80) NOT NULL,
	`Autore` VARCHAR(30) NOT NULL,
	FOREIGN KEY (`Nome`, `Autore`) REFERENCES RICETTA(`Nome`, `Autore`) ON DELETE CASCADE,
	PRIMARY KEY (`Nome`, `Autore`)
);

CREATE TABLE GOURMET (
	`Nome` VARCHAR(80) NOT NULL,
	`Autore` VARCHAR(30) NOT NULL,
	FOREIGN KEY (`Nome`, `Autore`) REFERENCES RICETTA(`Nome`, `Autore`) ON DELETE CASCADE,
	PRIMARY KEY (`Nome`, `Autore`)
);

CREATE TABLE partecipa ( 
	`CF_D` CHAR(16) NOT NULL,
	`Username` VARCHAR(15) NOT NULL,
	`Data` DATE NOT NULL,
	`CF_P` CHAR(16) NOT NULL,
	`Acquisto` ENUM('0','1') NOT NULL,
	FOREIGN KEY (`CF_D`,`Username`,`Data`) REFERENCES DIMOSTRAZIONE (`CF`,`Username`,`Data`) ON DELETE CASCADE,
	FOREIGN KEY (`CF_P`) REFERENCES PARTECIPANTE (`CF`) ON DELETE CASCADE,
	PRIMARY KEY (`CF_D`,`Username`,`Data`,`CF_P`)
); 

CREATE TABLE sceglie( 
	`Username` VARCHAR(15) NOT NULL,
	`Premio_nome` VARCHAR(60) NOT NULL,
	PRIMARY KEY (`Username`,`Premio_nome`),
	FOREIGN KEY (`Username`) REFERENCES ACCOUNTT (`Username`) ON DELETE CASCADE,
	FOREIGN KEY (`Premio_nome`) REFERENCES PREMIO (`Nome`) ON DELETE CASCADE
);

CREATE TABLE dispone_di(  
	`Username` VARCHAR(15) NOT NULL,
    `Ricetta_nome` VARCHAR(80) NOT NULL,
    `Ricetta_autore` VARCHAR(30) NOT NULL,
	FOREIGN KEY (`Username`) REFERENCES ACCOUNTT (`Username`) ON DELETE CASCADE,
    FOREIGN KEY (`Ricetta_nome`, `Ricetta_autore`) REFERENCES BASE (`Nome`, `Autore`) ON DELETE CASCADE,
	PRIMARY KEY (`Username`,`Ricetta_nome`, `Ricetta_autore`)
);

CREATE TABLE possiede(
	`Username` VARCHAR(15) NOT NULL,
    `Ricetta_nome` VARCHAR(80) NOT NULL,
    `Ricetta_autore` VARCHAR(30) NOT NULL,
	`Voto` INT DEFAULT NULL,
	FOREIGN KEY (`Username`) REFERENCES ACCOUNTT (`Username`) ON DELETE CASCADE,
    FOREIGN KEY (`Ricetta_nome`, `Ricetta_autore`) REFERENCES RICETTA (`Nome`, `Autore`) ON DELETE CASCADE,
    PRIMARY KEY (`Username`,`Ricetta_nome`, `Ricetta_autore`),
    CHECK (`Voto`>=0 AND `Voto`<=5)
);

CREATE TABLE contiene( 
	`Ricetta_nome` VARCHAR(80) NOT NULL,
    `Ricetta_autore` VARCHAR(30) NOT NULL,
	`Nome_ingrediente` VARCHAR(15) NOT NULL,
    FOREIGN KEY (`Ricetta_nome`, `Ricetta_autore`) REFERENCES RICETTA (`Nome`, `Autore`) ON DELETE CASCADE,
	FOREIGN KEY (`Nome_ingrediente`) REFERENCES INGREDIENTE (`Nome`) ON DELETE CASCADE,
    PRIMARY KEY (`Ricetta_nome`,`Ricetta_autore`, `Nome_ingrediente`)
);

SET GLOBAL local_infile=true;

LOAD DATA LOCAL INFILE 'PARTECIPANTE.sql'
INTO TABLE PARTECIPANTE FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'CLIENTE.sql'
INTO TABLE CLIENTE FIELDS TERMINATED BY ',' ENCLOSED BY ''''
(`CF`, `Nome`, `Cognome`, `Luogo_nascita`, `Data_nascita`,`Email`, `Via` ,`Civico`,`CAP`);

LOAD DATA LOCAL INFILE 'DIPENDENTE.sql'
INTO TABLE DIPENDENTE FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'TELEFONO_D.sql'
INTO TABLE TELEFONO_D FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'TELEFONO_C.sql'
INTO TABLE TELEFONO_C FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'ACCOUNTT.sql'
INTO TABLE ACCOUNTT FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'DIMOSTRAZIONE.sql'
INTO TABLE DIMOSTRAZIONE FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'PREMIO.sql'
INTO TABLE PREMIO FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'SPEDIZIONE_1.sql'
INTO TABLE SPEDIZIONE_1 FIELDS TERMINATED BY ',' ENCLOSED BY ''''
(`Corr`,`Data`,`CF`);

LOAD DATA LOCAL INFILE 'SPEDIZIONE_2.sql'
INTO TABLE SPEDIZIONE_2 FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'ROBOT_2.sql'
INTO TABLE ROBOT_2 FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'ROBOT_1.sql'
INTO TABLE ROBOT_1 FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'ABBONATO.sql'
INTO TABLE ABBONATO FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'VENDITA.sql'
INTO TABLE VENDITA FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'partecipa.sql'
INTO TABLE partecipa FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'sceglie.sql'
INTO TABLE sceglie FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'RICETTA.sql'
INTO TABLE RICETTA FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'BASE.sql'
INTO TABLE BASE FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'GOURMET.sql'
INTO TABLE GOURMET FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'possiede.sql'
INTO TABLE possiede FIELDS TERMINATED BY ',' ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'dispone_di.sql'
INTO TABLE dispone_di FIELDS TERMINATED BY ',' ENCLOSED BY '''';