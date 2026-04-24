Quiz 3  Biblioteca MySQL Curso Back End FWD Costa Rica

1. ¿Qué hace un JOIN?
Es como pegar dos tablas usando algo que tienen en común. Por ejemplo, el libro tiene un "id_autor"
y con JOIN puedo traer el nombre del autor desde la tabla autor, todo en una sola consulta.

2. Diferencia entre INNER JOIN, RIGHT JOIN, FULL JOIN y LEFT JOIN

INNER JOIN: Solo muestra lo que existe en ambas tablas. Si un libro no tiene autor registrado, no aparecera
LEFT JOIN: Muestra todo de la tabla de la izquierda, tenga o no coincidencia en la otra
RIGHT JOIN: Igual pero al revés, prioriza la tabla de la derecha
FULL JOIN: Muestra todo de ambas tablas sin importar si hay coincidencia. aunque MySQL no lo soporta de forma directa

3. ¿Qué es una clave foránea?
Es una columna que apunta al ID de otra tabla. En libro tengo "id_autor" que apunta a la tabla autor asi que básicamente
es el puente entre dos tablas y además evita que se pueda ingresar datos que no existen

4. ¿Qué es una relación muchos a muchos?
Es cuando un registro puede relacionarse con varios de otra tabla y al revés también
En este caso (osea el quiz) un libro puede tener varias categorías y una categoría puede tener varios libros
Pero para que eso funcione necesitaria una tabla intermedia, que en este caso seria "libro_categoria"


5. ¿Para qué sirve GROUP BY?
Agrupa filas con el mismo valor para poder contarlas o sumarlas
Por ejemplo, agrupa todos los libros por editorial para saber cuántos tiene cada una

6. ¿Qué hace HAVING?
Es como un WHERE pero para grupos se usa después de GROUP BY para filtrar resultados
Por ejemplo si solo quiero editoriales con más de 3 libros uso "HAVING total > 3"
No puedo usar WHERE porque ese total no es una columna real, es el resultado de un COUNT

Nota personal: Al principio HAVING me tenía confundido ya que la lógica de por qué no podía usar WHERE con un COUNT no la entendia
Pero cuando caí en cuenta de que WHERE trabaja con los datos crudos y HAVING con los grupos ya calculados, ahi ya entendi la funcion de 
cada una JAJASASJ
