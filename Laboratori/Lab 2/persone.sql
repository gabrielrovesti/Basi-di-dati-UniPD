--Eliminazione di entrambe le tabelle in caso esistano
DROP TABLE IF EXISTS Genitori CASCADE;
DROP TABLE IF EXISTS Persone;

--Creazione tipo di dato sex
CREATE TYPE genere AS ENUM('M', 'F');

--Creazione tabella Persone
CREATE TABLE Persone (
	Id CHAR (2) PRIMARY KEY,
	Nome VARCHAR (20) NOT NULL,
	Reddito int DEFAULT 0,
	Eta int,
	Sesso genere
);

--Aggiunta vincolo eta <200
ALTER TABLE Persone
	ADD CHECK (eta <200);

--Creazione tabella Genitori
CREATE TABLE Genitori (
	Figlio CHAR (2),
	Genitore CHAR (2),
	FOREIGN KEY (Genitore) REFERENCES Persone (Id) ON DELETE CASCADE ,
	FOREIGN KEY (Figlio) REFERENCES Persone (Id) ON DELETE CASCADE ,
	PRIMARY KEY (Figlio , Genitore)
);

--Popolamento tabella Persone
INSERT INTO Persone (Id, Nome , Reddito , Eta , Sesso) VALUES
	('A1', 'Aldo', 25, 15, 'M'),
	('A2', 'Andrea ', 27, 21, 'M'),
	('A3', 'Antonino ', 44, 40, 'M'),
	('A4', 'Amelia ', 79, 28, 'F'),
	('A5', 'Anna', 50, 29, 'F'),
	('A6', 'AnnaMaria ', 41, 30, 'F'),
	('A7', 'Aldo', 25, 20, 'M'),
	('B1', 'Beatrice ', 79, 30, 'F'),
	('F1', 'Filippo ', 26, 30, 'M'),
	('F2', 'Franco ', 60, 20, 'M'),
	('L1', 'Leonardo ', 79, 30, 'M'),
	('L2', 'Luigi ', 50, 40, 'M'),
	('L3', 'Luisa ', 75, 87, 'F'),
	('M1', 'Marco ', 11, 10, 'M'),
	('M2', 'Michele ', 79, 30, 'M'),
	('M3', 'Maria ', 55, 42, 'F'),
	('O1', 'Olga', 30, 41, 'F'),
	('S1', 'Sergio ', 85, 35, 'M');

--Popolamento tabella Genitori
INSERT INTO Genitori (Figlio , Genitore) VALUES
	('A7', 'A3'),
	('M1', 'A3'),
	('A6', 'A4'),
	('F1', 'A5'),
	('O1', 'A5'),
	('A7', 'A6'),
	('M1', 'A6'),
	('A3', 'B1'),
	('A1', 'F2'),
	('A2', 'F2'),
	('A3', 'L1'),
	('F1', 'L2'),
	('O1', 'L2'),
	('L2', 'L3'),
	('M3', 'L3'),
	('A6', 'M2'),
	('A1', 'M3'),
	('A2', 'M3'),
	('F2', 'S1');