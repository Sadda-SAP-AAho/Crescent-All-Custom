CLASS zcl_fiwtin_doc_modify DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_fiwtin_doc_modify .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FIWTIN_DOC_MODIFY IMPLEMENTATION.


  METHOD if_fiwtin_doc_modify~modify_acctab.
  IF sy-tcode = 'J1INJV'.
*      LOOP AT ct_accit ASSIGNING FIELD-SYMBOL(<fs_accit>).
*        IF <fs_accit>-rebzg IS NOT INITIAL.
*          SELECT SINGLE profitcenter FROM i_operationalacctgdocitem
*          WHERE companycode = @<fs_accit>-bukrs AND accountingdocument = @<fs_accit>-rebzg
*            AND fiscalyear = @<fs_accit>-rebzj AND accountingdocumentitemtype = 'W' AND profitcenter IS NOT INITIAL
*          INTO @<fs_accit>-prctr.
*        ENDIF.
*      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD if_fiwtin_doc_modify~validate_authorization.
  ENDMETHOD.
ENDCLASS.
