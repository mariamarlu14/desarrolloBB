/*Informacion de un cliente y muestre los datos de la cuenta*/

CREATE OR REPLACE VIEW PART_FED_MAYOR_MEDALLERO ("NOMBRE", "APELLIDOS", "TELEFONO", "EMAIL") AS
SELECT part.Nombre, part.apellidos, part.Telefono, part.email
FROM participante_objtab part
WHERE part.Federacion.Nombre IN (SELECT eqp.Nombre
FROM federacion_objtab eqp where eqp.medallero IN(SELECT max(eqp.medallero) FROM federacion_objtab eqp)
);

/*Informacion de una cuenta que muestre los movimientos*/

CREATE OR REPLACE VIEW PART_FED_MAYOR_MEDALLERO ("NOMBRE", "APELLIDOS", "TELEFONO", "EMAIL") AS
SELECT part.Nombre, part.apellidos, part.Telefono, part.email
FROM participante_objtab part
WHERE part.Federacion.Nombre IN (SELECT eqp.Nombre
FROM federacion_objtab eqp where eqp.medallero IN(SELECT max(eqp.medallero) FROM federacion_objtab eqp)
);
/*Informacion de la tarjeta donde muestre los movinientos de tarjeta*/
CREATE OR REPLACE VIEW Datos_PruebasInd AS
Select P.Nombre, P.Fase, (INFORESULTADOIND(P.Nombre)) AS DATOS
FROM Pruebasind_objtab P;

create or replace FUNCTION INFORESULTADOIND(RESULTADOSIND IN VARCHAR2) RETURN VARCHAR2 AS TEXTO VARCHAR2(30000);
Ri RESULTADOIND_NTABTYP;
aux PARTICIPANTE_objtyp;
BEGIN
ri := GETRESULTADOINDPI(RESULTADOSIND);
FOR I IN ri.FIRST..ri.LAST LOOP
SELECT DEREF(ri(I).Participante)
INTO aux
FROM DUAL; TEXTO := TEXTO || (CHR(13) || CHR(9) || ' Resultado ' || ri(I).RESULTADO || ' Unidad ' || ri(I).UNIDAD || ', Participante ' || aux.NOMBRE|| ' . ');
END LOOP;
RETURN TEXTO;
END;
/*Crear un prestamo con un empleado*/


/*Prestamos asignados a un empleado*/


/*Datos de los clientes que han realizado alguna transferencia con concepto luz*/

create or replace FUNCTION INFORESULTADOIND(RESULTADOSIND IN VARCHAR2) RETURN VARCHAR2 AS TEXTO VARCHAR2(30000);
Ri RESULTADOIND_NTABTYP;
aux PARTICIPANTE_objtyp;
BEGIN
ri := GETRESULTADOINDPI(RESULTADOSIND);
FOR I IN ri.FIRST..ri.LAST LOOP
SELECT DEREF(ri(I).Participante)
INTO aux
FROM DUAL; TEXTO := TEXTO || (CHR(13) || CHR(9) || ' Resultado ' || ri(I).RESULTADO || ' Unidad ' || ri(I).UNIDAD || ', Participante ' || aux.NOMBRE|| ' . ');
END LOOP;
RETURN TEXTO;
END;

/*Solicitudes no iniciadas a un empleado*/
create view solicitudesempleados as
select t2.column_value.idsolicitud as idsolicitud,
t2.column_value.nombre as nombre,
t1.nombre as "NOMBRE EMPLEADO",
t1.idusuario as idusuario
from usuario_objtab t1, table(treat(value(t1) as empleado_objtyp).solicitud) t2
where value(t1) is of (empleado_objtyp) and
t2.column_value.estadosolicitud = 'EN CURSO'
order by idusuario;

/*Prestamos en curso*/

create view solicitudesencurso as
select t1.idusuario, t1.nombre,
t1.apellido1, t1.apellido2,
t1.telefono, t1.email,
t2.column_value.nombre as "NOMBRE SOLICITUD"
from usuario_objtab t1, table(treat (value (t1) as promotor_objtyp).solicitud) t2
where value (t1) is of (promotor_objtyp)
and t2.column_value.estadosolicitud = 'EN CURSO';