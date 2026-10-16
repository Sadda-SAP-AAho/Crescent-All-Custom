@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #MANDATORY
@EndUserText.label: 'Inspection Plan OP Char Version'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_INSPPLNOPCHARVR
  provider contract transactional_query
  as projection on I_InspPlanOpCharcVersionTP_2 as inspplnopchar

{
  key InspectionPlanGroup,
  key BOOOperationInternalID,
  key BOOCharacteristic,
  key BOOCharacteristicVersion,
  key InspectionPlan,
      IsDeleted,
      InspectionSpecification,
      InspSpecUpperLimit
}
