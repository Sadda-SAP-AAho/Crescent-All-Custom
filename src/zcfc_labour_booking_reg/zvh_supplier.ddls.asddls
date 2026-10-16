@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS VIEW FOR VALUE HELP OF SUPPLIER'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZVH_SUPPLIER as select from I_Supplier
{
    
    key Supplier,
        SupplierName
    
}
