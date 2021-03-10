/**BANCO**/
CREATE TYPE Banco_objtyp AS OBJECT(
	cif char(10),
	nombre varchar(10)
);
CREATE TABLE Banco_objtab OF Banco_objtyp (
	cif PRIMARY KEY,
	check (nombre is not null)
	);

/**USUARIO**/

CREATE TYPE Usuario_objtyp AS OBJECT(
	dni varchar(9),
	nombre char(30),
	telefono number(9),
	fecha_nacimiento date,
	calle varchar(20),
	numero number,
	localidad char(20),
	codigo_postal number(5)
)NOT FINAL;

CREATE TABLE Usuario_objtab OF Usuario_objtyp (
	dni PRIMARY KEY,
	check( nombre is not null),
	check( telefono is not null),
	check( fecha_nacimiento is not null),
	check( calle is not null),
	check( numero is not null),
	check( localidad is not null),
	check( codigo_postal is not null)
);

CREATE TYPE Usuarios_ntabtyp
AS TABLE OF REF Usuario_objtyp;


/**SUCURSAL**/

CREATE TYPE Sucursal_objtyp AS OBJECT(
	localidad varchar(20),
	id char(10),
	telefono number(9),
	calle varchar(20),
	numero number,
	codigo_postal number(5),
	Usuarios Usuarios_ntabtyp
);


CREATE TABLE Sucursal_objtab OF Sucursal_objtyp (
	localidad PRIMARY KEY,
	check( id is not null),
	check( telefono is not null),
	check( calle is not null),
	check( numero is not null),
	check( codigo_postal is not null))

NESTED TABLE Usuarios STORE AS Usuarios_ntab;


/**GERENTE**/

CREATE TYPE Gerente_objtyp UNDER Usuario_objtyp(
	numero_gerente varchar(10),
	salario number(6,6),
	turno varchar(10),
	extension number	
);
CREATE TABLE Gerente_objtab OF Gerente_objtyp(
	numero_gerente PRIMARY KEY,
	check(salario is not null),
	check (UPPER(turno) in ('MAÑANA','TARDE')),
	check(extension is not null));


/**TIPO EMPLEADO**/

CREATE TYPE TipoEmpleado_objtyp AS OBJECT(
	tipo char(15)
);
CREATE TABLE TipoEmpleado_objtab OF TipoEmpleado_objtyp(
	tipo PRIMARY KEY,
	check (UPPER(tipo) in ('ADMINISTRADOR','CAJERO','CONTABLE'))
);

/**EMPLEADO**/

CREATE TYPE Empleado_objtyp UNDER Usuario_objtyp(
	numero_empleado varchar(10),
	extension number,
	salario number(6,6),
	turno varchar,
	tipo REF TipoEmpleado_objtyp
);
CREATE TABLE Empleado_objtab OF Empleado_objtyp(
	numero_empleado PRIMARY KEY,
	check(extension is not null),
	check(salario is not null),
	check(salario > 0),
	check (UPPER(turno) in ('MAÑANA','TARDE')),
    SCOPE FOR(tipo) IS TipoEmpleado_objtab
);

/**TIPO CUENTO**/

CREATE TYPE TipoCuenta_objtyp AS OBJECT(
	tipo varchar(20),
	interes number(6,6),
	comision number(6,6)	
);

CREATE TABLE TipoCuenta_objtab OF TipoCuenta_objtyp(
	tipo PRIMARY KEY,
	check (UPPER(tipo) in ('JOVEN','ADULTO','PENSIONISTA')),
	check(interes is not null),
	check(comision is not null)
);

/**MOVIMIENTO**/

CREATE TYPE Movimiento_objtyp AS OBJECT(
	numero_mov varchar(20),
	fecha_hora date,
	concepto varchar(50),
	cargo number(10),
	saldo number(6,6)
);

CREATE TABLE Movimiento_objtab OF Movimiento_objtyp(
	numero_mov PRIMARY KEY,
	check(fecha_hora is not null),
	check(concepto is not null),
	check(cargo is not null),
	check(cargo > 0),
	check(saldo is not null)
);

CREATE TYPE Movimiento_ntabtyp AS TABLE OF REF Movimiento_objtyp;


/**CLIENTE**/

