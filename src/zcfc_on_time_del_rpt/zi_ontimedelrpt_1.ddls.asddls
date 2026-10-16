@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'On Time Delivery Report-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_ONTIMEDELRPT_1
  as select distinct from ZI_SO_DATA  as a
    left outer join       ZI_PGI_QTY  as b on  a.SalesOrder     = b.SalesOrder
                                           and a.SalesOrderItem = b.SalesOrderItem
                                           and a.Material       = b.Material
    left outer join       ZI_LAST_PGI as c on  a.SalesOrder     = c.SalesOrder
                                           and a.SalesOrderItem = c.SalesOrderItem

{
  key a.SalesOrder,
  key a.SalesOrderItem,
      a.sodate,
      cast(concat(concat(concat(substring(( case when a.custreqdeldate is initial then c.PGIDate else a.custreqdeldate end )  ,7,2),'-'),
                 concat(substring(( case when a.custreqdeldate is initial then c.PGIDate else a.custreqdeldate end )  ,5,2),'-' ) ),
                 substring(( case when a.custreqdeldate is initial then c.PGIDate else a.custreqdeldate end )  ,1,4)) as abap.char(10) ) as custreqdeldate,
      a.CommittedDeliveryDate,
      c.PGINo,
      c.PGIDate,
      ( case when c.PGINo is not initial then c.PGIDate else $session.system_date end )                                                  as PGIDt,
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
      b.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      b.TotalPGIQty,
      ( cast(b.TotalPGIQty as abap.dec(13,0))  *
               cast(a.NetWeight as abap.dec(13,3)) )                                                                                     as TotalPGIWt


}
