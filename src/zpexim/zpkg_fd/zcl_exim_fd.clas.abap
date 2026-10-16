CLASS zcl_exim_fd DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'INVENT'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Container Track data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_EXIMFD_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_EXIMFD_ALOGS_01'.

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



CLASS ZCL_EXIM_FD IMPLEMENTATION.


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
                               header = cl_bali_header_setter=>create( object = 'ZAPP_EXIMFD_01_LOG'
                                                                       subobject = 'ZAPP_EXIMFD_01_SUB'
                                                                       external_id = 'EXIMFD' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    SELECT *
    FROM zdt_intcal_hd
    WHERE post IS NOT INITIAL
    AND accdocno IS INITIAL
    INTO TABLE @DATA(lt_intcal_hd).
    IF sy-subrc = 0.
      LOOP AT lt_intcal_hd ASSIGNING FIELD-SYMBOL(<lfs_intcal_hd>).
        SELECT SINGLE *
            FROM i_journalentryitem
            WHERE yy1_fdnumber_jei = @<lfs_intcal_hd>-nameid
            INTO  @DATA(ls_journal).
        IF sy-subrc = 0.
          <lfs_intcal_hd>-accdocno = ls_journal-accountingdocument.
          <lfs_intcal_hd>-accdocyr = ls_journal-fiscalyear.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT *
    FROM zdt_fd_head
    WHERE transactionno IS INITIAL
    INTO TABLE @DATA(lt_fdhead_trxn).
    IF lt_fdhead_trxn IS NOT INITIAL.

      LOOP AT lt_fdhead_trxn ASSIGNING FIELD-SYMBOL(<lfs_fdhead>).
        SELECT SINGLE *
            FROM i_journalentryitem
            WHERE yy1_fdnumber_jei = @<lfs_fdhead>-fdcertificateno
            AND   documentitemtext LIKE '%Booked%'
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_fdhead>-transactionno = ls_journal-accountingdocument.
          <lfs_fdhead>-transactiondate = ls_journal-postingdate.
        ENDIF.
      ENDLOOP.
    ENDIF.

    COMMIT ENTITIES BEGIN.
    MODIFY zdt_fd_head FROM TABLE @lt_fdhead_trxn.
    COMMIT ENTITIES END.

    SELECT *
    FROM zdt_fd_head
    WHERE fdclosetrxnno IS INITIAL
    INTO TABLE @DATA(lt_fdhead_trxnclose).
    IF lt_fdhead_trxnclose IS NOT INITIAL.

      LOOP AT lt_fdhead_trxnclose ASSIGNING <lfs_fdhead>.
        SELECT SINGLE *
            FROM i_journalentryitem
            WHERE yy1_fdnumber_jei = @<lfs_fdhead>-fdcertificateno
            AND   documentitemtext LIKE '%Closed%'
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_fdhead>-fdclosetrxnno = ls_journal-accountingdocument.
          <lfs_fdhead>-fdclosetrxndate = ls_journal-postingdate.
        ENDIF.
      ENDLOOP.
    ENDIF.

    COMMIT ENTITIES BEGIN.
    MODIFY zdt_fd_head FROM TABLE @lt_fdhead_trxnclose.
    COMMIT ENTITIES END.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    SELECT *
    FROM zdt_intcal_hd
    WHERE post IS NOT INITIAL
    AND accdocno IS INITIAL
    INTO TABLE @DATA(lt_intcal_hd).
    IF sy-subrc = 0.
      LOOP AT lt_intcal_hd ASSIGNING FIELD-SYMBOL(<lfs_intcal_hd>).
        SELECT SINGLE *
            FROM i_journalentryitem
            WHERE yy1_fdnumber_jei = @<lfs_intcal_hd>-nameid
            INTO  @DATA(ls_journal).
        IF sy-subrc = 0.
          <lfs_intcal_hd>-accdocno = ls_journal-accountingdocument.
          <lfs_intcal_hd>-accdocyr = ls_journal-fiscalyear.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT *
    FROM zdt_fd_head
    WHERE transactionno IS INITIAL
    INTO TABLE @DATA(lt_fdhead_trxn).
    IF lt_fdhead_trxn IS NOT INITIAL.

      LOOP AT lt_fdhead_trxn ASSIGNING FIELD-SYMBOL(<lfs_fdhead>).
        SELECT SINGLE *
            FROM i_journalentryitem
            WHERE yy1_fdnumber_jei = @<lfs_fdhead>-fdcertificateno
            AND   documentitemtext LIKE '%Booked%'
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_fdhead>-transactionno = ls_journal-accountingdocument.
          <lfs_fdhead>-transactiondate = ls_journal-postingdate.
        ENDIF.
      ENDLOOP.
    ENDIF.

    COMMIT ENTITIES BEGIN.
    MODIFY zdt_fd_head FROM TABLE @lt_fdhead_trxn.
    COMMIT ENTITIES END.

    SELECT *
    FROM zdt_fd_head
    WHERE fdclosetrxnno IS INITIAL
    INTO TABLE @DATA(lt_fdhead_trxnclose).
    IF lt_fdhead_trxnclose IS NOT INITIAL.

      LOOP AT lt_fdhead_trxnclose ASSIGNING <lfs_fdhead>.
        SELECT SINGLE *
            FROM i_journalentryitem
            WHERE yy1_fdnumber_jei = @<lfs_fdhead>-fdcertificateno
            AND   documentitemtext LIKE '%Closed%'
            INTO  @ls_journal.
        IF sy-subrc = 0.
          <lfs_fdhead>-fdclosetrxnno = ls_journal-accountingdocument.
          <lfs_fdhead>-fdclosetrxndate = ls_journal-postingdate.
        ENDIF.
      ENDLOOP.
    ENDIF.

    COMMIT ENTITIES BEGIN.
    MODIFY zdt_fd_head FROM TABLE @lt_fdhead_trxnclose.
    COMMIT ENTITIES END.


    SELECT *
    FROM zdt_fd_interest
    WHERE transactionno IS INITIAL
    INTO TABLE @DATA(lt_trxnint).
    IF lt_trxnint IS NOT INITIAL.

      SELECT *
      FROM zdt_fd_head
      FOR ALL ENTRIES IN @lt_trxnint
      WHERE id = @lt_trxnint-id
      INTO TABLE @DATA(lt_fd_head).

      LOOP AT lt_trxnint ASSIGNING FIELD-SYMBOL(<lfs_trxnint>).
        DATA(ls_fd_head) = VALUE #( lt_fd_head[ id = <lfs_trxnint>-id ] OPTIONAL ).
        IF ls_fd_head IS NOT INITIAL.
          SELECT SINGLE a~*
              FROM i_journalentryitem AS a
              INNER JOIN i_journalentry AS b ON b~accountingdocument = a~accountingdocument
                                            AND b~fiscalyear = a~fiscalyear
                                            AND b~companycode = a~companycode
              WHERE yy1_fdnumber_jei = @ls_fd_head-fdcertificateno
              AND   documentreferenceid = @<lfs_trxnint>-referenceno
              INTO  @DATA(ls_journal_all).
          IF sy-subrc = 0.
            <lfs_trxnint>-transactionno = ls_journal_all-accountingdocument.
            <lfs_trxnint>-transactiondate = ls_journal_all-postingdate.
          ENDIF.
        ENDIF.
        CLEAR: ls_fd_head.
      ENDLOOP.
    ENDIF.

    COMMIT ENTITIES BEGIN.
    MODIFY zdt_fd_interest FROM TABLE @lt_trxnint.
    COMMIT ENTITIES END.

  ENDMETHOD.
ENDCLASS.
