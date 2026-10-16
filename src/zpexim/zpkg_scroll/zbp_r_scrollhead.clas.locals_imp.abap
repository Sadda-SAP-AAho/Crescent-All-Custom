CLASS lhc_zr_scrollhead DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS post FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~post.

    METHODS status FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~status.

    METHODS check FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~check.

    METHODS shippingbill FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~shippingbill.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION head~uploadexceldata RESULT result.

    METHODS fields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~fields.
    METHODS uploadfile FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~uploadfile.
    METHODS upload_filedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~upload_filedata.

ENDCLASS.


CLASS lhc_zr_scrollhead IMPLEMENTATION.
  METHOD get_instance_features.

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    FINAL(ls_header_t) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zr_scrollhead
      WHERE id = @ls_header_t-id
      INTO @FINAL(ls_fdhead).

    result = VALUE #( FOR ls_header IN lt_header
                      ( %tky         = ls_header-%tky

                        %update           = COND #( WHEN ( ls_fdhead-post IS INITIAL AND
                                                           ls_header-post IS INITIAL )
                                               THEN if_abap_behv=>fc-o-enabled
                                               ELSE if_abap_behv=>fc-o-disabled )
                        %action-edit      = COND #( WHEN ( ls_fdhead-post IS INITIAL AND
                                                           ls_header-post IS INITIAL )
                                               THEN if_abap_behv=>fc-o-enabled
                                               ELSE if_abap_behv=>fc-o-disabled )

                        %delete           = COND #( WHEN ( ls_fdhead-post IS INITIAL AND
                                                           ls_header-post IS INITIAL )
                                               THEN if_abap_behv=>fc-o-enabled
                                               ELSE if_abap_behv=>fc-o-disabled )

                        %assoc-_item      =  if_abap_behv=>fc-o-disabled

                                                ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD post.

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header-post IS NOT INITIAL.
      RETURN.
    ENDIF.

    ls_header-statuscode = '2'.
    ls_header-statusdesc = 'Scroll Released'.
    MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
           ENTITY head
           UPDATE
           FIELDS ( statuscode statusdesc )
           WITH VALUE #( ( %tky       = ls_header-%tky

                           statuscode = ls_header-statuscode
                           statusdesc = ls_header-statusdesc

                           %control-statusdesc = if_abap_behv=>mk-on
                           %control-statuscode = if_abap_behv=>mk-on
                           ) ).
  ENDMETHOD.

  METHOD status.

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    DATA(ls_header_t) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    IF ls_header_t IS NOT INITIAL.
      SELECT SINGLE * FROM zr_scrollhead
        WHERE id = @ls_header_t-id
          " TODO: variable is assigned but never used (ABAP cleaner)
        INTO @FINAL(ls_fdhead).
      IF sy-subrc <> 0 AND ls_header_t-statuscode IS INITIAL.
        ls_header_t-statuscode = '1'.
        ls_header_t-statusdesc = 'Created'.

        MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
               ENTITY head
               UPDATE
               FIELDS ( statuscode statusdesc )
               WITH VALUE #( ( %tky       = ls_header_t-%tky
                               statuscode = ls_header_t-statuscode
                               statusdesc = ls_header_t-statusdesc ) ).
      ENDIF.
    ENDIF.

    CLEAR ls_header_t.
  ENDMETHOD.

  METHOD check.
    DATA: lv_msg TYPE string .
    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zr_scrollhead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM zr_scrollhead
      WHERE scrollno = @ls_header-scrollno AND id <> @ls_header-id
    " TODO: variable is assigned but never used (ABAP cleaner)
      INTO @FINAL(ls_head).
    IF sy-subrc = 0.
      APPEND VALUE #( %tky              = ls_header-%tky
                      %state_area       = 'Validate_Head'
                      %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = 'Duplicate Scroll Number' )
                      %element-scrollno = if_abap_behv=>mk-on )
             TO reported-head.

      APPEND VALUE #( %tky = ls_header-%tky )
             TO failed-head.
    ENDIF.

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).

      "--- Shipping Bill Post Check---
      SELECT SINGLE * FROM zex_shipbill_hdr
                     WHERE shipping_bill =  @<lfs_item>-shipping_bill
                     INTO @DATA(ls_shippbill).
      IF sy-subrc EQ 0 .
        IF ls_header-scrolltype = '1' AND ls_shippbill-tpost IS INITIAL.

          lv_msg = 'RoDTEP of SB-' && <lfs_item>-shipping_bill && ' Not Posted'.
          APPEND VALUE #( %tky            = ls_header-%tky
                        %state_area       = 'Validate_Head'
                        %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     =  lv_msg )
                        %element-shippingbill = if_abap_behv=>mk-on )
               TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.

        ELSEIF ls_header-scrolltype = '2' AND ls_shippbill-tpostdbk IS INITIAL.
          lv_msg = 'DBK of SB-' && <lfs_item>-shipping_bill && ' Not Posted'.
          APPEND VALUE #( %tky            = ls_header-%tky
                        %state_area       = 'Validate_Head'
                        %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     =  lv_msg )
                        %element-shippingbill = if_abap_behv=>mk-on )
               TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.

        ENDIF.
      ENDIF.


      SELECT SINGLE b~* FROM zdt_scroll_item AS a
                       INNER JOIN zdt_scroll_head AS b ON a~id = b~id
                      WHERE a~shipping_bill =  @<lfs_item>-shipping_bill AND
                            a~id            <> @ls_header-id AND
                            b~scrolltype    = @ls_header-scrolltype
                      INTO @DATA(ls_shipbill).

      IF sy-subrc EQ 0 .
        lv_msg = 'SB- ' && <lfs_item>-shipping_bill && ' Already inScroll-' && ls_shipbill-scrollno .
        APPEND VALUE #( %tky            = ls_header-%tky
                      %state_area       = 'Validate_Head'
                      %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     =  lv_msg )
                      %element-scrollno = if_abap_behv=>mk-on )
             TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.
      ENDIF.

      SELECT SINGLE * FROM zdt_scroll_head
                      WHERE id         = @ls_header-id AND
                            scrolltype = @ls_header-scrolltype
                     INTO @DATA(ls_scroll).

      IF sy-subrc EQ 0 AND ls_header-post IS NOT INITIAL.
        IF <lfs_item>-appliedamount IS INITIAL.
          lv_msg = 'Provide Applied Amount for SB- ' && <lfs_item>-shipping_bill .
          APPEND VALUE #( %tky              = ls_header-%tky
                          %state_area       = 'Validate_Head'
                          %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                     text     =  lv_msg )
                          %element-scrollno = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.
        ENDIF.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD shippingbill.
    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM zex_shipbill_hdr
      WHERE shipping_bill = @ls_header-shippingbill
      INTO TABLE @DATA(lt_shippingbill).
    IF sy-subrc = 0.
      SORT lt_shippingbill BY shipping_bill.

      SELECT * FROM zex_shipbill_hdr
        FOR ALL ENTRIES IN @lt_shippingbill
        WHERE internal_shipbill = @lt_shippingbill-internal_shipbill
        INTO TABLE @DATA(lt_shippingbillitem).
      IF sy-subrc = 0.
        SORT lt_shippingbillitem BY internal_shipbill.
      ENDIF.
    ENDIF.

    LOOP AT lt_shippingbillitem ASSIGNING FIELD-SYMBOL(<lfs_shippingbillitem>).
      FINAL(ls_shippingbill) = VALUE #( lt_shippingbill[ internal_shipbill = <lfs_shippingbillitem>-internal_shipbill ] OPTIONAL ).
      TRY.
          FINAL(lv_id) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

      MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
             ENTITY head
             CREATE BY \_item
             FROM VALUE #(
                 ( id      = ls_header-id
                   %target = VALUE #(
                       ( %cid                        = lv_id
                         item                        = lv_id
                         scrollno                    = ls_header-scrollno
                         shipping_bill               = ls_shippingbill-shipping_bill
                         shipping_bill_date          = ls_shippingbill-shipping_bill_date
                         port_code                   = ls_shippingbill-port_code
                         port_codename               = ls_shippingbill-port_codename
                         currency                    = 'INR'
                         fob_lc_v                    = <lfs_shippingbillitem>-fob_lc_v
                         rodtep_dd_v                 = COND #( WHEN ls_header-scrolltype = '1'
                                                               THEN <lfs_shippingbillitem>-total_rodtep_v
                                                               ELSE <lfs_shippingbillitem>-total_duty_drawback_v )

                         %control-scrollno           = if_abap_behv=>mk-on
                         %control-shipping_bill      = if_abap_behv=>mk-on
                         %control-shipping_bill_date = if_abap_behv=>mk-on
                         %control-port_code          = if_abap_behv=>mk-on
                         %control-port_codename      = if_abap_behv=>mk-on
                         %control-currency           = if_abap_behv=>mk-on
                         %control-fob_lc_v           = if_abap_behv=>mk-on
                         %control-rodtep_dd_v        = if_abap_behv=>mk-on ) ) ) )
             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(ls_mapped)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(ls_failed)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED FINAL(ls_reported).
    ENDLOOP.
  ENDMETHOD.

  METHOD uploadexceldata.

