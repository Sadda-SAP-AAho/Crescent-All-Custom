@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Paint BOM Master'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define root view entity ZI_PAINTBOMMSTR
  as select from zdt_paintbommstr
{
  key id         as Id,
      micron     as Micron,
      paintitmcd as Paintitmcd,
      paintitmnm as Paintitmnm,
      submicron  as Submicron,
      stdqty     as Stdqty
}
