@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'JE Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_JEDETAILS
  as select distinct from I_JournalEntry     as a
    inner join            I_JournalEntryItem as b on  a.CompanyCode        = b.CompanyCode
                                                  and a.FiscalYear         = b.FiscalYear
                                                  and a.AccountingDocument = b.AccountingDocument
{
  key a.CompanyCode        as CompCode,
  key a.FiscalYear         as FY,
  key a.AccountingDocument as JENo,
      b.GLAccount
}
