
--------------------------------------------------------------------------------------------------

/*dados dos clientes, devuelve cuál de los dos tiene mayor saldo. (HECHO)*/

--------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Clientes_Mayor_Saldo (dni1 cliente_objtab.dni%type, dni2 cliente_objtab.dni%type) IS
	ncuenta1 Cuenta_objtab.numCuenta%type;
	ncuenta2 Cuenta_objtab.numCuenta%type;
    scuenta1 Cuenta_objtab.saldo%type;
    scuenta2 Cuenta_objtab.saldo%type;
	ncliente Cliente_objtab.nombre%type;
    dcliente Cliente_objtab.dni%type;
    
	BEGIN
		SELECT cu.numCuenta, cu.saldo INTO ncuenta1, scuenta1 FROM Cuenta_objtab cu
		WHERE dni1 IN (SELECT ref(dni1) FROM Cliente_objtab);
		
		SELECT cu.numCuenta, cu.saldo INTO ncuenta2, scuenta2 FROM Cuenta_objtab cu
		WHERE dni2 IN (SELECT ref(dni2) FROM Cliente_objtab);

		IF (ncuenta1 = ncuenta2) THEN
			DBMS_OUTPUT.PUT_LINE('Los dos clientes son titulares de la misma cuenta: mismo saldo');
		
		ELSE
			IF (scuenta1 > scuenta2) THEN
				SELECT c.dni, c.nombre INTO dcliente, ncliente FROM Cliente_objtab c WHERE dni1 = c.dni;
				DBMS_OUTPUT.PUT_LINE( 'DNI: ' || dcliente ||' Nombre: ' || ncliente );
			ELSE IF (scuenta1 < scuenta2) THEN
				SELECT c.dni, c.nombre INTO dcliente, ncliente FROM Cliente_objtab c WHERE dni2 = c.dni;
				DBMS_OUTPUT.PUT_LINE( 'DNI: ' || dcliente ||' Nombre: ' || ncliente );
			ELSE
				DBMS_OUTPUT.PUT_LINE('Los dos clientes tienen el mismo saldo');
			END IF;

		END IF;
        END IF;
        
END Clientes_Mayor_Saldo;


--------------------------------------------------------------------------------------------------

/*datos del cliente que ha realizado más movimientos (HECHO)*/

--------------------------------------------------------------------------------------------------

create or replace PROCEDURE Cliente_mayor_movimientos IS

    cuenta Cuenta_objtab.numCuenta%TYPE;
    dnis Cliente_objtab.DNI%TYPE;
    nombres Cliente_objtab.nombre%TYPE;

	BEGIN
		SELECT C.numCuenta  into cuenta
        FROM Cuenta_objtab C
		WHERE C.numCuenta IN ( SELECT MAX (COUNT (*)) AS Num_mov
									FROM Cuenta_objtab cue, TABLE(cue.movimientos) t2 GROUP BY numCuenta);

        SELECT cl.dni, cl.nombre INTO dnis, nombres FROM Cliente_objtab cl, Cuenta_objtab c
        WHERE ref(cl) IN (SELECT ref(cl) FROM Cuenta_objtab c, TABLE(c.clientes) client);

        DBMS_OUTPUT.PUT_LINE( 'DNI: ' || dnis ||' Nombre: ' || nombres);

END Cliente_mayor_movimientos;








/*Insetar los movimientos de la tarjeta a movimientos cada 3 horas (lo que me explico que se hacia automaticamente)*/
create table pepote (
 fecha date
 );
 
 create procedure sch2 as
 begin
    insert into pepote values(sysdate);
end;

begin
dbms_scheduler.create_job (  
 job_name            => 'JOB_TEST',  
 job_type            => 'STORED_PROCEDURE',  
 job_action          => 'sch2',  
 number_of_arguments => 0,  
 start_date          => sysdate,
 end_date            => sysdate + 1,
 repeat_interval     => 'FREQ=HOURLY;byminute=0',
 job_class           => 'DEFAULT_JOB_CLASS',  -- Priority Group  
 enabled             => TRUE,  
 auto_drop           => TRUE,  
 comments            => 'JOB de prueba');
end;

select * from pepote;

select sysdate from dual;
/*Cambiar el puesto de un empleado (hecho)*/
CREATE OR replace PROCEDURE cambiar_puesto_empleado (
    dni   empleado_objtab.dni%TYPE,
    tp    tipoempleado_objtab.tipo%TYPE
) IS
    puesto_new tipoempleado_objtab.tipo%TYPE;

