@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INPUTREG4
  as select from I_JournalEntryItem           as a
    inner join   I_OperationalAcctgDocTaxItem as b on  a.CompanyCode        = b.CompanyCode
                                                   and a.FiscalYear         = b.FiscalYear
                                                   and a.AccountingDocument = b.AccountingDocument
{
  key  a.SourceLedger,
  key  a.CompanyCode,
  key  a.FiscalYear,
  key  a.AccountingDocument,

  key  a.Ledger,
  key  a.GLAccount,
  key  a.TaxCode,
  key  a.TransactionCurrency,

       min(     a.LedgerGLLineItem )                 as LedgerGLLineItema,
       @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
       sum(a.AmountInTransactionCurrency)            as AmountInTransactionCurrency,

       cast( sum(a.Quantity)     as abap.dec(13,3) ) as Quantity
}
where
      a.SourceLedger = '0L'
  and a.Ledger       = '0L'
//  and(
//        GLAccount    <> '0000251013'
//    and GLAccount    <> '251013'
//    and TaxCode      =  '1E'
//  )
group by
  a.SourceLedger,
  a.CompanyCode,
  a.FiscalYear,
  a.AccountingDocument,

  a.Ledger,
  a.GLAccount,
  a.TaxCode,
  a.TransactionCurrency
