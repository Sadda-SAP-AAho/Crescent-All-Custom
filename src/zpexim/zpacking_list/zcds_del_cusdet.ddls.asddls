@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Del. wise Cust Det'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_DEL_CUSDET
  as select from ZTBL_FCTN_DEL_CUSDET
{
  key DeliveryDocument,
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
