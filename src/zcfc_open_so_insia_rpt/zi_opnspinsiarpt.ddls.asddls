@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Open SO Report - Insia'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_OPNSPINSIARPT
  as select distinct from ZI_OPENSORPT as a
    inner join            I_SalesOrder as b on a.SalesOrder = b.SalesOrder

{
  key       a.SoldToParty                                                                                    as cust_code,
  key       a.SalesOrder,
  key       a.Product                                                                                        as matcode,
  key       a.SalesOrderItemText                                                                             as matdes,
  key       a.PurchaseOrderByCustomer                                                                        as Cust_PO_No,
            a.UnderlyingPurchaseOrderItem                                                                    as Cust_PO_Line_No,
            a.MaterialByCustomer                                                                             as custdes,
            a.salesdate                                                                                      as salesdate,
            b.CreationDate                                                                                   as createdate,
            b.LastChangeDate                                                                                 as updatedate,
            a.OrderQuantityUnit,
            @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
            sum( cast (a.OrderQuantity as abap.dec(15,3) ) )                                                 as OrderQty,
            a.WeightUnit,
            sum( cast ( a.OrderQuantity as abap.dec( 15, 3 ) ) * cast ( a.NetWeight as abap.dec( 15, 3 ) ) ) as Order_wt,
            @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
            sum( cast (a.delqty as abap.dec(15,3) ) )                                                        as DelQty,
            sum( cast ( a.delqty as abap.dec( 15, 3 ) ) * cast ( a.NetWeight as abap.dec( 15, 3 ) ) )        as Delivered_Wt,
            @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
            sum( cast (a.balanceqty as abap.dec(15,3) ) )                                                    as BalQty,
            sum( cast ( a.balanceqty as abap.dec( 15, 3 ) ) * cast ( a.NetWeight as abap.dec( 15, 3 ) ) )    as Balance_Wt




}

where
  a.Product <> 'SLAG'

group by
  a.SoldToParty,
  a.SalesOrder,
  a.Product,
  a.SalesOrderItemText,
  a.PurchaseOrderByCustomer,
  a.UnderlyingPurchaseOrderItem,
  a.MaterialByCustomer,
  a.salesdate,
  b.CreationDate,
  b.LastChangeDate,
  a.OrderQuantityUnit,
  a.WeightUnit
