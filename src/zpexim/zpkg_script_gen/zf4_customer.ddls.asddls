@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Customer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZF4_CUSTOMER
  as select from I_Customer
{
  key Customer,
      CustomerName,
      CustomerFullName,
      BPCustomerName,
      BPCustomerFullName
}
