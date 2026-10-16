@AbapCatalog.sqlViewName: 'ZPLANTDETAILSF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant-F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_PLANTDETAILS_F4
  as select from I_Plant as a
{
  key a.Plant     as plantcode,
      a.PlantName as plantname
}
where
      a.SalesOrganization =  '1000'
  and a.PlantCustomer     <> ''
