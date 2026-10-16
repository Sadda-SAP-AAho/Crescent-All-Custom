@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Status Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_RESRVSTSRPT
  provider contract transactional_query
  as projection on ZI_RESRVSTSRPT
{
      @EndUserText.label: 'Reservation'
  key Reservation,

      @EndUserText.label: 'Item'
  key ReservationItem,

      @EndUserText.label: 'Movement Type'
      MovementType,

      @EndUserText.label: 'Movement Type Text'
      MovementTypeTxt,

      @EndUserText.label: 'Requirement Date'
      ReqmntDate,

      @EndUserText.label: 'Material'
      Material,

      @EndUserText.label: 'Material Description'
      MaterialDesc,

      @EndUserText.label: 'Plant'
      Plant,

      @EndUserText.label: 'Plant Name'
      PlantName,

      @EndUserText.label: 'Storage Location'
      StorageLocation,

      @EndUserText.label: 'Storage Location Name'
      StorageLocationName,

      @EndUserText.label: 'Item Completed'
      ItmCompltd,

      @EndUserText.label: 'Item Deleted'
      ItmDeleted,

      @UI.hidden: true
      BaseUnit,

      @EndUserText.label: 'Quantity in Unit of Entry'
      QtyinUnit,

      @EndUserText.label: 'Quantity Withdrawn'
      QtyWithdrawn,

      @EndUserText.label: 'To Be Issued Qty'
      TobeIssuedQty,

      @UI.hidden: true
      MaterialBaseUnit,

      @EndUserText.label: 'Plant Stock'
      PlantStock,

      @EndUserText.label: 'G/L Code'
      GLCode,

      @EndUserText.label: 'G/L Name'
      GLName,

      @EndUserText.label: 'Cost Center'
      CostCenterCode,

      @EndUserText.label: 'Cost Center Name'
      CostCenterName,

      @EndUserText.label: 'User'
      UserID,

      @EndUserText.label: 'User Name'
      UserName
}
