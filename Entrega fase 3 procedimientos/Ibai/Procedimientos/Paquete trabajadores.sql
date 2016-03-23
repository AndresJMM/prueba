CREATE OR REPLACE PACKAGE PAC_TRABAJADOR IS
  TYPE G_CURSOR IS REF CURSOR;
  PROCEDURE get_trabajador(i_dniTrab IN TRABAJADOR.DNI%TYPE, o_cursor OUT G_CURSOR);
  PROCEDURE get_trabajadores_centro(i_idCen IN CENTRO.IDCENTRO%TYPE, o_cursor OUT G_CURSOR);
  PROCEDURE get_tipos_centro(i_idCen IN CENTRO.IDCENTRO%TYPE, i_tipo IN TIPOTRABAJADOR.TIPO%TYPE, o_cursor OUT G_CURSOR);
END PAC_TRABAJADOR;

CREATE OR REPLACE PACKAGE BODY PAC_TRABAJADOR IS
  
  PROCEDURE get_trabajador(
    i_dniTrab IN TRABAJADOR.DNI%TYPE, o_cursor OUT G_CURSOR
  )AS
  BEGIN
    OPEN o_cursor for
      SELECT IDTRABAJADOR, IDCENTRO, DNI, NOMBRE, APE1, APE2, FECHANAC, 
             SALARIO, MOVILEMP, TLFPERSONAL, CALLE, PORTAL, PISO, MANO, 
             (SELECT TIPO FROM TIPOTRABAJADOR WHERE IDTIPO = T.IDTIPO) TIPO
      FROM TRABAJADOR T
      WHERE DNI = i_dniTrab;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20105, 'NO SE ENCONTRÓ EL TRABAJADOR');
  END;
  
  PROCEDURE get_trabajadores_centro(
    i_idCen IN CENTRO.IDCENTRO%TYPE, o_cursor OUT G_CURSOR
  )AS
  BEGIN
    OPEN o_cursor for
      SELECT IDTRABAJADOR
      FROM TRABAJADOR
      WHERE IDCENTRO = i_idCen;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20105, 'NO SE ENCONTRARON TRABAJADORES DE ESE CENTRO');
  END;
  
  PROCEDURE get_tipos_centro(
    i_idCen IN CENTRO.IDCENTRO%TYPE, i_tipo IN TIPOTRABAJADOR.TIPO%TYPE, o_cursor OUT G_CURSOR
  )AS
  BEGIN
    OPEN o_cursor for
      SELECT IDTRABAJADOR
      FROM TRABAJADOR
      WHERE IDCENTRO = i_idCen
      AND IDTIPO = (SELECT IDTIPO FROM TIPOTRABAJADOR WHERE UPPER(TIPO) LIKE UPPER(i_tipo));
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20105, 'NO SE ENCONTRÓ EL TRABAJADOR');
  END;
  
END PAC_TRABAJADOR;