@AbapCatalog.sqlViewName: 'ZPO22'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'purchase order quantity'
define view zi_purchaseorder2
  as select distinct from zi_purchaseorder1           as a
    left outer join       I_PurchaseOrderHistoryAPI01 as f on  f.PurchaseOrder     = a.PurchaseOrder
                                                           and a.PurchaseOrderItem = f.PurchaseOrderItem
    left outer join       I_DeliveryDocument          as b on b.DeliveryDocument = f.DeliveryDocument
    left outer join       I_DeliveryDocumentItem      as c on  c.DeliveryDocument     = f.DeliveryDocument
                                                           and c.DeliveryDocumentItem = f.DeliveryDocumentItem
    left outer join       I_PurOrdScheduleLineAPI01   as e on  e.PurchaseOrder     = a.PurchaseOrder
                                                           and e.PurchaseOrderItem = a.PurchaseOrderItem
    left outer join       ZI_PurchaseOrderItem_vendor as d on  d.PurchaseOrder     = a.PurchaseOrder
                                                           and d.PurchaseOrderItem = a.PurchaseOrderItem

    left outer join       ZI_GITEM                    as h on  h.Vbeln = c.DeliveryDocument
                                                           and h.Vbelp = c.DeliveryDocumentItem

    left outer join       ZR_BALANCEQTY_2             as z on  z.Ebeln = a.PurchaseOrder
                                                           and z.Ebelp = a.PurchaseOrderItem
    left outer join       zdelqtypo                   as y on  y.ebeln = a.PurchaseOrder
                                                           and y.ebelp = a.PurchaseOrderItem
    left outer join       ZR_BALQTY_GRN               as x on  x.Ebeln = a.PurchaseOrder
                                                           and x.Ebelp = a.PurchaseOrderItem

  //    left outer join       ZI_qrscan_hrd1              as qr on qr.Deliveryorder = b.DeliveryDocument
    left outer join       ZTF_PO_LT                   as p on  p.PurchaseOrder     = a.PurchaseOrder
                                                           and p.PurchaseOrderItem = a.PurchaseOrderItem

{
  a.PurchaseOrder                                               as PurchaseOrder,
  a.PurchaseOrderItem                                           as PurchaseOrderItem,
  a.Vendorcode                                                  as Vendorcode,
  a.Material                                                    as Material,
  a.PurchaseOrderItemText                                       as PurchaseOrderItemText,
  p.PlainLongText,
  a.OrderQuantity,
  a.PurchaseOrderQuantityUnit                                   as PurchaseOrderQuantityUnit,
  b.DeliveryDocument                                            as deliverydocument,
  c.DeliveryDocumentItem                                        as deliverydocumentitem,
  b.OverallSDProcessStatus                                      as OverallSDProcessStatus,
  ( coalesce( y.challanqty , 0 ) - coalesce( x.reve_qty , 0 ) ) as ActualDeliveryQuantity, //c.ActualDeliveryQuantity,
  case when z.OrderQuantity > 0 and y.challanqty > 0 and x.reve_qty > 0
  then z.OrderQuantity - y.challanqty + x.reve_qty
  when z.OrderQuantity > 0 and y.challanqty > 0 and x.reve_qty is null
  then z.OrderQuantity - y.challanqty
  when z.OrderQuantity is null and y.challanqty > 0 and x.reve_qty > 0
  then ( ( -1 ) * y.challanqty ) + x.reve_qty
  when z.OrderQuantity is null and y.challanqty > 0 and x.reve_qty is null
  then ( ( -1 ) * y.challanqty )
  when z.OrderQuantity > 0 and y.challanqty is null and x.reve_qty > 0
  then z.OrderQuantity + x.reve_qty
  when z.OrderQuantity > 0 and y.challanqty is null and x.reve_qty is null
  then z.OrderQuantity  end                                     as bal_qty,
  z.Ebeln,
  h.Meins,
  PurchaseOrderType,
  b.DeliveryDocumentBySupplier,
  a.Plant,
  b.BillOfLading,
  //  qr.Vehicleno,
  //  qr.Transname,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  a.NetAmount,
  a.NetPriceAmount,
  a.DocumentCurrency,
  b.UnloadingPointName,
  a.ReleaseIsNotCompleted

}
where
      a.PurchaseOrder                  = d.PurchaseOrder
  and a.PurchaseOrderItem              = d.PurchaseOrderItem
  and a.SupplierConfirmationControlKey is initial
  and a.PurchaseOrder                  is not initial