BEGIN
        DBMS_OUTPUT.PUT_LINE('========================================================');        
        DBMS_OUTPUT.PUT_LINE('Cambio de puesto');        

    SELECT tipo INTO puesto_new   FROM tipoempleado_objtab   WHERE tipo = tp;
        DBMS_OUTPUT.PUT_LINE('Tipo de puesto: '|| puesto_new);        
        DBMS_OUTPUT.PUT_LINE('Empleado: '|| dni);        

    UPDATE empleado_objtab SET tipo = (SELECT ref(t)  FROM TipoEmpleado_objtab t WHERE tipo = puesto_new)  WHERE    dni = dni;
    
       DBMS_OUTPUT.PUT_LINE('Se ha cambiado correctamente');        

       DBMS_OUTPUT.PUT_LINE('========================================================');        

END;




DECLARE
  DNI VARCHAR2(9);
  TP CHAR(15);
BEGIN
  DNI := '82730198L';
  TP := 'CONTABLE';

  CAMBIAR_PUESTO_EMPLEADO(
    DNI => DNI,
    TP => TP
  );
--rollback; 
END;


-- Buscar el empleado en PUESTO_OBJTAB para eliminarlo del puesto
FOR I IN (SELECT IDPUESTO PU FROM PUESTO_OBJTAB P) LOOP
FOR J IN(SELECT E.COLUMN_VALUE EM FROM PUESTO_OBJTAB P, TABLE(P.EMPLEADO) E WHERE IDPUESTO = I.PU) LOOP
IF(EMP = J.EM) THEN
PUESTO_ACTUAL := I.PU;
IF(PUESTO_ACTUAL != PUESTO_NUEVO) THEN
DELETE FROM TABLE(SELECT EMPLEADO FROM PUESTO_OBJTAB WHERE IDPUESTO = PUESTO_ACTUAL)
WHERE COLUMN_VALUE = EMP;
INSERT INTO TABLE(
SELECT EMPLEADO
FROM PUESTO_OBJTAB
WHERE IDPUESTO = PUESTO_NUEVO
)
VALUES (
(SELECT TREAT(REF(E) AS REF EMPLEADO_OBJTYP)
FROM USUARIO_OBJTAB E
WHERE REF(E) = EMP)
);
ELSE
RAISE_APPLICATION_ERROR(-20200, 'El puesto actual y el nuevo son el mismo, no ha pasado nada.');
END IF;
ELSE
RAISE_APPLICATION_ERROR(-20220, 'El usuario que has introducido no es un empleado.');
END IF;
END LOOP;
END LOOP;
END;


/*muestra el número de movimiento que ha realizados por un clinete (TENIS).*/

create or replace PROCEDURE partidosGanados(F_nombre varchar2) is
    ganados number;
    BEGIN
        select count (ganador) into ganados from PARTIDO_TAB where (ganador=F_nombre);
        DBMS_OUTPUT.PUT_LINE('Este fenómeno '|| F_nombre || 'ha ganado ' || ganados || 'partidos');
END;


/*datos de los clientes que han realizado más transferencias (biblioteca)*/

BEGIN
MIEMBRO_MAYOR_PRESTAMOS();
rollback;
END;
create or replace PROCEDURE Miembro_mayor_prestamos AS
Type tDNI IS TABLE OF Miembros_objtab.DNI%TYPE INDEX BY BINARY_INTEGER;
vDNI tDNI;
Type tnombre IS TABLE OF Miembros_objtab.NOMBRE%TYPE INDEX BY BINARY_INTEGER;
vnombre tnombre;
Type tapellido IS TABLE OF Miembros_objtab.APELLIDOS%TYPE INDEX BY BINARY_INTEGER;
vapellido tapellido;
BEGIN
SELECT DNI,nombre,apellidos bulk collect into vDNI,vnombre,vapellido
FROM Miembros_objtab M
WHERE REF (M) IN ( SELECT miembro
FROM prestamo_objtab
GROUP BY miembro
HAVING COUNT (*) IN ( SELECT MAX (COUNT (*))
FROM Prestamo_objtab GROUP BY miembro));
FOR I IN 1..VDNI.COUNT LOOP
DBMS_OUTPUT.PUT_LINE (‘DNI miembro: ' || VDNI(I) ||' Nombre: ' ||vnombre(I)|| ' Apellidos : ' || vapellido(I)');
END LOOP;
END Miembro_mayor_prestamos;

/*mostrar todos los movimientos que se han realizado el último mes (biblioteca )*/

