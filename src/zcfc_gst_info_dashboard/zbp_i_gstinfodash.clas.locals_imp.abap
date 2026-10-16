CLASS lhc_zi_gstinfodash DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gstinfodash RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gstinfodash RESULT result.

    METHODS deleteall FOR MODIFY
      IMPORTING keys FOR ACTION zi_gstinfodash~deleteall RESULT result.

    METHODS savedata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gstinfodash~savedata.

    METHODS checkdet FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gstinfodash~checkdet.

ENDCLASS.

CLASS lhc_zi_gstinfodash IMPLEMENTATION.

  METHOD get_instance_features.

  READ ENTITIES OF zi_gstinfodash IN LOCAL MODE
    ENTITY zi_gstinfodash
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

  LOOP AT lt_header INTO DATA(ls_header).

    APPEND VALUE #(
      %tky = ls_header-%tky

      %delete = COND #(
                   WHEN sy-uname = 'CB9980000010'
                     OR sy-uname = 'CB9980000011'
                     OR sy-uname = 'CB9980000020'
                   THEN if_abap_behv=>fc-o-enabled
                   ELSE if_abap_behv=>fc-o-disabled )
    ) TO result.

  ENDLOOP.

ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD deleteall.

  ENDMETHOD.

  METHOD checkdet.

    DATA : lv_msg TYPE char100.
    READ ENTITIES OF zi_gstinfodash IN LOCAL MODE
                   ENTITY zi_gstinfodash
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-jeno IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_gstinfodash WHERE jeno = @gfs_header-jeno AND fisyear = @gfs_header-fisyear INTO @DATA(ls_jeno).
      IF ls_jeno IS NOT INITIAL.
        lv_msg = |FY and Journal Entry No already exist in Dashboard|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_gstinfodash.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_gstinfodash.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD savedata.

  DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_gstinfodash IN LOCAL MODE
                    ENTITY zi_gstinfodash
                    ALL FIELDS
                    WITH CORRESPONDING #( keys )
                    RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    gfs_header-Lastchngedt = lv_date.
    gfs_header-Lastchnngtm = lv_time.

    MODIFY ENTITIES OF zi_gstinfodash IN LOCAL MODE
             ENTITY zi_gstinfodash
             UPDATE FIELDS ( lastchngedt lastchnngtm )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             lastchngedt   = gfs_header-lastchngedt
                             lastchnngtm   = gfs_header-lastchnngtm
                         ) ).


  ENDMETHOD.

ENDCLASS.
