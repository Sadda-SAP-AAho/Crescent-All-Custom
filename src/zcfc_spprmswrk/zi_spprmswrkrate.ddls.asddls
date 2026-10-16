@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Special Price Misc Rate Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SPPRMSWRKRATE
  as select distinct from ZI_SPPRMSWRKHDR as a
    inner join            ZI_SPPRMSWRKITM as b on a.Id = b.Id
{
  key a.Id,
  key b.Item,
      a.Plantcode,
      a.Plantname,
      a.Workcode,
      a.Workname,
      b.Datefrom,
      b.Dateto,
      b.Currency,
      b.Rate
}

where
      b.Datefrom <= $session.system_date
  and b.Dateto   >= $session.system_date
