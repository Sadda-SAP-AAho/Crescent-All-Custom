CLASS lhc_zi_fesvacreg DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_fesvacreg RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fesvacreg RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_fesvacreg~updateheader.

    METHODS checkcomb FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkcomb.

    METHODS checkvalidation FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkvalidation.

    METHODS checkcostdate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkcostdate.

    METHODS checkeditflag FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkeditflag.

    METHODS checkdrawno FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkdrawno.

    METHODS checkmktuser FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkmktuser.

    METHODS checkcustcode2 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkcustcode2.

    METHODS checkuniquecust FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkuniquecust.

    METHODS checkline FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkline.

    METHODS checktolrncepm FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checktolrncepm.

    METHODS checkpd3d FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fesvacreg~checkpd3d.

ENDCLASS.

CLASS lhc_zi_fesvacreg IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
    ENTITY zi_fesvacreg
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    IF gfs_header-Custcd IS NOT INITIAL AND gfs_header-Custcd2 IS INITIAL.

    SELECT SINGLE * FROM zcds_customers_f4 WHERE CustCode = @gfs_header-Custcd
      INTO @DATA(loc_final1).
      IF sy-subrc = 0.
        gfs_header-Custname = loc_final1-CustName.

      ENDIF.

      MODIFY ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      UPDATE
      FIELDS ( Custname )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky
                   Custname = gfs_header-Custname
                   %control-Custname = if_abap_behv=>mk-on
                   ) ).
    ENDIF.

    IF gfs_header-Custcd IS INITIAL AND gfs_header-Custcd2 IS NOT INITIAL.

    SELECT SINGLE * FROM zcds_leadcode WHERE Leadcode = @gfs_header-Custcd2
      INTO @DATA(loc_final2).
      IF sy-subrc = 0.
        gfs_header-Custname = loc_final2-Leadname.

      ENDIF.

      MODIFY ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      UPDATE
      FIELDS ( Custname )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky
                   Custname = gfs_header-Custname
                   %control-Custname = if_abap_behv=>mk-on
                   ) ).
    ENDIF.

  ENDMETHOD.

  METHOD checkvalidation.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_1).

    LOOP AT lt_data_1 INTO DATA(ls_data_1).

      IF ls_data_1-Rfqno IS INITIAL OR ls_data_1-rfqdate IS INITIAL.

        APPEND VALUE #( %tky = ls_data_1-%tky )
         TO failed-zi_fesvacreg.

        APPEND VALUE #(
          %tky        = ls_data_1-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Please enter both RFQ no and RFQ Date| )
        ) TO reported-zi_fesvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD checkcomb.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
                 ENTITY zi_fesvacreg
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~id
      FROM zi_fesvacreg AS a
      WHERE a~Rfqno = @gfs_header-Rfqno
        AND a~rfqdate = @gfs_header-rfqdate
        AND a~id <> @gfs_header-id
      INTO @DATA(lv_comb_2).

    IF lv_comb_2 IS NOT INITIAL.

      APPEND VALUE #( %tky = gfs_header-%tky )
        TO failed-zi_fesvacreg.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'Validate_Head'
        %msg        = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Duplicate found for RFQ No and RFQ Date.| )
      ) TO reported-zi_fesvacreg.

    ENDIF.

  ENDMETHOD.

   METHOD checkcostdate.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_3).

    LOOP AT lt_data_3 INTO DATA(ls_data_3).

      IF ls_data_3-Pduser IS NOT INITIAL AND ls_data_3-Costdate IS INITIAL.

        APPEND VALUE #( %tky = ls_data_3-%tky )
         TO failed-zi_fesvacreg.

        APPEND VALUE #(
          %tky        = ls_data_3-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Please enter Costing Date| )
        ) TO reported-zi_fesvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

