CLASS lhc_zi_gstnewvenref DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gstnewvenref RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gstnewvenref RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gstnewvenref~updateheader.

    METHODS checkduplicate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gstnewvenref~checkduplicate.

    METHODS checkvalidation1 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gstnewvenref~checkvalidation1.

    METHODS checkmandatory FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gstnewvenref~checkmandatory.

    METHODS checkdata FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gstnewvenref~checkdata.

ENDCLASS.

CLASS lhc_zi_gstnewvenref IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_gstnewvenref IN LOCAL MODE
      ENTITY zi_gstnewvenref
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).


    SELECT SINGLE * FROM zcds_je_details_f4
    WHERE jeno = @gfs_header-jeno
    AND fiscalyear = @gfs_header-fisyear

      INTO @DATA(loc_final1).

    IF sy-subrc = 0.
      gfs_header-jedate = loc_final1-jedate.
      gfs_header-supplcode = loc_final1-supplcode.
      gfs_header-jerefno = loc_final1-jerefno.

    ENDIF.

    MODIFY ENTITIES OF zi_gstnewvenref IN LOCAL MODE
    ENTITY zi_gstnewvenref
    UPDATE
    FIELDS ( jedate supplcode jerefno )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 jedate = gfs_header-jedate
                 supplcode = gfs_header-supplcode
                 jerefno = gfs_header-jerefno
                 %control-jedate = if_abap_behv=>mk-on
                 %control-supplcode = if_abap_behv=>mk-on
                 %control-jerefno = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

  METHOD checkduplicate.

    READ ENTITIES OF zi_gstnewvenref IN LOCAL MODE
                   ENTITY zi_gstnewvenref
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~id
      FROM zi_gstnewvenref AS a
      WHERE a~fisyear = @gfs_header-fisyear
        AND a~jeno = @gfs_header-jeno
        AND a~id <> @gfs_header-id
      INTO @DATA(lv_comb_1).

    IF lv_comb_1 IS NOT INITIAL.

      APPEND VALUE #( %tky = gfs_header-%tky )
        TO failed-zi_gstnewvenref.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'Validate_Head'
        %msg        = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Duplicate found for Fiscal Year & JE No.| )
      ) TO reported-zi_gstnewvenref.

    ENDIF.

  ENDMETHOD.

  METHOD checkvalidation1.

  READ ENTITIES OF zi_gstnewvenref IN LOCAL MODE
    ENTITY zi_gstnewvenref
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

  LOOP AT lt_header INTO DATA(ls_header).

    "Fetch the corresponding Journal Entry details
    SELECT SINGLE
           FiscalYear,
           Jeno,
           Jedate,
           Supplcode,
           Jerefno
      FROM zcds_je_details_f4
      WHERE FiscalYear = @ls_header-fisyear
        AND Jeno       = @ls_header-jeno
      INTO @DATA(ls_je).

    "Record not found
    IF sy-subrc <> 0.

      APPEND VALUE #( %tky = ls_header-%tky )
        TO failed-zi_gstnewvenref.

      APPEND VALUE #(
        %tky        = ls_header-%tky
        %state_area = 'VALIDATE_HEAD'
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Invalid Fiscal Year / Journal Entry No.' )
      ) TO reported-zi_gstnewvenref.

      CONTINUE.

    ENDIF.

    "Validate JE Date, Supplier Code and JE Reference No.
    IF ls_header-jedate    <> ls_je-jedate
    OR ls_header-supplcode <> ls_je-supplcode
    OR ls_header-jerefno   <> ls_je-jerefno.

      APPEND VALUE #( %tky = ls_header-%tky )
        TO failed-zi_gstnewvenref.

      APPEND VALUE #(
        %tky        = ls_header-%tky
        %state_area = 'VALIDATE_HEAD'
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'JE Date, JE Ref. no, Supplier Code are not matched' )
      ) TO reported-zi_gstnewvenref.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

METHOD checkmandatory.

  READ ENTITIES OF zi_gstnewvenref IN LOCAL MODE
      ENTITY zi_gstnewvenref
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lv_data_1).

    LOOP AT lv_data_1 INTO DATA(ls_data_1).

      IF ls_data_1-Newvendrefno IS INITIAL.

        APPEND VALUE #( %tky = ls_data_1-%tky )
         TO failed-zi_gstnewvenref.

        APPEND VALUE #(
          %tky        = ls_data_1-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Please enter New Vendor Reference No.| )
        ) TO reported-zi_gstnewvenref.

      ENDIF.

    ENDLOOP.

ENDMETHOD.

METHOD checkdata.

  READ ENTITIES OF zi_gstnewvenref IN LOCAL MODE
      ENTITY zi_gstnewvenref
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lv_data_2).

    LOOP AT lv_data_2 INTO DATA(ls_data_2).

      IF ls_data_2-Jerefno = ls_data_2-Newvendrefno .

        APPEND VALUE #( %tky = ls_data_2-%tky )
         TO failed-zi_gstnewvenref.

        APPEND VALUE #(
          %tky        = ls_data_2-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |JE Ref No and New Vendor Ref No cannot be same| )
        ) TO reported-zi_gstnewvenref.

      ENDIF.

    ENDLOOP.

ENDMETHOD.

ENDCLASS.
