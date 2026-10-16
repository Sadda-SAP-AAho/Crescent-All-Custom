@AbapCatalog.sqlViewName: 'Z_PLANTDT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PLANT-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_PLANTDT_F4 as select from I_Plant as a
{
    key a.Plant as loctncd,
    key a.PlantName as loctnnam
}
where a.SalesOrganization = '1000'
and a.PlantCustomer <> ''
