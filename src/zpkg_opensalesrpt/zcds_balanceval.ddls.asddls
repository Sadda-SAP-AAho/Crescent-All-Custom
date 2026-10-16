@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for balance value in dc'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_BALANCEVAL
  as select distinct from I_SalesOrder                 as a
    left outer join       I_SalesOrderItem             as b on a.SalesOrder = b.SalesOrder
    left outer join       I_SalesDocItemPricingElement as c on  c.SalesDocument     = b.SalesOrder
                                                            and c.SalesDocumentItem = b.SalesOrderItem
{

  key c.SalesDocument,
  key c.SalesDocumentItem,
      sum(c.ConditionRateAmount) as unitprice
}
where
  (
       c.ConditionType = 'ZPR0'
    or c.ConditionType = 'ZPR1'
    or c.ConditionType = 'ZSPC'
  )
group by
  c.SalesDocument,
  c.SalesDocumentItem
