CLASS zcl_padiazv_38_fs_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_padiazv_38_fs_c26 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.


*    DATA nombre TYPE string VALUE 'Laura'.
*    FIELD-SYMBOLS <nombre> TYPE string.
*
*    "ASSIGN conecta el alias con el dato existente.
*    ASSIGN nombre TO <nombre>.
*
*    IF <nombre> IS ASSIGNED.
*      out->write( |Nombre original: { nombre }| ).
*      <nombre> = 'Ximena'.
*      out->write( |Nombre tras el cambio: { nombre }| ).
*    ENDIF.
*
*    DATA numeros TYPE STANDARD TABLE OF i WITH EMPTY KEY.
*    numeros = VALUE #( ( 10 ) ( 20 ) ( 30 ) ).
*
*    "INTO entrega una copia; cambiar esa variable no cambia la fila de la tabla.
*
*    LOOP AT numeros INTO DATA(numero_copia).
*      numero_copia *= 2.
*    ENDLOOP.
*
*    out->write( 'TRAS INTO: 10, 20, 30' ).
*    out->write( numeros ).
*
*    "ASSIGNING permite modificar directamente cada fila.
*    LOOP AT numeros ASSIGNING FIELD-SYMBOL(<numero>).
*      <numero> *= 2.
*    ENDLOOP.
*
*    out->write( 'TRAS ASSIGNING: 20, 40, 60' ).
*    out->write( numeros ).
*
*    IF <numero> IS ASSIGNED.
*      out->write( |Después del LOOP el alias sigue asignado: { <numero> }| ).
*    ENDIF.
*
*    UNASSIGN <numero>.
*
*    DATA precio TYPE p LENGTH 10 DECIMALS 2 VALUE '100.00'.
*
*    ASSIGN precio TO FIELD-SYMBOL(<precio>).
*
*    <precio> = <precio> * '1.21'.
*    out->write( |Precio con IVA: { precio }| ).
*
*    "UNASSIGN desconecta el alias; no borra ni libera el dato precio.
*    UNASSIGN <precio>.
*    IF <precio> IS NOT ASSIGNED.
*      out->write( |Alias desconectado; precio original: { precio }| ).
*    ENDIF.
*
*      SELECT FROM /dmo/customer
*      FIELDS customer_id, first_name, last_name, email_address
*      WHERE email_address LIKE '%@flight.example.de'
*      ORDER BY customer_id
*      INTO TABLE @DATA(customers)
*      UP TO 5 ROWS.
*
*    IF customers IS INITIAL.
*      out->write( 'No hay clientes con el dominio @flight.example.de en esta muestra.' ).
*      RETURN.
*    ENDIF.
*
*    out->write( |Clientes encontrados: { lines( customers ) }| ).
*
*    LOOP AT customers ASSIGNING FIELD-SYMBOL(<customer>).
*      DATA(previous_email) = <customer>-email_address.
*      "El patrón cambia el sufijo del dominio, sin sustituir texto de la parte local.
*      <customer>-email_address = replace(
*        val = <customer>-email_address
*        pcre = `@flight[.]example[.]de$`
*        with = '@empresa.com' ).
*
*      out->write( |{ <customer>-first_name } { <customer>-last_name }| ).
*      out->write( |Antes: { previous_email }| ).
*      out->write( |Ahora: { <customer>-email_address }| ).
*    ENDLOOP.
*
*    UNASSIGN <customer>.
*
*    out->write( 'Cambios realizados en la tabla interna customers.' ).
*


