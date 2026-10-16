CLASS zcl_payment_stat_batch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PAY'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'PAY DATA'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PAYSTAT_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PAYSTAT_01'.

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



CLASS ZCL_PAYMENT_STAT_BATCH IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_PAYSTAT_01_LOG'
                                                                      subobject   = 'ZAPP_PAYSTAT_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    TYPES: BEGIN OF ty_status,
             accdoc    TYPE belnr_d,
             gjahr     TYPE gjahr,
             bukrs     TYPE bukrs,
             status    TYPE char25,
             utr       TYPE char25,
             processed TYPE flag,
             createdon TYPE datum,
             createdat TYPE uzeit,
             remarks   TYPE char200,
           END OF ty_status.

    DATA: lv_filecontent TYPE string,
          lv_file_temp1  TYPE string,
          lv_file_temp2  TYPE string,
          l_mod          TYPE int8,
          lt_status      TYPE TABLE OF ty_status,
          ls_status      TYPE ty_status.

    DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
          lv_cid TYPE abp_behv_cid.
    DATA: lv_utr    TYPE c LENGTH 18,
          lv_doctxt TYPE text50,
          lt_paylog TYPE TABLE OF zdt_payst_log.

    CLEAR: lv_filecontent, lv_file_temp1,lv_file_temp2 .

*-----------------------------------------------------------------------------------
    SELECT a~filename, a~filecontent
           FROM zdt_payst_icici AS a
           WHERE processed <> 'X'
     INTO TABLE @DATA(lt_logdata).

    LOOP AT lt_logdata INTO DATA(ls_logdata).

      lv_filecontent = ls_logdata-filecontent.
      DO .
        DATA(lv_index) = sy-index.
        IF lv_filecontent IS INITIAL.
          EXIT.
        ENDIF.

        SPLIT lv_filecontent AT '|' INTO lv_file_temp1 lv_file_temp2.
        l_mod = lv_index MOD 17.
        CASE l_mod.
          WHEN 2.
            DATA(l_len) = strlen( lv_file_temp1 ).
            IF l_len EQ 18.
              ls_status-accdoc = lv_file_temp1+0(10).
              ls_status-gjahr = lv_file_temp1+10(4).
              ls_status-bukrs = lv_file_temp1+14(4).
            ENDIF.
          WHEN 14.
            ls_status-status = lv_file_temp1.
          WHEN 15.
            ls_status-utr = lv_file_temp1.
          WHEN 0.
            ls_status-remarks = lv_file_temp1.
            ls_status-createdon = sy-datum.
            ls_status-createdat = sy-uzeit.
            APPEND ls_status TO lt_status.
            CLEAR ls_status.
            IF lv_file_temp2 IS NOT INITIAL.
              lv_file_temp2 = '|' && lv_file_temp2.
            ENDIF.
        ENDCASE.

        IF lv_file_temp2 IS NOT INITIAL.
          lv_filecontent = lv_file_temp2.
        ELSEIF lv_file_temp2 IS INITIAL.
          CLEAR: lv_filecontent,ls_status.
        ENDIF.
      ENDDO.

      LOOP AT lt_status ASSIGNING FIELD-SYMBOL(<fs_status>).
        IF <fs_status>-status = 'Paid'.
*---- Journal Update
          APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).

* APAR Item Control
          DATA lt_glitem LIKE <je>-%param-_glitems.
          DATA ls_glitem LIKE LINE OF lt_glitem.
          DATA ls_glitem_control LIKE ls_glitem-%control.

          ls_glitem_control-glaccountlineitem   = if_abap_behv=>mk-on.
          ls_glitem_control-documentitemtext    = if_abap_behv=>mk-on.
          ls_glitem_control-assignmentreference = if_abap_behv=>mk-on.

          SELECT SINGLE referencedocumentitem
          FROM i_journalentryitem
          WHERE companycode        = @<fs_status>-bukrs AND
                fiscalyear         = @<fs_status>-gjahr AND
                accountingdocument = @<fs_status>-accdoc AND
                ledger             = '0L' AND
                supplier           IS INITIAL AND
                housebank          IS NOT INITIAL
          INTO @DATA(ls_gl_item) .

