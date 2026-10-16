CLASS lhc_zi_matfld DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_matfld RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_matfld RESULT result.

    METHODS matdet FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_matfld~matdet.

    METHODS checkdet FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_matfld~checkdet.

    METHODS savedata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_matfld~savedata.

    METHODS deleteall FOR MODIFY
      IMPORTING keys FOR ACTION zi_matfld~deleteall RESULT result.

ENDCLASS.

CLASS lhc_zi_matfld IMPLEMENTATION.

*  METHOD get_instance_features.
*
*    READ ENTITIES OF zi_matfld IN LOCAL MODE
*    ENTITY zi_matfld
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_header)
*      FAILED failed.
*
*    LOOP AT lt_header INTO DATA(ls_header).
*
*      " Check if user exists in custom table
*      SELECT SINGLE *
*        FROM zdt_mat_del
*        WHERE cbuserid = @sy-uname
*        INTO @DATA(ls_cbuser).
*
*      " Enable or disable delete
*      APPEND VALUE #(
*        %tky    = ls_header-%tky
*        %delete = COND #(
*                     WHEN ls_cbuser-cbuserid IS INITIAL or ls_cbuser-configdeprecationcode = 'E'
*                     THEN if_abap_behv=>fc-o-disabled
*                     ELSE if_abap_behv=>fc-o-enabled ) )
*        TO result.
*
*    ENDLOOP.
*  ENDMETHOD.


  METHOD get_instance_features.

  READ ENTITIES OF zi_matfld IN LOCAL MODE
    ENTITY zi_matfld
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

  METHOD matdet.
    READ ENTITIES OF zi_matfld IN LOCAL MODE
                 ENTITY zi_matfld
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE productdescription  FROM i_productdescription
    WHERE product = @gfs_header-product AND language = 'E'
    INTO @gfs_header-productdesc.

    MODIFY ENTITIES OF zi_matfld IN LOCAL MODE
             ENTITY zi_matfld
             UPDATE FIELDS ( productdesc )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             productdesc   = gfs_header-productdesc
                         ) ).

  ENDMETHOD.

  METHOD checkdet.
    DATA : lv_msg TYPE char100.
    READ ENTITIES OF zi_matfld IN LOCAL MODE
                   ENTITY zi_matfld
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-product IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_pp_matinffld WHERE product = @gfs_header-product INTO @DATA(ls_mat).
      IF ls_mat IS NOT INITIAL.
        lv_msg = |Product already exist in table|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_matfld.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_matfld.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD savedata.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_matfld IN LOCAL MODE
                    ENTITY zi_matfld
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
    gfs_header-lastchngedt = lv_date.
    gfs_header-lastchnngtm = lv_time.

    MODIFY ENTITIES OF zi_matfld IN LOCAL MODE
             ENTITY zi_matfld
             UPDATE FIELDS ( lastchngedt lastchnngtm )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             lastchngedt   = gfs_header-lastchngedt
                             lastchnngtm   = gfs_header-lastchnngtm
                         ) ).


  ENDMETHOD.

ENDCLASS.
