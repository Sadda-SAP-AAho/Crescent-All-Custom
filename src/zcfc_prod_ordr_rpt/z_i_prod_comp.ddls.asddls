@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Prod Order Component'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PROD_COMP
  provider contract transactional_query
  as projection on I_ProductionOrderOpComponentTP as Component
{
      // Key
  key Reservation,
  key ReservationItem,
  key ReservationRecordType,

      //Material data
      MaterialGroup,
      Material,
      Plant,

      // Order data
      ProductionOrder,
      ProductionOrderSequence,
      SequenceCategory,
      ProductionOrderOperation,

      OrderInternalID,
      OrderOperationInternalID,

      // Text
      @Semantics.text: true
      MaterialComponentText,
      @Semantics.text: true
      MaterialComponentSecondText,
      MaterialComponentHasLongText,
      LongTextLanguage,

      // Date and Time
      @Semantics.businessDate.at: true
      MatlCompRequirementDate,
      MatlCompRequirementTime,
      LatestRequirementDate,

      // Attributes
      ReservationItemCreationCode,
      ReservationIsFinallyIssued,
      //      @Semantics.booleanIndicator
      //      MatlCompIsMarkedForDeletion,
      MaterialComponentIsMissing,
      IsBulkMaterialComponent,
      MatlCompIsMarkedForBackflush,
      MatlCompIsTextItem,
      MaterialPlanningRelevance,
      MatlCompIsConfigurable,
      MaterialCompCostingRelevancy,
      MaterialComponentIsClassified,
      MaterialCompIsIntraMaterial,
      MaterialIsDirectlyProduced,
      MaterialIsDirectlyProcured,

      // Assignments
      RequirementType,
      SalesOrder,
      SalesOrderItem,
      WBSElementInternalID,
      ProductConfiguration,
      ChangeNumber,
      EffectivityParameterVariant,
      MatlCompFreeDefinedAttribute,

      // Assignments BOM
      BillOfMaterialCategory,
      BillOfMaterialInternalID,
      BillOfMaterialVariant,
      BillOfMaterialItemNodeNumber,
      BillOfMaterialVersion,
      BOMItemInternalChangeCount,
      InheritedBOMItemNode,
      BillOfMaterialItemCategory,
      BillOfMaterialItemNumber,
      BOMExplosionDateID,

      // Assignments Purchasing
      PurchasingInfoRecord,
      PurchasingGroup,
      PurchaseRequisition,
      PurchaseRequisitionItem,
      PurchaseOrder,
      PurchaseOrderItem,
      Supplier,
      DeliveryDurationInDays,
      MaterialGoodsReceiptDuration,
      @Semantics.amount.currencyCode: 'Currency'
      ExternalProcessingPrice,
      NumberOfOperationPriceUnits,

      // Goods Movement data
      GoodsMovementIsAllowed,
      StorageLocation,
      Batch,
      BatchSplitType,
      DebitCreditCode,
      GoodsMovementType,
      InventorySpecialStockType,
      InventorySpecialStockValnType,
      ConsumptionPosting,
      SupplyArea,
      @Semantics.text: true
      GoodsRecipientName,
      @Semantics.text: true
      UnloadingPointName,
      StockSegment,
      RequirementSegment,

      // Assignments FI/CO
      BusinessArea,
      GLAccount,
      FunctionalArea,
      AccountAssignmentCategory,

      // Variable-size item data
      MaterialCompIsVariableSized,
      VariableSizeItemUnit,
      @Semantics.quantity.unitOfMeasure: 'VariableSizeItemUnit'
      VariableSizeItemQuantity,
      VariableSizeComponentUnit,
      @Semantics.quantity.unitOfMeasure: 'VariableSizeComponentUnit'
      VariableSizeComponentQuantity,
      VariableSizeDimensionUnit,
      @Semantics.quantity.unitOfMeasure: 'VariableSizeDimensionUnit'
      VariableSizeDimension1,
      @Semantics.quantity.unitOfMeasure: 'VariableSizeDimensionUnit'
      VariableSizeDimension2,
      @Semantics.quantity.unitOfMeasure: 'VariableSizeDimensionUnit'
      VariableSizeDimension3,
      VariableSizeCompFormulaKey,

      // Phantom assembly
      MaterialComponentIsPhantomItem,
      OrderPathValue,
      OrderLevelValue,

      // Discontinuation
      DiscontinuationGroup,
      MatlCompDiscontinuationType,
      MatlCompIsFollowUpMaterial,
      FollowUpGroup,
      FollowUpMaterial,
      FollowUpMaterialIsActive,

      // Alternative item data
      MaterialCompIsAlternativeItem,
      AlternativeItemGroup,
      AlternativeItemStrategy,
      AlternativeItemPriority,
      UsageProbabilityPercent,

      // Others
      MatlComponentSparePartType,
      MaterialProvisionType,

      // Lead-Time offset
      LeadTimeOffset,
      OperationLeadTimeOffsetUnit,
      OperationLeadTimeOffset,

      // Quantities and UoM
      QuantityIsFixed,
      IsNetScrap,
      ComponentScrapInPercent,
      OperationScrapInPercent,
      MaterialQtyToBaseQtyNmrtr,
      MaterialQtyToBaseQtyDnmntr,
      BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      RequiredQuantity,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      WithdrawnQuantity,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      ConfirmedAvailableQuantity,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      MaterialCompOriginalQuantity,

      EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      GoodsMovementEntryQty,

      // Amount and Currency
      Currency,
      @Semantics.amount.currencyCode: 'Currency'
      WithdrawnQuantityAmount,

      // Associations
      _ProductionOrder,

      @Consumption.hidden: true
      _Supplier,              // for DCLS
      @Consumption.hidden: true
      _SupplierCompanyByPlant // for DCLS
};
