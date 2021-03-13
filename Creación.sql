/** Tipo BANCO**/
CREATE TYPE Banco_objtyp AS OBJECT(
	cif char(10),
	nombre varchar(10),
	map member function get_CIF return CHAR,
	member procedure print,
	member function ordenar (v_banco in Banco_objtyp) return integer
);

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

/**Tabla BANCO**/
CREATE TABLE Banco_objtab OF Banco_objtyp (
	cif PRIMARY KEY,
	check (nombre is not null),
	nombre unique
);

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
) NOT FINAL;


/**Tabla anidada para Sucursal **/
CREATE TYPE Usuarios_ntabtyp AS TABLE OF REF Usuario_objtyp;

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


/**Tabla USUARIO**/
CREATE TABLE Usuario_objtab OF Usuario_objtyp (
	dni PRIMARY KEY,
	check(nombre is not null),
	check(telefono is not null),
	telefono unique,
	check(fecha_nacimiento is not null),
	check(calle is not null),
	check(numero is not null),
	check(localidad is not null),
	check(codigo_postal is not null)
);



/**Tipo SUCURSAL**/
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


/**Tipo GERENTE**/
CREATE TYPE Gerente_objtyp UNDER Usuario_objtyp(
	numero_gerente varchar(10),
	salario number(12, 2),
	turno varchar(10),
	extension number,
	overriding member procedure print
	
);

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


/**Tipo TIPOEMPLEADO**/
CREATE TYPE TipoEmpleado_objtyp AS OBJECT(tipo char(15));

/**Tabla TIPOEMPLEADO**/
CREATE TABLE TipoEmpleado_objtab OF TipoEmpleado_objtyp(
	tipo PRIMARY KEY,
	check (
		UPPER(tipo) in ('ADMINISTRADOR', 'CAJERO', 'CONTABLE')
	)
);


/**Tipo EMPLEADO**/
CREATE TYPE Empleado_objtyp UNDER Usuario_objtyp(
	numero_empleado varchar(10),
	extension number,
	salario number(12, 2),
	turno varchar(20),
	tipo REF TipoEmpleado_objtyp,
	overriding member procedure print

);

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


/**Tipo TIPOCUENTA**/
CREATE TYPE TipoCuenta_objtyp AS OBJECT(
	tipo varchar(20),
	interes number(12, 2),
	comision number(12, 2)

);

/**Tabla TIPOCUENTA**/
CREATE TABLE TipoCuenta_objtab OF TipoCuenta_objtyp(
	tipo PRIMARY KEY,
	check (UPPER(tipo) in ('JOVEN', 'ADULTO', 'PENSIONISTA')),
	check(interes is not null),
	check(interes > 0),
	check(comision is not null),
	check(comision > 0)
);




/**Tipo CLIENTE**/
CREATE TYPE Cliente_objtyp UNDER Usuario_objtyp(numero_cliente varchar(10));

/**Tabla CLIENTE**/
CREATE TABLE Cliente_objtab OF Cliente_objtyp(
	dni PRIMARY KEY,
	numero_cliente unique,
	check(numero_cliente is not null)
);



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

/**Tabla OPERACION**/
CREATE TABLE Operacion_objtab OF Operacion_objtyp(
	id PRIMARY KEY,
	check(fecha is not null),
	check(estado is not null),
	check (
		UPPER(estado) in ('NO INICIADA', 'EN TRANSITO', 'FINALIZADA')
	),
	check(saldo_op is not null),
	check(saldo_op > 0)
);


/**Tipo INVERSION**/
CREATE TYPE Inversion_objtyp UNDER Operacion_objtyp(
	nombre_fondo varchar(20),
	riesgo varchar(20),
	categoria varchar(20),
	gerente REF Gerente_objtyp,
	overriding member procedure print
);
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

/**Tabla INVERSION**/
CREATE TABLE Inversion_objtab OF Inversion_objtyp(
	id PRIMARY KEY,
	check(nombre_fondo is not null),
	check(riesgo is not null),
	check(categoria is not null),
	SCOPE FOR(gerente) IS Gerente_objtab
);


/**Tipo PRESTAMO**/
CREATE TYPE Prestamo_objtyp UNDER Operacion_objtyp(
	finalidad varchar(40),
	plazo date,
	empleado REF Empleado_objtyp,
	overriding member procedure print
);

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

