CLASS lhc_zi_epcg_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_epcg_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_epcg_hdr RESULT result.

    METHODS determineepcgnumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_epcg_hdr~determineepcgnumber.
    METHODS get_planexpobligation FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_epcg_hdr~get_planexpobligation.
    METHODS check_epcg FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_epcg_hdr~check_epcg.

ENDCLASS.

CLASS lhc_zi_epcg_hdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determineepcgnumber.

    READ ENTITIES OF zi_epcg_hdr IN LOCAL MODE
       ENTITY zi_epcg_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED DATA(header_failed).

    " ---------------------------------------------------------------------
    " == EPCG number creation on create action
    " ---------------------------------------------------------------------
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-ecomno IS INITIAL.
      TRY.

          CALL METHOD cl_numberrange_runtime=>number_get
            EXPORTING
              nr_range_nr = '01'
              object      = 'ZEX_EPCG'
            IMPORTING
              number      = DATA(lv_number)
              returncode  = DATA(lv_rcode).

          SHIFT lv_number LEFT DELETING LEADING '0'.

*          DATA(lo_get_number) = cl_numberrange_buffer=>get_instance( ).
*          lo_get_number->if_numberrange_buffer~number_get_parallel(
*                                         EXPORTING
*                                           iv_object    = 'ZEX_EPCG'
*                                           iv_interval  = '01'
***                                       iv_subobject = lv_subobject
***                                       iv_toyear    = lv_year
*                                         IMPORTING
*                                            ev_number    = DATA(lv_number) ).
        CATCH cx_number_ranges INTO DATA(lr_error).
      ENDTRY .

      IF lv_number IS INITIAL.
        EXIT.
*        MESSAGE 'No document found' TYPE 'E'.
      ENDIF.

      gfs_header-ecomno = |{ lv_number ALPHA = IN }|.

      DATA(gfs_header1) = VALUE #( header[ 1 ]  OPTIONAL ).

      IF gfs_header-ecomno IS NOT INITIAL AND gfs_header-dutysaveval IS NOT INITIAL.

        gfs_header-plannedexpobg = gfs_header-dutysaveval * 6 .
      ENDIF.

      MODIFY ENTITIES OF zi_epcg_hdr IN LOCAL MODE
             ENTITY zi_epcg_hdr
             UPDATE
             FIELDS (  ecomno plannedexpobg )
             WITH VALUE #( ( %tky          = gfs_header-%tky

                             ecomno        = gfs_header-ecomno
                             plannedexpobg = gfs_header-plannedexpobg
                             ) ).
    ENDIF.


  ENDMETHOD.

  METHOD get_planexpobligation.

    READ ENTITIES OF zi_epcg_hdr IN LOCAL MODE
       ENTITY zi_epcg_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).

    " ---------------------------------------------------------------------
    " == Export Obligation
    " ---------------------------------------------------------------------
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

***    IF gfs_header-ecomno IS NOT INITIAL AND gfs_header-dutysaveval IS NOT INITIAL.
    IF gfs_header-dutysaveval IS NOT INITIAL.

      gfs_header-plannedexpobg = gfs_header-dutysaveval * 6 .

      MODIFY ENTITIES OF zi_epcg_hdr IN LOCAL MODE
           ENTITY zi_epcg_hdr
           UPDATE
           FIELDS ( plannedexpobg )
           WITH VALUE #( (
                           %tky           = gfs_header-%tky
                           plannedexpobg  = gfs_header-plannedexpobg
                        ) ).
    ENDIF.

  ENDMETHOD.

  METHOD check_epcg.

    READ ENTITIES OF zi_epcg_hdr IN LOCAL MODE
       ENTITY zi_epcg_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE licno FROM zdt_epcg_hdr
    WHERE licno = @gfs_header-licno INTO @DATA(ls_licno).
    IF ls_licno IS NOT INITIAL.
      DATA(lv_msg1) = |EPCG Licence No Already Exist|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_epcg_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_epcg_hdr.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_epcg_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_epcg_itm RESULT result.

    METHODS item_detail FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_epcg_itm~item_detail.
    METHODS dutysave FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_epcg_itm~dutysave.

ENDCLASS.

CLASS lhc_zi_epcg_itm IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_epcg_hdr IN LOCAL MODE
             ENTITY zi_epcg_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header)
             FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    IF gfs_header-ecomno IS INITIAL.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD item_detail.

  ENDMETHOD.

  METHOD dutysave.

    READ ENTITIES OF zi_epcg_hdr IN LOCAL MODE
             ENTITY zi_epcg_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header)
             FAILED FINAL(header_failed).

    DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ) .

    READ ENTITIES OF zi_epcg_hdr IN LOCAL MODE
         ENTITY zi_epcg_itm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         FAILED FINAL(lt_item_failed).

