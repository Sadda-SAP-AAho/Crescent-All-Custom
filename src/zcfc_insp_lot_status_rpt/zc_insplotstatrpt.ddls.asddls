@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Lot Status Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_INSPLOTSTATRPT
  provider contract transactional_query
  as projection on ZI_INSPLOTSTATRPT

{
      @EndUserText.label: 'Material'
  key Material,

      @EndUserText.label: 'Plant'
  key Plant,

      @EndUserText.label: 'Inspection Lot'
  key InspectionLot,

      @EndUserText.label: 'Serial Number'
  key SerialNumber,

      @UI.hidden: true
      InspectionLotQuantityUnit,

      @EndUserText.label: 'Inspection Lot Quantity'
      InspectionLotQuantity,

      @EndUserText.label: 'Actual Quantity'
      InspectionLotActualQuantity,

      @EndUserText.label: 'Defective Quantity'
      InspectionLotDefectiveQuantity,

      @EndUserText.label: 'Inspected Quantity'
      InspLotQtyInspected,

      @EndUserText.label: 'No. of Serial Numbers'
      NumberOfSerialNumbers,

      @EndUserText.label: 'Quantity to be Posted'
      InspLotQtyToBePosted,

      @EndUserText.label: 'Quantity to be Free'
      InspLotQtyToFree,

      @EndUserText.label: 'Usage Decision'
      UsageDecision,

      @EndUserText.label: 'Result Record'
      ResultRecord,
      
      @EndUserText.label: 'Recvd. in Inspection'
      RecvdInInsp,
      
      @EndUserText.label: 'Recvd. in Un-Restricted'
      RecvdInUnrestricted
}
