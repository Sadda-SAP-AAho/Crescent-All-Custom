CLASS lsc_zi_gstinfupd_hd DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_gstinfupd_hd IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_gstinfupd_hd IS NOT INITIAL.

      DATA(lt_head) = update-zi_gstinfupd_hd.

      IF lt_head[ 1 ]-status = '3'.

        READ TABLE lt_head INTO DATA(ls_head) INDEX 1.

        SELECT *
          FROM zdt_gstinfupd_it
          WHERE id = @ls_head-id
          INTO TABLE @DATA(lt_upd).

        DATA:
          ls_item TYPE zdt_gstinfodash,
          lt_item TYPE STANDARD TABLE OF zdt_gstinfodash.

        DATA:
          lv_date TYPE datn,
          lv_time TYPE timn.

        LOOP AT lt_upd INTO DATA(ls_upd)
             WHERE status = '2'.

          CLEAR ls_item.

          "Copy all common fields
          MOVE-CORRESPONDING ls_upd TO ls_item.

          "Time-stamp
          TRY.
              CONVERT DATE cl_abap_context_info=>get_system_date( )
                      TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp)
                TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
            CATCH cx_abap_context_info_error.
          ENDTRY.

          CONVERT TIME STAMP lv_timestamp
                  TIME ZONE 'INDIA'
                  INTO DATE lv_date
                       TIME lv_time.

          ls_item-lastchngedt = lv_date.
          ls_item-lastchnngtm = lv_time.

          APPEND ls_item TO lt_item.

          CLEAR:
            ls_item,
            lv_date,
            lv_time.

        ENDLOOP.

        IF lt_item IS NOT INITIAL.

          MODIFY zdt_gstinfodash
            FROM TABLE @lt_item.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_zi_gstinfupd_hd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gstinfupd_hd RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gstinfupd_hd RESULT result.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_gstinfupd_hd~upd RESULT result.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION zi_gstinfupd_hd~uploadexceldata RESULT result.

    METHODS valid FOR MODIFY
      IMPORTING keys FOR ACTION zi_gstinfupd_hd~valid RESULT result.

    METHODS fields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gstinfupd_hd~fields.

    METHODS change_status FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_gstinfupd_hd~change_status.

    METHODS validate_fields FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gstinfupd_hd~validate_fields.

ENDCLASS.

