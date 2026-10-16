CLASS lhc_zi_labbkreghead DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_labbkreghead RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_labbkreghead RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_labbkreghead~updateheader.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_labbkreghead~determinedocnum.


ENDCLASS.

CLASS lhc_zi_labbkreghead IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA lv_costcode TYPE kostl.

    READ ENTITIES OF zi_labbkreghead IN LOCAL MODE
    ENTITY zi_labbkreghead
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

      gfs_header-creby = sy-uname.
      gfs_header-creon = lv_date.

      gfs_header-fisyear = lv_date+2(2) && lv_date+2(2).
      gfs_header-fisyear = gfs_header-fisyear + 1.

      lv_costcode = '0000' && gfs_header-costcode.

      MODIFY ENTITIES OF zi_labbkreghead IN LOCAL MODE
      ENTITY zi_labbkreghead
      UPDATE
      FIELDS ( fisyear )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky
                   fisyear = gfs_header-fisyear
                   %control-fisyear = if_abap_behv=>mk-on
                   ) ).


      SELECT SINGLE * FROM zcds_plantdet_f4 WHERE loctncd = @gfs_header-plantcode
      INTO @DATA(loc_final).
      IF sy-subrc = 0.
        gfs_header-plantname = loc_final-loctnnam.

      ENDIF.

      SELECT SINGLE * FROM zcds_costcenter_f4 WHERE costcode = @lv_costcode
      INTO @DATA(loc_final1).
      IF sy-subrc = 0.
        gfs_header-costname = loc_final1-costname.

      ENDIF.

      SELECT SINGLE * FROM zcds_contrlist_f4 WHERE contcode = @gfs_header-contcode
      INTO @DATA(loc_final2).
      IF sy-subrc = 0.
        gfs_header-contname = loc_final2-contname.

      ENDIF.

      SELECT SINGLE * FROM zcds_operationdata_f4 WHERE oprcode = @gfs_header-oprcode
      INTO @DATA(loc_final3).
      IF sy-subrc = 0.
        gfs_header-oprname = loc_final3-oprname.

      ENDIF.

      MODIFY ENTITIES OF zi_labbkreghead IN LOCAL MODE
      ENTITY zi_labbkreghead
      UPDATE
      FIELDS ( plantname costname contname oprname creby creon )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky

                   plantname = gfs_header-plantname
                   costname = gfs_header-costname
                   contname = gfs_header-contname
                   oprname = gfs_header-oprname
                   creby     = gfs_header-creby
                   creon     = gfs_header-creon

                   %control-plantname = if_abap_behv=>mk-on
                   %control-costname = if_abap_behv=>mk-on
                   %control-contname = if_abap_behv=>mk-on
                   %control-oprname = if_abap_behv=>mk-on
                   %control-creby = if_abap_behv=>mk-on
                   %control-creon = if_abap_behv=>mk-on
                   ) ).

    ENDIF.

  ENDMETHOD.



  METHOD determinedocnum.

    DATA lv_date          TYPE datn.
    DATA lv_time          TYPE timn.
    DATA lv_max_keyid     TYPE i.
    DATA lv_new_keyid     TYPE i.
    DATA lv_max_newkeyid  TYPE i.

    READ ENTITIES OF zi_labbkreghead IN LOCAL MODE
           ENTITY zi_labbkreghead
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    IF gfs_header IS INITIAL.
      RETURN.
    ENDIF.


    "------------------------------------------------------------
    " Get current date and time
    "------------------------------------------------------------
    TRY.

        CONVERT DATE cl_abap_context_info=>get_system_date( )
                TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp)
                TIME ZONE cl_abap_context_info=>get_user_time_zone( ).

      CATCH cx_abap_context_info_error.
        RETURN.

    ENDTRY.


    CONVERT TIME STAMP lv_timestamp
            TIME ZONE 'INDIA'
            INTO DATE lv_date
                 TIME lv_time.


    "============================================================
    " CASE 1
    " Existing old record
    "
    " CREON < 20260915
    " NEWKEYID is INITIAL
    "
    " NEWKEYID = 00 + existing KEYID
    "============================================================
    IF gfs_header-creon IS NOT INITIAL
       AND gfs_header-creon < '20260915'
       AND gfs_header-newkeyid IS INITIAL.

      gfs_header-newkeyid =
          |00{ gfs_header-keyid }|.

      gfs_header-newdocnum =
          |{ gfs_header-fisyear }{ gfs_header-newkeyid }|.


      "============================================================
      " CASE 2A
      " New entry
      "
      " CREON >= 20260915
      " NEWKEYID is INITIAL
      " MAX(KEYID) < 9999
      "
      " KEYID    = MAX(KEYID) + 1
      " NEWKEYID = KEYID
      "============================================================
    ELSEIF gfs_header-creon IS NOT INITIAL
       AND gfs_header-creon >= '20260915'
       AND gfs_header-newkeyid IS INITIAL.

      SELECT MAX( keyid )
        FROM zdt_labbkreghead
        WHERE fisyear = @gfs_header-fisyear
        INTO @DATA(lv_max_keyid_char).

      IF lv_max_keyid_char IS INITIAL.
        lv_max_keyid = 0.
      ELSE.
        lv_max_keyid = CONV i( lv_max_keyid_char ).
      ENDIF.


      "--------------------------------------------------------
      " KEYID still available below 9999
      "--------------------------------------------------------
      IF lv_max_keyid < 9999.

        lv_new_keyid = lv_max_keyid + 1.

        "KEYID = 4 digits
        gfs_header-keyid =
            |{ lv_new_keyid WIDTH = 4 ALIGN = RIGHT PAD = '0' }|.

        "NEWKEYID = same number, 6 digits
        gfs_header-newkeyid =
            |{ lv_new_keyid WIDTH = 6 ALIGN = RIGHT PAD = '0' }|.


        "--------------------------------------------------------
        " KEYID reached 9999
        "
        " Cannot generate 10000 because KEYID is 4 digits.
        " Therefore continue NEWKEYID sequence.
        "--------------------------------------------------------
      ELSE.

        "Keep KEYID at 9999
        gfs_header-keyid =
            |{ lv_max_keyid WIDTH = 4 ALIGN = RIGHT PAD = '0' }|.


        "Get MAX NEWKEYID
        SELECT MAX( newkeyid )
          FROM zdt_labbkreghead
          WHERE fisyear = @gfs_header-fisyear
          INTO @DATA(lv_max_newkeyid_char).

        IF lv_max_newkeyid_char IS INITIAL.

          "First NEWKEYID after KEYID 9999
          lv_new_keyid = 10000.

        ELSE.

          lv_new_keyid =
              CONV i( lv_max_newkeyid_char ) + 1.

        ENDIF.


        "NEWKEYID = 6 digits
        gfs_header-newkeyid =
            |{ lv_new_keyid WIDTH = 6 ALIGN = RIGHT PAD = '0' }|.

      ENDIF.


      "--------------------------------------------------------
      " NEWDOCNUM
      "--------------------------------------------------------
      gfs_header-newdocnum =
          |{ gfs_header-fisyear }{ gfs_header-newkeyid }|.


      "Creation information
      gfs_header-creby = sy-uname.
      gfs_header-creon = lv_date.


      "============================================================
      " CASE 3
      " New entry where NEWKEYID is already populated
      "
      " CREON >= 20260915
      " NEWKEYID is NOT INITIAL
      "
      " KEYID    = unchanged
      " NEWKEYID = MAX(NEWKEYID) + 1
      "============================================================
    ELSEIF gfs_header-creon IS NOT INITIAL
       AND gfs_header-creon >= '20260915'
       AND gfs_header-newkeyid IS NOT INITIAL.

      SELECT MAX( newkeyid )
        FROM zdt_labbkreghead
        WHERE fisyear = @gfs_header-fisyear
        INTO @DATA(lv_max_newkeyid_char_2).

      IF lv_max_newkeyid_char_2 IS INITIAL.

        lv_new_keyid = 10000.

      ELSE.

        lv_new_keyid =
            CONV i( lv_max_newkeyid_char_2 ) + 1.

      ENDIF.


      "KEYID remains unchanged

      "NEWKEYID = 6 digits
      gfs_header-newkeyid =
          |{ lv_new_keyid WIDTH = 6 ALIGN = RIGHT PAD = '0' }|.


      "NEWDOCNUM
      gfs_header-newdocnum =
          |{ gfs_header-fisyear }{ gfs_header-newkeyid }|.


      "Creation information
      gfs_header-creby = sy-uname.
      gfs_header-creon = lv_date.

    ENDIF.


    "============================================================
    " Update entity
    "============================================================
    MODIFY ENTITIES OF zi_labbkreghead IN LOCAL MODE
      ENTITY zi_labbkreghead
      UPDATE
      FIELDS ( docnum
               keyid
               creby
               creon
               newkeyid
               newdocnum )
      WITH VALUE #(
        FOR key IN keys
        (
          %tky = gfs_header-%tky

          docnum    = gfs_header-docnum
          keyid     = gfs_header-keyid
          creby     = gfs_header-creby
          creon     = gfs_header-creon
          newkeyid  = gfs_header-newkeyid
          newdocnum = gfs_header-newdocnum

          %control-docnum    = if_abap_behv=>mk-on
          %control-keyid     = if_abap_behv=>mk-on
          %control-creby     = if_abap_behv=>mk-on
          %control-creon     = if_abap_behv=>mk-on
          %control-newkeyid  = if_abap_behv=>mk-on
          %control-newdocnum = if_abap_behv=>mk-on
        )
      ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_labbkregitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS updateitem1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_labbkregitem~updateitem1.

    METHODS updateitem2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_labbkregitem~updateitem2.

    METHODS updateitem3 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_labbkregitem~updateitem3.

    METHODS validateworkcode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_labbkregitem~validateworkcode.

