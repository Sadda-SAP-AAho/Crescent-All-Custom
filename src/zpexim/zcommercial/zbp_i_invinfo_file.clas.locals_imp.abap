CLASS lsc_zi_invinfo_file DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_invinfo_file IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_invinfo_file IS NOT INITIAL.

      DATA(lt_head) = update-zi_invinfo_file.

      READ TABLE lt_head INTO DATA(ls_head) INDEX 1.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      " Process only when posted
      IF ls_head-status = '3'.

        " Read validated item records
        SELECT *
          FROM zdt_invitem_file
          WHERE id = @ls_head-id
            AND status = '2'
          INTO TABLE @DATA(lt_upd).

        IF sy-subrc <> 0.
          RETURN.
        ENDIF.

        DATA:
          ls_comm TYPE zdt_comm_hed,
          lt_comm TYPE STANDARD TABLE OF zdt_comm_hed.

        LOOP AT lt_upd INTO DATA(ls_upd).

          CLEAR ls_comm.

          " Read existing CommID record
          SELECT SINGLE *
            FROM zdt_comm_hed
            WHERE commid = @ls_upd-commid
            INTO @ls_comm.

          " Skip if CommID does not exist
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          " Update only required fields
          ls_comm-bankrefno      = ls_upd-bankrefno.
          ls_comm-billcloseflag  = ls_upd-billcloseflag.
          ls_comm-fundplanremark = ls_upd-fundplanremark.
          ls_comm-planingmonth   = ls_upd-planingmonth.

          APPEND ls_comm TO lt_comm.

        ENDLOOP.

        " Update existing records only
        IF lt_comm IS NOT INITIAL.

          MODIFY zdt_comm_hed FROM TABLE @lt_comm.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_zi_invinfo_file DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_invinfo_file RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_invinfo_file RESULT result.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_invinfo_file~upd RESULT result.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION zi_invinfo_file~uploadexceldata RESULT result.

    METHODS valid FOR MODIFY
      IMPORTING keys FOR ACTION zi_invinfo_file~valid RESULT result.

    METHODS fields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_invinfo_file~fields.

    METHODS change_status FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_invinfo_file~change_status.

    METHODS validate_fields FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_invinfo_file~validate_fields.

ENDCLASS.

