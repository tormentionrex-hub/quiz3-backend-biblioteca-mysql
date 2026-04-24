CREATE DATABASE Biblioteca;

USE Biblioteca; 

CREATE TABLE autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, -- un autor sin nombre no tiene sentido por eso el not null en este campo
    nacionalidad VARCHAR(50) NOT NULL -- un autor debe tener una nacionalidad
);

CREATE TABLE editorial (
    id_editorial INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

ALTER TABLE editorial DROP INDEX nombre; -- aqui elimine el UNIQUE de nombre en la editorial
  
  SELECT * FROM editorial;
  
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL 
);

ALTER TABLE categoria DROP INDEX nombre; -- aqui borre el UNIQUE de la tabla categoria

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE, -- correo único y obligatorio
    fecha_registro DATE NOT NULL -- fecha 
    );
    
    CREATE TABLE libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL UNIQUE, -- título único y obligatorio
    id_autor INT NOT NULL, -- foregin key
    id_editorial INT NOT NULL, -- foreign g key
    anio_publicacion INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor),
    FOREIGN KEY (id_editorial) REFERENCES editorial(id_editorial)
);

CREATE TABLE libro_categoria (
    id_libro_categoria INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    id_libro INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro)
);

CREATE TABLE prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);
    
    CREATE TABLE detalle_prestamo (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_devolucion DATE,
    FOREIGN KEY (id_prestamo) REFERENCES prestamo(id_prestamo),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro)
);

INSERT INTO autor (nombre, nacionalidad) VALUES
("Gabriel García Márquez", "Colombiano"),
("Isabel Allende", "Chilena"),
("J.K. Rowling", "Británica"),
("George Orwell", "Británico"),
("Mario Vargas Llosa", "Peruano");

SELECT * FROM autor;  -- estaba revisando q se hayan guardado bien


INSERT INTO editorial (nombre, pais) VALUES
("Molodaya Gvardiya", "Rusia"),
("Arte Público Press", "Estados Unidos"),
("Penguin Random House", "Estados Unidos"),
("HUM", "España");

INSERT INTO categoria (nombre) VALUES
("Novela"),
("Fantasía"),
("Ciencia Ficción"),
("Drama"),
("Terror");

SELECT * FROM categoria;

INSERT INTO usuario (nombre, correo, fecha_registro) VALUES
("Carlos Pérez", "carlos@gmail.com", "2024-01-10"),
("Ana López", "ana@gmail.com", "2024-02-15"),
("Luis Gómez", "luis@gmail.com", "2024-03-20"),
("María Rodríguez", "maria@gmail.com", "2024-04-05");


SELECT * FROM usuario;

INSERT INTO libro (titulo, id_autor, id_editorial, anio_publicacion) VALUES
("Cien Años de Soledad", 1, 2, 1967),
("La Casa de los Espíritus", 2, 2, 1982),
("Harry Potter y la Piedra Filosofal", 3, 1, 1997),
("1984", 4, 3, 1949),
("La Ciudad y los Perros", 5, 4, 1963);

SELECT * FROM libro;

INSERT INTO libro_categoria (id_categoria, id_libro) VALUES
(1, 1), -- el libro 1 pertenece a la categoría 1
(4, 1), -- el libro 1 también pertenece a la categoría 4

(1, 2), -- aqui el libro 2 pertenece a la categoria 1
(4, 2), -- aqui el libro 2 pertenece tambien a la categoria 4

(2, 3), -- aqui el libro 3 pertenece a la categoria 2

(3, 4), -- aqui el libro 4 pertenece a la categoria 3
(5, 4), -- aqui el libro 4 tambien pertenece a la categoria 5

(1, 5), -- aqui el libro 5 pertenece a la categoria 1
(4, 5); -- y tambien el libro 5 pertenece a la categoria 4

SELECT * FROM libro_categoria;

INSERT INTO prestamo (id_usuario, fecha_prestamo) VALUES
(1, "2024-05-01"),
(2, "2024-05-03"),
(1, "2024-05-10"),
(3, "2024-05-12"),
(4, "2024-05-15");

SELECT * FROM prestamo;

INSERT INTO detalle_prestamo (id_prestamo, id_libro, fecha_devolucion) VALUES
(1, 1, "2024-05-10"), -- si esta la fecha es porque el libro si ha sido devuelto
(1, 3, "2024-05-12"),

(2, 2, NULL), -- si esta en null es porque el libro no ha sido devuelto
(2, 4, "2024-05-15"),

(3, 1, NULL),

(4, 3, "2024-05-20"),

(5, 5, "2024-05-22"),
(5, 1, "2024-05-25");


-- nivel 1 consultas basicas

SELECT * FROM libro;

SELECT titulo, anio_publicacion FROM libro;

