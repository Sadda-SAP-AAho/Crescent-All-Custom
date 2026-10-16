@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Serial x Characteristic - Interface'
@VDM.viewType: #BASIC
define view entity ZI_InspLotSerialCharResult
  as select from ZI_InspLotSerialNumber as Serial

  inner join ZI_InspLotCharacteristic as Charc
    on Serial.InspectionLot = Charc.InspectionLot

  left outer join I_InspectionResultValue as Result
    on  Result.InspectionLot            = Serial.InspectionLot
    and Result.InspectionCharacteristic = Charc.InspectionCharacteristic
    and Result.InspectionResultItem     = Serial.SerialNumber

{
  key Serial.InspectionLot,
  key Serial.SerialNumber,
  key Charc.InspectionCharacteristic,

      Charc.InspPlanOperationInternalID,
      Charc.InspectionSpecificationText,
      Charc.TargetValue,
      Charc.InspSpecIsQuantitative,

      case
        when Charc.InspSpecIsQuantitative = 'X'
          then cast( cast( Result.InspectionResultMeasuredValue as abap.dec( 23, 5 ) ) as abap.char( 40 ) )
        else Result.CharacteristicAttributeCode
      end as ReportedValue
}
