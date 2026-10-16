@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Standard Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_11
  as select from I_SalesOrderItem          as a
    inner join   I_SalesOrder              as b on b.SalesOrder = a.SalesOrder
    inner join   I_ProductCostEstimate     as c on  c.Product                       =  a.Material
                                                and c.Plant                         =  a.Plant
                                                and c.ValuationType                 is initial
                                                and (c.CostEstimateValidityStartDate <= b.CreationDate
                                                and c.CostEstimateValidityEndDate   >= b.CreationDate)

    inner join   I_ProductCostEstimateItem as d on  d.CostingReferenceObject = c.CostingReferenceObject
                                                and d.CostEstimate           = c.CostEstimate
                                                and d.CostingDate            = c.CostingDate
                                                and d.CostingType            = c.CostingType
    inner join   ZCDS_SAL_REA_12           as e on  e.SalesOrder     = a.SalesOrder
                                                and e.SalesOrderItem = a.SalesOrderItem
                                                and e.CostingDate    = c.CostingDate
{
  key a.SalesOrder,
  key a.SalesOrderItem,
      b.CreationDate,
      c.CostingDate,

      sum( cast( d.TotalAmountInCoCodeCrcy as abap.dec( 23, 2 ) ) ) as TotalAmountInCoCodeCrcy
}
group by
  a.SalesOrder,
  a.SalesOrderItem,
  b.CreationDate,
  c.CostingDate
