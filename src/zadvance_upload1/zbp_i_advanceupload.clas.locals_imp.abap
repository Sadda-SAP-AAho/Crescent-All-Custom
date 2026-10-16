CLASS lhc_zi_advanceupload DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_advanceupload RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_advanceupload RESULT result.
    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION zi_advanceupload~uploadexceldata RESULT result.
    METHODS change_status FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_advanceupload~change_status.
    METHODS postadv FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_advanceupload~postadv.

ENDCLASS.

CLASS lhc_zi_advanceupload IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD uploadexceldata.
    TYPES: BEGIN OF ty_excel,
             companycode   TYPE string,
             documentdate  TYPE string,
             postingdate   TYPE string,
             text          TYPE string,
             reference     TYPE string,
             currency      TYPE string,
             exchangerate  TYPE string,
             vendorcode    TYPE string,
             splindicator  TYPE string,
             amount        TYPE string,
             valuedate     TYPE string,
             profitcenter  TYPE string,
             businessplace TYPE string,
             sectioncode   TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_advanceupload IN LOCAL MODE
         ENTITY zi_advanceupload
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

  METHOD change_status.
    TYPES: BEGIN OF ty_excel,
             item          TYPE zde_glitem,
             companycode   TYPE string,
             documentdate  TYPE string,
             postingdate   TYPE string,
             text          TYPE string,
             reference     TYPE string,
             currency      TYPE string,
             exchangerate  TYPE string,
             vendorcode    TYPE string,
             amount        TYPE string,
             valuedate     TYPE string,
             profitcenter  TYPE string,
             businessplace TYPE string,
             sectioncode   TYPE string,
           END OF ty_excel,
           tt_excel TYPE STANDARD TABLE OF ty_excel.

    DATA lt_excel TYPE tt_excel.

    READ ENTITIES OF zi_advanceupload IN LOCAL MODE
         ENTITY zi_advanceupload
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(lt_head).

    READ ENTITIES OF zi_advanceupload IN LOCAL MODE
ENTITY zi_advanceuploaditm
ALL FIELDS
WITH CORRESPONDING #( keys )
RESULT FINAL(lt_item)
" TODO: variable is assigned but never used (ABAP cleaner)
FAILED FINAL(lt_item_failed).

    IF lt_item IS INITIAL.


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

      LOOP AT lt_excel INTO FINAL(ls_excel).
        TRY.
            DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          CATCH cx_uuid_error.
            " handle exception
        ENDTRY.

        CONCATENATE ls_excel-postingdate+6(4) ls_excel-postingdate+3(2) ls_excel-postingdate+0(2) INTO DATA(posting_date).
        CONCATENATE  ls_excel-documentdate+6(4) ls_excel-documentdate+3(2) ls_excel-documentdate+0(2) INTO DATA(document_date).
        CONCATENATE  ls_excel-valuedate+6(4) ls_excel-valuedate+3(2) ls_excel-valuedate+0(2) INTO DATA(value_date).

        MODIFY ENTITIES OF zi_advanceupload IN LOCAL MODE
               ENTITY zi_advanceupload
               CREATE BY \_item
               FROM VALUE #( ( id      = ls_head-id
                               %target = VALUE #( ( %cid                     = lv_item
                                                    item                     = ls_excel-item
                                                    companycode              = ls_excel-companycode
                                                    documentdate             = document_date
                                                   postingdate               = posting_date
                                                    text                     = ls_excel-text
                                                    reference                = ls_excel-reference
                                                    currency                 = ls_excel-currency
                                                    exchangerate             = ls_excel-exchangerate
                                                    vendorcode               = ls_excel-vendorcode
                                                    splindicator             = 'F'
                                                    amount                   = ls_excel-amount
                                                    glaccount                = '0012800010'
                                                    valuedate                = value_date
                                                    profitcenter             = ls_excel-profitcenter
                                                    businessplace            = ls_excel-businessplace
                                                    sectioncode              = ls_excel-sectioncode
                                                    %control-item            = if_abap_behv=>mk-on
                                                    %control-companycode     = if_abap_behv=>mk-on
                                                    %control-documentdate    = if_abap_behv=>mk-on
                                                    %control-postingdate     = if_abap_behv=>mk-on
                                                    %control-text            = if_abap_behv=>mk-on
                                                    %control-reference       = if_abap_behv=>mk-on
                                                    %control-currency        = if_abap_behv=>mk-on
                                                    %control-exchangerate    = if_abap_behv=>mk-on
                                                    %control-vendorcode      = if_abap_behv=>mk-on
                                                    %control-splindicator    = if_abap_behv=>mk-on
                                                    %control-amount          = if_abap_behv=>mk-on
                                                    %control-glaccount       = if_abap_behv=>mk-on
                                                    %control-valuedate       = if_abap_behv=>mk-on
                                                    %control-profitcenter    = if_abap_behv=>mk-on
                                                    %control-businessplace   = if_abap_behv=>mk-on
                                                    %control-sectioncode     = if_abap_behv=>mk-on ) ) ) )
               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(ls_mapped)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(ls_failed)
               " TODO: variable is assigned but never used (ABAP cleaner)
               REPORTED FINAL(ls_reported).

        CLEAR : document_date , posting_date , value_date .

      ENDLOOP.

      MODIFY ENTITIES OF zi_advanceupload IN LOCAL MODE
