@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For OC Form Item'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_OCFORM_ITEM
  as select from    I_SalesOrder          as a
    inner join      I_SalesOrderItem      as b on b.SalesOrder = a.SalesOrder
    //left outer join ZI_MATMASTERCDS       as c on b.Product = c.MaterialNo
  // and b.Plant   = c.PlantCode
  left outer join I_Product as c on b.Product = c.Product
    left outer join ZCDS_REJECTION_REASON as d on  d.SalesDocument     = a.SalesOrder
                                               and d.SalesDocumentItem = b.SalesOrderItem

{
  key  a.SalesOrder                     as OrdNo,
  key  b.SalesOrderItem                 as SoItem,
       b.Material                       as ItemCode,
       b.SalesOrderItemText             as Description,
       b.YY1_SD_SORD_MATERIAL_D_SDI     as Material,
       b.CustomerAccountAssignmentGroup as RevisionNo,
       //c.paintinfo                      as Paint,
       b.PurchaseOrderByCustomer        as PONo,
       b.CustomerPurchaseOrderDate      as PODT,
       b.OrderQuantityUnit              as QuantityUnit,
       @Semantics.quantity.unitOfMeasure : 'QuantityUnit'
       b.OrderQuantity                  as Quantity,
       @Semantics.quantity.unitOfMeasure : 'QuantityUnit'
       c.NetWeight                    as UnitWt,
       b.YY1_SD_SORD_rate_SDI           as Rate,
       b.TransactionCurrency            as Curr,
       @Semantics.amount.currencyCode : 'Curr'
       b.NetAmount                      as Total

}
where
  d.SalesDocumentRjcnReasonName is null
