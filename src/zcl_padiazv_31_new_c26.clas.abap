CLASS zcl_padiazv_31_new_c26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_padiazv_31_new_c26 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
"NEW crea la instancia y pasa estos parámetros a su constructor.
    DATA(notificacion) = NEW zcl_30_notificacion_c26(
      destinatario = 'admin@empresa.com'
      mensaje = 'Sistema caído - requiere atención inmediata'
      prioridad = 'URGENTE' ).

    out->write( |Destinatario: { notificacion->destinatario }| ).
    out->write( |Mensaje: { notificacion->mensaje }| ).
    out->write( |Prioridad: { notificacion->prioridad }| ).
    out->write( notificacion->preparar( ) ).




    "Con un tipo de datos, NEW crea un objeto de datos anónimo y devuelve su referencia.
    DATA(contador) = NEW i( 100 ).
    DATA(texto) = NEW string( 'Hola ABAP Cloud' ).
    out->write( |Contador: { contador->* }| ).
    out->write( |Texto: { texto->* }| ).
  ENDMETHOD.
ENDCLASS.
