@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Item Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_POITEM_BASIC
  as select distinct from I_PurchaseOrderAPI01           as a
    inner join            I_PurchaseOrderItemAPI01       as b on a.PurchaseOrder = b.PurchaseOrder
    left outer join       I_Supplier                     as c on a.Supplier = c.Supplier
    left outer join       I_UnitOfMeasure                as d on b.PurchaseOrderQuantityUnit = d.UnitOfMeasure
    left outer join       I_ProductGroupText_2           as e on b.MaterialGroup = e.ProductGroup
    left outer join       ZI_DELQTY                      as f on  b.PurchaseOrder     = f.PurchaseOrder
                                                              and b.PurchaseOrderItem = f.PurchaseOrderItem
    left outer join       ZI_INVQTY                      as g on  b.PurchaseOrder     = g.PurchaseOrder
                                                              and b.PurchaseOrderItem = g.PurchaseOrderItem
    left outer join       I_TaxCodeText                  as h on  b.TaxCode  = h.TaxCode
                                                              and h.Language = 'E'
    left outer join       I_PurchaseRequisitionItemAPI01 as i on i.PurchaseRequisition = b.PurchaseRequisition


{

  key a.PurchaseOrder,
  key b.PurchaseOrderItem,
      b.Material,
      b.PurchaseOrderItemText,
      a.Supplier,
      c.SupplierName,
      b.PurchaseOrderQuantityUnit, //hide
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      b.OrderQuantity,
      d.UnitOfMeasure_E     as ordunit,
      a.DocumentCurrency, // hide
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      b.NetAmount           as netordval,
      b.AccountAssignmentCategory,
      a.CreationDate,
      f.MaterialBaseUnit, //hide
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      f.delqty,
      h.TaxCodeName,
      f.CompanyCodeCurrency, //hide
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      f.delval,
      @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
      g.InvQty,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      g.InvVal,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      b.YY1_LastPOPrice_PDI as lastPOprice,
      b.MaterialGroup,
      e.ProductGroupText,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      b.NetPriceAmount,
      b.Plant,
      b.PurchaseRequisition,
      i.PurchaseReqnCreationDate,
      b.StorageLocation

}

where
  b.PurchasingDocumentDeletionCode <> 'L'
