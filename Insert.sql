/*BANCO*/

INSERT INTO Banco_objtab VALUES
(Banco_objtyp(372837, 'Banco LUMA'));


/*USUARIO CLIENTE*/
INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'27212721F', 'Lucía Navarro Sánchez', 679323593, TO_DATE('22/03/2000','dd/mm/yyyy') , 'C/La Paz', 20, 'Albacete', 02002, cliente_numerocliente_seq.nextval));

INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'28349273A', 'Julia López Martínez', 683749273,TO_DATE('09/02/1970','dd/mm/yyyy') , 'C/La Paz', 15, 'Albacete', 02002, cliente_numerocliente_seq.nextval));

INSERT INTO Cliente_objtab values (
Cliente_objtyp ( 
'82746429J', 'Miguel Pérez Díaz', 638290912,TO_DATE('13/05/1994','dd/mm/yyyy') , 'Avenida de España', 170, 'Albacete', 02002, cliente_numerocliente_seq.nextval));

INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'09382719I', 'María Martínez Lucas', 692930192,TO_DATE('14/11/1996','dd/mm/yyyy'), 'C/Hellín', 45, 'Albacete', 02006, cliente_numerocliente_seq.nextval));

INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'92831029P', 'Julia Perona Espinosa', 609128374,TO_DATE('18/01/1940','dd/mm/yyyy'), 'C/Socuéllamos', 100, 'Ciudad Real', 13700, cliente_numerocliente_seq.nextval));


/*USUARIO GERENTE*/
INSERT INTO Gerente_objtab values(
    Gerente_objtyp(
'38238472P', 'Pablo Rodrigo García', 620938756,TO_DATE('07/08/1975','dd/mm/yyyy') , 'C/Juan Carlos I', 2, 'Albacete',13320, gerente_idgerente_seq.nextval, 5039, 'MAÑANA', 1234));

INSERT INTO Gerente_objtab values(
    Gerente_objtyp(
'84750293I', 'Raquel Navarro Sánchez', 602938176,TO_DATE('09/03/1980','dd/mm/yyyy') , 'C/Montesol', 4, 'Ciudad Real',13701, gerente_idgerente_seq.nextval, 9087, 'TARDE', 1240));


/*TIPO DE EMPLEADO*/
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('ADMINISTRADOR'));
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('CONTABLE'));
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('CAJERO'));


/*USUARIO EMPLEADO*/
INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '12345678K', 'Sergio Martínez García', 628391029, TO_DATE('17/10/1998','dd/mm/yyyy'), 'C/Juan Carlos I', 3, 'Albacete',13320, empleado_idempleado_seq.nextval, 1324, 2739 ,'TARDE', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'ADMINISTRADOR')));

INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '82730198L', 'Raúl Castellanos Sáez', 687093657, TO_DATE('17/08/1989','dd/mm/yyyy'), 'Avenida España', 20, 'Albacete',02006, empleado_idempleado_seq.nextval, 1329, 3002 ,'MAÑANA', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'CONTABLE')));

INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '93560235Q', 'Álvaro Moreno García', 678923456, TO_DATE('09/06/1996','dd/mm/yyyy'), 'C/Hellín', 9, 'Albacete',02006, empleado_idempleado_seq.nextval, 1327, 2839 ,'TARDE', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'CAJERO')));

INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '82730298L', 'Miguel Navarro Espinosa', 615982567, TO_DATE('11/11/1972','dd/mm/yyyy'), 'C/Montesol', 7, 'Ciudad Real',13701, empleado_idempleado_seq.nextval, 1330, 3002 ,'MAÑANA', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'CONTABLE')));

INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '74808416O', 'Óscar Sevilla Sánchez', 687254081, TO_DATE('09/04/1997','dd/mm/yyyy'), 'C/Castilla la Mancha', 7, 'Ciudad Real',13701, empleado_idempleado_seq.nextval, 1287, 3874 ,'TARDE', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'ADMINISTRADOR')));
   
INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '82736401S', 'Jesús Escudero Avendano', 690384756, TO_DATE('03/10/1989','dd/mm/yyyy'), 'C/La Paz', 9, 'Ciudad Real',13700, empleado_idempleado_seq.nextval, 1738, 2739 ,'MAÑANA', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'CAJERO')));


/*SUCURSAL*/

INSERT INTO Sucursal_objtab VALUES
(Sucursal_objtyp('Albacete', sucursal_idsucursal_seq.nextval, 926384758, 'Hellín', 60, 02006, Usuarios_ntabtyp()));

