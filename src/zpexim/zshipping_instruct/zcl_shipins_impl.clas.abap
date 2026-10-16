CLASS zcl_shipins_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SHIPINS_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'BOOKINGNO' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA : lt_return TYPE TABLE OF zcus_shippinginstruc.

    LOOP AT lt_range[ name = 'BOOKINGNO' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zvshipinst_hdr
      WHERE bookingno = @lv_del
      INTO @DATA(ls_del1).

      INSERT VALUE zcus_shippinginstruc(
      Bookingno         = lv_del
      name              = ls_del1-name
      caddress1         = ls_del1-caddress1
      caddress2         = ls_del1-caddress2
      Shipmenttype      = ls_del1-Shipmenttype
      Shippingtype      = ls_del1-Shippingtype
      address           = ls_del1-address
      customername      = ls_del1-customername
      Precarby          = ls_del1-Precarby
      Pol               = ls_del1-Pol
      Por               = ls_del1-Por
      Pod               = ls_del1-Pod
      Placedel          = ls_del1-Placedel
      Loadingpier       = ls_del1-Loadingpier
      Expcarrvoyage     = ls_del1-Expcarrvoyage
      Notifyp1name      = ls_del1-Notifyp1name
      Notifyp1add1      = ls_del1-Notifyp1add1
      Notifyp1add2      = ls_del1-Notifyp1add2
      Notifyp2name      = ls_del1-Notifyp2name
      Notifyp2add1      = ls_del1-Notifyp2add1
      Notifyp2add2      = ls_del1-Notifyp2add2
      Notifyp3name      = ls_del1-Notifyp3name
      Notifyp3add1      = ls_del1-Notifyp3add1
      Notifyp3add2      = ls_del1-Notifyp3add2
      Deliveradd        = ls_del1-Deliveradd
      Deliveradd1       = ls_del1-Deliveradd1
      Deliveradd2       = ls_del1-Deliveradd2
       ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
