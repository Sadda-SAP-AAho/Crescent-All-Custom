@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Item Latest Costing Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_12
  as select from I_SalesOrderItem        as a
    inner join I_SalesOrder              as b on b.SalesOrder = a.SalesOrder
    inner join I_ProductCostEstimate     as c on  c.Product                        = a.Material
                                              and c.Plant                          = a.Plant
                                              and c.ValuationType                  is initial
                                              and (c.CostEstimateValidityStartDate <= b.CreationDate
                                              and c.CostEstimateValidityEndDate   >= b.CreationDate)
{
  key a.SalesOrder,
  key a.SalesOrderItem,
      max( c.CostingDate ) as CostingDate
}
group by
  a.SalesOrder,
  a.SalesOrderItem
