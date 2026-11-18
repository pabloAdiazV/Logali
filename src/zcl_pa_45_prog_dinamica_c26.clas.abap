CLASS zcl_pa_45_prog_dinamica_c26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.
    METHODS ejemplo_1_assign_component IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_2_inline           IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_3_modificar_tabla  IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_4_campo_por_nombre IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_5_varios_campos    IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_7_reporte          IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_8_select_dinamico  IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_8b_tipo_dinamico   IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_8c_new_dinamico    IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS cliente_de_ejemplo RETURNING VALUE(customer) TYPE /dmo/customer.
    METHODS tabla_permitida
      IMPORTING table_name     TYPE string
      RETURNING VALUE(allowed) TYPE abap_bool.
ENDCLASS.

CLASS zcl_pa_45_prog_dinamica_c26 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    "Comenta las llamadas de los ejemplos que no quieras ejecutar.
    ejemplo_1_assign_component( out ).
*    ejemplo_2_inline( out ).
*    ejemplo_3_modificar_tabla( out ).
*    ejemplo_4_campo_por_nombre( out ).
*    ejemplo_5_varios_campos( out ).
*    ejemplo_7_reporte( out ).
*    ejemplo_8_select_dinamico( out ).
*    ejemplo_8b_tipo_dinamico( out ).
*    ejemplo_8c_new_dinamico( out ).
  ENDMETHOD.

  METHOD ejemplo_1_assign_component.
    out->write( |=== EJEMPLO 1: Field symbol y ASSIGN COMPONENT ===| ).
    DATA(carrier) = VALUE /dmo/carrier( carrier_id    = 'LG'
                                        name          = 'Logali Airlines'
                                        currency_code = 'EUR' ).
    out->write( |ANTES: { carrier-name }| ).


    ASSIGN carrier TO FIELD-SYMBOL(<carrier>).
    "El componente se indica con un texto: se busca al ejecutar.
    ASSIGN COMPONENT 'NAME' OF STRUCTURE <carrier> TO FIELD-SYMBOL(<name>).
    IF sy-subrc = 0.
      <name> = 'Logali Group Airlines'.     "Cambia el dato original
    ENDIF.
    UNASSIGN: <name>, <carrier>.
    out->write( |DESPUÉS: { carrier-name }| ).
  ENDMETHOD.

  METHOD ejemplo_2_inline.
    out->write( |=== EJEMPLO 2: Field symbol declarado inline ===| ).
    DATA(connection) = VALUE /dmo/connection( carrier_id      = 'AA'
                                              connection_id   = '0017'
                                              airport_from_id = 'JFK'
                                              airport_to_id   = 'SFO' ).
    out->write( |ANTES: de { connection-airport_from_id } a { connection-airport_to_id }| ).

    "Tipado completo: los componentes se escriben directamente.
    ASSIGN connection TO FIELD-SYMBOL(<connection>).
    <connection>-airport_from_id = 'LAX'.
    <connection>-airport_to_id   = 'ORD'.
    UNASSIGN <connection>.
    out->write( |DESPUÉS: de { connection-airport_from_id } a { connection-airport_to_id }| ).
  ENDMETHOD.

  METHOD ejemplo_3_modificar_tabla.
    out->write( |=== EJEMPLO 3: Modificación masiva ===| ).
    SELECT * FROM /dmo/flight
      WHERE carrier_id = 'AA'
      ORDER BY PRIMARY KEY
      INTO TABLE @DATA(flights)
      UP TO 5 ROWS.
    out->write( |Total vuelos: { lines( flights ) }| ).
    out->write( |--- PRECIOS ORIGINALES ---| ).
    LOOP AT flights INTO DATA(flight).
      out->write( |Vuelo { flight-connection_id }: { flight-price } { flight-currency_code }| ).
    ENDLOOP.

    "ASSIGNING modifica cada fila directamente: no hace falta MODIFY.
    LOOP AT flights ASSIGNING FIELD-SYMBOL(<flight>).
      <flight>-price = <flight>-price * '0.9'.
    ENDLOOP.
    UNASSIGN <flight>.

    out->write( |--- PRECIOS CON DESCUENTO ---| ).
    LOOP AT flights INTO flight.
      out->write( |Vuelo { flight-connection_id }: { flight-price } { flight-currency_code }| ).
    ENDLOOP.
  ENDMETHOD.

  METHOD ejemplo_4_campo_por_nombre.
    out->write( |=== EJEMPLO 4: ASSIGN dinámico por nombre de campo ===| ).
    DATA(customer) = cliente_de_ejemplo( ).
    "Tipo genérico: el campo concreto no se conoce hasta ejecutar.
    FIELD-SYMBOLS <value> TYPE data.

    "El nombre del campo viene de una variable: podría elegirlo el usuario.
    DATA(field_name) = `FIRST_NAME`.
    ASSIGN customer-(field_name) TO <value>.
    IF sy-subrc = 0.
      out->write( |Campo { field_name }: { <value> }| ).
      <value> = 'María'.
    ENDIF.
    out->write( |Nombre modificado: { customer-first_name }| ).

    "Un nombre que no existe no da error de sintaxis: lo indica sy-subrc al ejecutar.
    DATA(missing_field) = `NO_EXISTE`.
    ASSIGN customer-(missing_field) TO <value> ELSE UNASSIGN.
    IF sy-subrc <> 0.
      out->write( |El campo { missing_field } no existe: sy-subrc = { sy-subrc }| ).
    ENDIF.
  ENDMETHOD.

  METHOD ejemplo_5_varios_campos.
    out->write( |=== EJEMPLO 5: Varios campos dinámicos ===| ).
    DATA(customer) = cliente_de_ejemplo( ).
    DATA(field_names) = VALUE string_table( ( `FIRST_NAME` ) ( `LAST_NAME` ) ( `CITY` ) ).
    FIELD-SYMBOLS <value> TYPE data.

    LOOP AT field_names INTO DATA(field_name).
      ASSIGN customer-(field_name) TO <value>.
      IF sy-subrc = 0.
        out->write( |{ field_name }: { <value> }| ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ejemplo_7_reporte.
    out->write( |=== EJEMPLO 7: Reporte configurable ===| ).
    "Los campos que el usuario quiere ver.
    DATA(selected_fields) = VALUE string_table( ( `CARRIER_ID` ) ( `CONNECTION_ID` ) ( `PRICE` ) ).
    FIELD-SYMBOLS <value> TYPE data.

    SELECT * FROM /dmo/flight
      WHERE carrier_id = 'LH'
      ORDER BY PRIMARY KEY
      INTO TABLE @DATA(flights)
      UP TO 3 ROWS.

    LOOP AT flights ASSIGNING FIELD-SYMBOL(<flight>).
      out->write( |--- Registro { sy-tabix } ---| ).
      LOOP AT selected_fields INTO DATA(field_name).
        ASSIGN <flight>-(field_name) TO <value>.
        IF sy-subrc = 0.
          out->write( |  { field_name }: { <value> }| ).
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD ejemplo_8_select_dinamico.
    out->write( |=== EJEMPLO 8: SELECT dinámico ===| ).
    "El nombre de la tabla se decide al ejecutar.
    DATA(table_name) = `/DMO/CARRIER`.
    IF tabla_permitida( table_name ) = abap_false.
      out->write( |Tabla { table_name } no permitida| ).
      RETURN.
    ENDIF.

    "El destino tiene un tipo fijo: solo sirve para tablas con esta misma estructura.
    DATA carriers TYPE STANDARD TABLE OF /dmo/carrier WITH EMPTY KEY.
    SELECT * FROM (table_name)
      INTO TABLE @carriers
      UP TO 3 ROWS.
    out->write( |Registros leídos de { table_name }: { lines( carriers ) }| ).

    FIELD-SYMBOLS <value> TYPE data.
    LOOP AT carriers ASSIGNING FIELD-SYMBOL(<row>).
      ASSIGN COMPONENT 'CARRIER_ID' OF STRUCTURE <row> TO <value>.
      IF sy-subrc = 0.
        out->write( |Carrier ID: { <value> }| ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ejemplo_8b_tipo_dinamico.
    out->write( |=== EJEMPLO 8B: SELECT con tipo dinámico ===| ).
    DATA(table_name) = `/DMO/FLIGHT`.        "Prueba también con `/DMO/FLIGHT`
    IF tabla_permitida( table_name ) = abap_false.
      out->write( |Tabla { table_name } no permitida| ).
      RETURN.
    ENDIF.

    DATA rows_ref TYPE REF TO data.
    FIELD-SYMBOLS <rows> TYPE STANDARD TABLE.
    "La tabla interna se crea al ejecutar con la estructura de table_name.
    CREATE DATA rows_ref TYPE STANDARD TABLE OF (table_name).
    ASSIGN rows_ref->* TO <rows>.

    SELECT * FROM (table_name)
      INTO TABLE @<rows>
      UP TO 5 ROWS.
    out->write( |Tabla: { table_name }; registros: { lines( <rows> ) }| ).
    out->write( <rows> ).
  ENDMETHOD.

  METHOD ejemplo_8c_new_dinamico.
    out->write( |=== EJEMPLO 8C: SELECT dinámico con NEW ===| ).
    DATA(table_name) = `/DMO/FLIGHT`.
    IF tabla_permitida( table_name ) = abap_false.
      out->write( |Tabla { table_name } no permitida| ).
      RETURN.
    ENDIF.

    "Con FROM dinámico, NEW @DATA es la única declaración inline posible.
    SELECT * FROM (table_name)
      INTO TABLE NEW @DATA(rows_ref)
      UP TO 3 ROWS.
    ASSIGN rows_ref->* TO FIELD-SYMBOL(<rows>).
    out->write( <rows> ).
  ENDMETHOD.

  METHOD cliente_de_ejemplo.
    customer = VALUE #( customer_id  = '000001'
                        first_name   = 'Laura'
                        last_name    = 'Martinez'
                        city         = 'Madrid'
                        country_code = 'ES' ).
  ENDMETHOD.

  METHOD tabla_permitida.
    "Un nombre de tabla que llega de fuera se compara con una lista cerrada.
    DATA(allowed_tables) = VALUE string_table( ( `/DMO/CARRIER` ) ( `/DMO/FLIGHT` ) ).
    allowed = xsdbool( line_exists( allowed_tables[ table_line = table_name ] ) ).
  ENDMETHOD.
ENDCLASS.
