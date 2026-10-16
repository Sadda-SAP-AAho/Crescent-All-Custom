@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Script Sales'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_script_sales
  as select from zi_scriptgn_hdr
{
  key    scriptno,
  key    scriptdate,
  key    currency,
         @Semantics.amount.currencyCode: 'currency'
         sum_realizationamt

}
