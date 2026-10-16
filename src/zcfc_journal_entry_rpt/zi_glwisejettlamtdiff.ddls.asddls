@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL wise Journal Entry Total Amt Difference'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GLWISEJETTLAMTDIFF
  as select distinct from I_JournalEntryItem  as a
    left outer join       ZI_GLWISEJETTLAMT_1 as b on  a.AccountingDocument = b.AccountingDocument
                                                   and a.FiscalYear         = b.FiscalYear
    left outer join       ZI_GLWISEJETTLAMT_2 as c on  a.AccountingDocument = c.AccountingDocument
                                                   and a.FiscalYear         = c.FiscalYear

{
  key a.AccountingDocument,
  key a.FiscalYear,
      ( cast( b.Set_1_Val as abap.dec(15,3) ) + cast( c.Set_2_Val as abap.dec(15,3) ) ) as Val_Diff

}
