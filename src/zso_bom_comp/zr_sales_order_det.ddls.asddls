@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SALES_ORDER_DET as select from I_SalesOrder as _SalesOrder
inner join I_SalesOrderItem as _SalesOrderItem on _SalesOrder.SalesOrder = _SalesOrderItem.SalesOrder
{
    key _SalesOrder.SalesOrder,
    key _SalesOrderItem.SalesOrderItem,
    _SalesOrder.CreationDate,
    _SalesOrder.RequestedDeliveryDate,
    _SalesOrder.SoldToParty,
    _SalesOrderItem.Plant,
    _SalesOrderItem.Material,
    _SalesOrderItem.SalesOrderItemText,
    @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
    _SalesOrderItem.OrderQuantity,
    _SalesOrderItem.OrderQuantityUnit,
    _SalesOrderItem.ProfitCenter,
    
//    Additional Fields
    _SalesOrder.OverallSDProcessStatus,
    _SalesOrderItem.SDProcessStatus
}
where _SalesOrder.OverallSDProcessStatus <> 'C' and
      _SalesOrderItem.SDProcessStatus <> 'C'
