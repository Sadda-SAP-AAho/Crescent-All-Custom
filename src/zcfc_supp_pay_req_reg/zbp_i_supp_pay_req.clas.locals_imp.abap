CLASS lhc_zi_supp_pay_req DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_supp_pay_req RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_supp_pay_req RESULT result.

    METHODS getvendorname FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_supp_pay_req~getvendorname.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_supp_pay_req~determinedocnum.

    METHODS setcreatedby FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_supp_pay_req~setcreatedby.

ENDCLASS.

CLASS lhc_zi_supp_pay_req IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getvendorname.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_supp_pay_req IN LOCAL MODE
     ENTITY zi_supp_pay_req
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    IF gfs_header-docnum IS INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-fisyear = lv_date+2(2) && lv_date+2(2).
      gfs_header-fisyear = gfs_header-fisyear + 1.

      MODIFY ENTITIES OF zi_supp_pay_req IN LOCAL MODE
       ENTITY zi_supp_pay_req
       UPDATE
       FIELDS ( fisyear )
       WITH VALUE #( FOR key IN keys
                    ( %tky = gfs_header-%tky
                    fisyear = gfs_header-fisyear
                    %control-fisyear = if_abap_behv=>mk-on
                    ) ).

      SELECT SINGLE * FROM zi_vendor_f4 WHERE vendorcode = @gfs_header-vendorcode
      INTO @DATA(loc_final).
      IF sy-subrc = 0.
        gfs_header-vendorname = loc_final-vendorname.

      ENDIF.

      MODIFY ENTITIES OF zi_supp_pay_req IN LOCAL MODE
      ENTITY zi_supp_pay_req
      UPDATE
      FIELDS ( vendorname )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_header-%tky
                   vendorname = gfs_header-vendorname
                   %control-vendorname = if_abap_behv=>mk-on
                   ) ).


    ENDIF.

  ENDMETHOD.

  METHOD determinedocnum.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_supp_pay_req IN LOCAL MODE
           ENTITY zi_supp_pay_req
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-docnum IS INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-createdby = sy-uname.
      gfs_header-creon = lv_date.

      SELECT MAX( keyid ) AS keyid FROM zdt_supp_pay_req WHERE fisyear = @gfs_header-fisyear
      INTO @DATA(lv_keyid).

      lv_keyid = lv_keyid + 1.
      gfs_header-keyid = lv_keyid.
      gfs_header-docnum = gfs_header-fisyear && lv_keyid.



      MODIFY ENTITIES OF zi_supp_pay_req IN LOCAL MODE
       ENTITY zi_supp_pay_req
       UPDATE
       FIELDS ( docnum keyid createdby creon createdbyname )
       WITH VALUE #( FOR key IN keys
                    ( %tky = gfs_header-%tky
                    docnum = gfs_header-docnum
                    keyid = gfs_header-keyid
                    createdby = gfs_header-createdby
                    creon = gfs_header-creon
                    createdbyname = gfs_header-createdbyname
                    %control-docnum = if_abap_behv=>mk-on
                    ) ).

    ENDIF.


  ENDMETHOD.

  METHOD setcreatedby.

    DATA lv_name TYPE string.

    LOOP AT keys INTO DATA(ls_key).

      READ ENTITIES OF zi_supp_pay_req IN LOCAL MODE
        ENTITY zi_supp_pay_req
        ALL FIELDS
        WITH VALUE #( ( %tky = ls_key-%tky ) )
        RESULT DATA(header).

      DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).

      IF ls_header-createdby IS NOT INITIAL.

        TRY.
            lv_name = cl_abap_context_info=>get_user_description( ).
          CATCH cx_abap_context_info_error.
            lv_name = ''.
        ENDTRY.

        MODIFY ENTITIES OF zi_supp_pay_req IN LOCAL MODE
          ENTITY zi_supp_pay_req
          UPDATE
          FIELDS ( createdby createdbyname )
          WITH VALUE #(
            (
              %tky          = ls_key-%tky
              createdby     = sy-uname
              createdbyname = lv_name
            )
          ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
