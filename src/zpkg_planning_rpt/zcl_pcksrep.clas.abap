CLASS zcl_pcksrep DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PACK'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Packing List shortage'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PACK_ALOG1_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PACK_ALOG1_01'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.

    METHODS constructor.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.



CLASS ZCL_PCKSREP IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
        severity = if_bali_constants=>c_severity_status
        text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.

    TRY.
        application_log = cl_bali_log=>create_with_header(
                               header = cl_bali_header_setter=>create( object = 'ZAPP_PACK_01_LOG'
                                                                       subobject = 'ZAPP_PACK_01_SUB'
                                                                       external_id = 'Pur. Req. IP' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA : lt_upd    TYPE STANDARD TABLE OF zdt_packing_det,
           ls_upd    TYPE zdt_packing_det,
           lv_stock  TYPE menge_d,
           lv_stock1 TYPE menge_d,
           lv_matnr  TYPE matnr,
           lv_doc    TYPE char10,
           lv_itm    TYPE posnr_vl,
           lv_sal    TYPE vbeln_va,
           lv_sitm   TYPE posnr_va,
           lv_plant  TYPE werks_d.

    SELECT * FROM zcds_planing_rpt_v8 INTO TABLE @DATA(lt_data).
    SORT lt_data BY itemcode shippingpoint comdeldt piority salesdocument salesdocumentitem docentey deliverydocumentitem  bomlevel parent component.
    LOOP AT lt_data INTO DATA(ls_data).
      ls_upd = CORRESPONDING #( ls_data ).
      IF lv_matnr = ls_data-itemcode AND lv_plant = ls_data-shippingpoint..
      ELSE.
        lv_matnr = ls_data-itemcode.
        lv_sal   = ls_data-salesdocument.
        lv_sitm  = ls_data-salesdocumentitem.
        lv_doc   = ls_data-docentey.
        lv_itm   = ls_data-deliverydocumentitem.
        lv_stock = ls_data-fgstock.
        lv_plant = ls_data-shippingpoint.
      ENDIF.
      IF lv_sal = ls_data-salesdocument AND lv_sitm = ls_data-salesdocumentitem AND
         lv_doc = ls_data-docentey      AND lv_itm  = ls_data-deliverydocumentitem.
      ELSE.
        lv_sal   = ls_data-salesdocument.
        lv_sitm  = ls_data-salesdocumentitem.
        lv_itm   = ls_data-deliverydocumentitem.
        lv_doc   = ls_data-docentey.
        lv_stock = lv_stock - lv_stock1.
        CLEAR : lv_stock1.
      ENDIF.
      IF lv_stock GE ls_data-ordqty.
        ls_upd-avlfgstock = ls_data-ordqty.
        lv_stock1 = ls_data-ordqty.
      ELSE.
        ls_upd-avlfgstock = lv_stock.
        lv_stock1 = lv_stock.
      ENDIF.
      ls_upd-balfgstock = lv_stock -  ls_upd-avlfgstock.
      ls_upd-reqdqty = ls_data-bomitemqty * ( ls_upd-ordqty - ls_upd-avlfgstock ).

      APPEND ls_upd TO lt_upd.
      CLEAR : ls_data, ls_upd.
    ENDLOOP.

    CLEAR : lv_stock, lv_stock1, lv_matnr, lv_doc, lv_itm, lv_sal, lv_sitm, lv_plant.
    SORT lt_upd BY child shippingpoint comdeldt piority salesdocument salesdocumentitem docentey deliverydocumentitem bomlevel parent component.
    LOOP AT lt_upd ASSIGNING FIELD-SYMBOL(<fs_upd>) .
      "ls_upd = CORRESPONDING #( ls_data ).
      IF lv_matnr = <fs_upd>-child AND lv_plant = <fs_upd>-shippingpoint.
      ELSE.
        lv_matnr = <fs_upd>-child.
        lv_plant = <fs_upd>-shippingpoint.
        lv_stock = <fs_upd>-totsfgstock.
      ENDIF.
      IF <fs_upd>-reqdqty GT 0.
        IF lv_stock GE <fs_upd>-reqdqty.
          <fs_upd>-avasfgstock = <fs_upd>-reqdqty.
          <fs_upd>-balsfgstock = lv_stock -  <fs_upd>-avasfgstock.
          lv_stock = lv_stock - <fs_upd>-reqdqty.
        ELSE.
          <fs_upd>-avasfgstock = lv_stock.
          <fs_upd>-balsfgstock = lv_stock -  <fs_upd>-avasfgstock.
          lv_stock = 0.
        ENDIF.
      ELSE.
        <fs_upd>-avasfgstock = 0.
        <fs_upd>-balsfgstock = lv_stock -  <fs_upd>-avasfgstock.
      ENDIF.

    ENDLOOP.

    IF lt_upd IS NOT INITIAL.
      SORT lt_upd BY docentey deliverydocumentitem bomlevel parent component.
      SELECT * FROM zdt_packing_det INTO TABLE @DATA(lt_del).
      DELETE zdt_packing_det FROM TABLE @lt_del.
      MODIFY zdt_packing_det FROM TABLE @lt_upd.
    ENDIF.



*-------------------------------------------------------------------------------*
* Planning Report stock calculation
*-------------------------------------------------------------------------------*
    DATA: lt_plan_stock TYPE STANDARD TABLE OF zdt_plan_stock,
          lv_planstock  TYPE p DECIMALS 2.

    SELECT * FROM zdt_plan_stock INTO TABLE @DATA(lt_test).
    DELETE zdt_plan_stock FROM TABLE @lt_test.

    SELECT * FROM zr_plan_rpt_2_2 INTO TABLE @DATA(lt_plan_rpt_2_2).
    IF sy-subrc EQ 0.
      LOOP AT lt_plan_rpt_2_2 INTO DATA(ls_plan_rpt).

        APPEND INITIAL LINE TO lt_plan_stock ASSIGNING FIELD-SYMBOL(<fs_line>).
        MOVE-CORRESPONDING ls_plan_rpt TO <fs_line> .

        IF ls_plan_rpt-Totalstockqty IS NOT INITIAL.
          lv_planstock =  ls_plan_rpt-Totalstockqty.
        ENDIF.

        IF ls_plan_rpt-opensoqty7 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty7 .
            <fs_line>-opensoqtysnl7 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty7 .
          ELSE.
            <fs_line>-opensoqtysnl7  =  ls_plan_rpt-opensoqty7 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty8 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty8 .
            <fs_line>-opensoqtysnl8 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty8 .
          ELSE.
            <fs_line>-opensoqtysnl8  =  ls_plan_rpt-opensoqty8 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty16 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty16 .
            <fs_line>-opensoqtysnl16 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty16 .
          ELSE.
            <fs_line>-opensoqtysnl16 =  ls_plan_rpt-opensoqty16 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty23 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty23 .
            <fs_line>-opensoqtysnl23 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty23 .
          ELSE.
            <fs_line>-opensoqtysnl23  =  ls_plan_rpt-opensoqty23 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty31 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty31 .
            <fs_line>-opensoqtysnl7 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty31 .
          ELSE.
            <fs_line>-opensoqtysnl31  =  ls_plan_rpt-opensoqty31 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty39 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty39 .
            <fs_line>-opensoqtysnl39 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty39 .
          ELSE.
            <fs_line>-opensoqtysnl39  =  ls_plan_rpt-opensoqty39 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty47 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty47 .
            <fs_line>-opensoqtysnl47 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty47 .
          ELSE.
            <fs_line>-opensoqtysnl47  =  ls_plan_rpt-opensoqty47 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty55 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty55 .
            <fs_line>-opensoqtysnl55 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty55 .
          ELSE.
            <fs_line>-opensoqtysnl55  =  ls_plan_rpt-opensoqty55 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty63 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty63 .
            <fs_line>-opensoqtysnl63 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty63 .
          ELSE.
            <fs_line>-opensoqtysnl63  =  ls_plan_rpt-opensoqty63 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty71 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty71 .
            <fs_line>-opensoqtysnl71 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty71 .
          ELSE.
            <fs_line>-opensoqtysnl71  =  ls_plan_rpt-opensoqty71 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty366 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty366 .
            <fs_line>-opensoqtysnl366 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty366 .
          ELSE.
            <fs_line>-opensoqtysnl366  =  ls_plan_rpt-opensoqty366 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

      ENDLOOP.

      IF lt_plan_stock[] IS NOT INITIAL.
        COMMIT ENTITIES BEGIN .
        MODIFY zdt_plan_stock FROM TABLE @lt_plan_stock.
        COMMIT ENTITIES END.
      ENDIF.


    ENDIF.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA : lt_upd    TYPE STANDARD TABLE OF zdt_packing_det,
           ls_upd    TYPE zdt_packing_det,
           lv_stock  TYPE menge_d,
           lv_stock1 TYPE menge_d,
           lv_matnr  TYPE matnr,
           lv_doc    TYPE char10,
           lv_itm    TYPE posnr_vl,
           lv_sal    TYPE vbeln_va,
           lv_sitm   TYPE posnr_va,
           lv_plant  TYPE werks_d.

    SELECT * FROM zcds_planing_rpt_v8 INTO TABLE @DATA(lt_data).
    SORT lt_data BY itemcode shippingpoint comdeldt piority salesdocument salesdocumentitem docentey deliverydocumentitem  bomlevel parent component.
    LOOP AT lt_data INTO DATA(ls_data).
      ls_upd = CORRESPONDING #( ls_data ).
      IF lv_matnr = ls_data-itemcode AND lv_plant = ls_data-shippingpoint.
      ELSE.
        lv_matnr = ls_data-itemcode.
        lv_sal   = ls_data-salesdocument.
        lv_sitm  = ls_data-salesdocumentitem.
        lv_doc   = ls_data-docentey.
        lv_itm   = ls_data-deliverydocumentitem.
        lv_stock = ls_data-fgstock.
        lv_plant = ls_data-shippingpoint.
      ENDIF.
      IF lv_sal = ls_data-salesdocument AND lv_sitm = ls_data-salesdocumentitem AND
         lv_doc = ls_data-docentey      AND lv_itm  = ls_data-deliverydocumentitem.
      ELSE.
        lv_sal   = ls_data-salesdocument.
        lv_sitm  = ls_data-salesdocumentitem.
        lv_itm   = ls_data-deliverydocumentitem.
        lv_doc   = ls_data-docentey.
        lv_stock = lv_stock - lv_stock1.
        CLEAR : lv_stock1.
      ENDIF.
      IF lv_stock GE ls_data-ordqty.
        ls_upd-avlfgstock = ls_data-ordqty.
        lv_stock1 = ls_data-ordqty.
      ELSE.
        ls_upd-avlfgstock = lv_stock.
        lv_stock1 = lv_stock.
      ENDIF.
      ls_upd-balfgstock = lv_stock -  ls_upd-avlfgstock.
      ls_upd-reqdqty = ls_data-bomitemqty * ( ls_upd-ordqty - ls_upd-avlfgstock ).

      APPEND ls_upd TO lt_upd.
      CLEAR : ls_data, ls_upd.
    ENDLOOP.

    CLEAR : lv_stock, lv_stock1, lv_matnr, lv_doc, lv_itm, lv_sal, lv_sitm, lv_plant.
    SORT lt_upd BY child shippingpoint comdeldt piority salesdocument salesdocumentitem docentey deliverydocumentitem bomlevel parent component.
    LOOP AT lt_upd ASSIGNING FIELD-SYMBOL(<fs_upd>) .
      "ls_upd = CORRESPONDING #( ls_data ).
      IF lv_matnr = <fs_upd>-child AND lv_plant = <fs_upd>-shippingpoint.
      ELSE.
        lv_matnr = <fs_upd>-child.
        lv_plant = <fs_upd>-shippingpoint.
        lv_stock = <fs_upd>-totsfgstock.
      ENDIF.
      IF <fs_upd>-reqdqty GT 0.
        IF lv_stock GE <fs_upd>-reqdqty.
          <fs_upd>-avasfgstock = <fs_upd>-reqdqty.
          <fs_upd>-balsfgstock = lv_stock -  <fs_upd>-avasfgstock.
          lv_stock = lv_stock - <fs_upd>-reqdqty.
        ELSE.
          <fs_upd>-avasfgstock = lv_stock.
          <fs_upd>-balsfgstock = lv_stock -  <fs_upd>-avasfgstock.
          lv_stock = 0.
        ENDIF.
      ELSE.
        <fs_upd>-avasfgstock = 0.
        <fs_upd>-balsfgstock = lv_stock -  <fs_upd>-avasfgstock.
      ENDIF.

    ENDLOOP.

    IF lt_upd IS NOT INITIAL.
      SORT lt_upd BY docentey deliverydocumentitem bomlevel parent component.
      SELECT * FROM zdt_packing_det INTO TABLE @DATA(lt_del).
      DELETE zdt_packing_det FROM TABLE @lt_del.
      MODIFY zdt_packing_det FROM TABLE @lt_upd.
    ENDIF.


*-------------------------------------------------------------------------------*
* Planning Report stock calculation
*-------------------------------------------------------------------------------*
    DATA: lt_plan_stock TYPE STANDARD TABLE OF zdt_plan_stock,
          lv_planstock  TYPE p DECIMALS 2.

    SELECT * FROM zr_plan_rpt_2_2 INTO TABLE @DATA(lt_plan_rpt_2_2).
    IF sy-subrc EQ 0.
      LOOP AT lt_plan_rpt_2_2 INTO DATA(ls_plan_rpt).

        APPEND INITIAL LINE TO lt_plan_stock ASSIGNING FIELD-SYMBOL(<fs_line>).
        MOVE-CORRESPONDING ls_plan_rpt TO <fs_line> .

        IF ls_plan_rpt-sfgonhand IS NOT INITIAL.
          lv_planstock =  ls_plan_rpt-sfgonhand.
        ENDIF.

        IF ls_plan_rpt-opensoqty7 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty7 .
            <fs_line>-opensoqtysnl7 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty7 .
          ELSE.
            <fs_line>-opensoqtysnl7  =  ls_plan_rpt-opensoqty7 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty8 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty8 .
            <fs_line>-opensoqtysnl8 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty8 .
          ELSE.
            <fs_line>-opensoqtysnl8  =  ls_plan_rpt-opensoqty8 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty16 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty16 .
            <fs_line>-opensoqtysnl16 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty16 .
          ELSE.
            <fs_line>-opensoqtysnl16 =  ls_plan_rpt-opensoqty16 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty23 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty23 .
            <fs_line>-opensoqtysnl23 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty23 .
          ELSE.
            <fs_line>-opensoqtysnl23  =  ls_plan_rpt-opensoqty23 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty31 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty31 .
            <fs_line>-opensoqtysnl7 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty31 .
          ELSE.
            <fs_line>-opensoqtysnl31  =  ls_plan_rpt-opensoqty31 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty39 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty39 .
            <fs_line>-opensoqtysnl39 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty39 .
          ELSE.
            <fs_line>-opensoqtysnl39  =  ls_plan_rpt-opensoqty39 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty47 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty47 .
            <fs_line>-opensoqtysnl47 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty47 .
          ELSE.
            <fs_line>-opensoqtysnl47  =  ls_plan_rpt-opensoqty47 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty55 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty55 .
            <fs_line>-opensoqtysnl55 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty55 .
          ELSE.
            <fs_line>-opensoqtysnl55  =  ls_plan_rpt-opensoqty55 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty63 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty63 .
            <fs_line>-opensoqtysnl63 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty63 .
          ELSE.
            <fs_line>-opensoqtysnl63  =  ls_plan_rpt-opensoqty63 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty71 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty71 .
            <fs_line>-opensoqtysnl71 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty71 .
          ELSE.
            <fs_line>-opensoqtysnl71  =  ls_plan_rpt-opensoqty71 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

        IF ls_plan_rpt-opensoqty366 IS NOT INITIAL .
          IF lv_planstock > ls_plan_rpt-opensoqty366 .
            <fs_line>-opensoqtysnl366 = 0.
            lv_planstock = lv_planstock - ls_plan_rpt-opensoqty366 .
          ELSE.
            <fs_line>-opensoqtysnl366  =  ls_plan_rpt-opensoqty366 - lv_planstock .
            CLEAR lv_planstock.
          ENDIF.
        ENDIF.

      ENDLOOP.

      IF lt_plan_stock[] IS NOT INITIAL.
        COMMIT ENTITIES BEGIN .
        MODIFY zdt_plan_stock FROM TABLE @lt_plan_stock.
        COMMIT ENTITIES END.
      ENDIF.


    ENDIF.

  ENDMETHOD.
ENDCLASS.
