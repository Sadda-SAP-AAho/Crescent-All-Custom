CLASS zcl_sord_detail_batch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'SORD'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'SORD DATA'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOGS_01'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.



CLASS ZCL_SORD_DETAIL_BATCH IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
        severity = if_bali_constants=>c_severity_status
        text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log
*                                                 assign_to_current_appl_job = abap_true
                                                 ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.
    TRY.
        application_log = cl_bali_log=>create_with_header(
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_SORD_01_LOG'
                                                                      subobject   = 'ZAPP_SORD_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA: lv_price  TYPE dmbtr,
          lv_date_l TYPE datn,
          lv_date_h TYPE datn,
          lv_time_l TYPE timn,
          lv_time_h TYPE timn.
    DATA: lv_timestamp_l TYPE timestamp.


    CLEAR: lv_price,lv_timestamp_l,lv_date_h,lv_date_l,lv_time_h,lv_time_l.
*//------------------Get Date Time from Time Stamp -----------//
    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP DATA(lv_timestamp) TIME ZONE '' ."cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE '' INTO DATE lv_date_h TIME lv_time_h.
***    TRY.
***        CONVERT DATE lv_date_h TIME lv_time_h
***                INTO TIME STAMP lv_timestamp TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
***      CATCH cx_abap_context_info_error.
***    ENDTRY.

    IF lv_date_h IS NOT INITIAL .
      IF lv_time_h < '020000'.
        lv_timestamp_l = lv_timestamp - 1020000 .
      ELSE.
        lv_timestamp_l = lv_timestamp - 20000.
      ENDIF.
    ENDIF.

*//------------------ Data selection -----------//

    CHECK lv_timestamp_l IS NOT INITIAL AND
          lv_timestamp IS NOT INITIAL .

    SELECT a~salesorder,a~salesorderitem,a~yy1_sd_sord_rate_sdi,b~conditionamount,
           b~conditionratevalue, b~conditiontype, c~additionalmaterialgroup1name,
           a~yy1_sd_sord_addmatgrp1_sdi,a~additionalmaterialgroup1,d~consumptiontaxctrlcode,
           e~consumptiontaxctrlcodetext1,a~yy1_sd_sord_material_d_sdi , a~yy1_sd_sord_discount_sdi ,
           a~yy1_sd_sord_freight_sdi , a~yy1_sd_sord_po_sdi , a~purchaseorderbycustomer
    FROM i_salesorderitem AS a
    LEFT OUTER JOIN i_salesorderitempricingelement  AS b ON a~salesorder = b~salesorder
                                                         AND a~salesorderitem = b~salesorderitem
*                                                       where b~ConditionType IN ( 'ZPR0' , 'ZPR1' )
    LEFT OUTER JOIN i_additionalmaterialgroup1text AS c ON c~additionalmaterialgroup1 = a~additionalmaterialgroup1
    LEFT OUTER JOIN i_productplantbasic            AS d ON d~product = a~product AND d~plant = a~plant
    LEFT OUTER JOIN i_ae_cnsmpntaxctrlcodetxt      AS e ON e~consumptiontaxctrlcode = d~consumptiontaxctrlcode
                                                           AND e~language = 'E' AND e~countrycode = 'IN'
    INNER JOIN i_salesorder                        AS f ON a~salesorder = f~salesorder AND
                                                           f~lastchangedatetime BETWEEN @lv_timestamp_l AND @lv_timestamp
    INTO TABLE @DATA(lt_tab).
    LOOP AT lt_tab ASSIGNING FIELD-SYMBOL(<fs>).
      IF <fs>-conditiontype = 'ZPR0' OR <fs>-conditiontype = 'ZPR1'.

        READ TABLE lt_tab INTO DATA(ls_zspc) WITH KEY salesorder = <fs>-salesorder
                                                      salesorderitem = <fs>-salesorderitem
                                                      conditiontype = 'ZSPC'.
        lv_price = <fs>-conditionratevalue + ls_zspc-conditionratevalue.


        IF   <fs>-yy1_sd_sord_rate_sdi NE lv_price.
          <fs>-yy1_sd_sord_rate_sdi = lv_price.
          DATA(lv_flag) = 'X'.
        ENDIF.
        CLEAR: ls_zspc.

      ENDIF.
      IF <fs>-yy1_sd_sord_addmatgrp1_sdi NE <fs>-additionalmaterialgroup1name.
        <fs>-yy1_sd_sord_addmatgrp1_sdi  = <fs>-additionalmaterialgroup1name.
        DATA(lv_flag1) = 'X'.
      ENDIF.

      IF <fs>-yy1_sd_sord_material_d_sdi NE <fs>-consumptiontaxctrlcodetext1.
        <fs>-yy1_sd_sord_material_d_sdi  = <fs>-consumptiontaxctrlcodetext1.
        DATA(lv_flag2) = 'X'.
      ENDIF.

      IF <fs>-conditiontype = 'ZK07' OR <fs>-conditiontype = 'ZK08' OR <fs>-conditiontype = 'D100'.
        IF <fs>-yy1_sd_sord_discount_sdi NE <fs>-conditionamount.
          <fs>-yy1_sd_sord_discount_sdi = <fs>-conditionamount.
          DATA(lv_flag3) = 'X'.
        ENDIF.
      ENDIF.

      IF <fs>-conditiontype = 'ZFIP' OR <fs>-conditiontype = 'ZFIV' OR <fs>-conditiontype = 'ZPFP'
         OR <fs>-conditiontype = 'ZPFV' OR  <fs>-conditiontype = 'ZXIV' OR <fs>-conditiontype = 'ZXIP'.
        IF <fs>-yy1_sd_sord_freight_sdi NE <fs>-conditionamount.
          <fs>-yy1_sd_sord_freight_sdi = <fs>-conditionamount.
          DATA(lv_flag4) = 'X'.
        ENDIF.
      ENDIF.

"++am_PO No per Item Issue dated. 12/06/25

    IF <fs>-yy1_sd_sord_po_sdi NE <fs>-PurchaseOrderByCustomer.
        <fs>-yy1_sd_sord_po_sdi  = <fs>-PurchaseOrderByCustomer.
        DATA(lv_flag7) = 'X'.
      ENDIF.

"++am_PO No per Item Issue dated. 12/06/25

      IF lv_flag = 'X'.
        MODIFY ENTITIES OF i_salesordertp
         ENTITY salesorderitem
           UPDATE
             FIELDS ( yy1_sd_sord_rate_sdi )
             WITH VALUE #( ( yy1_sd_sord_rate_sdi   = <fs>-yy1_sd_sord_rate_sdi
                             %key-salesorder            = <fs>-salesorder
                             %key-salesorderitem        = <fs>-salesorderitem ) )
         FAILED   DATA(ls_failed)
         REPORTED DATA(ls_reported).
      ENDIF.
      IF lv_flag1 = 'X'.
        MODIFY ENTITIES OF i_salesordertp
      ENTITY salesorderitem
        UPDATE
          FIELDS ( yy1_sd_sord_addmatgrp1_sdi )
          WITH VALUE #( ( yy1_sd_sord_addmatgrp1_sdi = <fs>-additionalmaterialgroup1name
                          %key-salesorder            = <fs>-salesorder
                          %key-salesorderitem        = <fs>-salesorderitem ) )
      FAILED   DATA(ls_failed1)
      REPORTED DATA(ls_reported1).
      ENDIF.

      IF lv_flag2 = 'X'.
        MODIFY ENTITIES OF i_salesordertp
      ENTITY salesorderitem
        UPDATE
          FIELDS ( yy1_sd_sord_material_d_sdi )
          WITH VALUE #( ( yy1_sd_sord_material_d_sdi = <fs>-consumptiontaxctrlcodetext1
                          %key-salesorder            = <fs>-salesorder
                          %key-salesorderitem        = <fs>-salesorderitem ) )
      FAILED   DATA(ls_failed2)
      REPORTED DATA(ls_reported2).
      ENDIF.

      IF lv_flag3 = 'X'.
        MODIFY ENTITIES OF i_salesordertp
         ENTITY salesorderitem
           UPDATE
             FIELDS ( yy1_sd_sord_discount_sdi )
             WITH VALUE #( ( yy1_sd_sord_discount_sdi   = <fs>-yy1_sd_sord_discount_sdi
                             %key-salesorder            = <fs>-salesorder
                             %key-salesorderitem        = <fs>-salesorderitem ) )
         FAILED   DATA(ls_failed3)
         REPORTED DATA(ls_reported3).
      ENDIF.

      IF lv_flag4 = 'X'.
        MODIFY ENTITIES OF i_salesordertp
         ENTITY salesorderitem
           UPDATE
             FIELDS ( yy1_sd_sord_freight_sdi )
             WITH VALUE #( ( yy1_sd_sord_freight_sdi  = <fs>-yy1_sd_sord_freight_sdi
                             %key-salesorder            = <fs>-salesorder
                             %key-salesorderitem        = <fs>-salesorderitem ) )
         FAILED   DATA(ls_failed4)
         REPORTED DATA(ls_reported4).
      ENDIF.

