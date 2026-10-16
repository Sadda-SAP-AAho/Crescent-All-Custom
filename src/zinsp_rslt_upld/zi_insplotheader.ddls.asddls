@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Insp. Lot Header - Interface'
@VDM.viewType: #BASIC
define view entity ZI_InspLotHeader
  as select from I_InspectionLot as Lot
 
//  left outer join ZI_InspLotExcludedStatus as ExclStatus
//    on ExclStatus.InspectionLot = Lot.InspectionLot
 
{
  key Lot.InspectionLot,
      Lot.Material,
      Lot.Plant,
      Lot.InspectionLotQuantity,
      Lot.InspectionLotQuantityUnit,
      Lot.InspectionLotType,
      Lot.InspectionLotCreatedOn
}
where
      Lot.InspectionLotType = '04'
//  and ExclStatus.InspectionLot is null
