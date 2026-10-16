@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Routing report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_ROUTINGRPT
  provider contract transactional_query
  as projection on ZI_ROUTINGRPT
{
        @EndUserText.label: 'MfgOrderInternalID'
        @Search.defaultSearchElement: true
  key   MfgOrderInternalID,
        @EndUserText.label: 'OrderOperationInternalID'
        @Search.defaultSearchElement: true
  key   OrderOperationInternalID,
        @EndUserText.label: 'ManufacturingOrder'
        @Search.defaultSearchElement: true
  key   ManufacturingOrder,
        @EndUserText.label: 'ProductionOrderItem'
  key   ProductionOrderItem,
        @EndUserText.label: 'Product'
  key   Product,
        @EndUserText.label: 'OpenYieldQuantity'
        OpenYieldQuantity,
        @EndUserText.label: 'ManufacturingOrderOperation'
        ManufacturingOrderOperation,
        @EndUserText.label: 'Plant'
        @Search.defaultSearchElement: true
        Plant,
        @EndUserText.label: 'MfgOrderOperationText'
        MfgOrderOperationText,
        @EndUserText.label: 'OperationControlProfile'
        OperationControlProfile,
        @EndUserText.label: 'WorkCenterStandardWorkQtyUnit1'
        WorkCenterStandardWorkQtyUnit1,
        @EndUserText.label: 'WorkCenterStandardWorkQty1'
        WorkCenterStandardWorkQty1,
        @EndUserText.label: 'CostCtrActivityType1'
        CostCtrActivityType1,
        @EndUserText.label: 'WorkCenterStandardWorkQtyUnit2'
        WorkCenterStandardWorkQtyUnit2,
        @EndUserText.label: 'WorkCenterStandardWorkQty2'
        WorkCenterStandardWorkQty2,
        @EndUserText.label: 'CostCtrActivityType2'
        CostCtrActivityType2,
        @EndUserText.label: 'WorkCenterStandardWorkQtyUnit3'
        WorkCenterStandardWorkQtyUnit3,
        @EndUserText.label: 'WorkCenterStandardWorkQty3'
        WorkCenterStandardWorkQty3,
        @EndUserText.label: 'CostCtrActivityType3'
        CostCtrActivityType3,
        @EndUserText.label: 'WorkCenterStandardWorkQtyUnit4'
        WorkCenterStandardWorkQtyUnit4,
        @EndUserText.label: 'WorkCenterStandardWorkQty4'
        WorkCenterStandardWorkQty4,
        @EndUserText.label: 'CostCtrActivityType4'
        CostCtrActivityType4,
        @EndUserText.label: 'WorkCenterStandardWorkQtyUnit5'
        WorkCenterStandardWorkQtyUnit5,
        @EndUserText.label: 'WorkCenterStandardWorkQty5'
        WorkCenterStandardWorkQty5,
        @EndUserText.label: 'CostCtrActivityType5'
        CostCtrActivityType5,
        @EndUserText.label: 'WorkCenterStandardWorkQtyUnit6'
        WorkCenterStandardWorkQtyUnit6,
        @EndUserText.label: 'WorkCenterStandardWorkQty6'
        WorkCenterStandardWorkQty6,
        @EndUserText.label: 'CostCtrActivityType6'
        CostCtrActivityType6,
        @EndUserText.label: 'Plant'
        @Search.defaultSearchElement: true
        EarliestScheduledWaitStartDate
}
