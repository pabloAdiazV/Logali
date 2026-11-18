CLASS zcl_padia_47_perfor_tablas_c26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS constructor.
    METHODS buscar_en_standard RETURNING VALUE(result) TYPE /dmo/booking_m.
    METHODS buscar_en_sorted   RETURNING VALUE(result) TYPE /dmo/booking_m.
    METHODS buscar_en_hashed   RETURNING VALUE(result) TYPE /dmo/booking_m.
  PRIVATE SECTION.
    "Las tres tablas tienen los mismos datos y la misma clave; cambia la categoría
    DATA bookings_standard TYPE STANDARD TABLE OF /dmo/booking_m
                           WITH NON-UNIQUE KEY travel_id booking_id booking_date.
    DATA bookings_sorted   TYPE SORTED TABLE OF /dmo/booking_m
                           WITH NON-UNIQUE KEY travel_id booking_id booking_date.
    DATA bookings_hashed   TYPE HASHED TABLE OF /dmo/booking_m
                           WITH UNIQUE KEY travel_id booking_id booking_date.
    DATA key_travel_id  TYPE /dmo/travel_id.
    DATA key_booking_id TYPE /dmo/booking_id.
    DATA key_date       TYPE /dmo/booking_date.
    METHODS elegir_fila_a_buscar.
ENDCLASS.

CLASS zcl_padia_47_perfor_tablas_c26 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    "main ya se ejecuta en un objeto de esta clase: no hace falta NEW
    IF bookings_standard IS INITIAL.
      out->write( `/DMO/BOOKING_M está vacía: genera los datos de vuelos antes de medir` ).
      RETURN.
    ENDIF.

    DATA(desde_standard) = buscar_en_standard( ).
    DATA(desde_sorted)   = buscar_en_sorted( ).
    DATA(desde_hashed)   = buscar_en_hashed( ).

    out->write( |Filas en cada tabla: { lines( bookings_standard ) }| ).
    out->write( |Clave buscada: viaje { key_travel_id }, reserva { key_booking_id }, fecha { key_date DATE = ISO }| ).
    out->write( |STANDARD encontró: viaje { desde_standard-travel_id }, reserva { desde_standard-booking_id }| ).
    out->write( |SORTED encontró:   viaje { desde_sorted-travel_id }, reserva { desde_sorted-booking_id }| ).
    out->write( |HASHED encontró:   viaje { desde_hashed-travel_id }, reserva { desde_hashed-booking_id }| ).
  ENDMETHOD.

  METHOD constructor.
    SELECT FROM /dmo/booking_m
      FIELDS *
      INTO TABLE @bookings_standard.
    SELECT FROM /dmo/booking_m
      FIELDS *
      INTO TABLE @bookings_sorted.
    SELECT FROM /dmo/booking_m
      FIELDS *
      INTO TABLE @bookings_hashed.
    elegir_fila_a_buscar( ).
  ENDMETHOD.

  METHOD elegir_fila_a_buscar.
    "Toma la fila que está al 65 % de la tabla STANDARD: así la búsqueda lineal
    "tiene que recorrer más de la mitad antes de encontrarla
    IF bookings_standard IS INITIAL.
      RETURN.
    ENDIF.
    DATA(fila) = bookings_standard[ CONV i( lines( bookings_standard ) * '0.65' ) ].
    key_travel_id  = fila-travel_id.
    key_booking_id = fila-booking_id.
    key_date       = fila-booking_date.
  ENDMETHOD.

  METHOD buscar_en_standard.
    "STANDARD: búsqueda lineal, fila a fila
    result = bookings_standard[ travel_id    = key_travel_id
                                booking_id   = key_booking_id
                                booking_date = key_date ].
  ENDMETHOD.

  METHOD buscar_en_sorted.
    "SORTED: búsqueda binaria, porque se indica la clave de la tabla
    result = bookings_sorted[ travel_id    = key_travel_id
                              booking_id   = key_booking_id
                              booking_date = key_date ].
  ENDMETHOD.

  METHOD buscar_en_hashed.
    "HASHED: algoritmo hash, porque se indica la clave completa
    result = bookings_hashed[ travel_id    = key_travel_id
                              booking_id   = key_booking_id
                              booking_date = key_date ].
  ENDMETHOD.
ENDCLASS.
