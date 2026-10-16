CLASS lsc_zi_matinfo_file DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_matinfo_file IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_matinfo_file IS NOT INITIAL.

      DATA(lt_head) = update-zi_matinfo_file.

      IF lt_head[ 1 ]-status = '3'.

        READ TABLE lt_head INTO DATA(ls_head) INDEX 1.

        SELECT *
          FROM zdt_matitem_file
          WHERE id = @ls_head-id
          INTO TABLE @DATA(lt_upd).

        DATA: lv_id   TYPE zdt_pp_matinffld-id,
              ls_item TYPE zdt_pp_matinffld,
              lt_item TYPE STANDARD TABLE OF zdt_pp_matinffld,
              lv_date TYPE datn,
              lv_time TYPE timn.

        LOOP AT lt_upd INTO DATA(ls_upd) WHERE status = '2'.

          TRY.
              lv_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
          ENDTRY.

          MOVE-CORRESPONDING ls_upd TO ls_item.

*       If ID needs to be newly generated, assign it explicitly
          ls_item-id = lv_id.

          TRY.
              CONVERT DATE cl_abap_context_info=>get_system_date( )
                      TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP DATA(lv_timestamp)
                TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
            CATCH cx_abap_context_info_error.
          ENDTRY.

          CONVERT TIME STAMP lv_timestamp
            TIME ZONE 'INDIA'
            INTO DATE lv_date TIME lv_time.

          ls_item-lastchngedt = lv_date.
          ls_item-lastchnngtm = lv_time.

          APPEND ls_item TO lt_item.

          CLEAR: lv_id,
                 ls_item,
                 lv_date,
                 lv_time.

        ENDLOOP.

        IF lt_item IS NOT INITIAL.
          MODIFY zdt_pp_matinffld FROM TABLE @lt_item.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_matinfo_file DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_matinfo_file RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_matinfo_file RESULT result.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION zi_matinfo_file~uploadexceldata RESULT result.

    METHODS valid FOR MODIFY
      IMPORTING keys FOR ACTION zi_matinfo_file~valid RESULT result.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_matinfo_file~upd RESULT result.


    METHODS fields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_matinfo_file~fields.

    METHODS change_status FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_matinfo_file~change_status.

    METHODS validate_fields FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_matinfo_file~validate_fields.

ENDCLASS.