/**Tabla PRESTAMO**/
CREATE TABLE Prestamo_objtab OF Prestamo_objtyp(
	id PRIMARY KEY,
	check(finalidad is not null),
	check(plazo is not null),
	SCOPE FOR(empleado) IS Empleado_objtab
);


/**Tipo TRANSFERENCIA**/
CREATE TYPE Transferencia_objtyp UNDER Operacion_objtyp(
	tipo varchar(40),
	concepto varchar(50),
	beneficiario number(15),
	overriding member procedure print

);

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

/**Tabla TRANSFERENCIA**/
CREATE TABLE Transferencia_objtab OF Transferencia_objtyp(
	id PRIMARY KEY,
	check(tipo is not null),
	check (UPPER(tipo) in ('EXTERIOR', 'NACIONAL')),
	check(concepto is not null),
	check(beneficiario is not null)
);


/**Tipo MOVIMIENTO TARJETA**/
CREATE TYPE MovimientoTarjeta_objtyp AS OBJECT(
	numero_movt varchar(20),
	fecha_hora timestamp,
	concepto varchar(50),
	cargo number(10),
	mensualidad number(12, 2),
	map member function get_numero_movt return CHAR,
	member procedure print,
	member function ordenar (v_movimientoT in MovimientoTarjeta_objtyp) return integer
);

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

/**Tabla MOVIMIENTOTARJETA**/
CREATE TABLE MovimientoTarjeta_objtab OF MovimientoTarjeta_objtyp(
	numero_movt PRIMARY KEY,
	check(fecha_hora is not null),
	check(concepto is not null),
	check(cargo is not null),
	check(cargo > 0),
	check(mensualidad is not null)
	
);


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

/**Tabla anidada para TARJETA**/
CREATE TYPE MovimientoTarjeta_ntabtyp AS TABLE OF REF Movimiento_objtyp;
/**Tabla anidada para CUENTA**/
CREATE TYPE Movimiento_ntabtyp AS TABLE OF REF Movimiento_objtyp;

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

/**Tabla MOVIMIENTO**/
CREATE TABLE Movimiento_objtab OF Movimiento_objtyp(
	numero_mov PRIMARY KEY,
	check(fecha_hora is not null),
	check(concepto is not null),
	check(cargo is not null),
	check(cargo > 0),
	check(saldo is not null),
	check(saldo > 0),
	SCOPE FOR(tipo_trans) IS Transferencia_objtab,
	SCOPE FOR(tipo_pres1) IS Prestamo_objtab,
	SCOPE FOR(tipo_pres2) IS Prestamo_objtab,
	SCOPE FOR(tipo_inv) IS Inversion_objtab
);


/**Tipo CUENTA**/
CREATE TYPE Cuenta_objtyp AS OBJECT (
	numCuenta number(20),
	fecha_Contrato date,
	saldo number(12,2),
	tipocuenta REF TipoCuenta_objtyp,
	movimientos Movimiento_ntabtyp,
	cliente REF Cliente_objtyp,
	map member function get_numCuenta return CHAR,
	member procedure print,
	member function ordenar (v_cuenta in Cuenta_objtyp) return integer

);

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

/**Tabla CUENTA**/
CREATE TABLE Cuenta_objtab OF Cuenta_objtyp(
	numCuenta PRIMARY KEY,
	check(fecha_Contrato is not null),
	check(saldo is not null),
	check(saldo > 0),
	SCOPE FOR(tipocuenta) IS TipoCuenta_objtab,
	SCOPE FOR(cliente) IS Cliente_objtab
) NESTED TABLE movimientos STORE AS Movimiento_ntab;



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

/**Tabla TARJETA**/
CREATE TABLE Tarjeta_objtab OF Tarjeta_objtyp(
	numTarjeta PRIMARY KEY,
	check(fecha_Caducidad is not null),
	check(CVV is not null),
	check(tipo is not null),
	check (UPPER(tipo) in ('CREDITO', 'DEBITO')),
	SCOPE FOR(cuenta) IS Cuenta_objtab
) NESTED TABLE movimientos STORE AS MovimientoTarjeta_ntab;






/**SIN PONER**/

/**Tabla anidada para**/
CREATE TYPE Cuenta_ntabtyp AS TABLE OF REF Cuenta_objtyp;