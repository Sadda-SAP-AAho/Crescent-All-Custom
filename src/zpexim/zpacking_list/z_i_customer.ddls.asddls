@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Copy of I_Customer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_Customer as select from I_Customer
{
    key Customer,
    key CustomerName,
    CustomerFullName,
    BPCustomerName,
    BPCustomerFullName,
      CreatedByUser,
    CreationDate,
AddressID,

       VATRegistration,
  CustomerAccountGroup,
    AuthorizationGroup,
 DeliveryIsBlocked,
PostingIsBlocked,
    BillingIsBlockedForCustomer, 
  OrderIsBlockedForCustomer  
}
