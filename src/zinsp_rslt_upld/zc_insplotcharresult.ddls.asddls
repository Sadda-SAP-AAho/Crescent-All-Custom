@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Insp. Lot Char. Result'
define view entity ZC_InspLotCharResult
  as projection on ZR_InspLotCharResult as CharResult
{
  key InspectionLot,
  key SerialNumber,
  key InspectionCharacteristic,

      InspPlanOperationInternalID,
      InspectionSpecificationText,
      TargetValue,
      InspSpecIsQuantitative,
      ReportedValue,

      _SerialResult : redirected to parent ZC_InspLotSerialResult
}
