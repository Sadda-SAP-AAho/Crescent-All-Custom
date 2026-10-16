@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Planning Rpt 2_2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_2_2
  as select from ZR_PLAN_RPT_2_1
{
  key plant,
      //  key hedmaterial,
  key component,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      NetWeight,
      qtyperbox,
      boxsize,
      OpenSoQty,
      castonhand,
      SfgOnHand,
      OpenSoQtyRem,

      case when OpenSoQtyRem <= SfgOnHand then OpenSoQtyRem
           when OpenSoQtyRem > SfgOnHand then SfgOnHand
           else null end                                 as SfgLiveQty,

      case when OpenSoQtyRem is null then SfgOnHand
           when OpenSoQtyRem <= SfgOnHand
              then cast( ( coalesce(cast(SfgOnHand as abap.dec( 15, 3) ),0) -
                           coalesce(cast( OpenSoQtyRem as abap.dec( 15, 3)),0)
                    ) as abap.dec( 15, 3 ) )
           else null end                                 as SfgdeadQty,

      //      case when coalesce(SfgOnHand,0) + coalesce(castonhand,0) <= OpenSoQty
      //           then ( coalesce(OpenSoQty,0) - coalesce(SfgOnHand,0) - coalesce(castonhand,0) )
      //            else null end                                as SfgLiveQty,
      //      case when coalesce(SfgOnHand,0) + coalesce(castonhand,0) > OpenSoQty
      //           then ( coalesce(SfgOnHand,0) + coalesce(castonhand,0) - coalesce(OpenSoQty,0) )
      //            else null end                                as SfgdeadQty,
      //      case when SfgOnHand >= ( OpenSoQty - castonhand )
      //           then ( OpenSoQty - castonhand ) else null end             as SfgdeadQty,

      ( coalesce(SfgOnHand,0) + coalesce(castonhand,0) ) as Totalstockqty,

      OpenSoQty7,
      OpenSoQty8,
      OpenSoQty16,
      OpenSoQty23,
      OpenSoQty31,
      OpenSoQty39,
      OpenSoQty47,
      OpenSoQty55,
      OpenSoQty63,
      OpenSoQty71,
      OpenSoQty366
}