union select distinct from zi_purchaseorder1             as a
  left outer join          I_POSupplierConfirmationAPI01 as f on  f.PurchaseOrder     = a.PurchaseOrder
                                                              and a.PurchaseOrderItem = f.PurchaseOrderItem
  left outer join          I_DeliveryDocument            as b on b.DeliveryDocument = f.DeliveryDocument
  left outer join          I_DeliveryDocumentItem        as c on c.DeliveryDocument = f.DeliveryDocument
  left outer join          I_PurOrdScheduleLineAPI01     as e on  e.PurchaseOrder     = a.PurchaseOrder
                                                              and e.PurchaseOrderItem = a.PurchaseOrderItem
  left outer join          ZI_PurchaseOrderItem_vendor   as d on  d.PurchaseOrder     = a.PurchaseOrder
                                                              and d.PurchaseOrderItem = a.PurchaseOrderItem
  left outer join          I_POSupplierConfirmationAPI01 as g on  g.PurchaseOrder     = a.PurchaseOrder
                                                              and g.PurchaseOrderItem = a.PurchaseOrderItem
  left outer join          ZI_GITEM                      as h on  h.Vbeln = c.DeliveryDocument
                                                              and h.Vbelp = c.DeliveryDocumentItem
  left outer join          ZR_BALANCEQTY_2               as z on  z.Ebeln = a.PurchaseOrder
                                                              and z.Ebelp = a.PurchaseOrderItem
  left outer join          ZR_BALQTY_GRN                 as x on  x.Ebeln = a.PurchaseOrder
                                                              and x.Ebelp = a.PurchaseOrderItem
//  left outer join          ZI_qrscan_hrd1                as qr on qr.Deliveryorder = b.DeliveryDocument
  left outer join          ZTF_PO_LT                     as p on  p.PurchaseOrder     = a.PurchaseOrder
                                                              and p.PurchaseOrderItem = a.PurchaseOrderItem
{
  a.PurchaseOrder                                                           as PurchaseOrder,
  a.PurchaseOrderItem                                                       as PurchaseOrderItem,
  a.Vendorcode                                                              as Vendorcode,
  a.Material                                                                as Material,
  a.PurchaseOrderItemText                                                   as PurchaseOrderItemText,
  p.PlainLongText,
  a.OrderQuantity,
  a.PurchaseOrderQuantityUnit                                               as PurchaseOrderQuantityUnit,
  b.DeliveryDocument                                                        as deliverydocument,
  c.DeliveryDocumentItem                                                    as deliverydocumentitem,
  b.OverallSDProcessStatus                                                  as OverallSDProcessStatus,
  //  c.ActualDeliveryQuantity,
  ( coalesce( c.ActualDeliveryQuantity , 0 ) - coalesce( x.reve_qty , 0 ) ) as ActualDeliveryQuantity,
  case when z.OrderQuantity > 0 and z.challanqty > 0
  then z.OrderQuantity - z.challanqty - x.reve_qty
  when z.OrderQuantity is null and z.challanqty > 0
  then ( ( -1 ) * z.challanqty ) - x.reve_qty
  when z.OrderQuantity > 0 and z.challanqty is null
  then z.OrderQuantity - x.reve_qty end                                     as bal_qty,
  z.Ebeln,
  h.Meins,
  PurchaseOrderType,
  b.DeliveryDocumentBySupplier,
  a.Plant,
  b.BillOfLading,
  //  qr.Vehicleno,
  //  qr.Transname,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  a.NetAmount,
  a.NetPriceAmount,
  a.DocumentCurrency,
  b.UnloadingPointName,
  a.ReleaseIsNotCompleted



}
where
      b.OverallGoodsMovementStatus <> 'C'
  and f.PurchaseOrder              =  d.PurchaseOrder
  and f.PurchaseOrderItem          =  d.PurchaseOrderItem
  and a.PurchaseOrder              is not initial
