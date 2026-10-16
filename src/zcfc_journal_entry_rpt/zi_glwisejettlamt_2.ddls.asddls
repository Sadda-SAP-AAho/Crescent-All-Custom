@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL wise Journal Entry Total Amt(Set-2)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GLWISEJETTLAMT_2
  as select distinct from I_JournalEntryItem
{
  key AccountingDocument,
  key FiscalYear,
      cast( sum( AmountInCompanyCodeCurrency ) as abap.dec(15,3) ) as Set_2_Val
}

where
       SourceLedger = '0L'
  and  Ledger       = '0L'
  and(
       GLAccount    = '0012100090'
    or GLAccount    = '0012100100'
    or GLAccount    = '0012100110'
    or GLAccount    = '0012100120'
    or GLAccount    = '0012100130'
    or GLAccount    = '0012100140'
    or GLAccount    = '0012100150'
    or GLAccount    = '0012100160'
    or GLAccount    = '0012100170'
    or GLAccount    = '0012100180'
    or GLAccount    = '0012100190'
    or GLAccount    = '0012100200'
    or GLAccount    = '0012100210'
    or GLAccount    = '0012100520'

  )

group by
  AccountingDocument,
  FiscalYear
