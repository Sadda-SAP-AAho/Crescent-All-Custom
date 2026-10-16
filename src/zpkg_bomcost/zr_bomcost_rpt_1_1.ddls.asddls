@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Cost Report 1.1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BOMCOST_RPT_1_1
  as select from ZR_BOMCOST_RPT_1
{
  key Plant,
  key Hedmaterial,
      HeaderGrpCode,
      HeaderGrpName,
      HeadQty,
      Bomlevel,
      Parent,
      @Semantics.quantity.unitOfMeasure: 'ParentGrossWtUnit'
      ParentGrosswt,
      ParentGrossWtUnit,
      @Semantics.quantity.unitOfMeasure: 'ParentNetWtUnit'
      ParentNetwt,
      ParentNetWtUnit,
      Costitemcat,
      Component,
      ChildDesc,
      ChildGrpCode,
      ChildGrpName,
      ChildStorageLoc,
      Childqty,
      Bomitemqtyunit,
      @Semantics.quantity.unitOfMeasure: 'ChildWtUnit'
      ChildNetwt,
      ChildWtUnit,
      ChildPlant,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ChildMatlStock,
      PriceControl,
      Currency,
      @Semantics.amount.currencyCode: 'Currency'
      Rate,
      RateQty,
      case when RateQty is not initial then cast( ( division( cast(Rate as abap.dec( 10, 2) ),RateQty,3 ) * Childqty ) as abap.dec( 23, 2 ) )
           else cast( 0 as abap.dec( 23, 2) ) end as Amount
}
