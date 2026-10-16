@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report - INSIA'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_OTIFINSIA
  as select distinct from ZI_SD_OTIF_REPORT_FIN as a
    inner join            I_SalesOrder          as b on a.SalesOrder = b.SalesOrder
    left outer join       I_CustomerMaterial_2  as c on c.Product = a.Product
{
  key a.SalesOrder                    as SO_No,
  key a.SalesOrderItem                as SO_Line_No,
  key a.DeliveryDocument              as Delv_No,
  key a.DeliveryDocumentItem          as Delv_Line_No,
      a.CreationDate                  as SO_Date,
      a.CreationDate                  as SO_Creation_Date,
      b.LastChangeDate                as SO_Update_Date,
      a.SoldToParty                   as Customer,
      a.Product                       as Mat_No,
      a.SalesOrderItemText            as Description,
      c.MaterialByCustomer            as Customer_Matl_Desc,
      a.ScheduleLineOrderQuantity     as Quantity,
      a.DeliveredQtyInOrderQtyUnit    as Delivered_Qty,
      a.OpenConfdDelivQtyInOrdQtyUnit as Open_Qty,
      a.PurchaseOrderByCustomer       as Customer_PO_No,
      a.CustomerPurchaseOrderDate     as Customer_PO_Date,
      a.ConfirmedDeliveryDate         as Our_Comm_Date,
      a.otifamt                       as OTIF
}
