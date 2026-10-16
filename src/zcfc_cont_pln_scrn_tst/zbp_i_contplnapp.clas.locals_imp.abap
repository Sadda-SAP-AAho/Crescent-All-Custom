CLASS lhc_zi_contplnapp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_contplnapp RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_contplnapp RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_contplnapp~updateheader.

    METHODS checkvalidation FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_contplnapp~checkvalidation.


ENDCLASS.


CLASS lhc_zi_contplnapp IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_contplnapp IN LOCAL MODE
    ENTITY zi_contplnapp
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).


    SELECT SINGLE * FROM zcds_plant_f4_test WHERE loctncd = @gfs_header-plantcode
    INTO @DATA(loc_final1).
    IF sy-subrc = 0.
      gfs_header-plantname = loc_final1-loctnnam.

    ENDIF.

    SELECT SINGLE * FROM zcds_final_dest_f4 WHERE value_low = @gfs_header-fdcode
    INTO @DATA(loc_final2).
    IF sy-subrc = 0.
      gfs_header-fdname = loc_final2-text.

    ENDIF.

    MODIFY ENTITIES OF zi_contplnapp IN LOCAL MODE
    ENTITY zi_contplnapp
    UPDATE
    FIELDS ( plantname fdname )
    WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 plantname = gfs_header-plantname
                 fdname = gfs_header-fdname
                 %control-plantname = if_abap_behv=>mk-on
                 %control-fdname = if_abap_behv=>mk-on
                 ) ).

  ENDMETHOD.

  METHOD checkvalidation.

    READ ENTITIES OF zi_contplnapp IN LOCAL MODE
             ENTITY zi_contplnapp
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    SELECT SINGLE concat( concat( a~plantcode , a~fdcode ), a~vsslnmvyg )
    FROM zi_contplnapp AS a
    WHERE a~plantcode = @gfs_header-plantcode
    AND a~fdcode = @gfs_header-fdcode
    AND a~vsslnmvyg = @gfs_header-vsslnmvyg
    AND ( ( @gfs_header-prtentfrmdt BETWEEN a~prtentfrmdt AND a~prtenttodt )
    OR ( @gfs_header-prtenttodt BETWEEN a~prtentfrmdt AND a~prtenttodt )
    OR ( @gfs_header-prtentfrmdt LE a~prtentfrmdt AND @gfs_header-prtenttodt GE a~prtenttodt ) )
    INTO @DATA(ls_comb).

    IF ls_comb IS NOT INITIAL.

      DATA(lv_msg) = |Duplicate Data exists in this Date Range|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_contplnapp.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_contplnapp.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
