CLASS lhc_zi_timrecoreghd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_timrecoreghd RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_timrecoreghd RESULT result.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_timrecoreghd~determinedocnum.

ENDCLASS.

CLASS lhc_zi_timrecoreghd IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determinedocnum.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_timrecoreghd IN LOCAL MODE
           ENTITY zi_timrecoreghd
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-docnum IS INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-fisyear = lv_date+2(2) && lv_date+2(2).
      gfs_header-fisyear = gfs_header-fisyear + 1.

      gfs_header-creby = sy-uname.
      gfs_header-creon = lv_date.

      SELECT MAX( keyid ) AS keyid FROM zdt_timrecoreghd WHERE fisyear = @gfs_header-fisyear
      INTO @DATA(lv_keyid).

      lv_keyid = lv_keyid + 1.
      gfs_header-keyid = lv_keyid.
      gfs_header-docnum = gfs_header-fisyear && lv_keyid..

      MODIFY ENTITIES OF zi_timrecoreghd IN LOCAL MODE
       ENTITY zi_timrecoreghd
       UPDATE
       FIELDS ( fisyear docnum keyid creby creon )
       WITH VALUE #( FOR key IN keys
                    ( %tky = gfs_header-%tky
                    fisyear = gfs_header-fisyear
                    docnum = gfs_header-docnum
                    keyid = gfs_header-keyid
                    creby = gfs_header-creby
                    creon = gfs_header-creon
                    %control-docnum = if_abap_behv=>mk-on
                    ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_timrecoregit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS checkrefdrnoteno FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_timrecoregit~checkrefdrnoteno.

    METHODS gstinvno FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_timrecoregit~gstinvno.

ENDCLASS.

CLASS lhc_zi_timrecoregit IMPLEMENTATION.

  METHOD checkrefdrnoteno.

*--------------------------------------------------------------------*
* Read Changed Items
*--------------------------------------------------------------------*
    READ ENTITIES OF zi_timrecoreghd IN LOCAL MODE
        ENTITY zi_timrecoregit
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_changed_items).

    LOOP AT lt_changed_items INTO DATA(ls_changed_item).

*--------------------------------------------------------------------*
* Amount > 0 -> Refdrnoteno must be blank
*--------------------------------------------------------------------*
      IF ls_changed_item-amount > 0
         AND ls_changed_item-refdrnoteno IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_changed_item-%tky

          %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text     = |Ref Dr Note No must be blank|
                 )

          %element-amount   = if_abap_behv=>mk-on
          %element-refdrnoteno = if_abap_behv=>mk-on

        ) TO reported-zi_timrecoregit.

        APPEND VALUE #(
          %tky = ls_changed_item-%tky
        ) TO failed-zi_timrecoregit.

        CONTINUE.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD gstinvno.

*--------------------------------------------------------------------*
* Read Changed Items
*--------------------------------------------------------------------*
    READ ENTITIES OF zi_timrecoreghd IN LOCAL MODE
        ENTITY zi_timrecoregit
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_changed_items).

    LOOP AT lt_changed_items INTO DATA(ls_changed_item).

*--------------------------------------------------------------------*
* Amount > 0 -> Gstinvno must be BA + Invno
*--------------------------------------------------------------------*
      IF ls_changed_item-amount > 0.

        DATA(lv_expected_gstinvno) =
          |BA{ ls_changed_item-invno }|.

        IF ls_changed_item-gstinvno <> lv_expected_gstinvno.

          APPEND VALUE #(
            %tky = ls_changed_item-%tky

            %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = |GST Invoice No must be { lv_expected_gstinvno }|
                   )

            %element-amount = if_abap_behv=>mk-on
            %element-invno    = if_abap_behv=>mk-on
            %element-gstinvno = if_abap_behv=>mk-on

          ) TO reported-zi_timrecoregit.

          APPEND VALUE #(
            %tky = ls_changed_item-%tky
          ) TO failed-zi_timrecoregit.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
