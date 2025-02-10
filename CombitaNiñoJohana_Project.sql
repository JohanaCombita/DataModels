--- AUTOR: Johana Patrica Cómbita Niño
--- DESCRIPCIÓN: Desarrollo de consultas del proyecto final sobre base de datos "Series"

--- Punto 1: Crea una nueva tabla para almacenar las temporadas 
--- de las series. La primary key ha de ser el par de campos 
--- “idSerie, numTemporada”. La descripción de la tabla es la 
--- siguiente: (2 ptos)

create table TEMPORADAS (idSerie int NOT NULL,
                        numTemporada int NOT NULL,
                        fechaEstreno date NOT NULL,
                        fechaRegistro date NOT NULL,
                        disponible int NOT NULL,
                        CONSTRAINT FK_idserie FOREIGN KEY (idSerie) REFERENCES SERIES
                        CONSTRAINT PK_serieTemporada PRIMARY KEY (idSerie, numTemporada)
                        CONSTRAINT CK_fechaRegistro CHECK (fechaRegistro > fechaEstreno)
                        CONSTRAINT CK_dispBooleano CHECK (disponible in (0, 1)));

--- Agregando valores en nueva tabla para probar cambios
INSERT INTO TEMPORADAS (idSerie, numTemporada, fechaEstreno, fechaRegistro, disponible)
VALUES (2, 7, '2020-08-20', '2020-12-10', 1);
INSERT INTO TEMPORADAS (idSerie, numTemporada, fechaEstreno, fechaRegistro, disponible)
VALUES (2, 4, '2018-05-20', '2018-06-10', 1);

--- Visualización de cambios
SELECT T.* FROM TEMPORADAS T;



--- Punto 2: Añadir una nueva columna a la tabla "profesiones"
--- para almacenar un campo denominado "descripcion" (0.25 ptos).

ALTER TABLE PROFESIONES ADD descripcion char NULL;

--- Nuevos valores para tabla profesiones con descripción
INSERT INTO PROFESIONES (idProfesion, profesion, descripcion)
VALUES ('13', 'Enfermero/a', 'Área de la salud');

--- Visualización de cambios en tabla profesiones
SELECT P.* FROM Profesiones P;



--- Punto 3: Crea un índice sobre el par de campos “titulo” y 
--- “anyoFin” de las series (0.25 ptos)

CREATE INDEX idx_titulo_anyoFin ON SERIES (titulo, anyoFin);

--- Prueba de indice 
EXPLAIN QUERY PLAN
SELECT * FROM SERIES ORDER BY titulo, anyoFin;


--- Punto 4: Mostrar el “idserie”, “titulo”, original” y 
--- “sinopsis” de todas las series, ordenadas por título 
--- descendentemente (0.5 ptos)

SELECT S.idSerie, S.titulo, S.tituloOriginal, S.sinopsis FROM SERIES S
ORDER BY S.titulo DESC; 



--- Punto 5: Retornar los datos de los usuarios franceses o 
--- noruegos (0.5 ptos)

SELECT U.* FROM USUARIOS U
WHERE U.pais IN ('Francia', 'Noruega');



--- Punto 6: Mostrar los datos de los actores junto con los datos
--- de las series en las que actúan (0.75 ptos)

SELECT A.*, S.* FROM ACTORES A
                JOIN REPARTO R ON A.idActor = R.idActor
                JOIN SERIES S ON S.idSerie = R.idSerie;

---Nota: si se coloca left join tenemos que dos actores no tienen serie asociada
--El actor Peter Vives fue cargado dos veces en la tabla Reparto con el mismo personaje. 



--- Punto 7: Mostrar los datos de los usuarios que no hayan
--- realizado nunca ninguna valoración (0.75 ptos)

SELECT U.* FROM USUARIOS U
WHERE NOT EXISTS (SELECT V.idUsuario FROM VALORACIONES V WHERE U.idUsuario = V.idUsuario);



--- Punto 8: Mostrar los datos de los usuarios junto con los
--- datos de su profesión, incluyendo las profesiones que no 
--- estén asignadas a ningún usuario (0.75 ptos)

SELECT P.*, U.* FROM PROFESIONES P 
                LEFT JOIN USUARIOS U ON U.idProfesion = P.idProfesion;



--- Punto 9: Retornar los datos de las series que estén en 
--- idioma español, y cuyo título comience por E o G (1 pto)

SELECT S.*, I.idioma FROM SERIES S
                JOIN IDIOMAS I ON I.idIdioma = S.idIdioma
WHERE (I.idioma = 'Español') AND (S.tituloOriginal like ('E%') OR S.tituloOriginal like ('G%')); 
--Nota: se tomo el titulo original para filtro y no titulo solo para que apareciera titulo con G



--- Punto 10: Retornar los “idserie”, “titulo” y “sinopsis” de
--- todas las series junto con la puntuación media, mínima y 
--- máxima de sus valoraciones (1 pto)

SELECT S.idSerie, S.titulo, S.sinopsis, avg(V.puntuacion) AS Puntución_Media, min(V.puntuacion) AS Puntución_Min, max(V.puntuacion) AS Puntución_Max  
FROM SERIES S
        JOIN VALORACIONES V ON V.idSerie = S.idSerie
        GROUP BY S.idSerie, S.titulo, S.sinopsis;
---Nota: hay una serie sin valoración (con left join).


--- Punto 11: Actualiza al valor 'Sin sinopsis' la sinopsis de
--- todas las series cuya sinopsis sea nula y cuyo idioma sea 
--- el inglés (1 pto)

UPDATE SERIES SET sinopsis = 'sin sinopsis'
WHERE (sinopsis IS NULL) AND (idIdioma IN (SELECT I.idIdioma FROM SERIES S 
                                            JOIN IDIOMAS I ON I.ididioma = S.ididioma
                                WHERE I.idioma = 'Inglés'));
                                
---Validación de actualización:
SELECT S.*, I.idioma FROM SERIES S
            JOIN IDIOMAS I ON I.ididioma = S.ididioma;


--- Punto 12: Utilizando funciones ventana, muestra los datos 
--- de las valoraciones junto al nombre y apellidos (concatenados)
--- de los usuarios que las realizan, y en la misma fila, el 
--- valor medio de las puntuaciones realizadas por el usuario
--- (1.25 ptos)

SELECT U.idUsuario, U.nombre || ' ' || U.apellido1 || ' ' || COALESCE(U.apellido2, '') AS Nombre_completo, 
        V.idSerie, V.Puntuacion, AVG(V.puntuacion) OVER (PARTITION BY U.idUsuario) AS Media_puntuaciones_usuario
            FROM VALORACIONES V 
                JOIN USUARIOS U ON V.idUsuario = U.idUsuario;

