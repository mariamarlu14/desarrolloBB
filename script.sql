/**IMPORTANTE: la tabla transferencia, cuenta y tarjeta hasta que no se compila el tipo no se puede crear**/


/** Tipo BANCO**/
CREATE TYPE Banco_objtyp AS OBJECT(
	cif char(10),
	nombre varchar(10),
	calle varchar(20),
	numero number,
	localidad char(20),
	codigo_postal number(5),
	map member function get_CIF return CHAR,
	member procedure print,
	member function ordenar (v_banco in Banco_objtyp) return integer
);
/
/**Función getCIF, print, ordernarBanco**/
create or replace type body Banco_objtyp as 
	map member function get_CIF return CHAR is
	BEGIN
		return self.cif;
	END get_CIF;
	member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Banco');
		DBMS_OUTPUT.PUT ('CIF: '||cif);
		DBMS_OUTPUT.PUT ('nombre: '||nombre );
		DBMS_OUTPUT.NEW_LINE;
	END print;
	member function ordenar (v_banco in Banco_objtyp) return
	 integer is 
	 	BEGIN 
		 if v_banco.cif < self.cif then 
		 	DBMS_OUTPUT.PUT_LINE('CIF mayor.');
			return 1;
		else 
			DBMS_OUTPUT.PUT_LINE('CIF menor.');
			return 0;
	end if;
	END;	
END;
/
/**Tabla BANCO**/
CREATE TABLE Banco_objtab OF Banco_objtyp (
	cif PRIMARY KEY,
	check (nombre is not null),
	check(calle is not null),
	check(numero is not null),
	check(localidad is not null),
	check(codigo_postal is not null),
	nombre unique
);
/
/**Tipo USUARIO**/
CREATE TYPE Usuario_objtyp AS OBJECT(
	dni varchar(9),
	nombre char(60),
	telefono number(9),
	fecha_nacimiento date,
	calle varchar(20),
	numero number,
	localidad char(20),
	codigo_postal number(5),
	map member function get_dni return CHAR,
	member procedure print,
	member procedure cambiarTelefono(telefono_U IN VARCHAR2),
	member function ordenar (v_usuarios in Usuario_objtyp) return integer
) NOT INSTANTIABLE  NOT FINAL;
/

/**Tabla anidada para Sucursal **/
CREATE TYPE Usuarios_ntabtyp AS TABLE OF REF Usuario_objtyp;
/
/**Funcion getDNI, cambiarTelefono, ordenarUsuario**/
create or replace type body Usuario_objtyp as 
	map member function get_dni return CHAR is
	BEGIN
		return self.dni;
	END get_dni;
	member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Usuario');
		DBMS_OUTPUT.PUT ('DNI: '||dni);
		DBMS_OUTPUT.PUT ('Nombre: '||nombre );
		DBMS_OUTPUT.PUT ('Telefono: '||telefono );
		DBMS_OUTPUT.PUT ('Fecha nacimiento: '||fecha_nacimiento );
		DBMS_OUTPUT.PUT ('Direccion: '||calle ||','|| numero ||','|| localidad ||','|| codigo_postal );
		

		DBMS_OUTPUT.NEW_LINE;
	END print;
	member procedure cambiarTelefono (telefono_U IN VARCHAR2) IS
    BEGIN
    	self.telefono := telefono_U;
    END cambiarTelefono;
	member function ordenar (v_usuarios in Usuario_objtyp) return
	 integer is 
	 	BEGIN 
		 if v_usuarios.dni < self.dni then 
		 	DBMS_OUTPUT.PUT_LINE('DNI mayor.');
			return 1;
		else 
			DBMS_OUTPUT.PUT_LINE('DNI menor.');
			return 0;
	end if;
	END;
END;
/

CREATE TYPE Sucursal_objtyp AS OBJECT(
	localidad varchar(20),
	id char(10),
	telefono number(9),
	calle varchar(20),
	numero number,
	codigo_postal number(5),
	Usuarios Usuarios_ntabtyp,
	map member function get_id return CHAR,
	member procedure print,
	member procedure cambiarTelefono(telefono_U IN VARCHAR2),
	member function ordenar (v_sucursal in Sucursal_objtyp) return integer

);
/
/**Funcion getID, print, cambiarTelefono, ordenar**/
create or replace type body Sucursal_objtyp as 
	map member function get_id return CHAR is
	BEGIN
		return self.id;
	END get_id;
	member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Sucursal');
		DBMS_OUTPUT.PUT ('ID: '||id );
		DBMS_OUTPUT.PUT ('Localidad: '||localidad);
		DBMS_OUTPUT.PUT ('Telefono: '||telefono );
		DBMS_OUTPUT.PUT ('Direccion: '||calle ||','|| numero ||','|| localidad ||','|| codigo_postal );
		DBMS_OUTPUT.NEW_LINE;
	END print;
	member procedure cambiarTelefono (telefono_U IN VARCHAR2) IS
    BEGIN
    	self.telefono := telefono_U;
    END cambiarTelefono;
	member function ordenar (v_sucursal in Sucursal_objtyp) return
	 integer is 
	 	BEGIN 
		 if v_sucursal.id < self.id then 
		 	DBMS_OUTPUT.PUT_LINE('Id mayor.');
			return 1;
		else 
			DBMS_OUTPUT.PUT_LINE('Id menor.');
			return 0;
	end if;
	END;
END;
/
/**Tabla Sucursal**/
CREATE TABLE Sucursal_objtab OF Sucursal_objtyp (
	localidad PRIMARY KEY,
	check(id is not null),
	check(telefono is not null),
	telefono unique,
	check(calle is not null),
	check(numero is not null),
	check(codigo_postal is not null)
) NESTED TABLE Usuarios STORE AS Usuarios_ntab;
/
/**Tipo GERENTE**/
CREATE TYPE Gerente_objtyp UNDER Usuario_objtyp(
	numero_gerente varchar(10),
	salario number(12, 2),
	turno varchar(10),
	extension number,
	overriding member procedure print
	
);
/
/**Funcion print**/
create or replace type body Gerente_objtyp as 
	
	overriding member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Gerente');
		DBMS_OUTPUT.PUT ('Numero de gerente: '||numero_gerente );
		DBMS_OUTPUT.PUT ('Salario: '||salario);
		DBMS_OUTPUT.PUT ('Turno: '||turno );
		DBMS_OUTPUT.PUT ('Extension: '||extension );
		DBMS_OUTPUT.NEW_LINE;
	END print;
	

END;
/
/**Tabla GERENTE**/
CREATE TABLE Gerente_objtab OF Gerente_objtyp(
	dni PRIMARY KEY,
	check(numero_gerente is not null),
	numero_gerente unique,
	check(salario is not null),
	check(salario > 0),
	check (UPPER(turno) in ('MAÑANA', 'TARDE')),
	check(extension is not null),
	extension unique
);

