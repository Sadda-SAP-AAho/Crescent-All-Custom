CLASS zcl_boeform_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BOEFORM_IMPL IMPLEMENTATION.


METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'BILLNO' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA : lt_return TYPE TABLE OF zcus_boeform.

    LOOP AT lt_range[ name = 'BILLNO' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zi_boeform
      WHERE BillNo = @lv_del
      INTO @DATA(lv_del1).

data: lv_paise type string.
data: lv_rupees type string .
DATA: lv_amtwrd TYPE STRING.
DATA: amtintext TYPE char256.
lv_rupees = lv_del1-NetAmt.
lv_amtwrd = ZCL_NUMTOWORDS=>ZNUMWORD( exporting iv_num = lv_rupees
                           CHANGING rv_dec_words = lv_paise ).

    CONCATENATE lv_amtwrd
                'Dollars and'
      INTO     amtintext
      SEPARATED BY space.

    CONCATENATE amtintext
                lv_paise
                'Cents Only'
      INTO      amtintext
      SEPARATED BY space.


INSERT VALUE zcus_boeform(
      BillNo     = lv_del
      BillDate   = lv_del1-BillDate
      Boeddt     = lv_del1-Boeddt
      Currency   = lv_del1-Currency
      NetAmt     = lv_del1-NetAmt
      amtintext  = amtintext
      TOP        = lv_del1-TOP
      BankAddr   = lv_del1-BankAddr
      CustName   = lv_del1-CustName
      StreetName = lv_del1-StreetName
      PostalCode = lv_del1-PostalCode
      CityName   = lv_del1-CityName
      Country    = lv_del1-Country
       ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
