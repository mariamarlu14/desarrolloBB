/*Informacion las cuentas de un cliente*/


'27212721F'

CREATE OR REPLACE VIEW Info_cuentas_usuario AS
SELECT cu.numcuenta, cu.fecha_contrato, cu.saldo, cli.dni, cli.nombre, cli.telefono, cli.fecha_nacimiento, cli.calle, cli.numero, cli.localidad
FROM cuenta_objtab cu, cliente_objtab cli
WHERE REF(cli) IN
(SELECT ref(c) FROM Cliente_objtab c WHERE c.dni = '&DNI');



/*Solicitudes no iniciadas a un empleado*/

'12345678K'

CREATE OR REPLACE VIEW Prestamo_no_iniciado AS
    SELECT p.id, p.fecha, p.estado, p.saldo_op, p.finalidad, p.plazo, p.empleado.nombre AS nombre FROM Prestamo_objtab p
     WHERE p.empleado.dni = '&DNI' AND p.estado = 'NO INICIADA';





/*Informacion de una cuenta que muestre los movimientos*/

CREATE OR REPLACE VIEW Info_Cuenta_Movimientos ("NUMERO_CUENTA", "FECHA_CONTRATO", "SALDO", "TIPO_CUENTA", "MOVIMIENTOS") AS
SELECT mov.numero_mov, mov.fecha_hora, mov.concepto, mov.cargo
FROM Movimiento_objtab mov
WHERE mov.numero_mov IN (SELECT cu.numero_cuenta, cu.fecha_contraro, cu.saldo, cu.tipo_cuenta FROM Cuenta_objtab cu WHERE )


CREATE OR REPLACE VIEW Info_Cuenta_Movimientos() AS;
    BEGIN
        SELECT cu.numCuenta, mov.numero_mov, mov.fecha_hora, mov.concepto, mov.cargo
        INTO Movimiento_objtab mov, (SELECT numCuenta FROM Cuenta_objtab WHERE numero_cuenta == cu.numCuenta) cu;
        

/*CREATE OR REPLACE VIEW PART_FED_MAYOR_MEDALLERO ("NOMBRE", "APELLIDOS", "TELEFONO", "EMAIL") AS
SELECT part.Nombre, part.apellidos, part.Telefono, part.email
FROM participante_objtab part
WHERE part.Federacion.Nombre IN (SELECT eqp.Nombre
FROM federacion_objtab eqp where eqp.medallero IN(SELECT max(eqp.medallero) FROM federacion_objtab eqp)
);*/


/*Informacion de la tarjeta donde muestre los movinientos de tarjeta*/
CREATE OR REPLACE VIEW Datos_Tarjeta AS
Select P.NumTarjeta, P.Tipo, (INFOMovimientosTarjeta(P.NumTarjeta)) AS DATOS
FROM Tarjeta_objtab P;

CREATE OR REPLACE FUNCTION getmovtar (numTarjeta1 IN VARCHAR2)
RETURN MovimientoTarjeta_NTABTYP AS ri MovimientoTarjeta_NTABTYP;
BEGIN
SELECT PInd.movimientoTarjeta INTO ri FROM Tarjeta_objtab PInd WHERE PInd.numTarjeta = numTarjeta1;
RETURN ri;
END getmovtar;

create or replace FUNCTION INFOMovimientosTarjeta(RESULTADOSIND IN VARCHAR2) RETURN VARCHAR2 AS TEXTO VARCHAR2(30000);
Ri MovimientoTarjeta_NTABTYP;
aux Tarjeta_objtyp;
BEGIN
ri := getmovtar(RESULTADOSIND);
FOR I IN ri.FIRST..ri.LAST LOOP
SELECT DEREF(ri(I).Tarjeta)
INTO aux
FROM DUAL; TEXTO := TEXTO || (CHR(13) || CHR(9) || ' Resultado ' || ri(I).concepto );
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


     



RETURN MOVIMIENTO_NTABTYP AS mv MOVIMIENTO_NTABTYP;
BEGIN
SELECT A.movimientos INTO mv FROM CUENTA_OBJTAB A WHERE A.numCuenta = cuenta;
RETURN mv;
END getMovimientos;

/*Prestamos en curso*/

SELECT * FROM Prestamo_objtab p WHERE p.estado = 'EN TRANSITO'; 

select 

create view solicitudesencurso as
select t1.idusuario, t1.nombre,
t1.apellido1, t1.apellido2,
t1.telefono, t1.email,
t2.column_value.nombre as "NOMBRE SOLICITUD"
from usuario_objtab t1, table(treat (value (t1) as promotor_objtyp).solicitud) t2
where value (t1) is of (promotor_objtyp)
and t2.column_value.estadosolicitud = 'EN CURSO';