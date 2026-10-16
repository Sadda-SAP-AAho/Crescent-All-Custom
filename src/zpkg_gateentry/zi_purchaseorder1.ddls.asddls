@AbapCatalog.sqlViewName: 'ZIPORDERITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'purchase order1'
define view zi_purchaseorder1
  as select distinct from I_PurchaseOrderAPI01     as A
    inner join            I_PurchaseOrderItemAPI01 as B on B.PurchaseOrder = A.PurchaseOrder
  // inner join            zi_ghead                 as c on c.Vendorcode = A.Supplier



{
  key A.PurchaseOrder,
  key B.PurchaseOrderItem,
      // key F.DeliveryDocument,
      B.Material,
      B.PurchaseOrderItemText,
      B.OrderQuantity,
      B.PurchaseOrderQuantityUnit,
      A.Supplier as Vendorcode,
      A.CompanyCode,
      B.SupplierConfirmationControlKey,
      A.PurchaseOrderType,
      B.Plant,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      B.NetAmount,
      B.NetPriceAmount,
      B.DocumentCurrency,
      A.ReleaseIsNotCompleted

}
where

      B.PurchasingDocumentDeletionCode = ''
  and B.IsCompletelyDelivered          = ''
  and A.ReleaseIsNotCompleted = ''
union select distinct from I_PurchaseOrderAPI01        as A
  inner join               I_PurchaseOrderItemAPI01    as B on B.PurchaseOrder = A.PurchaseOrder
//  inner join               zi_ghead                    as c on A.SupplyingPlant = substring(
//    c.Vendorcode, 7, 4
//  )

  inner join               I_PurchaseOrderHistoryAPI01 as f on  f.PurchaseOrder     = A.PurchaseOrder
                                                            and B.PurchaseOrderItem = f.PurchaseOrderItem
  inner join               I_DeliveryDocument          as D on D.DeliveryDocument = f.DeliveryDocument
  inner join               I_DeliveryDocumentItem      as E on  E.DeliveryDocument     = f.DeliveryDocument
                                                            and E.DeliveryDocumentItem = f.DeliveryDocumentItem


{
  key A.PurchaseOrder,
  key B.PurchaseOrderItem,
      // key F.DeliveryDocument,
      B.Material,
      B.PurchaseOrderItemText,
      B.OrderQuantity,
      B.PurchaseOrderQuantityUnit,
      A.Supplier as Vendorcode,
      A.CompanyCode,
      B.SupplierConfirmationControlKey,
      A.PurchaseOrderType,
      B.Plant,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      B.NetAmount,
      B.NetPriceAmount,
      B.DocumentCurrency,
      A.ReleaseIsNotCompleted

}
where

      B.PurchasingDocumentDeletionCode = ''
  and B.IsCompletelyDelivered          = ''
  and A.ReleaseIsNotCompleted = ''
