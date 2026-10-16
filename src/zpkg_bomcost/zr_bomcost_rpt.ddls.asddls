@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for BOM Cost Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BOMCOST_RPT
  as select from ZR_BOMCOST_RPT_1_1
{
  key    Plant,
  key    Hedmaterial,
  key    HeaderGrpCode,
  key    HeaderGrpName,
  key    HeadQty,
  key    Bomlevel,
  key    Parent,
  key    cast( 1 as abap.dec( 1, 0 ) )       as seq,
  key    Costitemcat,
  key    cast( '00' as abap.char( 2 ) )      as sequence,
  key    Component,
         @Semantics.quantity.unitOfMeasure: 'ParentGrossWtUnit'
         ParentGrosswt,
         ParentGrossWtUnit,
         @Semantics.quantity.unitOfMeasure: 'ParentNetWtUnit'
         ParentNetwt,
         ParentNetWtUnit,
         
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
         cast( Amount as abap.dec( 23, 2 ) ) as Amount
}
union select from ZR_BOMCOST_RPT_R_3
{
  key Plant,
  key Hedmaterial,
  key HeaderGrpCode,
  key HeaderGrpName,
  key HeadQty,
  key Bomlevel,
  key Parent,
  key cast( 2 as abap.dec( 1, 0 ) )               as seq,
  key Costitemcat,
  key sequence,
  key CostCtrActivityType                         as Component,
      cast( ParentGrosswt as abap.dec(13, 3) )    as ParentGrosswt,
      ParentGrossWtUnit,
      cast( ParentNetwt as abap.dec(13, 3) )      as ParentNetwt,
      ParentNetWtUnit,
      CostCtrActivityTypeName                     as Childdesc,
      ChildGrpCode,
      ChildGrpName,
      '' as ChildStorageLoc,
      WorkCenterStandardWorkQty                   as Childqty,
      StandardWorkQuantityUnit1                   as Bomitemqtyunit,
      cast( 0 as abap.quan( 13, 3 ) )             as ChildNetwt,
      cast( '' as meins )                         as ChildWtUnit,
      cast( '' as abap.char( 1 ) )                as ChildPlant,
      cast( '' as meins )                         as MaterialBaseUnit,
      cast( 0 as abap.quan( 13, 3 ) )             as ChildMatlStock,
      cast( '' as abap.char( 1 ) )                as PriceControl,
      currency,
      cast( costamt as abap.curr( 23, 2) )        as Rate,
      cast( factor as abap.dec( 5, 0 ) )          as Rateqty,
      //      cast( totamt as abap.dec( 23, 2 ) )  as Amount
      case when factor is not initial
           then cast( division( cast( ( cast( WorkCenterStandardWorkQty as abap.dec( 13, 3 ) ) * cast( costamt as abap.dec( 23, 2 ) )  ) as abap.dec( 23, 2 ) ),
                cast( factor as abap.dec( 23, 2 ) ), 2 ) as abap.dec( 23, 2 ) )
           else cast( 0 as abap.dec( 23, 2 )) end as amount
}
