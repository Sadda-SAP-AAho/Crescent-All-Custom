@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report - INSIA'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_OTIF_INSIA
  as select from ZI_SD_OTIF_REPORT_FIN as a
    inner join            I_SalesOrder          as b on a.SalesOrder = b.SalesOrder
    left outer join       I_CustomerMaterial_2  as c on c.Product = a.Product
{
  key a.SalesOrder                    as SONo,
  key a.SalesOrderItem                as SOLineNo,
  key a.DeliveryDocument              as DelvNo,
  key a.DeliveryDocumentItem          as DelvLineNo,
      a.CreationDate                  as SODate,
      a.CreationDate                  as SOCreationDate,
      b.LastChangeDate                as SOUpdateDate,
      a.SoldToParty                   as Customer,
      a.Product                       as MatNo,
      a.SalesOrderItemText            as Description,
      c.MaterialByCustomer            as CustomerMatlDesc,
      a.ScheduleLineOrderQuantity     as Quantity,
      a.DeliveredQtyInOrderQtyUnit    as DeliveredQty,
      a.OpenConfdDelivQtyInOrdQtyUnit as OpenQty,
      a.PurchaseOrderByCustomer       as CustomerPONo,
      a.CustomerPurchaseOrderDate     as CustomerPODate,
      a.ConfirmedDeliveryDate         as OurCommDate,
      a.otifamt                       as OTIF
}
