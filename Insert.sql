/*BANCO*/

INSERT INTO Banco_objtab VALUES
(Banco_objtyp(372837, 'Banco LUMA'));


/*USUARIO CLIENTE*/
INSERT INTO Usuario_objtab values (
Cliente_objtyp (
'27212721F', 'Lucía Navarro Sánchez', 679323593, 2000/03/22 , 'C/La Paz', 20, 'Albacete', 02002, cliente_numerocliente_seq.nextval));

INSERT INTO Usuario_objtab values (
Cliente_objtyp (
'28349273A', 'Julia López Martínez', 683749273, 1970/02/09 , 'C/La Paz', 15, 'Albacete', 02002, cliente_numerocliente_seq.nextval));

INSERT INTO Usuario_objtab values (
Cliente_objtyp (
'82746429J', 'Miguel Pérez Díaz', 638290912, 1994/05/13 , 'Avenida de España', 170, 'Albacete', 02002, cliente_numerocliente_seq.nextval));

INSERT INTO Usuario_objtab values (
Cliente_objtyp (
'09382719I', 'María Martínez Lucas', 692930192, 1996/11/14 , 'C/Hellín', 45, 'Albacete', 02006, cliente_numerocliente_seq.nextval));


/*USUARIO GERENTE*/
INSERT INTO Usuario_objtab values(
    Gerente_objtyp(
'382038472P', 'Pablo Rodrigo García', 6209384756, 1975/08/07, 'C/Juan Carlos I', 2, 'Albacete', gerente_id_gerente_seq.nextval, 5039, 'MAÑANA', 1234));

/*TIPO DE EMPLEADO*/
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('ADMINISTRADOR'));
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('CONTABLE'));
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('CAJERO'));


/*USUARIO EMPLEADO*/
INSERT INTO Usuario_objtab values(
    Empleado_objtyp(
'12345678K', 'Sergio Martínez García', 628391029, 1985/09/08, 'C/Juan Carlos I', 3, 'Albacete', empleado_idempleado_seq, 1324, 2739 ,'TARDE', 'ADMINISTRADOR'));


/*SUCURSAL*/

INSERT INTO Sucursal_objtab VALUES
(Sucursal_objtyp('Albacete', sucursal_idsucursal_seq.nextval, 9267384758, 'Hellín', 60, 02006, Usuarios_ntabtyp));


/*TIPO DE CUENTA*/

INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('JOVEN', 0.2, 0.3));
INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('NORMAL', 0.01, 0.3));
INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('PENSIONISTA', 0.2, 0.03));

/*MOVIMIENTO*/

INSERT INTO Movimiento_objtab VALUES(
	Movimiento_objtyp(movimiento_idmovimiento_seq.nextval, 2020-12-12 12:37:28, 'newkjfhq', 300.5, 0));
    
/*CUENTA*/

INSERT INTO Cuenta_objtab VALUES(
    Cuenta_objtyp(cuenta_idcuenta_seq.nextval, 2020/03/24, 28394, 'JOVEN', Movimiento_ntabtyp)
);
numCuenta number(20),
	fecha_Contrato date,
	saldo number(6, 6),
	tipocuenta REF TipoCuenta_objtyp,
	movimientos Movimiento_ntabtyp,
	cliente REF Cliente_objtyp

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