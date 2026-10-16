@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL wise Journal Entry Total Amt(Set-1)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GLWISEJETTLAMT_1
  as select distinct from I_JournalEntryItem
{
  key AccountingDocument,
  key FiscalYear,
      cast( sum( AmountInCompanyCodeCurrency ) as abap.dec(15,3) ) as Set_1_Val
}

where
       SourceLedger = '0L'
  and  Ledger       = '0L'
  and(
       GLAccount    = '0012100500'
    or GLAccount    = '0012100510'
    or GLAccount    = '0036200010'
    or GLAccount    = '0047100100'
    or GLAccount    = '0047100300'
    or GLAccount    = '0047100490'
    or GLAccount    = '0047100500'
    or GLAccount    = '0047100510'
    or GLAccount    = '0047100520'
    or GLAccount    = '0047100530'
    or GLAccount    = '0047100540'
    or GLAccount    = '0047100550'
    or GLAccount    = '0047100560'
    or GLAccount    = '0047100570'
    or GLAccount    = '0047100590'
    or GLAccount    = '0047100620'
    or GLAccount    = '0047100630'
    or GLAccount    = '0047100640'
    or GLAccount    = '0047100650'
    or GLAccount    = '0047100710'
    or GLAccount    = '0047100720'
    or GLAccount    = '0047100740'
    or GLAccount    = '0047200010'
    or GLAccount    = '0047200020'
    or GLAccount    = '0047200030'
    or GLAccount    = '0047200040'
    or GLAccount    = '0047200050'
    or GLAccount    = '0047200060'
    or GLAccount    = '0047200070'
    or GLAccount    = '0047200080'
    or GLAccount    = '0047200082'
    or GLAccount    = '0047200084'
    or GLAccount    = '0047200086'
    or GLAccount    = '0047200088'
    or GLAccount    = '0047200090'
    or GLAccount    = '0047200110'
    or GLAccount    = '0047200120'
    or GLAccount    = '0047200150'
    or GLAccount    = '0047200200'
    or GLAccount    = '0047200210'
    or GLAccount    = '0047200300'
    or GLAccount    = '0047200310'
    or GLAccount    = '0047200320'
    or GLAccount    = '0047200330'
    or GLAccount    = '0047200340'
    or GLAccount    = '0047200350'
    or GLAccount    = '0047200360'
    or GLAccount    = '0047200370'
    or GLAccount    = '0047200380'
    or GLAccount    = '0047200390'
    or GLAccount    = '0047200400'
    or GLAccount    = '0047200410'
    or GLAccount    = '0047600250'
    or GLAccount    = '0048400565'
  )

group by
  AccountingDocument,
  FiscalYear