ENTITY zi_advanceupload
UPDATE
FIELDS ( localcreatedby ) "
WITH VALUE #(
        ( %tky  = ls_head-%tky
          localcreatedby = sy-uname ) ).


    ENDIF.


  ENDMETHOD.

  METHOD postadv.

    TYPES : BEGIN OF ty_post,
              glaccountitem       TYPE c LENGTH 3,
              supplier            TYPE c LENGTH 10,
              businessplace       TYPE c LENGTH 4,
              assignmentreference TYPE c LENGTH 20,
              profitcenter        TYPE c LENGTH 4,
              glaccount           TYPE c LENGTH 10,
              specialglcode       TYPE c LENGTH 1,
              journalentryamount  TYPE c LENGTH 20,
              currencyrole        TYPE c LENGTH 5,
              currency            TYPE c LENGTH 3,
              text                TYPE c LENGTH 50,
            END OF ty_post.


    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    DATA: lt_je_deep  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lt_je_val   TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate,
          lv_cid      TYPE abp_behv_cid,
          lt_post     TYPE STANDARD TABLE OF ty_post,
          lv_text     TYPE char128,
          lt_post_tbl TYPE STANDARD TABLE OF ty_post,
          ls_post_tbl TYPE ty_post.

    READ ENTITIES OF zi_advanceupload IN LOCAL MODE
ENTITY zi_advanceupload
ALL FIELDS WITH
CORRESPONDING #( keys )
RESULT FINAL(lt_head).

    READ ENTITY zi_advanceupload
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_item).

    DATA(ls_header) = VALUE #( lt_head[ 1 ] OPTIONAL ).


*    lt_post_tbl = VALUE #( ( glaccountitem = '001' supplier = 'EMP800' businessplace = '1000' assignmentreference = 'Test_SC' profitcenter = '1000' glaccount = '0012800010' specialglcode = 'F' journalentryamount = '-1000' )
*   ( glaccountitem = '001' supplier = 'EMP800' businessplace = '1000' assignmentreference = 'Test_SC' profitcenter = '1000' glaccount = '0012800010' specialglcode = 'F' journalentryamount = '-2000' )
*    ).
    CLEAR : lt_post_tbl .
    LOOP AT lt_item INTO DATA(ls_excel1).
      ls_post_tbl-glaccountitem = ls_excel1-item.
      ls_post_tbl-supplier = ls_excel1-vendorcode.
      ls_post_tbl-businessplace = ls_excel1-businessplace.
      ls_post_tbl-assignmentreference = ls_excel1-reference.
      ls_post_tbl-profitcenter = ls_excel1-profitcenter.
      ls_post_tbl-glaccount = ls_excel1-glaccount.
      ls_post_tbl-specialglcode = ls_excel1-splindicator.
      ls_post_tbl-journalentryamount = ls_excel1-amount.
      ls_post_tbl-currency = ls_excel1-currency.
      ls_post_tbl-text = ls_excel1-text.
      APPEND ls_post_tbl TO lt_post_tbl.
      CLEAR : ls_post_tbl.
    ENDLOOP.






    LOOP AT lt_post_tbl INTO ls_post_tbl.
      APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
      TRY.
          lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
        CATCH cx_uuid_error.
          ASSERT 1 = 0.
      ENDTRY.
      <je_deep>-%cid = lv_cid.
      <je_deep>-%param = VALUE #(
      companycode = '1000'
     documentreferenceid = 'BKPFF'
      createdbyuser = sy-uname
      businesstransactiontype = 'RFST'
      accountingdocumenttype = 'KZ'
      documentdate = sy-datlo
      postingdate = sy-datlo
      accountingdocumentheadertext = ls_post_tbl-text
                          _apitems                    = VALUE #( (  glaccountlineitem      = ls_post_tbl-glaccountitem
                                                                   supplier               = ls_post_tbl-supplier
*                                                                   businessplace          = ls_post_tbl-businessplace
                                                                   assignmentreference    = ls_post_tbl-assignmentreference
                                                                   profitcenter = ls_post_tbl-profitcenter
                                                                   glaccount = '0012800010'
                                                                   specialglcode = 'F'
                                                                   _currencyamount       = VALUE #( ( currencyrole            = '00'
                                                                                                      journalentryitemamount = ls_post_tbl-journalentryamount * -1
                                                                                                      currency               = ls_post_tbl-currency ) ) ) )
      ).

      lt_je_val = CORRESPONDING #( lt_je_deep ).

      READ ENTITIES OF i_journalentrytp
           ENTITY journalentry
           EXECUTE validate FROM lt_je_val
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(lt_check_result)
           FAILED FINAL(ls_failed_deep01)
           REPORTED FINAL(ls_reported_deep01).

      IF ls_failed_deep01 IS NOT INITIAL.

        LOOP AT ls_reported_deep01-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep01>).
          FINAL(lv_result01) = <ls_reported_deep01>-%msg->if_message~get_text( ).
          IF sy-tabix = 1.
            lv_text = lv_result01.
          ELSE.
            lv_text = |{ lv_text } / { lv_result01 }|.
          ENDIF.
        ENDLOOP.


      ELSE.





      ENDIF.
    ENDLOOP.
    IF  ls_failed_deep01 IS INITIAL.
      MODIFY ENTITIES OF i_journalentrytp
         PRIVILEGED
         ENTITY journalentry
         EXECUTE post FROM lt_je_deep
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(ls_failed_deep)
         " TODO: variable is assigned but never used (ABAP cleaner)
         REPORTED FINAL(ls_reported_deep)
         " TODO: variable is assigned but never used (ABAP cleaner)
         MAPPED FINAL(ls_mapped_deep).

      IF ls_failed_deep IS INITIAL.
        MODIFY ENTITIES OF zi_advanceupload IN LOCAL MODE
        ENTITY zi_advanceupload
        UPDATE
        FIELDS ( filestatus ) "
        WITH VALUE #(
                ( %tky  = ls_header-%tky
                  status = '1' ) ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
