@AbapCatalog.sqlViewName: 'Z_PLANTTEST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PLANT
  as select from I_Plant as a
{
  key a.Plant     as Plantcd,
   a.PlantName as Plantnm
}
where
      a.SalesOrganization =  '1000'
  and a.PlantCustomer     <> ''
