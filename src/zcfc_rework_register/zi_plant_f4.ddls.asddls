@AbapCatalog.sqlViewName: 'Z_PLANT_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PLANT_F4
 as select from I_Plant as a
{
  key a.Plant     as Plantcd,
   a.PlantName as Plantnm
}
where
      a.SalesOrganization =  '1000'
  and a.PlantCustomer     <> ''
