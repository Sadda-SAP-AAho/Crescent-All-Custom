@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['InspectionLot', 'SerialNumber']
@EndUserText.label: 'Insp. Lot Serial Result'
define root view entity ZC_InspLotSerialResult
  provider contract transactional_query
  as projection on ZR_InspLotSerialResult as SerialResult
{
  key InspectionLot,
  key SerialNumber,
      Remakrs,

      @Consumption.filter.mandatory: true
      Material,

      @Consumption.filter.mandatory: true
      Plant,

      InspectionLotQuantity,
      InspectionLotQuantityUnit,

      //@Consumption.filter: { selectionType: #INTERVAL, multipleSelections: true }
      @Consumption.filter: { selectionType: #INTERVAL }
      InspectionLotCreatedOn,

      _CharResult : redirected to composition child ZC_InspLotCharResult
}
