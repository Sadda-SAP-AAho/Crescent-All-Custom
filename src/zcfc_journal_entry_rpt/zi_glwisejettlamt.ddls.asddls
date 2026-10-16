@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL wise Journal Entry Total Amt Comparison'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GLWISEJETTLAMT
  as select distinct from I_JournalEntryItem    as a
    inner join            I_JournalEntry        as aa on  a.CompanyCode        = aa.CompanyCode
                                                      and a.FiscalYear         = aa.FiscalYear
                                                      and a.AccountingDocument = aa.AccountingDocument
    left outer join       ZI_GLWISEJETTLAMT_1   as b  on  a.AccountingDocument = b.AccountingDocument
                                                      and a.FiscalYear         = b.FiscalYear
    left outer join       ZI_GLWISEJETTLAMT_2   as c  on  a.AccountingDocument = c.AccountingDocument
                                                      and a.FiscalYear         = c.FiscalYear
    left outer join       ZI_GLWISEJETTLAMTDIFF as d  on  a.AccountingDocument = d.AccountingDocument
                                                      and a.FiscalYear         = d.FiscalYear

{
  key a.FiscalYear,
  key a.AccountingDocument as JE_No,
      aa.PostingDate,
      b.Set_1_Val,
      c.Set_2_Val,
      d.Val_Diff

}

where
  d.Val_Diff <> cast( 0 as abap.dec(15,3) )
