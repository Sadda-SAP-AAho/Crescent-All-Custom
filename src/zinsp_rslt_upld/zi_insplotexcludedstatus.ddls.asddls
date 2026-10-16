@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Lots with Excluded Status - Helper'
@VDM.viewType: #BASIC
define view entity ZI_InspLotExcludedStatus
  as select distinct from I_InspectionLotStatus1 as Status
{
  key Status.InspectionLot
  
}
where Status.StatusCode = 'I0218' or Status.StatusCode = 'I0224';
//      Status.StatusCode = 'I0213'
//   or Status.StatusCode = 'I0217'

