create or replace TYPE BODY movimientos_objtyp AS
order member function ordenar (v_usuario in Usuario_objtyp)
return integer is
BEGIN
if v_usuario.idUsuario < self.idUsuario then
DBMS_OUTPUT.PUT_LINE('ID mayor.');
return 1;
else
DBMS_OUTPUT.PUT_LINE('ID menor.');
return 0;
end if;
END;
end;

create or replace type body Operacion_objtyp as
    member procedure cambiarEstado (estadoSolicitud in varchar2) is
    BEGIN
        update Operacion_objtab
        set estado = estadoSolicitud
        where id = self.id;
        DBMS_OUTPUT.PUT_LINE('Estado de la solicitud actualizado.');
END;
    order member function ordenar (v_solicitud in Solicitud_objtyp)
    return integer is
    BEGIN
        if v_solicitud.idSolicitud < self.idSolicitud then
            DBMS_OUTPUT.PUT_LINE('ID mayor.');
            return 1;
        else
            DBMS_OUTPUT.PUT_LINE('ID menor.');
            return 0;
        end if;
    END;
END;

CREATE OR REPLACE TYPE BODY Telefono_objtyp AS
MEMBER PROCEDURE Print IS
    BEGIN
    DBMS_OUTPUT.PUT ('Prefijo: '|| prefijo);
    DBMS_OUTPUT.PUT ('Teléfono: '|| telefono);
    DBMS_OUTPUT.NEW_LINE;
    END Print;
MEMBER PROCEDURE CambiarTelefono (p_telefono IN VARCHAR2) IS
    BEGIN
    SELF.telefono := p_telefono;
    END CambiarTelefono;
END;

CREATE OR REPLACE TYPE BODY Ejemplar_objtyp AS
MAP MEMBER FUNCTION Get_NumeroRegistro RETURN NUMBER IS
    BEGIN
    RETURN SELF.num_registro;
    END Get_NumeroRegistro;
MEMBER PROCEDURE Print IS
    BEGIN
    DBMS_OUTPUT.PUT ('Ejemplar: '||num_registro);
    DBMS_OUTPUT.PUT ('Edicion: '||edicion);
    DBMS_OUTPUT.PUT ('Fecha : '|| fecha_edicion);
    DBMS_OUTPUT.PUT ('Estado (0- DISPONIBLE, 1- OCUPADO):'||estado);
    DBMS_OUTPUT.NEW_LINE;
    END Print;
MEMBER PROCEDURE CambiarEstado(n_estado IN NUMBER) IS
    BEGIN
    SELF.estado := n_estado;
    END CambiarEstado;
END;


actualizar saldo

cambiar el interes



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