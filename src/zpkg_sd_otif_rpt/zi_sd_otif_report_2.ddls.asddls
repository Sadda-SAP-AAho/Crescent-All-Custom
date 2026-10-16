@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_2
  as select from I_SalesOrderItem as a
    inner join   I_MaterialStock  as b on  b.Material = a.Product
                                       and b.Plant    = a.Plant
{
  key a.SalesOrder,
  key a.SalesOrderItem,
      sum( cast( b.MatlWrhsStkQtyInMatlBaseUnit as abap.dec( 23, 3 ) ) ) as MatlWrhsStkQtyInMatlBaseUnit
}
where
  b.InventoryStockType = '01'
group by
  a.SalesOrder,
  a.SalesOrderItem
