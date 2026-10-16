@EndUserText.label: 'POD Master Table'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PodMasterTable
  as select from zdt_mpod_tmg
  association to parent ZI_PodMasterTable_S as _PodMasterTableAll on $projection.SingletonID = _PodMasterTableAll.SingletonID
{
      @EndUserText.label: 'Port of Destination Code'
  key podcode     as Podcode,
      @EndUserText.label: 'Container Size'
  key contsize    as Contsize,
      @EndUserText.label: 'GoTrack PortCode of POD'
  key gotrackcode as Gotrackcode,
      @EndUserText.label: 'Port of Destination Name'
      podcodename as Podcodename,
      @EndUserText.label: 'Customer Code'
      transitdays as Transitdays,
      @EndUserText.label: 'Gross Weight(KG)'
      grossweight as Grossweight,
      @EndUserText.label: 'Net Weight(KG) '
      netweight   as Netweight,
      @Consumption.hidden: true
      1           as SingletonID,
      _PodMasterTableAll

}
