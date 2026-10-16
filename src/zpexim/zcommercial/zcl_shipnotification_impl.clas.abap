CLASS zcl_shipnotification_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

 PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SHIPNOTIFICATION_IMPL IMPLEMENTATION.


METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'ID' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.
    DATA rt_table TYPE TABLE OF zvshipnot.

    LOOP AT lt_range[ name = 'ID' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_id) = <ls_range>-low.
      SELECT SINGLE * FROM zdt_comm_hed
        WHERE id = @lv_id
         INTO @DATA(ls_commhead).

      INSERT VALUE zvshipnot(
       Id             = ls_commhead-Id
       Atadate        = ls_commhead-Atadate
      Awbno           = ls_commhead-Awbno
      Bankrefno       = ls_commhead-Bankrefno
      Billcloseflag   = ls_commhead-Billcloseflag
      Blrcvdt         = ls_commhead-Blrcvdt
      Boeddt          = ls_commhead-Boeddt
      Commid          = ls_commhead-Commid
      Correctblsendon = ls_commhead-Correctblsendon
      Custrqstdt      = ls_commhead-Custrqstdt
      Docpresentbnkdt = ls_commhead-Docpresentbnkdt
      Docsentcustdt   = ls_commhead-Docsentcustdt
      Draftblcnfdt    = ls_commhead-Draftblcnfdt
      Ebrcno          = ls_commhead-Ebrcno
      Ebrcrcvdt       = ls_commhead-Ebrcrcvdt
      Ebrcvalfc       = ls_commhead-Ebrcvalfc
      Fundplanremark  = ls_commhead-Fundplanremark
      Initmationdt    = ls_commhead-Initmationdt
      Isfsenddt       = ls_commhead-Isfsenddt
      Tprint          = ls_commhead-tprint
      Ladingdt        = ls_commhead-Ladingdt
      Ladingno        = ls_commhead-Ladingno
      Lcbankadd1      = ls_commhead-Lcbankadd1
      Lcbankadd2      = ls_commhead-Lcbankadd2
      Leodate         = ls_commhead-Leodate
      Paymentprocess  = ls_commhead-Paymentprocess
      Planingmonth    = ls_commhead-Planingmonth
      Planingweek     = ls_commhead-Planingweek
      Rcvconsignbnkdt = ls_commhead-Rcvconsignbnkdt
      Rotationno      = ls_commhead-Rotationno
      Scripno         = ls_commhead-Scripno
      Scrollno        = ls_commhead-Scrollno
      Shbillrecddt    = ls_commhead-Shbillrecddt
      Swiftdt         = ls_commhead-Swiftdt
      Tpdate          = ls_commhead-Tpdate
      Tpno            = ls_commhead-Tpno
      Vesselsaildt    = ls_commhead-Vesselsaildt
      Waers           = ls_commhead-Waers
      createdat       = ls_commhead-createdat
      ) INTO TABLE rt_table.

    ENDLOOP.

    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).
  ENDMETHOD.
ENDCLASS.
