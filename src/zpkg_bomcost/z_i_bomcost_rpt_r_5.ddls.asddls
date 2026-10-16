@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_I_BOMCOST_RPT_R_5'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_BOMCOST_RPT_R_5
  provider contract transactional_query
  as projection on I_ProdnRoutingSequenceTP_2 as bomcost5
{
  key ProductionRoutingGroup,
  key ProductionRouting,
  key ProductionRoutingSequence,
  key ProductionRoutingSqncIntVers,
      IsDeleted,
      IsImplicitlyDeleted,
      ChangeNumber,
      ValidityStartDate,
      ValidityEndDate,
      SequenceCategory,
      BillOfOperationsRefSequence,
      BOOSqncBranchOpInternalID,
      BOOSqncReturnOpInternalID,
      @Semantics.quantity.unitOfMeasure: 'BillOfOperationsUnit'
      MinimumLotSizeQuantity,
      @Semantics.quantity.unitOfMeasure: 'BillOfOperationsUnit'
      MaximumLotSizeQuantity,
      BillOfOperationsUnit,
      SequenceText,
      CreationDate,
      CreatedByUser,
      LastChangeDate,
      LastChangedByUser,
      ChangedDateTime
}