/
/**Tipo TIPOEMPLEADO**/
CREATE TYPE TipoEmpleado_objtyp AS OBJECT(tipo char(15));
/
/**Tabla TIPOEMPLEADO**/
CREATE TABLE TipoEmpleado_objtab OF TipoEmpleado_objtyp(
	tipo PRIMARY KEY,
	check (
		UPPER(tipo) in ('ADMINISTRADOR', 'CAJERO', 'CONTABLE')
	)
);
/

/**Tipo EMPLEADO**/
CREATE TYPE Empleado_objtyp UNDER Usuario_objtyp(
	numero_empleado varchar(10),
	extension number,
	salario number(12, 2),
	turno varchar(20),
	tipo REF TipoEmpleado_objtyp,
	overriding member procedure print

);
/
/**Funcion print**/
create or replace type body Empleado_objtyp as 
	
	overriding member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Empleado');
		DBMS_OUTPUT.PUT ('Numero de epleado: '||numero_empleado );
		DBMS_OUTPUT.PUT ('Salario: '||salario);
		DBMS_OUTPUT.PUT ('Turno: '||turno );
		DBMS_OUTPUT.PUT ('Extension: '||extension );
		DBMS_OUTPUT.NEW_LINE;
	END print;

END;
/
/**Tabla EMPLEADO**/
CREATE TABLE Empleado_objtab OF Empleado_objtyp(
	dni PRIMARY KEY,
	check(numero_empleado is not null),
	numero_empleado unique,
	check(extension is not null),
	extension unique,
	check(salario is not null),
	check(salario > 0),
	check (UPPER(turno) in ('MAÑANA', 'TARDE')),
	SCOPE FOR(tipo) IS TipoEmpleado_objtab
);
/

/**Tipo TIPOCUENTA**/
CREATE TYPE TipoCuenta_objtyp AS OBJECT(
	tipo varchar(20),
	interes number(12, 2),
	comision number(12, 2)

);
/
/**Tabla TIPOCUENTA**/
CREATE TABLE TipoCuenta_objtab OF TipoCuenta_objtyp(
	tipo PRIMARY KEY,
	check (UPPER(tipo) in ('JOVEN', 'ADULTO', 'PENSIONISTA')),
	check(interes is not null),
	check(interes > 0),
	check(comision is not null),
	check(comision > 0)
);
/



/**Tipo CLIENTE**/
CREATE TYPE Cliente_objtyp UNDER Usuario_objtyp(numero_cliente varchar(10));
/
/**Tabla CLIENTE**/
CREATE TABLE Cliente_objtab OF Cliente_objtyp(
	dni PRIMARY KEY,
	numero_cliente unique,
	check(numero_cliente is not null)
);
/


/**Tipo OPERACION**/
CREATE TYPE Operacion_objtyp AS OBJECT(
	id number(10),
	fecha timestamp,
	estado varchar(20),
	saldo_op number(12, 2),
	map member function get_id return CHAR,
	member procedure print,
	member procedure cambiarEstado(estado_O IN VARCHAR2),
	member function ordenar (v_operacion in Operacion_objtyp) return integer
) NOT FINAL;
/
/**Funcion getID, print, cambiarEstado, ordenar**/
create or replace type body Operacion_objtyp as 
	map member function get_id return CHAR is
	BEGIN
		return self.id;
	END get_id;
	member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Operacion');
		DBMS_OUTPUT.PUT ('Fecha: '||fecha );
		DBMS_OUTPUT.PUT ('Estado: '||estado );
		DBMS_OUTPUT.PUT ('Saldo de la operación: '||saldo_op );
		DBMS_OUTPUT.NEW_LINE;
	END print;
	member procedure cambiarEstado (estado_O IN VARCHAR2) IS
    BEGIN
    	self.estado := estado_O;
    END cambiarEstado;
	member function ordenar (v_operacion in Operacion_objtyp) return
	 integer is 
	 	BEGIN 
		 if v_operacion.id < self.id then 
		 	DBMS_OUTPUT.PUT_LINE('Id mayor.');
			return 1;
		else 
			DBMS_OUTPUT.PUT_LINE('Id menor.');
			return 0;
	end if;
	END;
END;
/
CREATE TYPE Inversion_objtyp UNDER Operacion_objtyp(
	nombre_fondo varchar(20),
	riesgo varchar(20),
	categoria varchar(20),
	gerente REF Gerente_objtyp,
	overriding member procedure print
);
/
/**Funcion print**/
create or replace type body Inversion_objtyp as 
	
	overriding member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Inversion');
		DBMS_OUTPUT.PUT ('Nombre de fondo: '||nombre_fondo );
		DBMS_OUTPUT.PUT ('Riesgo: '||riesgo);
		DBMS_OUTPUT.PUT ('Categoria: '|| categoria );
		DBMS_OUTPUT.NEW_LINE;
	END print;
END;
/
/**Tabla INVERSION**/
CREATE TABLE Inversion_objtab OF Inversion_objtyp(
	id PRIMARY KEY,
	check(nombre_fondo is not null),
	check(riesgo is not null),
	check(categoria is not null),
	check(gerente is not null),

	SCOPE FOR(gerente) IS Gerente_objtab
);
/

/**Tipo PRESTAMO**/
CREATE TYPE Prestamo_objtyp UNDER Operacion_objtyp(
	finalidad varchar(40),
	plazo date,
	empleado REF Empleado_objtyp,
	overriding member procedure print
);
/
/**Funcion print**/
create or replace type body Prestamo_objtyp as 
	
	overriding member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Prestamo');
		DBMS_OUTPUT.PUT ('Finalidad: '||finalidad );
		DBMS_OUTPUT.PUT ('Date: '||plazo);
		DBMS_OUTPUT.NEW_LINE;
	END print;
END;
/
/**Tabla PRESTAMO**/

CREATE TABLE Prestamo_objtab OF Prestamo_objtyp(
    id PRIMARY KEY,
    check(finalidad is not null),
    check(plazo is not null),
    SCOPE FOR(empleado) IS Empleado_objtab
    );
/

