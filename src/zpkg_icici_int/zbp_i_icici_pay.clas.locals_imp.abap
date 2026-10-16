CLASS lhc_zi_icici_pay DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_icici_pay RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_icici_pay.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_icici_pay.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_icici_pay.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_icici_pay RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_icici_pay.

ENDCLASS.

CLASS lhc_zi_icici_pay IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA: ls_head TYPE zdt_payst_icici.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    "Modify
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs>).
      ls_head = CORRESPONDING #( <fs> ).

      SELECT SINGLE * FROM zdt_payst_icici
      WHERE filename =   @ls_head-filename
      INTO @DATA(ls_check).
      IF sy-subrc = 0.
        "do nothing
      ELSE.
        ls_head-createdon = sy-datum.
        ls_head-createdat = sy-uzeit.
        MODIFY zdt_payst_icici FROM @ls_head.
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

CLASS lsc_zi_icici_pay DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_icici_pay IMPLEMENTATION.

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
