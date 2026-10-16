CLASS lhc_zi_spprmswrkhdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_spprmswrkhdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_spprmswrkhdr RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_spprmswrkhdr~updateheader.

    METHODS checkcombination FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_spprmswrkhdr~checkcombination.


ENDCLASS.

CLASS lhc_zi_spprmswrkhdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_spprmswrkhdr IN LOCAL MODE
      ENTITY zi_spprmswrkhdr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zcds_plantdt_f4 WHERE loctncd = @gfs_header-plantcode
        INTO @DATA(loc_final).
    IF sy-subrc = 0.
      gfs_header-plantname = loc_final-loctnnam.

    ENDIF.

    MODIFY ENTITIES OF zi_spprmswrkhdr IN LOCAL MODE
    ENTITY zi_spprmswrkhdr
    UPDATE
    FIELDS ( plantname )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 plantname = gfs_header-plantname
                 %control-plantname = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

  METHOD checkcombination.

    READ ENTITIES OF zi_spprmswrkhdr IN LOCAL MODE
             ENTITY zi_spprmswrkhdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE concat( a~plantcode , a~workcode )
    FROM zi_spprmswrkhdr AS a
    WHERE a~plantcode = @gfs_header-plantcode
    AND a~workcode = @gfs_header-workcode
    INTO @DATA(ls_comb).

    IF ls_comb IS NOT INITIAL.

      SELECT SINGLE concat( a~plantcode , a~workcode )
      FROM zdt_spprmswrkhdr AS a
      WHERE a~plantcode = @gfs_header-plantcode
    AND a~workcode = @gfs_header-workcode
      INTO @DATA(ls_comb1).

      IF ls_comb1 IS NOT INITIAL.
        DATA(lv_msg1) = |Combination of Plant,Work Code are already used|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_spprmswrkhdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_spprmswrkhdr.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.


CLASS lhc_zi_spprmswrkitm DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS checkdaterange FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_spprmswrkitm~checkdaterange.

ENDCLASS.

CLASS lhc_zi_spprmswrkitm IMPLEMENTATION.

  METHOD checkdaterange.

    " Read headers for all keys
    READ ENTITIES OF zi_spprmswrkhdr IN LOCAL MODE
         ENTITY zi_spprmswrkhdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header).

    " Read items for all keys via association
    READ ENTITIES OF zi_spprmswrkhdr IN LOCAL MODE
         ENTITY zi_spprmswrkhdr BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item).

    DATA(ls_head) = VALUE #( header[ 1 ] OPTIONAL  ).

    " Loop through each key and validate
    LOOP AT item INTO DATA(ls_item).

      " Check if any other line within same PlantCode + WorkCode overlaps in date range
      SELECT SINGLE concat( a~plantcode, a~workcode )
        FROM zdr_spprmswrkhdr AS a
        INNER JOIN zdr_spprmswrkitm AS b ON a~id = b~id
        WHERE a~plantcode = @ls_head-plantcode
          AND a~workcode  = @ls_head-workcode
          AND b~item <> @ls_item-item    " exclude same item
          AND (
               ( @ls_item-datefrom BETWEEN b~datefrom AND b~dateto )
            OR ( @ls_item-dateto   BETWEEN b~datefrom AND b~dateto )
            OR ( @ls_item-datefrom <= b~datefrom AND @ls_item-dateto >= b~dateto )
              )
        INTO @DATA(ls_comb1).

      IF ls_comb1 IS NOT INITIAL.

        " Mark this header as failed
        APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_spprmswrkhdr.

        " Report validation error
        APPEND VALUE #(
          %tky        = ls_head-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Date range overlaps for Plant { ls_head-plantcode } and Workcode { ls_head-workcode }| ) )
          TO reported-zi_spprmswrkhdr.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
