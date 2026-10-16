@AbapCatalog.sqlViewName: 'Z_EMPLOYEE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EMPLOYEE-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_EMPLOYEE_F4
  as select distinct from I_Supplier as a
  
{
    key a.Supplier as Empcode,
        a.SupplierName as Empname
}
where a.SupplierAccountGroup = 'ZEMP'
