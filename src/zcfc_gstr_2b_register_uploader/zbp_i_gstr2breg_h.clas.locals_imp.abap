CLASS lhc_zi_gstr2breg_h DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gstr2breg_h RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gstr2breg_h RESULT result.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION zi_gstr2breg_h~uploadexceldata RESULT result.

    METHODS change_status FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_gstr2breg_h~change_status.

    METHODS checkcomb1 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gstr2breg_h~checkcomb1.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gstr2breg_h~updateheader.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_gstr2breg_h~determinedocnum.

ENDCLASS.

CLASS lhc_zi_gstr2breg_h IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
      ENTITY zi_gstr2breg_h
      FIELDS ( canceled )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    result =
      VALUE #( FOR ls_header IN lt_header
        (
          %tky = ls_header-%tky

          %features-%update =
            COND #(
              WHEN ls_header-canceled = 'YES'
              THEN if_abap_behv=>fc-o-disabled
              ELSE if_abap_behv=>fc-o-enabled )

          %features-%delete =
            COND #(
              WHEN ls_header-canceled = 'YES'
              THEN if_abap_behv=>fc-o-disabled
              ELSE if_abap_behv=>fc-o-enabled )

          %action-edit =
            COND #(
              WHEN ls_header-canceled = 'YES'
              THEN if_abap_behv=>fc-o-disabled
              ELSE if_abap_behv=>fc-o-enabled )

        ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD uploadexceldata.

    TYPES: BEGIN OF ty_excel,
             rowno       TYPE string,
             suppgstn    TYPE string,
             lglname     TYPE string,
             invno       TYPE string,
             invtyp      TYPE string,
             invdate     TYPE string,
             invval      TYPE string,
             placesupply TYPE string,
             revcharge   TYPE string,
             rateperc    TYPE string,
             taxval      TYPE string,
             intgrtax    TYPE string,
             centraltax  TYPE string,
             stateuttax  TYPE string,
             cess        TYPE string,
             gstrperiod  TYPE string,
             gstrfildate TYPE string,
             itcavail    TYPE string,
             reason      TYPE string,
             apptaxrate  TYPE string,
           END OF ty_excel.

    DATA lt_excel TYPE STANDARD TABLE OF ty_excel.

    READ ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
      ENTITY zi_gstr2breg_h
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_head).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).

    IF ls_head-attachment IS NOT INITIAL.

      DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content(
                        iv_file_content = ls_head-attachment )->read_access( ).

      DATA(lo_ws) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

      DATA(lo_pattern) =
        xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

      DATA(lo_exec) =
        lo_ws->select( lo_pattern
        )->row_stream(
        )->operation->write_to( REF #( lt_excel ) ).

      lo_exec->set_value_transformation(
        xco_cp_xlsx_read_access=>value_transformation->string_value
      )->if_xco_xlsx_ra_operation~execute( ).

    ENDIF.

  ENDMETHOD.


  METHOD change_status.

    TYPES:
      BEGIN OF ty_excel,
        rowno       TYPE string,
        suppgstn    TYPE string,
        lglname     TYPE string,
        invno       TYPE string,
        invtyp      TYPE string,
        invdate     TYPE string,
        invval      TYPE string,
        placesupply TYPE string,
        revcharge   TYPE string,
        rateperc    TYPE string,
        taxval      TYPE string,
        intgrtax    TYPE string,
        centraltax  TYPE string,
        stateuttax  TYPE string,
        cess        TYPE string,
        gstrperiod  TYPE string,
        gstrfildate TYPE string,
        itcavail    TYPE string,
        reason      TYPE string,
        apptaxrate  TYPE string,
      END OF ty_excel,
      tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
         ENTITY zi_gstr2breg_h
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_head).

    IF lt_head[ 1 ]-attachment IS NOT INITIAL.

      FINAL(lv_attachment) = lt_head[ 1 ]-attachment.

      FINAL(lo_xlsx) =
        xco_cp_xlsx=>document->for_file_content(
          iv_file_content = lv_attachment )->read_access( ).

      FINAL(lo_worksheet) =
        lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

      FINAL(lo_selection_pattern) =
        xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

      FINAL(lo_execute) =
        lo_worksheet->select(
            lo_selection_pattern )->row_stream(
            )->operation->write_to( REF #( lt_excel ) ).

      lo_execute->set_value_transformation(
        xco_cp_xlsx_read_access=>value_transformation->string_value
        )->if_xco_xlsx_ra_operation~execute( ).

      DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).

      DELETE lt_excel INDEX 1.

      LOOP AT lt_excel INTO FINAL(ls_excel)
           WHERE rowno IS NOT INITIAL.

        MODIFY ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
          ENTITY zi_gstr2breg_h
          CREATE BY \_item
          FROM VALUE #(
            (
              id = ls_head-id
              %target = VALUE #(
                (
                  %cid         = ls_excel-rowno
                  rowno        = ls_excel-rowno
                  suppgstn     = ls_excel-suppgstn
                  lglname      = ls_excel-lglname
                  invno        = ls_excel-invno
                  invtyp       = ls_excel-invtyp
                  invdate      = ls_excel-invdate
                  invval       = ls_excel-invval
                  placesupply  = ls_excel-placesupply
                  revcharge    = ls_excel-revcharge
                  rateperc     = ls_excel-rateperc
                  taxval       = ls_excel-taxval
                  intgrtax     = ls_excel-intgrtax
                  centraltax   = ls_excel-centraltax
                  stateuttax   = ls_excel-stateuttax
                  cess         = ls_excel-cess
                  gstrperiod   = ls_excel-gstrperiod
                  gstrfildate  = ls_excel-gstrfildate
                  itcavail     = ls_excel-itcavail
                  reason       = ls_excel-reason
                  apptaxrate   = ls_excel-apptaxrate

                  %control-rowno       = if_abap_behv=>mk-on
                  %control-suppgstn    = if_abap_behv=>mk-on
                  %control-lglname     = if_abap_behv=>mk-on
                  %control-invno       = if_abap_behv=>mk-on
                  %control-invtyp      = if_abap_behv=>mk-on
                  %control-invdate     = if_abap_behv=>mk-on
                  %control-invval      = if_abap_behv=>mk-on
                  %control-placesupply = if_abap_behv=>mk-on
                  %control-revcharge   = if_abap_behv=>mk-on
                  %control-rateperc    = if_abap_behv=>mk-on
                  %control-taxval      = if_abap_behv=>mk-on
                  %control-intgrtax    = if_abap_behv=>mk-on
                  %control-centraltax  = if_abap_behv=>mk-on
                  %control-stateuttax  = if_abap_behv=>mk-on
                  %control-cess        = if_abap_behv=>mk-on
                  %control-gstrperiod  = if_abap_behv=>mk-on
                  %control-gstrfildate = if_abap_behv=>mk-on
                  %control-itcavail    = if_abap_behv=>mk-on
                  %control-reason      = if_abap_behv=>mk-on
                  %control-apptaxrate  = if_abap_behv=>mk-on
                )
              )
            )
          )
          MAPPED  FINAL(ls_mapped)
          FAILED  FINAL(ls_failed)
          REPORTED FINAL(ls_reported).

        IF ls_head-internalno IS INITIAL.

          GET TIME STAMP FIELD DATA(lv_utctimestamp).

          CONVERT TIME STAMP lv_utctimestamp
            TIME ZONE 'INDIA'
            INTO DATE DATA(lv_date)
                 TIME DATA(lv_time).

          ls_head-internalno =
                lv_date+0(4) && |-|
             && lv_date+4(2) && |/|
             && lv_time+0(2) && |:|
             && lv_time+2(2) && |:|
             && lv_time+4(2) && |/|
             && sy-uname.

          MODIFY ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
            ENTITY zi_gstr2breg_h
            UPDATE FIELDS ( internalno )
            WITH VALUE #(
              FOR key IN keys
              (
                %tky       = key-%tky
                internalno = ls_head-internalno
              )
            )
            FAILED   FINAL(ls_failed_1)
            REPORTED FINAL(ls_reported_1).

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD updateheader.

    READ ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
      ENTITY zi_gstr2breg_h
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA lt_update TYPE TABLE FOR UPDATE zi_gstr2breg_h.

    LOOP AT lt_header INTO DATA(ls_header).

      SELECT SINGLE fmonth
        FROM zi_fmonth_f4
        WHERE fmonth_code = @ls_header-fmonthcd
        INTO @DATA(lv_fmonth).

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky            = ls_header-%tky
          fmonth          = lv_fmonth
          %control-fmonth = if_abap_behv=>mk-on
        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
        ENTITY zi_gstr2breg_h
        UPDATE FIELDS ( fmonth )
        WITH lt_update.

    ENDIF.

  ENDMETHOD.

  METHOD determinedocnum.

    DATA lv_date      TYPE datn.
    DATA lv_time      TYPE timn.
    DATA lv_timestamp TYPE timestampl.
    DATA lv_keyid     TYPE zdt_gstr2breg_h-keyid.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( )
                TIME cl_abap_context_info=>get_system_time( )
          INTO TIME STAMP lv_timestamp
          TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp
            TIME ZONE 'INDIA'
            INTO DATE lv_date
                 TIME lv_time.

    READ ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
      ENTITY zi_gstr2breg_h
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA lt_update TYPE TABLE FOR UPDATE zi_gstr2breg_h.

