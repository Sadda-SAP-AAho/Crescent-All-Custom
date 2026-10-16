CLASS zcl_domdraftpl_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DOMDRAFTPL_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'DELIVERYDOCUMENT' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA : lt_return TYPE TABLE OF zcus_domdraftpl.

    LOOP AT lt_range[ name = 'DELIVERYDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

    LOOP AT lt_range[ name = 'REVISION' ]-range ASSIGNING FIELD-SYMBOL(<ls_range1>).
      DATA(lv_rev) = <ls_range1>-low.
    ENDLOOP.

      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zvdomdraftpl_hdr
      WHERE deliverydocument = @lv_del and revision = @lv_rev
      INTO @DATA(ls_del1).

      INSERT VALUE zcus_domdraftpl(
      deliverydocument = lv_del
      purchaseorderbycustomer    = ls_del1-purchaseorderbycustomer
      customerpurchaseorderdate  = ls_del1-customerpurchaseorderdate
      incotermsclassification    = ls_del1-incotermsclassification
      caddress1                  = ls_del1-caddress1
      caddress2                  = ls_del1-caddress2
      name                       = ls_del1-name
      address                    = ls_del1-address
      addressbp                  = ls_del1-addressbp
      customernamebp             = ls_del1-Customernamebp
      customernamesh             = ls_del1-Customernamesh
      iec                        = ls_del1-iec
      var3                       = ls_del1-var3
*    Streetname                    : abap.char(100);
*    Cityname                      : abap.char(25);
*    PostalCode                    : abap.char(8)
*    Country                       : abap.char(30);
*    CustomerName                  : abap.char(75);
      customer                   = ls_del1-customer
      customer1                  = ls_del1-customer1
      counconsignee              = ls_del1-counconsignee
      counbuyer                  = ls_del1-counbuyer
      contactp                   = ls_del1-contactp
      contactn                   = ls_del1-contactn
      remarks                    = ls_del1-remarks
      Revision                   = lv_rev
       ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
