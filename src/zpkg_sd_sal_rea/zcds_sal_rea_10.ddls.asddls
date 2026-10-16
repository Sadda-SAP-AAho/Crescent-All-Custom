@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order total Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_10 
as select from I_SalesOrderItem
{
    SalesOrder,
    sum( cast( ItemNetWeight as abap.dec( 13, 3 ) ) ) as ItemNetWeight 
}
group by SalesOrder
