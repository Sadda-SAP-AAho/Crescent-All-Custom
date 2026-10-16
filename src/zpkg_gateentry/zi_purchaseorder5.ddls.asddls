@AbapCatalog.sqlViewName: 'ZWEAW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gaate'
@Metadata.ignorePropagatedAnnotations: true
define view zi_purchaseorder5
  as select from    zi_purchaseorder2             as a
    left outer join I_POSupplierConfirmationAPI01 as b on(
      a.DeliveryDocument         = b.DeliveryDocument
      and a.DeliveryDocumentItem = b.DeliveryDocumentItem
    )
    left outer join ZI_GITEM                      as c on(
      c.Ebeln      =  b.DeliveryDocument
      and c.Ebelp = substring(
        b.DeliveryDocumentItem, 2, 6
      )
    )
{
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,
      case when c.Ebeln is not null or c.Ebeln is not initial
      then 'DEL'
      else 
      a.Vendorcode
      end as Vendorcode,
      a.Material,
      a.PurchaseOrderItemText,
      a.OrderQuantity,
      a.PurchaseOrderQuantityUnit,
      a.DeliveryDocument,
      a.DeliveryDocumentItem,
      a.OverallSDProcessStatus,
      a.ActualDeliveryQuantity,
      a.bal_qty,
      c.Ebelp
}
