---INTEGRANTES: JOHANA CÓMBITA, SANTIAGO VILLA
--Descripción: Base de datos de datos de películas, con datos de directores y actores.

-- 1. Crear la tabla Director, siguiendo la descripción dada (3 puntos)
CREATE TABLE Director(
    iddirector int UNIQUE PRIMARY KEY CHECK (iddirector > 0), 
    dni char NOT NULL UNIQUE,
    nombre char NOT NULL,
    apellido1 char NOT NULL,
    apellido2 char NULL,
    fechaNacimiento DATE NOT NULL,
    fechaRegistro DATE NOT NULL CHECK (fechaRegistro > fechaNacimiento),
    fechaDeceso DATE NULL CHECK (fechaDeceso > fechaNacimiento),
    enActivo int NOT NULL CHECK (enActivo in (0,1))
);

-- 2. Crear la tabla Película, siguiendo la descripción dada (3 puntos)
CREATE TABLE Pelicula(
    idpelicula int UNIQUE PRIMARY KEY CHECK (idpelicula > 0),
    titulo char NOT NULL UNIQUE,
    fechaEstreno date NOT NULL,
    duracionMin real NOT NULL CHECK (duracionMin > 0),
    genero char NOT NULL CHECK (genero IN ('terror','scifi','aventura')),
    iddirector int NOT NULL,
    FOREIGN KEY (iddirector) REFERENCES Director(iddirector)
);

-- 3. Insertar al menos 3 filas válidas en la tabla Director, y otras 3 filas válidas en la tabla Película (1 punto)
--Filas tabla Director:
INSERT INTO Director (iddirector, dni, nombre, apellido1, apellido2, fechaNacimiento,fechaRegistro,fechaDeceso,enActivo)
            VALUES   (1, '15547896F', 'Christopher Edward', 'Nolan', NULL, '1970-07-30', '1997-01-01', NULL, 1);

INSERT INTO Director (iddirector, dni, nombre, apellido1, apellido2, fechaNacimiento,fechaRegistro,fechaDeceso,enActivo)
            VALUES   (2, '65987411R', 'Alfred Joseph', 'Hitchcock', NULL, '1899-08-13', '1923-02-05', '1980-04-29', 0);

INSERT INTO Director (iddirector, dni, nombre, apellido1, apellido2, fechaNacimiento,fechaRegistro,fechaDeceso,enActivo)
            VALUES   (3, '58742664J', 'Guillermo', 'del Toro', 'Gomez', '1964-10-09', '1985-06-18', NULL, 1);

INSERT INTO Director (iddirector, dni, nombre, apellido1, apellido2, fechaNacimiento,fechaRegistro,fechaDeceso,enActivo)
            VALUES   (4, '35698516-Z', 'Christopher','Nolan', NULL, '1970-07-30', '1990-03-12', NULL, 1);


--visualización de tabla director
SELECT D.* FROM Director D;
      
--Filas Tabla Pelicula:
INSERT INTO Pelicula (idpelicula, titulo, fechaEstreno, duracionMin, genero, iddirector)
            VALUES   (1, 'Interstellar', '2014-11-07', 169, 'scifi', 1);
            
INSERT INTO Pelicula (idpelicula, titulo, fechaEstreno, duracionMin, genero, iddirector)
            VALUES   (2, 'Psycho', '1960-06-16', 109, 'terror', 2);
            
INSERT INTO Pelicula (idpelicula, titulo, fechaEstreno, duracionMin, genero, iddirector)
            VALUES   (3, 'El Laberinto del Fauno', '2006-10-11', 119, 'aventura', 2);
            
INSERT INTO Pelicula (idpelicula, titulo, fechaEstreno, duracionMin, genero, iddirector)
            VALUES (4, 'Oppenheimer', '2023-07-21',180, 'aventura', 4);

--visualización de tabla pelicula
SELECT P.* FROM Pelicula P;

-- 4. Añadir a la tabla Película una nueva columna que almacene la recaudación, que no pueda tomar un valor negativo (debe ser mayor o igual a 0), 
-- que no pueda ser nula, y que por defecto su valor sea 0 (1 punto)

