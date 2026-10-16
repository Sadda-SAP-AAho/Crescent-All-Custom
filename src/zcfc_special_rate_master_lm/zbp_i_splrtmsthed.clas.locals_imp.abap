CLASS lhc_zi_splrtmsthed DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_splrtmsthed RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_splrtmsthed RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_splrtmsthed~updateheader.

    METHODS checkheadcomb FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_splrtmsthed~checkheadcomb.


ENDCLASS.

CLASS lhc_zi_splrtmsthed IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_splrtmsthed IN LOCAL MODE
  ENTITY zi_splrtmsthed
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

*  Plant
    SELECT SINGLE * FROM zi_plant_lm_f4 WHERE loctncd = @gfs_header-plntcd
    INTO @DATA(loc_final1).

    IF sy-subrc = 0.
      gfs_header-plntnm = loc_final1-loctnnam.
    ENDIF.
*      LM CODE
    SELECT SINGLE * FROM zi_material_lm_f4 WHERE product = @gfs_header-lmcd
 INTO @DATA(loc_final2).

    IF sy-subrc = 0.
      gfs_header-lmnm = loc_final1-loctnnam.
    ENDIF.


    MODIFY ENTITIES OF zi_splrtmsthed IN LOCAL MODE
ENTITY zi_splrtmsthed
UPDATE
FIELDS ( plntnm lmnm )
WITH VALUE #( FOR key IN keys
( %tky = gfs_header-%tky
 plntnm = gfs_header-plntnm
 lmnm   = gfs_header-lmnm
 %control-plntnm = if_abap_behv=>mk-on
 %control-lmnm = if_abap_behv=>mk-on

    ) ).

  ENDMETHOD.

  METHOD checkheadcomb.

    READ ENTITIES OF zi_splrtmsthed IN LOCAL MODE
             ENTITY zi_splrtmsthed
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE concat( a~plntcd , a~lmcd )
    FROM zi_splrtmsthed AS a
    WHERE a~plntcd = @gfs_header-plntcd
    AND a~lmcd = @gfs_header-lmcd
    INTO @DATA(ls_comb).

    IF ls_comb IS NOT INITIAL.

      SELECT SINGLE concat( a~plntcd , a~lmcd )
  FROM zdt_splrtmsthed AS a
  WHERE a~plntcd = @gfs_header-plntcd
AND a~lmcd = @gfs_header-lmcd
  INTO @DATA(ls_comb1).

      IF ls_comb1 IS NOT INITIAL.
        DATA(lv_msg1) = |Combination of Plant,LM Code are already used|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_splrtmsthed.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_splrtmsthed.
      ENDIF.
    ENDIF.

  ENDMETHOD.



ENDCLASS.

CLASS lhc_zi_splrtmstitm DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS checkdaterange FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_splrtmstitm~checkdaterange.

ENDCLASS.

CLASS lhc_zi_splrtmstitm IMPLEMENTATION.

  METHOD checkdaterange.

    " Read headers for all keys
    READ ENTITIES OF zi_splrtmsthed IN LOCAL MODE
         ENTITY zi_splrtmsthed
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header).

    " Read items for all keys via association
    READ ENTITIES OF zi_splrtmsthed IN LOCAL MODE
         ENTITY zi_splrtmsthed BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item).

    DATA(ls_head) = VALUE #( header[ 1 ] OPTIONAL  ).

    " Loop through each key and validate
    LOOP AT item INTO DATA(ls_item).

      " Check if any other line within same PlantCode + WorkCode overlaps in date range
      SELECT SINGLE concat( a~plntcd, a~lmcd )
        FROM zdr_splrtmsthed AS a
        INNER JOIN zdr_splrtmstitm AS b ON a~id = b~id
        WHERE a~plntcd = @ls_head-plntcd
          AND a~lmcd  = @ls_head-lmcd
          AND b~item <> @ls_item-item    " exclude same item
          AND (
               ( @ls_item-datefrom BETWEEN b~datefrom AND b~dateto )
            OR ( @ls_item-dateto   BETWEEN b~datefrom AND b~dateto )
            OR ( @ls_item-datefrom <= b~datefrom AND @ls_item-dateto >= b~dateto )
              )
        INTO @DATA(ls_comb1).

      IF ls_comb1 IS NOT INITIAL.

        " Mark this header as failed
        APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_splrtmsthed.

        " Report validation error
        APPEND VALUE #(
          %tky        = ls_head-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Date range overlaps for Plant { ls_head-plntcd } and Workcode { ls_head-lmcd }| ) )
          TO reported-zi_splrtmsthed.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
