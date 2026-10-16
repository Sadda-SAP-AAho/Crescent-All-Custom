@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_7
  as select from ZI_FI_DEBTOR_RPT          as a
    inner join   I_OperationalAcctgDocItem as b on  b.InvoiceReference           = a.AccountingDocument
                                                and b.InvoiceReferenceFiscalYear = a.FiscalYear
                                                and b.InvoiceItemReference       = a.AccountingDocumentItem
{
  a.AccountingDocument,
  a.FiscalYear,
  sum( cast( b.AmountInCompanyCodeCurrency as abap.dec( 23,2 ) ) ) as pamt,
  sum( cast( case when a.TransactionCurrency <> 'JPY' then b.AmountInTransactionCurrency
                  else b.AmountInTransactionCurrency * 100 end
  as abap.dec( 23,2 ) ) )                                          as pamtfc
}

where
  b.ClearingJournalEntry is initial

group by
  a.AccountingDocument,
  a.FiscalYear
