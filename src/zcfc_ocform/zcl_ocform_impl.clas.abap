CLASS zcl_ocform_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OCFORM_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'ORDNO' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA : lt_return TYPE TABLE OF zcus_ocform.

    LOOP AT lt_range[ name = 'ORDNO' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

    lv_del = |{ lv_del ALPHA = IN }|.

    SELECT SINGLE * FROM zi_ocform_header
    WHERE ordno = @lv_del
    INTO @DATA(lv_del1).

    INSERT VALUE zcus_ocform(
    ordno       = lv_del
    dt          = lv_del1-dt
    billnm      = lv_del1-billnm
    shpnm       = lv_del1-shpnm
    billadd     = lv_del1-billadd
    shpadd      = lv_del1-shpadd
    ordcurrency = lv_del1-ordcurrency
    pod         = lv_del1-pod
    shipptyp    = lv_del1-shipptyp
    fnldst      = lv_del1-fnldst
    paymentterms = lv_del1-paymentterms
    plndmnthshipment = lv_del1-plndmnthshipment
   ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
