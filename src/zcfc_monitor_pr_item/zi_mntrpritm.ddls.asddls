@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Monitor Purchase Requisition Item-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MNTRPRITM
  as select distinct from ZI_MNTRPRITM_BASE


{

  key PurchaseRequisitionItem,
      PurchaseRequisition,
      PurchaseReqnCreationDate,
      CreatedByUser,
      RequisitionerName,
      Material,
      PurchaseRequisitionItemText,
      Plant,
      PlantName,
      StorageLocation,
      Supplier,
      SupplierName,
      BaseUnit,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      RequestedQuantity,
      PurReqnItemCurrency,
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      PurchaseRequisitionPrice,
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      ItemNetAmount,
      DeliveryDate,
      cast( LastChangedDate as abap.dats ) as LastChangedDate,
      AccountAssignmentCategory,
      AcctAssignmentCategoryName,
      Assigned,
      MaterialGroup,
      ProductGroupName,
      MRPController,
      MRPControllerDesc,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      OrderedQuantity,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      OpenQty,
      QtyUom,
      OpenValue

}