*    "CHANGE BO
          <je>-companycode        = <fs_status>-bukrs.
          <je>-fiscalyear         = <fs_status>-gjahr.
          <je>-accountingdocument = <fs_status>-accdoc.
          <je>-%param = VALUE #(
          _glitems = VALUE #( ( glaccountlineitem   = ls_gl_item
                                documentitemtext    = <fs_status>-utr
                                assignmentreference = <fs_status>-utr
                                %control            = ls_glitem_control ) ) ).

          MODIFY ENTITIES OF i_journalentrytp
                       ENTITY journalentry
                       EXECUTE change FROM lt_je
                       FAILED DATA(ls_failed_deep)
                       REPORTED DATA(ls_reported_deep)
                       MAPPED DATA(ls_mapped_deep).
          IF ls_failed_deep IS INITIAL.
            COMMIT ENTITIES BEGIN
       RESPONSE OF i_journalentrytp
         " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED DATA(lt_commit_failed)
       " TODO: variable is assigned but never used (ABAP cleaner)
       REPORTED DATA(lt_commit_reported).
            COMMIT ENTITIES END.
            <fs_status>-processed = 'X'.
            UPDATE zdt_payment_head SET utr = @<fs_status>-utr,status = 'UTR Generated'
            WHERE accountingdoc = @<fs_status>-accdoc
            AND fiscalyear = @<fs_status>-gjahr AND companycode = @<fs_status>-bukrs.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ELSE.
            ROLLBACK ENTITIES.

            UPDATE zdt_payment_head SET utr = @<fs_status>-utr,status = 'UTR Generated'
            WHERE accountingdoc = @<fs_status>-accdoc
            AND fiscalyear = @<fs_status>-gjahr AND companycode = @<fs_status>-bukrs.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDIF.
        ELSE.
          UPDATE zdt_payment_head SET appr1comment = @<fs_status>-remarks,status = 'Failed'
          WHERE accountingdoc = @<fs_status>-accdoc
          AND fiscalyear = @<fs_status>-gjahr AND companycode = @<fs_status>-bukrs.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.
        ENDIF.
        CLEAR: lt_je[],ls_glitem_control,ls_gl_item.
      ENDLOOP.

      lt_paylog[] = CORRESPONDING #( lt_status[] ).
      UPDATE zdt_payst_icici SET processed = 'X' WHERE filename = @ls_logdata-filename.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
      MODIFY zdt_payst_log FROM TABLE @lt_paylog.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
      CLEAR: lt_status[],lt_paylog[].
      CLEAR: lt_je[].
    ENDLOOP.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF ty_status,
             accdoc    TYPE belnr_d,
             gjahr     TYPE gjahr,
             bukrs     TYPE bukrs,
             status    TYPE char25,
             utr       TYPE char25,
             processed TYPE flag,
             createdon TYPE datum,
             createdat TYPE uzeit,
             remarks   TYPE char200,
           END OF ty_status.

    DATA: lv_filecontent TYPE string,
          lv_file_temp1  TYPE string,
          lv_file_temp2  TYPE string,
          l_mod          TYPE int8,
          lt_status      TYPE TABLE OF ty_status,
          ls_status      TYPE ty_status.

    DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
          lv_cid TYPE abp_behv_cid.
    DATA: lv_utr    TYPE c LENGTH 18,
          lv_doctxt TYPE text50,
          lt_paylog TYPE TABLE OF zdt_payst_log.

    CLEAR: lv_filecontent, lv_file_temp1,lv_file_temp2 .

*-----------------------------------------------------------------------------------
    SELECT a~filename, a~filecontent
           FROM zdt_payst_icici AS a
           WHERE processed <> 'X'
     INTO TABLE @DATA(lt_logdata).

    LOOP AT lt_logdata INTO DATA(ls_logdata).

      lv_filecontent = ls_logdata-filecontent.
      DO .
        DATA(lv_index) = sy-index.
        IF lv_filecontent IS INITIAL.
          EXIT.
        ENDIF.

        SPLIT lv_filecontent AT '|' INTO lv_file_temp1 lv_file_temp2.
        l_mod = lv_index MOD 17.
        CASE l_mod.
          WHEN 2.
            DATA(l_len) = strlen( lv_file_temp1 ).
            IF l_len EQ 18.
              ls_status-accdoc = lv_file_temp1+0(10).
              ls_status-gjahr = lv_file_temp1+10(4).
              ls_status-bukrs = lv_file_temp1+14(4).
            ENDIF.
          WHEN 14.
            ls_status-status = lv_file_temp1.
          WHEN 15.
            ls_status-utr = lv_file_temp1.
          WHEN 0.
            ls_status-remarks = lv_file_temp1.
            ls_status-createdon = sy-datum.
            ls_status-createdat = sy-uzeit.
            APPEND ls_status TO lt_status.
            CLEAR ls_status.
            IF lv_file_temp2 IS NOT INITIAL.
              lv_file_temp2 = '|' && lv_file_temp2.
            ENDIF.
        ENDCASE.

        IF lv_file_temp2 IS NOT INITIAL.
          lv_filecontent = lv_file_temp2.
        ELSEIF lv_file_temp2 IS INITIAL.
          CLEAR: lv_filecontent,ls_status.
        ENDIF.
      ENDDO.

      LOOP AT lt_status ASSIGNING FIELD-SYMBOL(<fs_status>).
        IF <fs_status>-status = 'Paid'.
