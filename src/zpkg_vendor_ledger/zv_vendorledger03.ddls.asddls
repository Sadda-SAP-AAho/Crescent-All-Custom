@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VENDORLEDGER03

  with parameters
    p_begda : datum,
    p_endda : datum


  as select from I_JournalEntryItem           as a

    inner join   I_Supplier                   as b on b.Supplier = a.Supplier

    inner join   I_JournalEntry               as c on  c.AccountingDocument = a.AccountingDocument
                                                   and c.FiscalYear         = a.FiscalYear
                                                   and c.CompanyCode        = a.CompanyCode

    inner join   I_AccountingDocumentTypeText as d on  d.Language               = $session.system_language
                                                   and d.AccountingDocumentType = a.AccountingDocumentType

{

  key a.AccountingDocument,
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
      a.PostingDate,
      a.DocumentDate,
      a.NetDueDate                                                                                       as BaseLineDate,
      a.Supplier,
      b.SupplierName,
      a.AccountingDocumentType,
      d.AccountingDocumentTypeName,
      a.ProfitCenter,
      a.SpecialGLCode,
      a.ClearingAccountingDocument,
      a.ClearingDate,
      case when  a.ClearingAccountingDocument is not initial then 'Cleared' else 'Yet to be Cleared' end as ClearingStatus,
      c.DocumentReferenceID                                                                              as Reference,
      a.AssignmentReference,
      a.DocumentItemText,
      a.PurchasingDocument,
      a.OffsettingAccount,
      a.ReferenceDocument,
      a.DebitCreditCode,
      a.TaxCode,
      a.CreationDate,
      c.AccountingDocCreatedByUser,
      a.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.AmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.DebitAmountInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.CreditAmountInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.CreditAmountInCoCodeCrcy + a.DebitAmountInCoCodeCrcy                                             as BalanceDueCoCodeCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.DebitAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.CreditAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.CreditAmountInTransCrcy + a.DebitAmountInTransCrcy                                               as BalanceDueTransCrcy,
      concat( a.Supplier, 'B' )                                                                          as SortCode

}

where
      a.FinancialAccountType =  'K'
  and a.PostingDate          >= $parameters.p_begda
  and a.PostingDate          <= $parameters.p_endda
  and a.Supplier             is not initial
  and a.SpecialGLCode        <> 'F'
  and a.Ledger               =  '0L'
  and a.SourceLedger         =  '0L'
