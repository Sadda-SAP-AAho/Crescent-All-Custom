@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Monthly Budget-Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_MONTHBUD_ITM
  as select from zdt_monthbud_itm
  association to parent ZI_MONTHBUD_HED as _Head on $projection.Id = _Head.Id
{
  key zdt_monthbud_itm.id         as Id,
  key zdt_monthbud_itm.item       as Item,
      zdt_monthbud_itm.cstcntrcd  as Cstcntrcd,
      zdt_monthbud_itm.cstcntrnam as Cstcntrnam,
      zdt_monthbud_itm.glcode     as Glcode,
      zdt_monthbud_itm.glname     as Glname,
      zdt_monthbud_itm.aprilamt   as Aprilamt,
      zdt_monthbud_itm.mayamt     as Mayamt,
      zdt_monthbud_itm.juneamt    as Juneamt,
      zdt_monthbud_itm.julyamt    as Julyamt,
      zdt_monthbud_itm.augamt     as Augamt,
      zdt_monthbud_itm.septamt    as Septamt,
      zdt_monthbud_itm.octamt     as Octamt,
      zdt_monthbud_itm.novamt     as Novamt,
      zdt_monthbud_itm.decamt     as Decamt,
      zdt_monthbud_itm.janamt     as Janamt,
      zdt_monthbud_itm.febamt     as Febamt,
      zdt_monthbud_itm.marchamt   as Marchamt,
      _Head

}
