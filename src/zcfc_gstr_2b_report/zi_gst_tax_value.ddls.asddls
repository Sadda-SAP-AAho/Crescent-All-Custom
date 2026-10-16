@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST TAX VALUE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_TAX_VALUE
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

    left outer join       I_TaxCodeText      as c on  c.TaxCode                 = b.TaxCode
                                                  and c.TaxCalculationProcedure = '0TXIN'
                                                  and c.Language                = 'E'


{
  key a.FiscalYear,
  key a.AccountingDocument,
      max( c.TaxCodeName )                                               as TaxCode,
      sum( cast ( b.AmountInCompanyCodeCurrency as abap.dec( 19, 3 ) ) ) as TaxValue

}

where
  (
       b.GLAccount = '0012800200'
    or b.GLAccount = '0012800210'
    or b.GLAccount = '0012800220'
    or b.GLAccount = '0012800230'
    or b.GLAccount = '0012800240'
    or b.GLAccount = '0012800250'
    or b.GLAccount = '0012800260'
    or b.GLAccount = '0012800270'
    or b.GLAccount = '0012800280'
    or b.GLAccount = '0012800290'
    or b.GLAccount = '0012800300'
    or b.GLAccount = '0012800310'
    or b.GLAccount = '0012800340'
    or b.GLAccount = '0012800350'
    or b.GLAccount = '0012800360'
  )

group by
  a.FiscalYear,
  a.AccountingDocument
