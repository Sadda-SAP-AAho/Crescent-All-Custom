@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUSTOMER_LEDGER_02
  with parameters
    @EndUserText.label: 'From Date'
    p_from_date : zde_date_va,
    @EndUserText.label: 'To Date'
    p_to_date   : zde_date_va,
    customer    : kunnr,
    p_company   : bukrs
  as select distinct from ZI_CUSTOMER_LEDGER_03( p_from_date: $parameters.p_from_date, p_to_date: $parameters.p_to_date, customer: $parameters.customer, p_company : $parameters.p_company ) as a
  left outer join ZI_FI_DEBTOR_RPT_16  as b on b.billingdocument = a.arinv
{
       @EndUserText.label: 'Invoice No.'
  key cast(a.AccountingDocument as abap.char( 30 )) as AccountingDocument,
      @EndUserText.label: 'Company Code'
  key a.CompanyCode,
      @EndUserText.label: 'Fiscal Year'
  key a.FiscalYear,
      @UI.hidden: true
  key a.AccountingDocumentItem,
      a.arinv ,
      @EndUserText.label: 'Posting Date'
      a.PostingDate,
      @EndUserText.label: 'Due Date'
      a.NetDueDate,
      @EndUserText.label: 'Document Type'
      a.AccountingDocumentType,
      a.AccountingDocumentTypeName,
      @EndUserText.label: 'Tax Invoice No. '
      a.billingdocument,
      @EndUserText.label: 'Tax Invoice Ref. '
      a.billingdocumentref,
      @EndUserText.label: 'Invoice Ref.'
      b.Salesnoteref as DocumentReferenceID,
      @EndUserText.label: 'Document Reference.'
      a.DocumentReferenceID as DocumentReferenceID1,
      @EndUserText.label: 'Payment Term'
      a.paymentterms,
      @EndUserText.label: 'Order No.'
      a.orderno,
      @UI.hidden: true
      a.CompanyCodeCurrency,
      @EndUserText.label: 'Amount LC'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      @UI.hidden: true
      a.FunctionalCurrency,
      @EndUserText.label: 'Amount FC'
      @Semantics.amount.currencyCode: 'FunctionalCurrency'
      a.AmountInFunctionalCurrency,
      @EndUserText.label: 'Payment Invoice No.'
      a.payref,
      a.CompanyCodeCurrency as comcurr,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Balance Due (LC)'
      a.AmountInCompanyCodeCurrency as     amtincocurr,
      a.FunctionalCurrency  as funccurr,
      @EndUserText.label: 'Credit (FC)'
      @Semantics.amount.currencyCode: 'FunctionalCurrency'
     a.amtinfuct,
       @EndUserText.label: 'Balance Due (FC)'
       @Semantics.amount.currencyCode: 'FunctionalCurrency'
      a.balnacedue,
      'B' as sort
}
union all select from ZI_CUSTOMER_OPEING( p_from_date:$parameters.p_from_date, p_to_date:$parameters.p_to_date , customer: $parameters.customer, p_company : $parameters.p_company )
{
  key 'Opening Balance'             as AccountingDocument,
  key ''                            as companycode,
  key substring(postingdate,1,4)    as FiscalYear,
  key cast('000' as abap.numc(3))                            as AccountingDocumentItem,
  '' as  arinv ,
      postingdate,
      ''                            as NetDueDate,
      ''                            as AccountingDocumentType,
      '' as AccountingDocumentTypename,
      ''                            as billingdocument,
      '' as billingdocumentref,
      ''                            as DocumentReferenceID,
      '' as DocumentReferenceID1,
      ''                            as paymentterms,
      ''                            as orderno,
      CompanyCodeCurrency,
      amount                        as AmountInCompanyCodeCurrency,
      CompanyCodeCurrency           as FunctionalCurrency,
      cast(0 as abap.curr( 21, 2 )) as AmountInFunctionalCurrency,
      ''                            as payref,
      CompanyCodeCurrency           as comcurr,
      amount as amtincocurr,
      CompanyCodeCurrency           as funccurr,
      cast(0 as abap.curr( 21, 2 )) as amtinfuct,
      cast(0 as abap.curr( 21, 2 )) as balnacedue,
      'A' as sort
}
union all select from ZI_CUSTOMER_CLOSING( p_from_date:$parameters.p_from_date, p_to_date:$parameters.p_to_date , customer: $parameters.customer, p_company : $parameters.p_company )
{
  key 'Closing Balance'             as AccountingDocument,
  key ''                            as companycode,
  key substring(postingdate,1,4)    as FiscalYear,
  key cast('000' as abap.numc(3))                            as AccountingDocumentItem,
  '' as  arinv ,
      postingdate,
      ''                            as NetDueDate,
      ''                            as AccountingDocumentType,
         '' as AccountingDocumentTypename,
      ''                            as billingdocument,
      '' as billingdocumentref,
      ''                            as DocumentReferenceID,
      '' as DocumentReferenceID1,
      ''                            as paymentterms,
      ''                            as orderno,
      CompanyCodeCurrency,
      amount                        as AmountInCompanyCodeCurrency,
      CompanyCodeCurrency           as FunctionalCurrency,
      cast(0 as abap.curr( 21, 2 )) as AmountInFunctionalCurrency,
      ''                            as payref,
      CompanyCodeCurrency           as comcurr,
      amount as amtincocurr,
      CompanyCodeCurrency           as funccurr,
      cast(0 as abap.curr( 21, 2 )) as amtinfuct,
      cast(0 as abap.curr( 21, 2 )) as balnacedue,
      'C' as sort
}