***    TYPES: BEGIN OF ty_excel,
***             supp     TYPE string,
***             suppname TYPE string,
***             bankname TYPE string,
***             bankacc  TYPE string,
***             bankcou  TYPE string,
***             bankkey  TYPE string,
***           END OF ty_excel,
***           tt_excel TYPE STANDARD TABLE OF ty_excel.
***
***    DATA lt_excel TYPE tt_excel.
***
***    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
***         ENTITY zr_scrollhead
***         ALL FIELDS WITH
***         CORRESPONDING #( keys )
***         RESULT FINAL(lt_head).
***
***    FINAL(lv_attachment) = lt_head[ 1 ]-attachment.
***    IF lv_attachment IS NOT INITIAL.
***      FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
***      FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).
***
***      FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).
***
***      FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
***        )->row_stream(
***        )->operation->write_to( REF #( lt_excel ) ).
***
***      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
***                 )->if_xco_xlsx_ra_operation~execute( ).
***    ENDIF.
  ENDMETHOD.

  METHOD fields.
*    MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
*               ENTITY zr_scrollhead
*               UPDATE FROM VALUE #( FOR key IN keys
*                                    ( " status          = '0'
*                                      "%control-status = if_abap_behv=>mk-on
*                                      ) ).

*    IF keys[ 1 ]-%is_draft = '01'.
*      MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
*             ENTITY zr_scrollhead
*             EXECUTE uploadexceldata
*             FROM CORRESPONDING #( keys ).
*    ENDIF.
  ENDMETHOD.

  METHOD uploadfile.

    TYPES: BEGIN OF ty_excel,
             shipno TYPE char20,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA: lt_excel TYPE tt_excel,
          lv_msg   TYPE string,
          lv_data  TYPE char30.
