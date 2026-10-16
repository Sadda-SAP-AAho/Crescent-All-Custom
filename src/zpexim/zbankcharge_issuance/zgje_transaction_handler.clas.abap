CLASS zgje_transaction_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA: go_instance TYPE REF TO zgje_transaction_handler.

    CLASS-METHODS: get_instance RETURNING VALUE(result) TYPE REF TO zgje_transaction_handler.
    CLASS-METHODS: get_commit RETURNING VALUE(result) TYPE char13.

    TYPES: BEGIN OF ty_temp_key,
             cid           TYPE abp_behv_pid,
             pid           TYPE abp_behv_pid,
             transactionid TYPE char25,
             utr           TYPE char40,
           END OF ty_temp_key,

           tt_temp_key TYPE STANDARD TABLE OF ty_temp_key WITH DEFAULT KEY,
           BEGIN OF ty_final_key,
             transactionid TYPE char25,
             utr           TYPE char40,
*             remittername      TYPE ZCHAR50,
*             fromaccountnumber TYPE ZCHAR50,
*             frombankname      TYPE char70,
*             remitterifsc      TYPE char20,
*             virtualaccount    TYPE char30,
*             amount            TYPE dmbtr,
*             mmid              TYPE ZCHAR50,
*             valuedate         TYPE dats,
*             transfermode      TYPE char10,
*             creditdate        TYPE dats,
*             credittime        TYPE sy-uzeit,
*             chequeno          TYPE ZCHAR50,
*             narration         TYPE char30,
             accountingdoc TYPE char10,
             companycode   TYPE char4,
             fiscalyear    TYPE char4,
             waers         TYPE waers,
*             status            TYPE char30,
*             createdon         TYPE  dats,
*             createdat         TYPE sy-uzeit,
*             error_count       TYPE   numc5,
*             mailsent          TYPE char1,
*             mailsenton        TYPE dats,
*             mailsentat        TYPE sy-uzeit,
*             post              TYPE char1,
           END OF ty_final_key,

           tt_final_key TYPE STANDARD TABLE OF ty_final_key WITH DEFAULT KEY.
*           tt_header    TYPE STANDARD TABLE OF zdt_trans_api WITH DEFAULT KEY.


    DATA: temp_key     TYPE tt_temp_key.


    METHODS:
      set_temp_key
        IMPORTING it_temp_key TYPE tt_temp_key,
      convert_temp_to_final
        RETURNING VALUE(result) TYPE tt_final_key,
      additional_save IMPORTING it_create TYPE tt_temp_key,
      clean_up.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZGJE_TRANSACTION_HANDLER IMPLEMENTATION.


  METHOD additional_save.

*    DATA: lt_create TYPE TABLE OF zdt_trans_api.
*
*    data : ls_create like line of lt_create.
*    data: lt_create_temp TYPE TABLE OF zdt_trans_api.

    DATA(lt_je_key) = convert_temp_to_final(  ).


*    LOOP AT it_create ASSIGNING FIELD-SYMBOL(<ls_create>).
*      READ TABLE lt_je_key INTO DATA(ls_je_key) WITH KEY transactionid = <ls_create>-transactionid
*                                                         utr = <ls_create>-utr.
*      IF sy-subrc = 0.
*      MOVE-CORRESPONDING <ls_create> to ls_create.
*        ls_create-accountingdoc =    ls_je_key-accountingdoc.
*        ls_create-fiscalyear = ls_je_key-fiscalyear.
*        ls_create-companycode = ls_je_key-companycode.
*        ls_create-status = 'Processed'.
*        APPEND ls_create to lt_create_temp.
*      ENDIF.
*    ENDLOOP.

*    IF lt_create_temp IS NOT INITIAL.
*      MODIFY zdt_trans_api FROM TABLE @lt_create_temp.
*    ENDIF.


  ENDMETHOD.


  METHOD clean_up.
    CLEAR temp_key.
  ENDMETHOD.


  METHOD convert_temp_to_final.
    DATA: ls_final_key TYPE ty_final_key.
    IF temp_key IS NOT INITIAL.
      LOOP AT temp_key INTO DATA(ls_temp_key).
        CONVERT KEY OF i_journalentrytp
          FROM ls_temp_key-pid
          TO FINAL(lv_root_key).

        ls_final_key-transactionid = ls_temp_key-transactionid.
        ls_final_key-utr = ls_temp_key-utr.
        ls_final_key-companycode  = lv_root_key-companycode.
        ls_final_key-accountingdoc = lv_root_key-accountingdocument.
        ls_final_key-fiscalyear = lv_root_key-fiscalyear.


        APPEND ls_final_key TO result.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_commit.

*    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' STARTING NEW TASK  .
*    COMMIT ENTITIES BEGIN
*    RESPONSE OF i_journalentrytp
*    FAILED DATA(lt_commit_failed)
*    REPORTED DATA(lt_commit_reported).
*    ...
*    COMMIT ENTITIES END.


  ENDMETHOD.


  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    result = go_instance.
  ENDMETHOD.


  METHOD set_temp_key.
    temp_key = it_temp_key.
  ENDMETHOD.
ENDCLASS.