ALTER TABLE Pelicula ADD recaudacion real NOT NULL CHECK (recaudacion >= 0) DEFAULT 0;

--visualización de cambios en tabla pelicula
SELECT P.* FROM Pelicula P;

--- Nuevos valores en tabla pelicula para probar cambio:
INSERT INTO Pelicula (idpelicula, titulo, fechaEstreno, duracionMin, genero, iddirector, recaudacion)
VALUES (5, 'Bastardos sin gloria', '2009-10-23',153, 'aventura', 3, 321455689);


-- 5. ¿Se te ocurre un método mejor para almacenar los géneros de las películas? Por ejemplo, ¿qué pasaría si quisiésemos 
-- ampliar los géneros posibles y añadir uno nuevo? Impleméntalo* (1 punto)

CREATE TABLE Genero (
    idgenero int UNIQUE PRIMARY KEY CHECK (idgenero > 0), 
    descripcion char NOT NULL
);

INSERT INTO Genero (idgenero, descripcion)
            VALUES (1, 'Terror');

INSERT INTO Genero (idgenero, descripcion)
            VALUES (2, 'Scifi');
            
INSERT INTO Genero (idgenero, descripcion)
            VALUES (3, 'Aventura');
            
INSERT INTO Genero (idgenero, descripcion)
            VALUES (4, 'Comedia');
            
INSERT INTO Genero (idgenero, descripcion)
            VALUES (5, 'Drama');

--visualización de tabla pelicula
SELECT G.* FROM Genero G;

-- Para la resolución del punto 5 podéis implementar el código SQL en el mismo Script, creando una nueva tabla de Películas (llamada por ejemplo PelículaPunto5).
CREATE TABLE PeliculaPunto5 (
    idpelicula int UNIQUE PRIMARY KEY CHECK (idpelicula > 0),
    titulo char NOT NULL UNIQUE,
    fechaEstreno date NOT NULL,
    duracionMin real NOT NULL CHECK (duracionMin > 0),
    idgenero int NOT NULL,
    iddirector int NOT NULL,
    FOREIGN KEY (iddirector) REFERENCES Director(iddirector),
    FOREIGN KEY (idgenero) REFERENCES Genero(idgenero)
); 

--Peliculas punto 5:
INSERT INTO PeliculaPunto5 (idpelicula, titulo, fechaEstreno, duracionMin, idgenero, iddirector)
            VALUES   (1, 'Interstellar', '2014-11-07', 169, 2, 1);
            
INSERT INTO PeliculaPunto5 (idpelicula, titulo, fechaEstreno, duracionMin, idgenero, iddirector)
            VALUES   (2, 'Psycho', '1960-06-16', 109, 1, 2);
            
INSERT INTO PeliculaPunto5 (idpelicula, titulo, fechaEstreno, duracionMin, idgenero, iddirector)
            VALUES   (3, 'El Laberinto del Fauno', '2006-10-11', 119, 3, 2);
            
INSERT INTO PeliculaPunto5 (idpelicula, titulo, fechaEstreno, duracionMin, idgenero, iddirector)
            VALUES (4, 'Oppenheimer', '2023-07-21',180, 5, 4);

--visualización de tabla pelicula
SELECT P5.* FROM PeliculaPunto5 P5;

-- 6. Imaginemos que, además, queremos almacenar los datos de los actores que participan en las películas, sabiendo que un actor puede participar en varias películas, y una
-- película tiene varios actores. Implementa una solución a este problema. Para ello, se da a continuación la descripción de la tabla Actor (1 punto)

CREATE TABLE Actor (
    idactor int UNIQUE PRIMARY KEY CHECK (idactor > 0 ),
    dni char NOT NULL UNIQUE,
    nombre char NOT NULL,
    apellido1 char NOT NULL,
    apellido2 char NULL,
    fechaNacimiento date NOT NULL,
    fechaRegistro date NOT NULL CHECK (fechaRegistro > fechaNacimiento),
    fechaDeceso date NULL CHECK (fechaDeceso > fechaNacimiento),
    enActivo int NOT NULL CHECK (enActivo in (0,1))
);

