@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'shipping notification print data 1'
define view entity ZCDS_SHIP_NOT_HDR1
  as select distinct from ZI_COMM_HED                as a
    left outer join       I_BillingDocument          as b on a.Commid = b.BillingDocument
    left outer join       I_BillingDocumentItemBasic as e on  e.BillingDocument             = a.Commid
                                                          and e.ReferenceSDDocumentCategory = 'J'
    left outer join       I_BillingDocumentItemBasic as f on  f.BillingDocument             = a.Commid
                                                          and f.SalesDocumentItemCategory = 'C'
    left outer join       zdt_deldash_hdr            as c on c.delivery = e.BillingDocument
    left outer join       I_BillingDocumentItem      as d on  d.BillingDocument          = a.Commid
    left outer join       I_SalesOrderItem           as g on g.SalesOrder = d.SalesDocument
                                                           and g.Product = d.Product
{
  key b.BillingDocument,
  f.SalesDocument,
  e.ReferenceSDDocument,
  g.MaterialByCustomer,
  d.BillingDocumentItemText,
  c.shipline,
  c.stuffdt,
  c.contno,
  d.BillingQuantityUnit,
  @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
  d.BillingQuantity ,
  @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
  sum(d.BillingQuantity) as sum_qty
}
group by b.BillingDocument,
  f.SalesDocument,
  e.ReferenceSDDocument,
  g.MaterialByCustomer,
  d.BillingDocumentItemText,
  c.shipline,
  c.stuffdt,
  c.contno,
  d.BillingQuantityUnit,
  d.BillingQuantity
