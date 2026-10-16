@EndUserText.label: 'COD Master Table'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_CodMasterTable
  as select from zdt_mcod_tmg
  association to parent ZI_CodMasterTable_S as _CodMasterTableAll on $projection.SingletonID = _CodMasterTableAll.SingletonID
{
      @EndUserText.label: 'Country of Destination Code'
  key codcode             as Codcode,
      @EndUserText.label: 'Country of Origin Name'
      codcodenam          as Codcodenam,
      @EndUserText.label: 'Special Requirements'
      specialrequirements as Specialrequirements,
      @Consumption.hidden: true
      1                   as SingletonID,
      _CodMasterTableAll

}
