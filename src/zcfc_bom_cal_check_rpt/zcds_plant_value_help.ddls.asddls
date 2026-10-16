@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant'
@ObjectModel.dataCategory: #VALUE_HELP

define view entity ZCDS_PLANT_VALUE_HELP
  as select distinct from I_Plant as a
{
  key a.Plant,
  key a.PlantName
}
where
      a.SalesOrganization =  '1000'
  and a.PlantCustomer     <> ''
