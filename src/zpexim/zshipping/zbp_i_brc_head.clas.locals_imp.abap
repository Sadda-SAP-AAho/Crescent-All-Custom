CLASS lhc_zi_brc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_brc_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_brc_head RESULT result.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_brc_head~upd RESULT result.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION zi_brc_head~uploadexceldata RESULT result.

    METHODS valid FOR MODIFY
      IMPORTING keys FOR ACTION zi_brc_head~valid RESULT result.

    METHODS fields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_brc_head~fields.

    METHODS change_status FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_brc_head~change_status.

    METHODS validate_fields FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_brc_head~validate_fields.

ENDCLASS.

CLASS lhc_zi_brc_head IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_brc_head IN LOCAL MODE
             ENTITY zi_brc_head
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(lt_header)
             FAILED failed.

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*    SELECT SINGLE *
*        FROM zmm_matinfo_file
*        WHERE id = @ls_header-id
*        INTO @DATA(ls_zpp_serial_table).

    READ ENTITY zi_brc_head
           BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(item).

    READ TABLE item INTO DATA(ls_item) WITH KEY status = '2'.

    result = VALUE #( ( %tky              = ls_header-%tky

                        %update           = COND #( WHEN ls_header-internalno IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only )

                        %action-edit      = COND #( WHEN ls_header-internalno IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-o-disabled )


                        %delete           = COND #( WHEN ls_header-post = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only )

                        %action-upd       = COND #( WHEN ls_header-post = 'X' OR ls_header-internalno IS INITIAL OR
                                                         ls_header-status = '1' OR ( ls_item IS INITIAL AND ls_header-status = '2' )
                                                    THEN if_abap_behv=>fc-f-read_only )

                        %action-valid     = COND #( WHEN ls_header-post = 'X' OR ls_header-internalno IS INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only )

                        %assoc-_item      = if_abap_behv=>fc-f-read_only

