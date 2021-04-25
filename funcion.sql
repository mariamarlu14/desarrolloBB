create or replace FUNCTION getmov (numCuenta1 IN VARCHAR2)
    RETURN Movimiento_NTABTYP AS mv Movimiento_NTABTYP;
    BEGIN
        SELECT Cu.movimientos INTO mv FROM Cuenta_objtab Cu WHERE Cu.numCuenta = numCuenta1;
    RETURN mv;
END getmov;


create or replace FUNCTION totalprestamosTurno (
    nomTurno IN empleado_objtab.turno%TYPE,
    nomFinalidad IN prestamo_objtab.finalidad%TYPE

) RETURN NUMBER IS
    empleadoR ref empleado_objtyp;
    saldoOp prestamo_objtab.saldo_op%type;
    total NUMBER;
    vturno empleado_objtab.turno%TYPE;
BEGIN
    total:=0;
  select empleado, saldo_op into empleadoR, saldoOp from prestamo_objtab where finalidad=nomFinalidad;

   select turno into vturno from empleado_objtab e where ref(e)= empleadoR;
          dbms_output.put_line('No existe la finalidad' || saldoOp);
          dbms_output.put_line('No existe la finalidad' || vturno);
                            dbms_output.put_line('No existe la finalidad' || nomTurno);


  if vturno = nomTurno then
          dbms_output.put_line('No existe la finalidad' || vturno);
          dbms_output.put_line('No existe la finalidad' || total);

    total:= total+saldoOp;
   end if;
              dbms_output.put_line('Total' || total);


    RETURN total;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('No existe la finalidad');
        RETURN 0;

END;