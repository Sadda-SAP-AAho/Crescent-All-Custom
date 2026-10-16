CLASS lhc_zi_mldprdreghed DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_mldprdreghed RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_mldprdreghed RESULT result.


    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_mldprdreghed~updateheader.

    METHODS checkvalidation1 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_mldprdreghed~checkvalidation1.



ENDCLASS.

CLASS lhc_zi_mldprdreghed IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_mldprdreghed IN LOCAL MODE
      ENTITY zi_mldprdreghed
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zi_plant WHERE plantcd = @gfs_header-plntcd
    INTO @DATA(loc_final1).

    IF sy-subrc = 0.
      gfs_header-plntnm = loc_final1-plantnm.
    ENDIF.

    SELECT SINGLE * FROM zi_costcenter WHERE cstcntr = @gfs_header-cstcntr
    INTO @DATA(loc_final2).

    IF sy-subrc = 0.
      gfs_header-cstcntrnm = loc_final2-cstcntrtxt.
    ENDIF.

    SELECT SINGLE * FROM zi_profitcenter WHERE prftcntr = @gfs_header-prftcntr
    INTO @DATA(loc_final3).

    IF sy-subrc = 0.
      gfs_header-prftcntrnm = loc_final3-prftcntrnm.
    ENDIF.

    MODIFY ENTITIES OF zi_mldprdreghed IN LOCAL MODE
    ENTITY zi_mldprdreghed
    UPDATE
    FIELDS ( plntnm cstcntrnm prftcntrnm )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 plntnm = gfs_header-plntnm
                 cstcntrnm = gfs_header-cstcntrnm
                 prftcntrnm = gfs_header-prftcntrnm
                 %control-plntnm = if_abap_behv=>mk-on
                 %control-cstcntrnm = if_abap_behv=>mk-on
                 %control-prftcntrnm = if_abap_behv=>mk-on
                 ) ).


  ENDMETHOD.


  METHOD checkvalidation1.

*--------------------------------------------------------------------*
* 1) READ HEADER FROM PAYLOAD
*--------------------------------------------------------------------*
    READ ENTITIES OF zi_mldprdreghed IN LOCAL MODE
      ENTITY zi_mldprdreghed
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA(gfs_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF gfs_header IS INITIAL.
      RETURN.
    ENDIF.

*--------------------------------------------------------------------*
* 2) READ INCOMING ITEMS FROM PAYLOAD
*--------------------------------------------------------------------*
    READ ENTITIES OF zi_mldprdreghed IN LOCAL MODE
      ENTITY zi_mldprdreghed BY \_item
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items_payload).

    IF lt_items_payload IS INITIAL.
      RETURN.
    ENDIF.

*--------------------------------------------------------------------*
* 3) CHECK DUPLICATES WITHIN PAYLOAD ONLY
*--------------------------------------------------------------------*
    DATA lt_payload_unique TYPE SORTED TABLE OF zi_mldprdregitm-typeofmould
                           WITH UNIQUE KEY table_line.

    LOOP AT lt_items_payload INTO DATA(ls_payload_item).

      IF line_exists(
           lt_payload_unique[ table_line = ls_payload_item-typeofmould ] ).

        APPEND VALUE #( %tky = gfs_header-%tky )
          TO failed-zi_mldprdreghed.

        APPEND VALUE #(
          %tky        = gfs_header-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Duplicate Type of Mould in payload not allowed| )
        ) TO reported-zi_mldprdreghed.

        RETURN.
      ENDIF.

      INSERT ls_payload_item-typeofmould
        INTO TABLE lt_payload_unique.

    ENDLOOP.

*--------------------------------------------------------------------*
* 4) CHECK DUPLICATES WITH EXISTING ITEMS OF SAME HEADER
*--------------------------------------------------------------------*
    DATA lt_existing TYPE SORTED TABLE OF zi_mldprdregitm-typeofmould
                     WITH UNIQUE KEY table_line.

    SELECT typeofmould
      FROM zdt_mldprdregitm
      WHERE id = @gfs_header-id
      INTO TABLE @lt_existing.

    LOOP AT lt_items_payload INTO DATA(ls_payload_chk).

      IF line_exists(
           lt_existing[ table_line = ls_payload_chk-typeofmould ] ).

        APPEND VALUE #( %tky = gfs_header-%tky )
          TO failed-zi_mldprdreghed.

        APPEND VALUE #(
          %tky        = gfs_header-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Duplicate Type of Mould within header not allowed| )
        ) TO reported-zi_mldprdreghed.

        RETURN.
      ENDIF.

    ENDLOOP.

*--------------------------------------------------------------------*
* 5) DATABASE-WIDE CHECK (OTHER HEADERS)
*--------------------------------------------------------------------*
    TYPES: BEGIN OF ty_mould,
             typeofmould TYPE zi_mldprdregitm-typeofmould,
           END OF ty_mould.

    DATA lt_payload_db TYPE STANDARD TABLE OF ty_mould.

    lt_payload_db = VALUE #(
      FOR x IN lt_items_payload
      ( typeofmould = x-typeofmould )
    ).

    SELECT h~id, i~typeofmould
      FROM zdt_mldprdreghed AS h
      INNER JOIN zdt_mldprdregitm AS i
        ON h~id = i~id
      FOR ALL ENTRIES IN @lt_payload_db
      WHERE h~prddate      = @gfs_header-prddate
        AND h~plntcd       = @gfs_header-plntcd
        AND h~cstcntr      = @gfs_header-cstcntr
        AND h~id          <> @gfs_header-id
        AND i~typeofmould = @lt_payload_db-typeofmould
      INTO TABLE @DATA(lt_conflict).

    IF sy-subrc = 0.

      APPEND VALUE #( %tky = gfs_header-%tky )
        TO failed-zi_mldprdreghed.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'Validate_Head'
        %msg        = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Type of Mould already exists for this combination| )
      ) TO reported-zi_mldprdreghed.

    ENDIF.

  ENDMETHOD.


ENDCLASS.
