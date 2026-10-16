@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Power Head Master'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_PWRHDMASTER
  provider contract transactional_query
  as projection on ZI_PWRHDMASTER
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Sub Head Code'
  key Subheadcd,
      @EndUserText.label: 'Sub Head Name'
      Subheadnm,
      @EndUserText.label: 'Head Code'
      Headcd,
      @EndUserText.label: 'Head Name'
      Headnm,
      @EndUserText.label: 'Meter Type'
      Metertyp,
      @EndUserText.label: 'CI %'
      Ciprcnt,
      @EndUserText.label: 'DI %'
      Diprcnt,
      @EndUserText.label: 'MS %'
      Msprcnt,
      @EndUserText.label: 'VACUUM %'
      Vacprcnt,
      @EndUserText.label: 'BARODA %'
      Othrprcnt,
      @EndUserText.label: 'Meter Reading'
      Meterread
}
