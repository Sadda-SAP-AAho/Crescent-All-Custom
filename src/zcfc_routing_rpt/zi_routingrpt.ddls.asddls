@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Routing Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_ROUTINGRPT
  as select distinct from I_ManufacturingOrderOperation as a
    left outer join       ZI_PRODORDRRPT                as b on a.ManufacturingOrder = b.ProductionOrder

{
  key   a.MfgOrderInternalID,
  key   a.OrderOperationInternalID,
  key   a.ManufacturingOrder,
  key   b.ProductionOrderItem,
  key   b.Product,
        b.OpenYieldQuantity,
        a.ManufacturingOrderOperation,
        a.Plant,
        a.MfgOrderOperationText,
        a.OperationControlProfile,
        a.WorkCenterStandardWorkQtyUnit1,
        @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'
        a.WorkCenterStandardWorkQty1,
        a.CostCtrActivityType1,
        a.WorkCenterStandardWorkQtyUnit2,
        @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit2'
        a.WorkCenterStandardWorkQty2,
        a.CostCtrActivityType2,
        a.WorkCenterStandardWorkQtyUnit3,
        @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit3'
        a.WorkCenterStandardWorkQty3,
        a.CostCtrActivityType3,
        a.WorkCenterStandardWorkQtyUnit4,
        @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit4'
        a.WorkCenterStandardWorkQty4,
        a.CostCtrActivityType4,
        a.WorkCenterStandardWorkQtyUnit5,
        @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit5'
        a.WorkCenterStandardWorkQty5,
        a.CostCtrActivityType5,
        a.WorkCenterStandardWorkQtyUnit6,
        @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit6'
        a.WorkCenterStandardWorkQty6,
        a.CostCtrActivityType6,
        a.EarliestScheduledWaitStartDate


}
where
  b.OpenYieldQuantity <> 0
