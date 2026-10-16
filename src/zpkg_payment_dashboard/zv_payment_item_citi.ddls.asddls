@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CITI Payment Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PAYMENT_ITEM_CITI
  as select from I_OperationalAcctgDocItem as a
    inner join   I_JournalEntry            as b on(
      b.AccountingDocument = a.ClearingJournalEntry
      and b.FiscalYear     = a.ClearingJournalEntryFiscalYear
      and b.CompanyCode    = a.CompanyCode
    )
{
  key a.ClearingJournalEntry                 as AccountingDocument,
  key a.ClearingJournalEntryFiscalYear       as FiscalYear,
  key a.CompanyCode,
  key left( a.OriginalReferenceDocument,10 ) as SupplierInvoice,
      //a.AccountingDocument as Invoice,
      a.AccountingDocumentType,
      a.SpecialGLCode,
      a.DocumentDate,
      a.PostingDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.NetDueDate,
      a.PaymentTerms,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.WithholdingTaxAmount,
      a.PurchasingDocument
}
where
       a.FinancialAccountType   =  'K'
  and  a.AccountingDocumentType <> 'ZP'
  and(
       b.AccountingDocumentType =  'ZP'
    or b.AccountingDocumentType =  'KZ'
  )
