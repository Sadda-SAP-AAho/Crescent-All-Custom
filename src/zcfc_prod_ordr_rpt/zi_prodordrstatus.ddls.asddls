@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODORDRSTATUS
  as select distinct from ZI_PRODORDRSTATUS_1

{
  key ProductionOrder,
      ( case when Status = 'C' then 'Closed/Teco' else 'Released' end ) as Status
}

where
  Status is not null
