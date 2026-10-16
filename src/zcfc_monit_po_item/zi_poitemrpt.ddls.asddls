@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Item Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_POITEMRPT
  as select distinct from I_PurchaseOrderAPI01           as a
    inner join            I_PurchaseOrderItemAPI01       as b on a.PurchaseOrder = b.PurchaseOrder
    left outer join       I_Supplier                     as c on a.Supplier = c.Supplier
    left outer join       I_ProductGroupText_2           as e on  b.MaterialGroup = e.ProductGroup
                                                              and e.Language      = 'E'
    left outer join       ZI_DELQT                       as f on  b.PurchaseOrder     = f.PurchaseOrder
                                                              and b.PurchaseOrderItem = f.PurchaseOrderItem
    left outer join       ZI_INVQT                       as g on  b.PurchaseOrder     = g.PurchaseOrder
                                                              and b.PurchaseOrderItem = g.PurchaseOrderItem
    inner join            ZI_QTYTOBEDEL                  as h on  b.PurchaseOrder     = h.PurchaseOrder
                                                              and b.PurchaseOrderItem = h.PurchaseOrderItem
    left outer join       ZI_VALTOBEINV                  as i on  b.PurchaseOrder     = i.PurchaseOrder
                                                              and b.PurchaseOrderItem = i.PurchaseOrderItem
    left outer join       ZTBL_PO_ITEM_TEXT              as j on  a.PurchaseOrder     = j.PurchaseOrder
                                                              and b.PurchaseOrderItem = j.PurchaseOrderItem
                                                              and j.Language          = 'E'
                                                              and j.TextObjectType    = 'F01'
    left outer join       I_PurchaseRequisitionItemAPI01 as k on k.PurchaseRequisition = b.PurchaseRequisition


{

  key a.PurchaseOrder,
  key b.PurchaseOrderItem,
      b.Material,
      b.PurchaseOrderItemText                       as ShortText,
      j.PlainLongText                               as POItemText,
      a.Supplier,
      c.SupplierName,
      b.PurchaseOrderQuantityUnit, //hide

      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      ( case when b.IsReturnsItem is not initial then  b.OrderQuantity * (-1)
             else b.OrderQuantity end )             as OrderQuantity,

      ( case when b.IsReturnsItem is initial then h.QtytobeDel
             else cast( 0 as abap.dec(12,3) ) end ) as QtytobeDel,

      a.DocumentCurrency, // hide

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      ( case when b.IsReturnsItem is not initial then  b.NetAmount * (-1)
             else b.NetAmount end )                 as netordval,

      ( case when b.IsReturnsItem is initial then  i.AmttobeInv
             else cast( 0 as abap.dec(12,3) ) end ) as AmttobeInv,

      b.AccountAssignmentCategory,

      a.CreationDate,

      f.MaterialBaseUnit, //hide

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ( case when b.IsReturnsItem is not initial then  b.OrderQuantity * (-1)
             else f.delqty end )                    as delqty,

      f.CompanyCodeCurrency, //hide

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ( case when b.IsReturnsItem is not initial then  b.NetAmount * (-1)
             else f.delval end )                    as delval,

      @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
      ( case when b.IsReturnsItem is not initial then  b.OrderQuantity * (-1)
             else g.InvQty end )                    as InvQty,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      ( case when b.IsReturnsItem is not initial then  ( cast(b.NetAmount as abap.dec(12,3)) * (-1) )
             else g.InvVal end )                    as InvVal,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      b.YY1_LastPOPrice_PDI                         as lastPOprice,

      b.MaterialGroup,
      e.ProductGroupText,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      b.NetPriceAmount,
      b.Plant,
      b.PurchaseRequisition,
      k.PurchaseReqnCreationDate,
      b.StorageLocation


}