/**Tipo MOVIMIENTO TARJETA**/
CREATE TYPE MovimientoTarjeta_objtyp AS OBJECT(
	numero_movt varchar(20),
	fecha_hora timestamp,
	concepto varchar(50),
	cargo number(10),
	mensualidad number(12, 2),
	pasada varchar(50),
	map member function get_numero_movt return CHAR,
	member procedure print,
	member function ordenar (v_movimientoT in MovimientoTarjeta_objtyp) return integer
);
/
/**Funcion getNumeroMovt, print, ordenar**/
create or replace type body MovimientoTarjeta_objtyp as 
	map member function get_numero_movt return CHAR is
	BEGIN
		return self.numero_movt;
	END get_numero_movt;
	member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Movimiento Tarjeta');
		DBMS_OUTPUT.PUT ('Fecha: '||fecha_hora);
		DBMS_OUTPUT.PUT ('Concepto: '||concepto );
		DBMS_OUTPUT.PUT ('Cargo: '||cargo );
		DBMS_OUTPUT.PUT ('Mensualidad: '||mensualidad );
		DBMS_OUTPUT.NEW_LINE;
	END print;
	
	member function ordenar (v_movimientoT in MovimientoTarjeta_objtyp) return
	 integer is 
	 	BEGIN 
		 if v_movimientoT.fecha_hora < self.fecha_hora then 
		 	DBMS_OUTPUT.PUT_LINE('Fecha mayor.');
			return 1;
		else 
			DBMS_OUTPUT.PUT_LINE('Fecha menor.');
			return 0;
	end if;
	END;
END;
/





/**Tipo TRANSFERENCIA**/
CREATE TYPE Transferencia_objtyp UNDER Operacion_objtyp(
	tipo varchar(40),
	concepto varchar(50),
	beneficiario number(15),
	cuentaOrigen REF Cuenta_objtyp,
	overriding member procedure print

);
/
/**Funcion print**/
create or replace type body Transferencia_objtyp as 
	
	overriding member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Transferencia');
		DBMS_OUTPUT.PUT ('Tipo: '||tipo );
		DBMS_OUTPUT.PUT ('Concepto: '||concepto);
		DBMS_OUTPUT.PUT ('Beneficiario: '||beneficiario);
		DBMS_OUTPUT.NEW_LINE;
	END print;
END;
/


/**Tipo MOVIMIENTO**/
create or replace TYPE Movimiento_objtyp AS OBJECT(
	numero_mov varchar(20),
	fecha_hora timestamp ,
	concepto varchar(50),
	cargo number(12, 2),
	saldo number(12, 2),
	tipo_trans REF Transferencia_objtyp,
	tipo_pres1 REF Prestamo_objtyp,
	tipo_pres2 REF Prestamo_objtyp,
	tipo_inv REF Inversion_objtyp,
	map member function get_numero_mov return CHAR,
	member procedure print,
	member function ordenar (v_movimientos in Movimiento_objtyp) return integer

);
/

/**Tabla anidada para TARJETA**/
CREATE TYPE Movimientotarjeta_ntabtyp AS TABLE OF Movimientotarjeta_objtyp;
/
/**Tabla anidada para CUENTA**/
CREATE TYPE Movimiento_ntabtyp AS TABLE OF Movimiento_objtyp;
/
/**Funcion getNumeroMov, print, ordenar**/
create or replace type body Movimiento_objtyp as 
	map member function get_numero_mov return CHAR is
	BEGIN
		return self.numero_mov;
	END get_numero_mov;
	member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Movimiento');
		DBMS_OUTPUT.PUT ('Numero: '||numero_mov);
		DBMS_OUTPUT.PUT ('Fecha hora: '||fecha_hora );
		DBMS_OUTPUT.PUT ('Concepto: '||concepto );
		DBMS_OUTPUT.PUT ('Cargo: '||cargo );
		DBMS_OUTPUT.PUT ('Saldo: '||saldo );
		

		DBMS_OUTPUT.NEW_LINE;
	END print;
	
	member function ordenar (v_movimientos in Movimiento_objtyp) return
	 integer is 
	 	BEGIN 
		 if v_movimientos.fecha_hora < self.fecha_hora then 
		 	DBMS_OUTPUT.PUT_LINE('Fecha mayor.');
			return 1;
		else 
			DBMS_OUTPUT.PUT_LINE('Fecha menor.');
			return 0;
	end if;
	END;
END;

/
/**Tabla anidada para CUENTA**/
CREATE TYPE Cliente_ntabtyp AS TABLE OF REF Cliente_objtyp;
/
create or replace TYPE Cuenta_objtyp AS OBJECT (
	numCuenta number(20),
	fecha_Contrato date,
	saldo number(12,2),
	tipocuenta REF TipoCuenta_objtyp,
	movimientos Movimiento_ntabtyp,
	clientes Cliente_ntabtyp,
	map member function get_numCuenta return CHAR,
	member procedure print,
	member function ordenar (v_cuenta in Cuenta_objtyp) return integer

);
/
/**Funcion getNumCuenta, ordenar, print**/
create or replace type body Cuenta_objtyp as 
	map member function get_numCuenta return CHAR is
	BEGIN
		return self.numCuenta;
	END get_numCuenta;
	member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Cuenta');
		DBMS_OUTPUT.PUT ('Numero: '||numCuenta);
		DBMS_OUTPUT.PUT ('Fecha de contrato: '||fecha_Contrato );
		DBMS_OUTPUT.PUT ('Saldo: '||saldo );
		DBMS_OUTPUT.NEW_LINE;
	END print;
	member function ordenar (v_cuenta in Cuenta_objtyp) return
	 integer is 
	 	BEGIN 
		 if v_cuenta.numCuenta < self.numCuenta then 
		 	DBMS_OUTPUT.PUT_LINE('Numero de cuenta mayor.');
			return 1;
		else 
			DBMS_OUTPUT.PUT_LINE('Numero de cuenta menor.');
			return 0;
	end if;
	END;
	
END;


/

/**Tipo TARJETA**/
CREATE TYPE Tarjeta_objtyp AS OBJECT(
	numTarjeta number(20),
	fecha_Caducidad date,
	CVV number(3),
	tipo varchar(20),
	cuenta REF Cuenta_objtyp,
	movimientos MovimientoTarjeta_ntabtyp,
	map member function get_numTarjeta return CHAR,
	member procedure print,
	member function ordenar (v_tarjeta in Tarjeta_objtyp) return integer

);
/
/**Funcion getNumTarjeta, print, ordenar**/
create or replace type body Tarjeta_objtyp as 
	map member function get_numTarjeta return CHAR is
	BEGIN
		return self.numTarjeta;
	END get_numTarjeta;
	member procedure print IS
	BEGIN
		DBMS_OUTPUT.PUT ('Tarjeta');
		DBMS_OUTPUT.PUT ('Numero Tarjeta: '||numTarjeta);
		DBMS_OUTPUT.PUT ('Fecha de caducidad: '||fecha_Caducidad);
		DBMS_OUTPUT.PUT ('CVV: '||CVV );
		DBMS_OUTPUT.PUT ('Tipo: '||tipo );
		DBMS_OUTPUT.NEW_LINE;
	END print;
	
	member function ordenar (v_tarjeta in Tarjeta_objtyp) return
	 integer is 
	 	BEGIN 
		 if v_tarjeta.fecha_Caducidad < self.fecha_Caducidad then 
		 	DBMS_OUTPUT.PUT_LINE('Fecha mayor.');
			return 1;
		else 
			DBMS_OUTPUT.PUT_LINE('Fecha menor.');
			return 0;
	end if;
	END;
