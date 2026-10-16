@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fright Forwarder F4'
@Metadata.allowExtensions: true
define root view entity ZI_FORWARDER_F4 
as select from I_Supplier
{
    key Supplier,
        SupplierFullName
}
