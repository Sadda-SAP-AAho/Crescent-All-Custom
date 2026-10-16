@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN COde CDS View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_HSN_CODE 
  as select from I_AE_CnsmpnTaxCtrlCodeTxt
{
  key ConsumptionTaxCtrlCode,
      ConsumptionTaxCtrlCodeText1
}
where Language    = 'E' and
      CountryCode = 'IN'