END;
/

/**Tabla anidada para transferencias**/
CREATE TYPE Cuenta_ntabtyp AS TABLE OF REF Cuenta_objtyp;
/

ALTER TABLE movimiento_ntab ADD (SCOPE FOR (tipo_trans) IS transferencia_objtab);
/
ALTER TABLE movimiento_ntab ADD (SCOPE FOR (tipo_pres1) IS prestamo_objtab);
/
ALTER TABLE movimiento_ntab ADD (SCOPE FOR (tipo_pres2) IS prestamo_objtab);
/
ALTER TABLE movimiento_ntab ADD (SCOPE FOR (tipo_inv) IS inversion_objtab);

/
/**Tabla CUENTA**/
CREATE TABLE Cuenta_objtab OF Cuenta_objtyp(
	numCuenta PRIMARY KEY,
	check(fecha_Contrato is not null),
	check(saldo is not null),
	check(saldo > 0),
	SCOPE FOR(tipocuenta) IS TipoCuenta_objtab)
    NESTED TABLE clientes STORE AS Cliente_ntab,
NESTED TABLE movimientos STORE AS Movimiento_ntab(
	(	
	numero_mov PRIMARY KEY,
	check(fecha_hora is not null),
	check(concepto is not null),
	check(cargo is not null),
	check(cargo > 0),
	check(saldo is not null),
	check(saldo > 0)
	
));
/
/**Tabla TRANSFERENCIA**/
CREATE TABLE Transferencia_objtab OF Transferencia_objtyp(
	id PRIMARY KEY,
	check(tipo is not null),
	check (UPPER(tipo) in ('EXTERIOR', 'NACIONAL')),
	check(concepto is not null),
	check(beneficiario is not null),
	SCOPE FOR(cuentaOrigen) IS Cuenta_objtab


);
/
/**Tabla TARJETA**/
CREATE TABLE Tarjeta_objtab OF Tarjeta_objtyp(
	numTarjeta PRIMARY KEY,
	check(fecha_Caducidad is not null),
	check(CVV is not null),
	check(tipo is not null),
	check (UPPER(tipo) in ('CREDITO', 'DEBITO')),
	SCOPE FOR(cuenta) IS Cuenta_objtab
) NESTED TABLE movimientos STORE AS MovimientoTarjeta_ntab(
	(
		numero_movt PRIMARY KEY,
	check(fecha_hora is not null),
	check(concepto is not null),
	check(cargo is not null),
	check(cargo > 0),
	check(mensualidad is not null)
	)
);



/
CREATE SEQUENCE banco_idbanco_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE sucursal_idsucursal_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE gerente_idgerente_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE empleado_idempleado_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE movimiento_idmovimiento_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE cliente_numerocliente_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE cuenta_idcuenta_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE transferencia_idtransferencia_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE prestamo_idprestamo_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE inversion_idinversion_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE movimientoTarjeta_idmovimientoTarjeta_seq START WITH 1 INCREMENT BY 1;
/
CREATE SEQUENCE tarjeta_idtarjeta_seq START WITH 1 INCREMENT BY 1;
/

/**INSERCIONES**/
/*BANCO*/

INSERT INTO Banco_objtab VALUES
(Banco_objtyp(372837, 'Banco LUMA','Calle Hellín',2,'Albacete',02006));

/
/*USUARIO CLIENTE*/
INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'27212721F', 'Lucía Navarro Sánchez', 679323593, TO_DATE('22/03/2000','dd/mm/yyyy') , 'C/La Paz', 20, 'Albacete', 02002, cliente_numerocliente_seq.nextval));
/
INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'28349273A', 'Julia López Martínez', 683749273,TO_DATE('09/02/1970','dd/mm/yyyy') , 'C/La Paz', 15, 'Albacete', 02002, cliente_numerocliente_seq.nextval));
/
INSERT INTO Cliente_objtab values (
Cliente_objtyp ( 
'82746429J', 'Miguel Pérez Díaz', 638290912,TO_DATE('13/05/1994','dd/mm/yyyy') , 'Avenida de España', 170, 'Albacete', 02002, cliente_numerocliente_seq.nextval));
/
INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'09382719I', 'María Martínez Lucas', 692930192,TO_DATE('14/11/1996','dd/mm/yyyy'), 'C/Hellín', 45, 'Albacete', 02006, cliente_numerocliente_seq.nextval));
/
INSERT INTO Cliente_objtab values (
Cliente_objtyp (
'92831029P', 'Julia Perona Espinosa', 609128374,TO_DATE('18/01/1940','dd/mm/yyyy'), 'C/Socuéllamos', 100, 'Ciudad Real', 13700, cliente_numerocliente_seq.nextval));

/
/*USUARIO GERENTE*/
INSERT INTO Gerente_objtab values(
    Gerente_objtyp(
'38238472P', 'Pablo Rodrigo García', 620938756,TO_DATE('07/08/1975','dd/mm/yyyy') , 'C/Juan Carlos I', 2, 'Albacete',13320, gerente_idgerente_seq.nextval, 5039, 'MAÑANA', 1234));
/
INSERT INTO Gerente_objtab values(
    Gerente_objtyp(
'84750293I', 'Raquel Navarro Sánchez', 602938176,TO_DATE('09/03/1980','dd/mm/yyyy') , 'C/Montesol', 4, 'Ciudad Real',13701, gerente_idgerente_seq.nextval, 9087, 'TARDE', 1240));

/
/*TIPO DE EMPLEADO*/
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('ADMINISTRADOR'));
/
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('CONTABLE'));
/
INSERT INTO TipoEmpleado_objtab values(
    TipoEmpleado_objtyp('CAJERO'));
/

