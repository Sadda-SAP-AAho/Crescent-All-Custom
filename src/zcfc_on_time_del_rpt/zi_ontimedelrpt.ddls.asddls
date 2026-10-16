@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'On Time Delivery Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_ONTIMEDELRPT
  as select distinct from ZI_ONTIMEDELRPT_1 as a

{
  key cast( a.SalesOrder as abap.char(10) )                                                                                as SalesOrder,
  key cast( a.SalesOrderItem as abap.char(6) )                                                                             as SalesOrderItem,
      a.sodate,
      a.custreqdeldate,
      a.CommittedDeliveryDate,
      a.PGINo,
      a.PGIDate,
      a.CustCode,
      a.SalesPerson,
      a.Plant,
      a.MOC,
      a.Material,
      a.MaterialDesc,
      a.HSNCode,
      a.UOM,
      a.WeightUnit,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      a.NetWeight,
      a.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      a.OrderQuantity,
      a.OrderWt,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.TotalPGIQty,
      a.TotalPGIWt,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ( case when a.PGIDt <= a.CommittedDeliveryDate then a.TotalPGIQty end )                                              as OnTimeDelQty,

      cast ( ( ( case when a.PGIDt <= a.CommittedDeliveryDate then a.TotalPGIQty end ) * a.NetWeight ) as abap.dec(13,3) ) as OnTimeDelwt,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ( case when a.PGIDt > a.CommittedDeliveryDate then a.TotalPGIQty end )                                               as DelayedDelQty,
      cast ( ( ( case when a.PGIDt > a.CommittedDeliveryDate then a.TotalPGIQty end ) * a.NetWeight ) as abap.dec(13,3) )  as DelayedDelwt,

      dats_days_between( a.CommittedDeliveryDate, a.PGIDt )                                                                as DelayDays



}
