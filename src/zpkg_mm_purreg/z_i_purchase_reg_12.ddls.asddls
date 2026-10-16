@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PURCHASE_REG_12
  provider contract transactional_query
  as projection on I_InspLotUsageDecisionTP_2 as insplot
{
  key InspectionLot,
      InspectionLotQualityScore,
      InspLotUsageDecisionCatalog,
      SelectedCodeSetPlant,
      InspLotUsgeDcsnSelectedSet,
      InspLotUsageDecisionCodeGroup,
      InspectionLotUsageDecisionCode,
      InspLotUsgeDcsnDynValuation,
      InspLotUsageDecisionValuation,
      InspLotUsgeDcsnFollowUpAction,
      InspectionLotUsageDecidedBy,
      InspectionLotUsageDecidedOn,
      InspLotUsageDecisionTime,
      InspLotUsageDecisionChangedBy,
      InspLotUsageDecisionChangedOn,
      InspLotUsgeDcsnChangedTime,
      InspLotUsgeDcsnHasLongText
}