"++am_PO No per Item Issue dt. 12/06/25

      IF lv_flag7 = 'X'.
        MODIFY ENTITIES OF i_salesordertp
         ENTITY salesorderitem
           UPDATE
             FIELDS ( yy1_sd_sord_po_sdi )
             WITH VALUE #( ( yy1_sd_sord_po_sdi  = <fs>-PurchaseOrderByCustomer
                             %key-salesorder            = <fs>-salesorder
                             %key-salesorderitem        = <fs>-salesorderitem ) )
         FAILED   DATA(ls_failed7)
         REPORTED DATA(ls_reported7).
      ENDIF.

"++am_PO No per Item Issue dt. 12/06/25

      CLEAR: lv_flag,lv_flag2,lv_flag3,lv_flag4,
             lv_flag1,lv_flag7.

      COMMIT ENTITIES BEGIN
        RESPONSE OF i_salesordertp
          FAILED   DATA(ls_save_failed)
          REPORTED DATA(ls_save_reported).
      COMMIT ENTITIES END.

    ENDLOOP.



*****Regarding pattern sales invoice**
DATA: Lastchngedt TYPE datn,
      lv_time TYPE timn.
TRY.
    CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp1) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp1 TIME ZONE 'INDIA' INTO DATE Lastchngedt TIME lv_time.

    SELECT a~salesorder,a~salesorderitem,a~yy1_sd_sord_artno_sdi,
           a~yy1_sd_sord_drawingno_sdi,b~artno,b~drawno
    FROM i_salesorderitem AS a
    INNER JOIN zi_matfld as b on a~Product = b~Product
    INNER JOIN i_salesorder   AS c ON a~salesorder = c~salesorder AND
                                                     c~lastchangedatetime BETWEEN @lv_timestamp_l AND @lv_timestamp


    INTO TABLE @DATA(lt_tab1).

   SELECT a~salesorder,a~salesorderitem,a~yy1_sd_sord_artno_sdi,
           a~yy1_sd_sord_drawingno_sdi,b~artno,b~drawno
    FROM i_salesorderitem AS a
    INNER JOIN zi_matfld as b on a~Product = b~Product
    INNER JOIN i_salesorder   AS c ON a~salesorder = c~salesorder AND
                                                     b~Lastchngedt = @Lastchngedt


    INTO TABLE @DATA(lt_tab2).

    append lines of lt_tab1 to lt_tab2.
    Sort lt_tab2 by salesorder salesorderitem.
    DELETE ADJACENT DUPLICATES FROM lt_tab2 COMPARING salesorder salesorderitem.

     LOOP AT lt_tab2 ASSIGNING FIELD-SYMBOL(<fs1>).
      IF <fs1>-yy1_sd_sord_artno_sdi NE <fs1>-Artno.
        <fs1>-yy1_sd_sord_artno_sdi  = <fs1>-Artno.
        DATA(lv_flag5) = 'X'.
      ENDIF.

     IF <fs1>-yy1_sd_sord_drawingno_sdi NE <fs1>-Drawno.
        <fs1>-yy1_sd_sord_drawingno_sdi  = <fs1>-Drawno.
        DATA(lv_flag6) = 'X'.
      ENDIF.

     IF lv_flag5 = 'X'.
        MODIFY ENTITIES OF i_salesordertp
      ENTITY salesorderitem
        UPDATE
          FIELDS ( yy1_sd_sord_artno_sdi )
          WITH VALUE #( ( yy1_sd_sord_artno_sdi = <fs1>-Artno
                          %key-salesorder            = <fs1>-salesorder
                          %key-salesorderitem        = <fs1>-salesorderitem ) )
      FAILED   DATA(ls_failed5)
      REPORTED DATA(ls_reported5).
      ENDIF.

     IF lv_flag6 = 'X'.
        MODIFY ENTITIES OF i_salesordertp
      ENTITY salesorderitem
        UPDATE
          FIELDS ( yy1_sd_sord_drawingno_sdi )
          WITH VALUE #( ( yy1_sd_sord_drawingno_sdi = <fs1>-Drawno
                          %key-salesorder            = <fs1>-salesorder
                          %key-salesorderitem        = <fs1>-salesorderitem ) )
      FAILED   DATA(ls_failed6)
      REPORTED DATA(ls_reported6).
      ENDIF.

      COMMIT ENTITIES BEGIN
      RESPONSE OF i_salesordertp
        FAILED   DATA(ls_save_failed1)
        REPORTED DATA(ls_save_reported1).
      COMMIT ENTITIES END.

     CLEAR: lv_flag5,lv_flag6.
    ENDLOOP.



*****End of pattern sales invoice**
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.

    TRY.
        "
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner) " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
