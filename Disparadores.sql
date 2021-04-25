---------------------------------------------------------------------------------------------------------------------------
/*Asignar automaticamente el numero de cuenta (LISTO)*/
create or replace TRIGGER AUTONUMERIC
BEFORE  INSERT ON transferencia_objtab
FOR EACH ROW
DECLARE
BEGIN
    INSERT INTO transferencia_objtab VALUES (transferencia_idtransferencia_seq.NEXTVAL, :new.fecha_contrato,
    :new.saldo,:new.tipocuenta,:new.movimientos, :new.clientes);
END;
---------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------
/*Establecer el estado de inversion “En Curso” cuando se inserta una inversion.(LISTA)*/

create or replace trigger setInversionEnCurso
    after insert on inversion_objtab
    declare
        valorsecuencia inversion_objtab.id%type;
    begin
        select inversion_idinversion_seq.currval into valorsecuencia
            from dual;

        update inversion_objtab
            set estado = 'EN CURSO'
            where id = valorsecuencia;
    end;

    /**Probar el disparador**/
    INSERT INTO Inversion_objtab VALUES(
    Inversion_objtyp(
    inversion_idinversion_seq.nextval,TO_TIMESTAMP ('03-Dic-02 13:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF') , 'NO INICIADA', 300.5, 'Bankia', 'Medio', 'banca', 
    (SELECT ref(g)
    FROM Gerente_objtab g
    WHERE g.numero_gerente = 62)));
---------------------------------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------------------------------
/*Calcular el campo derivado Saldo en Cuentas (como la 7 del campus)*/

CREATE VIEW Cuenta AS ( SELECT * FROM Cuenta_objtab );



 
CREATE OR REPLACE TRIGGER Act_Saldo_N
INSTEAD OF INSERT OR DELETE OR UPDATE
ON NESTED TABLE Movimientos OF Cuenta
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    UPDATE cuenta_objtab SET saldo = saldo + :NEW.saldo 
        WHERE numcuenta = :PARENT.numcuenta;
    INSERT INTO TABLE (SELECT Movimientos FROM cuenta_objtab WHERE numcuenta = :PARENT.numcuenta)
        VALUES (:NEW.numero_mov, :NEW.fecha_hora, :NEW.concepto, :NEW.cargo, :NEW.saldo, :NEW.tipo_trans, :NEW.tipo_pres1, :NEW.tipo_pres2, :NEW.tipo_inv);
  END IF;

  IF DELETING THEN
    UPDATE cuenta_objtab 
        SET saldo = saldo - :OLD.saldo
        WHERE numcuenta = :PARENT.numcuenta;
    DELETE FROM TABLE (SELECT Movimientos FROM cuenta_objtab WHERE numcuenta = :PARENT.numcuenta)
      WHERE numero_mov = :OLD.numero_mov;
  END IF;  
  
  IF UPDATING THEN
    UPDATE cuenta_objtab 
        SET saldo = saldo + :NEW.saldo - :OLD.saldo 
        WHERE numcuenta = :PARENT.numcuenta;
    UPDATE TABLE (SELECT Movimientos FROM cuenta_objtab WHERE numcuenta = :PARENT.numcuenta)
      SET numero_mov = :NEW.numero_mov, fecha_hora = :NEW.fecha_hora, concepto = :NEW.concepto,
       cargo = :NEW.cargo, saldo = :NEW.saldo, tipo_trans = :NEW.tipo_trans, tipo_pres1 = :NEW.tipo_pres1, tipo_pres2 = :NEW.tipo_pres2, tipo_inv = :NEW.tipo_inv
      WHERE numero_mov = :NEW.numero_mov;
  END IF; 
END;










create or replace TRIGGER Act_Saldo 
INSTEAD OF INSERT OR UPDATE ON Cuenta
FOR EACH ROW
DECLARE
  VPT NUMBER;
  I BINARY_INTEGER;
BEGIN
  IF :NEW.Movimientos IS NOT NULL THEN
    VPT := 0;
    FOR I IN 1..:NEW.Movimientos.COUNT LOOP
       VPT := VPT + :NEW.Movimientos(I).saldo;
    END LOOP;
  ELSE
    VPT:= 0;
  END IF;

  IF INSERTING THEN
    INSERT INTO Cuenta_objtab 
		VALUES (:NEW.numCuenta,:NEW.fecha_Contrato,VPT,:NEW.tipocuenta,:NEW.movimientos,  :NEW.clientes);
  END IF;
  IF UPDATING THEN
    UPDATE Cuenta SET numCuenta = :NEW.numCuenta, fecha_Contrato = :NEW.fecha_Contrato, saldo = VPT, tipocuenta = :NEW.tipocuenta, 
	       movimientos = :NEW.movimientos, clientes = :NEW.clientes
    WHERE numCuenta = :OLD.numCuenta;
  END IF;
END;
------------------------------------------------------------------------------------------------------------------





------------------------------------------------------------------------------------------------------------------