*----------------------------------------------------------*

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zr_scrollhead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL OR ls_header-attachment IS INITIAL.
      RETURN.
    ENDIF.

*// Excel Upload File

    FINAL(lv_attachment) = ls_header-attachment.
    IF lv_attachment IS NOT INITIAL.
      FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
      FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

      FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

      FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
        )->row_stream(
        )->operation->write_to( REF #( lt_excel ) ).

      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
                 )->if_xco_xlsx_ra_operation~execute( ).
    ENDIF.

    DELETE lt_excel INDEX 1.
    IF lt_excel[] IS INITIAL .
      RETURN.
    ENDIF.

    SELECT a~* FROM zex_shipbill_hdr AS a
             INNER JOIN @lt_excel AS b ON a~shipping_bill = b~shipno
          INTO TABLE @DATA(lt_shippingbill).
    IF sy-subrc = 0.
      SORT lt_shippingbill BY shipping_bill.

      SELECT * FROM zex_shipbill_hdr
        FOR ALL ENTRIES IN @lt_shippingbill
        WHERE internal_shipbill = @lt_shippingbill-internal_shipbill
        INTO TABLE @DATA(lt_shippingbillitem).
      IF sy-subrc = 0.
        SORT lt_shippingbillitem BY internal_shipbill.
      ENDIF.
    ENDIF.

    LOOP AT lt_shippingbillitem ASSIGNING FIELD-SYMBOL(<lfs_shippingbillitem>).
      FINAL(ls_shippingbill) = VALUE #( lt_shippingbill[ internal_shipbill = <lfs_shippingbillitem>-internal_shipbill ] OPTIONAL ).
      TRY.
          FINAL(lv_id) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

      MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
             ENTITY head
             CREATE BY \_item
             FROM VALUE #(
                 ( id      = ls_header-id
                   %target = VALUE #(
                       ( %cid                        = lv_id
                         item                        = lv_id
                         scrollno                    = ls_header-scrollno
                         shipping_bill               = ls_shippingbill-shipping_bill
                         shipping_bill_date          = ls_shippingbill-shipping_bill_date
                         port_code                   = ls_shippingbill-port_code
                         port_codename               = ls_shippingbill-port_codename
                         currency                    = 'INR'
                         fob_lc_v                    = <lfs_shippingbillitem>-fob_lc_v
                         rodtep_dd_v                 = COND #( WHEN ls_header-scrolltype = '1'
                                                               THEN <lfs_shippingbillitem>-total_rodtep_v
                                                               ELSE <lfs_shippingbillitem>-total_duty_drawback_v )

                         %control-scrollno           = if_abap_behv=>mk-on
                         %control-shipping_bill      = if_abap_behv=>mk-on
                         %control-shipping_bill_date = if_abap_behv=>mk-on
                         %control-port_code          = if_abap_behv=>mk-on
                         %control-port_codename      = if_abap_behv=>mk-on
                         %control-currency           = if_abap_behv=>mk-on
                         %control-fob_lc_v           = if_abap_behv=>mk-on
                         %control-rodtep_dd_v        = if_abap_behv=>mk-on ) ) ) )
             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(ls_mapped)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(ls_failed)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED FINAL(ls_reported).
    ENDLOOP.

