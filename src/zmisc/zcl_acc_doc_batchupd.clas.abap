CLASS zcl_acc_doc_batchupd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'ACDOCUPD'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'AccDocUpdat'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_01'.

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



CLASS ZCL_ACC_DOC_BATCHUPD IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_ACDOC_01_LOG'
                                                                      subobject   = 'ZAPP_ACDOC_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA: lv_text TYPE string.


*//--------------------------------------------------------------------------//*
* Account Posting Update for Bank Charges Entry
*//--------------------------------------------------------------------------//*

    SELECT *
       FROM zdt_bnk_ent_hdr
       WHERE belnr IS INITIAL AND
             accpostref IS NOT INITIAL
       INTO TABLE @DATA(lt_bank_accpost).
    IF lt_bank_accpost IS NOT INITIAL.

      LOOP AT lt_bank_accpost ASSIGNING FIELD-SYMBOL(<lfs_acc_post>).
        lv_text = <lfs_acc_post>-accpostref .

        SELECT SINGLE *
            FROM i_journalentry
            WHERE documentreferenceid = @<lfs_acc_post>-bnkadviceno+0(16)
            AND   accountingdocumentheadertext = @lv_text
            INTO  @DATA(ls_journal).
        IF sy-subrc = 0.
          <lfs_acc_post>-belnr = ls_journal-accountingdocument.
          <lfs_acc_post>-gjahr = ls_journal-fiscalyear.
        ENDIF.
      ENDLOOP.
    ENDIF.

    COMMIT ENTITIES BEGIN.
    MODIFY zdt_bnk_ent_hdr FROM TABLE @lt_bank_accpost .
    COMMIT ENTITIES END.

*//--------------------------------------------------------------------------//*
* Account Posting Update for Shipping Bill- RoDTEP
*//--------------------------------------------------------------------------//*

    SELECT *
       FROM zex_shipbill_hdr
       WHERE ( accountdocno IS INITIAL AND
               accpostref IS NOT INITIAL ) OR
             ( accdocnodbk IS INITIAL AND
               accpostrefdbk IS NOT INITIAL )
       INTO TABLE @DATA(lt_ship_accpost).
    IF lt_ship_accpost IS NOT INITIAL.

      LOOP AT lt_ship_accpost ASSIGNING FIELD-SYMBOL(<lfs_ship_accpost>).
        "-- RoDTEP---"
        lv_text = <lfs_ship_accpost>-accpostref .
        SELECT SINGLE *
            FROM i_journalentry
            WHERE documentreferenceid = @<lfs_ship_accpost>-shipping_bill+0(16)
            AND   accountingdocumentheadertext = @lv_text
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_ship_accpost>-accountdocno = ls_journal-accountingdocument.
          <lfs_ship_accpost>-accountdocyr = ls_journal-fiscalyear.
        ENDIF.

        "-- Duty Drawback---"
        lv_text = <lfs_ship_accpost>-accpostrefdbk .
        SELECT SINGLE *
            FROM i_journalentry
            WHERE documentreferenceid = @<lfs_ship_accpost>-shipping_bill+0(16)
            AND   accountingdocumentheadertext = @lv_text
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_ship_accpost>-accdocnodbk = ls_journal-accountingdocument.
          <lfs_ship_accpost>-accdocyrdbk = ls_journal-fiscalyear.
        ENDIF.
      ENDLOOP.
    ENDIF.

    COMMIT ENTITIES BEGIN.
    MODIFY zex_shipbill_hdr FROM TABLE @lt_ship_accpost.
    COMMIT ENTITIES END.

*//--------------------------------------------------------------------------//*
* Account Posting Update for Script Account Post
*//--------------------------------------------------------------------------//*

    SELECT *
       FROM zdt_scriptgn_hdr
       WHERE ( accountdocno IS INITIAL AND
               accpostref IS NOT INITIAL )
       INTO TABLE @DATA(lt_scripgn_accpost).
    IF lt_scripgn_accpost IS NOT INITIAL.

      LOOP AT lt_scripgn_accpost ASSIGNING FIELD-SYMBOL(<lfs_scripgn_accpost>).
        "-- Scrip---"
        lv_text = <lfs_scripgn_accpost>-accpostref .
        SELECT SINGLE *
            FROM i_journalentry
            WHERE documentreferenceid = @<lfs_scripgn_accpost>-scriptno+0(16)
            AND   accountingdocumentheadertext = @lv_text
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_scripgn_accpost>-accountdocno = ls_journal-accountingdocument.
          <lfs_scripgn_accpost>-accountdocyr = ls_journal-fiscalyear.
        ENDIF.
      ENDLOOP.

      COMMIT ENTITIES BEGIN.
      MODIFY zdt_scriptgn_hdr FROM TABLE @lt_scripgn_accpost.
      COMMIT ENTITIES END.

    ENDIF.

