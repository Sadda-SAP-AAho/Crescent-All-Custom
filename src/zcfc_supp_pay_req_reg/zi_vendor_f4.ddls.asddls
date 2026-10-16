@AbapCatalog.sqlViewName: 'Z_VENDOR_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Gode F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_VENDOR_F4
  as select distinct from I_Supplier as A

{
  key A.Supplier     as VendorCode,
      A.SupplierName as VendorName
}
