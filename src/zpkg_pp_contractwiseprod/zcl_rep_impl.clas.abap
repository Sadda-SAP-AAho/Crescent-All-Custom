CLASS zcl_rep_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_REP_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'SHPFLRDT' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.


    DATA : lt_return TYPE TABLE OF zcus_repprint.

    LOOP AT lt_range[ name = 'SHPFLRDT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

     LOOP AT lt_range[ name = 'OPR' ]-range ASSIGNING FIELD-SYMBOL(<ls_range1>).
      DATA(lv_opr) = <ls_range1>-low.
    ENDLOOP.

     LOOP AT lt_range[ name = 'CONT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range2>).
      DATA(lv_cont) = <ls_range2>-low.
    ENDLOOP.

    LOOP AT lt_range[ name = 'DEPT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range3>).
      DATA(lv_dept) = <ls_range3>-low.
    ENDLOOP.

    LOOP AT lt_range[ name = 'PLANT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range4>).
      DATA(lv_plant) = <ls_range4>-low.
    ENDLOOP.

*    LOOP AT lt_range[ name = 'DEPTNAME' ]-range ASSIGNING FIELD-SYMBOL(<ls_range5>).
*      DATA(lv_deptname) = <ls_range5>-low.
*    ENDLOOP.
*
*    LOOP AT lt_range[ name = 'CONTNAME' ]-range ASSIGNING FIELD-SYMBOL(<ls_range6>).
*      DATA(lv_contname) = <ls_range6>-low.
*    ENDLOOP.
*
*    LOOP AT lt_range[ name = 'OPRNAME' ]-range ASSIGNING FIELD-SYMBOL(<ls_range7>).
*      DATA(lv_oprname) = <ls_range7>-low.
*    ENDLOOP.


      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zcds_reprpnt_hdr
      WHERE shpflrdt   = @lv_del
      and     dept     = @lv_dept
      and     plant    = @lv_plant
      and     opr      = @lv_opr
      and     cont     = @lv_cont
      INTO @DATA(ls_del1).

      INSERT VALUE zcus_repprint(
      Shpflrdt               = lv_del
      Opr                    = lv_opr
      Plant                  = lv_plant
      Dept                   = lv_dept
      Cont                   = lv_cont
      Contname               = ls_del1-Contname
      Deptname               = ls_del1-Deptname
      Oprname                = ls_del1-Oprname
      laboritemno1           = ls_del1-laboritemno1
      laboritemno2           = ls_del1-laboritemno2
      laboritemno3           = ls_del1-laboritemno3
      laboritemno4           = ls_del1-laboritemno4
      ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
