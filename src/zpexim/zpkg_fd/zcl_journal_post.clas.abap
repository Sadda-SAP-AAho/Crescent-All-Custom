CLASS zcl_journal_post DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_JOURNAL_POST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid = lv_cid.
    <je_deep>-%param = VALUE #(
    companycode = '1000'
   documentreferenceid = 'BKPFF'
    createdbyuser = sy-uname
    businesstransactiontype = 'RFST'
    accountingdocumenttype = 'KZ'
    documentdate = sy-datlo
    postingdate = sy-datlo
    accountingdocumentheadertext = 'RAP rules'
                        _apitems                    = VALUE #( (  glaccountlineitem      = '001'
                                                                 supplier               = 'EMP800'
                                                                 businessplace          = '1000'
                                                                 assignmentreference    = 'TEST NOted Items'
                                                                 profitcenter = '1000'
                                                                 glaccount = '0012800010'
                                                                 specialglcode = 'F'
                                                                 _currencyamount       = VALUE #( ( currencyrole            = '00'
                                                                                                    journalentryitemamount = '-1000'
                                                                                                    currency               = 'INR' ) ) ) )
    ).

    MODIFY ENTITIES OF i_journalentrytp
    ENTITY journalentry
    EXECUTE post FROM lt_je_deep
    FAILED DATA(ls_failed_deep)
    REPORTED DATA(ls_reported_deep)
    MAPPED DATA(ls_mapped_deep).

    IF ls_failed_deep IS NOT INITIAL.

      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
        ...
      ENDLOOP.
    ELSE.

      COMMIT ENTITIES BEGIN
      RESPONSE OF i_journalentrytp
      FAILED DATA(lt_commit_failed)
      REPORTED DATA(lt_commit_reported).
      ...
      COMMIT ENTITIES END.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
