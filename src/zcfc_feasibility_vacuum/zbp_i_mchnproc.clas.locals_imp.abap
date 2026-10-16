*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_zi_mchnproc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_mchnproc RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_mchnproc RESULT result.

    METHODS checkvalidation FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_mchnproc~checkvalidation.

    METHODS checkcomb FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_mchnproc~checkcomb.

ENDCLASS.

CLASS lhc_zi_mchnproc IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD checkvalidation.

    READ ENTITIES OF zi_mchnproc IN LOCAL MODE
      ENTITY zi_mchnproc
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_1).

    LOOP AT lt_data_1 INTO DATA(ls_data_1).

      IF ls_data_1-rfqdate IS INITIAL OR ls_data_1-matcd IS INITIAL.

        APPEND VALUE #( %tky = ls_data_1-%tky )
         TO failed-zi_mchnproc.

        APPEND VALUE #(
          %tky        = ls_data_1-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Please enter both RFQ Date and Material Code| )
        ) TO reported-zi_mchnproc.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD checkcomb.

    READ ENTITIES OF zi_mchnproc IN LOCAL MODE
             ENTITY zi_mchnproc
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~id
      FROM zi_mchnproc AS a
      WHERE a~rfqdate = @gfs_header-rfqdate
        AND a~matcd   = @gfs_header-matcd
        AND a~id <> @gfs_header-id
      INTO @DATA(lv_comb_2).

    IF lv_comb_2 IS NOT INITIAL.

      APPEND VALUE #( %tky = gfs_header-%tky )
        TO failed-zi_mchnproc.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'Validate_Head'
        %msg        = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Duplicate found for RFQ Date and Material Code.| )
      ) TO reported-zi_mchnproc.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
