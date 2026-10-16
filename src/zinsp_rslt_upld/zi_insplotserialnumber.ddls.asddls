@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Insp. Lot Serial Numbers - Interface'
@VDM.viewType: #BASIC
define view entity ZI_InspLotSerialNumber
  as select from I_InspLotSerialNumber as Serial
  left outer join zinspc_srl_rmrks as _remarks on Serial.InspectionLot = _remarks.lot_number and Serial.SerialNumber = _remarks.serial_number
{
  key Serial.InspectionLot,
  key Serial.SerialNumber,
  _remarks.remarks as Remakrs
    
      
}