CREATE TABLE PeliculaActor (
    idpelicula int NOT NULL,
    idactor int NOT NULL,
    FOREIGN KEY (idpelicula) REFERENCES PeliculaPunto5 (idpelicula),
    FOREIGN KEY (idactor) REFERENCES Actor(idactor),
    PRIMARY KEY (idpelicula, idactor)
);

INSERT INTO Actor (idactor, dni, nombre, apellido1, fechaNacimiento, fechaRegistro, enActivo)
        VALUES    (1, '56998410S', 'Matthew David', 'McConaughey', '1969-11-04', '1996-07-26', 1);
        
INSERT INTO Actor (idactor, dni, nombre, apellido1, fechaNacimiento, fechaRegistro, enActivo)
        VALUES    (2, '56889774E', 'Anne Jacqueline', 'Hathaway', '1982-11-12', '1999-09-08', 1);
    
INSERT INTO Actor (idactor, dni, nombre, apellido1, fechaNacimiento, fechaRegistro, fechaDeceso, enActivo)
        VALUES    (3, '56448220B', 'Anthony', 'Perkins', '1932-04-04', '1953-09-25', '1992-09-12', 0);
    
INSERT INTO Actor (idactor, dni, nombre, apellido1, fechaNacimiento, fechaRegistro, enActivo)
        VALUES    (4, '45877415A', 'Vera June', 'Ralston', '1929-08-23', '1999-09-08', 0);
        
INSERT INTO Actor (idactor, dni, nombre, apellido1, apellido2, fechaNacimiento, fechaRegistro, enActivo)
        VALUES    (5, '45877663V', 'Ivana', 'Vaquero', 'Macias', '1994-06-11', '2004-05-14', 1);
        
INSERT INTO Actor (idactor, dni, nombre, apellido1, fechaNacimiento, fechaRegistro, enActivo)
        VALUES    (6, '98541247W', 'Doug', 'Jones', '1960-05-24', '1992-06-19', 1);
        
INSERT INTO Actor (idactor, dni, nombre, apellido1, apellido2, fechaNacimiento, fechaRegistro, enActivo)
        VALUES (7, '25631895U', 'Robert', 'Downey', 'Jr', '1965-04-04', '1995-06-08', 1);

--visualización de tabla actor
SELECT A.* FROM ACTOR A;

-- Creacion de la relacion entre Pelicula y Actor
INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (1,1);

INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (1,2);

INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (2,3);

INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (2,4);
            
INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (3,5);

INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (3,6);
            
INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (4,7);

--    Creacion de relacion donde un mismo actor está en mas de una película
--    Insertamos el director de la nueva película
INSERT INTO Director (iddirector, dni, nombre, apellido1, fechaNacimiento,fechaRegistro,enActivo)
            VALUES   (5, '44586697T', 'Tommy', 'O Haver', '1968-10-24', '1998-07-24', 1);

--    Insertamos la nueva película
INSERT INTO PeliculaPunto5 (idpelicula, titulo, fechaEstreno, duracionMin, idgenero, iddirector)
            VALUES         (5, 'Ella Enchanted', '2004-04-09', 96, 4, 5);

--    Creamos la relación de los actores con esa película
INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (5,2);
            
INSERT INTO PeliculaActor (idpelicula,idactor)
            VALUES        (5,6);
            
--    Consulta final de las tablas PeliculaPunto5, Genero y Actor para verificar
SELECT P.Titulo, P.fechaEstreno AS Estreno, G.descripcion AS Genero, A.nombre || ' ' || A.apellido1 AS Actor FROM PeliculaActor PA
JOIN PeliculaPunto5 P ON P.idpelicula = PA.idpelicula
JOIN Genero G ON G.idgenero = P.idgenero
JOIN Actor A ON A.idactor = PA.idactor
