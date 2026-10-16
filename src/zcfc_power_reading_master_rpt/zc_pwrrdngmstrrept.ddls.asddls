@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Power Reading Master Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_PWRRDNGMSTRREPT
  provider contract transactional_query
  as projection on ZI_PWRRDNGMSTRREPT
{

      @EndUserText.label: 'Power Reading Master Report'
      @Search.defaultSearchElement: true

      @UI.hidden: true
  key Id,

      @UI.hidden: true
  key Item,

      @EndUserText.label: 'Document No.'
  key Docnum,

      @EndUserText.label: 'Document Date'
      Readdate,

      @EndUserText.label: 'Plant Code'
      Readloccd,

      @EndUserText.label: 'Plant Name'
      Readlocnm,

      @EndUserText.label: 'Department'
      Readdept,

      @EndUserText.label: 'Unit Rate in Rs.'
      UnitRate,

      @EndUserText.label: 'Sub Head Code'
      Subhdcd,

      @EndUserText.label: 'Sub Head Name'
      Subhdnm,

      @EndUserText.label: 'Head Code'
      Headcd,

      @EndUserText.label: 'Head Name'
      Headnm,

      @EndUserText.label: 'Meter Type'
      Metertyp,

      @EndUserText.label: 'Meter Reading'
      Meterrdng,
      
      @EndUserText.label: 'DI %'
      Diprcnt,
      
      @EndUserText.label: 'DI Units'
      DiUnits,
      
      @EndUserText.label: 'DI Amount'
      DiAmt,
      
      @EndUserText.label: 'CI %'
      Ciprcnt,
      
      @EndUserText.label: 'CI Units'
      CiUnits,
      
      @EndUserText.label: 'CI Amount'
      CiAmt,
      
      @EndUserText.label: 'Total Amount'
      TotalAmt

}