/*Saldo mayor que cero al insertar o actualizar una transferencia.(LISTO))*/
create or replace TRIGGER saldonmenorceroActualizarSaldo BEFORE
    INSERT OR UPDATE ON transferencia_objtab
    FOR EACH ROW
DECLARE
    sal           NUMBER(12, 2);
    saldocuenta   cuenta_objtab.saldo%TYPE;
    idusuario     transferencia_objtab.id%TYPE;
    nCuenta cuenta_objtab.numcuenta%type;

BEGIN
    idusuario := :new.id;
    SELECT
       g.numcuenta, g.saldo
    INTO nCuenta, saldocuenta
    FROM
        cuenta_objtab g
    WHERE
        ref(g) = :new.cuentaorigen;

    sal := saldocuenta - :new.saldo_op;
    IF sal < 0 THEN
        raise_application_error(-20103, 'No se puede realizar la operacion ');
    ELSE
        IF inserting OR updating THEN
            UPDATE cuenta_objtab
            SET
                saldo = sal
            WHERE
                numCuenta = nCuenta;

        END IF;

        IF deleting THEN
            UPDATE cuenta_objtab
            SET
                saldo = saldocuenta + :new.saldo_op
            WHERE
                numCuenta = nCuenta;

        END IF;

    END IF;

END;
------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------

/*Asignar automáticamente el número de un cliente  (HECHO)  */

------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER Insertar_Cliente
BEFORE  INSERT ON Cliente_objtab
FOR EACH ROW
DECLARE
BEGIN
    INSERT INTO Cliente_objtab VALUES (:new.dni,
    :new.nombre,:new.telefono,:new.fecha_nacimiento, :new.calle,
    :new.numero, :new.localidad, :new.codigo_postal, cliente_numerocliente_seq.NEXTVAL);
END;


--------------------------------------------------------------------------------------------------

/*Asignar el tipo de cuenta automáticamente según la edad del cliente (HECHO) */

--------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER Tipo_Cuenta_Cliente
BEFORE INSERT OR UPDATE ON Cuenta_objtab
FOR EACH ROW
DECLARE
    edad NUMBER;
BEGIN
    
    SELECT FLOOR((TRUNC(SYSDATE) - TRUNC(cl.fecha_nacimiento))/365) 
    INTO edad 
    FROM Cliente_objtab cl;
       
	IF (edad >= 18 AND edad < 25) THEN
		INSERT INTO Cuenta_objtab VALUES
		(:new.numCuenta, :new.fecha_contrato, :new.saldo,
		(SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'JOVEN'),
		:new.movimientos, :new.clientes);
	END IF;

	IF (edad >= 25 AND edad < 65) THEN
		INSERT INTO Cuenta_objtab VALUES
		(:new.numCuenta, :new.fecha_contrato, :new.saldo,
		(SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'ADULTO'),
		:new.movimientos, :new.clientes);
	END IF;

	IF (edad >= 65) THEN
		INSERT INTO Cuenta_objtab VALUES
		(:new.numCuenta, :new.fecha_contrato, :new.saldo,
		(SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'PENSIONISTA'),
		:new.movimientos, :new.clientes);
	END IF;
		
END;



--------------------------------------------------------








----------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
/*Asignar una solicitud que se acaba de crear a un empleado. (JAVIER 1)*/
CREATE OR REPLACE TRIGGER ASIGNAR_SOLICITUD
FOR INSERT ON SOLICITUD_OBJTAB
COMPOUND TRIGGER
TYPE TIDSOLICITUD IS TABLE OF SOLICITUD_OBJTAB.IDSOLICITUD%TYPE
INDEX BY BINARY_INTEGER;
VTIDSOLICITUD TIDSOLICITUD;
NE BINARY_INTEGER := 0; -- ÍNDICE DE VTIDSOLICITUD
IDEMP BINARY_INTEGER := 0; -- EMPLEADO AL QUE SE ASIGNARÁ LA SOLICITUD
NEMP BINARY_INTEGER := 0; -- VARIABLE AUX PARA CAMBIAR IDEMP
NSOLEMP BINARY_INTEGER := 0; -- SOLICITUDES DEL EMPLEADO CON ID NEMP
NSOL BINARY_INTEGER := 0; -- VARIABLE AUX PARA CAMBIAR NSOLEMP
BEFORE EACH ROW IS
BEGIN
NE := NE + 1;
VTIDSOLICITUD(NE) := :NEW.IDSOLICITUD;
END BEFORE EACH ROW;
AFTER STATEMENT IS
BEGIN
SELECT COUNT(*) INTO NEMP
FROM USUARIO_OBJTAB U
WHERE VALUE(U) IS OF (EMPLEADO_OBJTYP);
IF(NEMP > 0) THEN
SELECT IDUSUARIO INTO IDEMP
FROM USUARIO_OBJTAB U
WHERE VALUE(U) IS OF (EMPLEADO_OBJTYP)
FETCH FIRST 1 ROWS ONLY;
SELECT COUNT(S.COLUMN_VALUE) INTO NSOLEMP
FROM USUARIO_OBJTAB U, TABLE(TREAT(VALUE(U) AS EMPLEADO_OBJTYP).SOLICITUD) S
WHERE IDUSUARIO = IDEMP;
FOR J IN 1..NE LOOP
FOR i IN (SELECT IDUSUARIO IDU FROM USUARIO_OBJTAB U WHERE VALUE(U) IS OF (EMPLEADO_OBJTYP)) LOOP
SELECT COUNT(S.COLUMN_VALUE) INTO NSOL
FROM USUARIO_OBJTAB U, TABLE(TREAT(VALUE(U) AS EMPLEADO_OBJTYP).SOLICITUD) S
WHERE IDUSUARIO = i.IDU;
IF (NSOL < NSOLEMP) THEN
IDEMP := i.IDU;
NSOLEMP := NSOL;
END IF;
END LOOP;
INSERT INTO TABLE (
SELECT TREAT(VALUE(U) AS EMPLEADO_OBJTYP).SOLICITUD
FROM USUARIO_OBJTAB U
WHERE IDUSUARIO = IDEMP
)
VALUES (
(SELECT REF(S)
FROM SOLICITUD_OBJTAB S
WHERE IDSOLICITUD = VTIDSOLICITUD(J))
);
END LOOP;
ELSE
DBMS_OUTPUT.PUT_LINE('No hay empleados a los que asignarles esta solicitud.');
END IF;
END AFTER STATEMENT;
END;
------------------------------------------------------------------------------------------------------------------