INSERT INTO Sucursal_objtab VALUES
(Sucursal_objtyp('Ciudad Real', sucursal_idsucursal_seq.nextval, 926388758, 'Tobarra', 61, 05106, Usuarios_ntabtyp()));

/*TIPO DE CUENTA*/

INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('JOVEN', 0.2, 0.3));
INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('ADULTO', 0.01, 0.3));
INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('PENSIONISTA', 0.2, 0.03));



/*CUENTA*/

INSERT INTO Cuenta_objtab VALUES(
    Cuenta_objtyp(
    cuenta_idcuenta_seq.nextval, TO_DATE('24/03/2020','dd/mm/yyyy'), 28394, 
    (SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'JOVEN'),
    Movimiento_ntabtyp(Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('14-Sep-20 02:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Inversion Ibex 35', 400, 16000,
        NULL, NULL, NULL,
        (SELECT ref(o)
         FROM Inversion_objtab o
        WHERE o.id = 1),
    Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('02-Dic-20 13:03:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Pago agua', 25, 16000,
        (SELECT ref(o)
        FROM Transferencia_objtab o
        WHERE o.id = 2),
        NULL, NULL, NULL
        )
        )), 
        (SELECT ref(u) FROM Cliente_objtab u WHERE u.dni = '27212721F')));

INSERT INTO Cuenta_objtab VALUES(
    Cuenta_objtyp(
    cuenta_idcuenta_seq.nextval, TO_DATE('21/11/2020','dd/mm/yyyy'), 25548, 
    (SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'ADULTO'),
    Movimiento_ntabtyp(Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Prestamo casa', 400, 16000,
        NULL,(SELECT ref(o)
        FROM Prestamo_objtab o
        WHERE o.id = 1), NULL, NULL
    )), 
    (SELECT ref(u) FROM Cliente_objtab u WHERE u.dni = '28349273A')));

INSERT INTO Cuenta_objtab VALUES(
    Cuenta_objtyp(
    cuenta_idcuenta_seq.nextval, TO_DATE('24/03/2020','dd/mm/yyyy'), 88544, 
    (SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'PENSIONISTA'),
    Movimiento_ntabtyp( Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('25-Nov-20 11:32:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Prestamo casa pagar', 100, 16000,
        NULL, NULL, (SELECT ref(o)
        FROM Prestamo_objtab o
        WHERE o.id = 2),NULL
    )),Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Pago luz', 30, 16000,
    (SELECT ref(o)
    FROM Transferencia_objtab o
    WHERE o.id = 1),
    NULL, NULL, NULL
    ), 
    (SELECT ref(u) FROM Cliente_objtab u WHERE u.dni = '92831029P')));

/*OPERACIÓN TRANSFERENCIA*/


