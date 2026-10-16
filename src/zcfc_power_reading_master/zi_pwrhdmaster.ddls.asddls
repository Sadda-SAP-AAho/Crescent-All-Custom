@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Power Head Master'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_PWRHDMASTER
  as select from zdt_pwrhdmaster
{
  key id        as Id,
  key subheadcd as Subheadcd,
      subheadnm as Subheadnm,
      headcd    as Headcd,
      headnm    as Headnm,
      metertyp  as Metertyp,
      ciprcnt   as Ciprcnt,
      diprcnt   as Diprcnt,
      msprcnt   as Msprcnt,
      vacprcnt  as Vacprcnt,
      othrprcnt as Othrprcnt,
      meterread as Meterread
}
