-- Active: 1711804507493@@127.0.0.5@3306@wasserwerk
CREATE DATABASE IF NOT EXISTS Wasserwerk;

DROP TABLE IF EXISTS Zaehlerbesitz CASCADE;
DROP TABLE IF EXISTS Kunde CASCADE;
DROP TABLE IF EXISTS Foto CASCADE;
DROP TABLE IF EXISTS Zaehlerstand CASCADE;
DROP TABLE IF EXISTS Zaehler CASCADE;
DROP TABLE IF EXISTS Einbauort CASCADE;

CREATE TABLE Einbauort(
    id INT PRIMARY KEY  AUTO_INCREMENT,
    addresse VARCHAR(255)
);

-- Tables
CREATE TABLE Zaehler(
    id INT PRIMARY KEY  AUTO_INCREMENT,
    isHauptzaehler BOOLEAN,
    id_einbauort INT,
    Foreign Key (id_einbauort) REFERENCES einbauort(id) ON DELETE CASCADE
);

CREATE TABLE Kunde(
    id INT PRIMARY KEY  AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE Zaehlerbesitz(
    ablesezeit DATE NOT NULL,
    wechselzeit DATE NOT NULL,
    id_kunde INT NOT NULL,
    id_zaehler INT NOT NULL,
    Foreign Key (id_kunde) REFERENCES Kunde(id) ON DELETE CASCADE,
    Foreign Key (id_zaehler) REFERENCES Zaehler(id) ON DELETE CASCADE
);


create table Zaehlerstand(
    id INT PRIMARY KEY  AUTO_INCREMENT,
    stand_in_m3 INT NOT NULL,
    herkunft VARCHAR(255) NOT NULL,
    id_zaehler INT NOT NULL,
    Foreign Key (id_zaehler) REFERENCES Zaehler(id) ON DELETE CASCADE
);

CREATE TABLE Foto(
    id INT PRIMARY KEY AUTO_INCREMENT,
    bilddatei BLOB,
    id_zaehlerstand INT NOT NULL,
    Foreign Key (id_zaehlerstand) REFERENCES zaehlerstand(id) ON DELETE CASCADE
);

-- Inserts

INSERT INTO Kunde(name, email) VALUES
    ('SYMVARO', 'symvaro@gmail.com'),
    ('MCDonalds', 'mcdonalds@gmail.com'),
    ('BMW', 'bmw@gmail.com');

INSERT INTO Einbauort(addresse) VALUES
    ('Tschinowitscherweg 5, Villach, 9500'),
    ('Kirchbach 55, Kirchbach im Gailtal, 9632'),
    ('Hans-Gaser-Platz 32, Villach, 9500');

INSERT INTO Zaehler(isHauptzaehler, id_einbauort) VALUES
    (TRUE,1),
    (FALSE,1),
    (TRUE,2),
    (FALSE,2),
    (FALSE,2),
    (TRUE,3);
    
INSERT INTO Zaehlerbesitz(ablesezeit,wechselzeit,id_kunde,id_zaehler) VALUES
    ('2021-12-21', '2022-04-01',1,1),
    ('2021-12-21', '2022-06-21',1,2),
    ('2021-12-21', '2022-02-17',1,3),
    ('2021-12-21', '2022-07-23',2,3),
    ('2022-04-15', '2022-08-12',3,6);

INSERT INTO Zaehlerstand(stand_in_m3,herkunft,id_zaehler) VALUES
    (340,'Web', 1),
    (111,'Post', 2),
    (999,'Web', 1),
    (200,'Web', 2),
    (565,'App', 3),
    (264,'App', 3);

INSERT INTO Foto(bilddatei, id_zaehlerstand) VALUES 
    (LOAD_FILE('./Fotos/bild1.jpg'), 1),
    (LOAD_FILE('./Fotos/bild2.jpg'), 2),
    (LOAD_FILE('./Fotos/bild3.jpg'), 3);

-- Selects
SELECT * FROM Zaehler;
SELECT * FROM Kunde;
SELECT * FROM Zaehlerbesitz;
SELECT * FROM Einbauort;
SELECT * FROM Zaehlerstand;
SELECT * FROM Foto;

SELECT z.*, zb.ablesezeit, zb.wechselzeit, zs.stand_in_m3, zs.herkunft
FROM Zaehler z
JOIN Zaehlerbesitz zb ON z.id = zb.id_zaehler
JOIN zaehlerstand zs ON z.id = zs.id_zaehler
JOIN Kunde k ON k.id = zb.id_kunde
WHERE k.name = 'SYMVARO';

SELECT k.name, COUNT(zb.id_zaehler) AS Anzahl_Zähler
FROM Kunde k
JOIN Zaehlerbesitz zb ON k.id = zb.id_kunde
GROUP BY k.id
ORDER BY Anzahl_Zähler DESC
LIMIT 1;

SELECT z.*
FROM Zaehler z
JOIN Zaehlerbesitz zb ON z.id = zb.id_zaehler
WHERE ablesezeit >= '2022-04-01' AND ablesezeit < '2022-05-01';

SELECT DISTINCT k.name
FROM Kunde k
JOIN Zaehlerbesitz zb ON k.id = zb.id_kunde
JOIN zaehlerstand zs ON zb.id_zaehler = zs.id_zaehler
JOIN Zaehler z ON zs.id_zaehler = z.id
WHERE zs.herkunft = 'App';

SELECT k.name, COUNT(DISTINCT z.id) AS Anzahl_Zähler
FROM Kunde k
LEFT JOIN Zaehlerbesitz zb ON k.id = zb.id_kunde
LEFT JOIN Zaehler z ON zb.id_zaehler = z.id
GROUP BY k.id
ORDER BY Anzahl_Zähler DESC;