CLASS lhc_zi_gstr2breg_hd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gstr2breg_hd RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gstr2breg_hd RESULT result.

    METHODS checkcomb1 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gstr2breg_hd~checkcomb1.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gstr2breg_hd~updateheader.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_gstr2breg_hd~determinedocnum.



ENDCLASS.

CLASS lhc_zi_gstr2breg_hd IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD checkcomb1.

    READ ENTITIES OF zi_gstr2breg_hd IN LOCAL MODE
      ENTITY zi_gstr2breg_hd
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      SELECT SINGLE id
        FROM zi_gstr2breg_hd
        WHERE location = @ls_header-location
          AND fyear  = @ls_header-fyear
          AND fmonth = @ls_header-fmonth
          AND id     <> @ls_header-id
        INTO @DATA(lv_id).

      IF lv_id IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zi_gstr2breg_hd.

        APPEND VALUE #(
          %tky        = ls_header-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = |Duplicate Location, FY & Month already exists| )
        ) TO reported-zi_gstr2breg_hd.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_gstr2breg_hd IN LOCAL MODE
      ENTITY zi_gstr2breg_hd
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA lt_update TYPE TABLE FOR UPDATE zi_gstr2breg_hd.

    LOOP AT lt_header INTO DATA(ls_header).

      SELECT SINGLE fmonth
        FROM zi_fmonth_f4
        WHERE fmonth_code = @ls_header-fmonthcd
        INTO @DATA(lv_fmonth).

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky            = ls_header-%tky
          fmonth          = lv_fmonth
          %control-fmonth = if_abap_behv=>mk-on
        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF zi_gstr2breg_hd IN LOCAL MODE
        ENTITY zi_gstr2breg_hd
        UPDATE FIELDS ( fmonth )
        WITH lt_update.

    ENDIF.

  ENDMETHOD.

  METHOD determinedocnum.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( )
                TIME cl_abap_context_info=>get_system_time( )
          INTO TIME STAMP DATA(lv_timestamp)
          TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp
        TIME ZONE 'INDIA'
        INTO DATE lv_date
             TIME lv_time.

    READ ENTITIES OF zi_gstr2breg_hd IN LOCAL MODE
      ENTITY zi_gstr2breg_hd
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA lt_update TYPE TABLE FOR UPDATE zi_gstr2breg_hd.

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-docnum IS INITIAL.

        ls_header-fisyear = lv_date+2(2) && lv_date+2(2).
        ls_header-fisyear = ls_header-fisyear + 1.

        ls_header-creby = sy-uname.
        ls_header-creon = lv_date.

        SELECT MAX( keyid )
          FROM zi_gstr2breg_hd
          WHERE fisyear = @ls_header-fisyear
          INTO @DATA(lv_keyid).

        lv_keyid = lv_keyid + 1.

        APPEND VALUE #(
          %tky              = ls_header-%tky
          fisyear           = ls_header-fisyear
          keyid             = lv_keyid
          docnum            = |{ ls_header-fisyear }{ lv_keyid }|
          creby             = ls_header-creby
          creon             = ls_header-creon
          %control-fisyear  = if_abap_behv=>mk-on
          %control-keyid    = if_abap_behv=>mk-on
          %control-docnum   = if_abap_behv=>mk-on
          %control-creby    = if_abap_behv=>mk-on
          %control-creon    = if_abap_behv=>mk-on
        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF zi_gstr2breg_hd IN LOCAL MODE
        ENTITY zi_gstr2breg_hd
        UPDATE FIELDS (
            fisyear
            keyid
            docnum
            creby
            creon )
        WITH lt_update.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
