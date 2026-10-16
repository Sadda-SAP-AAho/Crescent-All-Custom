CLASS zcl_patinv_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PATINV_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'BILLINGDOCUMENT' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA : lt_return TYPE TABLE OF zcus_patinv.

    LOOP AT lt_range[ name = 'BILLINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zcds_patinvhed
      WHERE billingdocument = @lv_del
      INTO @DATA(ls_del1).

      INSERT VALUE zcus_patinv(
      BillingDocument               = lv_del
      BillingDocumentDate           = ls_del1-BillingDocumentDate
      caddress1                     = ls_del1-caddress1
      caddress2                     = ls_del1-caddress2
      caddress3                     = ls_del1-caddress3
      name                          = ls_del1-name
      gstin                         = ls_del1-gstin
      cmobile                       = ls_del1-cmobile
      var6                          = ls_del1-var6
      customername                  = ls_del1-customername
      address                       = ls_del1-address
      bankname                      = ls_del1-BankName
      streetname                    = ls_del1-CityName
      cityname                      = ls_del1-StreetName
      DocumentReferenceID           = ls_del1-DocumentReferenceID
       ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
