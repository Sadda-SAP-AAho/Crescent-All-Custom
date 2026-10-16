CLASS lhc_zi_captypmstr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_captypmstr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_captypmstr RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_captypmstr~updateheader.

    METHODS checkcapname FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_captypmstr~checkcapname.



ENDCLASS.

CLASS lhc_zi_captypmstr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_captypmstr IN LOCAL MODE
      ENTITY zi_captypmstr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zcds_typeofmould WHERE type_of_mould = @gfs_header-capcode
      INTO @DATA(loc_final).
    IF sy-subrc = 0.
      gfs_header-capname = loc_final-type_of_mould_name.

    ENDIF.

    MODIFY ENTITIES OF zi_captypmstr IN LOCAL MODE
    ENTITY zi_captypmstr
    UPDATE
    FIELDS ( capname )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 capname = gfs_header-capname
                 %control-capname = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

  METHOD checkcapname.
    READ ENTITIES OF zi_captypmstr IN LOCAL MODE
          ENTITY zi_captypmstr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE capcode FROM zi_captypmstr
    WHERE capcode = @gfs_header-capcode INTO @DATA(ls_capcode).

    IF ls_capcode IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_captypmstr_n WHERE capcode = @gfs_header-capcode
      INTO @DATA(ls_capcode1).

      IF ls_capcode1 IS NOT INITIAL.
        DATA(lv_msg1) = |Code is already used|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_captypmstr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_captypmstr.
      ENDIF.
    ENDIF.


      SELECT SINGLE * FROM zdr_captypmstr_n
      WHERE capname = @gfs_header-capcode
      INTO @DATA(ls_capcomb1).

      IF ls_capcomb1 IS INITIAL.
        DATA(lv_msg2) = |Code and Name are different,Please correct|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_captypmstr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg2 ) )
        TO reported-zi_captypmstr.
      ENDIF.

  ENDMETHOD.

ENDCLASS.
