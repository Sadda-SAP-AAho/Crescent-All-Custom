CLASS zcl_comm_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COMM_IMPL IMPLEMENTATION.


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

    data : lt_return TYPE TABLE of ZVCOMMERCIALPRNT.

      LOOP AT lt_range[ name = 'BILLINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_bill) = <ls_range>-low.
      lv_bill = |{ lv_bill ALPHA = IN }|.

      select single  DocumentReferenceID from ZCDS_DOCREFNO
      where BillingDocument = @lv_bill
     into @data(lv_docid).

      select single * from zvbillingdochead
      where BillingDocument = @lv_bill
      into @data(ls_bill1).



      INSERT VALUE ZVCOMMERCIALPRNT(
      Billingdocument = lv_bill
      doc_ref         = lv_docid
      CreationDate    = ls_bill1-CreationDate
      CreationTime    = ls_bill1-CreationTime
      caddress1       = ls_bill1-caddress1
      caddress2       = ls_bill1-caddress2
      name            = ls_bill1-name
       ) into TABLE lt_return.
      endloop.
      io_response->set_data( lt_return ).
      io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
