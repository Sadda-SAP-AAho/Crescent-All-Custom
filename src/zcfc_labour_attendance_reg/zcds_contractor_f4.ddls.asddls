@AbapCatalog.sqlViewName: 'Z_CONTRACTOR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contractor-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CONTRACTOR_F4
  as select distinct from I_Supplier as a
  
{
    key a.Supplier as Contcode,
        a.SupplierName as Contname
}
where a.SupplierAccountGroup = 'ZCNT'
