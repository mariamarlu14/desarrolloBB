/*BANCO*/

INSERT INTO Banco_objtab VALUES
(Banco_objtyp(372837, 'Banco LUMA'));


/*USUARIO CLIENTE*/
INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'27212721F', 'Lucía Navarro Sánchez', 679323593, TO_DATE('22/03/2000','dd/mm/yyyy') , 'C/La Paz', 20, 'Albacete', 02002, cliente_idcliente_seq.nextval));

INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'28349273A', 'Julia López Martínez', 683749273,TO_DATE('09/02/1970','dd/mm/yyyy') , 'C/La Paz', 15, 'Albacete', 02002, cliente_idcliente_seq.nextval));

INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'82746429J', 'Miguel Pérez Díaz', 638290912,TO_DATE('13/05/1994','dd/mm/yyyy') , 'Avenida de España', 170, 'Albacete', 02002, cliente_idcliente_seq.nextval));

INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'09382719I', 'María Martínez Lucas', 692930192,TO_DATE('14/11/1996','dd/mm/yyyy'), 'C/Hellín', 45, 'Albacete', 02006, cliente_idcliente_seq.nextval));


/*USUARIO GERENTE*/
INSERT INTO Gerente_objtyp values(
    Gerente_objtyp(
'38238472P', 'Pablo Rodrigo García', 620938756,TO_DATE('07/08/1975','dd/mm/yyyy') , 'C/Juan Carlos I', 2, 'Albacete',13320, gerente_idgerente_seq.nextval, 5039, 'MAÑANA', 1234));


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
    '12345678K', 'Sergio Martínez García', 628391029, TO_DATE('17/10/1998','dd/mm/yyyy'), 'C/Juan Carlos I', 3, 'Albacete', empleado_idempleado_seq.nextval, 1324, 2739 ,'TARDE', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'ADMINISTRADOR')));



/*SUCURSAL*/

INSERT INTO Sucursal_objtab VALUES
(Sucursal_objtyp('Albacete', sucursal_idsucursal_seq.nextval, 926384758, 'Hellín', 60, 02006, Usuarios_ntabtyp()));



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
    Movimiento_ntabtyp(), 
    (SELECT ref(u) FROM Cliente_objtab u WHERE u.dni = '27212721F')));


/*OPERACIÓN TRANSFERENCIA*/


INSERT INTO Transferencia_objtab VALUES(
    Transferencia_objtyp(
        operacion_idoperacion_seq.nextval,TO_TIMESTAMP ('10-Sep-02 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),  'NO INICIADA', 300.5, 'NACIONAL', 'comida', 1));



/*OPERACION INVERSION*/
INSERT INTO Inversion_objtab VALUES(
    Inversion_objtyp(
    operacion_idoperacion_seq.nextval,TO_TIMESTAMP ('03-Dic-02 13:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF') , 'NO INICIADA', 300.5, 'Bankia', 'Medio', 'banca', 
    (SELECT ref(g)
    FROM Gerente_objtab g
    WHERE g.numero_gerente = 1)));


/*OPERACION PRESTAMO*/
INSERT INTO Prestamo_objtab VALUES(
    Prestamo_objtyp(
    operacion_idoperacion_seq.nextval, TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'NO INICIADA', 0.5, 'hipoteca',  TO_DATE('18/03/2022','dd/mm/yyyy'), 
    (SELECT ref(e)
    FROM Empleado_objtab e
    WHERE e.numero_empleado = 1)));


/*MOVIMIENTO*/
INSERT INTO Movimiento_objtab VALUES(
    Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'prestamo casa', 400, 16000,
    (SELECT ref(o)
    FROM Transferencia_objtab o
    WHERE o.id = 3),
    NULL, NULL, NULL
    ));
    


/*MOVIMIENTO TARJETA*/

INSERT INTO MovimientoTarjeta_objtab VALUES(
    MovimientoTarjeta_objtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('13-Oct-20 11:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Comprar Mercadona', 95.2, 1));


/*TARJETA*/
INSERT INTO Tarjeta_objtab VALUES(
    Tarjeta_objtyp(
    tarjeta_idtarjeta_seq.nextval, TO_DATE('14/05/2020','dd/mm/yyyy'), 123, 'CREDITO', 
    (SELECT ref(c) 
    FROM Cuenta_objtab c
    WHERE c.numcuenta = 1),
    MovimientoTarjeta_ntabtyp()));
/**/





/*EJEMPLO*/

insert into Usuario_objtab values (
Empleado_objtyp (
usuario_idusuario_seq.nextval, 'Jesús', 'Buendía', 'Martínez','47474747A', '684256875', 'jesus.buendia@startgrow.com', 'C/La Almendra,26,1ºH', 'Albacete', '02001', 'España', '@1234',
'ES3721001439539824252398', 1802.25, Solicitud_ntabtyp()
)
);
insert into Usuario_objtab values (
Promotor_objtyp (
usuario_idusuario_seq.nextval, 'Florentino', 'Nieto', 'González', '27212721F', '679323593', 'florentino.nieto@hotmail.com', 'C/Via Trajana,51,4ºA', 'Barcelona', '08020', 'España', '@1239', 'ES8937691103860937681045', 'Director Ejecutivo de Virtual Indie.', Solicitud_ntabtyp()
)
);


