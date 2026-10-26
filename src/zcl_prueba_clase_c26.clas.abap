CLASS zcl_prueba_clase_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun. "Para poder imprimir en consola
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prueba_clase_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( 'Esta es mi primera clase en ABAP.' ).

    " Variables
    DATA: lv_fecha TYPE d,
          lv_texto TYPE string.

    " Constante
    CONSTANTS: lv_c1 TYPE c LENGTH 7 VALUE 'padiazv'.

    lv_fecha = '20260101'.
    lv_texto = 'PabloA.'.

    out->write( lv_fecha ).
    out->write( |Hola { lv_fecha } | ).
    out->write( lv_texto ).
    out->write( lv_c1 ).



  ENDMETHOD.

ENDCLASS.
