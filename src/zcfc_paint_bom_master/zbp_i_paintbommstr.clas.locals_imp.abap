CLASS lhc_zi_paintbommstr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_paintbommstr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_paintbommstr RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_paintbommstr~updateheader.

    METHODS checkvalidation FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_paintbommstr~checkvalidation.

ENDCLASS.

CLASS lhc_zi_paintbommstr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_paintbommstr IN LOCAL MODE
      ENTITY zi_paintbommstr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zi_paintitem_f4 WHERE product = @gfs_header-paintitmcd
      INTO @DATA(loc_final1).
    IF sy-subrc = 0.
      gfs_header-paintitmnm = loc_final1-productname.

    ENDIF.

    MODIFY ENTITIES OF zi_paintbommstr IN LOCAL MODE
    ENTITY zi_paintbommstr
    UPDATE
    FIELDS ( paintitmnm )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 paintitmnm = gfs_header-paintitmnm
                 %control-paintitmnm = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

  METHOD checkvalidation.

    READ ENTITIES OF zi_paintbommstr IN LOCAL MODE
                   ENTITY zi_paintbommstr
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~id
      FROM zi_paintbommstr AS a
      WHERE a~micron = @gfs_header-micron
        AND a~paintitmcd = @gfs_header-paintitmcd
        AND a~id <> @gfs_header-id
      INTO @DATA(lv_comb_1).

    IF lv_comb_1 IS NOT INITIAL.

      APPEND VALUE #( %tky = gfs_header-%tky )
        TO failed-zi_paintbommstr.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'Validate_Head'
        %msg        = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Micron & Paint Item Code already maintained| )
      ) TO reported-zi_paintbommstr.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