CLASS lhc_zi_invinfo_file IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_invinfo_file IN LOCAL MODE
           ENTITY zi_invinfo_file
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_header)
           FAILED failed.

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    SELECT SINGLE *
        FROM zdt_invinfo_file
        WHERE id = @ls_header-id
        INTO @DATA(ls_zpp_serial_table).

    READ ENTITY zi_invinfo_file
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
             commid         TYPE string,
             bankrefno      TYPE string,
             billcloseflag  TYPE string,
             fundplanremark TYPE string,
             planingmonth   TYPE string,

           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_invinfo_file IN LOCAL MODE
         ENTITY zi_invinfo_file
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

    MODIFY ENTITIES OF zi_invinfo_file IN LOCAL MODE
               ENTITY zi_invinfo_file
               UPDATE FROM VALUE #( FOR key IN keys
                                    ( status          = '0'
                                      %control-status = if_abap_behv=>mk-on ) ).

    IF keys[ 1 ]-%is_draft = '01'.
      MODIFY ENTITIES OF zi_invinfo_file IN LOCAL MODE
             ENTITY zi_invinfo_file
             EXECUTE uploadexceldata
             FROM CORRESPONDING #( keys ).
    ENDIF.

  ENDMETHOD.

  METHOD change_status.

    TYPES: BEGIN OF ty_excel,
             commid         TYPE string,
             bankrefno      TYPE string,
             billcloseflag  TYPE string,
             fundplanremark TYPE string,
             planingmonth   TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    DATA : lv_cdate TYPE sydate.

    READ ENTITIES OF zi_invinfo_file IN LOCAL MODE
         ENTITY zi_invinfo_file
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
      LOOP AT lt_excel INTO FINAL(ls_excel) WHERE commid IS NOT INITIAL.


        MODIFY ENTITIES OF zi_invinfo_file IN LOCAL MODE
               ENTITY zi_invinfo_file
               CREATE BY \_item
               FROM VALUE #( ( id      = ls_head-id
                               %target = VALUE #( ( %cid                     = ls_excel-commid

                                                    commid                  = ls_excel-commid
                                                    bankrefno               = ls_excel-bankrefno
                                                    billcloseflag           = ls_excel-billcloseflag
                                                    fundplanremark          = ls_excel-fundplanremark
                                                    planingmonth = ls_excel-planingmonth

                                                    status                   = '1'


                                                    %control-commid         = if_abap_behv=>mk-on
                                                    %control-bankrefno     = if_abap_behv=>mk-on
                                                    %control-billcloseflag       = if_abap_behv=>mk-on
                                                    %control-fundplanremark         = if_abap_behv=>mk-on
                                                    %control-planingmonth         = if_abap_behv=>mk-on

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

          MODIFY ENTITIES OF zi_invinfo_file IN LOCAL MODE
                 ENTITY zi_invinfo_file
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
             commid         TYPE string,
             bankrefno      TYPE string,
             billcloseflag  TYPE string,
             fundplanremark TYPE string,
             planingmonth   TYPE string,

           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.
    DATA lv_msg   TYPE char100.

    READ ENTITIES OF zi_invinfo_file IN LOCAL MODE
         ENTITY zi_invinfo_file
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
        APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_invinfo_file.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_invinfo_file.

      ELSE.
        DELETE lt_excel INDEX 1.

        IF lt_excel IS INITIAL.
          lv_msg = |no data is present in file|.
          APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_invinfo_file.

          APPEND VALUE #( %tky        = ls_head-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_invinfo_file.

        ELSE.
          SORT lt_excel BY commid.
          DATA(lv_line) = lines( lt_excel ).

          DATA(lt_excel_1) = lt_excel[].
          SORT lt_excel_1 BY commid.
          DELETE ADJACENT DUPLICATES FROM lt_excel_1 COMPARING commid.
          DATA(lv_line_1) = lines( lt_excel_1 ).
          IF lv_line <> lv_line_1.
            lv_msg = |Please remove duplicate CommID from file|.
            APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_invinfo_file.

            APPEND VALUE #( %tky        = ls_head-%tky
                            %state_area = 'Validate_Header'
                            %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = lv_msg ) )
            TO reported-zi_invinfo_file.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD valid.

    DATA : lv_msg TYPE char100.

    " Read Header Data
    READ ENTITIES OF zi_invinfo_file IN LOCAL MODE
           ENTITY zi_invinfo_file
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    " Check whether document is saved
    IF gfs_header-id IS INITIAL.

      lv_msg = 'Please save the data and click on Validate button'.

      APPEND VALUE #(
        %tky = gfs_header-%tky
      ) TO failed-zi_invinfo_file.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'VALIDATE_HEADER'
        %msg        = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                         text     = lv_msg )
      ) TO reported-zi_invinfo_file.

      RETURN.

    ENDIF.

    " Read Item Data
    READ ENTITY zi_invinfo_file
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item).

    LOOP AT item INTO DATA(ls_item).

      CLEAR : ls_item-msg,
              ls_item-status.

      " Validate CommId Exists
      SELECT SINGLE *
        FROM zdt_comm_hed
        WHERE commid = @ls_item-commid
        INTO @DATA(ls_pro).

      IF ls_pro IS INITIAL.

        ls_item-status = '3'.
        ls_item-msg    = 'CommId not found'.

      ELSE.

*      " Check Already Maintained
*      SELECT SINGLE *
*        FROM zdt_comm_hed
*        WHERE commid = @ls_item-commid
*        INTO @DATA(ls_mat).
*
*      IF ls_mat IS NOT INITIAL.
*
*        ls_item-status = '3'.
*        ls_item-msg    = 'CommId already maintained'.
*
*      ELSE.

        ls_item-status = '2'.
        ls_item-msg    = 'Validation Successful'.

*      ENDIF.

      ENDIF.

      " Update Item Status
      MODIFY ENTITIES OF zi_invinfo_file IN LOCAL MODE
             ENTITY zi_invitem_file
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
    MODIFY ENTITIES OF zi_invinfo_file IN LOCAL MODE
           ENTITY zi_invinfo_file
           UPDATE FIELDS ( status )
           WITH VALUE #(
             (
               %tky   = gfs_header-%tky
               status = '2'
             )
           ).

    " Read Updated Header
    READ ENTITIES OF zi_invinfo_file IN LOCAL MODE
           ENTITY zi_invinfo_file
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

    READ ENTITIES OF zi_invinfo_file IN LOCAL MODE
                 ENTITY zi_invinfo_file
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    MODIFY ENTITIES OF zi_invinfo_file IN LOCAL MODE
                ENTITY zi_invinfo_file
                UPDATE FIELDS ( post status )
                WITH VALUE #( FOR key IN keys
                            (  %tky = gfs_header-%tky
                               post   = 'X'
                               status = '3' ) ).


    READ ENTITIES OF zi_invinfo_file IN LOCAL MODE
           ENTITY zi_invinfo_file
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.



ENDCLASS.

CLASS lhc_zi_invitem_file DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_invitem_file RESULT result.

ENDCLASS.

CLASS lhc_zi_invitem_file IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.
