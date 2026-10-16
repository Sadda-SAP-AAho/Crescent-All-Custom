@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VALUE HELP FOR PLANT'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZVH_PLANT as select from I_Plant as a
{
    key Plant as PLANT_CODE,
    PlantName as PLANT_NAME
}
where a.SalesOrganization = '1000'
and a.PlantCustomer <> ''