CLASS lhc_zi_matinfo_file IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_matinfo_file IN LOCAL MODE
           ENTITY zi_matinfo_file
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_header)
           FAILED failed.

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    SELECT SINGLE *
        FROM zmm_matinfo_file
        WHERE id = @ls_header-id
        INTO @DATA(ls_zpp_serial_table).

    READ ENTITY zi_matinfo_file
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
             product         TYPE string,
             productdesc     TYPE string,
             qtyperbox       TYPE string,
             subcode         TYPE string,
             pcspack         TYPE string,
             potpat          TYPE string,
             sqmtr           TYPE string,
             matcrawt        TYPE string,
             machloss        TYPE string,
             qtypalpcdbox    TYPE string,
             typeofmould     TYPE string,
             prodcapcday     TYPE string,
             qtyboltunitcons TYPE string,
             calibdate       TYPE string,
             rejpercntg      TYPE string,
             moc             TYPE string,
             cft             TYPE string,
             pltpcdboxsize   TYPE string,
             boltsize        TYPE string,
             consbase        TYPE string,
             constdi         TYPE string,
             constci         TYPE string,
             constbag1       TYPE string,
             constbag2       TYPE string,
             constbaroda     TYPE string,
             constvackul     TYPE string,
             micr            TYPE string,
             cuscode         TYPE string,
             noofptn         TYPE string,
             ptnirs          TYPE string,
             ptnapp          TYPE string,
             pilotprdapp     TYPE string,
             sqmtr1          TYPE string,
             sqmtr2          TYPE string,
             sqmtr3          TYPE string,
             chillwt         TYPE string,
             jigf1           TYPE string,
             jigf2           TYPE string,
             castcode1       TYPE string,
             castcode2       TYPE string,
             castcode3       TYPE string,
             partno          TYPE string,
             drawno          TYPE string,
             artno           TYPE string,
             mldlinspd       TYPE string,
             matlngtxt       TYPE string,
             cusmat          TYPE string,
             paintinfo       TYPE string,
             coreinfo        TYPE string,
             steel_unit_wt   TYPE string,
             packinstr       TYPE string,

           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_matinfo_file IN LOCAL MODE
         ENTITY zi_matinfo_file
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
    MODIFY ENTITIES OF zi_matinfo_file IN LOCAL MODE
             ENTITY zi_matinfo_file
             UPDATE FROM VALUE #( FOR key IN keys
                                  ( status          = '0'
                                    %control-status = if_abap_behv=>mk-on ) ).

    IF keys[ 1 ]-%is_draft = '01'.
      MODIFY ENTITIES OF zi_matinfo_file IN LOCAL MODE
             ENTITY zi_matinfo_file
             EXECUTE uploadexceldata
             FROM CORRESPONDING #( keys ).
    ENDIF.
  ENDMETHOD.

  METHOD change_status.
    TYPES: BEGIN OF ty_excel,
             product         TYPE string,
             productdesc     TYPE string,
             qtyperbox       TYPE string,
             subcode         TYPE string,
             pcspack         TYPE string,
             potpat          TYPE string,
             sqmtr           TYPE string,
             matcrawt        TYPE string,
             machloss        TYPE string,
             qtypalpcdbox    TYPE string,
             typeofmould     TYPE string,
             prodcapcday     TYPE string,
             qtyboltunitcons TYPE string,
             calibdate       TYPE string,
             rejpercntg      TYPE string,
             moc             TYPE string,
             cft             TYPE string,
             pltpcdboxsize   TYPE string,
             boltsize        TYPE string,
             consbase        TYPE string,
             constdi         TYPE string,
             constci         TYPE string,
             constbag1       TYPE string,
             constbag2       TYPE string,
             constbaroda     TYPE string,
             constvackul     TYPE string,
             micr            TYPE string,
             cuscode         TYPE string,
             noofptn         TYPE string,
             ptnirs          TYPE string,
             ptnapp          TYPE string,
             pilotprdapp     TYPE string,
             sqmtr1          TYPE string,
             sqmtr2          TYPE string,
             sqmtr3          TYPE string,
             chillwt         TYPE string,
             jigf1           TYPE string,
             jigf2           TYPE string,
             castcode1       TYPE string,
             castcode2       TYPE string,
             castcode3       TYPE string,
             partno          TYPE string,
             drawno          TYPE string,
             artno           TYPE string,
             mldlinspd       TYPE string,
             matlngtxt       TYPE string,
             cusmat          TYPE string,
             paintinfo       TYPE string,
             coreinfo        TYPE string,
             steel_unit_wt   TYPE string,
             packinstr       TYPE string,

           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    DATA : lv_cdate TYPE sydate.

    READ ENTITIES OF zi_matinfo_file IN LOCAL MODE
         ENTITY zi_matinfo_file
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
      LOOP AT lt_excel INTO FINAL(ls_excel) WHERE product IS NOT INITIAL.

        SELECT SINGLE productdescription FROM i_productdescription WHERE product = @ls_excel-product AND language = 'E'
        INTO @DATA(lv_itemdesc).

        TRY.
            CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                    INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
          CATCH cx_abap_context_info_error.
        ENDTRY.

        IF ls_excel-calibdate IS NOT INITIAL.
          lv_cdate = ls_excel-calibdate+6(4) && ls_excel-calibdate+3(2) && ls_excel-calibdate+0(2).
        ENDIF.


        MODIFY ENTITIES OF zi_matinfo_file IN LOCAL MODE
               ENTITY zi_matinfo_file
               CREATE BY \_item
               FROM VALUE #( ( id      = ls_head-id
                               %target = VALUE #( ( %cid                     = ls_excel-product

                                                    product                  = ls_excel-product
                                                    productdesc              = lv_itemdesc "ls_excel-productdesc
                                                    qtyperbox                = ls_excel-qtyperbox
                                                    subcode                  = ls_excel-subcode
                                                    pcspack                  = ls_excel-pcspack
                                                    potpat                   = ls_excel-potpat
                                                    sqmtr                    = ls_excel-sqmtr
                                                    matcrawt                 = ls_excel-matcrawt
                                                    machloss                 = ls_excel-machloss
                                                    qtypalpcdbox             = ls_excel-qtypalpcdbox
                                                    typeofmould              = ls_excel-typeofmould
                                                    prodcapcday              = ls_excel-prodcapcday
                                                    qtyboltunitcons          = ls_excel-qtyboltunitcons
                                                    calibdate                = lv_cdate "ls_excel-calibdate
                                                    rejpercntg               = ls_excel-rejpercntg
                                                    moc                      = ls_excel-moc
                                                    cft                      = ls_excel-cft
                                                    pltpcdboxsize            = ls_excel-pltpcdboxsize
                                                    boltsize                 = ls_excel-boltsize
                                                    consbase                 = ls_excel-consbase
                                                    constdi                  = ls_excel-constdi
                                                    constci                  = ls_excel-constci
                                                    constbag1                = ls_excel-constbag1
                                                    constbag2                = ls_excel-constbag2
                                                    constbaroda              = ls_excel-constbaroda
                                                    constvackul              = ls_excel-constvackul
                                                    micr                     = ls_excel-micr
                                                    cuscode                  = ls_excel-cuscode
                                                    noofptn                  = ls_excel-noofptn
                                                    ptnirs                   = ls_excel-ptnirs
                                                    ptnapp                   = ls_excel-ptnapp
                                                    pilotprdapp              = ls_excel-pilotprdapp
                                                    sqmtr1                   = ls_excel-sqmtr1
                                                    sqmtr2                   = ls_excel-sqmtr2
                                                    sqmtr3                   = ls_excel-sqmtr3
                                                    chillwt                  = ls_excel-chillwt
                                                    jigf1                    = ls_excel-jigf1
                                                    jigf2                    = ls_excel-jigf2
                                                    castcode1                = ls_excel-castcode1
                                                    castcode2                = ls_excel-castcode2
                                                    castcode3                = ls_excel-castcode3
                                                    partno                   = ls_excel-partno
                                                    drawno                   = ls_excel-drawno
                                                    artno                    = ls_excel-artno
                                                    mldlinspd                = ls_excel-mldlinspd
                                                    matlngtxt                = ls_excel-matlngtxt
                                                    cusmat                   = ls_excel-cusmat
                                                    paintinfo                = ls_excel-paintinfo
                                                    coreinfo                 = ls_excel-coreinfo
                                                    steel_unit_wt            = ls_excel-steel_unit_wt
                                                    packinstr                = ls_excel-packinstr
                                                    status                   = '1'


                                                    %control-product         = if_abap_behv=>mk-on
                                                    %control-productdesc     = if_abap_behv=>mk-on
                                                    %control-qtyperbox       = if_abap_behv=>mk-on
                                                    %control-subcode         = if_abap_behv=>mk-on
                                                    %control-pcspack         = if_abap_behv=>mk-on
                                                    %control-potpat          = if_abap_behv=>mk-on
                                                    %control-matcrawt        = if_abap_behv=>mk-on
                                                    %control-machloss        = if_abap_behv=>mk-on
                                                    %control-qtypalpcdbox    = if_abap_behv=>mk-on
                                                    %control-sqmtr           = if_abap_behv=>mk-on
                                                    %control-typeofmould     = if_abap_behv=>mk-on
                                                    %control-prodcapcday     = if_abap_behv=>mk-on
                                                    %control-qtyboltunitcons = if_abap_behv=>mk-on
                                                    %control-calibdate       = if_abap_behv=>mk-on
                                                    %control-rejpercntg      = if_abap_behv=>mk-on
                                                    %control-moc             = if_abap_behv=>mk-on
                                                    %control-cft             = if_abap_behv=>mk-on
                                                    %control-pltpcdboxsize   = if_abap_behv=>mk-on
                                                    %control-boltsize        = if_abap_behv=>mk-on
                                                    %control-consbase        = if_abap_behv=>mk-on
                                                    %control-constdi         = if_abap_behv=>mk-on
                                                    %control-constci         = if_abap_behv=>mk-on
                                                    %control-constbag1       = if_abap_behv=>mk-on
                                                    %control-constbag2       = if_abap_behv=>mk-on
                                                    %control-constbaroda     = if_abap_behv=>mk-on
                                                    %control-constvackul     = if_abap_behv=>mk-on
                                                    %control-micr            = if_abap_behv=>mk-on
                                                    %control-noofptn         = if_abap_behv=>mk-on
                                                    %control-ptnirs          = if_abap_behv=>mk-on
                                                    %control-ptnapp          = if_abap_behv=>mk-on
                                                    %control-cuscode         = if_abap_behv=>mk-on
                                                    %control-pilotprdapp     = if_abap_behv=>mk-on
                                                    %control-sqmtr1          = if_abap_behv=>mk-on
                                                    %control-sqmtr2          = if_abap_behv=>mk-on
                                                    %control-sqmtr3          = if_abap_behv=>mk-on
                                                    %control-chillwt         = if_abap_behv=>mk-on
                                                    %control-jigf1           = if_abap_behv=>mk-on
                                                    %control-jigf2           = if_abap_behv=>mk-on
                                                    %control-castcode1       = if_abap_behv=>mk-on
                                                    %control-castcode2       = if_abap_behv=>mk-on
                                                    %control-castcode3       = if_abap_behv=>mk-on
                                                    %control-partno          = if_abap_behv=>mk-on
                                                    %control-drawno          = if_abap_behv=>mk-on
                                                    %control-artno           = if_abap_behv=>mk-on
                                                    %control-mldlinspd       = if_abap_behv=>mk-on
                                                    %control-matlngtxt       = if_abap_behv=>mk-on
                                                    %control-cusmat          = if_abap_behv=>mk-on
                                                    %control-paintinfo       = if_abap_behv=>mk-on
                                                    %control-coreinfo        = if_abap_behv=>mk-on
                                                    %control-steel_unit_wt   = if_abap_behv=>mk-on
                                                    %control-packinstr       = if_abap_behv=>mk-on
                                                    %control-status          = if_abap_behv=>mk-on ) ) ) )
               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(ls_mapped)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(ls_failed)
               " TODO: variable is assigned but never used (ABAP cleaner)
               REPORTED FINAL(ls_reported).

        CLEAR : lv_itemdesc, lv_cdate.
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

          MODIFY ENTITIES OF zi_matinfo_file IN LOCAL MODE
                 ENTITY zi_matinfo_file
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
             product         TYPE string,
             productdesc     TYPE string,
             qtyperbox       TYPE string,
             subcode         TYPE string,
             pcspack         TYPE string,
             potpat          TYPE string,
             sqmtr           TYPE string,
             matcrawt        TYPE string,
             machloss        TYPE string,
             qtypalpcdbox    TYPE string,
             typeofmould     TYPE string,
             prodcapcday     TYPE string,
             qtyboltunitcons TYPE string,
             calibdate       TYPE string,
             rejpercntg      TYPE string,
             moc             TYPE string,
             cft             TYPE string,
             pltpcdboxsize   TYPE string,
             boltsize        TYPE string,
             consbase        TYPE string,
             constdi         TYPE string,
             constci         TYPE string,
             constbag1       TYPE string,
             constbag2       TYPE string,
             constbaroda     TYPE string,
             constvackul     TYPE string,
             micr            TYPE string,
             cuscode         TYPE string,
             noofptn         TYPE string,
             ptnirs          TYPE string,
             ptnapp          TYPE string,
             pilotprdapp     TYPE string,
             sqmtr1          TYPE string,
             sqmtr2          TYPE string,
             sqmtr3          TYPE string,
             chillwt         TYPE string,
             jigf1           TYPE string,
             jigf2           TYPE string,
             castcode1       TYPE string,
             castcode2       TYPE string,
             castcode3       TYPE string,
             partno          TYPE string,
             drawno          TYPE string,
             artno           TYPE string,
             mldlinspd       TYPE string,
             matlngtxt       TYPE string,
             cusmat          TYPE string,
             paintinfo       TYPE string,
             coreinfo        TYPE string,
             steel_unit_wt   TYPE string,
             packinstr       TYPE string,

           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.
    DATA lv_msg   TYPE char100.

    READ ENTITIES OF zi_matinfo_file IN LOCAL MODE
         ENTITY zi_matinfo_file
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
        APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_matinfo_file.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_matinfo_file.

      ELSE.
        DELETE lt_excel INDEX 1.

        IF lt_excel IS INITIAL.
          lv_msg = |no data is present in file|.
          APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_matinfo_file.

          APPEND VALUE #( %tky        = ls_head-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_matinfo_file.

        ELSE.
          SORT lt_excel BY product.
          DATA(lv_line) = lines( lt_excel ).

          DATA(lt_excel_1) = lt_excel[].
          SORT lt_excel_1 BY product.
          DELETE ADJACENT DUPLICATES FROM lt_excel_1 COMPARING product.
          DATA(lv_line_1) = lines( lt_excel ).
          IF lv_line <> lv_line_1.
            lv_msg = |Please remove duplicate material frpm file|.
            APPEND VALUE #( %tky = ls_head-%tky ) TO failed-zi_matinfo_file.

            APPEND VALUE #( %tky        = ls_head-%tky
                            %state_area = 'Validate_Header'
                            %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = lv_msg ) )
            TO reported-zi_matinfo_file.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD valid.
    DATA : lv_msg TYPE char100.

    READ ENTITIES OF zi_matinfo_file IN LOCAL MODE
               ENTITY zi_matinfo_file
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_matinfo_file
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).

    SELECT SINGLE * FROM zdr_matinfo_file WHERE id = @gfs_header-id INTO @DATA(ls_check).
    IF ls_check IS NOT INITIAL.
      lv_msg = |Please save the data and then click on Validate button|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_matinfo_file.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_matinfo_file.
    ELSE.
      LOOP AT item INTO DATA(ls_item).
        SELECT SINGLE * FROM i_product WHERE product = @ls_item-product
        INTO @DATA(ls_pro).
        IF ls_pro IS INITIAL.
          ls_item-status = '3'.
          ls_item-msg = 'Product not found'.
        ELSE.

        " Check Already Maintained
          SELECT SINGLE * FROM zdt_pp_matinffld WHERE product = @ls_item-product
          INTO @DATA(ls_mat).
          IF ls_mat IS NOT INITIAL.
            ls_item-status = '3'.
            ls_item-msg = 'Product already maintained'.
          ELSE.
            ls_item-status = '2'.
            ls_item-msg = 'Validation Successful'.
          ENDIF.
        ENDIF.
        MODIFY ENTITIES OF zi_matinfo_file IN LOCAL MODE
              ENTITY zi_matitem_file
              UPDATE FIELDS ( status msg )
              WITH VALUE #( FOR key IN keys
                          (  %tky = ls_item-%tky
                             status = ls_item-status
                             msg = ls_item-msg ) ).


        CLEAR : ls_pro, ls_mat, ls_item.
*
      ENDLOOP.

      MODIFY ENTITIES OF zi_matinfo_file IN LOCAL MODE
              ENTITY zi_matinfo_file
              UPDATE FIELDS ( status )
              WITH VALUE #( FOR key IN keys
                          (  %tky = gfs_header-%tky
                             status = '2' ) ).
    ENDIF.

    READ ENTITIES OF zi_matinfo_file IN LOCAL MODE
           ENTITY zi_matinfo_file
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

  METHOD upd.

    READ ENTITIES OF zi_matinfo_file IN LOCAL MODE
                 ENTITY zi_matinfo_file
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    MODIFY ENTITIES OF zi_matinfo_file IN LOCAL MODE
                ENTITY zi_matinfo_file
                UPDATE FIELDS ( post status )
                WITH VALUE #( FOR key IN keys
                            (  %tky = gfs_header-%tky
                               post   = 'X'
                               status = '3' ) ).


    READ ENTITIES OF zi_matinfo_file IN LOCAL MODE
           ENTITY zi_matinfo_file
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_matitem_file DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_matitem_file RESULT result.

ENDCLASS.

CLASS lhc_zi_matitem_file IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.
