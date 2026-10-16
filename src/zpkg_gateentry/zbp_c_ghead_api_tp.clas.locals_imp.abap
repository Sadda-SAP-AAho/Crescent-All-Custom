CLASS lhc_z_c_ghead_api_tp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR z_c_ghead_api_tp RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE z_c_ghead_api_tp.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE z_c_ghead_api_tp.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE z_c_ghead_api_tp.

    METHODS read FOR READ
      IMPORTING keys FOR READ z_c_ghead_api_tp RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK z_c_ghead_api_tp.

ENDCLASS.

CLASS lhc_z_c_ghead_api_tp IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA ls_head TYPE zdt_ghead.
    DATA ls_item TYPE zdt_gitem.
    DATA ls_wb   TYPE zdt_weighbridge.

    " Modify
    DATA(lt_entities) = entities.
    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<fs>).
*      <fs>-grswt = <fs>-grswt / 1000.
*      <fs>-netwt = <fs>-netwt / 1000.
*      <fs>-tarwt = <fs>-tarwt / 1000.
      IF <fs>-trans NE 'Internal'.
        ls_head = CORRESPONDING #( <fs> ).

        ls_item = CORRESPONDING #( <fs> ).
        ls_wb = CORRESPONDING zdt_weighbridge( <fs> ).
        ls_wb-gateitem = <fs>-gateentryitem.
        ls_wb-gateentryno = <fs>-gateentryno.
        ls_item-gatepass = |{ <fs>-gateentryno ALPHA = IN }|.
        ls_item-gateitem = |{ <fs>-gateentryitem ALPHA = IN }|.
        ls_head-gatepass = |{ <fs>-gateentryno ALPHA = IN }|.
        ls_wb-gateitem     = |{ ls_wb-gateitem ALPHA = IN }|.

        SELECT SINGLE * FROM zdt_ghead WHERE gatepass = @ls_head-gatepass INTO @DATA(ls_ghead).

        IF ls_item-tarwt IS NOT INITIAL.
          UPDATE zdt_gitem SET tarwt = @ls_item-tarwt WHERE id = @ls_ghead-id AND gateitem = @ls_wb-gateitem.
        ENDIF.

        IF ls_item-grswt IS NOT INITIAL.
          UPDATE zdt_gitem SET grswt = @ls_head-grswt WHERE  id = @ls_ghead-id AND gateitem = @ls_wb-gateitem.
        ENDIF.

        IF ls_item-meins <> ''.
          UPDATE zdt_gitem SET meins = @ls_item-meins WHERE  id = @ls_ghead-id AND gateitem = @ls_wb-gateitem.
        ENDIF.

        IF ls_item-netwt IS NOT INITIAL.
          UPDATE zdt_gitem SET netwt = @ls_item-netwt WHERE  id = @ls_ghead-id AND gateitem = @ls_wb-gateitem.
        ENDIF.

        IF ls_item-weighbentrydate IS NOT INITIAL.
          UPDATE zdt_gitem SET weighbentrydate = @ls_item-weighbentrydate, weighbentrytime = @ls_item-weighbentrytime
          WHERE  id = @ls_ghead-id AND gateitem = @ls_wb-gateitem.
        ENDIF.

        IF ls_item-weighbexitdate IS NOT INITIAL.
          UPDATE zdt_gitem SET weighbexitdate = @ls_item-weighbexitdate, weighbexittime = @ls_item-weighbexittime
          WHERE  id = @ls_ghead-id AND gateitem = @ls_wb-gateitem.
        ENDIF.

        SELECT * FROM zdt_gitem
          WHERE gatepass = @ls_head-gatepass
        " TODO: variable is assigned but never used (ABAP cleaner)
          INTO TABLE @DATA(lt_item).
        IF sy-subrc  IS INITIAL.
          SORT lt_item BY gatepass gateitem ASCENDING.
          FINAL(lv_gr) = VALUE #( lt_item[ 1 ] OPTIONAL ).
          IF lv_gr-grswt IS NOT INITIAL.
            UPDATE zdt_ghead SET grswt = @lv_gr-grswt WHERE gatepass = @ls_head-gatepass .
          ENDIF.

          FINAL(lv_net) = REDUCE menge_d( INIT i TYPE menge_d FOR ls_i IN lt_item
                                          NEXT i = i + ( ls_i-netwt ) ).
          DATA lv_trg TYPE menge_d.
          lv_trg = lv_gr-grswt - lv_net.
          IF lv_net IS NOT INITIAL.
            UPDATE zdt_ghead SET netwt = @lv_net WHERE gatepass = @ls_head-gatepass .
          ENDIF.
          IF lv_trg IS NOT INITIAL.
            UPDATE zdt_ghead SET tarwt = @lv_trg WHERE gatepass = @ls_head-gatepass .
          ENDIF.
        ENDIF.
        MODIFY zdt_weighbridge FROM @ls_wb.
      ELSE.
        ls_item = CORRESPONDING #( <fs> ).
        ls_wb = CORRESPONDING zdt_weighbridge( <fs> ).
        ls_wb-gateitem = <fs>-gateentryitem.
        ls_wb-gateentryno = <fs>-gateentryno.
        ls_item-gatepass = |{ <fs>-gateentryno ALPHA = IN }|.
        ls_item-gateitem = |{ <fs>-gateentryitem ALPHA = IN }|.
        ls_head-gatepass = |{ <fs>-gateentryno ALPHA = IN }|.
        ls_wb-gateitem     = |{ ls_wb-gateitem ALPHA = IN }|.


        IF <fs>-netwt IS NOT INITIAL.
          UPDATE ztm_iito_trans SET ntgew = @<fs>-netwt WHERE itono = @ls_item-gatepass AND matnr = @<fs>-matnr .
        ENDIF.


        IF <fs>-tarwt IS NOT INITIAL.
          UPDATE ztm_hito_trans SET trgew = @<fs>-tarwt WHERE itono = @ls_item-gatepass .
        ENDIF.


        MODIFY zdt_weighbridge FROM @ls_wb.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_z_c_ghead_api_tp DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_z_c_ghead_api_tp IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