*                        %field-attachment = COND #( WHEN ls_header-status <> ' '
*                                                    THEN if_abap_behv=>fc-f-read_only )
*
*                        %field-comments   = COND #( WHEN ls_header-status <> ' '
*                                                    THEN if_abap_behv=>fc-f-read_only )

                                                     ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD upd.
    READ ENTITIES OF zi_brc_head IN LOCAL MODE
                  ENTITY zi_brc_head
                  ALL FIELDS
                  WITH CORRESPONDING #( keys )
                  RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    MODIFY ENTITIES OF zi_brc_head IN LOCAL MODE
                ENTITY zi_brc_head
                UPDATE FIELDS ( post status )
                WITH VALUE #( FOR key IN keys
                            (  %tky = gfs_header-%tky
                               post   = 'X'
                               status = '3' ) ).


    READ ENTITIES OF zi_brc_head IN LOCAL MODE
           ENTITY zi_brc_head
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
  ENDMETHOD.

  METHOD uploadexceldata.
    TYPES: BEGIN OF ty_excel,
             shippingbill TYPE string,
             brcno        TYPE string,
             brcdate      TYPE string,
             brcvalue     TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_brc_head IN LOCAL MODE
         ENTITY zi_brc_head
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(lt_head).
    IF ( lt_head[ 1 ]-attachment IS NOT INITIAL ).
      FINAL(lv_attachment) = lt_head[ 1 ]-attachment.

      FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
      FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

      FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

      FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
        )->row_stream(
        )->operation->write_to( REF #( lt_excel ) ).

      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
                 )->if_xco_xlsx_ra_operation~execute( ).
    ENDIF.
  ENDMETHOD.

  METHOD fields.
    MODIFY ENTITIES OF zi_brc_head IN LOCAL MODE
             ENTITY zi_brc_head
             UPDATE FROM VALUE #( FOR key IN keys
                                  ( status          = '0'
                                    %control-status = if_abap_behv=>mk-on ) ).

    IF keys[ 1 ]-%is_draft = '01'.
      MODIFY ENTITIES OF zi_brc_head IN LOCAL MODE
             ENTITY zi_brc_head
             EXECUTE uploadexceldata
             FROM CORRESPONDING #( keys ).
    ENDIF.
  ENDMETHOD.

  METHOD change_status.
    TYPES: BEGIN OF ty_excel,
             shippingbill TYPE string,
             brcno        TYPE string,
             brcdate      TYPE string,
             brcvalue     TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    DATA : lv_cdate TYPE sydate.

    READ ENTITIES OF zi_brc_head IN LOCAL MODE
         ENTITY zi_brc_head
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(lt_head).
    IF ( lt_head[ 1 ]-attachment IS NOT INITIAL ).
      FINAL(lv_attachment) = lt_head[ 1 ]-attachment.

      FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
      FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

      FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

      FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
        )->row_stream(
        )->operation->write_to( REF #( lt_excel ) ).

      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
                 )->if_xco_xlsx_ra_operation~execute( ).

      DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).

      DELETE lt_excel INDEX 1.
      LOOP AT lt_excel INTO FINAL(ls_excel) WHERE shippingbill IS NOT INITIAL.

        TRY.
            CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                    INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
          CATCH cx_abap_context_info_error.
        ENDTRY.


        MODIFY ENTITIES OF zi_brc_head IN LOCAL MODE
               ENTITY zi_brc_head
               CREATE BY \_item
               FROM VALUE #( ( id      = ls_head-id
                               %target = VALUE #( ( %cid                     = ls_excel-shippingbill
                                                    shippingbill             = ls_excel-shippingbill
                                                    brcdate                  = ls_excel-brcdate
                                                    brcno                    = ls_excel-brcno
                                                    brcvalue                 = ls_excel-brcvalue
                                                    status                   = '1'
                                                    %control-shippingbill     = if_abap_behv=>mk-on
                                                    %control-brcdate          = if_abap_behv=>mk-on
                                                    %control-brcno            = if_abap_behv=>mk-on
                                                    %control-brcvalue         = if_abap_behv=>mk-on
                                                    %control-status           = if_abap_behv=>mk-on ) ) ) )
               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(ls_mapped)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(ls_failed)
               " TODO: variable is assigned but never used (ABAP cleaner)
               REPORTED FINAL(ls_reported).

        CLEAR : lv_cdate.
        IF ls_head-status = '' OR ls_head-status = '0'.

          ls_head-status = '1'.

          GET TIME STAMP FIELD DATA(lv_utctimestamp).
          CONVERT TIME STAMP lv_utctimestamp  TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
          ls_head-internalno = lv_date+0(4) && |-| &&
                               lv_date+4(2) && |/| &&
                               lv_time+0(2) && |:| &&
                               lv_time+2(2) && |:| &&
                               lv_time+4(2) && |/| &&
                               sy-uname.

          MODIFY ENTITIES OF zi_brc_head IN LOCAL MODE
                 ENTITY zi_brc_head
                 UPDATE FIELDS ( status internalno )
                 WITH VALUE #( FOR key IN keys
                               (  %tky = key-%tky
                                  status = ls_head-status
                                  internalno = ls_head-internalno
                               ) )
                 FAILED FINAL(ls_failed_1)
                 REPORTED FINAL(ls_reported_1).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD valid.
    DATA : lv_msg TYPE char100.

    READ ENTITIES OF zi_brc_head IN LOCAL MODE
               ENTITY zi_brc_head
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_brc_head
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).

    SELECT SINGLE * FROM zdr_matinfo_file WHERE id = @gfs_header-id INTO @DATA(ls_check).
    IF ls_check IS NOT INITIAL.
      lv_msg = |Please save the data and then click on Validate button|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_brc_head.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_brc_head.
    ELSE.
      LOOP AT item INTO DATA(ls_item).
        SELECT SINGLE * FROM zr_shippingbilltp WHERE shippingbill = @ls_item-shippingbill
          INTO @DATA(lv_ship).
        IF lv_ship IS INITIAL.
          ls_item-status = '3'.
          ls_item-message = 'Shipping Bill not found'.
        ELSE.
          ls_item-status = '2'.
          ls_item-message = 'Validation Successful'.
        ENDIF.

        MODIFY ENTITIES OF zi_brc_head IN LOCAL MODE
               ENTITY zi_brc
               UPDATE FIELDS ( status message )
               WITH VALUE #( FOR key IN keys
                           (  %tky = ls_item-%tky
                              status = ls_item-status
                              message = ls_item-message ) ).



        CLEAR : lv_ship , ls_item.
      ENDLOOP.

      MODIFY ENTITIES OF zi_brc_head IN LOCAL MODE
              ENTITY zi_brc_head
              UPDATE FIELDS ( status )
              WITH VALUE #( FOR key IN keys
                          (  %tky = gfs_header-%tky
                             status = '2' ) ).
    ENDIF.

    READ ENTITIES OF zi_brc_head IN LOCAL MODE
           ENTITY zi_brc_head
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
  ENDMETHOD.

  METHOD validate_fields.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_brc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_brc RESULT result.

ENDCLASS.

CLASS lhc_zi_brc IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_brc_head DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_brc_head IMPLEMENTATION.


  METHOD save_modified.

    IF update-zi_brc_head  IS NOT INITIAL.
      DATA(lt_head) = update-zi_brc_head .
      IF lt_head[ 1 ]-status = '3'.

        READ TABLE lt_head INTO DATA(ls_head) INDEX 1.

        SELECT * FROM zdt_brc
        WHERE id = @ls_head-id
        INTO TABLE @DATA(lt_upd).

        DATA : lv_p    TYPE p,
               lv_id   TYPE zex_shipbill_hdr-internal_shipbill,
               ls_item TYPE zex_shipbill_hdr,
               lt_item TYPE STANDARD TABLE OF zex_shipbill_hdr.

        DATA lv_date TYPE datn.
        DATA lv_time TYPE timn.

        LOOP AT lt_upd INTO DATA(ls_upd) WHERE status = '2'.
          lv_p += 1.

          SELECT SINGLE * FROM zex_shipbill_hdr
          WHERE shipping_bill = @ls_upd-shippingbill
          INTO @DATA(ls_shipping_bill).

          ls_shipping_bill-brcno = ls_upd-brcno.
          ls_shipping_bill-brcdate = ls_upd-brcdate.
          ls_shipping_bill-brcvalue = ls_upd-brcvalue.

          MOVE-CORRESPONDING ls_shipping_bill TO ls_item.

          APPEND ls_item TO lt_item.
          CLEAR : lv_id, ls_item, lv_date, lv_time, ls_shipping_bill.
        ENDLOOP.

        IF lt_item[] IS NOT INITIAL.
          MODIFY zex_shipbill_hdr FROM TABLE @lt_item.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
