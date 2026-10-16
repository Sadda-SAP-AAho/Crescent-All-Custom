@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer View Help'
define view entity ZR_CUSTOMER_F4 
       as select distinct from I_Customer
{
    key Customer,
    key CustomerName
}
