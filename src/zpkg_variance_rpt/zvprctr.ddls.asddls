@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unique Profit center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVPRCTR
  as select distinct from zdt_costingpl_pc
{
  key prctrclub            as Prctrclub,
      cast(1 as abap.int4) as joinflag
}
