@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'POD Master Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_PODMASTERRPT
  provider contract transactional_query
  as projection on ZI_PODMASTERRPT
{
      @EndUserText.label: 'Port of Destination Code'
  key Podcode,
      @EndUserText.label: 'Container Size'
  key Contsize,
      @EndUserText.label: 'GoTrack PortCode of POD'
  key Gotrackcode,
      @EndUserText.label: 'Port of Destination Name'
      Podcodename,
      @EndUserText.label: 'Customer Code'
      Transitdays,
      @EndUserText.label: 'Gross Weight(KG)'
      Grossweight,
      @EndUserText.label: 'Net Weight(KG)'
      Netweight

}
