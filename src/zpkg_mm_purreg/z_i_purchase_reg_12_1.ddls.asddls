@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM ITEM-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PURCHASE_REG_12_1
  as select from I_InspectionCodeText as insptxt
{
  key InspectionCatalog,
  key InspectionCodeGroup,
  key InspectionCode,
  key Language,
      InspectionCodeText
}
