@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_I_BOMCOST_RPT_R_4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_BOMCOST_RPT_R_4
  provider contract transactional_query
  as projection on I_ProdnRoutingOperationTP_2 as bomcost4
{
  key ProductionRoutingGroup,
  key ProductionRouting,
  key ProductionRoutingSequence,
  key ProductionRoutingOpIntID,
  key ProductionRoutingOpIntVersion,
      Operation,
      CreationDate,
      CreatedByUser,
      LastChangeDate,
      LastChangedByUser,
      ChangeNumber,
      ValidityStartDate,
      ValidityEndDate,
      IsDeleted,
      IsImplicitlyDeleted,
      OperationText,
      LongTextLanguageCode,
      Plant,
      OperationControlProfile,
      OperationStandardTextCode,
      WorkCenterTypeCode,
      WorkCenterInternalID,
      CapacityCategoryCode,
      CostElement,
      OperationCostingRelevancyType,
      NumberOfTimeTickets,
      NumberOfConfirmationSlips,
      EmployeeWageGroup,
      EmployeeWageType,
      EmployeeSuitability,
      NumberOfEmployees,
      BillOfOperationsRefType,
      BillOfOperationsRefGroup,
      BillOfOperationsRefVariant,
      LineSegmentTakt,
      OperationStdWorkQtyGrpgCat,
      OrderHasNoSubOperations,
      OperationSetupType,
      OperationSetupGroupCategory,
      OperationSetupGroup,
      BOOOperationIsPhase,
      BOOPhaseSuperiorOpInternalID,
      ControlRecipeDestination,
      OpIsExtlyProcdWithSubcontrg,
      PurchasingInfoRecord,
      PurchasingOrganization,
      PurchaseContract,
      PurchaseContractItem,
      PurchasingInfoRecdAddlGrpgName,
      MaterialGroup,
      PurchasingGroup,
      Supplier,
      PlannedDeliveryDuration,
      NumberOfOperationPriceUnits,
      OpExternalProcessingCurrency,
      @Semantics.amount.currencyCode: 'OpExternalProcessingCurrency'
      OpExternalProcessingPrice,
      InspectionLotType,
      InspResultRecordingView,
      InspSbstCompletionConfirmation,
      InspSbstHasNoTimeOrQuantity,
      @Semantics.quantity.unitOfMeasure: 'OperationUnit'
      OperationReferenceQuantity,
      OperationUnit,
      OperationScrapPercent,
      OpQtyToBaseQtyNmrtr,
      OpQtyToBaseQtyDnmntr,
      @Semantics.quantity.unitOfMeasure: 'StandardWorkQuantityUnit1'
      StandardWorkQuantity1,
      StandardWorkQuantityUnit1,
      CostCtrActivityType1,
      PerfEfficiencyRatioCode1,
      @Semantics.quantity.unitOfMeasure: 'StandardWorkQuantityUnit1'
      StandardWorkQuantity2,
      StandardWorkQuantityUnit2,
      CostCtrActivityType2,
      PerfEfficiencyRatioCode2,
      @Semantics.quantity.unitOfMeasure: 'StandardWorkQuantityUnit1'
      StandardWorkQuantity3,
      StandardWorkQuantityUnit3,
      CostCtrActivityType3,
      PerfEfficiencyRatioCode3,
      @Semantics.quantity.unitOfMeasure: 'StandardWorkQuantityUnit1'
      StandardWorkQuantity4,
      StandardWorkQuantityUnit4,
      CostCtrActivityType4,
      PerfEfficiencyRatioCode4,
      @Semantics.quantity.unitOfMeasure: 'StandardWorkQuantityUnit1'
      StandardWorkQuantity5,
      StandardWorkQuantityUnit5,
      CostCtrActivityType5,
      PerfEfficiencyRatioCode5,
      @Semantics.quantity.unitOfMeasure: 'StandardWorkQuantityUnit1'
      StandardWorkQuantity6,
      StandardWorkQuantityUnit6,
      CostCtrActivityType6,
      PerfEfficiencyRatioCode6,
      BusinessProcess,
      LeadTimeReductionStrategy,
      TeardownAndWaitIsParallel,
      @Semantics.quantity.unitOfMeasure: 'BreakDurationUnit'
      BillOfOperationsBreakDuration,
      BreakDurationUnit,
      @Semantics.quantity.unitOfMeasure: 'MaximumWaitDurationUnit'
      MaximumWaitDuration,
      MaximumWaitDurationUnit,
      @Semantics.quantity.unitOfMeasure: 'MaximumWaitDurationUnit'
      MinimumWaitDuration,
      MinimumWaitDurationUnit,
      @Semantics.quantity.unitOfMeasure: 'MaximumWaitDurationUnit'
      StandardQueueDuration,
      StandardQueueDurationUnit,
      @Semantics.quantity.unitOfMeasure: 'MaximumWaitDurationUnit'
      MinimumQueueDuration,
      MinimumQueueDurationUnit,
      @Semantics.quantity.unitOfMeasure: 'MaximumWaitDurationUnit'
      StandardMoveDuration,
      StandardMoveDurationUnit,
      @Semantics.quantity.unitOfMeasure: 'MaximumWaitDurationUnit'
      MinimumMoveDuration,
      MinimumMoveDurationUnit,
      OperationSplitIsRequired,
      MaximumNumberOfSplits,
      @Semantics.quantity.unitOfMeasure: 'MinProcessingDurnPerSplitUnit'
      MinProcessingDurationPerSplit,
      MinProcessingDurnPerSplitUnit,
      OperationOverlappingIsRequired,
      OperationOverlappingIsPossible,
      OperationsIsAlwaysOverlapping,
      OperationHasNoOverlapping,
      @Semantics.quantity.unitOfMeasure: 'OverlapMinimumDurationUnit'
      OverlapMinimumDuration,
      OverlapMinimumDurationUnit,
      @Semantics.quantity.unitOfMeasure: 'OverlapMinimumTransferQtyUnit'
      OverlapMinimumTransferQty,
      OverlapMinimumTransferQtyUnit,
      FactoryCalendar,
      ChangedDateTime,
      PlainLongText
}
