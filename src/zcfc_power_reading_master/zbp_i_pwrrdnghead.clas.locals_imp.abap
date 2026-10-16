CLASS lhc_zi_pwrrdngitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pwrrdngitem~updateitem.

ENDCLASS.

CLASS lhc_zi_pwrrdngitem IMPLEMENTATION.

  METHOD updateitem.
    READ ENTITIES OF zi_pwrrdnghead IN LOCAL MODE
    ENTITY zi_pwrrdnghead
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    READ ENTITY zi_pwrrdnghead
    BY \_item
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(item).

    DATA(gfs_item) = VALUE #( item[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zdt_pwrhdmaster WHERE subheadcd = @gfs_item-subhdcd
    INTO @DATA(loc_item).
    IF sy-subrc = 0.

      gfs_item-subhdnm = loc_item-subheadnm.
      gfs_item-headcd = loc_item-headcd.
      gfs_item-headnm = loc_item-headnm.
      gfs_item-metertyp = loc_item-metertyp.

    ENDIF.

    MODIFY ENTITIES OF zi_pwrrdnghead IN LOCAL MODE
    ENTITY zi_pwrrdngitem
    UPDATE
    FIELDS ( subhdnm headcd headnm metertyp )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_item-%tky

                 subhdnm = gfs_item-subhdnm
                 headcd = gfs_item-headcd
                 headnm = gfs_item-headnm
                 metertyp = gfs_item-metertyp

                 %control-subhdnm = if_abap_behv=>mk-on
                 %control-headcd = if_abap_behv=>mk-on
                 %control-headnm = if_abap_behv=>mk-on
                 %control-metertyp = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_pwrrdnghead DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_pwrrdnghead RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_pwrrdnghead RESULT result.
    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pwrrdnghead~updateheader.
    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_pwrrdnghead~determinedocnum.

ENDCLASS.

CLASS lhc_zi_pwrrdnghead IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_pwrrdnghead IN LOCAL MODE
    ENTITY zi_pwrrdnghead
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    IF gfs_header-docnum IS INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-fisyear = lv_date+2(2) && lv_date+2(2).
      gfs_header-fisyear = gfs_header-fisyear + 1.


      SELECT SINGLE * FROM zcds_plant_f4 WHERE loctncd = @gfs_header-readloccd
      INTO @DATA(loc_final).
      IF sy-subrc = 0.
        gfs_header-readlocnm = loc_final-loctnnam.

      ENDIF.

      MODIFY ENTITIES OF zi_pwrrdnghead IN LOCAL MODE
      ENTITY zi_pwrrdnghead
      UPDATE
      FIELDS ( readlocnm )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky
                   readlocnm = gfs_header-readlocnm
                   %control-readlocnm = if_abap_behv=>mk-on
                   ) ).

      MODIFY ENTITIES OF zi_pwrrdnghead IN LOCAL MODE
      ENTITY zi_pwrrdnghead
      UPDATE
      FIELDS ( fisyear )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky
                   fisyear = gfs_header-fisyear
                   %control-fisyear = if_abap_behv=>mk-on
                   ) ).

    ENDIF.

  ENDMETHOD.


  METHOD determinedocnum.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA lv_fisyr TYPE int2.

    READ ENTITIES OF zi_pwrrdnghead IN LOCAL MODE
           ENTITY zi_pwrrdnghead
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

      gfs_header-creby = sy-uname.
      gfs_header-creon = lv_date.

      SELECT MAX( keyid ) AS keyid FROM zdt_pwrrdnghead WHERE fisyear = @gfs_header-fisyear
      INTO @DATA(lv_keyid).

      lv_keyid = lv_keyid + 1.
      gfs_header-keyid = lv_keyid.
      gfs_header-docnum = gfs_header-fisyear && lv_keyid.

      MODIFY ENTITIES OF zi_pwrrdnghead IN LOCAL MODE
       ENTITY zi_pwrrdnghead
       UPDATE
       FIELDS ( docnum Keyid Creby Creon )
       WITH VALUE #( FOR key IN keys
                    ( %tky = gfs_header-%tky
                    docnum = gfs_header-docnum
                    Keyid = gfs_header-keyid
                    Creby = gfs_header-creby
                    Creon = gfs_header-creon
                    %control-docnum = if_abap_behv=>mk-on
                    ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
