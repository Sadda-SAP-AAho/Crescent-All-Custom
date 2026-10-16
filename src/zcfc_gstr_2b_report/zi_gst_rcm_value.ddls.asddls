@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST RCM VALUE-REVERSE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_RCM_VALUE
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
       b.GLAccount = '0012800230'
    or b.GLAccount = '0012800290'
    or b.GLAccount = '0012800250'
    or b.GLAccount = '0012800310'
    or b.GLAccount = '0012800240'
    or b.GLAccount = '0012800300'
  )

group by
  a.FiscalYear,
  a.AccountingDocument
