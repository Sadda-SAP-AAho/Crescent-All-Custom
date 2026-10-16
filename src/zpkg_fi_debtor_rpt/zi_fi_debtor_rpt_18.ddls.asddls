@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report- tax Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_18
  as select from ZTBL_DEBTOR_RPT_1
{
  key arinv,
      billingdocument,
      billingdocumentref
}
