CLASS lhc_zi_labour_book DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_labour_book RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_labour_book RESULT result.
    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_labour_book~updateheader.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_labour_book~determinedocnum.

    METHODS checkcombination FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_labour_book~checkcombination.

ENDCLASS.

CLASS lhc_zi_labour_book IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_labour_book IN LOCAL MODE
    ENTITY zi_labour_book
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


      SELECT SINGLE * FROM zcds_plantdata_f4 WHERE loctncd = @gfs_header-plantcode
      INTO @DATA(loc_final).
      IF sy-subrc = 0.
        gfs_header-plantname = loc_final-loctnnam.

      ENDIF.

      MODIFY ENTITIES OF zi_labour_book IN LOCAL MODE
      ENTITY zi_labour_book
      UPDATE
      FIELDS ( plantname )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky
                   plantname = gfs_header-plantname
                   %control-plantname = if_abap_behv=>mk-on
                   ) ).

      MODIFY ENTITIES OF zi_labour_book IN LOCAL MODE
      ENTITY zi_labour_book
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

    READ ENTITIES OF zi_labour_book IN LOCAL MODE
           ENTITY zi_labour_book
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

      SELECT MAX( keyid ) AS keyid FROM zi_labour_book WHERE fisyear = @gfs_header-fisyear
      INTO @DATA(lv_keyid).

      lv_keyid = lv_keyid + 1.
      gfs_header-keyid = lv_keyid.
      gfs_header-docnum = gfs_header-fisyear && lv_keyid.

      MODIFY ENTITIES OF zi_labour_book IN LOCAL MODE
       ENTITY zi_labour_book
       UPDATE
       FIELDS ( docnum keyid creby creon )
       WITH VALUE #( FOR key IN keys
                    ( %tky = gfs_header-%tky
                    docnum = gfs_header-docnum
                    keyid = gfs_header-keyid
                    creby = gfs_header-creby
                    creon = gfs_header-creon
                    %control-docnum = if_abap_behv=>mk-on
                    ) ).

    ENDIF.

  ENDMETHOD.

  METHOD checkcombination.

*  READ ENTITIES OF zi_labour_book IN LOCAL MODE
*             ENTITY zi_labour_book
*             ALL FIELDS
*             WITH CORRESPONDING #( keys )
*             RESULT FINAL(header).
*
*    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*
*    READ ENTITY zi_labour_book
*             BY \_Items
*             ALL FIELDS
*             WITH CORRESPONDING #( keys )
*             RESULT FINAL(item).
*
*    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).
*
*    SELECT SINGLE concat( concat( concat( concat( concat( a~plantcode , a~reportdate ) , b~contcode ), b~deptcode ), b~category ), b~oprcode )
*    FROM zi_labour_book AS a
*    INNER JOIN zi_labour_book_item AS b ON a~id = b~id
*    WHERE a~plantcode = @gfs_header-plantcode
*    AND a~reportdate = @gfs_header-reportdate
*    AND b~contcode = @gfs_item-contcode
*    AND b~deptcode = @gfs_item-deptcode
*    AND b~category = @gfs_item-category
*    AND b~oprcode = @gfs_item-oprcode
*    INTO @DATA(ls_comb).
*
*    IF ls_comb IS NOT INITIAL.
*
*      SELECT SINGLE concat( concat( concat( concat( concat( a~plantcode , a~reportdate ) , b~contcode ), b~deptcode ), b~category ), b~oprcode )
*      FROM zdt_labattnhead AS a
*      INNER JOIN zdt_labattnitem AS b ON a~id = b~id
*      WHERE a~plantcode = @gfs_header-plantcode
*      AND a~reportdate = @gfs_header-reportdate
*      AND b~contcode = @gfs_item-contcode
*      AND b~deptcode = @gfs_item-deptcode
*      AND b~category = @gfs_item-category
*      AND b~oprcode = @gfs_item-oprcode
*      INTO @DATA(ls_comb1).
*
*      IF ls_comb1 IS NOT INITIAL.
*        DATA(lv_msg1) = |Combination has been used on this Report Date|.
*        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_labattnhead.
*
*        APPEND VALUE #( %tky        = gfs_header-%tky
*                        %state_area = 'Validate_Head'
*                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                             text     = lv_msg1 ) )
*        TO reported-zi_labattnhead.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.

ENDCLASS.