/*Generar un movimiento mensual en la cuenta que recoja los movimientos de una tarjeta del mes anterior*/
/*Crear un procedimiento o disparador por tiempo que un día del mes sume los movimientos del mes anterior y los cargue en la cuenta 
si es una tarjeta de crédito
Si la tarjeta es de débito, cada movimiento se cargará en la cuenta de origen*/


---------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER Cargos_Tarjeta_Debito 
BEFORE INSERT ON Tarjeta_objtab
FOR EACH ROW
DECLARE
    
BEGIN

END;



---------------------------------------------------------------------------------------------------------------------------


/*controla el número de movimientos por cada préstamo. (TENIS)*/


---------------------------------------------------------------------------------------------------------------------------

create or replace trigger nPartidos
before insert on partido_tab
for each row
declare
  v_fase number(20):=0;
  f_act number(20):=0;
  cont_Partido number(20):=0;
  cont number(20):=0;
begin
  select :new.fase into v_fase from dual;
  f_act := (64/(2**(v_fase - 1)));
  select count (*) into cont_Partido from partido_tab where fase = v_fase;
  if(cont_Partido=f_act) then
    RAISE_APPLICATION_ERROR(-20000, 'No se pueden insertar más partidos para esta fase');
  else
    cont:=1;
  end if;
end;






------------------------------------------------------------------------------------------------

/*Asignar automáticamente el número de un cliente*/

------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER Insertar_Cliente
BEFORE  INSERT ON Cliente_objtab
FOR EACH ROW
DECLARE
BEGIN
    INSERT INTO Cliente_objtab VALUES (:new.dni,
    :new.nombre,:new.telefono,:new.fecha_nacimiento, :new.calle,
    :new.numero, :new.localidad, :new.codigo_postal, cliente_numerocliente_seq.NEXTVAL);
END;




--------------------------------------------------------------------------------------------------

/*Asignar el tipo de cuenta automáticamente según la edad del cliente*/

--------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER Tipo_Cuenta_Cliente
BEFORE INSERT OR UPDATE ON Cuenta_objtab
FOR EACH ROW
DECLARE
    edad NUMBER;
BEGIN
    
    SELECT FLOOR((TRUNC(SYSDATE) - TRUNC(cl.fecha_nacimiento))/365) 
    INTO edad 
    FROM Cliente_objtab cl;
       
	IF (edad >= 18 AND edad < 25) THEN
		INSERT INTO Cuenta_objtab VALUES
		(:new.numCuenta, :new.fecha_contrato, :new.saldo,
		(SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'JOVEN'),
		:new.movimientos, :new.clientes);
	END IF;

	IF (edad >= 25 AND edad < 65) THEN
		INSERT INTO Cuenta_objtab VALUES
		(:new.numCuenta, :new.fecha_contrato, :new.saldo,
		(SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'ADULTO'),
		:new.movimientos, :new.clientes);
	END IF;

	IF (edad >= 65) THEN
		INSERT INTO Cuenta_objtab VALUES
		(:new.numCuenta, :new.fecha_contrato, :new.saldo,
		(SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'PENSIONISTA'),
		:new.movimientos, :new.clientes);
	END IF;
		
END;




create or replace trigger setInversionEnCurso
    after insert on inversion_objtab
    declare
        valorsecuencia inversion_objtab.id%type;
    begin
        select inversion_idinversion_seq.currval into valorsecuencia
            from dual;

        update inversion_objtab
            set estado = 'EN CURSO'
            where id = valorsecuencia;
    end;