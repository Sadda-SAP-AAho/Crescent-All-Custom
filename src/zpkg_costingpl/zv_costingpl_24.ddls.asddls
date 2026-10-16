@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_24

  as select from I_SalesOrderItem           as a

    inner join   I_SalesOrderPricingElement as b on b.SalesOrder = a.SalesOrder

{

  key a.SalesOrder,
  key a.SalesOrderItem,
      sum( case when b.ConditionType = 'ZRAW' then cast( b.ConditionAmount as abap.dec( 21,2 ) ) else 0 end ) as ZRAW

}

group by
  a.SalesOrder,
  a.SalesOrderItem
