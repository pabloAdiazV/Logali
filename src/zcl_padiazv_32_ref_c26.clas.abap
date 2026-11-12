CLASS zcl_padiazv_32_ref_c26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_padiazv_32_ref_c26 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*
*    TYPES: BEGIN OF configuracion,
*             parametro TYPE string,
*             valor TYPE string,
*           END OF configuracion.
*
*    DATA configuraciones TYPE STANDARD TABLE OF configuracion WITH EMPTY KEY.
*
*    configuraciones = VALUE #(
*      ( parametro = 'max_usuarios' valor = '100' )
*      ( parametro = 'timeout' valor = '30' )
*      ( parametro = 'modo_debug' valor = 'ON' ) ).
*
*    out->write( 'CONFIGURACIÓN INICIAL' ).
*
*    out->write( configuraciones ).
*
*
*
*    "REF devuelve una referencia a la fila existente; no copia sus componentes.
*    DATA(configuracion_referencia) = REF #( configuraciones[ 2 ] ).
*
*    out->write( |Parámetro: { configuracion_referencia->parametro }| ).
*    out->write( |Valor: { configuracion_referencia->valor }| ).
*
*    configuracion_referencia->valor = '60'.
*
*    out->write( 'TABLA TRAS MODIFICAR LA REFERENCIA' ).
*    out->write( configuraciones ).
*
*
*
*
*    "NEW crea un dato independiente inicializado con los valores de esa fila.
*    DATA(configuracion_copia) = NEW configuracion( configuraciones[ 2 ] ).
*
*    configuracion_copia->valor = '90'.
*
*    out->write( |Timeout original: { configuraciones[ 2 ]-valor }| ).
*    out->write( |Timeout del dato nuevo: { configuracion_copia->valor }| ).
*
*    "OPTIONAL devuelve una referencia inicial si no existe la fila indicada.
*    DATA(referencia_ausente) = REF configuracion( configuraciones[ 99 ] OPTIONAL ).
*
*    IF referencia_ausente IS BOUND.
*      out->write( referencia_ausente->valor ).
*    ELSE.
*      out->write( 'No existe la fila 99; no se desreferencia.' ).
*    ENDIF.


*    DATA precio TYPE p LENGTH 10 DECIMALS 2 VALUE '100.00'.
*    DATA iva TYPE p LENGTH 5 DECIMALS 2 VALUE '0.21'.
*
*    "CONV especifica el tipo del resultado de esta conversión.
*
*    DATA(mensaje) = |Precio final: { CONV string( precio * ( 1 + iva ) ) } EUR|.
*    out->write( mensaje ).
*
*    out->write( |Presentación: { precio * ( 1 + iva ) DECIMALS = 2 NUMBER = RAW } EUR| ).
*
*
*    DATA numeros_ordenados TYPE SORTED TABLE OF i WITH NON-UNIQUE KEY table_line.
*
*    numeros_ordenados = VALUE #( ( 3 ) ( 1 ) ( 4 ) ( 1 ) ( 5 ) ).
*
*    TYPES numeros_estandar TYPE STANDARD TABLE OF i WITH EMPTY KEY.
*
*    "Cambiar la clase de tabla no reconstruye el orden anterior a la inserción en SORTED.
*    DATA(numeros_convertidos) = CONV numeros_estandar( numeros_ordenados ).
*    out->write( 'SORTED A STANDARD' ).
*    out->write( numeros_convertidos ).
*
*    "CONV puede fallar si el contenido no se puede convertir al tipo solicitado.
*    DATA texto_invalido TYPE string VALUE '12X'.
*    DATA numero TYPE i.
*
*    TRY.
*        numero = CONV i( texto_invalido ).
*        out->write( numero ).
*      CATCH cx_sy_conversion_no_number.
*        out->write( '12X no representa un entero válido.' ).
*    ENDTRY.


    TYPES importe TYPE p LENGTH 10 DECIMALS 2.

    TYPES: BEGIN OF producto,
             codigo    TYPE string,
             nombre    TYPE string,
             precio    TYPE importe,
             stock     TYPE i,
             en_oferta TYPE abap_bool,
           END OF producto.

    "La clave SORTED permite filtrar por en_oferta y por un rango de stock.
    DATA inventario TYPE SORTED TABLE OF producto WITH NON-UNIQUE KEY en_oferta stock.

    inventario = VALUE #(
      ( codigo = 'LAP001' nombre = 'Laptop HP' precio = 800 stock = 3 en_oferta = abap_true )
      ( codigo = 'MOU001' nombre = 'Mouse Logitech' precio = 25 stock = 50 en_oferta = abap_true )
      ( codigo = 'TEC001' nombre = 'Teclado Mecánico' precio = 120 stock = 15 en_oferta = abap_true )
      ( codigo = 'MON001' nombre = 'Monitor Samsung' precio = 300 stock = 8 en_oferta = abap_false )
      ( codigo = 'WEB001' nombre = 'Webcam HD' precio = 60 stock = 2 en_oferta = abap_true )
      ( codigo = 'AUR001' nombre = 'Auriculares' precio = 45 stock = 20 en_oferta = abap_false )
      ( codigo = 'IMP001' nombre = 'Impresora' precio = 200 stock = 12 en_oferta = abap_true ) ).

    out->write( |INVENTARIO: { lines( inventario ) } productos| ).

    LOOP AT inventario INTO DATA(producto_inventario).

      DATA(oferta_texto) = COND string( WHEN producto_inventario-en_oferta = abap_true
                                       THEN 'EN OFERTA' ELSE '' ).
      out->write( |{ producto_inventario-codigo } - { producto_inventario-nombre }: | &&
                  |{ producto_inventario-precio } EUR; stock { producto_inventario-stock } { oferta_texto }| ).
    ENDLOOP.

    "El tipo de resultado se infiere de inventario; se mantiene una tabla SORTED.
    DATA(productos_promocion) = FILTER #( inventario
                                          WHERE en_oferta = abap_true AND stock > 5 ).

    out->write( |PROMOCIÓN: { lines( productos_promocion ) } productos| ).

    IF productos_promocion IS NOT INITIAL.

      LOOP AT productos_promocion INTO DATA(producto_promocion).
        out->write( |{ producto_promocion-nombre } - { producto_promocion-precio } EUR | &&
                    |(stock { producto_promocion-stock })| ).
      ENDLOOP.

    ELSE.
      out->write( 'No hay productos que cumplan los criterios.' ).
    ENDIF.

    "El acumulador decimal conserva los céntimos de precio por cantidad.
    DATA(valor_total) = REDUCE importe(
      INIT total = CONV importe( 0 )
      FOR producto_actual IN productos_promocion
      NEXT total = total + producto_actual-precio * producto_actual-stock ).
    out->write( |Valor total: { valor_total } EUR| ).
    out->write( |Inventario original: { lines( inventario ) } productos| ).

  ENDMETHOD.

ENDCLASS.
