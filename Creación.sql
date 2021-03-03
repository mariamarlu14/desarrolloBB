CREATE TYPE Banco_objtyp AS OBJECT(
	cif char(10),
	nombre varchar(10)
);
CREATE TABLE Banco_objtab OF Banco_objtyp (cif PRIMARY KEY);

CREATE TYPE Sucursal_objtyp AS OBJECT(
	localidad varchar(20),
	id char(10),
	telefono number(9),
	calle varchar(20),
	numero number,
	codigo_postal number(5)
);
CREATE TABLE Sucursal_objtab OF Sucursal_objtyp (localidad PRIMARY KEY);

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
CREATE TABLE Usuario_objtab OF Usuario_objtyp (dni PRIMARY KEY);

CREATE TYPE Cliente_objtyp UNDER Usuario_objtyp(
	numero_cliente varchar(10)
);
CREATE TABLE Cliente_objtab OF Cliente_objtyp;

CREATE TYPE TipoEmpleado_objtyp AS OBJECT(
	tipo char(15)
);
CREATE TABLE TipoEmpleado_objtab (tipo PRIMARY KEY);

CREATE TYPE Empleado_objtyp UNDER Usuario_objtyp(
	numero_empleado varchar(10),
	extension number,
	salario double,
	turno varchar,
	tipo REF TipoEmpleado_objtyp
);
CREATE TABLE Empleado_objtab OF Empleado_objtyp;


CREATE TYPE Gerente_objtab UNDER Usuario_objtyp(
	numero_gerente varchar(10),
	salario double,
	turno varchar,
	extension number
);
CREATE TABLE Gerente_objtyp OF Gerente_objtyp;

CREATE TYPE Operacion_objtyp AS OBJECT(
	id number(10),
	fecha date,
	saldo_op double
);
CREATE TABLE Operacion_objtab OF Operacion_objtyp(id PRIMARY KEY);

CREATE TYPE Inversion_objtyp UNDER Operacion_objtyp(
	nombre_fondo varchar(20),
	riesgo varchar(20),
	categoria varchar(20),
	gerente REF Gerente_objtyp
);
CREATE TABLE Inversion_objtab OF Inversion_objtyp;

CREATE TYPE Prestamo_objtyp UNDER Operacion_objtyp(
	finalidad varchar(40),
	plazo date
);
CREATE TABLE Prestamo_objtab OF Prestamo_objtyp;

CREATE TYPE Transferencia_objtyp UNDER Operacion_objtyp(
	tipo varchar(40),
	concepto varchar(50),
	beneficiario number(15),
	empleado REF Empleado_objtyp
);
CREATE TABLE Transferencia_objtab OF Transferencia_objtyp;