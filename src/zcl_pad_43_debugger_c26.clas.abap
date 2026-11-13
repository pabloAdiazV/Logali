CLASS zcl_pad_43_debugger_c26 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.
    METHODS sumar_precios
      IMPORTING precios      TYPE string_table
      RETURNING VALUE(total) TYPE i.
ENDCLASS.

CLASS zcl_pad_43_debugger_c26 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    "=== SECCIÓN 1: F8 (Resume) ===
    out->write( |--- SECCIÓN 1: F8 (Resume) ---| ).           "<-- BP 1
    DATA(inicio) = `Inicio del programa`.
    out->write( inicio ).
    DATA(valor_1) = 100.
    DATA(valor_2) = 200.
    DATA(suma) = valor_1 + valor_2.
    out->write( |Suma: { suma }| ).                             "<-- BP 2

    "=== SECCIÓN 2: F6 (Step Over) ===
    out->write( |--- SECCIÓN 2: F6 (Step Over) ---| ).        "<-- BP 3
    DATA flights TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.
    SELECT * FROM /dmo/flight
      WHERE carrier_id = 'AA'
      ORDER BY PRIMARY KEY
      INTO TABLE @flights
      UP TO 3 ROWS.
    DATA(cantidad) = lines( flights ).
    out->write( |Vuelos encontrados: { cantidad }| ).

    "=== SECCIÓN 3: F5 (Step Into) ===
    out->write( |--- SECCIÓN 3: F5 (Step Into) ---| ).        "<-- BP 4
    DATA(precios) = VALUE string_table( ( `1500` ) ( `2000` ) ( `2500` ) ).
    DATA(total_precios) = sumar_precios( precios ).             "F5 aquí: entra en el método
    out->write( |Total precios: { total_precios }| ).

    "=== SECCIÓN 5: Shift+F8 (Run to Line) ===
    out->write( |--- SECCIÓN 5: Shift+F8 (Run to Line) ---| ). "<-- BP 5
    DATA(contador) = 0.
    DO 10 TIMES.
      contador += 1.
    ENDDO.
    out->write( |Contador después del DO: { contador }| ).     "<-- CURSOR 1

    "=== SECCIÓN 6: Shift+F12 (Jump to Line) ===
    out->write( |--- SECCIÓN 6: Shift+F12 (Jump to Line) ---| ).
    DATA(saldo) = 1000.
    out->write( |Saldo inicial: { saldo }| ).                   "<-- BP 6
    saldo -= 500.                                               "Esta línea se salta
    out->write( |Saldo tras saltar la resta: { saldo }| ).      "<-- CURSOR 2

    "=== SECCIÓN 7: combinación de técnicas ===
    out->write( |--- SECCIÓN 7: Combinación ---| ).
    SELECT * FROM /dmo/flight                                   "<-- BP 7
      WHERE carrier_id = 'LH'
      ORDER BY PRIMARY KEY
      INTO TABLE @flights
      UP TO 5 ROWS.
    out->write( |Total vuelos: { lines( flights ) }| ).
    DATA(vuelos_caros) = 0.
    LOOP AT flights INTO DATA(flight).                          "<-- BP 8
      IF flight-price > 500.                                    "<-- BP 9 (condicional)
        vuelos_caros += 1.
      ENDIF.
    ENDLOOP.
    out->write( |Vuelos caros: { vuelos_caros }| ).

    "=== SECCIÓN 8: expresiones complejas ===
    out->write( |--- SECCIÓN 8: Expresiones ---| ).
    DATA(precio_maximo) = REDUCE /dmo/flight_price(             "<-- BP 10
      INIT maximo = CONV /dmo/flight_price( 0 )
      FOR vuelo IN flights
      NEXT maximo = COND #( WHEN vuelo-price > maximo THEN vuelo-price ELSE maximo ) ).
    out->write( |Precio máximo: { precio_maximo }| ).

    TYPES: BEGIN OF vuelo_resumido,
             carrier    TYPE /dmo/carrier_id,
             connection TYPE /dmo/connection_id,
             price      TYPE /dmo/flight_price,
           END OF vuelo_resumido.
    DATA resumen TYPE vuelo_resumido.
    IF flights IS NOT INITIAL.
      "MAPPING enlaza componentes con nombres distintos.
      resumen = CORRESPONDING #( flights[ 1 ] MAPPING carrier    = carrier_id
                                                      connection = connection_id ).
    ENDIF.
    out->write( |Vuelo resumido: { resumen-carrier } { resumen-connection } { resumen-price }| ).

    out->write( |=== FIN DEL PROGRAMA ===| ).                   "<-- BP 11
  ENDMETHOD.

  METHOD sumar_precios.
    "=== SECCIÓN 4: F7 (Step Return) ===
    LOOP AT precios INTO DATA(precio).                          "F5 te deja aquí
      total += CONV i( precio ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
