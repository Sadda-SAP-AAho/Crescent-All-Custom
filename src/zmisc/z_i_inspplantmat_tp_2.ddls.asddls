@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_I_InspPlantMatlAssgmtVersTP_2'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_I_InspPlantMat_TP_2
  provider contract transactional_query
  as projection on I_InspPlanMatlAssgmtVersTP_2
{
 
  key     Material,
  key     Plant,
  key     InspectionPlanGroup,
  key     InspectionPlan,
  key     InspPlanMatlAssignment,
  key     InspPlanMatlAssgmtIntVersion
}