*//--------------------------------------------------------------------------//*
* Account Posting Update for Scrip Sales Account Post
*//--------------------------------------------------------------------------//*

    SELECT *
       FROM zdt_scriptsl_hdr
       WHERE ( accdocno IS INITIAL AND
               accpostref IS NOT INITIAL )
       INTO TABLE @DATA(lt_scripsl_accpost).
    IF lt_scripsl_accpost IS NOT INITIAL.

      LOOP AT lt_scripsl_accpost ASSIGNING FIELD-SYMBOL(<lfs_scripsl_accpost>).
        "-- Scrip Sales---"
        lv_text = <lfs_scripsl_accpost>-accpostref .
        SELECT SINGLE *
            FROM i_journalentry
            WHERE documentreferenceid = @<lfs_scripsl_accpost>-scriptsalesno+0(16)
            AND   accountingdocumentheadertext = @lv_text
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_scripsl_accpost>-accdocno = ls_journal-accountingdocument.
          <lfs_scripsl_accpost>-docyear  = ls_journal-fiscalyear.
        ENDIF.
      ENDLOOP.

      COMMIT ENTITIES BEGIN.
      MODIFY zdt_scriptsl_hdr FROM TABLE @lt_scripsl_accpost.
      COMMIT ENTITIES END.

    ENDIF.

*//--------------------------------------------------------------------------//*
* Account Posting Update for LOAN DashboardAccount Post
*//--------------------------------------------------------------------------//*

    SELECT *
       FROM zdt_pcr_hdr
       WHERE ( accountdocno IS INITIAL AND
               accpostref IS NOT INITIAL )
       INTO TABLE @DATA(lt_pcr_accpost).
    IF lt_pcr_accpost IS NOT INITIAL.

      LOOP AT lt_pcr_accpost ASSIGNING FIELD-SYMBOL(<lfs_pcr_accpost>).
        "-- LOAN Post---"
        lv_text = <lfs_pcr_accpost>-accpostref+0(25) .
        SELECT SINGLE *
            FROM i_journalentry
            WHERE documentreferenceid = @<lfs_pcr_accpost>-loanacno+0(16)
            AND   accountingdocumentheadertext = @lv_text
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_pcr_accpost>-accountdocno = ls_journal-accountingdocument.
          <lfs_pcr_accpost>-accountdocyr = ls_journal-fiscalyear.
        ENDIF.
      ENDLOOP.

      COMMIT ENTITIES BEGIN.
      MODIFY zdt_pcr_hdr FROM TABLE @lt_pcr_accpost.
      COMMIT ENTITIES END.

    ENDIF.


*//--------------------------------------------------------------------------//*
* Account Posting Update for LOAN Interest Cockpit
*//--------------------------------------------------------------------------//*
    DATA: lv_text_intcal TYPE i_journalentry-accountingdocumentheadertext.

    SELECT *
       FROM zdt_intcal_hd
       WHERE ( accdocno IS INITIAL AND
               status = 2 )
       INTO TABLE @DATA(lt_intcal_hd).
    IF lt_intcal_hd IS NOT INITIAL.

      LOOP AT lt_intcal_hd ASSIGNING FIELD-SYMBOL(<lfs_intcal_hd>).
        "-- LOAN Post---"
        lv_text_intcal = <lfs_intcal_hd>-nameid.
        SELECT SINGLE *
            FROM i_journalentry
            WHERE accountingdocumentheadertext = @lv_text_intcal
            INTO  @DATA(ls_journal_intcal).
        IF sy-subrc = 0.
          <lfs_intcal_hd>-accdocno = ls_journal_intcal-accountingdocument.
          <lfs_intcal_hd>-accdocyr = ls_journal_intcal-fiscalyear.
        ENDIF.
      ENDLOOP.

      COMMIT ENTITIES BEGIN.
      MODIFY zdt_intcal_hd FROM TABLE @lt_intcal_hd.
      COMMIT ENTITIES END.

    ENDIF.

