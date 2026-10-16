@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Insp. Lot Serial Result - Root'
@ObjectModel.semanticKey: ['InspectionLot', 'SerialNumber']
define root view entity ZR_InspLotSerialResult
  as select from ZI_InspLotSerialNumber as Serial

  inner join ZI_InspLotHeader as Header
    on Serial.InspectionLot = Header.InspectionLot
    
  left outer join ZI_InspLotExcludedStatus as status 
  on Serial.InspectionLot = status.InspectionLot  

  composition [0..*] of ZR_InspLotCharResult as _CharResult

{
  key Serial.InspectionLot,
  key Serial.SerialNumber,
      Serial.Remakrs,
      Header.Material,
      Header.Plant,
      1 as InspectionLotQuantity,
      Header.InspectionLotQuantityUnit,
      Header.InspectionLotCreatedOn,

      _CharResult
}where  status.InspectionLot  is null;