/*USUARIO EMPLEADO*/
INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '12345678K', 'Sergio Martínez García', 628391029, TO_DATE('17/10/1998','dd/mm/yyyy'), 'C/Juan Carlos I', 3, 'Albacete',13320, empleado_idempleado_seq.nextval, 1324, 2739 ,'TARDE', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'ADMINISTRADOR')));
/
INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '82730198L', 'Raúl Castellanos Sáez', 687093657, TO_DATE('17/08/1989','dd/mm/yyyy'), 'Avenida España', 20, 'Albacete',02006, empleado_idempleado_seq.nextval, 1329, 3002 ,'MAÑANA', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'CONTABLE')));
/
INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '93560235Q', 'Álvaro Moreno García', 678923456, TO_DATE('09/06/1996','dd/mm/yyyy'), 'C/Hellín', 9, 'Albacete',02006, empleado_idempleado_seq.nextval, 1327, 2839 ,'TARDE', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'CAJERO')));
/
INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '82730298L', 'Miguel Navarro Espinosa', 615982567, TO_DATE('11/11/1972','dd/mm/yyyy'), 'C/Montesol', 7, 'Ciudad Real',13701, empleado_idempleado_seq.nextval, 1330, 3002 ,'MAÑANA', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'CONTABLE')));
/
INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '74808416O', 'Óscar Sevilla Sánchez', 687254081, TO_DATE('09/04/1997','dd/mm/yyyy'), 'C/Castilla la Mancha', 7, 'Ciudad Real',13701, empleado_idempleado_seq.nextval, 1287, 3874 ,'TARDE', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'ADMINISTRADOR')));
/   
INSERT INTO Empleado_objtab values(
    Empleado_objtyp(
    '82736401S', 'Jesús Escudero Avendano', 690384756, TO_DATE('03/10/1989','dd/mm/yyyy'), 'C/La Paz', 9, 'Ciudad Real',13700, empleado_idempleado_seq.nextval, 1738, 2739 ,'MAÑANA', 
    (SELECT ref(t)
    FROM TipoEmpleado_objtab t
    WHERE tipo = 'CAJERO')));

/
/*SUCURSAL*/

INSERT INTO Sucursal_objtab VALUES
(Sucursal_objtyp('Albacete', sucursal_idsucursal_seq.nextval, 926384758, 'Hellín', 60, 02006, Usuarios_ntabtyp()));
/
INSERT INTO Sucursal_objtab VALUES
(Sucursal_objtyp('Ciudad Real', sucursal_idsucursal_seq.nextval, 926388758, 'Tobarra', 61, 05106, Usuarios_ntabtyp()));
/
/*TIPO DE CUENTA*/

INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('JOVEN', 0.2, 0.3));
/    
INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('ADULTO', 0.01, 0.3));
/    
INSERT INTO TipoCuenta_objtab VALUES(
    TipoCuenta_objtyp('PENSIONISTA', 0.2, 0.03));

/

/*OPERACION INVERSION*/
INSERT INTO Inversion_objtab VALUES(
    Inversion_objtyp(
    inversion_idinversion_seq.nextval,TO_TIMESTAMP ('03-Dic-02 13:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF') , 'NO INICIADA', 300.5, 'Bankia', 'Medio', 'banca', 
    (SELECT ref(g)
    FROM Gerente_objtab g
    WHERE g.numero_gerente = 1)));

/
/*OPERACION PRESTAMO*/
INSERT INTO Prestamo_objtab VALUES(
    Prestamo_objtyp(
    prestamo_idprestamo_seq.nextval, TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'NO INICIADA', 0.5, 'hipoteca',  TO_DATE('18/03/2022','dd/mm/yyyy'), 
    (SELECT ref(e)
    FROM Empleado_objtab e
    WHERE e.numero_empleado = 1)));