*    SELECT FROM /dmo/booking
*      FIELDS booking_id, customer_id, carrier_id, connection_id, flight_date
*      ORDER BY booking_id, customer_id, carrier_id, connection_id, flight_date
*      INTO TABLE @DATA(bookings)
*      UP TO 3 ROWS.
*
*    DATA(initial_count) = lines( bookings ).
*
*    out->write( |Reservas iniciales: { initial_count }| ).
*    out->write( bookings ).
*
*    "INITIAL LINE crea una fila inicial; ASSIGNING permite rellenarla sin otra copia.
*    APPEND INITIAL LINE TO bookings ASSIGNING FIELD-SYMBOL(<new_booking>).
*
*    <new_booking>-booking_id = '9999'.
*    <new_booking>-customer_id = '000001'.
*    <new_booking>-carrier_id = 'AA'.
*    <new_booking>-connection_id = '0017'.
*    <new_booking>-flight_date = cl_abap_context_info=>get_system_date( ).
*
*    out->write( 'RESERVA AÑADIDA EN MEMORIA' ).
*    out->write( <new_booking> ).
*    out->write( |Total: { lines( bookings ) }; incremento: { lines( bookings ) - initial_count }| ).
*    UNASSIGN <new_booking>.
*
*    out->write( bookings ).


*   SELECT FROM /dmo/customer
*      FIELDS customer_id, first_name, last_name, city
*      ORDER BY customer_id
*      INTO TABLE @DATA(customers)
*      UP TO 3 ROWS.
*
*    out->write( 'LISTA INICIAL' ).
*    out->write( customers ).
*
*    "INDEX 1 requiere una tabla con índice y desplaza las posiciones siguientes.
*    INSERT INITIAL LINE INTO customers INDEX 2
*      ASSIGNING FIELD-SYMBOL(<vip_customer>).
*
*    <vip_customer>-customer_id = '999999'.
*    <vip_customer>-first_name = 'Laura'.
*    <vip_customer>-last_name = 'Martinez'.
*    <vip_customer>-city = 'Madrid'.
*
*    out->write( 'LISTA CON CLIENTE VIP AL PRINCIPIO' ).
*
*    LOOP AT customers ASSIGNING FIELD-SYMBOL(<customer>).
*      DATA(tag) = COND string( WHEN <customer>-customer_id = '999999' THEN 'VIP' ELSE '' ).
*      out->write( |{ sy-tabix }. { <customer>-customer_id } - | &&
*                  |{ <customer>-first_name } { <customer>-last_name } { tag }| ).
*    ENDLOOP.
*
*    UNASSIGN <vip_customer>.
*    UNASSIGN <customer>.

*
    SELECT FROM /dmo/flight
      FIELDS carrier_id, connection_id, flight_date, price, currency_code
      WHERE carrier_id = 'LH' AND connection_id = '0400'
      ORDER BY flight_date
      INTO TABLE @DATA(flights)
      UP TO 5 ROWS.

    IF flights IS INITIAL.
      out->write( 'No hay vuelos LH 0400 en esta muestra.' ).
      RETURN.
    ENDIF.

    out->write( 'VUELOS EN MEMORIA' ).
    out->write( flights ).

    "sy-subrc comprueba el resultado de esta lectura concreta.
    READ TABLE flights ASSIGNING FIELD-SYMBOL(<flight>)
      WITH KEY carrier_id = 'LH' connection_id = '0400'.

    IF sy-subrc EQ 0.
      DATA(previous_price) = <flight>-price.
      <flight>-price = <flight>-price * '0.85'.
      out->write( |Precio: { previous_price } -> { <flight>-price } { <flight>-currency_code }| ).
    ELSE.
      out->write( 'No se encontró la fila solicitada.' ).
    ENDIF.

    READ TABLE flights ASSIGNING FIELD-SYMBOL(<second_flight>) INDEX 2.

    IF sy-subrc = 0.
      out->write( 'SEGUNDA FILA' ).
      out->write( <second_flight> ).
    ELSE.
      out->write( 'La muestra no contiene una segunda fila.' ).
    ENDIF.

    "UNASSIGN evita conservar un alias anterior al comprobar una lectura fallida.
    UNASSIGN <flight>.
    READ TABLE flights ASSIGNING <flight> WITH KEY carrier_id = 'ZZ'.

    IF sy-subrc <> 0.
      out->write( 'No existe ZZ; no se accede a un alias sin una lectura válida.' ).
    ENDIF.

    UNASSIGN <flight>.
    UNASSIGN <second_flight>.
    out->write( 'TABLA INTERNA FINAL' ).
    out->write( flights ).


  ENDMETHOD.

ENDCLASS.
