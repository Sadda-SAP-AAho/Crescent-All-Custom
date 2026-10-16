@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Sales Order Customer Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SALES_CUSDET
  as select from ZTBL_FCTN_SAL_CUSDET
{
  key Salesorder,
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
