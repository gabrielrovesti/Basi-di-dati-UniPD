CREATE TABLE Festival(
	Nome VARCHAR(100) PRIMARY KEY,
	Data_inizio DATE,
	Data_fine DATE,
	Tema VARCHAR(200)
);

CREATE TABLE Indirizzo(
    ID VARCHAR(20) PRIMARY KEY,
    Indirizzo VARCHAR(100),
    Citta VARCHAR(50),
    Cap VARCHAR(5),
    Provincia VARCHAR(50)
);

CREATE TABLE Sponsor(
    Nome VARCHAR(100) UNIQUE,
    Partita_iva VARCHAR(11),
	Indirizzo_fiscale VARCHAR(20) REFERENCES Indirizzo(ID)
	ON DELETE CASCADE,
	Codice_fiscale VARCHAR(13),
	PRIMARY KEY (Partita_iva)
);

CREATE TABLE Sponsorizzazione(
	Festival VARCHAR(100),
	Pagamento FLOAT,
	Sponsor VARCHAR(11),
    FOREIGN KEY(Festival) REFERENCES Festival(Nome)
    ON DELETE CASCADE,
    FOREIGN KEY(Sponsor) REFERENCES Sponsor(Partita_iva)
    ON DELETE CASCADE
);

CREATE TABLE Giornata(
	Data_effettiva DATE PRIMARY KEY,
	Festival VARCHAR(100),
	FOREIGN KEY(Festival) REFERENCES Festival(Nome)
	ON DELETE CASCADE
);

CREATE TABLE Artista(
	Nome VARCHAR(100) PRIMARY KEY,
	Numero_componenti SMALLINT,
	Genere_musicale VARCHAR(100),
	Headliner BOOL
);

CREATE TYPE Tipo_luci AS ENUM ('standard', 'pro');
CREATE TYPE Tipo_audio AS ENUM ('medio', 'grande','arena');

CREATE TABLE Palcoscenico(
	Nome VARCHAR(50) PRIMARY KEY,
	Location VARCHAR(100),
	Grandezza FLOAT,
	Impianto_luci Tipo_luci[],
	Impianto_audio Tipo_audio[]
);

CREATE TABLE Concerto(
	Giornata DATE,
	Artista VARCHAR(100),
	Ora_inizio TIME,
	Ora_fine TIME,
	Palcoscenico VARCHAR(50),
	
	FOREIGN KEY(Palcoscenico) REFERENCES Palcoscenico(Nome)
	ON DELETE CASCADE,
	FOREIGN KEY(Artista) REFERENCES Artista(Nome)
	ON DELETE CASCADE,
	FOREIGN KEY(Giornata) REFERENCES Giornata(Data_effettiva)
	ON DELETE CASCADE,
	PRIMARY KEY(Giornata, Artista)
);

CREATE TABLE Camerino(
	ID VARCHAR(5) PRIMARY KEY,
	Grandezza FLOAT
);

CREATE TABLE Occupazione(
    Artista VARCHAR(100),
    Camerino VARCHAR(5),
	Giornata DATE,
    FOREIGN KEY(Artista) REFERENCES Artista(Nome) ON DELETE CASCADE,
    FOREIGN KEY(Camerino) REFERENCES Camerino(ID) ON DELETE CASCADE,
	FOREIGN KEY(Giornata) REFERENCES Giornata(data_effettiva) ON DELETE CASCADE
);


CREATE TABLE Servizio(
	Nome VARCHAR(50) PRIMARY KEY,
	Solo_vip BOOL
);

CREATE TABLE Camerino_servizio(
	Camerino VARCHAR(5) REFERENCES Camerino(ID)
	ON DELETE CASCADE,
	Servizio VARCHAR(50) REFERENCES Servizio(Nome)
	ON DELETE CASCADE,
	PRIMARY KEY(Camerino, Servizio)
);

CREATE TABLE Cliente(
	ID VARCHAR(20) PRIMARY KEY,
	Nome VARCHAR(50),
	Cognome VARCHAR(100),
	Indirizzo_fiscale VARCHAR(20) REFERENCES Indirizzo(ID)
	ON DELETE CASCADE,
	Email VARCHAR(100),
);

CREATE TABLE Biglietto(
	ID VARCHAR(5) PRIMARY KEY,
	Festival VARCHAR(100),	
	Prezzo FLOAT,
	Numero_giorni SMALLINT,
	Fisico BOOL,
	Digitale BOOL,
	FOREIGN KEY(Festival) REFERENCES Festival(nome)
	ON DELETE CASCADE
);

CREATE TYPE Tipo_consegna AS ENUM ('digitale', 'fisica','entrambe');

CREATE TABLE Acquisto(
	ID VARCHAR(20) PRIMARY KEY,
	Data_ora TIMESTAMP,
	Cliente VARCHAR(20),
	Indirizzo_consegna VARCHAR(20) REFERENCES Indirizzo(ID),
	Consegna Tipo_consegna[],
	FOREIGN KEY(Cliente) REFERENCES Cliente(ID)
	ON DELETE CASCADE
);

CREATE TABLE Acquisto_biglietto(
 	Acquisto VARCHAR(20) REFERENCES Acquisto(ID)
 	ON DELETE CASCADE,
 	Biglietto VARCHAR(5) REFERENCES Biglietto(ID)
	ON DELETE CASCADE,
	PRIMARY KEY(Acquisto, Biglietto)
);

CREATE TABLE Partecipazione(
	Giornata DATE REFERENCES Giornata(Data_effettiva)
	ON DELETE CASCADE,
 	Acquisto VARCHAR(20) REFERENCES Acquisto(ID)
 	ON DELETE CASCADE,
	PRIMARY KEY(Giornata, Acquisto)
);

/* POPOLAZIONE */

