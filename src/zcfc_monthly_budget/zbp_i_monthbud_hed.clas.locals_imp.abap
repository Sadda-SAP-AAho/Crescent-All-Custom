CLASS lhc_zi_monthbud_hed DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_monthbud_hed RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_monthbud_hed RESULT result.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_monthbud_hed~determinedocnum.

    METHODS checkcomb FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_monthbud_hed~checkcomb.

    METHODS checkvalidation FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_monthbud_hed~checkvalidation.

ENDCLASS.

CLASS lhc_zi_monthbud_hed IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determinedocnum.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_monthbud_hed IN LOCAL MODE
           ENTITY zi_monthbud_hed
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-budgetcode IS INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-creby = sy-uname.
      gfs_header-creon = lv_date.

      SELECT MAX( keyid ) AS keyid FROM zdt_monthbud_hed WHERE fiscalyear = @gfs_header-fiscalyear
      INTO @DATA(lv_keyid).

      lv_keyid = lv_keyid + 1.
      gfs_header-keyid = lv_keyid.
      gfs_header-budgetcode = gfs_header-fiscalyear && lv_keyid.

      MODIFY ENTITIES OF zi_monthbud_hed IN LOCAL MODE
       ENTITY zi_monthbud_hed
       UPDATE
       FIELDS ( budgetcode keyid creby creon )
       WITH VALUE #( FOR key IN keys
                    ( %tky = gfs_header-%tky
                    budgetcode = gfs_header-budgetcode
                    keyid = gfs_header-keyid
                    creby = gfs_header-creby
                    creon = gfs_header-creon
                    %control-budgetcode = if_abap_behv=>mk-on
                    ) ).

    ENDIF.

  ENDMETHOD.

  METHOD checkcomb.

    "-------------------------------------------------------
    " Read Header
    "-------------------------------------------------------
    READ ENTITIES OF zi_monthbud_hed IN LOCAL MODE
      ENTITY zi_monthbud_hed
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    "-------------------------------------------------------
    " Read ALL items (existing + newly added in buffer)
    "-------------------------------------------------------
    READ ENTITY zi_monthbud_hed
      BY \_item
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    "-------------------------------------------------------
    " Duplicate Check (Create + Update scenario)
    "-------------------------------------------------------
    TYPES: BEGIN OF ty_check,
             cstcntrcd TYPE zdt_monthbud_itm-cstcntrcd,
             glcode    TYPE zdt_monthbud_itm-glcode,
           END OF ty_check.

    DATA: lt_check TYPE SORTED TABLE OF ty_check
                    WITH UNIQUE KEY cstcntrcd glcode.

    LOOP AT lt_item INTO DATA(ls_item).

      "Skip empty entries (optional safety)
      IF ls_item-cstcntrcd IS INITIAL OR ls_item-glcode IS INITIAL.
        CONTINUE.
      ENDIF.

      INSERT VALUE #(
        cstcntrcd = ls_item-cstcntrcd
        glcode    = ls_item-glcode ) INTO TABLE lt_check.

      "-------------------------------------------------------
      " If duplicate found
      "-------------------------------------------------------
      IF sy-subrc <> 0.

        DATA(lv_msg) = |Cost Center & GL Code can't repeated in same FY|.

        "Mark failure on HEADER (or item if needed)
        APPEND VALUE #( %tky = ls_header-%tky )
          TO failed-zi_monthbud_hed.

        APPEND VALUE #(
          %tky        = ls_header-%tky
          %state_area = 'VALIDATE'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = lv_msg ) )
          TO reported-zi_monthbud_hed.

        EXIT.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD checkvalidation.

    READ ENTITIES OF zi_monthbud_hed IN LOCAL MODE
      ENTITY zi_monthbud_hed
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    READ ENTITY zi_monthbud_hed
    BY \_item
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(item).


    SELECT SINGLE * FROM zdt_monthbud_hed WHERE fiscalyear = @gfs_header-fiscalyear
    INTO @DATA(ls_comb1).

    IF ls_comb1 IS NOT INITIAL.

      DATA(lv_msg1) = |More than one Budget can't be added in one FY|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_monthbud_hed.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_monthbud_hed.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_monthbud_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_monthbud_itm~updateitem.

ENDCLASS.

CLASS lhc_zi_monthbud_itm IMPLEMENTATION.

  METHOD updateitem.

    READ ENTITIES OF zi_monthbud_hed IN LOCAL MODE
                 ENTITY zi_monthbud_hed
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_monthbud_hed
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM zi_costcenter_f4 WHERE cstcntr = @gfs_item-cstcntrcd
      INTO @DATA(loc_final1).
    IF sy-subrc = 0.
      gfs_item-cstcntrnam = loc_final1-cstcntrtxt.

    ENDIF.

    SELECT SINGLE * FROM zi_gl_code_f4 WHERE glcode = @gfs_item-glcode
      INTO @DATA(loc_final2).
    IF sy-subrc = 0.
      gfs_item-glname = loc_final2-glname.

    ENDIF.

    MODIFY ENTITIES OF zi_monthbud_hed IN LOCAL MODE
      ENTITY zi_monthbud_itm
      UPDATE
      FIELDS ( cstcntrnam glname )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_item-%tky
                   cstcntrnam = gfs_item-cstcntrnam
                   glname = gfs_item-glname
                   %control-cstcntrnam = if_abap_behv=>mk-on
                   %control-glname = if_abap_behv=>mk-on
                   ) ).

  ENDMETHOD.

ENDCLASS.
