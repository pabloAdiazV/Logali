CLASS zcl_padi_30_notificacion_c26 DEFINITION "AUXILIAR
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    DATA destinatario TYPE string READ-ONLY.
    DATA mensaje TYPE string READ-ONLY.
    DATA prioridad TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING destinatario TYPE string
                mensaje TYPE string
                prioridad TYPE string.

    METHODS preparar RETURNING VALUE(resultado) TYPE string.
ENDCLASS.

CLASS zcl_padi_30_notificacion_c26 IMPLEMENTATION.

  METHOD constructor.
    "me-> identifica el atributo cuando el parámetro tiene el mismo nombre.
    me->destinatario = destinatario.
    me->mensaje = mensaje.
    me->prioridad = prioridad.
  ENDMETHOD.

  METHOD preparar.
    "Construye el texto de la notificación; no ejecuta un envío externo.
    resultado = |Para: { destinatario } - { prioridad }: { mensaje }|.
  ENDMETHOD.

  ENDCLASS.
