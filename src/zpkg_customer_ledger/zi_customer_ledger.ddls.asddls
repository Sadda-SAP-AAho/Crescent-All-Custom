@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZI_CUSTOMER_LEDGER
  with parameters
  @EndUserText.label: 'From Date'
    p_from_date : zde_date_va,
    @EndUserText.label: 'To Date'
    p_to_date   : zde_date_va,
    customer    : kunnr,
    p_company   : bukrs
  as select from    ZI_CUSTOMER_LEDGER_02( p_from_date: $parameters.p_from_date, p_to_date: $parameters.p_to_date, customer: $parameters.customer, p_company : $parameters.p_company )   
{
      @EndUserText.label: 'Invoice No.'
  key AccountingDocument,
      @EndUserText.label: 'Company Code'
  key CompanyCode,
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear,
      @UI.hidden: true
  key AccountingDocumentItem,
      @EndUserText.label: 'AR invoice Number'
      arinv,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Due Date'
      NetDueDate,
      @EndUserText.label: 'Document Type'
      AccountingDocumentType,
      @EndUserText.label: 'Document Type Name'
      AccountingDocumentTypeName,
      @EndUserText.label: 'Tax Invoice No. '
      billingdocument,
       @EndUserText.label: 'Tax Invoice Ref. '
      billingdocumentref,
      @EndUserText.label: 'Invoice Ref.'
      DocumentReferenceID,
      @EndUserText.label: 'Document Reference'
      DocumentReferenceID1,
      @EndUserText.label: 'Payment Term'
      paymentterms,
      @EndUserText.label: 'Order No.'
      orderno,
      @UI.hidden: true
      CompanyCodeCurrency,
      @EndUserText.label: 'Amount LC'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      @UI.hidden: true
      FunctionalCurrency,
      @EndUserText.label: 'Amount FC'
      @Semantics.amount.currencyCode: 'FunctionalCurrency'
       AmountInFunctionalCurrency,
      @EndUserText.label: 'Payment Invoice No.'
      payref,
       comcurr,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Balance Due (LC)'
          amtincocurr,
      funccurr,
      @EndUserText.label: 'Credit (FC)'
      @Semantics.amount.currencyCode: 'FunctionalCurrency'
       amtinfuct,
       @EndUserText.label: 'Balance Due (FC)'
       @Semantics.amount.currencyCode: 'FunctionalCurrency'
      balnacedue,
      sort
}