**    MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
**                 ENTITY head
**                 UPDATE
**                 FIELDS ( mimetype attachment filename )
**                 WITH VALUE #( ( %tky       = ls_header-%tky
**
**                                 mimetype    = ''
**                                 attachment  = ''
**                                 filename    = '' ) ).

  ENDMETHOD.

*// ----- Validation Upload File ---
  METHOD upload_filedata.

    TYPES: BEGIN OF ty_excel,
             shipno TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA: lt_excel TYPE tt_excel,
          lv_msg   TYPE string.
*----------------------------------------------------------*

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zr_scrollhead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL OR ls_header-attachment IS INITIAL.
      RETURN.
    ENDIF.

*// Excel Upload File

    FINAL(lv_attachment) = ls_header-attachment.
    IF lv_attachment IS NOT INITIAL.
      FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
      FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

      FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

      FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
        )->row_stream(
        )->operation->write_to( REF #( lt_excel ) ).

      lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
                 )->if_xco_xlsx_ra_operation~execute( ).
    ENDIF.
*//-- Validate Excel File data
    DELETE lt_excel INDEX 1.
    SORT lt_excel BY shipno.

***    IF ls_header-filename IS INITIAL.
***      lv_msg = |Please provide filename|.
***      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .
***
***      APPEND VALUE #( %tky        = ls_header-%tky
***                      %state_area = 'Validate_Header'
***                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
***                                                           text     = lv_msg ) )
***      TO reported-head.
***      RETURN.
***    ENDIF.

    IF lt_excel[] IS INITIAL.
      lv_msg = |No Data is Present in File|.
      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .

      APPEND VALUE #( %tky        = ls_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-head.
      RETURN.
    ENDIF.

    LOOP AT lt_excel INTO DATA(ls_excel).
      DATA(lt_exl_tmp) = lt_excel .
      DELETE lt_exl_tmp WHERE shipno <> ls_excel-shipno .
      IF lines( lt_exl_tmp ) > 1 .
        lv_msg = |Ship Bill- | && ls_excel-shipno && | Duplicate in Excel File|.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .

        APPEND VALUE #( %tky        = ls_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-head.
      ENDIF.


      SELECT SINGLE * FROM zex_shipbill_hdr WHERE shipping_bill = @ls_excel-shipno
            INTO @DATA(ls_shipping_hed).
      IF sy-subrc <> 0 .
        lv_msg = |Ship Bill- | && ls_excel-shipno && | Does not Exist|.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .

        APPEND VALUE #( %tky        = ls_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-head.
      ENDIF.

      SELECT SINGLE * FROM zex_shipbill_hdr WHERE shipping_bill = @ls_excel-shipno
            INTO @DATA(ls_ship_check).
      IF sy-subrc <> 0 .
        lv_msg = |Ship Bill- | && ls_excel-shipno && | Does not Exist|.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .

        APPEND VALUE #( %tky        = ls_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-head.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.


CLASS lhc_zr_scrollitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR item RESULT result.
    METHODS values FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~values.
    METHODS update_apply_amt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~update_apply_amt.
    METHODS check_data FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~check_data.
    METHODS update_head FOR DETERMINE ON SAVE
      IMPORTING keys FOR item~update_head.

ENDCLASS.