*--Sales Detention
    DATA: lt_zdt_salesdetentn TYPE STANDARD TABLE OF zdt_salesdetentn,
          lv_time_begin       TYPE i_billingdocument-creationtime,
          lv_time_end         TYPE i_billingdocument-creationtime,
          lv_day              TYPE zdt_salesdetrate-today,
          lv_daycount         TYPE zdt_salesdetrate-today.

    DATA(lv_date) = cl_abap_context_info=>get_system_date(  ).
    lv_time_end = cl_abap_context_info=>get_system_time(  ).
    lv_time_begin = lv_time_end - 000060.

    SELECT *
     FROM zv_salesdetention_v1
     WHERE updated IS INITIAL "= ''
     INTO TABLE @DATA(lt_salesdetention).
    IF sy-subrc = 0.
      SORT lt_salesdetention BY deliverydocument.
    ENDIF.

    SELECT *
     FROM zdt_salesdetrate
     FOR ALL ENTRIES IN @lt_salesdetention
     WHERE begda <= @lt_salesdetention-containeractualpickupdate
     AND endda >= @lt_salesdetention-containeractualpickupdate
     INTO TABLE @DATA(lt_salesdetrate).
    IF lt_salesdetrate IS NOT INITIAL.
      SORT lt_salesdetrate BY contsize fromday.
    ENDIF.

    LOOP AT lt_salesdetention INTO DATA(ls_salesdetention).

      APPEND INITIAL LINE TO lt_zdt_salesdetentn ASSIGNING FIELD-SYMBOL(<lfs_zdt_salesdetentn>).

      <lfs_zdt_salesdetentn>-deliverydocument = ls_salesdetention-deliverydocument.

      IF ls_salesdetention-cartingorderrecdate >= ls_salesdetention-gateopendate.
        <lfs_zdt_salesdetentn>-truckholdingdays = ls_salesdetention-containerdockindate - ls_salesdetention-containeractualpickupdate + 1.
      ELSEIF ls_salesdetention-cartingorderrecdate < ls_salesdetention-gateopendate.
        IF ls_salesdetention-containerdockindate < ls_salesdetention-gateopendate.
          <lfs_zdt_salesdetentn>-truckholdingdays = ls_salesdetention-containerdockindate - ls_salesdetention-containeractualpickupdate.
        ELSEIF ls_salesdetention-containerdockindate >= ls_salesdetention-gateopendate AND ls_salesdetention-gateopendate < ls_salesdetention-containerfactoryoutdate.
          <lfs_zdt_salesdetentn>-truckholdingdays = ls_salesdetention-containerfactoryoutdate.
        ELSE.
          <lfs_zdt_salesdetentn>-truckholdingdays = ls_salesdetention-gateopendate - ls_salesdetention-containeractualpickupdate + 1.
        ENDIF.
      ENDIF.
      IF <lfs_zdt_salesdetentn>-truckholdingdays < 0.
        <lfs_zdt_salesdetentn>-truckholdingdays = 0.
      ENDIF.
      IF ls_salesdetention-containeractualpickupweekday = 6 OR ls_salesdetention-containeractualpickupweekday = 7.
        <lfs_zdt_salesdetentn>-truckholdingdays = 1.
      ENDIF.

      <lfs_zdt_salesdetentn>-factorydetentiondays = ( ls_salesdetention-containerfactoryoutdate + 1 ) -
                                                    ( ls_salesdetention-containeractualpickupdate + 1 ).
      IF <lfs_zdt_salesdetentn>-factorydetentiondays < 0.
        <lfs_zdt_salesdetentn>-factorydetentiondays = 0.
      ENDIF.
      IF ls_salesdetention-containeractualpickupweekday = 6 OR ls_salesdetention-containeractualpickupweekday = 7.
        <lfs_zdt_salesdetentn>-factorydetentiondays = 1.
      ENDIF.

      CLEAR: lv_day.
      LOOP AT lt_salesdetrate INTO DATA(ls_salesdetrate) WHERE contsize = ls_salesdetention-containersize AND
                                                               begda <= ls_salesdetention-containeractualpickupdate AND
                                                               endda >= ls_salesdetention-containeractualpickupdate.



        lv_daycount = ls_salesdetrate-today - ls_salesdetrate-fromday.
        DO lv_daycount TIMES.
          lv_day = lv_day + 1.
          IF lv_day <= <lfs_zdt_salesdetentn>-truckholdingdays.
            <lfs_zdt_salesdetentn>-truckdetentionamount = <lfs_zdt_salesdetentn>-truckdetentionamount + ls_salesdetrate-rate.
          ELSE.
            EXIT.
          ENDIF.
        ENDDO.
        CLEAR: lv_daycount.
      ENDLOOP.

      CLEAR: lv_day.
      LOOP AT lt_salesdetrate INTO ls_salesdetrate WHERE contsize = ls_salesdetention-containersize AND
                                                           begda <= ls_salesdetention-containeractualpickupdate AND
                                                           endda >= ls_salesdetention-containeractualpickupdate.

        lv_daycount = ls_salesdetrate-today - ls_salesdetrate-fromday.
        DO lv_daycount TIMES.
          lv_day = lv_day + 1.
          IF lv_day <= <lfs_zdt_salesdetentn>-factorydetentiondays.
            <lfs_zdt_salesdetentn>-factorydetentionamount = <lfs_zdt_salesdetentn>-factorydetentionamount + ls_salesdetrate-rate.
          ELSE.
            EXIT.
          ENDIF.
        ENDDO.
        CLEAR: lv_daycount.
      ENDLOOP.

      <lfs_zdt_salesdetentn>-docdetentiondays = <lfs_zdt_salesdetentn>-truckholdingdays - <lfs_zdt_salesdetentn>-factorydetentiondays.
      IF <lfs_zdt_salesdetentn>-docdetentiondays < 0.
        <lfs_zdt_salesdetentn>-docdetentiondays = 0.
      ENDIF.
      <lfs_zdt_salesdetentn>-docdetentionamount = <lfs_zdt_salesdetentn>-truckdetentionamount - <lfs_zdt_salesdetentn>-factorydetentionamount.
      IF ls_salesdetention-containeractualpickupdate IS NOT INITIAL.
        <lfs_zdt_salesdetentn>-updated = 'X'.
      ENDIF.
    ENDLOOP.

    MODIFY zdt_salesdetentn FROM TABLE @lt_zdt_salesdetentn.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

