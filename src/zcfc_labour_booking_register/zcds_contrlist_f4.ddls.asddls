@AbapCatalog.sqlViewName: 'Z_CONTRLIST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONTRACTOR-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CONTRLIST_F4
  as select distinct from I_Supplier as a
  
{
    key a.Supplier as Contcode,
        a.SupplierName as Contname
}
where a.SupplierAccountGroup = 'ZCNT'