CLASS lhc_zr_scrollitem IMPLEMENTATION.
  METHOD get_instance_features.

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
         ENTITY item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR ls_item IN lt_item
                      ( %tky    = ls_item-%tky

                        %update = COND #( WHEN ls_header-post = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled )

*                        %delete = COND #( WHEN ls_header-post = ''
*                                          THEN if_abap_behv=>fc-o-enabled
*                                          ELSE if_abap_behv=>fc-o-disabled )

                            ) ).

  ENDMETHOD.
  METHOD values.
    DATA: lv_rodtepamt TYPE dmbtr,
          lv_applyamt  TYPE dmbtr.

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
       ENTITY head
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT FINAL(lt_header)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(lt_header_failed).

    READ ENTITY zr_scrollhead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.


    lv_rodtepamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                                 NEXT lv_amt = lv_amt + ls_itm-rodtep_dd_v ).

    lv_applyamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                                 NEXT lv_amt = lv_amt + ls_itm-appliedamount ).

    ls_header-rodtepttl        = lv_rodtepamt.
    ls_header-appliedamountttl = lv_applyamt.

    MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
               ENTITY head
               UPDATE
               FIELDS ( rodtepttl appliedamountttl )
               WITH VALUE #( ( %tky       = ls_header-%tky

                               rodtepttl        = ls_header-rodtepttl
                               appliedamountttl = ls_header-appliedamountttl ) ).

  ENDMETHOD.

  METHOD update_apply_amt.

    DATA: lv_rodtepamt TYPE dmbtr,
          lv_applyamt  TYPE dmbtr.

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
       ENTITY head
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT FINAL(lt_header)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(lt_header_failed).

    READ ENTITY zr_scrollhead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.


    lv_rodtepamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                                 NEXT lv_amt = lv_amt + ls_itm-rodtep_dd_v ).

    lv_applyamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                                 NEXT lv_amt = lv_amt + ls_itm-appliedamount ).

    ls_header-rodtepttl        = lv_rodtepamt.
    ls_header-appliedamountttl = lv_applyamt.

    MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
               ENTITY head
               UPDATE
               FIELDS ( rodtepttl appliedamountttl )
               WITH VALUE #( ( %tky       = ls_header-%tky

                               rodtepttl        = ls_header-rodtepttl
                               appliedamountttl = ls_header-appliedamountttl ) ).

  ENDMETHOD.

  METHOD check_data.
    DATA: lv_msg TYPE string .

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
       ENTITY head
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT FINAL(lt_header)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(lt_header_failed).

    READ ENTITY zr_scrollhead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.


"""""""""""" Added by Infocus  on 26th Nov 2025  "for Cancel Shipping Bill Validation
loop at lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).

if <ls_item>-shipping_bill is NOT INITIAL.

select single Closestatus from zex_shipbill_hdr where shipping_bill  = @<ls_item>-shipping_bill and closestatus = 'X' into @data(cancelStatus).
if sy-subrc = 0.
  APPEND VALUE #( %tky            = ls_header-%tky
                    %state_area       = 'Validate_Head'
                    %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     =  'Cancel Shipping Bill Not Allowed-' && <ls_item>-shipping_bill ) )
         TO reported-head.

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.

endif.

endif.


endloop.
"""""""""""""""""""""""""""""""""""""""" End Added By Infocus on 26th Nov 2025

    DATA(lt_portcode) = lt_item[].
    DELETE ADJACENT DUPLICATES FROM lt_portcode COMPARING port_code .
    IF lines( lt_portcode ) > 1 .
      lv_msg = 'Multiple PortCode Not Allowed in Scroll'.
      APPEND VALUE #( %tky            = ls_header-%tky
                    %state_area       = 'Validate_Head'
                    %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     =  lv_msg ) )
         TO reported-head.

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.
    ENDIF.


  ENDMETHOD.

  METHOD update_head.

    DATA: lv_rodtepamt TYPE dmbtr,
          lv_applyamt  TYPE dmbtr.

    READ ENTITIES OF zr_scrollhead IN LOCAL MODE
       ENTITY head
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT FINAL(lt_header)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(lt_header_failed).

    READ ENTITY zr_scrollhead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.


    lv_rodtepamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                                 NEXT lv_amt = lv_amt + ls_itm-rodtep_dd_v ).

    lv_applyamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                                 NEXT lv_amt = lv_amt + ls_itm-appliedamount ).

    ls_header-rodtepttl        = lv_rodtepamt.
    ls_header-appliedamountttl = lv_applyamt.

    MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
               ENTITY head
               UPDATE
               FIELDS ( rodtepttl appliedamountttl )
               WITH VALUE #( ( %tky       = ls_header-%tky

                               rodtepttl        = ls_header-rodtepttl
                               appliedamountttl = ls_header-appliedamountttl ) ).

  ENDMETHOD.

ENDCLASS.
