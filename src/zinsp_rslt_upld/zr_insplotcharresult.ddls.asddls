@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Insp. Lot Char. Result - Child'
define view entity ZR_InspLotCharResult
  as select from ZI_InspLotSerialCharResult as CharResult
 
  association to parent ZR_InspLotSerialResult as _SerialResult
    on  $projection.InspectionLot = _SerialResult.InspectionLot
    and $projection.SerialNumber  = _SerialResult.SerialNumber
 
{
  key CharResult.InspectionLot,
  key CharResult.SerialNumber,
  key CharResult.InspectionCharacteristic,
 
      CharResult.InspPlanOperationInternalID,
      CharResult.InspectionSpecificationText,
      CharResult.TargetValue,
      CharResult.InspSpecIsQuantitative,
      CharResult.ReportedValue,
 
      _SerialResult
}