SELECT * FROM usuario
ORDER BY fecha_registro DESC;


-- nivel 2 join

SELECT libro.titulo, autor.nombre AS autor   -- aqui son los libros con sus autores
FROM libro
INNER JOIN autor ON libro.id_autor = autor.id_autor;


SELECT libro.titulo, editorial.nombre AS editorial -- aqui muestro los libros con su editorial
FROM libro
INNER JOIN editorial ON libro.id_editorial = editorial.id_editorial;

SELECT libro.titulo, categoria.nombre AS categoria -- aqui se muestra las categorias de cada libro
FROM libro
INNER JOIN libro_categoria ON libro.id_libro = libro_categoria.id_libro
INNER JOIN categoria ON libro_categoria.id_categoria = categoria.id_categoria;


-- nivel 3 join multiples

SELECT usuario.nombre AS usuario, libro.titulo AS libro, prestamo.fecha_prestamo -- aqui deberia mostrarse los prestamos con usuarios y libros
FROM prestamo
INNER JOIN usuario ON prestamo.id_usuario = usuario.id_usuario
INNER JOIN detalle_prestamo ON prestamo.id_prestamo = detalle_prestamo.id_prestamo
INNER JOIN libro ON detalle_prestamo.id_libro = libro.id_libro;

SELECT usuario.nombre AS usuario, libro.titulo AS libro, prestamo.fecha_prestamo -- aqui se muestran los libros no devueltos
FROM detalle_prestamo
INNER JOIN prestamo ON detalle_prestamo.id_prestamo = prestamo.id_prestamo
INNER JOIN usuario ON prestamo.id_usuario = usuario.id_usuario
INNER JOIN libro ON detalle_prestamo.id_libro = libro.id_libro
WHERE detalle_prestamo.fecha_devolucion IS NULL;

SELECT  -- historial completo de prestamos
    usuario.nombre AS usuario,
    libro.titulo AS libro,
    prestamo.fecha_prestamo,
    detalle_prestamo.fecha_devolucion,
    CASE   -- El "case when else" es similar a un if y else tienen casi la misma logica (se usa para mostrar un resultado según una condición)
        WHEN detalle_prestamo.fecha_devolucion IS NULL THEN 'No devuelto'
        ELSE 'Devuelto'
    END AS estado
FROM prestamo
INNER JOIN usuario ON prestamo.id_usuario = usuario.id_usuario
INNER JOIN detalle_prestamo ON prestamo.id_prestamo = detalle_prestamo.id_prestamo
INNER JOIN libro ON detalle_prestamo.id_libro = libro.id_libro
ORDER BY prestamo.fecha_prestamo DESC;

-- nivel 4 agregaciones

SELECT categoria.nombre AS categoria, COUNT(*) AS total_libros -- cantidad de libros por categoria (deberia salir 3 1 1 3 1)
FROM libro_categoria
INNER JOIN categoria ON libro_categoria.id_categoria = categoria.id_categoria
GROUP BY categoria.nombre;

SELECT usuario.nombre AS usuario, COUNT(*) AS total_prestamos -- aqui van a salir la cantidad de prestamos por usuario
FROM prestamo
INNER JOIN usuario ON prestamo.id_usuario = usuario.id_usuario
GROUP BY usuario.nombre;

SELECT editorial.nombre AS editorial, COUNT(*) AS total_libros -- aqui se muestra la cantidad de libros por editorial
FROM libro
INNER JOIN editorial ON libro.id_editorial = editorial.id_editorial
GROUP BY editorial.nombre;

-- nivel 5 consultas avanzadas

SELECT usuario.nombre AS usuario, COUNT(*) AS total_prestamos -- aqui sale el usuario con mas prestamos que seria carlos
FROM prestamo
INNER JOIN usuario ON prestamo.id_usuario = usuario.id_usuario
GROUP BY usuario.nombre
ORDER BY total_prestamos DESC
LIMIT 1;

SELECT libro.titulo AS libro, COUNT(*) AS veces_prestado -- aqui se muestra al libro mas prestado o usado
FROM detalle_prestamo
INNER JOIN libro ON detalle_prestamo.id_libro = libro.id_libro
GROUP BY libro.titulo
ORDER BY veces_prestado DESC
LIMIT 1;


SELECT categoria.nombre AS categoria, COUNT(*) AS total_prestamos -- y aqui al libro mas popular 
FROM detalle_prestamo
INNER JOIN libro ON detalle_prestamo.id_libro = libro.id_libro
INNER JOIN libro_categoria ON libro.id_libro = libro_categoria.id_libro
INNER JOIN categoria ON libro_categoria.id_categoria = categoria.id_categoria
GROUP BY categoria.nombre
ORDER BY total_prestamos DESC
LIMIT 1;

