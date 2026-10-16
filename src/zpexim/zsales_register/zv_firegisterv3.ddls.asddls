@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI REGISTER'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZV_FIREGISTERV3

  as select from I_JournalEntry            as a

    inner join   I_OperationalAcctgDocItem as b on  b.AccountingDocument = a.AccountingDocument
                                                and b.FiscalYear         = a.FiscalYear
                                                and b.CompanyCode        = a.CompanyCode

{

  key a.AccountingDocument                                             as GSTInvoiceNo,
  key a.FiscalYear,
  key a.CompanyCode,
      b.TransactionTypeDetermination,
      sum( cast( b.AmountInTransactionCurrency as abap.dec( 23,2 ) ) ) as Amount

}

where
  (
       a.AccountingDocumentType       = 'DR'
    or a.AccountingDocumentType       = 'DG'
  )

  and(
       b.TransactionTypeDetermination = 'JOC'
    or b.TransactionTypeDetermination = 'JOI'
    or b.TransactionTypeDetermination = 'JOS'
  )

group by
  a.AccountingDocument,
  a.FiscalYear,
  a.CompanyCode,
  b.TransactionTypeDetermination
