@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 help for Profit Center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_Profit_Center_F4
  as select from I_ProfitCenterText
{
  key ltrim( ProfitCenter, '0' ) as ProfitCenter,
      ProfitCenterName
};