CREATE TYPE Cliente_objtyp UNDER Usuario_objtyp(
	numero_cliente varchar(10)
);
CREATE TABLE Cliente_objtab OF Cliente_objtyp(
	numero_cliente PRIMARY KEY
);


/**CUENTA**/

CREATE TYPE Cuenta_objtyp AS OBJECT (
	numCuenta number(20),
	fecha_Contrato date,
	saldo number(6,6),
	tipocuenta REF TipoCuenta_objtyp,
	movimientos Movimiento_ntabtyp,
	cliente REF Cliente_objtyp
	
);

CREATE TABLE Cuenta_objtab OF Cuenta_objtyp(
	numCuenta PRIMARY KEY,
	check(fecha_Contrato is not null),
	check(saldo is not null),
    SCOPE FOR(tipocuenta) IS TipoCuenta_objtab,
	SCOPE FOR(cliente) IS Cliente_objtab)
	NESTED TABLE movimientos STORE AS Movimiento_ntab;


CREATE TYPE Cuenta_ntabtyp AS TABLE OF REF Cuenta_objtyp;


/**OPERACION**/

CREATE TYPE Operacion_objtyp AS OBJECT(
	id number(10),
	fecha date,
	estado varchar(20),
	saldo_op number(6,6)
)NOT FINAL;

CREATE TABLE Operacion_objtab OF Operacion_objtyp(
	id PRIMARY KEY,
	check(fecha is not null),
	check(estado is not null),
	check (UPPER(estado) in ('NO INICIADA','EN TRANSITO','FINALIZADA')),
	check(saldo_op is not null)

);


/**INVERSION**/

CREATE TYPE Inversion_objtyp UNDER Operacion_objtyp(
	nombre_fondo varchar(20),
	riesgo varchar(20),
	categoria varchar(20),
	gerente REF Gerente_objtyp
);
CREATE TABLE Inversion_objtab OF Inversion_objtyp(
	nombre_fondo PRIMARY KEY,
	check(riesgo is not null),
	check(categoria is not null),
	SCOPE FOR(gerente) IS Gerente_objtab

);


/**PRESTAMO**/

CREATE TYPE Prestamo_objtyp UNDER Operacion_objtyp(
	finalidad varchar(40),
	plazo date,
	empleado REF Empleado_objtyp

);
CREATE TABLE Prestamo_objtab OF Prestamo_objtyp(
	check(finalidad is not null),
	check(plazo is not null),
	SCOPE FOR(empleado) IS Empleado_objtab
);

/**TRANSFERENCIA**/

CREATE TYPE Transferencia_objtyp UNDER Operacion_objtyp(
	tipo varchar(40),
	concepto varchar(50),
	beneficiario number(15)
);
CREATE TABLE Transferencia_objtab OF Transferencia_objtyp(
	check(tipo is not null),
	check(concepto is not null),
	check(beneficiario is not null)

);

/**MOVIMIENTO TARJETA**/

CREATE TYPE MovimientoTarjeta_objtyp AS OBJECT(
	numero_movt varchar(20),
	fecha_hora date,
	concepto varchar(50),
	cargo number(10),
	mensualidad number(6,6)
);
CREATE TYPE MovimientoTarjeta_ntabtyp AS TABLE OF REF Movimiento_objtyp;

CREATE TABLE MovimientoTarjeta_objtab AS OF MovimientoTarjeta_objtyp(
	numero_movt PRIMARY KEY,
	check(fecha_hora is not null),
	check(concepto is not null),
	check(cargo is not null),
	check(mensualidad is not null)

);

/**TARJETA**/

CREATE TYPE Tarjeta_objtyp AS OBJECT(
	numTarjeta number(20),
	fecha_Caducidad date,
	CVV number(3),
	tipo varchar(20),
	cuenta REF Cuenta_objtyp,
	movimientos MovimientoTarjeta_ntabtyp
);

CREATE TABLE Tarjeta_objtab  OF Tarjeta_objtyp(
	numTarjeta PRIMARY KEY,
	check(fecha_Caducidad is not null),
	check(CVV is not null),
	check(tipo is not null),
	check (UPPER(tipo) in ('CREDITO','DEBITO')),
	SCOPE FOR(cuenta) IS Cuenta_objtab)
	NESTED TABLE movimientos STORE AS MovimientoTarjeta_ntab;

