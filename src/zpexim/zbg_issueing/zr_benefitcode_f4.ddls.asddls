@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Benifisary code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BENEFITCODE_F4
  as select from I_Supplier
{
  key Supplier     as Code,
      SupplierName as Name
}
union select from I_Customer
{
  key Customer     as Code,
      CustomerName as Name
}
