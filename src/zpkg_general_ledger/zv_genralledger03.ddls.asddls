@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'General Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_GENRALLEDGER03


  with parameters
    p_begda : datum,
    p_endda : datum


  as select from I_JournalEntryItem           as a

    inner join   I_GLAccount                  as b on b.GLAccount = a.GLAccount

    inner join   I_GLAccountText              as e on  e.Language  = $session.system_language
                                                   and e.GLAccount = b.GLAccount

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
      a.NetDueDate                                                                                       as BaseLineDate,
      a.GLAccount,
      e.GLAccountName,
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
      a.Supplier,
      a.Customer,
      a.IsReversal,
      a.IsReversed,
      a.ReversalReferenceDocument,
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
      a.DebitAmountInCoCodeCrcy + a.CreditAmountInCoCodeCrcy                                             as BalanceDueCoCodeCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.DebitAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.CreditAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.DebitAmountInTransCrcy + a.CreditAmountInTransCrcy                                               as BalanceDueTransCrcy,
      concat( a.GLAccount, 'B' )                                                                         as SortCode

}

where
      a.FinancialAccountType =  'S'
  and a.PostingDate          >= $parameters.p_begda
  and a.PostingDate          <= $parameters.p_endda
  and a.Ledger               =  '0L'
  and a.SourceLedger         =  '0L'