/
INSERT INTO Prestamo_objtab VALUES(
    Prestamo_objtyp(
    prestamo_idprestamo_seq.nextval, TO_TIMESTAMP ('03-Dic-20 12:38:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'NO INICIADA', 0.5, 'devolver hipoteca',  TO_DATE('18/04/2022','dd/mm/yyyy'), 
    (SELECT ref(e)
    FROM Empleado_objtab e
    WHERE e.numero_empleado = 1)));
/   
INSERT INTO Cuenta_objtab VALUES(
    Cuenta_objtyp(
    cuenta_idcuenta_seq.nextval, TO_DATE('21/11/2020','dd/mm/yyyy'), 25548, 
    (SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'ADULTO'),
    Movimiento_ntabtyp(Movimiento_objtyp(
        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Prestamo casa', 400, 16000,
        NULL,(SELECT ref(o)
        FROM Prestamo_objtab o
        WHERE o.id = 1), NULL, NULL
    ),
    Movimiento_objtyp(
        4,TO_TIMESTAMP ('25-Nov-20 11:32:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Prestamo casa pagar', 100, 16000,
        NULL, NULL, (SELECT ref(o)
        FROM Prestamo_objtab o
        WHERE o.id = 2),NULL
    )), 
    Cliente_ntabtyp(
    (SELECT ref(u) FROM Cliente_objtab u WHERE u.dni = '28349273A'))));
/

/*OPERACIÓN TRANSFERENCIA*/


INSERT INTO Transferencia_objtab VALUES(
    Transferencia_objtyp(
        transferencia_idtransferencia_seq.nextval,TO_TIMESTAMP ('10-Sep-02 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),  'NO INICIADA', 300.5, 'NACIONAL', 'luz', 1,
        (SELECT ref(o)
    FROM Cuenta_objtab o
    WHERE o.numCuenta = 1)));
/
INSERT INTO Transferencia_objtab VALUES(
    Transferencia_objtyp(
        transferencia_idtransferencia_seq.nextval,TO_TIMESTAMP ('12-Sep-02 12:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),  'NO INICIADA', 10.5, 'NACIONAL', 'agua', 1,(SELECT ref(o)
    FROM Cuenta_objtab o
    WHERE o.numCuenta = 1)));
/

INSERT INTO Cuenta_objtab VALUES(
    Cuenta_objtyp(
    cuenta_idcuenta_seq.nextval, TO_DATE('24/03/2020','dd/mm/yyyy'), 28394, 
    (SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'JOVEN'),
    Movimiento_ntabtyp(Movimiento_objtyp(
                        movimiento_idmovimiento_seq.nextval,TO_TIMESTAMP ('14-Sep-20 02:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'),
                        'Inversion Ibex 35', 400, 16000,
                        NULL, NULL, NULL,
                        (SELECT ref(o)
                        FROM Inversion_objtab o
                        WHERE o.id = 1)),
                    Movimiento_objtyp(
                        80,
                        TO_TIMESTAMP ('02-Dic-20 13:03:30.123000',
                        'DD-Mon-RR HH24:MI:SS.FF'), 'Pago agua', 25, 16000,
                        (SELECT ref(o)
                        FROM Transferencia_objtab o
                        WHERE o.id = 1),
                        NULL, NULL, NULL
        )), 
        Cliente_ntabtyp(
            (SELECT REF(c) FROM Cliente_objtab c WHERE dni = '27212721F') 
        )));
        
/     


INSERT INTO Cuenta_objtab VALUES(
    Cuenta_objtyp(
    cuenta_idcuenta_seq.nextval, TO_DATE('24/03/2020','dd/mm/yyyy'), 88544, 
    (SELECT ref(t) FROM TipoCuenta_objtab t WHERE tipo = 'PENSIONISTA'),
    Movimiento_ntabtyp( Movimiento_objtyp(
        5,TO_TIMESTAMP ('03-Dic-20 12:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Pago luz', 30, 16000,
    (SELECT ref(o)
    FROM Transferencia_objtab o
    WHERE o.id = 2),
    NULL, NULL, NULL
    )), 
    Cliente_ntabtyp(
    (SELECT ref(u) FROM Cliente_objtab u WHERE u.dni = '92831029P'))));
/
/*TARJETA*/
INSERT INTO Tarjeta_objtab VALUES(
    Tarjeta_objtyp(
    tarjeta_idtarjeta_seq.nextval, TO_DATE('14/05/2020','dd/mm/yyyy'), 123, 'CREDITO', 
    (SELECT ref(c) 
    FROM Cuenta_objtab c
    WHERE c.numcuenta = 1),
    MovimientoTarjeta_ntabtyp(
    movimientoTarjeta_objtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval,
        TO_TIMESTAMP ('13-Oct-20 11:37:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Comprar Mercadona', 95.2, 1,'NO'))));
/
INSERT INTO Tarjeta_objtab VALUES(
    Tarjeta_objtyp(
    tarjeta_idtarjeta_seq.nextval, TO_DATE('21/01/2022','dd/mm/yyyy'), 789, 'DEBITO', 
    (SELECT ref(c) 
    FROM Cuenta_objtab c
    WHERE c.numcuenta = 1),
    MovimientoTarjeta_ntabtyp(
     movimientoTarjeta_objtyp(
        4, TO_TIMESTAMP ('05-Dic-20 18:31:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Mercadona', 155.2, 1,'NO'),
    movimientoTarjeta_objtyp(
       5, TO_TIMESTAMP ('23-Dic-20 21:02:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Amazon', 10.2, 1,'NO'))
    ));
/
INSERT INTO Tarjeta_objtab VALUES(
    Tarjeta_objtyp(
    tarjeta_idtarjeta_seq.nextval, TO_DATE('21/01/2022','dd/mm/yyyy'), 789, 'DEBITO', 
    (SELECT ref(c) 
    FROM Cuenta_objtab c
    WHERE c.numcuenta = 1),
    MovimientoTarjeta_ntabtyp(
     movimientoTarjeta_objtyp(
        movimientoTarjeta_idmovimientoTarjeta_seq.nextval, TO_TIMESTAMP ('05-Dic-20 18:31:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Mercadona', 155.2, 1,'NO'),
      movimientoTarjeta_objtyp(
        80, TO_TIMESTAMP ('23-Dic-20 21:02:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'Compra Amazon', 10.2, 1,'NO'))
    ));

/**FUNCIONES**/
/
create or replace FUNCTION getmov (numCuenta1 IN VARCHAR2)
    RETURN Movimiento_NTABTYP AS mv Movimiento_NTABTYP;
    BEGIN
        SELECT Cu.movimientos INTO mv FROM Cuenta_objtab Cu WHERE Cu.numCuenta = numCuenta1;
    RETURN mv;
END getmov;

/

create or replace FUNCTION INFOMovimiento(numCuenta1 IN VARCHAR2) RETURN VARCHAR2 AS TEXTO VARCHAR2(30000);
Mv Movimiento_NTABTYP;
aux Transferencia_objtyp;
    BEGIN
        Mv := getmov(numCuenta1);
        FOR I IN Mv.FIRST..Mv.LAST LOOP
            SELECT DEREF(Mv(I).Tipo_trans)
            INTO aux
                FROM DUAL; TEXTO := TEXTO || (CHR(13) || CHR(9) || ' Num: ' || Mv(I).numero_mov || ' Fecha y hora: ' || Mv(I).fecha_hora || ' Concepto: ' || Mv(I).concepto || ' Saldo: ' || Mv(I).saldo ||'---' );
            END LOOP;
    RETURN TEXTO;
END;
/

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
       

  if vturno = nomTurno then
       
    total:= total+saldoOp;
   end if;
              dbms_output.put_line('Total' || total);

    RETURN total;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('No existe la finalidad');
        RETURN 0;

END;
/
/**SENTENCIAS**/


CREATE OR REPLACE VIEW Info_cuentas_usuario AS
SELECT cu.numcuenta, cu.fecha_contrato, cu.saldo, cli.dni, cli.nombre, cli.telefono, cli.fecha_nacimiento, cli.calle, cli.numero, cli.localidad
FROM cuenta_objtab cu, cliente_objtab cli
WHERE REF(cli) IN
(SELECT ref(c) FROM Cliente_objtab c WHERE c.dni = '&DNI');
/
CREATE OR REPLACE VIEW Empleado_Con_Mas_Prestamos ("DNI", "Nombre", "Telefono", "Extension", "Turno")AS
SELECT e.dni, e.nombre, e.telefono, e.extension, e.turno
FROM empleado_objtab e
WHERE e.dni IN (SELECT max(p.Empleado.dni)
FROM prestamo_objtab p);
/

CREATE OR REPLACE VIEW Datos_Cuenta_Movimiento ("NUMERO_CUENTA", "FECHA_CONTRATO", "SALDO", "MOVIMIENTOS")  AS
Select C.NumCuenta,C.Fecha_Contrato, C.Saldo, (INFOMovimiento(C.NumCuenta)) AS DATOS
FROM cuenta_objtab C;
/
CREATE OR REPLACE VIEW Info_sucursal_usuario AS
SELECT cu.localidad,  cu.telefono, cu.calle, cu.numero, cu.codigo_postal, cli.dni, cli.nombre, cli.fecha_nacimiento
FROM sucursal_objtab cu, cliente_objtab cli
WHERE REF(cli) IN
(SELECT ref(c) FROM Cliente_objtab c WHERE c.dni = '&DNI' ) and cu.localidad='Albacete' ;
/

CREATE OR REPLACE VIEW Gerente_Mas_Inversiones_Riesgo_Medio AS
SELECT g.*
FROM gerente_objtab g
WHERE REF(g)=
 (SELECT max(i.gerente)
FROM inversion_objtab i where i.riesgo='Medio');
/

CREATE OR REPLACE VIEW Tipo_Empleado_Segun_Turno AS
SELECT te.*
FROM tipoempleado_objtab te
WHERE ref(te)
IN (SELECT e.tipo
FROM empleado_objtab e where e.turno='&TURNO');
/

CREATE OR REPLACE VIEW Prestamo_no_iniciado AS
    SELECT p.id, p.fecha, p.estado, p.saldo_op, p.finalidad, p.plazo, p.empleado.nombre AS nombre FROM Prestamo_objtab p
     WHERE p.empleado.dni = '&DNI' AND p.estado = 'NO INICIADA';

/
CREATE OR REPLACE VIEW Caducidad AS
SELECT t.numTarjeta, t.fecha_Caducidad, t.CVV, t.tipo
FROM tarjeta_objtab t
WHERE t.fecha_Caducidad IN (SELECT min(fecha_Caducidad) FROM tarjeta_objtab WHERE fecha_Caducidad > SYSDATE);

/
CREATE OR REPLACE VIEW Cuenta_y_Cliente_Tarjeta_DEBITO ("Numero Cuenta", "Fecha Contrato", "Saldo", "DNI", "Nombre", "Telefono","Fecha_nacimiento")AS
SELECT e.numcuenta, e.fecha_contrato, e.saldo, cli.dni, cli.nombre, cli.telefono, cli.fecha_nacimiento 
FROM cuenta_objtab e, cliente_objtab cli
WHERE e.numcuenta IN (SELECT p.cuenta.numcuenta
FROM tarjeta_objtab p where p.tipo='DEBITO') and REF(cli) IN
(SELECT ref(c) FROM Cliente_objtab c);
/

CREATE OR REPLACE VIEW Cuenta_Con_Mas_Tarjetas ("Numero_Cuenta", "Fecha_Contrato", "Saldo") AS
SELECT c.numCuenta, c.fecha_Contrato, c.saldo
FROM Cuenta_objtab c
WHERE c.numCuenta IN (SELECT max(t.cuenta.numCuenta)
FROM Tarjeta_objtab t GROUP BY t.cuenta.numCuenta);
/

CREATE OR REPLACE VIEW Info_Cuentas_Jovenes ("Numero Cuenta", "Fecha Contrato", "Saldo", "DNI", "Nombre", "Telefono","Fecha_nacimiento")AS
SELECT c.numcuenta, c.fecha_contrato, c.saldo, cli.dni, cli.nombre, cli.telefono, cli.fecha_nacimiento 
FROM cuenta_objtab c, cliente_objtab cli
WHERE c.tipocuenta IN (
SELECT ref(t) FROM TipoCuenta_objtab t WHERE t.tipo = 'JOVEN');

/
CREATE OR REPLACE VIEW Administradores("DNI", "Nombre", "Telefono", "Extension", "Turno") AS
SELECT e.dni, e.nombre, e.telefono, e.extension, e.turno 
FROM Empleado_objtab e
WHERE e.tipo IN (SELECT ref(t) FROM TipoEmpleado_objtab t WHERE t.tipo = 'ADMINISTRADOR');
/
CREATE VIEW Cuenta AS ( SELECT * FROM Cuenta_objtab );
/

/**DISPARADORES**/
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
/


 
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
/


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

/
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
/

create or replace NONEDITIONABLE TRIGGER  insercionDeMovimientoTarjetaDebito 
after insert or update on tarjeta_objtab
declare
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

        if tipoT='DEBITO' THEN
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

                       UPDATE TABLE (SELECT Movimientos FROM tarjeta_objtab WHERE numTarjeta = i.numT and tipo='DEBITO')
          SET pasada = 'YES';
            end loop;
    end if;
end loop;
         DBMS_OUTPUT.PUT_LINE('Se han pasado los movimientos de la tarjeta de debito correctamente');

 end;
/






/**PROCEDIMIENTOS**/
/


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
/


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



/



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





 /**XML**/
 /
 begin
    dbms_xmlschema.registerschema(schemaurl=>'Operacion.xsd', 
    schemadoc=> '<?xml version="1.0" encoding="UTF-8"?> 
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="transferencia" type="TipoTransferencia">
    <xs:key name= "Num_transferencia">
        <xs:selector xpath= "xs:transferencia" />
        <xs:field xpath="xs:num_transferencia"/> 
    </xs:key>
</xs:element>
	
	<xs:complexType name="TipoTransferencia">
		<xs:sequence>
		 <xs:element name="empleado" type="TipoEmpleado" minOccurs="1" maxOccurs="unbounded"/>
	     <xs:element name="cuenta" type="TipoCuenta" minOccurs="0" maxOccurs="unbounded"/>
	     <xs:element name="cliente" type="TipoCliente" minOccurs="1" maxOccurs="unbounded"/>
	    </xs:sequence>
	</xs:complexType>
	
	<xs:complexType name="TipoEmpleado">
		<xs:sequence> <xs:element name="dni" type="xs:string" />
	        <xs:element name="nombre" type="xs:string" />
	        <xs:element name="telefono" type="xs:integer" />
	        <xs:element name="calle" type="xs:string" />
	        <xs:element name="email" type="xs:string" />
	        <xs:element name="numero" type="xs:string" />
	        <xs:element name="localidad" type="xs:string" />
	        <xs:element name="codigo_postal" type="xs:string" />
	        <xs:element name="numero_empleado" type="xs:string"/>
	        <xs:element name="extension" type="xs:integer"/>
	        <xs:element name="salario" type="xs:integer"/>
	        <xs:element name="turno" type="xs:string" nillable="true"/>
		</xs:sequence>
	    <xs:attribute name="tipo" use="required" type="xs:string"/>
	</xs:complexType>
	<xs:complexType name="TipoCuenta">
		<xs:sequence>
	        <xs:element name="numCuenta" type="xs:integer"/>
	        <xs:element name="saldo" type="xs:integer"/>
	        <xs:element name="fecha_contrato" type="xs:date"/>
	        <xs:element name="tipoCuenta" type="xs:string"/>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="TipoCliente">
		<xs:sequence>
	       <xs:element name="dni" type="xs:string" />
	        <xs:element name="nombre" type="xs:string" />
	        <xs:element name="telefono" type="xs:integer" />
	        <xs:element name="calle" type="xs:string" />
	        <xs:element name="email" type="xs:string" />
	        <xs:element name="numero" type="xs:string" />
	        <xs:element name="localidad" type="xs:string" />
	        <xs:element name="codigo_postal" type="xs:string" />
	        <xs:element name="numero_cliente" type="xs:integer"/>
		</xs:sequence>
	</xs:complexType>

</xs:schema>',
local=> true, gentypes => false, genbean=> false, gentables=> false, force => false, 
options => dbms_xmlschema.register_binaryxml, owner=> user);

commit;

end;
/

CREATE TABLE Operacion (ID NUMBER, DATOS XMLTYPE)
XMLTYPE COLUMN DATOS STORE AS BINARY XML
XMLSCHEMA "Operacion.xsd" ELEMENT "transferencia";

/


INSERT INTO Operacion VALUES (1,
'<?xml version="1.0" encoding="UTF-8"?>
<transferencia>
	<empleado tipo="administrador">
		<dni>7647477L</dni>

		<nombre>Pedro</nombre>
		<telefono>666666666</telefono>
		<calle>Av.España</calle>
		<email>admin1@gmail.com</email>
		<numero>2</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_empleado>1</numero_empleado>
		<extension>552</extension>
		<salario>2100</salario>
		<turno>tarde</turno>
	</empleado>
	<empleado tipo="recursoshumanos">
		<dni>555454F</dni>

		<nombre>Ana</nombre>
		<telefono>777777777</telefono>
		<calle>Av.Madrid</calle>
		<email>rh1@gmail.com</email>
		<numero>2</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_empleado>2</numero_empleado>
		<extension>772</extension>
		<salario>1890</salario>
		<turno>tarde</turno>
	</empleado>
	<cuenta>
		<numCuenta>25254858</numCuenta>
		<saldo >32525241</saldo >
		<fecha_contrato>2020-02-01</fecha_contrato>
		<tipoCuenta>Joven</tipoCuenta>
	</cuenta>
	<cuenta>
		<numCuenta>85854854</numCuenta>
		<saldo >2546982</saldo >
		<fecha_contrato>2019-05-02</fecha_contrato>
		<tipoCuenta>Joven</tipoCuenta>
	</cuenta>
	<cliente >
		<dni>888888S</dni>
		<nombre>Maria</nombre>
		<telefono>858548548</telefono>
		<calle>Calle Hellin</calle>
		<email>maria@gmail.com</email>
		<numero>2</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_cliente>2858</numero_cliente>
	</cliente>
	<cliente >
		<dni>85474525T</dni>
		<nombre>Lucia</nombre>
		<telefono>858585658</telefono>
		<calle>Calle Quijote</calle>
		<email>lucia@gmail.com</email>
		<numero>8</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_cliente>2852</numero_cliente>
	</cliente>
	<cliente >
		<dni>43323523D</dni>
		<nombre>Tomás</nombre>
		<telefono>666588555</telefono>
		<calle>Av.España</calle>
		<email>tomas@gmail.com</email>
		<numero>82</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_cliente>14585</numero_cliente>
	</cliente>
</transferencia>');
/


INSERT INTO Operacion VALUES (2,
'<?xml version="1.0" encoding="UTF-8"?>
<transferencia>
	<empleado tipo="administrador">
		<dni>85858582G</dni>

		<nombre>Juan</nombre>
		<telefono>96857452</telefono>
		<calle>Calle Lanza</calle>
		<email>admin2@gmail.com</email>
		<numero>2</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_empleado>3</numero_empleado>
		<extension>559</extension>
		<salario>2125</salario>
		<turno>mañana</turno>
	</empleado>
	<empleado tipo="recursoshumanos">
		<dni>11122233Y</dni>

		<nombre>Elena</nombre>
		<telefono>965854253</telefono>
		<calle>Calle Literatura</calle>
		<email>rh2@gmail.com</email>
		<numero>2</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_empleado>2</numero_empleado>
		<extension>778</extension>
		<salario>1870</salario>
		<turno>mañana</turno>
	</empleado>
	<cuenta>
		<numCuenta>8574585</numCuenta>
		<saldo >9630000</saldo >
		<fecha_contrato>2021-02-01</fecha_contrato>
		<tipoCuenta>Adulto</tipoCuenta>
	</cuenta>
	<cuenta>
		<numCuenta>22266633</numCuenta>
		<saldo >12054</saldo >
		<fecha_contrato>2020-05-02</fecha_contrato>
		<tipoCuenta>Joven</tipoCuenta>
	</cuenta>
	<cliente >
		<dni>1234567D</dni>
		<nombre>Rocio</nombre>
		<telefono>968547231</telefono>
		<calle>Calle Mancha</calle>
		<email>rocio@gmail.com</email>
		<numero>2</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_cliente>8765</numero_cliente>
	</cliente>
	<cliente >
		<dni>6321457L</dni>
		<nombre>Carmen</nombre>
		<telefono>654321987</telefono>
		<calle>Calle Zarza</calle>
		<email>carmen@gmail.com</email>
		<numero>8</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_cliente>9876</numero_cliente>
	</cliente>
	
</transferencia>');



/**CONSULTAS XPATH**/

/

CREATE VIEW NombreEmpleado AS
SELECT extract(datos,'//empleado/nombre')
FROM Operacion
WHERE id = 1;
/

CREATE VIEW numerosCuenta AS
SELECT extract(datos,'/transferencia/cuenta/numCuenta')
FROM Operacion
WHERE id = 1;
/

CREATE VIEW Administrador AS
SELECT o.datos.extract('/transferencia/empleado[@tipo="administrador"]/dni/text()')
FROM Operacion o
WHERE o.id = 1;

/

CREATE VIEW Cliente_1234567D AS
SELECT EXTRACT(datos, '//cliente [dni = "1234567D"]/sss/text()') AS Operacion
FROM operacion
WHERE ID = 2;
/

CREATE VIEW Cuenta_Saldo_Mayor_100 AS
SELECT EXTRACT(datos, '//cuenta [saldo > 100]/numCuenta') AS PROYECTO
FROM operacion
WHERE ID = 2;



/**CONSULTAS XQUERY**/
/

CREATE VIEW SaldoMayorA AS
SELECT ptab.column_value
FROM operacion p, xmltable ( 'for $i in //cuenta
where $i//saldo > 9620000
return $i//numCuenta'
PASSING p.datos) ptab;
/

CREATE VIEW TOTAL_Saldo AS
SELECT XMLQUERY('for $i in //cuenta
let $don := $i//saldo
let $sum := sum($don)
return $sum'
PASSING datos RETURNING CONTENT) AS TOTAL_Saldo
FROM operacion
WHERE ID = 2;

/**ACTUALIZACIÓN DEL FICHERO**/
/

UPDATE Operacion
SET datos = APPENDCHILDXML(datos, '/empleado',
xmltype(
'<empleado>
        <dni>11122233Y</dni>
		<nombre>Elena</nombre>
		<telefono>622555222</telefono>
		<calle>Calle Literatura</calle>
		<email>rh2@gmail.com</email>
		<numero>2</numero>
		<localidad>Albacete</localidad>
		<codigo_postal>02006</codigo_postal>
		<numero_empleado>2</numero_empleado>
		<extension>778</extension>
		<salario>2050</salario>
		<turno>mañana</turno>
</empleado>'
)
)
WHERE ID = 2;
/


UPDATE Operacion
SET datos = UPDATEXML(datos,'/transferencia/empleado[dni="85858582G"][2]/salario/text()', 2090)
WHERE ID = 2;
/

UPDATE Operacion
SET datos = DELETEXML(datos, '/transferencia/empleado[dni="85858582G"][2]')
WHERE ID = 2;