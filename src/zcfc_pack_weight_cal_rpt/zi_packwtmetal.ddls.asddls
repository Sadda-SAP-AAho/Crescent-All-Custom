@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pack Weight-Metal Crate'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PACKWTMETAL
  as select distinct from ZR_BOMCOST_RPT
{
  key Plant,
  key Hedmaterial,
      ChildWtUnit,
      @Semantics.quantity.unitOfMeasure: 'ChildWtUnit'
      sum( ChildNetwt ) as PackWt
}

where
       ChildGrpCode = 'Z042'
  and(
       Plant        = '1200'
    or Plant        = '1300'
  )

group by
  Plant,
  Hedmaterial,
  ChildWtUnit