ENDCLASS.

CLASS lhc_zi_labbkregitem IMPLEMENTATION.

  METHOD updateitem1.

    READ ENTITIES OF zi_labbkreghead IN LOCAL MODE
               ENTITY zi_labbkreghead
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_labbkreghead
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~workcode, a~workname
    FROM zi_spprmswrkhdr AS a
    WHERE a~workcode = @gfs_item-workcode
    AND a~plantcode = @gfs_header-plantcode
    INTO @DATA(ls_comb1).

    IF sy-subrc = 0.
      gfs_item-workname = ls_comb1-workname.

    ENDIF.

    SELECT SINGLE a~workcode,b~uom,b~rate
    FROM zi_spprmswrkhdr AS a
    INNER JOIN zi_spprmswrkitm AS b ON a~id = b~id
    WHERE a~workcode = @gfs_item-workcode
      AND a~plantcode = @gfs_header-plantcode
      AND ( b~datefrom LE @gfs_header-rptdate AND b~dateto GE @gfs_header-rptdate )
    INTO @DATA(ls_comb2).

    IF sy-subrc = 0.
      gfs_item-uom = ls_comb2-uom.
      gfs_item-rate = ls_comb2-rate.

    ENDIF.

    MODIFY ENTITIES OF zi_labbkreghead IN LOCAL MODE
      ENTITY zi_labbkregitem
      UPDATE
      FIELDS ( workname uom rate )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_item-%tky
                   workname = gfs_item-workname
                   uom = gfs_item-uom
                   rate = gfs_item-rate
                   %control-workname = if_abap_behv=>mk-on
                   %control-uom = if_abap_behv=>mk-on
                   %control-rate = if_abap_behv=>mk-on
                   ) ).

  ENDMETHOD.

  METHOD updateitem2.

    READ ENTITIES OF zi_labbkreghead IN LOCAL MODE
                 ENTITY zi_labbkreghead
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_labbkreghead
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~workcode,b~rate
    FROM zi_spprmswrkhdr AS a
    INNER JOIN zi_spprmswrkitm AS b ON a~id = b~id
    WHERE a~workcode = @gfs_item-workcode
      AND a~plantcode = @gfs_header-plantcode
      AND ( b~datefrom LE @gfs_header-rptdate AND b~dateto GE @gfs_header-rptdate )
    INTO @DATA(ls_comb3).

    IF sy-subrc = 0.
      gfs_item-amount = ( gfs_item-quantity * gfs_item-rate ).

    ENDIF.

    MODIFY ENTITIES OF zi_labbkreghead IN LOCAL MODE
    ENTITY zi_labbkregitem
    UPDATE
    FIELDS ( amount )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_item-%tky
                 amount = gfs_item-amount
                 %control-amount = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

  METHOD updateitem3.

    READ ENTITIES OF zi_labbkreghead IN LOCAL MODE
                 ENTITY zi_labbkreghead
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_labbkreghead
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM zcds_employee_f4 WHERE empcode = @gfs_item-aprvcode
    INTO @DATA(loc_comb4).

    IF sy-subrc = 0.
      gfs_item-aprvname = loc_comb4-empname.

    ENDIF.

    MODIFY ENTITIES OF zi_labbkreghead IN LOCAL MODE
    ENTITY zi_labbkregitem
    UPDATE
    FIELDS ( aprvname )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_item-%tky
                 aprvname = gfs_item-aprvname
                 %control-aprvname = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

  METHOD validateworkcode.

    READ ENTITIES OF zi_labbkreghead IN LOCAL MODE
      ENTITY zi_labbkregitem
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    LOOP AT items INTO DATA(item).

      IF item-workcode IS INITIAL.

        APPEND VALUE #(
          %tky = item-%tky
        ) TO failed-zi_labbkregitem.

        APPEND VALUE #(
          %tky = item-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Work code cannot be blank.'
                 )
        ) TO reported-zi_labbkregitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