BEGIN
MIEMBROS_PRESTAMOS();
rollback;
END;
create or replace PROCEDURE Miembros_prestamos AS
miembros miembro_objtyp;
CURSOR mim IS Select value(m) mi From miembros_objtab m where REF(m)IN(SELECT p.miembro FROM Prestamo_objtab p);
BEGIN
35
FOR miembros in mim Loop
DBMS_OUTPUT.PUT_LINE( 'DNI miembro: ' || miembros.mi.DNI ||' Nombre: ' ||miembros.mi.nombre|| ' Apellidos : ' || miembros.mi.apellidos);
END LOOP;
END Miembros_prestamos;

/*Salario neto anual de un empleado (yasin 2)*/

/*Añadir cantidad al saldo de un cliente que realiza un prestamo.(javier 1)*/

/*Restar cantidad al saldo de un cliente.(javier 3)*/




/*lista de los clientes que han realizado al menos un prestamo (biblioteca)*/









create or replace PROCEDURE infomovimientoCuenta (
    numCuenta IN VARCHAR2
) AS

    rmov   movimiento_ntabtyp;
    prest   prestamo_objtyp;
    trans   transferencia_objtyp;
    inv   inversion_objtyp;

    cuent    cuenta_objtyp;
    tCuenta    tipocuenta_objtyp;
    CURSOR cursor2 IS
    SELECT
        value(p),
        deref(p.tipocuenta)
    FROM
        cuenta_objtab p
    WHERE
        p.numcuenta = numcuenta;

BEGIN
    OPEN cursor2;
    FETCH cursor2 INTO
        cuent,
        tCuenta;
    dbms_output.put_line('Cuenta: ' || cuent.numCuenta  || ' cuyo tipo es : '|| tCuenta.tipo || ' cuyo saldo es: '||cuent.saldo);

    CLOSE cursor2;
    
    rmov := getMov(numCuenta);
    
    FOR i IN rmov.first..rmov.last LOOP
        if rmov(i).tipo_pres1 is not null then
        SELECT deref(rmov(i).tipo_pres1) INTO prest FROM  dual;
       dbms_output.put_line('PRESTAMO ACEPTADO ' );

         dbms_output.put_line('El número de movimiento es: ' || rmov(i).numero_mov || ' cuyo concepto '
                             || rmov(i).concepto || ', siendo el estado del prestamo: ' || prest.estado || ' teniendo como plazo:'
                             || prest.plazo);
        else if rmov(i).tipo_trans is not null then
        SELECT deref(rmov(i).tipo_trans) INTO trans FROM  dual;
       dbms_output.put_line('TRANSFERENCIA ' );

         dbms_output.put_line('El número de movimiento es: ' || rmov(i).numero_mov || ' cuyo concepto ' || rmov(i).concepto
                             || ', cuyo saldo de operacion es : '|| trans.saldo_op || ', siendo del tipo'|| trans.tipo);
        else if rmov(i).tipo_pres2 is not null then
        SELECT deref(rmov(i).tipo_pres2) INTO prest FROM  dual;
       dbms_output.put_line('PRESTAMO A DEBER ' );

        dbms_output.put_line('El número de movimiento es: ' || rmov(i).numero_mov || ' cuyo concepto '
                             || rmov(i).concepto || ', siendo de la devolucion del prestamo: ' || prest.estado || ' teniendo como plazo:'
                             || prest.plazo);
        else if rmov(i).tipo_inv is not null then
        SELECT deref(rmov(i).tipo_inv) INTO inv FROM  dual;
       dbms_output.put_line('INVERSION' );
        dbms_output.put_line('El número de movimiento es: ' || rmov(i).numero_mov || ' cuyo concepto ' || rmov(i).concepto
                             || 'cuya inversion tiene como riesgo: '|| inv.riesgo|| ' y su estado es '|| inv.estado);
        end if;
        end if;
        end if;
        end if;

       

    END LOOP;

END infomovimientoCuenta;

DECLARE
  NUMCUENTA VARCHAR2(200);
BEGIN
  NUMCUENTA := '1';

  INFOMOVIMIENTOCUENTA(
    NUMCUENTA => NUMCUENTA
  );
--rollback; 
END;



begin
dbms_scheduler.create_job (  
 job_name            => 'JOB_TEST2',  
 job_type            => 'STORED_PROCEDURE',  
 job_action          => 'inserciondeTransferenciasTa',  
 number_of_arguments => 0,  
 start_date          => sysdate,
 end_date            => sysdate + 1,
 repeat_interval     => 'FREQ=HOURLY;byminute=0',
 job_class           => 'DEFAULT_JOB_CLASS',  -- Priority Group  
 enabled             => TRUE,  
 auto_drop           => TRUE,  
 comments            => 'JOB de prueba');
