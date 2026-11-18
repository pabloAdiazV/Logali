CLASS zcl_adiazv_46_perfor_fs_c26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS con_estructura.
    METHODS con_field_symbol.
  PRIVATE SECTION.
    TYPES airport_table TYPE STANDARD TABLE OF /dmo/airport
                        WITH NON-UNIQUE KEY airport_id.
    "Los LOOP van en métodos propios para que el Hit List los mida
    "sin el tiempo del SELECT
    METHODS loop_estructura    CHANGING airports TYPE airport_table.
    METHODS loop_field_symbol  CHANGING airports TYPE airport_table.
ENDCLASS.

CLASS zcl_adiazv_46_perfor_fs_c26 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(perfor) = NEW zcl_46_perfor_fs_c26( ).
    perfor->con_estructura( ).      "Enfoque 1: INTO + MODIFY
    perfor->con_field_symbol( ).    "Enfoque 2: ASSIGNING
    out->write( `OK: abre el Hit List para comparar los tiempos` ).
  ENDMETHOD.

  METHOD con_estructura.
    DATA airports TYPE airport_table.
    SELECT FROM /dmo/airport
      FIELDS *
      INTO TABLE @airports.
    loop_estructura( CHANGING airports = airports ).
  ENDMETHOD.

  METHOD con_field_symbol.
    DATA airports TYPE airport_table.
    SELECT FROM /dmo/airport
      FIELDS *
      INTO TABLE @airports.
    loop_field_symbol( CHANGING airports = airports ).
  ENDMETHOD.

  METHOD loop_estructura.
    "Copia la fila al área de trabajo, cambia la copia y la devuelve a la tabla
    LOOP AT airports INTO DATA(airport).
      airport-country = 'CO'.
      MODIFY airports FROM airport.
    ENDLOOP.
  ENDMETHOD.

  METHOD loop_field_symbol.
    "El field symbol da acceso directo a la fila: el cambio queda en la tabla
    LOOP AT airports ASSIGNING FIELD-SYMBOL(<airport>).
      <airport>-country = 'CO'.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
