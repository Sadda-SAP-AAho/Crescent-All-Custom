@EndUserText.label: 'POL Master Table'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PolMasterTable
  as select from zdt_mpol_tmg
  association to parent ZI_PolMasterTable_S as _PolMasterTableAll on $projection.SingletonID = _PolMasterTableAll.SingletonID
{
  @EndUserText.label: 'Port of Loading Code'
  key polcode     as Polcode,
  @EndUserText.label: 'Port of Loading Name'
  key polcodename as Polcodename,
  @EndUserText.label: 'GoTrack Port of Loading code'
  key gotrackcode as Gotrackcode,
      @Consumption.hidden: true
      1           as SingletonID,
      _PolMasterTableAll

}
