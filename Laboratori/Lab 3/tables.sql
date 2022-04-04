-- Eliminazione di entrambe le tabelle in caso esistano
DROP TABLE IF EXISTS Legs;
DROP TABLE IF EXISTS Hubs;
DROP TABLE IF EXISTS Trips;

-- Creazione tabella Hubs
CREATE TABLE Hubs (
	Hub VARCHAR(30),
	Country CHAR(2),
	PRIMARY KEY(Hub)
);

-- Creazione tabella Trips
CREATE TABLE Trips (
	Number VARCHAR(12) NOT NULL,
	Meters REAL,
	PRIMARY KEY(Number)
);

-- Creazione tabella Legs
CREATE TABLE Legs (
	Trip_number VARCHAR(12) NOT NULL,
	Origin VARCHAR(30) NOT NULL,
	Destination VARCHAR(30) NOT NULL,
	Departure_time TIMESTAMP NOT NULL,
	Arrival_time TIMESTAMP NOT NULL,
	FOREIGN KEY (Trip_number) REFERENCES Trips (Number) ON DELETE CASCADE,
	FOREIGN KEY (Destination) REFERENCES Hubs (Hub) ON DELETE CASCADE,
	FOREIGN KEY (Origin) REFERENCES Hubs (Hub) ON DELETE CASCADE,
	PRIMARY KEY (Trip_number, Origin, Destination, Departure_time, Arrival_time)
);