CLASS lhc_zi_gstinfupd_hd IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
           ENTITY zi_gstinfupd_hd
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_header)
           FAILED failed.

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    SELECT SINGLE *
        FROM zdt_gstinfupd_hd
        WHERE id = @ls_header-id
        INTO @DATA(ls_zpp_serial_table).

    READ ENTITY zi_gstinfupd_hd
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

                        %field-attachment = COND #( WHEN ls_header-status <> ' '
                                                    THEN if_abap_behv=>fc-f-read_only )

                        %field-comments   = COND #( WHEN ls_header-status <> ' '
                                                    THEN if_abap_behv=>fc-f-read_only ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD uploadexceldata.
    TYPES: BEGIN OF ty_excel,
             fisyear          TYPE string,
             jeno             TYPE string,
             jedate           TYPE string,
             documenttype     TYPE string,
             journalentrytype TYPE string,
             documentno       TYPE string,
             vendorcode       TYPE string,
             vendorname       TYPE string,
             invoicedrno      TYPE string,
             invoicedrdate    TYPE string,
             gstno            TYPE string,
             state            TYPE string,
             sumtaxablevalue  TYPE string,
             sumcgst          TYPE string,
             sumsgst          TYPE string,
             sumigst          TYPE string,
             sumrcmcgst       TYPE string,
             sumrcmsgst       TYPE string,
             sumrcmigst       TYPE string,
             sumtotalinvvalue TYPE string,
             twobrefno        TYPE string,
             gstremarks       TYPE string,
             newgstno         TYPE string,
             gstmonth         TYPE string,
             extra1           TYPE string,
             extra2           TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
         ENTITY zi_gstinfupd_hd
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
    MODIFY ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
               ENTITY zi_gstinfupd_hd
               UPDATE FROM VALUE #( FOR key IN keys
                                    ( status          = '0'
                                      %control-status = if_abap_behv=>mk-on ) ).

    IF keys[ 1 ]-%is_draft = '01'.
      MODIFY ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
             ENTITY zi_gstinfupd_hd
             EXECUTE uploadexceldata
             FROM CORRESPONDING #( keys ).
    ENDIF.
  ENDMETHOD.

  METHOD change_status.

    TYPES: BEGIN OF ty_excel,
             fisyear          TYPE string,
             jeno             TYPE string,
             jedate           TYPE string,
             documenttype     TYPE string,
             journalentrytype TYPE string,
             documentno       TYPE string,
             vendorcode       TYPE string,
             vendorname       TYPE string,
             invoicedrno      TYPE string,
             invoicedrdate    TYPE string,
             gstno            TYPE string,
             state            TYPE string,
             sumtaxablevalue  TYPE string,
             sumcgst          TYPE string,
             sumsgst          TYPE string,
             sumigst          TYPE string,
             sumrcmcgst       TYPE string,
             sumrcmsgst       TYPE string,
             sumrcmigst       TYPE string,
             sumtotalinvvalue TYPE string,
             twobrefno        TYPE string,
             gstremarks       TYPE string,
             newgstno         TYPE string,
             gstmonth         TYPE string,
             extra1           TYPE string,
             extra2           TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    DATA : lv_cdate TYPE sydate.

    READ ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
         ENTITY zi_gstinfupd_hd
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
      LOOP AT lt_excel INTO FINAL(ls_excel) WHERE fisyear IS NOT INITIAL AND jeno IS NOT INITIAL.

        MODIFY ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
        ENTITY zi_gstinfupd_hd
        CREATE BY \_item
        FROM VALUE #(
                      (
                        id      = ls_head-id
                        %target = VALUE #(
                                            (
                                              %cid               = ls_excel-jeno

                                              fisyear            = ls_excel-fisyear
                                              jeno               = ls_excel-jeno
                                              jedate             = ls_excel-jedate
                                              documenttype       = ls_excel-documenttype
                                              journalentrytype   = ls_excel-journalentrytype
                                              documentno         = ls_excel-documentno
                                              vendorcode         = ls_excel-vendorcode
                                              vendorname         = ls_excel-vendorname
                                              invoicedrno        = ls_excel-invoicedrno
                                              invoicedrdate      = ls_excel-invoicedrdate
                                              gstno              = ls_excel-gstno
                                              state              = ls_excel-state
                                              sumtaxablevalue    = ls_excel-sumtaxablevalue
                                              sumcgst            = ls_excel-sumcgst
                                              sumsgst            = ls_excel-sumsgst
                                              sumigst            = ls_excel-sumigst
                                              sumrcmcgst         = ls_excel-sumrcmcgst
                                              sumrcmsgst         = ls_excel-sumrcmsgst
                                              sumrcmigst         = ls_excel-sumrcmigst
                                              sumtotalinvvalue   = ls_excel-sumtotalinvvalue
                                              twobrefno          = ls_excel-twobrefno
                                              gstremarks         = ls_excel-gstremarks
                                              newgstno           = ls_excel-newgstno
                                              gstmonth           = ls_excel-gstmonth
                                              extra1             = ls_excel-extra1
                                              extra2             = ls_excel-extra2

                                              status             = '1'

                                              %control-fisyear          = if_abap_behv=>mk-on
                                              %control-jeno             = if_abap_behv=>mk-on
                                              %control-jedate           = if_abap_behv=>mk-on
                                              %control-documenttype     = if_abap_behv=>mk-on
                                              %control-journalentrytype = if_abap_behv=>mk-on
                                              %control-documentno       = if_abap_behv=>mk-on
                                              %control-vendorcode       = if_abap_behv=>mk-on
                                              %control-vendorname       = if_abap_behv=>mk-on
                                              %control-invoicedrno      = if_abap_behv=>mk-on
                                              %control-invoicedrdate    = if_abap_behv=>mk-on
                                              %control-gstno            = if_abap_behv=>mk-on
                                              %control-state            = if_abap_behv=>mk-on
                                              %control-sumtaxablevalue  = if_abap_behv=>mk-on
                                              %control-sumcgst          = if_abap_behv=>mk-on
                                              %control-sumsgst          = if_abap_behv=>mk-on
                                              %control-sumigst          = if_abap_behv=>mk-on
                                              %control-sumrcmcgst       = if_abap_behv=>mk-on
                                              %control-sumrcmsgst       = if_abap_behv=>mk-on
                                              %control-sumrcmigst       = if_abap_behv=>mk-on
                                              %control-sumtotalinvvalue = if_abap_behv=>mk-on
                                              %control-twobrefno        = if_abap_behv=>mk-on
                                              %control-gstremarks       = if_abap_behv=>mk-on
                                              %control-newgstno         = if_abap_behv=>mk-on
                                              %control-gstmonth         = if_abap_behv=>mk-on
                                              %control-extra1           = if_abap_behv=>mk-on
                                              %control-extra2           = if_abap_behv=>mk-on

                                              %control-status           = if_abap_behv=>mk-on ) ) ) )
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

          MODIFY ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
                 ENTITY zi_gstinfupd_hd
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

  METHOD validate_fields.
    TYPES: BEGIN OF ty_excel,
             fisyear          TYPE string,
             jeno             TYPE string,
             jedate           TYPE string,
             documenttype     TYPE string,
             journalentrytype TYPE string,
             documentno       TYPE string,
             vendorcode       TYPE string,
             vendorname       TYPE string,
             invoicedrno      TYPE string,
             invoicedrdate    TYPE string,
             gstno            TYPE string,
             state            TYPE string,
             sumtaxablevalue  TYPE string,
             sumcgst          TYPE string,
             sumsgst          TYPE string,
             sumigst          TYPE string,
             sumrcmcgst       TYPE string,
             sumrcmsgst       TYPE string,
             sumrcmigst       TYPE string,
             sumtotalinvvalue TYPE string,
             twobrefno        TYPE string,
             gstremarks       TYPE string,
             newgstno         TYPE string,
             gstmonth         TYPE string,
             extra1           TYPE string,
             extra2           TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.
    DATA lv_msg   TYPE char100.

    READ ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
         ENTITY zi_gstinfupd_hd
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

      IF ls_head-filename IS INITIAL.
        lv_msg = |Please provide filename|.
        APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_gstinfupd_hd.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_gstinfupd_hd.

      ELSE.
        DELETE lt_excel INDEX 1.

        IF lt_excel IS INITIAL.
          lv_msg = |no data is present in file|.
          APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_gstinfupd_hd.

          APPEND VALUE #( %tky        = ls_head-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_gstinfupd_hd.

        ELSE.
          SORT lt_excel BY fisyear jeno.
          DATA(lv_line) = lines( lt_excel ).

          DATA(lt_excel_1) = lt_excel[].
          SORT lt_excel_1 BY fisyear jeno.
          DELETE ADJACENT DUPLICATES FROM lt_excel_1 COMPARING fisyear jeno.
          DATA(lv_line_1) = lines( lt_excel_1 ).
          IF lv_line <> lv_line_1.
            lv_msg = |Please remove duplicate FY & Journal No from file|.
            APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_gstinfupd_hd.

            APPEND VALUE #( %tky        = ls_head-%tky
                            %state_area = 'Validate_Header'
                            %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = lv_msg ) )
            TO reported-zi_gstinfupd_hd.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD valid.

    DATA : lv_msg TYPE char100.

    " Read Header Data
    READ ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
           ENTITY zi_gstinfupd_hd
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    " Check whether document is saved
    IF gfs_header-id IS INITIAL.

      lv_msg = 'Please save the data and click on Validate button'.

      APPEND VALUE #(
        %tky = gfs_header-%tky
      ) TO failed-zi_gstinfupd_hd.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'VALIDATE_HEADER'
        %msg        = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                         text     = lv_msg )
      ) TO reported-zi_gstinfupd_hd.

      RETURN.

    ENDIF.

    " Read Item Data
    READ ENTITY zi_gstinfupd_hd
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item).

    LOOP AT item INTO DATA(ls_item).

      CLEAR : ls_item-msg,
              ls_item-status.


      " Validate FY & JE No Exists
      SELECT SINGLE *
        FROM i_journalentry
        WHERE accountingdocument = @ls_item-jeno
        AND fiscalyear = @ls_item-fisyear
        INTO @DATA(ls_pro).

      IF ls_pro IS INITIAL.

        ls_item-status = '3'.
        ls_item-msg    = 'Fiscal Year & Journal No are not found'.

      ELSE.

