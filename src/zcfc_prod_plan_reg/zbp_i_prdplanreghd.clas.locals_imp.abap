CLASS lhc_zi_prdplanreghd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_prdplanreghd RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_prdplanreghd RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_prdplanreghd~updateheader.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_prdplanreghd~determinedocnum.

    METHODS checkcomb FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_prdplanreghd~checkcomb.

    METHODS checkvalidation FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_prdplanreghd~checkvalidation.

ENDCLASS.

CLASS lhc_zi_prdplanreghd IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA lv_costcode TYPE kostl.

    READ ENTITIES OF zi_prdplanreghd IN LOCAL MODE
    ENTITY zi_prdplanreghd
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


      MODIFY ENTITIES OF zi_prdplanreghd IN LOCAL MODE
      ENTITY zi_prdplanreghd
      UPDATE
      FIELDS ( fisyear )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky
                   fisyear = gfs_header-fisyear
                   %control-fisyear = if_abap_behv=>mk-on
                   ) ).


      SELECT SINGLE * FROM zcds_plantdetails_f4 WHERE plantcode = @gfs_header-plantcode
      INTO @DATA(loc_final).
      IF sy-subrc = 0.
        gfs_header-plantname = loc_final-plantname.

      ENDIF.

      SELECT SINGLE * FROM zcds_prodgroup_f4 WHERE matgrpcode = @gfs_header-matgrpcode
      INTO @DATA(loc_final1).
      IF sy-subrc = 0.
        gfs_header-matgrpname = loc_final1-matgrpname.

      ENDIF.

      MODIFY ENTITIES OF zi_prdplanreghd IN LOCAL MODE
      ENTITY zi_prdplanreghd
      UPDATE
      FIELDS ( plantname matgrpname )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky

                   plantname = gfs_header-plantname
                   matgrpname = gfs_header-matgrpname

                   %control-plantname = if_abap_behv=>mk-on
                   %control-matgrpname = if_abap_behv=>mk-on

                   ) ).

    ENDIF.

  ENDMETHOD.

  METHOD determinedocnum.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_prdplanreghd IN LOCAL MODE
           ENTITY zi_prdplanreghd
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

      SELECT MAX( keyid ) AS keyid FROM zdt_prdplanreghd WHERE fisyear = @gfs_header-fisyear
      INTO @DATA(lv_keyid).

      lv_keyid = lv_keyid + 1.
      gfs_header-keyid = lv_keyid.
      gfs_header-docnum = gfs_header-fisyear && lv_keyid.

      MODIFY ENTITIES OF zi_prdplanreghd IN LOCAL MODE
       ENTITY zi_prdplanreghd
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

  METHOD checkcomb.

    READ ENTITIES OF zi_prdplanreghd IN LOCAL MODE
               ENTITY zi_prdplanreghd
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_prdplanreghd
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    SELECT SINGLE concat( concat( concat( a~plantcode , a~matgrpcode ) , a~prodyear ), a~prodmonth )
    FROM zi_prdplanreghd AS a
    INNER JOIN zi_prdplanregit AS b ON a~id = b~id
    WHERE a~plantcode = @gfs_header-plantcode
    AND a~matgrpcode = @gfs_header-matgrpcode
    AND a~prodyear = @gfs_header-prodyear
    AND a~prodmonth = @gfs_header-prodmonth
    INTO @DATA(ls_comb).

    IF ls_comb IS NOT INITIAL.

      SELECT SINGLE concat( concat( concat( a~plantcode , a~matgrpcode ) , a~prodyear ), a~prodmonth )
      FROM zdt_prdplanreghd AS a
      INNER JOIN zdt_prdplanregit AS b ON a~id = b~id
      WHERE a~plantcode = @gfs_header-plantcode
      AND a~matgrpcode = @gfs_header-matgrpcode
      AND a~prodyear = @gfs_header-prodyear
      AND a~prodmonth = @gfs_header-prodmonth
      INTO @DATA(ls_comb1).

      IF ls_comb1 IS NOT INITIAL.
        DATA(lv_msg1) = |Combination of Plant, MatGrp, Year & Month exists|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_prdplanreghd.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_prdplanreghd.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD checkvalidation.

    READ ENTITIES OF zi_prdplanreghd IN LOCAL MODE
    ENTITY zi_prdplanreghd
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    READ ENTITY zi_prdplanreghd
    BY \_item
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(item).


    DATA lt_prodcode TYPE SORTED TABLE OF zi_prdplanregit-prodcode
                 WITH UNIQUE KEY table_line.

    LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item>).

      INSERT <fs_item>-prodcode INTO TABLE lt_prodcode.
      IF sy-subrc <> 0.

        DATA(lv_msg) = |Duplicate Product Code "{ <fs_item>-prodcode }" exists.|.

        APPEND VALUE #( %tky = gfs_header-%tky )
          TO failed-zi_prdplanreghd.

        APPEND VALUE #(
          %tky        = gfs_header-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                         text     = lv_msg ) )
          TO reported-zi_prdplanreghd.

        EXIT. "Stop after first duplicate
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_prdplanregit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS updateitem1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_prdplanregit~updateitem1.

ENDCLASS.

CLASS lhc_zi_prdplanregit IMPLEMENTATION.

  METHOD updateitem1.

    READ ENTITIES OF zi_prdplanreghd IN LOCAL MODE
                 ENTITY zi_prdplanreghd
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_prdplanreghd
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~prodcode, a~prodname
    FROM zcds_product_f4 AS a
    WHERE a~prodcode = @gfs_item-prodcode
    AND a~plantcode = @gfs_header-plantcode
    AND a~matgrpcode = @gfs_header-matgrpcode
    INTO @DATA(ls_comb1).

    IF sy-subrc = 0.
      gfs_item-prodname = ls_comb1-prodname.

    ENDIF.

    MODIFY ENTITIES OF zi_prdplanreghd IN LOCAL MODE
      ENTITY zi_prdplanregit
      UPDATE
      FIELDS ( prodname  )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_item-%tky
                   prodname = gfs_item-prodname

                   %control-prodname = if_abap_behv=>mk-on

                   ) ).

  ENDMETHOD.

ENDCLASS.
