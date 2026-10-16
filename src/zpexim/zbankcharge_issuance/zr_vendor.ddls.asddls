@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for vendor code'
define root view entity ZR_VENDOR 
as select from I_Supplier
{
    key Supplier,
        SupplierFullName
}