*----- Fiscal year -----
    DATA(lv_fisyear) = lv_date+0(4).

*----- Read maximum KeyID once -----
    SELECT MAX( keyid )
      FROM zdt_gstr2breg_h
      WHERE fisyear = @lv_fisyear
      INTO @lv_keyid.

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-docnum IS INITIAL.

        ls_header-fisyear = lv_fisyear.

*----- Audit fields -----
        ls_header-local_created_by = sy-uname.
        ls_header-local_created_at = lv_date.

*----- Default Cancel Status -----
        IF ls_header-canceled IS INITIAL.
          ls_header-canceled = 'NO'.
        ENDIF.

*----- Next KeyID -----
        lv_keyid += 1.

*----- Document Number -----
        ls_header-keyid  = lv_keyid.
        ls_header-docnum = |{ ls_header-fisyear }{ lv_keyid WIDTH = 4 PAD = '0' }|.

        APPEND VALUE #(
            %tky                      = ls_header-%tky
            fisyear                   = ls_header-fisyear
            keyid                     = ls_header-keyid
            docnum                    = ls_header-docnum
            canceled                  = ls_header-canceled
            local_created_by          = ls_header-local_created_by
            local_created_at          = ls_header-local_created_at
            %control-fisyear          = if_abap_behv=>mk-on
            %control-keyid            = if_abap_behv=>mk-on
            %control-docnum           = if_abap_behv=>mk-on
            %control-canceled         = if_abap_behv=>mk-on
            %control-local_created_by = if_abap_behv=>mk-on
            %control-local_created_at = if_abap_behv=>mk-on
        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
        ENTITY zi_gstr2breg_h
        UPDATE FIELDS (
          fisyear
          keyid
          docnum
          canceled
          local_created_by
          local_created_at )
        WITH lt_update.

    ENDIF.

  ENDMETHOD.

  METHOD checkcomb1.

    TYPES: BEGIN OF ty_latest,
             id       TYPE zi_gstr2breg_h-id,
             docnum   TYPE zi_gstr2breg_h-docnum,
             canceled TYPE zi_gstr2breg_h-canceled,
           END OF ty_latest.

    DATA: lt_exist  TYPE TABLE OF ty_latest,
          ls_latest TYPE ty_latest.

    READ ENTITIES OF zi_gstr2breg_h IN LOCAL MODE
      ENTITY zi_gstr2breg_h
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      CLEAR: lt_exist, ls_latest.

      SELECT id,
             docnum,
             canceled
      FROM zi_gstr2breg_h
      WHERE location = @ls_header-location
      AND fyear  = @ls_header-fyear
      AND fmonth = @ls_header-fmonth
      AND id     <> @ls_header-id
      INTO TABLE @lt_exist.

      IF sy-subrc = 0.

        SORT lt_exist BY docnum.
        READ TABLE lt_exist INTO ls_latest INDEX lines( lt_exist ).

        IF ls_latest-canceled <> 'YES'.

          APPEND VALUE #(
            %tky = ls_header-%tky
          ) TO failed-zi_gstr2breg_h.

          APPEND VALUE #(
            %tky        = ls_header-%tky
            %state_area = 'Validate_Head'
            %msg        = new_message_with_text(
                             severity = if_abap_behv_message=>severity-error
                             text     = |Duplicate Location, FY & Month already exists| )
          ) TO reported-zi_gstr2breg_h.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_gstr2breg_i DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gstr2breg_i RESULT result.

ENDCLASS.

CLASS lhc_zi_gstr2breg_i IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_gstr2breg_h DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_gstr2breg_h IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
