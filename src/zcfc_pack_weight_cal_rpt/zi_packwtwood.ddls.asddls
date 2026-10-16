@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pack Weight-Wooden Crate'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PACKWTWOOD
  as select distinct from ZR_BOMCOST_RPT
{
  key Plant,
  key Hedmaterial,
      ChildWtUnit,
      @Semantics.quantity.unitOfMeasure: 'ChildWtUnit'
      sum( ChildNetwt ) as PackWt
}

where
  (
       ChildGrpCode = 'Z010'
    or ChildGrpCode = 'Z011'
    or ChildGrpCode = 'Z012'
    or ChildGrpCode = 'Z013'
  )


group by
  Plant,
  Hedmaterial,
  ChildWtUnit