end;

create or replace procedure insercionDeTransferenciasTa as
tarjeta tarjeta_objtyp;
nt tarjeta_objtab.numTarjeta%type;
nC cuenta_objtab.numCuenta%type;

mov movimientotarjeta_ntabtyp;
cuenta ref cuenta_objtyp;

 begin
 /*select numcuenta BULK COLLECT INTO TPROF from cuenta_objtab;*/
FOR I IN (SELECT numTarjeta numT FROM tarjeta_objtab P) LOOP
   
         DBMS_OUTPUT.PUT_LINE('Numero de tarjeta ' || i.numT);
         select movimientos into mov from Tarjeta_objtab where numTarjeta=i.numT;
         select cuenta into cuenta from Tarjeta_objtab where numTarjeta=i.numT;


        FOR j IN mov.FIRST..mov.LAST LOOP
            if mov(j).pasada ='NO' then
            
                     DBMS_OUTPUT.PUT_LINE('Numero de tarjeta ' || mov(j).pasada);
                     select numCuenta into nC from cuenta_objtab e where ref(e)=cuenta;
                                          
                    
                    
                    INSERT INTO Transferencia_objtab VALUES(
                     Transferencia_objtyp(
                        transferencia_idtrans_seq.nextval,mov(j).fecha_hora, 'INICIADA',
                        mov(j).cargo, 'tarjeta', mov(j).concepto, 1,  (SELECT ref(o)FROM Cuenta_objtab o WHERE o.numCuenta = nC)));
                   
                   UPDATE TABLE (SELECT Movimientos FROM tarjeta_objtab WHERE numTarjeta = i.numT)
      SET pasada = 'YES';
                   
                    
                     
             end if;
            
        
        end loop;
          
end loop;
 end;




 create or replace NONEDITIONABLE procedure insercionDeMovimientoTarjetaCredito as
tarjeta tarjeta_objtyp;
nt tarjeta_objtab.numTarjeta%type;
tipoT tarjeta_objtab.tipo%type;
nC cuenta_objtab.numCuenta%type;
saldocuenta   cuenta_objtab.saldo%TYPE;
sal           NUMBER(12, 2);

mov movimientotarjeta_ntabtyp;
cuenta ref cuenta_objtyp;
cargo number(12, 2);
 begin
 /*select numcuenta BULK COLLECT INTO TPROF from cuenta_objtab;*/
FOR I IN (SELECT numTarjeta numT FROM tarjeta_objtab P) LOOP


         select tipo into tipoT from Tarjeta_objtab where numTarjeta=i.numT;

        if tipoT='CREDITO' THEN
         select movimientos into mov from Tarjeta_objtab where numTarjeta=i.numT;
         select cuenta into cuenta from Tarjeta_objtab where numTarjeta=i.numT;
            FOR j IN mov.FIRST..mov.LAST LOOP
                if mov(j).pasada ='NO' then

                         select numCuenta into nC from cuenta_objtab e where ref(e)=cuenta;


       SELECT g.saldo INTO  saldocuenta FROM cuenta_objtab g  WHERE  numCuenta = nC;

         sal := saldocuenta - mov(j).cargo;

            INSERT INTO TABLE 
            (SELECT Movimientos FROM cuenta_objtab WHERE numcuenta = nC)
                VALUES (movimientoTarjeta_idmovimientoTarjeta_seq.nextval, mov(j).fecha_hora , 'TARJETA', mov(j).cargo, sal,NULL,NULL,NULL,NULL);
        

        UPDATE cuenta_objtab SET saldo = sal  WHERE numCuenta = nC;

        
                 end if;

                       UPDATE TABLE (SELECT Movimientos FROM tarjeta_objtab WHERE numTarjeta = i.numT and tipo='CREDITO')
          SET pasada = 'YES';
            end loop;
    end if;
end loop;
         DBMS_OUTPUT.PUT_LINE('Se han pasado los movimientos de la tarjeta de credito correctamente');

 end;


 begin
dbms_scheduler.create_job (  
 job_name            => 'JOB_TEST2',  
 job_type            => 'STORED_PROCEDURE',  
 job_action          => 'inserciondeTransferenciasTarjetaCredito',  
 number_of_arguments => 0,  
 start_date          => sysdate,
 end_date            => sysdate + 1,
 repeat_interval     => 'FREQ=HOURLY;byminute=0',
 job_class           => 'DEFAULT_JOB_CLASS',  -- Priority Group  
 enabled             => TRUE,  
 auto_drop           => TRUE,  
 comments            => 'JOB de prueba');
end;
