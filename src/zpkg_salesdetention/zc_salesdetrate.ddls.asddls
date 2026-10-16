@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Detention Report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_SalesDetRate
  as projection on ZI_SalesDetRate
{
  key id,
      @EndUserText.label: 'Container Size'
      contsize,
      @EndUserText.label: 'Begin Date'
      begda,
      @EndUserText.label: 'End Date'
      endda,
      @EndUserText.label: 'From Day'
      fromday,
      @EndUserText.label: 'End Day'
      today,
      @EndUserText.label: 'Rate'
      rate
}
