CLASS lhc_zi_vend_bank_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_vend_bank_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_vend_bank_hdr RESULT result.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_vend_bank_hdr~upd RESULT result.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION zi_vend_bank_hdr~uploadexceldata RESULT result.

    METHODS fields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_vend_bank_hdr~fields.

    METHODS change_status FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_vend_bank_hdr~change_status.

    METHODS validate_fields FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_vend_bank_hdr~validate_fields.

ENDCLASS.

CLASS lhc_zi_vend_bank_hdr IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
            ENTITY zi_vend_bank_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header)
            FAILED failed.

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).


    result = VALUE #( ( %tky              = ls_header-%tky

                        %update           = COND #( WHEN ls_header-internalno IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only )

                        %action-edit      = COND #( WHEN ls_header-internalno IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-o-disabled )


                        %delete           = COND #( WHEN ls_header-post = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only )

                        %action-upd       = COND #( WHEN ls_header-post = 'X' OR ls_header-internalno IS INITIAL OR
                                                         ls_header-status <> '1'
                                                    THEN if_abap_behv=>fc-o-disabled )

                        %assoc-_item      = if_abap_behv=>fc-f-read_only

                        %field-attachment = COND #( WHEN ls_header-status <> ' '
                                                    THEN if_abap_behv=>fc-f-read_only )

                        %field-comments   = COND #( WHEN ls_header-status <> ' '
                                                    THEN if_abap_behv=>fc-f-read_only ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD upd.

    READ ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
              ENTITY zi_vend_bank_hdr
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(lt_header)
              FAILED failed.

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    READ ENTITY zi_vend_bank_hdr
           BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(item).

*    DATA : curr_bank_1 TYPE TABLE FOR CREATE i_businesspartnertp_3\_businesspartnerbank.
*    DATA : lv_cou TYPE numc5.
**
*    CLEAR : lv_cou.
*    LOOP AT item ASSIGNING FIELD-SYMBOL(<new_bank>).
*
*      READ ENTITIES OF i_businesspartnertp_3 ENTITY businesspartner
*      ALL FIELDS WITH VALUE #( (
*        businesspartner = <new_bank>-supp
*      ) ) RESULT DATA(partner).
*
*      READ ENTITIES OF i_businesspartnertp_3 ENTITY businesspartner BY \_businesspartnerbank
*      ALL FIELDS WITH VALUE #( (
*        %tky = partner[ 1 ]-%tky
*      ) )
*      RESULT DATA(curr_bank).
*
*      IF lv_cou = 0.
*        DATA(lt_curr_bank) = curr_bank[].
*        CLEAR:lt_curr_bank[].
*      ENDIF.
*
*      READ TABLE curr_bank INTO DATA(ls_bank_curr) INDEX 1.
*
*      APPEND INITIAL LINE TO lt_curr_bank ASSIGNING FIELD-SYMBOL(<fs_bank>).
*
*      <fs_bank> = ls_bank_curr.
*
*      <fs_bank>-%is_draft = if_abap_behv=>mk-off.
*      <fs_bank>-%pid = partner[ 1 ]-BusinessPartnerUUID.
**
*      <fs_bank>-bankaccount = <new_bank>-bankacc.
*      <fs_bank>-bankaccountname = <new_bank>-bankname.
*      <fs_bank>-banknumber = <new_bank>-bankkey.
*      <fs_bank>-bankcountrykey = <new_bank>-bankcou.
*
*      lv_cou = lv_cou + 1.
*
*      CLEAR : ls_bank_curr.
*
*    ENDLOOP.
*
*
*    MODIFY ENTITY i_businesspartnerbanktp_3
*      UPDATE FROM VALUE #( FOR ls_bank IN lt_curr_bank ( VALUE #(
*      %data-bankaccount = ls_bank-bankaccount
*      %data-bankaccountname = ls_bank-bankaccountname
*      %data-banknumber = ls_bank-banknumber
*      %data-bankcountrykey  = ls_bank-bankcountrykey
*
*      %control-bankaccount = cl_abap_behv=>flag_changed
*      %control-bankaccountname = cl_abap_behv=>flag_changed
*      %control-banknumber  = cl_abap_behv=>flag_changed
*      %control-bankcountrykey  = cl_abap_behv=>flag_changed
*
*      %is_draft = if_abap_behv=>mk-off
*
*      %tky = CORRESPONDING #( ls_bank-%tky ) ) ) )
*      REPORTED DATA(reported_1)
*      FAILED DATA(failed_1).
*
*    IF reported_1-businesspartnerbank IS NOT INITIAL.
*      APPEND VALUE #(
*      %tky                        = ls_header-%tky
*      %state_area                 = 'Validate_Head'
*      %msg                        = new_message_with_text(
*      severity = if_abap_behv_message=>severity-error
*      text     = 'Error in Confirmation'
*      )
*      ) TO reported-zi_vend_bank_hdr.
*
*      APPEND VALUE #(
*       %tky = ls_header-%tky
*      ) TO failed-zi_vend_bank_hdr.
*
*    ELSE.

    LOOP AT item INTO DATA(ls_item).

      MODIFY ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
                      ENTITY zi_vend_bank_itm
                      UPDATE FIELDS ( status )
                      WITH VALUE #( id = ls_header-id
                                    ( %tky         = ls_item-%tky
                                      status       = '2'
                                  ) ).

      CLEAR : ls_item.
    ENDLOOP.

    MODIFY ENTITIES OF zi_vend_bank_hdr  IN LOCAL MODE
               ENTITY zi_vend_bank_hdr
               UPDATE FIELDS ( status post )
               WITH VALUE #( FOR key IN keys
                             (  %tky = key-%tky
                                status = '3'
                                post   = 'X'
                             ) )
               FAILED FINAL(ls_failed_1)
               REPORTED FINAL(ls_reported_1).

