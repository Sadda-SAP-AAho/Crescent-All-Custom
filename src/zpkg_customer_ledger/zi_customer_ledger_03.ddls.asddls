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
define view entity ZI_CUSTOMER_LEDGER_03
  with parameters
  @EndUserText.label: 'From Date'
    p_from_date : zde_date_va,
    @EndUserText.label: 'To Date'
    p_to_date   : zde_date_va,
    customer    : kunnr,
    p_company   : bukrs
  as select from    I_OperationalAcctgDocItem as a
    left outer join ZI_CUSTOMER_LEDGER_01     as b on  a.AccountingDocument     = b.AccountingDocument
                                                   and a.CompanyCode            = b.CompanyCode
                                                   and a.FiscalYear             = b.FiscalYear
                                                   and a.AccountingDocumentItem = b.AccountingDocumentItem
    left outer join ZI_FI_DEBTOR_RPT_18       as c on c.arinv = b.arinv
    
    left outer join I_JournalEntry            as d on  d.CompanyCode        = a.CompanyCode
                                                   and d.FiscalYear         = a.FiscalYear
                                                   and d.AccountingDocument = a.AccountingDocument
    left outer join ZR_PAYMENT_TERMS01        as e on  e.CompanyCode        = a.CompanyCode
                                                   and e.FiscalYear         = a.FiscalYear
                                                   and e.AccountingDocument = a.AccountingDocument

    left outer join ZTABL_ORDER_NO            as f on  f.companycode        = a.CompanyCode
                                                   and f.fiscalyear         = a.FiscalYear
                                                   and f.accountingdocument = a.AccountingDocument
    left outer join ZTABL_payment_ref         as g on  g.companycode        = a.CompanyCode
                                                   and g.fiscalyear         = a.FiscalYear
                                                   and g.accountingdocument = a.AccountingDocument

    left outer join ZI_INVOICE_REFERENCE02    as h on  g.companycode        = a.CompanyCode
                                                   and h.FiscalYear         = a.FiscalYear
                                                   and h.AccountingDocument = a.AccountingDocument
  left outer join I_AccountingDocumentTypeText as i on  i.Language               = $session.system_language
                                                      and i.AccountingDocumentType = a.AccountingDocumentType

{
      @EndUserText.label: 'Invoice No.'
  key a.AccountingDocument,
      @EndUserText.label: 'Company Code'
  key a.CompanyCode,
      @EndUserText.label: 'Fiscal Year'
  key a.FiscalYear,
      @UI.hidden: true
  key a.AccountingDocumentItem,
  case when a.AccountingDocumentType = 'DR' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'RV' then a.OriginalReferenceDocument
           when a.AccountingDocumentType = 'UE' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'DG' then left(a.OriginalReferenceDocument, 10)
           else '' end                                      as arinv,
      @EndUserText.label: 'Posting Date'
      a.PostingDate,
      @EndUserText.label: 'Due Date'
      a.NetDueDate,
      @EndUserText.label: 'Document Type'
      a.AccountingDocumentType,
      @EndUserText.label: 'Document Type Name'
      i.AccountingDocumentTypeName,
      @EndUserText.label: 'Tax Invoice No. '
      c.billingdocument,
       @EndUserText.label: 'Tax Invoice ref.'
      c.billingdocumentref,
      @EndUserText.label: 'Invoice Ref.'
      d.DocumentReferenceID,
      @EndUserText.label: 'Payment Term'
      e.paymentterms,
      @EndUserText.label: 'Order No.'
      f.orderno,
      @UI.hidden: true
      a.CompanyCodeCurrency,
      @EndUserText.label: 'Amount LC'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      @UI.hidden: true
      a.TransactionCurrency as FunctionalCurrency,
      @EndUserText.label: 'Amount FC'
      @Semantics.amount.currencyCode: 'FunctionalCurrency'
        case 
      when a.DebitCreditCode = 'S'
      then 
      a.AmountInTransactionCurrency end as AmountInFunctionalCurrency,
      @EndUserText.label: 'Payment Invoice No.'
      g.payref,
      h.CompanyCodeCurrency as comcurr,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Balance Due (LC)'
      a.AmountInCompanyCodeCurrency as     amtincocurr,
      h.FunctionalCurrency  as funccurr,
      @EndUserText.label: 'Credit (FC)'
      @Semantics.amount.currencyCode: 'FunctionalCurrency'
      case 
      when a.DebitCreditCode = 'H'
      then a.AmountInTransactionCurrency end as amtinfuct,
       @EndUserText.label: 'Balance Due (FC)'
       @Semantics.amount.currencyCode: 'FunctionalCurrency'
     a.AmountInTransactionCurrency as balnacedue

}
where
      a.PostingDate >= $parameters.p_from_date
  and a.PostingDate <= $parameters.p_to_date
  and a.Customer    = $parameters.customer
  and a.CompanyCode = $parameters.p_company
  and a.FinancialAccountType = 'D'
  and a.SpecialGLCode <> 'F'
  and a.AccountingDocumentType <> 'ZR'
  and a.AccountingDocumentType <> 'ZD'