*//--------------------------------------------------------------------------//*
* Account Posting Update for LOAN Interest Cockpit
*//--------------------------------------------------------------------------//*
    DATA: lv_text TYPE i_journalentry-accountingdocumentheadertext.

    SELECT *
       FROM zdt_intcal_hd
       WHERE ( accdocno IS INITIAL AND
               status = 2 )
       INTO TABLE @DATA(lt_intcal_hd).
    IF lt_intcal_hd IS NOT INITIAL.

      LOOP AT lt_intcal_hd ASSIGNING FIELD-SYMBOL(<lfs_intcal_hd>).
        "-- LOAN Post---"
        lv_text = <lfs_intcal_hd>-nameid.
        SELECT SINGLE *
            FROM i_journalentry
            WHERE accountingdocumentheadertext = @lv_text
            INTO  @DATA(ls_journal).
        IF sy-subrc = 0.
          <lfs_intcal_hd>-accdocno = ls_journal-accountingdocument.
          <lfs_intcal_hd>-accdocyr = ls_journal-fiscalyear.
        ENDIF.
      ENDLOOP.

      COMMIT ENTITIES BEGIN.
      MODIFY zdt_intcal_hd FROM TABLE @lt_intcal_hd.
      COMMIT ENTITIES END.

    ENDIF.