INSERT INTO Transferencia_objtab VALUES(
    Transferencia_objtyp(
        transferencia_idtransferencia_seq.nextval,TO_TIMESTAMP ('10-Sep-02 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),  'NO INICIADA', 300.5, 'NACIONAL', 'luz', 1));
INSERT INTO Transferencia_objtab VALUES(
    Transferencia_objtyp(
        transferencia_idtransferencia_seq.nextval,TO_TIMESTAMP ('12-Sep-02 12:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),  'NO INICIADA', 10.5, 'NACIONAL', 'agua', 1));



/*OPERACION INVERSION*/
INSERT INTO Inversion_objtab VALUES(
    Inversion_objtyp(
    inversion_idinversion_seq.nextval,TO_TIMESTAMP ('03-Dic-02 13:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF') , 'NO INICIADA', 300.5, 'Bankia', 'Medio', 'banca', 
    (SELECT ref(g)
    FROM Gerente_objtab g
    WHERE g.numero_gerente = 1)));


/*OPERACION PRESTAMO*/
INSERT INTO Prestamo_objtab VALUES(
    Prestamo_objtyp(
    prestamo_idprestamo_seq.nextval, TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'NO INICIADA', 0.5, 'hipoteca',  TO_DATE('18/03/2022','dd/mm/yyyy'), 
    (SELECT ref(e)
    FROM Empleado_objtab e
    WHERE e.numero_empleado = 1)));

INSERT INTO Prestamo_objtab VALUES(
    Prestamo_objtyp(
    prestamo_idprestamo_seq.nextval, TO_TIMESTAMP ('03-Dic-20 12:38:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'NO INICIADA', 0.5, 'devolver hipoteca',  TO_DATE('18/04/2022','dd/mm/yyyy'), 
    (SELECT ref(e)
    FROM Empleado_objtab e
    WHERE e.numero_empleado = 1)));
    
    
/*MOVIMIENTO*/
INSERT INTO Movimiento_objtab VALUES(
    Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Pago luz', 30, 16000,
    (SELECT ref(o)
    FROM Transferencia_objtab o
    WHERE o.id = 1),
    NULL, NULL, NULL
    ));

INSERT INTO Movimiento_objtab VALUES(
    Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('02-Dic-20 13:03:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Pago agua', 25, 16000,
    (SELECT ref(o)
    FROM Transferencia_objtab o
    WHERE o.id = 2),
    NULL, NULL, NULL
    ));
    
INSERT INTO Movimiento_objtab VALUES(
    Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('14-Sep-20 02:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Inversion Ibex 35', 400, 16000,
        NULL, NULL, NULL,
        (SELECT ref(o)
         FROM Inversion_objtab o
        WHERE o.id = 1)
    ));
    
INSERT INTO Movimiento_objtab VALUES(
    Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Prestamo casa', 400, 16000,
        NULL,(SELECT ref(o)
        FROM Prestamo_objtab o
        WHERE o.id = 1), NULL, NULL
    ));

INSERT INTO Movimiento_objtab VALUES(
    Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('25-Nov-20 11:32:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Prestamo casa pagar', 100, 16000,
        NULL, NULL, (SELECT ref(o)
        FROM Prestamo_objtab o
        WHERE o.id = 2),NULL
    ));
       


/*MOVIMIENTO TARJETA*/

/*INSERT INTO MovimientoTarjeta_objtab VALUES(
    MovimientoTarjeta_objtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('13-Oct-20 11:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Comprar Mercadona', 95.2, 1));
*/
/*INSERT INTO MovimientoTarjeta_objtab VALUES(
    MovimientoTarjeta_objtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('15-Oct-20 21:15:38.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Online', 25.9, 1));
*/
/*INSERT INTO MovimientoTarjeta_objtab VALUES(
    MovimientoTarjeta_objtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('03-Oct-20 02:25:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Pago Esteticien', 102.9, 1));
*/
/*INSERT INTO MovimientoTarjeta_objtab VALUES(
    MovimientoTarjeta_objtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('05-Dic-20 18:31:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Mercadona', 155.2, 1));
*/
/*INSERT INTO MovimientoTarjeta_objtab VALUES(
    MovimientoTarjeta_objtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('23-Dic-20 21:02:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Amazon', 10.2, 1));
*/

/*TARJETA*/
INSERT INTO Tarjeta_objtab VALUES(
    Tarjeta_objtyp(
    tarjeta_idtarjeta_seq.nextval, TO_DATE('14/05/2020','dd/mm/yyyy'), 123, 'CREDITO', 
    (SELECT ref(c) 
    FROM Cuenta_objtab c
    WHERE c.numcuenta = 1),
    MovimientoTarjeta_ntabtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('13-Oct-20 11:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Comprar Mercadona', 95.2, 1))));

INSERT INTO Tarjeta_objtab VALUES(
    Tarjeta_objtyp(
    tarjeta_idtarjeta_seq.nextval, TO_DATE('04/10/2021','dd/mm/yyyy'), 456, 'CREDITO', 
    (SELECT ref(c) 
    FROM Cuenta_objtab c
    WHERE c.numcuenta = 2),
    MovimientoTarjeta_ntabtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('15-Oct-20 21:15:38.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Online', 25.9, 1)),
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('03-Oct-20 02:25:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Pago Esteticien', 102.9, 1))

    )));

INSERT INTO Tarjeta_objtab VALUES(
    Tarjeta_objtyp(
    tarjeta_idtarjeta_seq.nextval, TO_DATE('21/01/2022','dd/mm/yyyy'), 789, 'DEBITO', 
    (SELECT ref(c) 
    FROM Cuenta_objtab c
    WHERE c.numcuenta = 1),
    MovimientoTarjeta_ntabtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('05-Dic-20 18:31:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Mercadona', 155.2, 1)),
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('23-Dic-20 21:02:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Amazon', 10.2, 1))
    )));

INSERT INTO Tarjeta_objtab VALUES(
    Tarjeta_objtyp(
    tarjeta_idtarjeta_seq.nextval, TO_DATE('14/09/2023','dd/mm/yyyy'), 147, 'DEBITO', 
    (SELECT ref(c) 
    FROM Cuenta_objtab c
    WHERE c.numcuenta = 3),
    MovimientoTarjeta_ntabtyp()));


