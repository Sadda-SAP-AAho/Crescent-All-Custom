@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Plan'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_GRPO_REP
  provider contract transactional_query
  as projection on I_MaterialDocumentItemTP as a

{
  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,
      MaterialDocumentLine,
      MaterialDocumentParentLine,
      GoodsMovementType,
      Material,
      Plant,
      StorageLocation,
      InventoryUsabilityCode,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      QuantityInEntryUnit,
      EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      QuantityInBaseUnit,
      MaterialBaseUnit,
      Batch,
      ShelfLifeExpirationDate,
      ManufactureDate,
      InventorySpecialStockType,
      Customer,
      Supplier,
      InventoryStockType,
      InventoryValuationType,
      AccountAssignmentCategory,
      ReversedMaterialDocumentYear,
      ReversedMaterialDocument,
      ReversedMaterialDocumentItem,
      GoodsMovementIsCancelled,
      FiscalYearPeriod,
      FiscalYearVariant,
      IsAutomaticallyCreated,
      MaterialDocumentPostingType,
      ReservationItemRecordType,
      DebitCreditCode,
      IssgOrRcvgMaterial,
      IssuingOrReceivingPlant,
      IssuingOrReceivingStorageLoc,
      IssgOrRcvgBatch,
      IssgOrRcvgSpclStockInd,
      IssuingOrReceivingValType,
      WBSElementInternalID,
      Reservation,
      ReservationItem,
      GoodsMovementRefDocType,
      GoodsMovementReasonCode,
      PurchaseOrder,
      PurchaseOrderItem,
      IsCompletelyDelivered,
      SerialNumbersAreCreatedAutomly,
      CostCenter,
      GLAccount,
      ProfitCenter,
      SalesOrder,
      SalesOrderItem,
      SalesOrderScheduleLine,
      DeliveryDocument,
      DeliveryDocumentItem,
      GoodsRecipientName,
      UnloadingPointName,
      ReservationIsFinallyIssued,
      ManufacturingOrder,
      ManufacturingOrderItem,
      SpecialStockIdfgSalesOrder,
      SpecialStockIdfgSalesOrderItem,
      MaterialDocumentItemText,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      GdsMvtExtAmtInCoCodeCrcy,
      ProductStandardID,
      CompanyCodeCurrency,
      ReferenceDocumentFiscalYear,
      InvtryMgmtRefDocumentItem,
      InvtryMgmtReferenceDocument,
      YY1_VehicleNumber_MMI,
      YY1_UoM_MMI,
      YY1_GateEntryNumber_MMI,
      YY1_TransporterName_MMI,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      YY1_TareWeight_MMI,
      YY1_TareWeight_MMIU,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      YY1_NetWeight_MMI,
      YY1_NetWeight_MMIU,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      YY1_GrossWeight_MMI,
      YY1_GrossWeight_MMIU,
      YY1_ChallanNumber_MMI,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      YY1_ChallanQuantity_MMI,
      YY1_ChallanQuantity_MMIU,
      YY1_ChallanDate_MMI,
      YY1_OperationDesc_MMI,
      YY1_PlantQuantity_MMI
}
