CLASS zcl_journal_post1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_JOURNAL_POST1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*
*    TYPES : BEGIN OF ty_post,
*              glaccountitem       TYPE c LENGTH 3,
*              supplier            TYPE c LENGTH 10,
*              businessplace       TYPE c LENGTH 4,
*              assignmentreference TYPE c LENGTH 20,
*              profitcenter        TYPE c LENGTH 4,
*              glaccount           TYPE c LENGTH 10,
*              specialglcode       TYPE c LENGTH 1,
*              journalentryamount  TYPE c LENGTH 20,
*              currencyrole        TYPE c LENGTH 5,
*              currency            TYPE c LENGTH 3,
*            END OF ty_post.
*
*
*    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
*    DATA: lt_je_deep  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*          lv_cid      TYPE abp_behv_cid,
*          lt_post     TYPE STANDARD TABLE OF ty_post,
*          lt_post_tbl TYPE STANDARD TABLE OF ty_post.
*
*    lt_post_tbl = VALUE #( ( glaccountitem = '001' supplier = 'EMP800' businessplace = '1000' assignmentreference = 'Test_SC' profitcenter = '1000' glaccount = '0012800010' specialglcode = 'F' journalentryamount = '-1000' )
*   ( glaccountitem = '001' supplier = 'EMP800' businessplace = '1000' assignmentreference = 'Test_SC' profitcenter = '1000' glaccount = '0012800010' specialglcode = 'F' journalentryamount = '-2000' )
*    ).
*
*
*
*
*
*    LOOP AT lt_post_tbl INTO DATA(ls_post_tbl).
*      APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
*      TRY.
*          lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
*        CATCH cx_uuid_error.
*          ASSERT 1 = 0.
*      ENDTRY.
*      <je_deep>-%cid = lv_cid.
*      <je_deep>-%param = VALUE #(
*      companycode = '1000'
*     documentreferenceid = 'BKPFF'
*      createdbyuser = sy-uname
*      businesstransactiontype = 'RFST'
*      accountingdocumenttype = 'KZ'
*      documentdate = sy-datlo
*      postingdate = sy-datlo
*      accountingdocumentheadertext = 'RAP rules'
*                          _apitems                    = VALUE #( (  glaccountlineitem      = ls_post_tbl-glaccountitem
*                                                                   supplier               = ls_post_tbl-supplier
*                                                                   businessplace          = ls_post_tbl-businessplace
*                                                                   assignmentreference    = ls_post_tbl-assignmentreference
*                                                                   profitcenter = ls_post_tbl-profitcenter
*                                                                   glaccount = ls_post_tbl-glaccount
*                                                                   specialglcode = ls_post_tbl-specialglcode
*                                                                   _currencyamount       = VALUE #( ( currencyrole            = '00'
*                                                                                                      journalentryitemamount = ls_post_tbl-journalentryamount
*                                                                                                      currency               = 'INR' ) ) ) )
*      ).
*
*
*      MODIFY ENTITIES OF i_journalentrytp
*      ENTITY journalentry
*      EXECUTE post FROM lt_je_deep
*      FAILED DATA(ls_failed_deep)
*      REPORTED DATA(ls_reported_deep)
*      MAPPED DATA(ls_mapped_deep).
*
*      IF ls_failed_deep IS NOT INITIAL.
*
*        LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
*          DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
*          ...
*        ENDLOOP.
*      ELSE.
*
*        COMMIT ENTITIES BEGIN
*        RESPONSE OF i_journalentrytp
*        FAILED DATA(lt_commit_failed)
*        REPORTED DATA(lt_commit_reported).
*        ...
*        COMMIT ENTITIES END.
*      ENDIF.
*    ENDLOOP.

    SELECT *
    FROM zi_vend_bank_itm
    INTO TABLE @DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).
      READ ENTITIES OF i_businesspartnertp_3 ENTITY businesspartner
      ALL FIELDS WITH VALUE #( (
      businesspartner = ls_item-supp
      ) ) RESULT DATA(partner).

      READ ENTITIES OF i_businesspartnertp_3 ENTITY businesspartner BY \_businesspartnerbank
      ALL FIELDS WITH VALUE #( (
       %tky = partner[ 1 ]-%tky
       ) )
       RESULT DATA(curr_bank).

      LOOP AT curr_bank ASSIGNING FIELD-SYMBOL(<new_bank>).
        <new_bank>-%is_draft = if_abap_behv=>mk-off.
        <new_bank>-bankaccount = ls_item-bankacc.
        <new_bank>-banknumber = ls_item-bankkey.

        MODIFY ENTITIES OF i_businesspartnertp_3 "i_businesspartnerbanktp_3
        ENTITY businesspartnerbank
       UPDATE FROM VALUE #( ( VALUE #(
        %data-bankaccount = <new_bank>-bankaccount
        %data-banknumber = <new_bank>-banknumber
        %control-bankaccount = cl_abap_behv=>flag_changed
        %control-banknumber = cl_abap_behv=>flag_changed
        %is_draft = if_abap_behv=>mk-off
        %tky = CORRESPONDING #( <new_bank>-%tky )
        ) ) ) REPORTED DATA(reported) FAILED DATA(failed).

        COMMIT ENTITIES BEGIN RESPONSE OF i_businesspartnertp_3
        FAILED DATA(failed_commit)
        REPORTED DATA(reported_commit).
        COMMIT ENTITIES END.

        WAIT UP TO 5 SECONDS.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