*---- Journal Update
          APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).

* APAR Item Control
          DATA lt_glitem LIKE <je>-%param-_glitems.
          DATA ls_glitem LIKE LINE OF lt_glitem.
          DATA ls_glitem_control LIKE ls_glitem-%control.

          ls_glitem_control-glaccountlineitem   = if_abap_behv=>mk-on.
          ls_glitem_control-documentitemtext    = if_abap_behv=>mk-on.
          ls_glitem_control-assignmentreference = if_abap_behv=>mk-on.

          SELECT SINGLE referencedocumentitem
          FROM i_journalentryitem
          WHERE companycode        = @<fs_status>-bukrs AND
                fiscalyear         = @<fs_status>-gjahr AND
                accountingdocument = @<fs_status>-accdoc AND
                ledger             = '0L' AND
                supplier           IS INITIAL AND
                housebank          IS NOT INITIAL
          INTO @DATA(ls_gl_item) .

*    "CHANGE BO
          <je>-companycode        = <fs_status>-bukrs.
          <je>-fiscalyear         = <fs_status>-gjahr.
          <je>-accountingdocument = <fs_status>-accdoc.
          <je>-%param = VALUE #(
          _glitems = VALUE #( ( glaccountlineitem   = ls_gl_item
                                documentitemtext    = <fs_status>-utr
                                assignmentreference = <fs_status>-utr
                                %control            = ls_glitem_control ) ) ).

          MODIFY ENTITIES OF i_journalentrytp
                       ENTITY journalentry
                       EXECUTE change FROM lt_je
                       FAILED DATA(ls_failed_deep)
                       REPORTED DATA(ls_reported_deep)
                       MAPPED DATA(ls_mapped_deep).
          IF ls_failed_deep IS INITIAL.
            COMMIT ENTITIES BEGIN
         RESPONSE OF i_journalentrytp
           " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_commit_failed)
         " TODO: variable is assigned but never used (ABAP cleaner)
         REPORTED DATA(lt_commit_reported).
            COMMIT ENTITIES END.
            <fs_status>-processed = 'X'.
            UPDATE zdt_payment_head SET utr = @<fs_status>-utr,status = 'UTR Generated'
            WHERE accountingdoc = @<fs_status>-accdoc
            AND fiscalyear = @<fs_status>-gjahr AND companycode = @<fs_status>-bukrs.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ELSE.
            ROLLBACK ENTITIES.
            UPDATE zdt_payment_head SET utr = @<fs_status>-utr,status = 'UTR Generated'
            WHERE accountingdoc = @<fs_status>-accdoc
            AND fiscalyear = @<fs_status>-gjahr AND companycode = @<fs_status>-bukrs.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDIF.
        ELSE.
          UPDATE zdt_payment_head SET appr1comment = @<fs_status>-remarks,status = 'Failed'
          WHERE accountingdoc = @<fs_status>-accdoc
          AND fiscalyear = @<fs_status>-gjahr AND companycode = @<fs_status>-bukrs.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.
        ENDIF.
        CLEAR: lt_je[],ls_glitem_control,ls_gl_item.
      ENDLOOP.

      lt_paylog[] = CORRESPONDING #( lt_status[] ).
      UPDATE zdt_payst_icici SET processed = 'X' WHERE filename = @ls_logdata-filename.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
      MODIFY zdt_payst_log FROM TABLE @lt_paylog.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
      CLEAR: lt_status[],lt_paylog[].
      CLEAR: lt_je[].
    ENDLOOP.


***    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
***
***    TRY.
***        "
***        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
***        out->write( |Finished| ).
***        "
***      CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner) " TODO: variable is assigned but never used (ABAP cleaner)
***    ENDTRY.

  ENDMETHOD.
ENDCLASS.
