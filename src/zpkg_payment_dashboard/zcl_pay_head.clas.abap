CLASS zcl_pay_head DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PAY_HEAD IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
     DATA it_pay_head TYPE STANDARD TABLE OF zc_pay_header WITH DEFAULT KEY.
    it_pay_head   = CORRESPONDING #( it_original_data ).

    loop at it_pay_head  ASSIGNING FIELD-SYMBOL(<fs_pay>).
    if <fs_pay> is ASSIGNED.
    select SINGLE AMOUNTINCOMPANYCODECURRENCY , ABSOLUTEAMOUNTINCOCODECRCY , CompanyCodeCurrency
    from I_OPERATIONALACCTGDOCITEM
    where AccountingDocument = @<fs_pay>-Accountingdoc
    and FiscalYear = @<fs_pay>-Fiscalyear
    and CompanyCode = @<fs_pay>-Companycode
    into @data(ls_amount).
    if sy-subrc = 0.
      <fs_pay>-uom = ls_amount-CompanyCodeCurrency.
      if ls_amount-AbsoluteAmountInCoCodeCrcy is NOT INITIAL.
      <fs_pay>-amount = ls_amount-AmountInCompanyCodeCurrency." / ls_amount-AbsoluteAmountInCoCodeCrcy .
      endif.
    endif.
     endif.
    ENDLOOP.
     ct_calculated_data = CORRESPONDING #( it_pay_head ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
