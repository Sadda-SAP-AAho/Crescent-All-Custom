@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Pack Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_BOMPACKQTY
  as select distinct from ZR_BOMCOST_RPT
{
  key Plant,
  key Hedmaterial,
      sum( Childqty ) as BomPackQty
}

where
  (
       ChildGrpCode = 'Z041'
    or ChildGrpCode = 'Z042'
  )

group by
  Plant,
  Hedmaterial