* //== Update Line item Field ==//
    LOOP AT lt_item INTO DATA(ls_item).

      "//== Get HSN Description ==//
      IF ls_item-hsn IS NOT INITIAL.
        SELECT SINGLE consumptiontaxctrlcodetext1
               FROM zc_hsn_code
               WHERE consumptiontaxctrlcode = @ls_item-hsn INTO @DATA(lv_hsntext) .
        IF sy-subrc EQ 0.
          ls_item-matdesc = lv_hsntext.
        ENDIF.
      ENDIF.

      ls_item-cifvalfc  = ls_item-grosspricefc.
      ls_item-cifvalinr = ls_item-grosspricefc * ls_item-excrateinr.

      IF ls_item-waersfr <> 'INR'.
        DATA(lv_frcharge) = ls_item-freightcharge * ls_item-excrateinr.
      ELSE.
        lv_frcharge = ls_item-freightcharge.
      ENDIF.
      IF ls_item-waersinc <> 'INR'.
        DATA(lv_inccharge) = ls_item-inschange * ls_item-excrateinr.
      ELSE.
        lv_inccharge = ls_item-inschange.
      ENDIF.

      ls_item-accessval = ls_item-cifvalinr + lv_frcharge + lv_inccharge.

      IF ls_item-dutysavper IS NOT INITIAL AND ls_item-swcessperc IS NOT INITIAL AND ls_item-igstperc IS NOT INITIAL AND
         ls_item-accessval IS NOT INITIAL.

        DATA(lv_dutysave) = ( ls_item-accessval * ls_item-dutysavper ) / 100.
        DATA(lv_swcess)   = ( lv_dutysave * ls_item-swcessperc ) / 100.
        DATA(lv_igst)     = ( ( ls_item-accessval + lv_dutysave + lv_swcess ) * ls_item-igstperc ) / 100.

        ls_item-dutysavevalinr = lv_dutysave + lv_swcess + lv_igst .
        ls_item-dutysavevalfc  = ls_item-dutysavevalinr / ls_item-excrateinr .
      ENDIF.

      MODIFY ENTITIES OF zi_epcg_hdr IN LOCAL MODE
              ENTITY zi_epcg_itm
              UPDATE
              FIELDS ( matdesc cifvalfc cifvalinr accessval dutysavevalinr dutysavevalfc ) "
              WITH VALUE #( id = ls_item-id
                            ( %tky  = ls_item-%tky

                              matdesc        = ls_item-matdesc
                              cifvalfc       = ls_item-cifvalfc
                              cifvalinr      = ls_item-cifvalinr
                              accessval      = ls_item-accessval
                              dutysavevalinr = ls_item-dutysavevalinr
                              dutysavevalfc  = ls_item-dutysavevalfc
                              ) ).

    ENDLOOP.

*--//== Update Header Data ==//
    READ ENTITIES OF zi_epcg_hdr IN LOCAL MODE
         ENTITY zi_epcg_itm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item2)
         FAILED FINAL(lt_item_failed2).

    SELECT * FROM zdr_epcg_item WHERE id = @ls_header-id INTO TABLE @DATA(lt_item1).
    LOOP AT lt_item1 ASSIGNING FIELD-SYMBOL(<fs_item1>).
      CLEAR ls_item.
      ls_item = VALUE #( lt_item2[ id = <fs_item1>-id itemno = <fs_item1>-itemno ] OPTIONAL ) .
      IF ls_item IS NOT INITIAL .
        MOVE-CORRESPONDING ls_item TO <fs_item1>.
      ENDIF.
    ENDLOOP.

    DATA(lv_totalcifvalue) = REDUCE dmbtr( INIT lv_cif TYPE dmbtr FOR ls_cif
                                            IN lt_item1  NEXT lv_cif = lv_cif + ls_cif-accessval ).
    DATA(lv_totaldutysave) = REDUCE dmbtr( INIT lv_cif TYPE dmbtr FOR ls_cif
                                            IN lt_item1  NEXT lv_cif = lv_cif + ls_cif-dutysavevalinr ).
    ls_header-totalcifvalue = lv_totalcifvalue.
    ls_header-totaldutysave = lv_totaldutysave.

    MODIFY ENTITIES OF zi_epcg_hdr IN LOCAL MODE
                 ENTITY zi_epcg_hdr
                 UPDATE
                 FIELDS ( totalcifvalue totaldutysave )
                 WITH VALUE #( id = ls_header-id
                               ( %tky  = ls_header-%tky

                                 totalcifvalue = ls_header-totalcifvalue
                                 totaldutysave = ls_header-totaldutysave
                                 ) ).

  ENDMETHOD.

ENDCLASS.
