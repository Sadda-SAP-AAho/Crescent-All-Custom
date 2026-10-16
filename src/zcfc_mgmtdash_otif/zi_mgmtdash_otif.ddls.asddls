@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASH_OTIF
  as select from ZI_MGMTDASH_OTIF_BASIC as a

{

  key a.ProfitCenterName,
      sum( a.finalotif ) as finalotif
}

group by
  a.ProfitCenterName
