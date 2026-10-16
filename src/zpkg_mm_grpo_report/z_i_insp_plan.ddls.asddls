@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Plan'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_INSP_PLAN 
  provider contract transactional_query
  as projection on I_InspPlanMatlAssgmtVersTP_2 as inspplan

{
  key Material,
  key Plant,
  key InspectionPlanGroup,
  key InspectionPlan,
  key InspPlanMatlAssignment,
  key InspPlanMatlAssgmtIntVersion,
      ValidityStartDate,
      ValidityEndDate,
      ChangeNumber,
      CreationDate,
      CreatedByUser,
      LastChangeDate,
      LastChangedByUser,
      IsDeleted,
      Supplier,
      Customer,
      MultipleSpecificationObject,
      MultipleSpecificationObjType,
      BOOSearchText,
      ChangedDateTime

}
