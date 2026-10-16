@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Lot Status Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_INSPLOTSTATRPT
  as select distinct from I_InspectionLot       as a
    inner join            I_InspLotSerialNumber as b on a.InspectionLot = b.InspectionLot
    left outer join       ZI_INSPRSLTRCD        as c on  a.InspectionLot = c.InspectionLot
                                                     and b.SerialNumber  = c.SerialNumber
    left outer join       ZI_MATMOVE_101        as d on  a.Material      = d.Material
                                                     and a.Plant         = d.Plant
                                                     and a.InspectionLot = d.InspectionLot
                                                     and b.SerialNumber  = d.SerialNumber

    left outer join       ZI_MATMOVE_321        as e on  a.Material      = e.Material
                                                     and a.Plant         = e.Plant
                                                     and a.InspectionLot = e.InspectionLot
                                                     and b.SerialNumber  = e.SerialNumber

{
  key a.Material,
  key a.Plant,
  key a.InspectionLot,
  key b.SerialNumber,
      a.InspectionLotQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
      a.InspectionLotQuantity,
      @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
      a.InspectionLotActualQuantity,
      @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
      a.InspectionLotDefectiveQuantity,
      @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
      a.InspLotQtyInspected,
      a.NumberOfSerialNumbers,
      @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
      a.InspLotQtyToBePosted,
      @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
      a.InspLotQtyToFree,
      ( case when a.InspectionLotHasUsageDecision = 'X' then 'Yes'
             else 'No' end )                                               as UsageDecision,
      c. ResultRecord,
      ( case when d.SerialNumber is not initial then 'Yes' else 'No' end ) as RecvdInInsp,
      ( case when e.SerialNumber is not initial then 'Yes' else 'No' end ) as RecvdInUnrestricted



}
