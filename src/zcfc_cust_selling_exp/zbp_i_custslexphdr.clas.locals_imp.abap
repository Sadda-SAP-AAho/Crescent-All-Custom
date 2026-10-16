CLASS lhc_zi_custslexpitm DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS checkdaterange FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_custslexpitm~checkdaterange.
    METHODS itemdetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_custslexpitm~itemdetails.

ENDCLASS.

CLASS lhc_zi_custslexpitm IMPLEMENTATION.

  METHOD checkdaterange.

    " Read headers for all keys
    READ ENTITIES OF zi_custslexphdr IN LOCAL MODE
         ENTITY zi_custslexphdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header).

    " Read items for all keys via association
    READ ENTITIES OF zi_custslexphdr IN LOCAL MODE
         ENTITY zi_custslexphdr BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item).

    DATA(ls_head) = VALUE #( header[ 1 ] OPTIONAL  ).


    " Loop through each key and validate
    LOOP AT item INTO DATA(ls_item).

*      " Match header for this key
*      READ TABLE header INTO DATA(ls_header)
*           WITH KEY %tky = ls_key-%tky.
*      IF sy-subrc <> 0.
*        CONTINUE.
*      ENDIF.

*      " Match item for this key
*      READ TABLE item INTO DATA(ls_item)
*           WITH KEY %tky = ls_key-%tky.
*      IF sy-subrc <> 0.
*        CONTINUE.
*      ENDIF.

      " Check overlapping date range
      SELECT SINGLE concat( a~custcode , a~expcode )
        FROM zdr_custslexphdr AS a
        INNER JOIN zdr_custslexpitm AS b
          ON a~id = b~id
        WHERE a~custcode = @ls_head-custcode
          AND a~expcode  = @ls_head-expcode
          AND b~id <> @ls_item-id
          AND (
               ( @ls_item-datefrom BETWEEN b~datefrom AND b~dateto )
            OR ( @ls_item-dateto BETWEEN b~datefrom AND b~dateto )
            OR ( @ls_item-datefrom LE b~datefrom AND @ls_item-dateto GE b~dateto )
              )
        INTO @DATA(ls_comb1).

      IF ls_comb1 IS NOT INITIAL.

        " Mark this item as failed
        APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_custslexphdr.

        APPEND VALUE #(
          %tky        = ls_head-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Date Range is Overlaped| ) )
        TO reported-zi_custslexphdr.

      ENDIF.

      " Check overlapping date range
      SELECT SINGLE concat( a~custcode , a~expcode )
        FROM zi_custslexphdr AS a
        INNER JOIN zi_custslexpitm AS b
          ON a~id = b~id
        WHERE a~custcode = @ls_head-custcode
          AND a~expcode  = @ls_head-expcode
          AND (
               ( @ls_item-datefrom BETWEEN b~datefrom AND b~dateto )
            OR ( @ls_item-dateto BETWEEN b~datefrom AND b~dateto )
            OR ( @ls_item-datefrom LE b~datefrom AND @ls_item-dateto GE b~dateto )
              )
        INTO @DATA(ls_comb2).

      IF ls_comb2 IS NOT INITIAL.

        " Mark this item as failed
        APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_custslexphdr.

        APPEND VALUE #(
          %tky        = ls_head-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Date Range is used previously| ) )
        TO reported-zi_custslexphdr.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD itemdetails.

    READ ENTITIES OF zi_custslexphdr IN LOCAL MODE
         ENTITY zi_custslexphdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_custslexphdr IN LOCAL MODE
         ENTITY zi_custslexpitm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    LOOP AT lt_item INTO DATA(ls_item).


      MODIFY ENTITIES OF zi_custslexphdr IN LOCAL MODE
             ENTITY zi_custslexpitm
             UPDATE
             FIELDS ( rate currency datefrom dateto )
             WITH VALUE #( id = ls_item-id
                           ( %tky       = ls_item-%tky
                             rate = ls_item-rate
                             currency = ls_item-currency
                             datefrom      = ls_item-datefrom
                             dateto      = ls_item-dateto
                               ) ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_custslexphdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_custslexphdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_custslexphdr RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_custslexphdr~updateheader.

    METHODS checkcomb FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_custslexphdr~checkcomb.

    METHODS savecreate FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_custslexphdr~savecreate.

ENDCLASS.

CLASS lhc_zi_custslexphdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_custslexphdr IN LOCAL MODE
        ENTITY zi_custslexphdr
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zcds_customer_f4 WHERE custcode = @gfs_header-custcode
        INTO @DATA(loc_final1).
    IF sy-subrc = 0.
      gfs_header-custname = loc_final1-custname.

    ENDIF.

    SELECT SINGLE * FROM zcds_selexp_f4 WHERE expcode = @gfs_header-expcode
        INTO @DATA(loc_final2).
    IF sy-subrc = 0.
      gfs_header-expname = loc_final2-expname.

    ENDIF.

    MODIFY ENTITIES OF zi_custslexphdr IN LOCAL MODE
    ENTITY zi_custslexphdr
    UPDATE
    FIELDS ( custname expname )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 custname = gfs_header-custname
                 expname = gfs_header-expname
                 %control-custname = if_abap_behv=>mk-on
                 %control-expname = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

  METHOD checkcomb.

    READ ENTITIES OF zi_custslexphdr IN LOCAL MODE
               ENTITY zi_custslexphdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE concat( a~custcode , a~expcode )
    FROM zi_custslexphdr AS a
    WHERE a~custcode = @gfs_header-custcode
    AND a~expcode = @gfs_header-expcode
    INTO @DATA(ls_comb).

    IF ls_comb IS NOT INITIAL.

      SELECT SINGLE concat( a~custcode , a~expcode )
      FROM zdt_custslexphdr AS a
      WHERE a~custcode = @gfs_header-custcode
      AND a~expcode = @gfs_header-expcode
      INTO @DATA(ls_comb1).

      IF ls_comb1 IS NOT INITIAL.
        DATA(lv_msg1) = |Combination of Customer,Selling Expense are already used|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_custslexphdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_custslexphdr.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD savecreate.

    READ ENTITIES OF zi_custslexphdr IN LOCAL MODE
         ENTITY zi_custslexphdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zcds_customer_f4 WHERE custcode = @gfs_header-custcode
        INTO @DATA(loc_final1).
    IF sy-subrc = 0.
      gfs_header-custname = loc_final1-custname.

    ENDIF.

    SELECT SINGLE * FROM zcds_selexp_f4 WHERE expcode = @gfs_header-expcode
        INTO @DATA(loc_final2).
    IF sy-subrc = 0.
      gfs_header-expname = loc_final2-expname.

    ENDIF.

    MODIFY ENTITIES OF zi_custslexphdr IN LOCAL MODE
    ENTITY zi_custslexphdr
    UPDATE
    FIELDS ( custname expname )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 custname = gfs_header-custname
                 expname = gfs_header-expname
                 %control-custname = if_abap_behv=>mk-on
                 %control-expname = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

ENDCLASS.
