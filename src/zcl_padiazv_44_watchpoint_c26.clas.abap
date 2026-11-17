CLASS zcl_padiazv_44_watchpoint_c26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_padiazv_44_watchpoint_c26 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    SELECT * FROM /dmo/flight
      WHERE carrier_id = 'AA'
      ORDER BY PRIMARY KEY
      INTO TABLE @DATA(flights)
      UP TO 5 ROWS.
    out->write( |Vuelos encontrados: { lines( flights ) }| ).

    "Este VALUE con FOR es UNA sola sentencia: un breakpoint no para en cada vuelta.
    "Para ver cada iteración se vigila la variable flight con un watchpoint.
    DATA con_descuento TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.
    con_descuento = VALUE #(                                    "<-- BP 1
      FOR flight IN flights
      ( carrier_id     = flight-carrier_id
        connection_id  = flight-connection_id
        flight_date    = flight-flight_date
        plane_type_id  = flight-plane_type_id
        seats_max      = flight-seats_max
        seats_occupied = flight-seats_occupied
        price          = flight-price * '0.9'                   "10 % de descuento
        currency_code  = flight-currency_code ) ).

    out->write( |--- Precios con descuento ---| ).
    LOOP AT con_descuento INTO DATA(vuelo).
      out->write( |Vuelo { vuelo-connection_id }: { vuelo-price } { vuelo-currency_code }| ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
