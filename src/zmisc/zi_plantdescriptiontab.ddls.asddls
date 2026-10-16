@EndUserText.label: 'Plant Description Table'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PlantDescriptionTab
  as select from ZDT_MM_PLANTDES
  association to parent ZI_PlantDescriptionTab_S as _PlantDescriptionAll on $projection.SingletonID = _PlantDescriptionAll.SingletonID
{
  key PLANT as Plant,
  PLANTDES as Plantdes,
  @Consumption.hidden: true
  1 as SingletonID,
  _PlantDescriptionAll
  
}
