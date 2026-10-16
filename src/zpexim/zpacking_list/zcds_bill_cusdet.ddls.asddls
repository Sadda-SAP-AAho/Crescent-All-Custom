@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for billing wise Cust Det'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_BILL_CUSDET
  as select from ZTBL_FCTN_BILL_CUSDET
{
  key BillingDocument,
  key customer,
  key pfunc,
      cusname,
      address,
      streetname,
      shipinsadd,
      country,
      countryname,
      region
}
