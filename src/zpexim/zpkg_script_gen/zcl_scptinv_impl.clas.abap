CLASS zcl_scptinv_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SCPTINV_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'SCRIPTSALESNO' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA : lt_return TYPE TABLE OF zcus_scriptinv.

    LOOP AT lt_range[ name = 'SCRIPTSALESNO' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zcds_scriptinv_hed
      WHERE scriptsalesno = @lv_del
      INTO @DATA(ls_del1).

      Select single * from zcds_amttext
      where scriptsalesno = @lv_del
      INTO @DATA(ls_amt).

      data: lv_paise type string.
      data: lv_rupees type string .
      DATA: lv_amtwrd TYPE STRING.
      DATA: amtintext TYPE char256.

      lv_rupees = ls_amt-linetotal.
      lv_amtwrd = ZCL_NUMTOWORDS=>ZNUMWORD( exporting iv_num = lv_rupees
                           CHANGING rv_dec_words = lv_paise ).

      CONCATENATE lv_amtwrd
                  'Rupees and'
      INTO     amtintext
      SEPARATED BY space.

      CONCATENATE amtintext
                lv_paise
                'Paise Only'
      INTO      amtintext
      SEPARATED BY space.

      INSERT VALUE zcus_scriptinv(
      scriptsalesno             = lv_del
      accdocno                  = ls_del1-accdocno
      scriptsalesdate           = ls_del1-scriptsalesdate
      Customername              = ls_del1-CustomerName
      StreetName                = ls_del1-cusstreet
      CityName                  = ls_del1-cuscityname
      Country                   = ls_del1-cuscoun
      PostalCode                = ls_del1-cuspostcode
      bnkname                   = ls_del1-BankName
      bnkstreet                 = ls_del1-bnkstreet
      bnkcity                   = ls_del1-bnkcityname
      bnkaccno                  = ls_del1-bankaccno
      bnkswiftcode              = ls_del1-SWIFTCode
      caddress1                 = ls_del1-caddress1
      caddress2                 = ls_del1-caddress2
      caddress3                 = ls_del1-caddress3
      name                      = ls_del1-name
      TaxNumber3                = ls_del1-TaxNumber3
      gstin                     = ls_del1-gstin
      cmobile                   = ls_del1-cmobile
      var6                      = ls_del1-var6
      amtintext                 = amtintext
      cemail                    = ls_del1-cemail
      cuspanno                  = ls_del1-cuspanno
       ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