METHOD checkeditflag.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_4).

    LOOP AT lt_data_4 INTO DATA(ls_data_4).

      IF ls_data_4-editflag IS NOT INITIAL.

        APPEND VALUE #( %tky = ls_data_4-%tky )
         TO failed-zi_fesvacreg.

        APPEND VALUE #(
          %tky        = ls_data_4-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Data cannot be modified| )
        ) TO reported-zi_fesvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

METHOD checkdrawno.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_5).

    LOOP AT lt_data_5 INTO DATA(ls_data_5).

      IF ls_data_5-Matcd IS INITIAL.

        APPEND VALUE #( %tky = ls_data_5-%tky )
         TO failed-zi_fesvacreg.

        APPEND VALUE #(
          %tky        = ls_data_5-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Drawning No Mandatory| )
        ) TO reported-zi_fesvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

 METHOD checkmktuser.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
                 ENTITY zi_fesvacreg
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

      SELECT SINGLE * FROM zcds_mktuser_f4 AS a WHERE a~Marketing_User = @gfs_header-Mktgusr
      INTO @DATA(lv_comb_6).

    IF lv_comb_6 IS INITIAL.

      APPEND VALUE #( %tky = gfs_header-%tky )
        TO failed-zi_fesvacreg.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'Validate_Head'
        %msg        = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Please select valid Marketing User| )
      ) TO reported-zi_fesvacreg.

    ENDIF.

  ENDMETHOD.

  METHOD checkcustcode2.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
                 ENTITY zi_fesvacreg
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

      SELECT SINGLE * FROM zcds_customers_f4 AS a WHERE a~CustCode = @gfs_header-custcd2
      INTO @DATA(lv_comb_8).

    IF lv_comb_8 IS NOT INITIAL.

      APPEND VALUE #( %tky = gfs_header-%tky )
        TO failed-zi_fesvacreg.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'Validate_Head'
        %msg        = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |New Customer Code cannot be same as existing| )
      ) TO reported-zi_fesvacreg.

    ENDIF.

  ENDMETHOD.

METHOD checkuniquecust.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_9).

    LOOP AT lt_data_9 INTO DATA(ls_data_9).

      IF ( ls_data_9-Custcd IS INITIAL AND ls_data_9-Custcd2 IS INITIAL ).

        APPEND VALUE #( %tky = ls_data_9-%tky )
         TO failed-zi_fesvacreg.

        APPEND VALUE #(
          %tky        = ls_data_9-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Select either Existing or New Customer Code| )
        ) TO reported-zi_fesvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

   METHOD checkline.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_11).

    LOOP AT lt_data_11 INTO DATA(ls_data_11).

      IF ls_data_11-Pduser IS NOT INITIAL AND ls_data_11-Line IS INITIAL.

        APPEND VALUE #( %tky = ls_data_11-%tky )
         TO failed-zi_fesvacreg.

        APPEND VALUE #(
          %tky        = ls_data_11-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Line is mandatory| )
        ) TO reported-zi_fesvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD checktolrncepm.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_12).

    LOOP AT lt_data_12 INTO DATA(ls_data_12).

      IF ( ls_data_12-Ptolrnce IS NOT INITIAL OR ls_data_12-Ntolrnce IS NOT INITIAL ) AND ls_data_12-Tolrncepm IS INITIAL.

        APPEND VALUE #( %tky = ls_data_12-%tky )
         TO failed-zi_fesvacreg.

        APPEND VALUE #(
          %tky        = ls_data_12-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Tolerance Parameter is mandatory| )
        ) TO reported-zi_fesvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD checkpd3d.

    READ ENTITIES OF zi_fesvacreg IN LOCAL MODE
      ENTITY zi_fesvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_13).

    LOOP AT lt_data_13 INTO DATA(ls_data_13).

      IF ls_data_13-Pduser IS NOT INITIAL AND ls_data_13-Pd3d IS INITIAL.

        APPEND VALUE #( %tky = ls_data_13-%tky )
         TO failed-zi_fesvacreg.

        APPEND VALUE #(
          %tky        = ls_data_13-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |3D Weight is mandatory| )
        ) TO reported-zi_fesvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
