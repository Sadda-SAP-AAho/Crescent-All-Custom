CLASS zcl_vend_bank_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'VENDBANK'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'VendBnakUpd'.
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



CLASS ZCL_VEND_BANK_JOB IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_VBANK_01_LOG'
                                                                      subobject   = 'ZAPP_VBANK_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    SELECT *
      FROM zdt_ven_bank_itm
      WHERE status = '2'
      INTO TABLE @DATA(lt_item_100) UP TO 100 ROWS .

    DO 50 TIMES.
      SELECT a~*
          FROM zdt_ven_bank_itm AS a
          INNER JOIN @lt_item_100 AS b ON a~supp = b~supp
          WHERE a~status = '2'
          INTO TABLE @DATA(lt_item).

      IF lt_item[] IS INITIAL .
        EXIT.
      ENDIF.

      LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).

        READ ENTITIES OF i_businesspartnertp_3 ENTITY businesspartner
        ALL FIELDS WITH VALUE #( ( businesspartner = <fs_item>-supp ) ) RESULT DATA(partner).
        IF partner IS NOT INITIAL.
          READ ENTITIES OF i_businesspartnertp_3
               ENTITY businesspartner BY \_businesspartnerbank
          ALL FIELDS WITH VALUE #( ( %tky = partner[ 1 ]-%tky ) ) RESULT DATA(curr_bank).
          IF curr_bank IS NOT INITIAL.
            LOOP AT curr_bank ASSIGNING FIELD-SYMBOL(<new_bank>).

              <new_bank>-%is_draft       = if_abap_behv=>mk-off.
              <new_bank>-bankaccount     = <fs_item>-bankacc.
              <new_bank>-banknumber      = <fs_item>-bankkey.
              <new_bank>-bankaccountname = <fs_item>-bankname.
              <new_bank>-bankcountrykey  = <fs_item>-bankcou.



              MODIFY ENTITIES OF i_businesspartnertp_3 "i_businesspartnerbanktp_3
               ENTITY businesspartnerbank
               UPDATE
               FROM VALUE #( ( VALUE #(  %tky = CORRESPONDING #( <new_bank>-%tky )

                                         %data-bankaccount    = <new_bank>-bankaccount
                                         %data-banknumber     = <new_bank>-banknumber
                                         %data-bankaccountname = <new_bank>-bankaccountname
                                         %data-bankcountrykey = <new_bank>-bankcountrykey

                                         %control-bankaccount    = cl_abap_behv=>flag_changed
                                         %control-banknumber     = cl_abap_behv=>flag_changed
                                         %control-bankaccountname = cl_abap_behv=>flag_changed
                                         %control-bankcountrykey = cl_abap_behv=>flag_changed
                                         %is_draft = if_abap_behv=>mk-off

                                      ) ) )
                              REPORTED DATA(reported) FAILED DATA(failed).

              COMMIT ENTITIES BEGIN RESPONSE OF i_businesspartnertp_3
              FAILED DATA(failed_commit)
              REPORTED DATA(reported_commit).
              COMMIT ENTITIES END.

              IF failed_commit IS NOT INITIAL .
*Reset transactional buffer
                ROLLBACK ENTITIES.

*Persist (empty) transactional buffer
                COMMIT ENTITIES
                RESPONSE OF i_businesspartnertp_3
                FAILED DATA(failed_commit2)
                REPORTED DATA(reported_commit2).
              ENDIF.

              WAIT UP TO 1 SECONDS.
            ENDLOOP.

            READ ENTITIES OF i_businesspartnertp_3
                 ENTITY businesspartner BY \_businesspartnerbank
            ALL FIELDS WITH VALUE #( ( %tky = partner[ 1 ]-%tky ) ) RESULT DATA(lt_vbankupd).

            READ TABLE lt_vbankupd INTO DATA(ls_vbankupd) WITH KEY businesspartner = <new_bank>-businesspartner
                                                                   bankaccount = <new_bank>-bankaccount
                                                                   banknumber  = <new_bank>-banknumber.
            IF sy-subrc EQ 0 .
              <fs_item>-status = '3' .
            ENDIF.
          ELSE.
            <fs_item>-status = '5' .
          ENDIF.
        ELSE.
          <fs_item>-status = '4' .
        ENDIF.
      ENDLOOP.

      COMMIT ENTITIES BEGIN.
      MODIFY zdt_ven_bank_itm FROM TABLE @lt_item.
      COMMIT ENTITIES END.

    ENDDO.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