*--Sales Detention
    DATA: lt_zdt_salesdetentn TYPE STANDARD TABLE OF zdt_salesdetentn,
          lv_time_begin       TYPE i_billingdocument-creationtime,
          lv_time_end         TYPE i_billingdocument-creationtime,
          lv_day              TYPE zdt_salesdetrate-today,
          lv_daycount         TYPE zdt_salesdetrate-today.

    DATA(lv_date) = cl_abap_context_info=>get_system_date(  ).
    lv_time_end = cl_abap_context_info=>get_system_time(  ).
    lv_time_begin = lv_time_end - 000060.

    SELECT *
     FROM zv_salesdetention_v1
     WHERE updated IS INITIAL "= ''
     INTO TABLE @DATA(lt_salesdetention).
    IF sy-subrc = 0.
      SORT lt_salesdetention BY deliverydocument.
    ENDIF.

    SELECT *
     FROM zdt_salesdetrate
     FOR ALL ENTRIES IN @lt_salesdetention
     WHERE begda <= @lt_salesdetention-containeractualpickupdate
     AND endda >= @lt_salesdetention-containeractualpickupdate
     INTO TABLE @DATA(lt_salesdetrate).
    IF lt_salesdetrate IS NOT INITIAL.
      SORT lt_salesdetrate BY contsize fromday.
    ENDIF.

    LOOP AT lt_salesdetention INTO DATA(ls_salesdetention).

      APPEND INITIAL LINE TO lt_zdt_salesdetentn ASSIGNING FIELD-SYMBOL(<lfs_zdt_salesdetentn>).

      <lfs_zdt_salesdetentn>-deliverydocument = ls_salesdetention-deliverydocument.

      IF ls_salesdetention-cartingorderrecdate >= ls_salesdetention-gateopendate.
        <lfs_zdt_salesdetentn>-truckholdingdays = ls_salesdetention-containerdockindate - ls_salesdetention-containeractualpickupdate + 1.
      ELSEIF ls_salesdetention-cartingorderrecdate < ls_salesdetention-gateopendate.
        IF ls_salesdetention-containerdockindate < ls_salesdetention-gateopendate.
          <lfs_zdt_salesdetentn>-truckholdingdays = ls_salesdetention-containerdockindate - ls_salesdetention-containeractualpickupdate.
        ELSEIF ls_salesdetention-containerdockindate >= ls_salesdetention-gateopendate AND ls_salesdetention-gateopendate < ls_salesdetention-containerfactoryoutdate.
          <lfs_zdt_salesdetentn>-truckholdingdays = ls_salesdetention-containerfactoryoutdate.
        ELSE.
          <lfs_zdt_salesdetentn>-truckholdingdays = ls_salesdetention-gateopendate - ls_salesdetention-containeractualpickupdate + 1.
        ENDIF.
      ENDIF.
      IF <lfs_zdt_salesdetentn>-truckholdingdays < 0.
        <lfs_zdt_salesdetentn>-truckholdingdays = 0.
      ENDIF.
      IF ls_salesdetention-containeractualpickupweekday = 6 OR ls_salesdetention-containeractualpickupweekday = 7.
        <lfs_zdt_salesdetentn>-truckholdingdays = 1.
      ENDIF.

      <lfs_zdt_salesdetentn>-factorydetentiondays = ( ls_salesdetention-containerfactoryoutdate + 1 ) -
                                                    ( ls_salesdetention-containeractualpickupdate + 1 ).
      IF <lfs_zdt_salesdetentn>-factorydetentiondays < 0.
        <lfs_zdt_salesdetentn>-factorydetentiondays = 0.
      ENDIF.
      IF ls_salesdetention-containeractualpickupweekday = 6 OR ls_salesdetention-containeractualpickupweekday = 7.
        <lfs_zdt_salesdetentn>-factorydetentiondays = 1.
      ENDIF.

      CLEAR: lv_day.
      LOOP AT lt_salesdetrate INTO DATA(ls_salesdetrate) WHERE contsize = ls_salesdetention-containersize AND
                                                               begda <= ls_salesdetention-containeractualpickupdate AND
                                                               endda >= ls_salesdetention-containeractualpickupdate.



        lv_daycount = ls_salesdetrate-today - ls_salesdetrate-fromday.
        DO lv_daycount TIMES.
          lv_day = lv_day + 1.
          IF lv_day <= <lfs_zdt_salesdetentn>-truckholdingdays.
            <lfs_zdt_salesdetentn>-truckdetentionamount = <lfs_zdt_salesdetentn>-truckdetentionamount + ls_salesdetrate-rate.
          ELSE.
            EXIT.
          ENDIF.
        ENDDO.
        CLEAR: lv_daycount.
      ENDLOOP.

      CLEAR: lv_day.
      LOOP AT lt_salesdetrate INTO ls_salesdetrate WHERE contsize = ls_salesdetention-containersize AND
                                                           begda <= ls_salesdetention-containeractualpickupdate AND
                                                           endda >= ls_salesdetention-containeractualpickupdate.

        lv_daycount = ls_salesdetrate-today - ls_salesdetrate-fromday.
        DO lv_daycount TIMES.
          lv_day = lv_day + 1.
          IF lv_day <= <lfs_zdt_salesdetentn>-factorydetentiondays.
            <lfs_zdt_salesdetentn>-factorydetentionamount = <lfs_zdt_salesdetentn>-factorydetentionamount + ls_salesdetrate-rate.
          ELSE.
            EXIT.
          ENDIF.
        ENDDO.
        CLEAR: lv_daycount.
      ENDLOOP.

      <lfs_zdt_salesdetentn>-docdetentiondays = <lfs_zdt_salesdetentn>-truckholdingdays - <lfs_zdt_salesdetentn>-factorydetentiondays.
      IF <lfs_zdt_salesdetentn>-docdetentiondays < 0.
        <lfs_zdt_salesdetentn>-docdetentiondays = 0.
      ENDIF.
      <lfs_zdt_salesdetentn>-docdetentionamount = <lfs_zdt_salesdetentn>-truckdetentionamount - <lfs_zdt_salesdetentn>-factorydetentionamount.
      IF ls_salesdetention-containeractualpickupdate IS NOT INITIAL.
        <lfs_zdt_salesdetentn>-updated = 'X'.
      ENDIF.
    ENDLOOP.

    MODIFY zdt_salesdetentn FROM TABLE @lt_zdt_salesdetentn.


    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