*    ENDIF.


    READ ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
            ENTITY zi_vend_bank_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header_1 IN header_upd
                          ( %tky   = ls_header_1-%tky
                            %param = ls_header_1 ) ).

  ENDMETHOD.

  METHOD uploadexceldata.
    TYPES: BEGIN OF ty_excel,
             supp     TYPE string,
             suppname TYPE string,
             bankname TYPE string,
             bankacc  TYPE string,
             bankcou  TYPE string,
             bankkey  TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
         ENTITY zi_vend_bank_hdr
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(lt_head).

    FINAL(lv_attachment) = lt_head[ 1 ]-attachment.

    FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
    FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

    FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
      )->row_stream(
      )->operation->write_to( REF #( lt_excel ) ).

    lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
               )->if_xco_xlsx_ra_operation~execute( ).
  ENDMETHOD.

  METHOD fields.
    MODIFY ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
               ENTITY zi_vend_bank_hdr
               UPDATE FROM VALUE #( FOR key IN keys
                                    ( status          = '0'
                                      %control-status = if_abap_behv=>mk-on ) ).

    IF keys[ 1 ]-%is_draft = '01'.
      MODIFY ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
             ENTITY zi_vend_bank_hdr
             EXECUTE uploadexceldata
             FROM CORRESPONDING #( keys ).
    ENDIF.
  ENDMETHOD.

  METHOD change_status.

    TYPES: BEGIN OF ty_excel,
             supp     TYPE string,
             suppname TYPE string,
             bankname TYPE string,
             bankacc  TYPE string,
             bankcou  TYPE string,
             bankkey  TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
         ENTITY zi_vend_bank_hdr
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(lt_head).

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
    LOOP AT lt_excel INTO FINAL(ls_excel) WHERE supp IS NOT INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      MODIFY ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
             ENTITY zi_vend_bank_hdr
             CREATE BY \_item
             FROM VALUE #( ( id      = ls_head-id
                             %target = VALUE #( ( %cid                     = ls_excel-supp

                                                  supp                     = ls_excel-supp
                                                  suppname                 = ls_excel-suppname
                                                  bankname                 = ls_excel-bankname
                                                  bankacc                  = ls_excel-bankacc
                                                  bankcou                  = ls_excel-bankcou
                                                  bankkey                   = ls_excel-bankkey

                                                  status                   = '1'


                                                  %control-supp            = if_abap_behv=>mk-on
                                                  %control-suppname        = if_abap_behv=>mk-on
                                                  %control-bankname        = if_abap_behv=>mk-on
                                                  %control-bankacc         = if_abap_behv=>mk-on
                                                  %control-bankcou         = if_abap_behv=>mk-on
                                                  %control-bankkey          = if_abap_behv=>mk-on

                                                  %control-status          = if_abap_behv=>mk-on ) ) ) )
             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(ls_mapped)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(ls_failed)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED FINAL(ls_reported).

      IF ls_head-status = ''.

        ls_head-status = '1'.

        GET TIME STAMP FIELD DATA(lv_utctimestamp).
        CONVERT TIME STAMP lv_utctimestamp  TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
        ls_head-internalno = lv_date+0(4) && |-| &&
                             lv_date+4(2) && |/| &&
                             lv_time+0(2) && |:| &&
                             lv_time+2(2) && |:| &&
                             lv_time+4(2) && |/| &&
                             sy-uname.

        MODIFY ENTITIES OF zi_vend_bank_hdr  IN LOCAL MODE
               ENTITY zi_vend_bank_hdr
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
  ENDMETHOD.

  METHOD validate_fields.

    TYPES: BEGIN OF ty_excel,
             supp     TYPE string,
             suppname TYPE string,
             bankname TYPE string,
             bankacc  TYPE string,
             bankcou  TYPE string,
             bankkey  TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.


    DATA lt_excel TYPE tt_excel.
    DATA lv_msg   TYPE char100.

    READ ENTITIES OF zi_vend_bank_hdr IN LOCAL MODE
         ENTITY zi_vend_bank_hdr
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(lt_head).

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

    IF ls_head-filename IS INITIAL.
      lv_msg = |Please provide filename|.
      APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_vend_bank_hdr.

      APPEND VALUE #( %tky        = ls_head-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_vend_bank_hdr.

    ELSE.
      DELETE lt_excel INDEX 1.

      IF lt_excel IS INITIAL.
        lv_msg = |no data is present in file|.
        APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_vend_bank_hdr.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_vend_bank_hdr.

      ELSE.
        SORT lt_excel BY supp.
        DATA(lv_line) = lines( lt_excel ).

        DATA(lt_excel_1) = lt_excel[].
        SORT lt_excel_1 BY supp.
        DELETE ADJACENT DUPLICATES FROM lt_excel_1 COMPARING supp.
        DATA(lv_line_1) = lines( lt_excel ).
        IF lv_line <> lv_line_1.
          lv_msg = |Please remove duplicate material frpm file|.
          APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_vend_bank_hdr.

          APPEND VALUE #( %tky        = ls_head-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_vend_bank_hdr.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_vend_bank_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_vend_bank_itm RESULT result.

ENDCLASS.

CLASS lhc_zi_vend_bank_itm IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.