*        " Check Already Maintained
*
*        SELECT SINGLE * FROM zdt_gstinfodash WHERE jeno = @ls_item-jeno AND fisyear = @ls_item-fisyear
*        INTO @DATA(ls_jeinfo).
*        IF ls_jeinfo IS NOT INITIAL.
*          ls_item-status = '3'.
*          ls_item-msg = 'Fiscal Year & Journal No already maintained'.
*
*
*        ELSE.
          ls_item-status = '2'.
          ls_item-msg = 'Validation Successful'.

*        ENDIF.

      ENDIF.

      " Update Item Status
      MODIFY ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
             ENTITY zi_gstinfupd_it
             UPDATE FIELDS ( status msg )
             WITH VALUE #(
               (
                 %tky   = ls_item-%tky
                 status = ls_item-status
                 msg    = ls_item-msg
               )
             ).

    ENDLOOP.

    " Update Header Status
    MODIFY ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
           ENTITY zi_gstinfupd_hd
           UPDATE FIELDS ( status )
           WITH VALUE #(
             (
               %tky   = gfs_header-%tky
               status = '2'
             )
           ).

    " Read Updated Header
    READ ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
           ENTITY zi_gstinfupd_hd
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(header_upd).

    result = VALUE #(
               FOR ls_header IN header_upd
               (
                 %tky   = ls_header-%tky
                 %param = ls_header
               )
             ).

  ENDMETHOD.

  METHOD upd.

    READ ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
                 ENTITY zi_gstinfupd_hd
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    MODIFY ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
                ENTITY zi_gstinfupd_hd
                UPDATE FIELDS ( post status )
                WITH VALUE #( FOR key IN keys
                            (  %tky = gfs_header-%tky
                               post   = 'X'
                               status = '3' ) ).


    READ ENTITIES OF zi_gstinfupd_hd IN LOCAL MODE
           ENTITY zi_gstinfupd_hd
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_gstinfupd_it DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gstinfupd_it RESULT result.

ENDCLASS.

CLASS lhc_zi_gstinfupd_it IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.
