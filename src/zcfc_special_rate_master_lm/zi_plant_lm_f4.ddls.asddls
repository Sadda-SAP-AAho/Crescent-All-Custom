@AbapCatalog.sqlViewName: 'Z_PLANT_LM_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PLANT-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PLANT_LM_F4
 as select from I_Plant as a
{
    key a.Plant as loctncd,
    key a.PlantName as loctnnam
}
where a.SalesOrganization = '1000'
and a.PlantCustomer <> ''
