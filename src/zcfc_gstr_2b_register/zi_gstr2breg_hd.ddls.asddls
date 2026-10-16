@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'GSTR 2B Register-Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_GSTR2BREG_HD
  as select from zdt_gstr2breg_hd
  composition [0..*] of ZI_GSTR2BREG_IT as _Item
{
  key id       as Id,
      fisyear  as Fisyear,
      docnum   as Docnum,
      keyid    as Keyid,
      creon    as Creon,
      creby    as Creby,
      location as Location,
      fyear    as Fyear,
      fmonthcd as Fmonthcd,
      fmonth   as Fmonth,
      _Item

}
