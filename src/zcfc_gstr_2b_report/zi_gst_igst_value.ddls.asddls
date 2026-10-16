@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST IGST VALUE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_IGST_VALUE
  as select distinct from I_JournalEntry     as a

    inner join            I_JournalEntryItem as b on  b.AccountingDocument       = a.AccountingDocument
                                                  and b.FiscalYear               = a.FiscalYear
                                                  and b.SourceLedger             = '0L'
                                                  and b.Ledger                   = '0L'
                                                  and a.ReverseDocument          is initial
                                                  and (
                                                     a.AccountingDocumentType    = 'KR'
                                                     or a.AccountingDocumentType = 'RE'
                                                   )
                                                  and a.CompanyCode              = '1000'

{
  key a.FiscalYear,
  key a.AccountingDocument,
      sum( cast ( b.AmountInCompanyCodeCurrency as abap.dec( 19, 3 ) ) ) as TaxValue
}

where
  (
       b.GLAccount = '0012800220'
    or b.GLAccount = '0012800280'
  )

group by
  a.FiscalYear,
  a.AccountingDocument
