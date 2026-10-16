@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_CUSTOMER_F4_N as select distinct from I_OperationalAcctgDocItem as a
inner join I_Customer as b on a.Customer = b.Customer
{
    key a.Customer,
    b.CustomerName
}
where a.Customer is not initial
