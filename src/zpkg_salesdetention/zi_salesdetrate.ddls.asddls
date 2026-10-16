@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Detention Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SalesDetRate
  as select from zdt_salesdetrate
{
  key id,
      contsize,
      begda,
      endda,
      fromday,
      today,
      rate
}
