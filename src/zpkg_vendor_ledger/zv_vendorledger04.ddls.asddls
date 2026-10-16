@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VENDORLEDGER04

  with parameters
    p_begda : datum,
    p_endda : datum

  as select from    ZV_VENDORLEDGER03( p_begda: $parameters.p_begda, p_endda: $parameters.p_endda ) as a

    left outer join ZV_VENDORLEDGER05( mandt: $session.client )                                     as b on  b.accountingdocument = a.AccountingDocument
                                                                                                         and b.fiscalyear         = a.FiscalYear
                                                                                                         and b.companycode        = a.CompanyCode

{

  key cast( a.AccountingDocument as abap.char(30) ) as AccountingDocument,
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
      a.DocumentDate,
      a.PostingDate,
      a.BaseLineDate,
      a.Supplier,
      a.SupplierName,
      a.AccountingDocumentType,
      a.AccountingDocumentTypeName,
      a.ProfitCenter,
      a.SpecialGLCode,
      a.ClearingAccountingDocument,
      a.ClearingDate,
      a.ClearingStatus,
      a.Reference,
      a.AssignmentReference,
      a.DocumentItemText,
      b.poreference                                 as PurchasingDocument,
      a.OffsettingAccount,
      a.ReferenceDocument,
      a.DebitCreditCode,
      a.TaxCode,
      a.CreationDate,
      a.AccountingDocCreatedByUser,
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
      a.BalanceDueCoCodeCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.DebitAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.CreditAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.BalanceDueTransCrcy,
      a.SortCode

}

union select from ZV_VENDORLEDGER01( p_begda: $parameters.p_begda )

{

  key cast( 'OPENING' as abap.char(30) )                                  as AccountingDocument,
  key CompanyCode,
  key cast( '' as gjahr )                                                 as FiscalYear,
  key cast( '0' as abap.char(3))                                          as AccountingDocumentItem,
      ''                                                                  as DocumentDate,
      postingdate,
      ''                                                                  as BaseLineDate,
      Supplier,
      SupplierName,
      ''                                                                  as AccountingDocumentType,
      ''                                                                  as AccountingDocumentTypeName,
      ''                                                                  as ProfitCenter,
      ''                                                                  as SpecialGLCode,
      ''                                                                  as ClearingAccountingDocument,
      ''                                                                  as ClearingDate,
      ''                                                                  as ClearingStatus,
      ''                                                                  as Reference,
      ''                                                                  as AssignmentReference,
      ''                                                                  as DocumentItemText,
      ''                                                                  as PurchasingDocument,
      ''                                                                  as OffsettingAccount,
      ''                                                                  as ReferenceDocument,
      ''                                                                  as DebitCreditCode,
      ''                                                                  as TaxCode,
      ''                                                                  as CreationDate,
      ''                                                                  as AccountingDocCreatedByUser,
      CompanyCodeCurrency,
      CreditAmountInCoCodeCrcy + DebitAmountInCoCodeCrcy                  as AmountInCompanyCodeCurrency,
      cast( '' as abap.cuky( 5 ) )                                        as TransactionCurrency,
      cast( 0 as dmbtr)                                                   as AmountInTransactionCurrency,
      cast( DebitAmountInCoCodeCrcy as dmbtr)                             as DebitAmountInCoCodeCrcy,
      cast( CreditAmountInCoCodeCrcy as dmbtr)                            as CreditAmountInCoCodeCrcy,
      cast( CreditAmountInCoCodeCrcy + DebitAmountInCoCodeCrcy  as dmbtr) as BalanceDueCoCodeCrcy,
      cast( 0 as dmbtr)                                                   as DebitAmountInTransCrcy,
      cast( 0 as dmbtr)                                                   as CreditAmountInTransCrcy,
      cast( 0 as dmbtr)                                                   as BalanceDueTransCrcy,
      SortCode

}

union select from ZV_VENDORLEDGER02( p_endda: $parameters.p_endda )

{

  key cast( 'CLOSING' as abap.char(30) )                                  as AccountingDocument,
  key CompanyCode,
  key cast( '' as gjahr )                                                 as FiscalYear,
  key cast( '0' as abap.char(3))                                          as AccountingDocumentItem,
      ''                                                                  as DocumentDate,
      postingdate,
      ''                                                                  as BaseLineDate,
      Supplier,
      SupplierName,
      ''                                                                  as AccountingDocumentType,
      ''                                                                  as AccountingDocumentTypeName,
      ''                                                                  as ProfitCenter,
      ''                                                                  as SpecialGLCode,
      ''                                                                  as ClearingAccountingDocument,
      ''                                                                  as ClearingDate,
      ''                                                                  as ClearingStatus,
      ''                                                                  as Reference,
      ''                                                                  as AssignmentReference,
      ''                                                                  as DocumentItemText,
      ''                                                                  as PurchasingDocument,
      ''                                                                  as OffsettingAccount,
      ''                                                                  as ReferenceDocument,
      ''                                                                  as DebitCreditCode,
      ''                                                                  as TaxCode,
      ''                                                                  as CreationDate,
      ''                                                                  as AccountingDocCreatedByUser,
      CompanyCodeCurrency,
      CreditAmountInCoCodeCrcy + DebitAmountInCoCodeCrcy                  as AmountInCompanyCodeCurrency,
      cast( '' as abap.cuky( 5 ) )                                        as TransactionCurrency,
      cast( 0 as dmbtr)                                                   as AmountInTransactionCurrency,
      cast( DebitAmountInCoCodeCrcy as dmbtr)                             as DebitAmountInCoCodeCrcy,
      cast( CreditAmountInCoCodeCrcy as dmbtr)                            as CreditAmountInCoCodeCrcy,
      cast( CreditAmountInCoCodeCrcy + DebitAmountInCoCodeCrcy  as dmbtr) as BalanceDueCoCodeCrcy,
      cast( 0 as dmbtr)                                                   as DebitAmountInTransCrcy,
      cast( 0 as dmbtr)                                                   as CreditAmountInTransCrcy,
      cast( 0 as dmbtr)                                                   as BalanceDueTransCrcy,
      SortCode

}
